@isTest
public class RefundProcessFromILIControllerTest {
    public static testMethod void method1() {
        Test.startTest() ;
            
            Account objAccount = new Account();
            objAccount.Name = 'Test Account';
            insert objAccount;
            
            Contact objContact = new Contact();
            objContact.FirstName = 'Test';
            objContact.LastName = 'Contact';
            objContact.AccountId = objAccount.Id;
            objContact.MailingState = 'Sample City';
            insert objContact;
            
            Invoice__c objInvoice = new  Invoice__c() ;
            objInvoice.Related_to_Contact__c = objContact.Id;
            objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
            objInvoice.Customer_Name__c = 'Test Customer' ;
            objInvoice.Phone_Number__c = '7896541230' ;
            objInvoice.Email__c = 'abc@gmail.com' ;
            objInvoice.Customer_Address__c = 'Test Address' ;
            objInvoice.City__c = 'Test City' ;
            objInvoice.State__c = 'Test State' ;
            objInvoice.Zip_Code__c = 'Test ZipCode' ;
            insert objInvoice ;
            
            RecordType objRecType = [select Id,Name from RecordType where Name = 'Vendor'] ;
            
            Manufacturer__c objManufacturer = new Manufacturer__c () ;
            objManufacturer.Name = 'Test Manufacturer' ;
            objManufacturer.Manufacturer_name__c = 'Man12345' ;
            objManufacturer.RecordTypeId = objRecType.Id ;
            insert objManufacturer ;
            
            Invoice_Line_Item__c objILI = new Invoice_Line_Item__c() ;
            objILI.Name = 'Test Line Item' ;
            objILI.Description__c = 'Test Description' ;
            objILI.Discount_Price__c = 100 ;
            objILI.MSRP__c = 100 ;
            objILI.Part_Cost__c = 100 ;
            objILI.Part_Number__c = 'Test Part Number' ;
            objILI.Part_Vendor__c = objManufacturer.Id ;
            objILI.Quantity__c = 1 ;
            objILI.Related_To_Invoice__c = objInvoice.Id ;
            objILI.Taxable__c = true ;
            objILI.Weight__c = '100' ;
            insert objILI ;
            
            Inventory__c objInventory = new Inventory__c() ;
            objInventory.Status__c = 'Test Status' ;
            objInventory.Part_Number__c = 'Test Part Number' ;
            objInventory.Quantity__c = 1 ;
            insert objInventory ;
            
            ApexPages.currentPage().getParameters().put('Id',objILI.Id) ;
            RefundProcessFromILIController objController = new RefundProcessFromILIController() ;
            RefundProcessFromILIController.refundInvoiceLineItem(objILI.Id , '1000') ;
        Test.stopTest() ;
    }
    public static testMethod void method2() {
        RefundProcessFromILIController objController = new RefundProcessFromILIController() ;
    }
}