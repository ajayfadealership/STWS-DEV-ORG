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
        BOATBUILDING__EndPointURL__c objEndP = new BOATBUILDING__EndPointURL__c();
        objEndP.Name = 'test name';
        objEndP.BOATBUILDING__URL__c = 'https://stws-dev-org-dev-ed.my.salesforce.com/';
        insert objEndP;
        
        Invoice__c objInvoice = new Invoice__c();
        objInvoice.Name = 'Test';
        objInvoice.Related_to_Contact__c = objContact.Id;
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice.Customer_Name__c = objInvoice.Related_to_Contact__r.Name;
        objInvoice.Phone_Number__c = objInvoice.Related_to_Contact__r.Phone;
        objInvoice.Email__c = 'test@123.com';
        objInvoice.Shipping_Charge__c = 10000;
        insert objInvoice;
        InvoicePaymentController objInv = new InvoicePaymentController();
        InvoicePaymentController.getPaymentURLInfo(objInvoice.Id);
        InvoicePaymentController.getType(objInvoice.Id);
     //   InvoicePaymentController.getPaymentURLInfoWO(objInvoice.Id);        
        
        
    }
     private static testmethod void MyTest2(){
         BOATBUILDING__Work_Order__c  objWO = new BOATBUILDING__Work_Order__c();
         insert objWO;
         InvoicePaymentController.getPaymentURLInfoWO(objWO.Id);
         InvoicePaymentController.getType(objWO.Id);
        }
        

}