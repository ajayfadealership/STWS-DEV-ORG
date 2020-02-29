@isTest
public class UpdateInventoryOnWebsiteTest {
	
    testmethod static void updateWebTest(){
        
        BOATBUILDING__FroceDotCom__c objEndpoint = new BOATBUILDING__FroceDotCom__c();
        objEndpoint.BOATBUILDING__WebsiteEndPoint__c = 'Test.Endpoint.com';
        insert objEndpoint;
        
        Inventory__c objInv = new Inventory__c();
        insert objInv;
        
        String invId = objInv.Id;
        UpdateInventoryOnWebsite.updateOnWeb(invId);
        UpdateInventoryOnWebsite.updateOnWebLightning(invId);
    }
}