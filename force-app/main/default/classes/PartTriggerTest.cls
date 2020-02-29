@isTest
private class PartTriggerTest {
    
    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        map<Id,BOATBUILDING__Part__c> MapPart = new map<Id,BOATBUILDING__Part__c>();
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Part_Number__c = 'avsfd';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        objPart.BOATBUILDING__Category1__c = 'Boat Parts';
        objPart.BOATBUILDING__Part_Cost__c = 700;
        objPart.Add_Inventory__c = true;
        MapPart.put(objPart.Id,objPart);
        insert objPart;
        
        List<BOATBUILDING__Part__c> lstPart = new List<BOATBUILDING__Part__c>();
        lstPart.add(objPart);
        
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.Part_Name__c = 'Test Part';
        objInventory.Part_Number__c = 'avsfd';
        objInventory.Vendor__c = objManuFacturer1.Id;
        objInventory.Quantity__c=8;
        List<RecordType> lstRecInv = [Select Id From RecordType Where DeveloperName = 'Inventory_for_Parts' And SobjectType = 'BOATBUILDING__Inventory__c'];
        if(lstRecInv.size() > 0) {
            objInventory.RecordTypeId = lstRecInv[0].Id;
        }
        insert objInventory;
        
        objPart.Retail_Price__c = 223;
        update objPart;
        PartTriggerHandler.onAfterUpdate(MapPart,MapPart);
        PartTriggerHandler.updateInventoryFromPart(MapPart);
        PartTriggerHandler.onAfterInsert(lstPart);
    }
}