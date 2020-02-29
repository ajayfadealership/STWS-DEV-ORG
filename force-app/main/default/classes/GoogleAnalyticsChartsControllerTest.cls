@isTest
public class GoogleAnalyticsChartsControllerTest {
    testmethod static void TestController(){
        BOATBUILDING__Inventory__c ObjInv= new BOATBUILDING__Inventory__c ();
        insert ObjInv;
        ApexPages.StandardController sc = new ApexPages.StandardController(objInv);
		GoogleAnalyticsChartsController ObjG = new  GoogleAnalyticsChartsController(sc);
        ObjG.storeAnalyticsData();
        
        
    }

}