@isTest
public class CreateCompanyPurchaseOrderTest {
    testmethod static void TestController(){
        CreateCompanyPurchaseOrder ObjO= new CreateCompanyPurchaseOrder();
        BOATBUILDING__Manufacturer__c ObjM= new BOATBUILDING__Manufacturer__c();
        Id RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        ObjM.RecordTypeId = RecordTypeId;
        ObjM.Name= 'test';
        
        CreateCompanyPurchaseOrder.createVendor('test');
    }

}