@isTest
public class ApproveFromOrderControllerCloneTest {
    public static testMethod void method1() {
        Test.startTest() ;
        
        RecordType objRecType = [select Id,Name from RecordType where SobjectType = 'BOATBUILDING__Manufacturer__c' AND Name = 'Vendor'] ;
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c () ;
        objManufacturer.Name = 'Test Manufacturer' ;
        objManufacturer.Manufacturer_name__c = 'Man12345' ;
        objManufacturer.RecordTypeId = objRecType.Id ;
        insert objManufacturer ;
        
        RecordType objRecType1 = [select Id,Name from RecordType where SobjectType = 'BOATBUILDING__Order__c' AND Name = 'Purchase Order'] ;
        BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c() ;
        objOrder.Vendor_Name__c = objManufacturer.Id ;
        objOrder.Total_Amount__c = 1000 ;
        objOrder.PO_Date__c = Date.today() ;
        objOrder.Amount_On_Order__c = 1000 ;
        objOrder.RecordTypeId = objRecType1.Id ;
        insert objOrder ;
        
        BOATBUILDING__Purchase_Order_Line_Item__c objPOLineItem = new BOATBUILDING__Purchase_Order_Line_Item__c() ;
        objPOLineItem.Cost__c = 1000 ;
        objPOLineItem.Name = 'Test Line item' ;
        objPOLineItem.Dealer_Price__c = 1000 ;
        objPOLineItem.Retail_Price__c = 1000 ;
        objPOLineItem.Vendor_Name__c = objManufacturer.Id ;
        objPOLineItem.Quantity__c = 1 ;
        objPOLineItem.Part_Number__c = 'Test Part number' ;
        objPOLineItem.Weight__c = '100' ;
        objPOLineItem.Purchase_Order__c =  objOrder.Id ;
        insert objPOLineItem ;
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Part_Number__c = 'avsfd';
        objPart.Vendor_Name__c = objManuFacturer.Id;
        objPart.Retail_Price__c = 23;
        insert objPart;
        ApexPages.StandardController sc = new ApexPages.StandardController(objOrder);
        ApexPages.currentPage().getParameters().put('Id',objOrder.Id) ;
        ApproveFromOrderController_Clone objController = new ApproveFromOrderController_Clone(sc) ; 
        objController.createOrder(); 
        ApexPages.currentPage().getParameters().put('Id',objOrder.Id) ;
        //objController.refreshLineItem();
        objController.editPOApex();
        objController.getVendorInfoApex();
        objController.updatePOApex();
        objController.updateQuantityApex();
        ApproveFromOrderController_Clone.searchParts('a');
        List<String> lst = new List<String>();
        lst.add('avsfd');
        Map<String, String> mp = new Map<String, String>();
        mp.put('avsfd','1');
        
        ApproveFromOrderController_Clone.updateLIonOrder(lst,mp,objOrder.Id);
        Test.stopTest() ;
    }
}