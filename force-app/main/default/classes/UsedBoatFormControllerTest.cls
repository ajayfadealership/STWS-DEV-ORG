@isTest
private class UsedBoatFormControllerTest {
    
    static testMethod void myUnitTest() {
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        String recIdNew1 = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'].Id;
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        objProductPriceForSelectedCategory.RecordTypeId = recIdNew1;
        objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bimini Top';
        insert objProductPriceForSelectedCategory;
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Manufacturer_name__c = '12345';
        objManufacturer.Name = 'Skiers Choice(Moomba)';
        insert objManufacturer;
        List<SelectOption> lstManufacture = new List<SelectOption>();
        UsedBoatFormController objUsedBoatFormController = new UsedBoatFormController();
        Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
        objUsedBoatFormController.mapSelectedCategory = mapSelectedCategory;
        List<BOATBUILDING__Inventory_Line_Item__c> lstInventoryLineItem = new List<BOATBUILDING__Inventory_Line_Item__c>();
        objUsedBoatFormController.selectedManufacture = 'Skiers Choice(Moomba)';
        objUsedBoatFormController.lstManufacture = new List<SelectOption>();
        objUsedBoatFormController.selectedOptionString = 'Bimini Top';  
        objUsedBoatFormController.selectedOptionCategory = 'Bimini Top';
        objUsedBoatFormController.selectedYear = '2016';
        objUsedBoatFormController.rowNumber = '1';
        BOATBUILDING__Dealer_Option__c objDealer = new BOATBUILDING__Dealer_Option__c();
        objDealer.BOATBUILDING__Part_Number__c = 'test';
        ObjDealer.Name = 'test';
        insert objDealer;
        
        
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        objInventory1.Vehicle_Type__c = 'Runabout';
        objInventory1.Model__c = 'Test Model';
        objInventory1.Boat_Type__c = 'Inboard';
        objInventory1.Hull_Material__c = 'Wood';
        objInventory1.Engine__c = 'Sample';
        objInventory1.Net_Weight__c = 100.22;
        objInventory1.Suggested_List_Price__c = 20000;
        objInventory1.Cost__c = 15000;
        objInventory1.ACV__c = 10000;
        objInventory1.Date_on_FloorPlan__c = System.Today();
        objInventory1.Costline__c = 10;
        objInventory1.Hull_ID__c = 'ABC123';
        objInventory1.Trailer_ID__c ='XYZ456';
        objInventory1.Engine_SN__c = '111111';
        objInventory1.Interest_Start_Date__c = System.Today();
        objInventory1.Curtailment_Start_Date__c = System.Today();
        objInventory1.UsedBoatStatus__c  = 'Service';
        objInventory1.Location__c = 'Showroom';
        objInventory1.Dealer_Prep__c = 10000;
        objInventory1.Owner__c = 'Dealership';
        objInventory1.Part_Number__c = '123456';
        objUsedBoatFormController.objInventory = objInventory1;
        BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
        objILI.Name = 'Bimini Top';
        objILI.Name__c = 'Bimini Top';
        objILI.Option_Category__c = 'Bimini Top';
        objILI.Price__c = 10000;
        objILI.Dealer_Price__c = 200;
        lstInventoryLineItem.add(objILI);
        objUsedBoatFormController.lstInventoryLineItem = lstInventoryLineItem;
        Pagereference pf =objUsedBoatFormController.createBoat(); 
        objUsedBoatFormController.updateDealerOptionList();
        
        BOATBUILDING__ACV_Form__c objForm = new BOATBUILDING__ACV_Form__c();
        objForm.BOATBUILDING__Contact_Name__c = objContact.Id;
        objForm.BOATBUILDING__High_Comp_1_Amount__c = 1;
        objForm.BOATBUILDING__High_Comp_2_Amount__c = 12;
        objForm.BOATBUILDING__High_Comp_3_Amount__c = 123;
        objForm.BOATBUILDING__Low_Comp_1_Amount__c = 1234;
        objForm.BOATBUILDING__Low_Comp_2_Amount__c = 12345;
        insert objForm;
        apexpages.currentpage().getparameters().put('acvId',objForm.Id);
        //objUsedBoatFormController.getDeleteDealerOptionPriceSub();
        
    }
    
