@isTest
private class OptionAndSelectedCatagoryUtilTest {

    static testMethod void myUnitTest() {
        BOATBUILDING__Manufacturer__c objManuFacturer = new BOATBUILDING__Manufacturer__c();
        objManuFacturer.Name = 'Skiers Choice(Supra)';
        objManuFacturer.Manufacturer_name__c = '123';
        objManuFacturer.Model_Variant__c = true;
        insert objManuFacturer;
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.Model_Variant__c = false;
        insert objManuFacturer1;
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
        
        //String recIdNew = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'].Id;
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        BOATBUILDING__ProductPrice__c objPP1 = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
    
        if(lstRT.size() > 0){
              objPP.RecordTypeId = lstRT[0].Id;
              objPP1.RecordTypeId = lstRT[0].Id;
             }
        //objPP.RecordTypeId = recIdNew;
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Product_Model__c = 'Hexa';
        objPP.Dealer_Price__c= 0.00;
        objPP.Product_Code__c = '45631';
        objPP.Option_Category__c = 'Audio Options (7A)';
        objPP.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        objPP.Year__c = '2016';
        objPP.Sorting_Order__c = 1;
        objPP.Product_Code__c = '123456';
        insert objPP;
        
        
        
        objPP1.ProductManufacturer__c = 'Skiers Choice(Supra)';
        objPP1.Product_Model__c = 'SC';
        objPP1.Model_Variant__c = 'SC400';
        objPP1.Sorting_Order__c = 1;
        objPP1.Dealer_Price__c= 0.00;
        objPP1.Product_Code__c = '4563';
        objPP1.Option_Category__c = 'Audio Options (7A)';
        objPP1.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        objPP1.Year__c = '2016';
        insert objPP1;
        
        //String recIdNew1 = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'].Id;
        BOATBUILDING__ProductPrice__c objPP2 = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRT1= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
    
        if(lstRT1.size() > 0){
              objPP2.RecordTypeId = lstRT1[0].Id;
              //objPP1.RecordTypeId = lstRT1[0].Id;
             }
        //objPP2.RecordTypeId = recIdNew1;
        objPP2.Option_Category__c = 'Audio Options (7A)';
        objPP2.Product_Code__c = '123';
        
        objPP2.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        insert objPP2;
        
        OptionAndSelectedCatagoryUtil.getInstance('','','','Used Boats').getSelectedCatagory();
        OptionAndSelectedCatagoryUtil.getInstance(objProduct.Id, objManuFacturer1.Id,'2016','New Boats').getSelectedCatagory();
        OptionAndSelectedCatagoryUtil.getInstance(objProduct1.Id, objManuFacturer.Id,'2016','New Boats').getSelectedCatagory();         
    }
}