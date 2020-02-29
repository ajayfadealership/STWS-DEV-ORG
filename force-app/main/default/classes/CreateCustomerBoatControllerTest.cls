@isTest
public class CreateCustomerBoatControllerTest{

    testmethod static void testmethod1(){
        
        BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
        objInv.Model__c = '2008';
        objInv.Year__c = '2008';
        objInv.HIN_Number__c = '2008HIN';
        objInv.BOATBUILDING__Serial_Number_2__c = 'test SN';
        objInv.BOATBUILDING__Beam__c = '100';
        objInv.BOATBUILDING__Boat_Length_in_feets__c = '10';
        objInv.BOATBUILDING__Engine_Year__c = '2008';
        objInv.BOATBUILDING__Weight__c = '100';
        objInv.BOATBUILDING__Engine_Model__c = '2008';
        objInv.BOATBUILDING__Model_Variant__c = '2008';
        
        insert objInv;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objInv);
        CreateCustomerBoatController objCont = new CreateCustomerBoatController(sc);
        
        objCont.createBoat();
    }
}