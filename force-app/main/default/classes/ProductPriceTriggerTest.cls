@isTest
private class ProductPriceTriggerTest {

    static testMethod void firstTestMethod() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__ProductPriceTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.Model_Variant__c =false;
        insert objManuFacturer1;
        list<BOATBUILDING__ProductPrice__c> objPPr = new list<BOATBUILDING__ProductPrice__c>();
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
    
        if(lstRT.size() > 0){
              objPP.RecordTypeId = lstRT[0].Id;
             }
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Product_Model__c = 'Hexa';
        objPP.Dealer_Price__c= 0.00;
        objPP.Product_Code__c = '45631';
        objPP.Option_Category__c = 'Audio Options (7A)';
        objPP.ProductSelected_Category__c = 'Add 2 Bow Speakers with Amplifier';
        objPP.Year__c = '2016';
        objPP.Sorting_Order__c = 1;
        objPP.Model_Variant__c= 'Test';
        objPP.Product_Code__c = '123456';
        objPPr.add(objPP);
        insert objPPr;
        
        objPP.Model_Variant__c= 'Test';
        update objPP;
        ProductPriceTriggerHandler.onAfterInsert(objPPr);
    }
}