public class WorkOrderJobTriggerHandler 
{
    public static Boolean PREVENT_WORK_ORDER_JOB_TRIGGER = false;
    public static void AfterUpdateInsert(List<Work_Order_Job__c> newLstWorkOrder){
        Set<Id> setWorkOrderJobId = new Set<Id>();
        for(Work_Order_Job__c objWO : newLstWorkOrder)
        {
         setWorkOrderJobId.add(objWO.Id);   
        }
        List<Work_Order_Job__c> WorkOrderJobList = [Select Id, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c from Work_Order_Job__c where Id IN : setWorkOrderJobId];
        for(Work_Order_Job__c objWO2 : WorkOrderJobList)
        {
             sendAppCallout(objWO2.Work_Order_Warranty_Work_Order__c, objWO2.Id, objWO2.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c);
        }
    }
    public static void onBeforeDelete(Map<Id, Work_Order_Job__c> newMapWorkOrder){
        Set<Id> setWorkOrderJobId = new Set<Id>(); 
        for(Work_Order_Job__c objWO : newMapWorkOrder.values())
        {
         setWorkOrderJobId.add(objWO.Id);   
        }
        List<Work_Order_Job__c> WorkOrderJobList = [Select Id, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c from Work_Order_Job__c where Id IN : setWorkOrderJobId];
        for(Work_Order_Job__c objWO2 : WorkOrderJobList)
        {
            sendAppCalloutDelete(objWO2.Work_Order_Warranty_Work_Order__c, objWO2.Id, objWO2.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c);
        }
        deleteWOJLineItem(newMapWorkOrder.keySet());
    }
    public static void deleteWOJLineItem(Set<Id> setJobId) {
        try {
            System.debug('deleteWOJLineItem: '); 
            List<Work_Order_Job_Line_Item__c> lstWOJLI =  [SELECT Id, BOATBUILDING__Select_Part__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Quantity__c FROM BOATBUILDING__Work_Order_Job_Line_Item__c 
                                                            WHERE BOATBUILDING__Related_to_Job__c IN :setJobId 
                                                                AND BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c != 'Quote'];
            if( !lstWOJLI.isEmpty() ) {
                JLITriggerHandler.updateInventoryQuantity(lstWOJLI, null);
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
    @future(callout = true)
    public static void sendAppCallout(Id newWorkOrderId, Id newWorkOrderjobId, Id boatId){
        BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
        System.debug('------------WOID FM--------'+newWorkOrderId+'------@'+boatId);
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', objConfig.BOATBUILDING__AppOrgId__c);
        mapRequestBody.put('workorder_id', newWorkOrderId);
        mapRequestBody.put('workorder_job_id', newWorkOrderjobId);
        mapRequestBody.put('boat_id', boatId);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
        req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/workOrder/job/update');
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
    public static void sendAppCalloutDelete(Id newWorkOrderId, Id newWorkOrderjobId, Id boatId){
        BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
        System.debug('------------WOID FM--------'+newWorkOrderId+'------@'+boatId);
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', objConfig.BOATBUILDING__AppOrgId__c);
        mapRequestBody.put('workorder_id', newWorkOrderId);
        mapRequestBody.put('workorder_job_id', newWorkOrderjobId);
        mapRequestBody.put('boat_id', boatId); 
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
        req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/workOrder/job/delete');
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
}