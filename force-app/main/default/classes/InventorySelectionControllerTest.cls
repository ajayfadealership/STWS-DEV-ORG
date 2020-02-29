@isTest
public class InventorySelectionControllerTest {
    testmethod static void TestController(){
        
        BOATBUILDING__Inventory__c ObjInv= new BOATBUILDING__Inventory__c();
        ObjInv.BOATBUILDING__Manufacturer__c='jhdd';
        ObjInv.BOATBUILDING__Model__c='efgge';
        ObjInv.BOATBUILDING__Model_Variant__c='vcng';
        ObjInv.BOATBUILDING__Year__c='fff';
        ObjInv.BOATBUILDING__Stage__c='Ordered';  
        Id newBoatRecordtypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
        ObjInv.RecordtypeId= newBoatRecordtypeId;
        insert ObjInv;    
        InventorySelectionController.getInvList(ObjInv.BOATBUILDING__Model__c);

       
        
        
        
        
    }
    
}