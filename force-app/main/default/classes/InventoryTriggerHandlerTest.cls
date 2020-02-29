@isTest
private class InventoryTriggerHandlerTest {

    static testMethod void myUnitTest1() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__InventoryTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManufacturer1.Model_Variant__c = false;
        insert objManuFacturer1;
        
        BOATBUILDING__Product__c objProduct = new BOATBUILDING__Product__c();
        objProduct.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct.M_Year__c = '2016';  
        objProduct.MModel2__c = 'Hexa'; 
        insert objProduct;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
        if(lstInventory1Id.size() > 0){
                objInventory1.RecordTypeId = lstInventory1Id[0].Id;
        }
        objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory1.Year__c = '2016';
        objInventory1.Model__c = 'Mondo(MD)';
        objInventory1.Part_Number__c = '99999';
        objInventory1.Cost__c =10000;
        objInventory1.HIN_Number__c = 'ABCD2';
        insert objInventory1;
        
                    
    }
    static testMethod void myUnitTest2() {
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManufacturer1.Model_Variant__c = false;
        insert objManuFacturer1;
        
        BOATBUILDING__Product__c objProduct = new BOATBUILDING__Product__c();
        objProduct.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct.M_Year__c = '2016';  
        objProduct.MModel2__c = 'Hexa'; 
        insert objProduct;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Name = 'Sample Item';
        objItem.Boat_HIN_No__c = 'ABCD';
        insert objItem;
        
        map<ID,BOATBUILDING__Inventory__c> MapId = new map<ID,BOATBUILDING__Inventory__c>();
        list< BOATBUILDING__Inventory__c> listIN =  new list< BOATBUILDING__Inventory__c>();
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
        if(lstInventory1Id.size() > 0){
                objInventory1.RecordTypeId = lstInventory1Id[0].Id;
        }
        objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory1.Year__c = '2016';
        objInventory1.Model__c = 'Mondo(MD)';
        objInventory1.Part_Number__c = '99999';
        objInventory1.Cost__c =10000;
        objInventory1.HIN_Number__c = 'ABCD2';
        MapId.put(objInventory1.Id,objInventory1);
        
        listIN.add(objInventory1);
        insert listIN;
       
        Task objtask = new Task();
      
     
        
        InventoryTriggerHandler.onAfterInsert(listIN);
        InventoryTriggerHandler.isAfterUpdate(listIN,MapId,MapId);
        InventoryTriggerHandler.updatePartLookupOnInventory(listIN);
       // InventoryTriggerHandler.createTask('other',objInventory1.Id,);
        InventoryTriggerHandler.shootMailForInvUpate(listIN);
        InventoryTriggerHandler.shootMailForInvUpateAU(MapId,MapId);
        InventoryTriggerHandler.sendBoatRiggingNotification(listIN,MapId);
        InventoryTriggerHandler.createCustomerBoatValidation(listIN,MapId);
        InventoryTriggerHandler.updateInventoryQuantityFromParts(listIN);
        InventoryTriggerHandler.isBeforeUpdate(listIN,MapId);
    }
    
}