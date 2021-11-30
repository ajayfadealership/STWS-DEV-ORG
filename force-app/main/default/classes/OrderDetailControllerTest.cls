@isTest
public class OrderDetailControllerTest {
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
        OrderDetailController.getRecordTypeDetail(objOrder.Id);
        OrderDetailController.getRecordType('Order');
    }

}