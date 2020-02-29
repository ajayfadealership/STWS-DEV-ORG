@isTest
private class WorkOrderControllerCloneTest {
    
    static testMethod void myUnitTest() {
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test Con';
        con.LastName = 'Last Test Con';
        con.AccountId = acc.id;
        insert con;
        
        WorkOrderControllerClone objClone = new WorkOrderControllerClone();
        BOATBUILDING__Work_Order__c objWork = new BOATBUILDING__Work_Order__c();
        Id RecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        objWork.RecordTypeId = RecordTypeId;
        objWork.BOATBUILDING__Store_Location__c = 'Other';
        insert objWork;
        Map<String, String> MyMap = new map<String, String>();
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Boat_HIN_No__c = '12321456';
        objItem.Engine_SN__c = 'dfs456s46s'; 
        objItem.Trailer_VIN__c = '456dfs46df';
        objItem.Boat_Model__c = 'Test Model';
        objItem.M_Boat_Year__c = '2017';
        insert objItem;
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        insert objJob;
        BOATBUILDING__Work_Order__c objOrder = new BOATBUILDING__Work_Order__c();
        insert objOrder;
        
        
        WorkOrderControllerClone.getWOWholeList();
        objClone.getWorkOrderList();
        WorkOrderControllerClone.getContact(con.Id ,'Other');
        WorkOrderControllerClone.getSalesTax('Other');
        WorkOrderControllerClone.fetchItemsWo(objItem.Id);
        WorkOrderControllerClone.PopulatePartNumber();
        WorkOrderControllerClone.getDetailsOfJob(objJob.Id);
        WorkOrderControllerClone.createWorkOrder('some json');
        WorkOrderControllerClone.fetchWorkOrder(objOrder.Id);
        WorkOrderControllerClone.removeFromExistingWO(objJob.Id);
        //WorkOrderControllerClone.addPayment(MyMap ,objOrder.Id);
        WorkOrderPhotoPreviewCtrl.getWOPhotoFiles(objOrder.Id);
        
       
    }
}