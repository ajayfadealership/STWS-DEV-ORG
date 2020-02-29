@isTest
public class InventorySelectionTableControllerTest {
    testmethod static void TestController(){
        InventorySelectionTableController objN = new InventorySelectionTableController();
        BOATBUILDING__Inventory__c objInv= new BOATBUILDING__Inventory__c();
        Id RecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
        objInv.RecordTypeId = RecordTypeId;
        objInv.Manufacturer__c = 'ABC';
        objInv.BOATBUILDING__Model__c = 'model';
        objInv.BOATBUILDING__Model_Variant__c ='miss';
        objInv.BOATBUILDING__Year__c = '1234';
      
        insert objInv;
        Id RecordTypeId1 = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Used Boats').getRecordTypeId();
        objInv.RecordTypeId = RecordTypeId1;
        update objInv;
        
        BOATBUILDING__Inventory_Line_Item__c objI = new BOATBUILDING__Inventory_Line_Item__c ();
        objI.BOATBUILDING__Name__c = 'test1';
        objI.BOATBUILDING__Option_Category__c = 'test';
        objI.BOATBUILDING__Related_to_Inventory__c = objInv.Id;
        objI.BOATBUILDING__Dealer_Price__c = 123;
        objI.BOATBUILDING__Option_Category__c ='Dealer Options';
        objI.BOATBUILDING__Product_Code__c = 'testt';
        insert objI;
        
        BOATBUILDING__Dealer_Option__c objD= new 	BOATBUILDING__Dealer_Option__c();
        objD.Name='test';
        objD.BOATBUILDING__Part_Number__c='all';
        insert objD;
        
        BOATBUILDING__Manufacturer__c objM= new BOATBUILDING__Manufacturer__c();
        objM.Name = objInv.Manufacturer__c;
        objM.BOATBUILDING__Manufacturer_name__c = 'tests';
        insert objM;
        
        BOATBUILDING__Product__c objP= new BOATBUILDING__Product__c();
        objP.BOATBUILDING__Product_Manufacturer__c = objM.Id;
        objP.BOATBUILDING__MModel2__c= 'SC';
        objP.BOATBUILDING__M_Model_Variant__c='SR400';
        objP.BOATBUILDING__Product_Type__c = 'Used Boats';
        objP.BOATBUILDING__M_Year__c = 'Other';
        objP.BOATBUILDING__Product_Type__c = 'Other';
        insert objP;
        
        InventorySelectionTableController.getProductPriceApex(objInv.Id);
        InventorySelectionTableController.getDealerPriceApex1(objInv.Id); 
        InventorySelectionTableController.getProdutPriceingApexMD(objInv.Id);
        InventorySelectionTableController.getDealerPriceApex();
        
    }
    
}