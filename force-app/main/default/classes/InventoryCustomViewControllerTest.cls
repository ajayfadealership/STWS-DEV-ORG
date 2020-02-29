@isTest
private class InventoryCustomViewControllerTest {

    static testMethod void myUnitTest() {
       Test.startTest();
       BOATBUILDING__Inventory__c  objInventory = new BOATBUILDING__Inventory__c();
       objInventory.Year__c = 'years';
     //  objInventory.Status_for_Days_on_the_Lot__c = 'dsys';
       objInventory.Walkthrough__c = 'WalkThrough';
       objInventory.Underwater_lights__c = 'Underwater';
       objInventory.Transom_remote__c = 'transome';
       objInventory.Transom__c = 'transom';
       objInventory.Trailer_wheels__c= 'Trailer';
       objInventory.Trailer_VIN__c = 'trailers';
       objInventory.Tower_speakers__c = 'Tower';
      // objInventory.Status_for_Interest_Start_Date__c= 'stauts';
       objInventory.RecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
       objInventory.Surf_system__c = 'Surf';
       objInventory.Steering_wheel_controls__c = 'Steering';
       objInventory.Status__c = 'statuss';
       objInventory.Stage__c  = 'In Stock';
       objInventory.Speed_Wakeplate_levers__c = 'Speed';
       objInventory.Boat_Length_in_feets__c = 'Boast';
       objInventory.Side__c = 'side';
       objInventory.Part_Number__c = '123456';
       
       insert objInventory;
       
       ApexPages.StandardController sc = new ApexPages.StandardController(objInventory);
       InventoryCustomViewController objInventoryCustomeViewController  = new InventoryCustomViewController(sc);
       objInventoryCustomeViewController.newInventory();
       
      
      
        
    }
    
    static testMethod void myUnitTest2() {
       Test.startTest();
       BOATBUILDING__Inventory__c  objInventory = new BOATBUILDING__Inventory__c();
       objInventory.Year__c = 'years';
     //  objInventory.Status_for_Days_on_the_Lot__c = 'dsys';
       objInventory.Walkthrough__c = 'WalkThrough';
       objInventory.Underwater_lights__c = 'Underwater';
       objInventory.Transom_remote__c = 'transome';
       objInventory.Transom__c = 'transom';
       objInventory.Trailer_wheels__c= 'Trailer';
       objInventory.Trailer_VIN__c = 'trailers'; 
       objInventory.Tower_speakers__c = 'Tower';
      // objInventory.Status_for_Interest_Start_Date__c= 'stauts';
      objInventory.RecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
       objInventory.Surf_system__c = 'Surf';
       objInventory.Steering_wheel_controls__c = 'Steering';
       objInventory.Status__c = 'statuss';
       objInventory.Stage__c  = 'In Stock';
       objInventory.Speed_Wakeplate_levers__c = 'Speed';
       objInventory.Boat_Length_in_feets__c = 'Boast';
       objInventory.Side__c = 'side';
       objInventory.Part_Number__c = '123456';
       
       insert objInventory;
       
       ApexPages.StandardController sc = new ApexPages.StandardController(objInventory);
       InventoryCustomViewController objInventoryCustomeViewController  = new InventoryCustomViewController(sc);
       objInventoryCustomeViewController.recordTypeChange(); 
        objInventoryCustomeViewController.searchData();
       
      
      
        
    }
}