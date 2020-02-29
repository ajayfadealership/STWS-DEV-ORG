@isTest
public class ServiceIFPDFControllerTest {
    testmethod static void TestController1(){
        BOATBUILDING__Template_WhyBuyFromUS__c ObjT = new BOATBUILDING__Template_WhyBuyFromUS__c();
        ObjT.Name = 'ojdio';
        insert ObjT;
        BOATBUILDING__Dealership_Form__c ObjD = new BOATBUILDING__Dealership_Form__c();
        insert ObjD;
        ApexPages.currentPage().getParameters().put('Id', ObjD.Id);
        ServiceIFPDFController ObjS= new ServiceIFPDFController();
        
        
        
        
    }
    
    
}