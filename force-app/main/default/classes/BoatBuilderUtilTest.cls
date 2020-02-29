@isTest
public class BoatBuilderUtilTest {
    testmethod static void TestController(){
        BOATBUILDING__SalesTaxConfiguration__c objSale = new BOATBUILDING__SalesTaxConfiguration__c();
        objSale.Name = 'test';
        insert objSale;
        BoatBuilderUtil objBoat = new BoatBuilderUtil('test');
        
       
    }

}