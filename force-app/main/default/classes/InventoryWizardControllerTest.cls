@isTest
public class InventoryWizardControllerTest {
 
        
    
    testmethod static void inventoryTest(){
        
      
         
    
        BOATBUILDING__Manufacturer__c objManufacturer1 = new BOATBUILDING__Manufacturer__c();
        objManufacturer1.Manufacturer_name__c = '12345';
        objManufacturer1.Name = 'Skiers Choice(Moomba)';
        objManufacturer1.Model_Variant__c = false;
        insert objManufacturer1;
        
        BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
        objProduct1.M_Year__c = '2016';
        objProduct1.MModel2__c = 'Mondo(MD)';
        objProduct1.Product_Manufacturer__c = objManufacturer1.Id;
        objProduct1.Cost_Price__c = 40000;
        objProduct1.M_Boat_MSRP_PRICE__c = 50000;
        objProduct1.M_Dealer_Status__c ='Quoted';
        objProduct1.M_Manufacture_Status__c = 'Ordered';
  
        insert objProduct1;
        
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        
        List<String> listProdId = new List<String>();
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        if(lstRT.size() > 0){
            objPP.RecordTypeId = lstRT[0].Id;
        }
        objPP.Option_Category__c = 'Trailer Light Options (9G)';
        objPP.ProductSelected_Category__c = 'Surface Mount Clear LED';
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Year__c ='2016';
        objPP.Product_Model__c ='Mondo(MD)';
        objPP.Product_Code__c = 'ABC123';
        objPP.ProductRetail_Price__c = 100;
        objPP.Dealer_Price__c =50;
        objPP.Sorting_Order__c = 35;
        insert objPP;
        listProdId.add(objPP.Id);
        
         List<String> listDO = new List<String>();
        BOATBUILDING__Dealer_Option__c objDO = new BOATBUILDING__Dealer_Option__c();
        objDO.Name = 'Test';
        objDO.BOATBUILDING__Cost__c = 10;
        objDO.BOATBUILDING__Part_Number__c = 'PartNo';
        objDO.BOATBUILDING__Retail_Price__c = 20;
        insert objDO;
        listDO.add(objDO.Id);
        
        
        List<RecordType>  lstInventory5Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats'];
        BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
        if(lstInventory5Id.size() > 0){
            objInventory5.RecordTypeId = lstInventory5Id[0].Id;
        }
        objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory5.Year__c = '2017';
        objInventory5.Model__c = 'SR';
        objInventory5.Cost__c =10000;
        objInventory5.Model_Variant__c = 'SR400';
        objInventory5.Part_Number__c = 'ABC400';
        objInventory5.Engine_SN__c = '12345';
        objInventory5.Boat_Length_in_feets__c = '12';
        objInventory5.HIN_Number__c = 'ABC12';
        objInventory5.Trailer_VIN__c = 'xyz';
        insert objInventory5;
        
        
          

        
      
        
        InventoryWizardController.generateInventory(objProduct1.Id, listProdId, listDO, objInventory5 , objDO.Name );
        InventoryWizardController.isNoSalesmanWithoutCost();
    }
}