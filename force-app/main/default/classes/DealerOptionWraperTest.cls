@isTest
public class DealerOptionWraperTest {
    testmethod static void TestController(){
       BOATBUILDING__Dealer_Option__c ObjD = new BOATBUILDING__Dealer_Option__c();
        ObjD.Name='test';
       ObjD.BOATBUILDING__Part_Number__c ='test1';       
       insert ObjD;
        
    }

}