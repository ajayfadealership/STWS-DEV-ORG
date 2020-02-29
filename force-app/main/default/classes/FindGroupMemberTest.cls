@isTest
public class FindGroupMemberTest {
    testmethod static void TestController(){
        Profile q = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = q.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardasdasdasdsdasduserbnvhv@testorg.com');
        User r = [Select Id From User Limit 1];
        r.UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'GM' Limit 1 ].Id;
        insert u;
        Group testGroup = new Group(Name='test group', Type='Queue');
        insert testGroup;
        
        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        
        Case aCase = new Case(OwnerId = testGroup.Id);
        insert aCase;
        FindGroupMember objF = new FindGroupMember();
        objF.isGroupMemberUser(UserInfo.getUserId(), testGroup.Id);    
    }
    
}