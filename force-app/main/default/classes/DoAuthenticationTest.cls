@isTest	
public class DoAuthenticationTest {
    testmethod static void Test1(){
        
        ExternalDatabaseConfig__c objEDBC = new ExternalDatabaseConfig__c();
        objEDBC.Name='Exter';
        objEDBC.BOATBUILDING__Dealer_Id__c='Dealer';
        //objEDBC.id='Manufacturers';
        insert objEDBC;
        
        //DoAuthentication.Manufacturers = objEDBC.Id;
        List<ExternalDatabaseConfig__c> lstEDBC = new List<ExternalDatabaseConfig__c>();
        lstEDBC.add(objEDBC);
        DoAuthentication objTest = new DoAuthentication();
        objTest.getItems();
        objTest.getyearvalues();
        objTest.getobjectvalues();
       // DoAuthentication.docallout();
       // DoAuthentication.docallouttoImport();
    }
}