    static testMethod void myUnitTest2() {
        //String recIdNew1 = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'].Id;
        
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
        
        if(lstRT.size() > 0){
            objProductPriceForSelectedCategory.RecordTypeId = lstRT[0].Id;
            
        }
        //objProductPriceForSelectedCategory.RecordTypeId = recIdNew1;
        objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bimini Top';
        insert objProductPriceForSelectedCategory;
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Manufacturer_name__c = '12345';
        objManufacturer.Name = 'Skiers Choice(Moomba)';
        insert objManufacturer;
        UsedBoatFormController objUsedBoatFormController = new UsedBoatFormController();
        List<SelectOption> lstManufacture = new List<SelectOption>();
        Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
        objUsedBoatFormController.mapSelectedCategory = mapSelectedCategory;List<BOATBUILDING__Inventory_Line_Item__c> lstInventoryLineItem = new List<BOATBUILDING__Inventory_Line_Item__c>();
        objUsedBoatFormController.selectedManufacture = 'Skiers Choice(Moomba)';
        objUsedBoatFormController.lstManufacture = new List<SelectOption>();
        objUsedBoatFormController.selectedOptionString = 'Bimini Top';
        objUsedBoatFormController.selectedOptionCategory = 'Bimini Top';
        objUsedBoatFormController.selectedYear = '2016';
        objUsedBoatFormController.rowNumber = '1';
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        objInventory1.Vehicle_Type__c = 'Runabout';
        objInventory1.Model__c = 'Test Model';
        objInventory1.Boat_Type__c = 'Inboard';
        objInventory1.Hull_Material__c = 'Wood';
        objInventory1.Engine__c = 'Sample';
        objInventory1.Net_Weight__c = 100.22;
        objInventory1.Suggested_List_Price__c = 20000;
        objInventory1.Cost__c = 15000;
        objInventory1.ACV__c = 10000;
        objInventory1.Date_on_FloorPlan__c = System.Today();
        objInventory1.Costline__c = 10;
        objInventory1.Hull_ID__c = 'ABC123';
        objInventory1.Trailer_ID__c ='XYZ456';
        objInventory1.Engine_SN__c = '111111';
        objInventory1.Interest_Start_Date__c = System.Today();
        objInventory1.Curtailment_Start_Date__c = System.Today();
        objInventory1.UsedBoatStatus__c  = 'Service';
        objInventory1.Location__c = 'Showroom';
        objInventory1.Dealer_Prep__c = 10000;
        objInventory1.Owner__c = 'Dealership';
        objInventory1.Part_Number__c = '123456';
        insert objInventory1;
        BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
        objILI.Name = 'Bimini Top';
        objILI.Name__c = 'Bimini Top';
        objILI.Option_Category__c = 'Bimini Top';
        objILI.Price__c = 10000;
        objILI.Dealer_Price__c = 200;
        objILI.Related_to_Inventory__c = objInventory1.Id;
        insert objILI;
        lstInventoryLineItem.add(objILI);
        objUsedBoatFormController.objInventory = objInventory1;
        objUsedBoatFormController.lstInventoryLineItem = lstInventoryLineItem;
        Pagereference pf =objUsedBoatFormController.createBoat();
        System.debug('>>>>>>>>>>>>>>>>mapSelectedCategory'+mapSelectedCategory.size());
        objUsedBoatFormController.getMFGPrice();
        objUsedBoatFormController.getMFGPriceSubtrct();
    }
    
    static testMethod void myUnitTest3() {
        //String recIdNew1 = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'].Id;
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
        
        if(lstRT.size() > 0){
            objProductPriceForSelectedCategory.RecordTypeId = lstRT[0].Id;
            
        }
        //objProductPriceForSelectedCategory.RecordTypeId = recIdNew1;
        objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bimini Top';
        insert objProductPriceForSelectedCategory;
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Manufacturer_name__c = '12345';
        objManufacturer.Name = 'Skiers Choice(Moomba)';
        insert objManufacturer;
        UsedBoatFormController objUsedBoatFormController = new UsedBoatFormController();
        List<BOATBUILDING__Inventory_Line_Item__c> lstInventoryLineItem = new List<BOATBUILDING__Inventory_Line_Item__c>();
        List<SelectOption> lstManufacture = new List<SelectOption>();
        Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
        objUsedBoatFormController.mapSelectedCategory = mapSelectedCategory;//public List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
        objUsedBoatFormController.selectedManufacture = 'Skiers Choice(Moomba)';
        objUsedBoatFormController.lstManufacture = new List<SelectOption>();
        objUsedBoatFormController.selectedOptionString = 'Bimini Top';
        objUsedBoatFormController.selectedOptionCategory = 'Bimini Top';
        objUsedBoatFormController.selectedYear = '2016';
        objUsedBoatFormController.rowNumber = '1';
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        objInventory1.Vehicle_Type__c = 'Runabout';
        objInventory1.Model__c = 'Test Model';
        objInventory1.Boat_Type__c = 'Inboard';
        objInventory1.Hull_Material__c = 'Wood';
        objInventory1.Engine__c = 'Sample';
        objInventory1.Net_Weight__c = 100.22;
        objInventory1.Suggested_List_Price__c = 20000;
        objInventory1.Cost__c = 15000;
        objInventory1.ACV__c = 10000;
        objInventory1.Date_on_FloorPlan__c = System.Today();
        objInventory1.Costline__c = 10;
        objInventory1.Hull_ID__c = 'ABC123';
        objInventory1.Trailer_ID__c ='XYZ456';
        objInventory1.Engine_SN__c = '111111';
        objInventory1.Interest_Start_Date__c = System.Today();
        objInventory1.Curtailment_Start_Date__c = System.Today();
        objInventory1.UsedBoatStatus__c  = 'Service';
        objInventory1.Location__c = 'Showroom';
        objInventory1.Dealer_Prep__c = 10000;
        objInventory1.Owner__c = 'Dealership';
        objInventory1.Part_Number__c = '123456';
        
        BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
        objILI.Name = 'Bimini Top';
        objILI.Name__c = 'Bimini Top'; 
        objILI.Option_Category__c = 'Bimini Top';
        objILI.Price__c = 10000;
        objILI.Dealer_Price__c = 200;
        lstInventoryLineItem.add(objILI);
        objUsedBoatFormController.objInventory = objInventory1;
        objUsedBoatFormController.lstInventoryLineItem = lstInventoryLineItem;
        Pagereference pf =objUsedBoatFormController.createBoat();
        objUsedBoatFormController.getMFGPriceSubtrct();
        objUsedBoatFormController.getDeleteDealerOptionPriceSub();
        objUsedBoatFormController.getDealerOptionPriceSub();
        objUsedBoatFormController.getMFGPrice();
     //   objUsedBoatFormController.checkAccess();
    }
    
    
}