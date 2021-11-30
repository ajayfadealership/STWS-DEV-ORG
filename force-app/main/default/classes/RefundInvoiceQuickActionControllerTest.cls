@isTest
public class RefundInvoiceQuickActionControllerTest {
    testmethod static void invoiceTest(){
        
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
          BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
        if(lstInventory1Id.size() > 0){
                objInventory1.RecordTypeId = lstInventory1Id[0].Id;
        }
        objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory1.Year__c = '2016';
        objInventory1.Model__c = 'Mondo(MD)';
        objInventory1.Part_Number__c = '99999';
        objInventory1.Cost__c =10000;
        objInventory1.HIN_Number__c = 'ABCD2';
        objInventory1.Quantity__c  = 100;
        insert objInventory1;
        Invoice__c objInvoice = new Invoice__c();
        objInvoice.Name = 'Sample Test';
        objInvoice.Related_to_Contact__c = objContact.Id;
        objInvoice.BOATBUILDING__Contact_Name__c = objContact.Id;
        objInvoice.Customer_Name__c = objInvoice.Related_to_Contact__r.Name;
        objInvoice.Phone_Number__c = objInvoice.Related_to_Contact__r.Phone;
        objInvoice.Email__c = 'test@123.com';
        objInvoice.Shipping_Charge__c = 10000;
        objInvoice.Inventory__c = objInventory1.Id;
        insert objInvoice;
        BOATBUILDING__Invoice_Line_Item__c objInv = new BOATBUILDING__Invoice_Line_Item__c();
        objInv.BOATBUILDING__Related_To_Invoice__c = objInvoice.Id;
        objInv.BOATBUILDING__Inventory__c = objInventory1.Id;
        objInv.BOATBUILDING__Quantity__c = 2;
        insert objInv;
         PartInventoryManagerController obj = new PartInventoryManagerController();
        PartInventoryManagerController.PartInventoryWrapper objPIW = new PartInventoryManagerController.PartInventoryWrapper();
        RefundInvoiceQuickActionController.refundInvoice(objInvoice.Id);
        
    }

}