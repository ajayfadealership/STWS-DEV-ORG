@isTest
private class GenerateOrderControllerTest {
    static testMethod void myUnitTest() {
       
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
        BOATBUILDING__Manufacturer__c objManu = new BOATBUILDING__Manufacturer__c();
        objManu.BOATBUILDING__Manufacturer_name__c = 'test';
        Id RecordTypeIdManu = Schema.SObjectType.BOATBUILDING__Manufacturer__c .getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        objManu.recordtypeid = RecordTypeIdManu;
        
        
        insert objManu;
        
        BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
        objOrder.BOATBUILDING__Vendor_Name__c = objManu.Id;
      
        ApexPages.currentPage().getParameters().put('Id',objOrder.id);
         insert objOrder;
         GenerateOrderController objGOC = new GenerateOrderController();

    }}