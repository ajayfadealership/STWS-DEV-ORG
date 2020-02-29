@isTest
public class VfTemplateContrlTest {
    testmethod static void TestController(){
        BOATBUILDING__Inventory__c ObjInv = new BOATBUILDING__Inventory__c();
        insert ObjInv;
        BOATBUILDING__Template_WhyBuyFromUS__c ObjTemp= new BOATBUILDING__Template_WhyBuyFromUS__c(); 
        ObjTemp.Name='TemplateInfo';
        ObjTemp.BOATBUILDING__Company_Address__c='test';
        ObjTemp.BOATBUILDING__Company_Name__c='testty';
        ObjTemp.BOATBUILDING__Company_Phone__c='testcfv';
        ObjTemp.BOATBUILDING__Company_Website__c='testdwed';
        ObjTemp.BOATBUILDING__TemplateInfo__c='wdccc';
        insert ObjTemp;
        ApexPages.currentPage().getParameters().put('invId',ObjInv.Id);
        
        VfTemplateContrl ObjV= new VfTemplateContrl();
        ObjV.ContinueAfterSelection();
        ObjV.getselectTemplate();
        ObjV.sideimageid= 'true';
        ObjV.Interiorimageid='true';
        ObjV.getselectTemplate();
        
       
        
        
        
    }
    
}