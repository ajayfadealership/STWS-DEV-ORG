@isTest
public class WindowStickerControllerTest {
    static testMethod void myUnitTest(){
        BOATBUILDING__Template_WhyBuyFromUS__c objForm = new BOATBUILDING__Template_WhyBuyFromUS__c();
        objForm.Name = 'TemplateInfo';
        objForm.BOATBUILDING__Company_Name__c = 'tst';
        objForm.BOATBUILDING__TemplateInfo__c = 'test,test';
        insert objForm;
        list<BOATBUILDING__Inventory__c> lstInv = new list<BOATBUILDING__Inventory__c>(); 
        BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
        lstInv.add(objInv);
        objInv.BOATBUILDING__Window_Sticker_MSRP__c = 12;
        objInv.BOATBUILDING__Window_Sticker_Payment__c = 120;
        objInv.BOATBUILDING__Window_Sticker_Interest_Rate__c = 1234;
        objInv.BOATBUILDING__Window_Sticker_Our_Discount__c = 1;
        objInv.BOATBUILDING__Web_Down_Payment__c = 123;
        insert objInv;
        ApexPages.currentPage().getParameters().put('invId',objInv.Id);
        WindowStickerController objWindow = new WindowStickerController();
        
        
    }
    
}