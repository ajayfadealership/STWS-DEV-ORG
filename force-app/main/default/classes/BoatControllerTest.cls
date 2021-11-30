@isTest
public class BoatControllerTest {
    public static TestMethod void test1(){
        Test.setMock(HttpCalloutMock.class, new BoatControllerMockHttpResponse());
        BoatController.getBoatInfo();
        BoatController.getInventoryById('7514286');
        BoatController.addUsedInventory('7514286');
    }
}