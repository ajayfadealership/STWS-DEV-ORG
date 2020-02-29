@isTest
private class PaymentTriggerHandlerTest {
    @testSetup static void setup(){
        
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__PaymentTriggerCheckBox__c= true;
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
        
        BOATBUILDING__Invoice__c objInvoice1 = new BOATBUILDING__Invoice__c();
        objInvoice1.Name = 'Invoice Test';
        objInvoice1.Related_to_Contact__c = objContact.Id;
        objInvoice1.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice1.BOATBUILDING__QBInvoiceID__c  = '101';
        insert objInvoice1;

        BOATBUILDING__Payment__c objPayment = new BOATBUILDING__Payment__c();
        objPayment.Name = 'Test Payment';
        objPayment.BOATBUILDING__Payment_Type__c = 'Cash';
        objPayment.BOATBUILDING__Related_to_Invoice__c = objInvoice1.id; 
        objPayment.BOATBUILDING__Amount__c = 0.00;
        Insert objPayment;
    }
    
   

}