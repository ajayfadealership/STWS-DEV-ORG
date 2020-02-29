@isTest
public class CheckBoxWraperTest {
    static testMethod void myUnitTest(){
        
        Id recTypeId = Schema.SObjectType.BOATBUILDING__ProductPrice__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
        BOATBUILDING__ProductPrice__c objProduct = new BOATBUILDING__ProductPrice__c();
        objProduct.RecordTypeId = recTypeId;
        objProduct.BOATBUILDING__Sorting_Order__c = 1;
        objProduct.BOATBUILDING__Product_Code__c = 'test';
        insert objproduct;
        
        CheckBoxWraper objCBox =  new CheckBoxWraper(true,12,objProduct);        
        
    }
}