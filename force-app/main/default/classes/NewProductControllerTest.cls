@isTest
private class NewProductControllerTest {
    static testMethod void myUnitTest() {
        BOATBUILDING__Manufacturer__c objManufacturer1 = new BOATBUILDING__Manufacturer__c();
        objManufacturer1.Manufacturer_name__c = '12345';
        objManufacturer1.Name = 'Skiers Choice(Moomba)';
        objManufacturer1.Model_Variant__c = True;
        insert objManufacturer1;
        
        
        BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
        objProduct1.M_Year__c = '2016';
        objProduct1.MModel2__c = 'Mondo(MD)';
        objProduct1.Product_Manufacturer__c = objManufacturer1.Id;
        objProduct1.Cost_Price__c = 40000;
        objProduct1.M_Boat_MSRP_PRICE__c = 50000;
        objProduct1.Product_Type__c = 'New Boats';
        objProduct1.M_Model_Variant__c = 'Test';
        insert objProduct1;
        
        BOATBUILDING__Product__c objProduct2 = new BOATBUILDING__Product__c();
        objProduct2.M_Year__c = '2016';
        objProduct2.MModel2__c = 'Mondo(MD)';
        objProduct2.Product_Manufacturer__c = objManufacturer1.Id;
        objProduct2.Cost_Price__c = 40000;
        objProduct2.M_Boat_MSRP_PRICE__c = 50000;
        objProduct2.Product_Type__c = 'New Boats';
        objProduct2.M_Model_Variant__c = 'Test';
        insert objProduct2;
        
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        
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
        objPP.BOATBUILDING__Model_Variant__c = 'Test';
        objPP.ProductRetail_Price__c = 100;
        objPP.Dealer_Price__c =50;
        objPP.Sorting_Order__c = 35;
        insert objPP;
        
      //  List<PriceAndProductOptionWraperClass> li = NewProductController.getProductPriceApex('New Boats', objManufacturer1.Id, '2016', 'Mondo(MD)', 'Test', '0'); 
        
        NewProductController.getManufacturer('Skiers Choice(Moomba)');
        NewProductController.getYear(objManufacturer1.Id, 'New Boats');
        NewProductController.getMVStatus(objManufacturer1.Id);
        NewProductController.getModel('New Boats', objManufacturer1.Id, '2016', '1');
        NewProductController.getModelVariantApex('New Boats', objManufacturer1.Id, '2016', 'Mondo(MD)');
     //  NewProductController.getProductPriceApex('New Boats', objManufacturer1.Id, '2016', 'Mondo(MD)', 'Test', '0');
        NewProductController.getDealerPriceApex();
        NewProductController.getProduct(objProduct1.Id);
        NewProductController.getModel('New Boats', objManufacturer1.Id, '2016', '0');
        //NewProductController.getProduct(objPP.Id);
    }
}