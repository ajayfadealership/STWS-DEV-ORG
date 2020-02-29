@isTest
public class AccountcontrollerTest {
    static testMethod void myUnitTest(){
    	
        Accountcontroller objAcc = new Accountcontroller();
        objAcc.objAccount = new Account();
        objAcc.objAccount.Name = 'test';
        objAcc.CreateBoatShowaccount();
        objAcc.objAccount.BOATBUILDING__Prospect_Last_Name__c = 'Last Name Test';
        objAcc.CreateBoatShowaccount(); 
    } 
    static testMethod void myUnitTest1(){
    	
        Accountcontroller objAcc = new Accountcontroller();
        objAcc.objAccount = new Account();
        objAcc.objAccount.Name = 'test';
        objAcc.objAccount.BOATBUILDING__Prospect_Last_Name__c = 'Last Name Test';
        objAcc.CreateBoatShowaccount(); 
    } 
}