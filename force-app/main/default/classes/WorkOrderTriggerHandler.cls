// Trigger handler for Work order
// created by vivek on 20-5-2017
public with sharing class WorkOrderTriggerHandler {
    public static boolean checkTrgFire = false;
    public static void onBeforeInsert(List<Work_Order__c> newLstWorkOrder){
        //updateAccountOnWorkOrder(newLstWorkOrder);
    }
    
    public static void onAfterUpdate(List<Work_Order__c> newLstWorkOrder, Map<Id, Work_Order__c> oldMapWorkOrder){
        
        List<Work_Order__c> listWOToProcess = new List<Work_Order__c>();
        notifyAppOnWorkOrderUpdate(newLstWorkOrder);
        for(Work_Order__c wo: newLstWorkOrder){
            //Work order getting closed
            if(wo.BOATBUILDING__Status__c == 'Closed' && oldMapWorkOrder.get(wo.Id).BOATBUILDING__Status__c != 'Closed'){
                listWOToProcess.add(wo);
            }
        }
        
        if(!listWOToProcess.isEmpty() && runOnce()){
            Boolean isEnableClosedWONotification = BOATBUILDING__System_Config__c.getOrgDefaults().BOATBUILDING__Enable_closed_WO_Notification__c;
            if(isEnableClosedWONotification){
                closedWOSalesNotification(listWOToProcess);
            }
        }
    }
    
    public static void onAfterInsert(List<Work_Order__c> newLstWorkOrder){
        createWONotification(newLstWorkOrder);
        notifyAppOnWorkOrderUpdate(newLstWorkOrder);
    }
    
    /****Code addedby Pradeep on 9thSept 2017 ***/
    public static void onBeforeUpdate(List<Work_Order__c> newLstWorkOrder){
        //updateAccountOnWorkOrder(newLstWorkOrder);
        
    } 
    /*****Code ended*****/
    
    public Static Void updateAccountOnWorkOrder(list<BOATBUILDING__Work_Order__c> lstWorkOrder){
        
        Set<Id> setContactIds = new Set<Id>();
        
        for(BOATBUILDING__Work_Order__c objWO : lstWorkOrder){
            if(objWO.BOATBUILDING__Account__c == null)
                setContactIds.add(objWO.BOATBUILDING__Contact__c);
        }
        System.debug('==setContactIds=='+setContactIds);
        Map<Id, Contact> mapContactToAccount = new Map<Id, Contact>();
        if(setContactIds != null && setContactIds.size()>0){
            for(Contact objCon : [SELECT id,AccountId,Email, Phone from Contact where ID IN : setContactIds]){
                mapContactToAccount.put(objCon.Id, objCon);
            }
            
            if(lstWorkOrder.isEmpty()){
                for(BOATBUILDING__Work_Order__c objWO : lstWorkOrder){
                    objWO.BOATBUILDING__Account__c = mapContactToAccount.get(objWO.BOATBUILDING__Contact__c).AccountId;
                    objWO.BOATBUILDING__ContactEmail__c = mapContactToAccount.get(objWO.BOATBUILDING__Contact__c).Email;
                    objWO.BOATBUILDING__ContactPhone__c = mapContactToAccount.get(objWO.BOATBUILDING__Contact__c).Phone;
                }
            }
        }
    }
    
    // Closed WO Notification for Sales Team
    public static void closedWOSalesNotification(List<Work_Order__c> newLstWorkOrder){
        
        Map<String, List<Work_Order__c>> mapCustomerTypeToWorkOrder = new Map<String, List<Work_Order__c>>();
        
        for(Work_Order__c WO : newLstWorkOrder){
            if(wo.BOATBUILDING__Status__c == 'Closed'){
                if(mapCustomerTypeToWorkOrder.containsKey(WO.BOATBUILDING__Account_Customer_Type__c)){
                    List<Work_Order__c> listWO = mapCustomerTypeToWorkOrder.get(WO.BOATBUILDING__Account_Customer_Type__c);
                    listWO.add(WO);
                    mapCustomerTypeToWorkOrder.put(WO.BOATBUILDING__Account_Customer_Type__c, listWO);
                } else{
                    mapCustomerTypeToWorkOrder.put(WO.BOATBUILDING__Account_Customer_Type__c, new List<Work_Order__c> {WO});
                }
            }
        }
        
        //Get All Emails from Custom Setting
        Map<String, BOATBUILDING__ExternalNotificationEmail__c> mapCustomerTypeToExternalEmail = BOATBUILDING__ExternalNotificationEmail__c.getAll();
        List<String> toAddress = new List<String>();
        List<String> ccAddress = new List<String>();
        
        for(String strCustType: mapCustomerTypeToWorkOrder.keySet()){
            
            for(Work_Order__c wo: mapCustomerTypeToWorkOrder.get(strCustType)){
                
                //Get Customer Type User Emails from Custom Setting
                if(mapCustomerTypeToExternalEmail.containsKey(strCustType)){
                    String toAddresseEmails = mapCustomerTypeToExternalEmail.get(strCustType).BOATBUILDING__Email__c;
                    if(toAddresseEmails.containsIgnoreCase(',')){
                        List<String> listToAddress = toAddresseEmails.split(',');
                        toAddress.addAll(listToAddress);
                    } else {
                        toAddress.add(toAddresseEmails);
                    }                    
                }
                
                String workOrderlink = System.URL.getSalesforceBaseUrl()+'/'+wo.Id;
                String htmlBody = 'Hi, <br/><br/> We have Closed this Work Order <br/> <a target="_blank" href = "'+workOrderlink+'">';
                htmlBody += wo.Name+'<a/> <br/><br/>Please reach out to the customer and keep the relationship going on.';
                htmlBody += '<br/><br/>Thanks.';
                String subject = 'Work Order is Closed '+wo.Name;
                sendEmailwithWOPdf(toAddress, ccAddress, htmlBody, subject, wo.Id);
                //createTask('Work Order is Closed', wo.Id, setSalesUserId);
            }
        }
    }
    
    // Create Work Order notification
    public static void createWONotification(List<Work_Order__c> newLstWorkOrder){
        
        Map<String, List<Work_Order__c>> mapCustomerTypeToWorkOrder = new Map<String, List<Work_Order__c>>();
        
        for(Work_Order__c WO : newLstWorkOrder){
            if(mapCustomerTypeToWorkOrder.containsKey(WO.BOATBUILDING__Account_Customer_Type__c)){
                List<Work_Order__c> listWO = mapCustomerTypeToWorkOrder.get(WO.BOATBUILDING__Account_Customer_Type__c);
                listWO.add(WO);
                mapCustomerTypeToWorkOrder.put(WO.BOATBUILDING__Account_Customer_Type__c, listWO);
            } else{
                mapCustomerTypeToWorkOrder.put(WO.BOATBUILDING__Account_Customer_Type__c, new List<Work_Order__c> {WO});
            }
        }
        
        /*Fetch Associated Job
List<BOATBUILDING__Work_Order_Job__c> listWOJobs = [SELECT Id, BOATBUILDING__Job_Name__c, BOATBUILDING__Work_Order_Warranty_Work_Order__c 
FROM BOATBUILDING__Work_Order_Job__c 
WHERE BOATBUILDING__Work_Order_Warranty_Work_Order__c IN: mapCustomerTypeToWorkOrder];

Map<String, List<BOATBUILDING__Work_Order_Job__c>> mapWoToJobList = new Map<String, List<BOATBUILDING__Work_Order_Job__c>>();
for(BOATBUILDING__Work_Order_Job__c job: listWOJobs){
if(mapWoToJobList.containsKey(job.BOATBUILDING__Work_Order_Warranty_Work_Order__c)){
List<BOATBUILDING__Work_Order_Job__c> listWOJ = mapWoToJobList.get(job.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
listWOJ.add(job);
mapWoToJobList.put(job.BOATBUILDING__Work_Order_Warranty_Work_Order__c, listWOJ);
} else{
mapWoToJobList.put(job.BOATBUILDING__Work_Order_Warranty_Work_Order__c, new List<BOATBUILDING__Work_Order_Job__c> {job});
}
}*/
        
        //Get All Emails from Custom Setting
        Map<String, BOATBUILDING__ExternalNotificationEmail__c> mapCustomerTypeToExternalEmail = BOATBUILDING__ExternalNotificationEmail__c.getAll();
        List<String> toAddress = new List<String>();
        List<String> ccAddress = new List<String>();
        
        /*for(String strCustType: mapCustomerTypeToWorkOrder.keySet()){

for(Work_Order__c wo: mapCustomerTypeToWorkOrder.get(strCustType)){

//Get Customer Type User Emails from Custom Setting
if(mapCustomerTypeToExternalEmail.containsKey(strCustType)){
toAddress.add(mapCustomerTypeToExternalEmail.get(strCustType).BOATBUILDING__Email__c);
}

String workOrderlink = System.URL.getSalesforceBaseUrl()+'/'+wo.Id;
String htmlBody = 'Hi, <br/><br/> A MasterCraft Customer just dropped their Boat off for Service <br/> ';
for(Integer i = 1; i<= mapWoToJobList.get(wo.Id).size(); i++){
htmlBody += 'Job '+i+':'+mapWoToJobList.get(wo.Id).get(i);
}
htmlBody += '<br/><br/>Thanks.';
String subject = 'New Work Order Created '+wo.Name;
sendEmailwithWOPdf(toAddress, ccAddress, htmlBody, subject, wo.Id);
//createTask('Work Order is Closed', wo.Id, setSalesUserId);
}
}*/
        
        for(String strCustType: mapCustomerTypeToWorkOrder.keySet()){
            
            for(Work_Order__c wo: mapCustomerTypeToWorkOrder.get(strCustType)){
                
                //Get Customer Type User Emails from Custom Setting
                if(mapCustomerTypeToExternalEmail.containsKey(strCustType)){
                    String toAddresseEmails = mapCustomerTypeToExternalEmail.get(strCustType).BOATBUILDING__Email__c;
                    if(toAddresseEmails.containsIgnoreCase(',')){
                        List<String> listToAddress = toAddresseEmails.split(',');
                        toAddress.addAll(listToAddress);
                    } else {
                        toAddress.add(toAddresseEmails);
                    } 
                }
                
                String workOrderlink = System.URL.getSalesforceBaseUrl()+'/'+wo.Id;
                String htmlBody = 'Hi, <br/><br/> A MasterCraft Customer just dropped their Boat off for Service <br/> <a target="_blank" href = "'+workOrderlink+'">';
                htmlBody += wo.Name+'<br/><br/>Thanks.';
                String subject = 'New Work Order is Created '+wo.Name;
                sendEmailwithWOPdf(toAddress, ccAddress, htmlBody, subject, wo.Id);
            }
        }
    }
    
    public static void createTask(String subject, Id parentId, Set<String> setOwnerIds){
        
        List<Task> listTask = new List<Task>();
        
        for(String uId: setOwnerIds){
            Task objTask = new Task();
            objTask.Subject = subject;
            objTask.WhatId = parentId;
            objTask.OwnerId = uId;
            listTask.add(objTask);
        }
        System.debug('listTask---'+listTask);
        if(!listTask.isEmpty()){
            insert listTask;
        }
    }
    
    @future(callout = true)
    public static void sendEmailwithWOPdf(List<String> toAddress, List<String> ccAddress, String htmlBody, String subject, String woId){
        
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        
        PageReference myPdf = new PageReference('/apex/CasePDFPageClone2?id='+woId);
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        efa.setFileName('Work Order.Pdf');
        efa.setBody(myPdf.getContentAsPdf());
        fileAttachments.add(efa);
        
        SendEmailUtility.sendEmailwithAttachment(toAddress,ccAddress,htmlBody,subject,fileAttachments);
    }
    
    public static void notifyAppOnWorkOrderUpdate(List<Work_Order__c> newLstWorkOrder){
        
        for(Work_Order__c objWO : newLstWorkOrder){
            if(objWO.LastModifiedDate < DateTime.now().addMinutes(-2)){
                sendAppCallout(objWO.Id, objWO.BOATBUILDING__Boat__c);
            }
        }
    }
    
    @future(callout = true)
    public static void sendAppCallout(Id newWorkOrderId, Id boatId){
        
        BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
        System.debug('------------WOID FM--------'+newWorkOrderId+'------@'+boatId);
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', objConfig.BOATBUILDING__AppOrgId__c);
        mapRequestBody.put('workorder_id', newWorkOrderId);
        mapRequestBody.put('boat_id', boatId);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY2NGNmY2JlMGUyZWYyZTQxMTJlMjgzYjdmZjkzZmU2NmVhNjg0ZDA4MmNiOTVkNGMxNWZkYThmMWZlMWQzM2M5ZjVlMmFkMjk5YmVlMTVkIn0.eyJhdWQiOiIxIiwianRpIjoiNjY0Y2ZjYmUwZTJlZjJlNDExMmUyODNiN2ZmOTNmZTY2ZWE2ODRkMDgyY2I5NWQ0YzE1ZmRhOGYxZmUxZDMzYzlmNWUyYWQyOTliZWUxNWQiLCJpYXQiOjE1Njg3MzkyODMsIm5iZiI6MTU2ODczOTI4MywiZXhwIjoxNjAwMzYxNjgzLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.JHS6FrIzQ9WnTu7q5L88cMs9nAWegs3-a1wWP7YFqIRAyPMPv8BS6Ms05gQLSOrcg_bOpVkc4Qht8ZEtHBxDHO-Puf-XbDm6-IQ3oTiYwYl5pL4eGKYEDAaXD5xncukV7kh0DzaQIcTL7uZ0zeahMGO-SldjGlJ81wEuFK2zas6q0uEotaF8LqasBw7a-N35Zq6Fk78A39PLmIFjpBq4RatZrP8UJB8EZMxjjWzbjG7MFDIazuAlVB8ehBtVaZk3J6B6JoWURldO_ESvkw2ZdNKZ-rPf4obvsTe9FbhoKOoLCiWBIwVu2QYAzw8anH-wWKGDN4_04DFqUFui0h15wJMUpr2gPaY-K5EO3gjxOntdCuaW5BZJG6NTZEFcS-bgcg01OkfHxO2-MqHIbETeNJ4xlh2oRt9E6bMYGUSI3jKEJRStqHyHbW_lvqcLfX82nEGvlj-N6s76FteRtOzcvKZAQFladwepPB3HJjt2LZLeaF_s_ehJ4Q71zJ5TjTBRPFzXVwpOG62ZFjh3SFxOtxYU36nuKTAwjzaaARGb9wN3FQWDpjTzG3Frn_A4fZUIWSCknBqJrsGmB4qlzvINLzIWsIjsK5QdZ9nw432K4B0-GlXgkVkykSckwlwLsemPel6dAcUI_9wMlbBKgZY0yUR43SK6P9pypNZtsIeoXi8');
        req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/workOrder/update');
        req.setMethod('POST');
        String body = JSON.serialize(mapRequestBody);
        req.setBody(body);
        System.debug('APP req---'+req);
        System.debug('APP body---'+body);
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('APP res---'+res);
        }
    }
    
    public static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}