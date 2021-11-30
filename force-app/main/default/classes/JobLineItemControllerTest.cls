@isTest
public class JobLineItemControllerTest {
    private static testmethod void myTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory for Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = 'dfvdsgsgv';
        objInventory.Vendor__c = objManuFacturer1.Id;
        objInventory.BOATBUILDING__Part_MSRP_Price__c = 11;
        insert objInventory;
        JobLineItemController.searchPartsfromInventoryAndParts('recentlyViewed');
    }

}