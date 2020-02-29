@isTest
public class InventoryControllerTest{
    static testMethod void unitTest(){
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
        insert objInventory;
       
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        insert objOrder;
        
        Line_Items__c objLI = new Line_Items__c();
        objLI.Quantity__c = 1;
        objLI.Part_Number_del__c = '25412';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        insert objLI ;
       
        Map<String,String> objMap = new Map<String,String>();
        objMap.put('vendor',string.valueOf(objManuFacturer1.Id));
        objMap.put('MSRP','25');
        objMap.put('InvPartWeight','test');
        objMap.put('Quantity','2');
        objMap.put('Description','test1');
        objMap.put('PartNumber','123456');
        objMap.put('MapPrice','254');
        objMap.put('Discount','52');
        objMap.put('Size','large');
        objMap.put('Category','Parts');
        objMap.put('Family','Canvas');
        objMap.put('Color','red');
        objMap.put('Cost','365');
        objMap.put('MinAmount','214');
        objMap.put('inventoryLocation','test');
        
        InventoryController objInventoryController = new InventoryController();
        InventoryController.saveInventory(objMap);
        InventoryController.getInvList();
        
    }
}