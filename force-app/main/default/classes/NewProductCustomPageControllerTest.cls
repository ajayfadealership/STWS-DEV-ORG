@isTest
private class NewProductCustomPageControllerTest {

    static testMethod void myUnitTest() {
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.Model_Variant__c =false;
        insert objManuFacturer1;
        
        BOATBUILDING__Manufacturer__c objManuFacturer = new BOATBUILDING__Manufacturer__c();
        objManuFacturer.Name = 'Skiers Choice(Supra)';
        objManuFacturer.Manufacturer_name__c = '123';
        objManuFacturer1.Model_Variant__c =true;
        insert objManuFacturer;
        
        BOATBUILDING__Product__c objProduct = new BOATBUILDING__Product__c();
        objProduct.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct.M_Year__c = '2016';  
        objProduct.MModel2__c = 'Hexa'; 
        insert objProduct;
        
        BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
        objProduct1.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct1.M_Year__c = '2016'; 
        objProduct1.MModel2__c = 'SC';
        objProduct1.M_Model_Variant__c = 'SC400';   
        insert objProduct1;
        
        String recIdNew = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'].Id;
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        objPP.Product_Code__c = '123';
        objPP.RecordTypeId = recIdNew;
        objPP.Sorting_Order__c = 1;
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Product_Model__c = 'Hexa';
        objPP.Dealer_Price__c= 0.00;
        objPP.Option_Category__c = 'Audio Options (7A)';
        objPP.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        objPP.Year__c = '2016';
        insert objPP;
        
        BOATBUILDING__ProductPrice__c objPP1 = new BOATBUILDING__ProductPrice__c();
        objPP1.RecordTypeId = recIdNew;
        objPP1.Product_Code__c = '456';
        objPP1.ProductManufacturer__c = 'Skiers Choice(Supra)';
        objPP1.Product_Model__c = 'SC';
        objPP1.Model_Variant__c = 'SC400';
        objPP1.Dealer_Price__c= 0.00;
        objPP1.Sorting_Order__c = 1;
        objPP1.Option_Category__c = 'Audio Options (7A)';
        objPP1.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        objPP1.Year__c = '2016';
        insert objPP1;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objProduct);
        NewProductCustomPageController objNewProductCustomPageController = new NewProductCustomPageController(sc);
        objNewProductCustomPageController.selectedManufacturer = objManuFacturer1.Id;
        objNewProductCustomPageController.selectedYear = '2016';
        objNewProductCustomPageController.selectedModel = 'Hexa';
        objNewProductCustomPageController.selectedOptionCategory =  'Audio Options (7A)';
        objNewProductCustomPageController.selectedSCategory = 'Add 2 Bow Speakers with Amplifier';
        objNewProductCustomPageController.getYears();
        objNewProductCustomPageController.getModel();
        objNewProductCustomPageController.getSelectedCategory();
        objNewProductCustomPageController.saveNewProduct();
        objNewProductCustomPageController.saveAndNewForm();
        objNewProductCustomPageController.cancelBack();
        
        objNewProductCustomPageController.selectedManufacturer = objManuFacturer.Id;
        objNewProductCustomPageController.selectedYear = '2016';
        objNewProductCustomPageController.selectedModel = 'SC'; 
        objNewProductCustomPageController.selectedModelVariant = 'SC400';
        objNewProductCustomPageController.selectedSCategory = null;
        objNewProductCustomPageController.selectedOptionCategory = null;
        objNewProductCustomPageController.getYears();
        objNewProductCustomPageController.getModel();
        objNewProductCustomPageController.getEngineOptionCatAndModelVariant();
        objNewProductCustomPageController.getSelectedCategory();
        objNewProductCustomPageController.saveNewProduct();
        objNewProductCustomPageController.saveAndNewForm();
        objNewProductCustomPageController.cancelBack();
    }
}