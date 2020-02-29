@isTest
private class ContactTriggerHandlerTest {
    
    @testSetup
    static void dataSetup() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__ContactTriggerCheckbox__c= true;
        insert ObjTriggerSetting;

        BOATBUILDING__OAuthService__c custSetOAuthServ = new BOATBUILDING__OAuthService__c();
        custSetOAuthServ.Name = 'Intuit';
        custSetOAuthServ.BOATBUILDING__Access_Token_URL__c = '12f32965b0ac4b4932b90f3b65c559e781ed';
        custSetOAuthServ.BOATBUILDING__Application_Token__c = '12f32965b0ac4b4932b90f3b65c559e781ed';
        custSetOAuthServ.BOATBUILDING__Authorization_URL__c = 'https://oauth.intuit.com/oauth/v1/get_access_token';
        custSetOAuthServ.BOATBUILDING__Company_ID__c = '123145830824089';
        custSetOAuthServ.BOATBUILDING__Consumer_Key__c = 'qyprdZhlgBZ7tUvxKD5zzCe8LJ5ImS';
        custSetOAuthServ.BOATBUILDING__Consumer_Secret__c = 'HJhghg8763826jhgdaj';
        custSetOAuthServ.BOATBUILDING__OAuth_Token__c = 'HJhghg8763826jhgdaj';
        custSetOAuthServ.BOATBUILDING__OAuth_Token_Secret__c = 'HJhghg8763826jhgdaj';
        custSetOAuthServ.BOATBUILDING__Request_Token_URL__c = 'HJhghg8763826jhgdaj';
        custSetOAuthServ.BOATBUILDING__Temporary_Token_Secret__c = 'HJhghg8763826jhgdaj';
       
        Insert custSetOAuthServ;
        
        
        BOATBUILDING__EndPointURL__c custSetEndPoint = new BOATBUILDING__EndPointURL__c();
        custSetEndPoint.Name = 'QBCreateCustomerEndPoint';
        custSetEndPoint.BOATBUILDING__URL__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/';
        
        
        Insert custSetEndPoint;
    }
    static testMethod void myUnitTest() {
        
         System.runAs(new user(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new MockService());
            Contact objCon = new Contact();
            ObjCon.FirstName = 'Test Denny';
            ObjCon.LastName = 'Test Denny123';
            ObjCon.Email = '360dc@test.com';
            ObjCon.Phone = '1234567890';
            ObjCon.MailingStreet = 'street';
            ObjCon.MailingCity = 'city';
            ObjCon.MailingState = 'state';
            ObjCon.MailingCountry = 'country';
            ObjCon.MailingPostalCode = '000000';
             
           insert ObjCon;
             
        }
    
    }
 }