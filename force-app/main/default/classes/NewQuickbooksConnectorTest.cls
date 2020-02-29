@istest
public class NewQuickbooksConnectorTest{
   
    @testSetup
    static void dataSetup() {
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
    }
    
    static testMethod void myUnitTest() {
     test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockService());
        NewQuickbooksConnector objQBConn = new NewQuickbooksConnector();
        objQBConn.OAuth_Step1_getTempTokenAndRedirectToIntuit();
        objQBConn.OAuth_Step2_getFinalToken();
    test.Stoptest();
    }
  
}