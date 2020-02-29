@isTest
private class SendInvoiceDetailPageControllerTest {

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
        
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        List<RecordType> lstRecType = [SELECT
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Manufacturer__c'
                                        AND
                                                Name = 'Vendor'
                                                
                                    ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
        
        Invoice__c objInvoice = new Invoice__c();
        List<RecordType> lstRecTypeInvoice = [SELECT
                                                            Id
                                                    FROM
                                                            RecordType
                                                    WHERE
                                                            SobjectType = 'Invoice__c'
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
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        insert attach; 
        
        ApexPages.currentPage().getParameters().put('Id',objInvoice.id);
        SendInvoiceDetailPageController objSendInvoiceDetailPageController = new SendInvoiceDetailPageController();
        objSendInvoiceDetailPageController.sendInvoice();
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
        
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        List<RecordType> lstRecType = [SELECT
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Manufacturer__c'
                                        AND
                                                Name = 'Vendor'
                                                
                                    ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
        
        Invoice__c objInvoice = new Invoice__c();
         List<RecordType> lstRecTypeInvoice = [SELECT
                                                            Id
                                                    FROM
                                                            RecordType
                                                    WHERE
                                                            SobjectType = 'Invoice__c'
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
        
        ApexPages.currentPage().getParameters().put('Id',objInvoice.id);
        SendInvoiceDetailPageController objSendInvoiceDetailPageController = new SendInvoiceDetailPageController();
        objSendInvoiceDetailPageController.sendInvoice();
    }
}