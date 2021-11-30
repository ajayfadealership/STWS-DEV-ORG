// Trigger handler for Work order
// created by vivek on 20-5-2017
public with sharing class WorkOrderTriggerHandler {
    public static boolean checkTrgFire = false;
    public static void onBeforeInsert(List<Work_Order__c> newLstWorkOrder){
        //updateAccountOnWorkOrder(newLstWorkOrder);
    }
    
    public static void onAfterUpdate(List<Work_Order__c> newLstWorkOrder, Map<Id, Work_Order__c> oldMapWorkOrder){
        
        List<Work_Order__c> listWOToProcess = new List<Work_Order__c>();
        notifyAppOnWorkOrderUpdate(newLstWorkOrder, oldMapWorkOrder);
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
        for(Work_Order__c objWO : newLstWorkOrder){
            sendAppCallout(objWO.Id, objWO.BOATBUILDING__Boat__c);
            
        }        
    }
    public static void onAfterDelete(List<Work_Order__c> newLstWorkOrder){
        //createWONotification(newLstWorkOrder);
        for(Work_Order__c objWO : newLstWorkOrder){
            sendAppCalloutDelete(objWO.Id, objWO.BOATBUILDING__Boat__c);
        }        
    }
    
    
    public static void onBeforeUpdate(List<Work_Order__c> newLstWorkOrder, Map<Id, Work_Order__c> mapOldWO){
        //updateAccountOnWorkOrder(newLstWorkOrder);
        // for(Work_Order__c objWO : newLstWorkOrder) {
        // 	if(objWO.Status__c != null && objWO.Status__c != mapOldWO.get(objWO.Id).Status__c && objWO.Status__c == 'Closed'
        // 		&& objWO.Balance__c > 0) { 
        // 		objWO.addError('The work order can\'t be closed due to the remaining balance.')	;
        // 	}
        // }
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
    
    public static void notifyAppOnWorkOrderUpdate(List<Work_Order__c> newLstWorkOrder, Map<Id, Work_Order__c> oldMapWorkOrder){
        System.debug('in notifyAppOnWorkOrderUpdate call--');
        Id wrRID = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
        for(Work_Order__c objWO : newLstWorkOrder){
            if(oldMapWorkOrder.containsKey(objWO.Id)){
                if(oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c != objWO.BOATBUILDING__Status__c
                   || oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Part_description__c != objWO.BOATBUILDING__Part_description__c
                   || oldMapWorkOrder.get(objWO.Id).Name != objWO.Name
                   || oldMapWorkOrder.get(objWO.Id).RecordTypeId != objWO.RecordTypeId || objWO.RecordTypeId == wrRID){
                       System.debug('in future call--');
                       sendAppCallout(objWO.Id, objWO.BOATBUILDING__Boat__c); 
                   } 
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
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
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
    @future(callout = true)
    public static void sendAppCalloutDelete(Id newWorkOrderId, Id boatId){
        
        BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
        System.debug('------------WOID FM--------'+newWorkOrderId+'------@'+boatId);
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', objConfig.BOATBUILDING__AppOrgId__c);
        mapRequestBody.put('workorder_id', newWorkOrderId);
        mapRequestBody.put('boat_id', boatId);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
        req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/workOrder/delete');
        req.setMethod('DELETE');
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

    public static void onBeforeDelete(Map<Id, Work_Order__c> oldMap) {
        deleteWOJLineItem(oldMap.keySet());
    }

    public static void deleteWOJLineItem(Set<Id> woId) {
        try {
            System.debug('deleteWOJLineItem: '); 
            List<Work_Order_Job_Line_Item__c> lstWOJLI =  [SELECT Id FROM BOATBUILDING__Work_Order_Job_Line_Item__c 
                                                            WHERE BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c IN :woId 
                                                                AND BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c != 'Quote'];
            if( !lstWOJLI.isEmpty() ) {
                System.debug('deleteWOJLineItem: '+lstWOJLI); 
                delete lstWOJLI;
            }
        } catch(Exception ex) {
            System.debug('onBeforeDelete: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Work Order';
                String customLog = 'onBeforeDelete : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }

    public static void updateInventoryQuantity(List<Work_Order__c > lstWorkorder , map<Id,Work_Order__c> oldMapWorkOrder) {
        try {
            System.debug('updateInventoryQuantity :');
            Map<String, Boolean> mapDeduct = new Map<String, Boolean>();
            Map<Id, String> mapNewStoreLocation = new Map<Id, String>();
            Map<Id, String> mapOldStoreLocation = new Map<Id, String>();
            for(Work_Order__c objWO : lstWorkorder) {
                if(objWO.BOATBUILDING__Status__c != null && objWO.BOATBUILDING__Status__c != 'Quote' &&
                    (oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c == null || oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c != null 
                        && oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c == 'Quote') ) {
                        mapDeduct.put(objWO.Id, true);
                } else if(objWO.BOATBUILDING__Status__c != null && objWO.BOATBUILDING__Status__c == 'Quote' &&
                    (oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c == null || 
                        oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c != null && oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Status__c != 'Quote' )) {
                        mapDeduct.put(objWO.Id, false);
                }
                if(objWO.BOATBUILDING__Status__c != 'Quote' && objWO.BOATBUILDING__Store_Location__c != oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Store_Location__c) {
                    mapNewStoreLocation.put(objWO.Id, objWO.BOATBUILDING__Store_Location__c);
                    mapOldStoreLocation.put(objWO.Id, oldMapWorkOrder.get(objWO.Id).BOATBUILDING__Store_Location__c);
                }
            }
            System.debug('mapNewStoreLocation :'+mapNewStoreLocation);
            System.debug('mapOldStoreLocation :'+mapOldStoreLocation);
            if(!mapDeduct.isEmpty()) {
                List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJobLineItem = [SELECT Id, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c 
                                                                            FROM BOATBUILDING__Work_Order_Job_Line_Item__c WHERE BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c IN :mapDeduct.keySet()];
                Map<String, Decimal> mapJLIQuantity = new Map<String, Decimal>();
                Map<String, String> mapStoreLocation = new Map<String, String>();
                for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI : lstJobLineItem) {
                    Decimal decQuantity = mapJLIQuantity.get(objJLI.BOATBUILDING__Part_Number__c);
                    if(decQuantity == null) {
                        decQuantity = 0;
                    }
                    if(mapDeduct.get(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c)) {
                        decQuantity += objJLI.BOATBUILDING__Quantity__c;
                    } else {
                        decQuantity += 0 - objJLI.BOATBUILDING__Quantity__c;
                    }
                    System.debug('objJLI.BOATBUILDING__Quantity__c :'+objJLI.BOATBUILDING__Quantity__c);
                    mapJLIQuantity.put(objJLI.BOATBUILDING__Part_Number__c, decQuantity);
                    if(!mapStoreLocation.containsKey(objJLI.BOATBUILDING__Part_Number__c)) {
                            mapStoreLocation.put(objJLI.BOATBUILDING__Part_Number__c, objJLI.BOATBUILDING__Store_Location__c);
                    }
                }
                System.debug('mapJLIQuantity :'+mapJLIQuantity);
                List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                                FROM BOATBUILDING__Inventory__c 
                                                                WHERE BOATBUILDING__Part_Number__c IN: mapJLIQuantity.keySet()];
                List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
                for(BOATBUILDING__Inventory__c objInv : listInvToQuery) {
                    PartInventoryManagerController.PartInventoryWrapper objPW = new PartInventoryManagerController.PartInventoryWrapper();
                    objPW.inventoryId = objInv.Id;
                    objPW.quantity = mapJLIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                    objPW.storeLocation = mapStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                    listWrapToProcess.add(objPW);
                }
                PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
            }
            if(!mapNewStoreLocation.isEmpty()) {
                List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJobLineItem = [SELECT Id, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c 
                                                                            FROM BOATBUILDING__Work_Order_Job_Line_Item__c WHERE BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c IN :mapNewStoreLocation.keySet()];
                Map<String, Decimal> mapJLIQuantity = new Map<String, Decimal>();
                Map<String, String> mapILINewStoreLocation = new Map<String, String>();
                Map<String, String> mapILIOldStoreLocation = new Map<String, String>();
                for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI : lstJobLineItem) {
                    mapJLIQuantity.put(objJLI.BOATBUILDING__Part_Number__c, objJLI.BOATBUILDING__Quantity__c);
                    mapILINewStoreLocation.put(objJLI.BOATBUILDING__Part_Number__c, mapNewStoreLocation.get(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c));
                    mapILIOldStoreLocation.put(objJLI.BOATBUILDING__Part_Number__c, mapOldStoreLocation.get(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c));
                }
                System.debug('mapILINewStoreLocation :'+mapILINewStoreLocation);
                System.debug('mapILIOldStoreLocation :'+mapILIOldStoreLocation);
                List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                                    FROM BOATBUILDING__Inventory__c 
                                                                    WHERE BOATBUILDING__Part_Number__c IN: mapJLIQuantity.keySet()];

                List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
                for(BOATBUILDING__Inventory__c objInv : listInvToQuery) {
                    PartInventoryManagerController.PartInventoryWrapper objPWNew = new PartInventoryManagerController.PartInventoryWrapper();
                    objPWNew.inventoryId = objInv.Id;
                    objPWNew.quantity = mapJLIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                    objPWNew.storeLocation = mapILINewStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                    listWrapToProcess.add(objPWNew);
    
                    PartInventoryManagerController.PartInventoryWrapper objPWOld = new PartInventoryManagerController.PartInventoryWrapper();
                    objPWOld.inventoryId = objInv.Id;
                    objPWOld.quantity = 0 - mapJLIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                    objPWOld.storeLocation = mapILIOldStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                    listWrapToProcess.add(objPWOld);
                }
                PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
            }
            
        } catch(Exception ex) {
            System.debug('onAfterUpdate: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Work Order';
                String customLog = 'onAfterUpdate : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }
}