@isTest
public class SendInspectionFormControllerTest {
    testmethod static void TestController(){
        BOATBUILDING__Dealership_Form__c ObjD= new BOATBUILDING__Dealership_Form__c();
        insert ObjD;
        ApexPages.currentPage().getParameters().put('id',ObjD.Id);
       // SendInspectionFormController ObjS = new SendInspectionFormController();
        //ObjS.strTo = 'ma@bcd.com';
        //ObjS.sendIF();
        
        
        
        
        
    }
    
}