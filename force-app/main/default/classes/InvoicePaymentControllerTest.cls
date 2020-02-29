@isTest
public class InvoicePaymentControllerTest {
    private static testmethod void MyTest(){
         Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact; 
        
        Invoice__c objInvoice = new Invoice__c();
        objInvoice.Name = 'Test';
        objInvoice.Related_to_Contact__c = objContact.Id;
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice.Customer_Name__c = objInvoice.Related_to_Contact__r.Name;
        objInvoice.Phone_Number__c = objInvoice.Related_to_Contact__r.Phone;
        objInvoice.Email__c = 'test@123.com';
        objInvoice.Shipping_Charge__c = 10000;
        insert objInvoice;
        InvoicePaymentController.getPaymentURLInfo(objInvoice.Id);
        InvoicePaymentController.getType(objInvoice.Id);
        
        
        
    }

}