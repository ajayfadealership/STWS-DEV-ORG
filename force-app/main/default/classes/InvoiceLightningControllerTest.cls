@isTest
public class InvoiceLightningControllerTest {
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
      
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
        objPOLIW.PartId = objInvoice.Id;
        objPOLIW.Quantity =2;
        objPOLIW.PartNumber = '12541254';
        objPOLIW.PartName = objInvoice.Name;
        objPOLIW.Cost = 20.0;
        objPOLIW.discount = 0.0;
        objPOLIW.discountPer = 2;
        objPOLIW.Total = (objPOLIW.Cost * objPOLIW.Quantity) -  objPOLIW.discount;
        objPOLIW.TotalWithoutDisc = objPOLIW.Cost * objPOLIW.Quantity;
        objPOLIW.showPill = true;
        lstPOLIW.add(objPOLIW); 
        
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Test';
        objManuFacturer1.Manufacturer_name__c = '1234';
         objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        insert objManuFacturer1;
        
         BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Bin__c = 'test';
        objPart.Part_Number__c = '12541254';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        objPart.Dealer_Price__c = 458;
        objPart.Part_Cost__c = 698;
        objPart.Category1__c = 'Parts';
        objPart.Discount__c = 54;
        objPart.Family1__c = 'Canvas';
        objPart.Location__c = 'test';
        objPart.Map_Price__c = 25;
        objPart.Minimum_Amount__c = 36;
        objPart.Part_Color__c = 'red';
        objPart.Part_Size__c = 'red';
        objPart.Taxable__c = false;
        objPart.Weight__c = 'red';
        insert objPart;
        
        
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = objPart.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        Invoice_Line_Item__c objInvLineItem = new Invoice_Line_Item__c(MSRP__c = 1000,Related_To_Invoice__c = objInvoice.Id, Part_Vendor__c = objManuFacturer1.id, Part_Number__c = 'Test',Quantity__c = 10);
        insert objInvLineItem;
        List<Invoice_Line_Item__c> lstInvLI = new List<Invoice_Line_Item__c>();
        lstInvLI.add(objInvLineItem);
        
        string strLineItem = JSON.serialize(lstPOLIW);
        InvoiceLightningController.getLineItems(objInvoice.Id);
        InvoiceLightningController.searchPartsfromInvoiceAndParts('Test');
        InvoiceLightningController.InvRecordTypeId();
        InvoiceLightningController.updateInvoicewithLineItems(objInvoice.Id,strLineItem);
        InvoiceLightningController.getSalesTaxCustomSetting();
        InvoiceLightningController.deleteInvoiceLineItem(objInvLineItem.Id);
        InvoiceLightningController.searchPartsfromInventoryAndParts('test');

    } 
    private static testmethod void MyTest2(){
        InvoiceLightningController.InvRecordTypeId();
        InvoiceLightningController.searchPartsfromInventoryAndParts('recentlyViewed');
        
    }

}