@isTest
public class ItemtriggerTest {
    
    testmethod static void TestController() { 
        BOATBUILDING__TriggerSetting__c objTS = new BOATBUILDING__TriggerSetting__c();
        objTS.BOATBUILDING__ItemTrigger__c = True;
        insert objTS;
        
        account objAcc = new account();
        objAcc.Name = 'test name';
        objAcc.AnnualRevenue = 34456;
        insert objAcc;
        
        contact objCon = new contact();
        objCon.BOATBUILDING__Customer_Type__c = 'test type';
        objCon.LastName = 'test';
        objCon.FirstName = 'Test Con';
        
        insert objCon;  
        
        BOATBUILDING__Item__c objIT = new BOATBUILDING__Item__c();
        objIT.BOATBUILDING__Boat_HIN_No__c = 'ABC';
        objIT.BOATBUILDING__Contact__c = objCon.Id;
        objIt.BOATBUILDING__Account__c = objCon.AccountId;
        System.AssertEquals( objIt.BOATBUILDING__Account__c,objCon.AccountId);
        insert objIt;
        
        
        
        
    }
}