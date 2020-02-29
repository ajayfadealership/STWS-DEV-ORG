@isTest
public class CreateTrailerControllerTest {

    testmethod static void testCreateTrailer(){
        BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
        objInv.Trailer_ID__c = '1234';
        
        CreateTrailerController objCont = new CreateTrailerController();
        objCont.objTrailer = objInv;
        objCont.createTrailer();
    }
}