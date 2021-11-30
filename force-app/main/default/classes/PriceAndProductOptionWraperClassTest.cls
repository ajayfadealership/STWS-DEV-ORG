@isTest
public class PriceAndProductOptionWraperClassTest {
    static testMethod void myUnitTest(){
        BOATBUILDING__ProductPrice__c objPrice = new   BOATBUILDING__ProductPrice__c();
        objPrice.BOATBUILDING__ProductRetail_Price__c = 123;
        objPrice.BOATBUILDING__Product_Code__c = 'test';
        objPrice.BOATBUILDING__Sorting_Order__c = 1;
        insert objPrice;
        
        list<CheckBoxWraper> lstCBW = new  list<CheckBoxWraper>();
        CheckBoxWraper objCheckBox = new CheckBoxWraper(true,1,objPrice);
        objCheckBox.checkBox = true;
        objCheckBox.rowNumber = 1;
        objCheckBox.objProductPriceForSelectedCategory = objPrice;
        lstCBW.add(objCheckBox);
        
        PriceAndProductOptionWraperClass obj = new PriceAndProductOptionWraperClass('test',lstCBW);
        
        
    }
    
    
    
    
    
}