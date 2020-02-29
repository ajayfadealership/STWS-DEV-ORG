@isTest
private class PartsAvailabilityTriggerTest {

    static testMethod void myUnitTest() {
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = 'test';
        objInventory.Vendor__c = objManuFacturer1.Id;
        objInventory.Store_location__c = 'Other';
        insert objInventory;   
        
        Parts_Availability__c objPA = new Parts_Availability__c();
        objPA.Quantity__c = 5.0;
        objPA.Store_Location__c = 'Other';
        objPA.Inventory__c = objInventory.Id;
        insert objPA;
    }
}