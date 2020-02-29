@isTest
public class TimeMgmtCustReportControllerTest {
    testmethod static void TestController(){
        TimeMgmtCustReportController ObjC = new TimeMgmtCustReportController();
        BOATBUILDING__Work_Order_Job__c ObjO = new BOATBUILDING__Work_Order_Job__c(); 
        Profile q = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = q.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardasdasdasdsdasduserbnvhv@testorg.com');
        User r1 = [Select Id From User Limit 1];
        r1.UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'GM' Limit 1 ].Id;
        insert u1;
        TimeMgmtCustReportController.getUserDetails();
        ObjC.getLongDate();
        TimeMgmtCustReportController.getReport('All','ALL');
        TimeMgmtCustReportController.getTM(Userinfo.getUserId(),'All');
    }
    
}