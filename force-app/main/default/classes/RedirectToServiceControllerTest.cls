@isTest
public class RedirectToServiceControllerTest {
    static testMethod void myUnitTest(){
        BOATBUILDING__Work_Order__c ObjW= new BOATBUILDING__Work_Order__c();
        insert ObjW;
        ApexPages.StandardController sc = new ApexPages.StandardController(ObjW);
		RedirectToServiceController ObjR= new RedirectToServiceController(sc);
      ObjR.redirectToService();
        ObjR.inLightning();
        
    }
    
}