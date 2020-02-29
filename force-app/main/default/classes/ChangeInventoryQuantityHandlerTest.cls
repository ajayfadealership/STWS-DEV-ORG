@isTest
public class ChangeInventoryQuantityHandlerTest {
    static testmethod void myUnitTest() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__ChangeInventoryQuantityCheckBox__c= true;
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
        
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType> lstInventoryRT = [SELECT           
                                                    Id
                                            FROM    
                                                    RecordType
                                            WHERE       
                                                    DeveloperName = 'Inventory_for_Parts'
                                            AND
                                                    SobjectType = 'BOATBUILDING__Inventory__c'
                                            LIMIT 
                                                    1];
        if(lstInventoryRT.size() > 0){
            objInventory1.RecordTypeId = lstInventoryRT[0].Id;
        }
        objInventory1.Vendor__c = objManuFacturer1.Id;
        objInventory1.Part_Number__c = '1234';
        objInventory1.Description__c = 'Sample Text Description';
        objInventory1.Quantity__c = 10;
        objInventory1.Part_Name__c = 'Line Item for Sample Test';
        objInventory1.Part_MSRP_Price__c = 1000.00;
        insert objInventory1;
        
        
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
        objInvoice.Invoice_Status__c = 'Active';
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
        
        objInvoice.Invoice_Status__c = 'Cancelled';
        update objInvoice;
        
        objInvoice.Invoice_Status__c = 'Active';
        update objInvoice;
        
    }
    
    static testmethod void myUnitTest2(){
    
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
        if(lstInventory1Id.size() > 0){
            objInventory1.RecordTypeId = lstInventory1Id[0].Id;
        }
         //objInventory1.RecordTypeId = recIdInventory;
        objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory1.Year__c = '2016';
        objInventory1.Model__c = 'Mondo(MD)';
        objInventory1.Part_Number__c = '99999';
        objInventory1.Cost__c =10000;
        objInventory1.Quantity__c = 2;
        insert objInventory1;
        
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        List<RecordType> lstSoldBoatInvoice = [SELECT 
                                                        Id 
                                               FROM 
                                                        RecordType 
                                               WHERE 
                                                        SobjectType = 'BOATBUILDING__Invoice__c' 
                                               AND 
                                                        DeveloperName = 'Sold_Boat_Invoice'

                                                        limit 1];
        if(lstSoldBoatInvoice.size() > 0){
            objInvoice.RecordTypeId = lstSoldBoatInvoice[0].Id;
        }
        
        objInvoice.Name = 'Sample Test';
        objInvoice.Inventory__c = objInventory1.Id;
        objInvoice.Invoice_Status__c = 'Active';
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        insert objInvoice;
        
        objInvoice.Invoice_Status__c = 'Cancelled';
        update objInvoice;
        
        objInvoice.Invoice_Status__c = 'Active';
        update objInvoice;

    }
}