@isTest
private class UserTriggerTest {

    static testMethod void myUnitTest() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__UserTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        Profile q = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        List<user> listuser= new List<user>();
        User u1 = new User();
        u1.Alias = 'standt';
        u1.Email='standarduser@testorg.com';
        u1.EmailEncodingKey='UTF-8';
        u1.LastName='Testing';
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.UserName='standardasdasdasdsdasduserbnvhv@testorg.com';
        listuser.add(u1);
        User r1 = [Select Id From User Limit 1];
        r1.UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'GM' Limit 1 ].Id;
        r1.userRoleId= null;
       // insert u1;
        //update u1;
        UserTriggerHandler.countAccountOnAssignedUserinsert(listuser);
       UserTriggerHandler.countAccountOnAssignedUserupdate(listuser);
     
       
            
        }
       
    }