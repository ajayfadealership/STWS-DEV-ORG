@isTest
public class CalculatePriceOnInvoiceTriggerTest {
    static testmethod void myUnitTest() {
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
        
        objInvoiceLineItem.Quantity__c = 10;
        objInvoiceLineItem.Refunded__c = true;
        objInvoiceLineItem.Refunded_Amount__c = 1;
        update objInvoiceLineItem;
        
        delete objInvoiceLineItem;
        
    }
    
        static testmethod void myUnitTest2() {
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
        insert objInvoice;
        
         list<BOATBUILDING__Invoice_Line_Item__c>  lstILI = new list<BOATBUILDING__Invoice_Line_Item__c>();  
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
        objInvoiceLineItem.Refunded__c = true;
        objInvoiceLineItem.Refunded_Amount__c = 0;
        lstILI.add(objInvoiceLineItem);
        insert lstILI;
        
        objInvoiceLineItem.Quantity__c = 10;
        update objInvoiceLineItem;
        
        BOATBUILDING__Invoice_Line_Item__c objInvoiceLineItem1 = new BOATBUILDING__Invoice_Line_Item__c();
        objInvoiceLineItem1.Name ='Line Item for Sample Test';
        objInvoiceLineItem1.Part_Number__c = '1234';
        objInvoiceLineItem1.Part_Vendor__c = objManuFacturer1.Id;
        objInvoiceLineItem1.Description__c = 'Sample Text Description';
        objInvoiceLineItem1.Quantity__c = 2;
        objInvoiceLineItem1.Taxable__c = true;
        objInvoiceLineItem1.MSRP__c = 1000.00;
        objInvoiceLineItem1.Part_Cost__c = 100.00;
        objInvoiceLineItem1.Related_To_Invoice__c = objInvoice.Id;
        objInvoiceLineItem1.Refunded__c = true;
        objInvoiceLineItem1.Refunded_Amount__c = 0;
        insert objInvoiceLineItem1;
        
        delete objInvoiceLineItem;
        CalculatePriceOnInvoiceTriggerHandler.onInsert(lstILI);
        CalculatePriceOnInvoiceTriggerHandler.onUpdate(lstILI);
         CalculatePriceOnInvoiceTriggerHandler.onDelete(lstILI);
    }

}