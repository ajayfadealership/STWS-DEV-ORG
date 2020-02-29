@isTest
public class InvoiceDetailControllerTest{
    
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
        objInvoice.Shipping_Charge__c = 10000;
        objInvoice.Inventory__c = objInventory1.Id;
        insert objInvoice;
        
        Payment__c objPayment = new Payment__c(Amount__c= 10, Payment_Type__c = 'Cash', Related_to_Invoice__c = objInvoice.Id);
        insert objPayment;
        
        Invoice_Line_Item__c objInvLineItem = new Invoice_Line_Item__c(MSRP__c = 1000,Related_To_Invoice__c = objInvoice.Id, Part_Vendor__c = objManuFacturer1.id, Part_Number__c = 'Test',Quantity__c = 10);
        insert objInvLineItem;
                
        ApexPages.currentPage().getParameters().put('id',objInvoice.Id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(objInvoice);
        
        InvoiceDetailController objCont = new InvoiceDetailController(stdController);
        Map<String, String> mapInvoiceData = new Map<String, String>();
        mapInvoiceData.put('Id',''+objInvoice.Id);
        mapInvoiceData.put('RelatedToContact',''+objContact.Id);
        mapInvoiceData.put('ShopShupplies','100');
        mapInvoiceData.put('InvoiceName','Test Inv');
        mapInvoiceData.put('City','Test');
        mapInvoiceData.put('State','Test');
        mapInvoiceData.put('Email','Test@test.com');
        mapInvoiceData.put('BillingState','Test');
        mapInvoiceData.put('Zip','Test');
        mapInvoiceData.put('PhoneNumber','123456789');
        mapInvoiceData.put('CustomerAddress','Test');
        mapInvoiceData.put('Labor','100');
        InvoiceDetailController.updateInvoice(mapInvoiceData,true);
        
        objCont.calculateAllValues();
        objCont.createBackInvoice();
        objCont.addToInventory();
        objCont.CancelInvoice();
        objCont.updateDiscount();
        objCont.ShippingUpdate();
        objCont.updateQuantity();
        objCont.deleteLIL();
        objCont.getAllLineItem();
        
        InvoiceDetailController.updateShipping('100',''+objInvoice.Id);
        InvoiceDetailController.searchParts('test');
        
        Map<String, String> mapPaymentData = new Map<String, String>();
        mapPaymentData.put('Amount','1000');
        mapPaymentData.put('PaymentType','Cash');
        mapPaymentData.put('CreditCardType','');
        mapPaymentData.put('CheckNumber','');
        InvoiceDetailController.addPayment(mapPaymentData,''+objInvoice.Id);
        List<String> lstStr = new List<String>();
        lstStr.add('99999');
        Map<String,String> objMap3 = new Map<String,String>();
        objMap3.put('99999','1');
        InvoiceDetailController.generateInvoice(lstStr, objMap3, String.valueOf(objInvoice.Id));
                
    }
}