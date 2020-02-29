@isTest
public class PurchaseOrderEditControllerTest {
    private static testmethod void MyTest(){
        OrderDetailController obj =  new OrderDetailController();
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Test';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
        objOrder.BOATBUILDING__Vendor_Name__c = objManuFacturer1.Id;
        insert objOrder;
        BOATBUILDING__Purchase_Order_Line_Item__c  objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
        objPOLI.BOATBUILDING__Purchase_Order__c = objOrder.Id;
        objPOLI.BOATBUILDING__Part_Number__c = 'test';
        insert objPOLI;  
        PurchaseOrderEditController objPOE = new PurchaseOrderEditController();
        PurchaseOrderEditController.getLineItems(objOrder.Id);
        
        
    }

}