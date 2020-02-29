@isTest
private class GenerateInvoiceControllerTest {
    
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
        
        BOATBUILDING__Service_Module_Tax_Rates__c objRecord1 = new BOATBUILDING__Service_Module_Tax_Rates__c();
        objRecord1.Name = 'Sample City';
        objRecord1.Tax__c = 10.25;
        insert objRecord1;
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        List<RecordType> lstRecType = [SELECT
                                       Id
                                       FROM
                                       RecordType
                                       WHERE
                                       sObjectType = 'BOATBUILDING__Manufacturer__c'
                                       AND
                                       Name = 'Vendor'
                                       
                                      ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
        
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        List<RecordType> lstRecTypeInvoice = [SELECT
                                              Id
                                              FROM
                                              RecordType
                                              WHERE
                                              SobjectType = 'BOATBUILDING__Invoice__c'
                                              AND
                                              DeveloperName = 'Standard_Invoice'
                                              LIMIT
                                              1];
        if(lstRecTypeInvoice.size()>0) {
            objInvoice.RecordTypeId = lstRecTypeInvoice[0].Id;
        }
        objInvoice.Name = 'Sample Test';
        objInvoice.Related_to_Contact__c = objContact.Id;
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice.Customer_Name__c = objInvoice.Related_to_Contact__r.Name;
        objInvoice.Phone_Number__c = objInvoice.Related_to_Contact__r.Phone;
        objInvoice.Email__c = 'test@123.com';
        insert objInvoice;
        
        BOATBUILDING__Invoice_Line_Item__c objInvoiceLineItem = new BOATBUILDING__Invoice_Line_Item__c();
        objInvoiceLineItem.Name ='Line Item for Sample Test';
        objInvoiceLineItem.Part_Number__c = '1234';
        objInvoiceLineItem.Part_Vendor__c = objManuFacturer1.Id;
        objInvoiceLineItem.Description__c = 'Sample Text Description';
        objInvoiceLineItem.Quantity__c = 2;
        objInvoiceLineItem.Taxable__c = true;
        objInvoiceLineItem.MSRP__c = 1000.00;
        objInvoiceLineItem.Part_Cost__c = 100.00;
        objInvoiceLineItem.Related_To_Invoice__c = objInvoice.Id;
        insert objInvoiceLineItem;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        insert attach; 
        
        apexpages.currentpage().getparameters().put('Id' , objInvoice.Id);
        apexpages.currentpage().getparameters().put('strSubject' , '');
        apexpages.currentpage().getparameters().put('strBody' , '');
        apexpages.currentpage().getparameters().put('strCC' , '');
        GenerateInvoiceController objGenerateInvoiceController = new GenerateInvoiceController();
        Pagereference pf1 = objGenerateInvoiceController.saveQuoteasPDF();
        Pagereference pf2 = objGenerateInvoiceController.saveAndSendInvoice();
    }
    
    static testMethod void myUnitTest2() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
        BOATBUILDING__Service_Module_Tax_Rates__c objRecord1 = new BOATBUILDING__Service_Module_Tax_Rates__c();
        objRecord1.Name = 'Sample City';
        objRecord1.Tax__c = 10.25;
        insert objRecord1;
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        List<RecordType> lstRecType = [SELECT
                                       Id
                                       FROM
                                       RecordType
                                       WHERE
                                       sObjectType = 'BOATBUILDING__Manufacturer__c'
                                       AND
                                       Name = 'Vendor'
                                       
                                      ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
        
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        List<RecordType> lstRecTypeInvoice = [SELECT
                                              Id
                                              FROM
                                              RecordType
                                              WHERE
                                              SobjectType = 'BOATBUILDING__Invoice__c'
                                              AND
                                              DeveloperName = 'Standard_Invoice'
                                              LIMIT
                                              1];
        if(lstRecTypeInvoice.size()>0) {
            objInvoice.RecordTypeId = lstRecTypeInvoice[0].Id;
        }
        objInvoice.Name = 'Sample Test';
        objInvoice.Related_to_Contact__c = objContact.Id;
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice.Customer_Name__c = objInvoice.Related_to_Contact__r.Name;
        objInvoice.Phone_Number__c = objInvoice.Related_to_Contact__r.Phone;
        objInvoice.Email__c = 'test@123.com';
        insert objInvoice;
        
        BOATBUILDING__Invoice_Line_Item__c objInvoiceLineItem = new BOATBUILDING__Invoice_Line_Item__c();
        objInvoiceLineItem.Name ='Line Item for Sample Test';
        objInvoiceLineItem.Part_Number__c = '1234';
        objInvoiceLineItem.Part_Vendor__c = objManuFacturer1.Id;
        objInvoiceLineItem.Description__c = 'Sample Text Description';
        objInvoiceLineItem.Quantity__c = 2;
        objInvoiceLineItem.Taxable__c = true;
        objInvoiceLineItem.MSRP__c = 1000.00;
        objInvoiceLineItem.Part_Cost__c = 100.00;
        objInvoiceLineItem.Related_To_Invoice__c = objInvoice.Id;
        insert objInvoiceLineItem;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        insert attach; 
        
        apexpages.currentpage().getparameters().put('Id' , objInvoice.Id);
        apexpages.currentpage().getparameters().put('strSubject' , 'Sample Text');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Text');
        apexpages.currentpage().getparameters().put('strCC' , 'abc@xyz.com');
        GenerateInvoiceController objGenerateInvoiceController = new GenerateInvoiceController();
        //objGenerateInvoiceController.myAttchId = attach.Id;
        Pagereference pf1 = objGenerateInvoiceController.saveQuoteasPDF();
        Pagereference pf2 = objGenerateInvoiceController.saveAndSendInvoice();
    }
}