@isTest
public class BoatShowLeadCaptureControllerTest {
    static testMethod void myUnitTest(){
        
        BoatShowLeadCaptureController objBSLCC = new BoatShowLeadCaptureController();
        objBSLCC.objAccount = new Account();
        objBSLCC.objAccount.Name = 'test';
        objBSLCC.CreateBoatShowaccount();
        objBSLCC.objAccount.BOATBUILDING__Prospect_Last_Name__c = 'Last Name Test';
        objBSLCC.CreateBoatShowaccount(); 
    } 
    static testMethod void myUnitTest1(){
        
        BoatShowLeadCaptureController objBSLCC = new BoatShowLeadCaptureController();
        objBSLCC.objAccount = new Account();
        objBSLCC.objAccount.Name = 'test';
        objBSLCC.objAccount.BOATBUILDING__Prospect_Last_Name__c = 'Last Name Test';
        objBSLCC.CreateBoatShowaccount(); 
    } 
}