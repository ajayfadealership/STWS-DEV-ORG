@isTest
private class GenerateCasePDFCloneTest {
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
        objWork.Contact__c = con.Id;
        Id RecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        objWork.RecordTypeId = RecordTypeId;
        objWork.BOATBUILDING__Store_Location__c = 'Other';
        insert objWork;
        ApexPages.currentPage().getParameters().put('id',objWork.Id);
        GenerateCasePDFClone objGC =  new GenerateCasePDFClone();
        objGC.checkAccess();
        objGC.backToService();
        objGC.saveCaseasPDF();
        objGC.saveAndSendCase();
       
        
    }}