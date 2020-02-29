@isTest
public class NewDealerOptionControllerTest {
    testmethod static void TestController(){
        NewDealerOptionController ObjN= new NewDealerOptionController();
        Profile q = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = q.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardasdasdasdsdasduserbnvhv@testorg.com');
        User r1 = [Select Id From User Limit 1];
        r1.UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'GM' Limit 1 ].Id;
        insert u1;
        BOATBUILDING__Dealer_Option__c ObjD= new BOATBUILDING__Dealer_Option__c();
        List<String> listDOId = new List<String>();
        ObjD.Name ='test';
        ObjD.BOATBUILDING__Cost__c = 1234;
        ObjD.BOATBUILDING__Part_Number__c ='testt';
        ObjD.BOATBUILDING__Retail_Price__c = 12;
        listDOId.add(objD.Id);
        insert ObjD;
        NewDealerOptionController.updateDealerOptionApex('test','1234','12','testt','1');
       
            
            }
    
    
}