@isTest
private class InvoiceTriggerTest {
    private testmethod static void unitTest1() {
        
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__InvoiceTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
        list<BOATBUILDING__Invoice__c> lstIn = new list<BOATBUILDING__Invoice__c>();
        map<Id,BOATBUILDING__Invoice__c> mapInv = new map<Id,BOATBUILDING__Invoice__c>();
        BOATBUILDING__Invoice__c objInvoice1 = new BOATBUILDING__Invoice__c();
        objInvoice1.Name = 'Invoice Test';
        objInvoice1.Related_to_Contact__c = objContact.Id;
        objInvoice1.BOATBUILDING__Contact_Name__c = objContact.Id;
        mapInv.put(objInvoice1.Id,objInvoice1);
        lstIn.add(objInvoice1);
        insert lstIn;
        InvoiceHandlerClass.onAfterInsert(lstIn);
        //InvoiceHandlerClass.onAfterUpdate(lstIn,mapInv);
        InvoiceHandlerClass.updateAccountOnInvoice(lstIn);
        InvoiceHandlerClass.createQBInvoice(lstIn,mapInv);
      //  InvoiceHandlerClass.generateInvoiceJson(objInvoice1,'12244657gjhg');
        InvoiceHandlerClass.generateJournalEntryJson(objInvoice1,'12244657gjhg');
        InvoiceHandlerClass.updateSoldByDetailsOnInventory(lstIn,mapInv);
        
      

      
    }
}