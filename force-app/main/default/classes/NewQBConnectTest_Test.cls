@istest
public class NewQBConnectTest_Test{
    
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
        
        BOATBUILDING__EndPointURL__c custSetEndPoint = new BOATBUILDING__EndPointURL__c();
        custSetEndPoint.Name = 'QBCreateCustomerEndPoint';
        custSetEndPoint.BOATBUILDING__URL__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/';
        
        Insert custSetEndPoint;
    }
    
     static testMethod void myUnitTest() {
     String JSONStr = '{ "BillAddr": { "Line1": "123 Main Street", "City": "Mountain View", "Country": "USA", "CountrySubDivisionCode": "CA", "PostalCode": "94042" }, "Notes": "Here are other details.", "Title": "Mr", "GivenName": "James", "MiddleName": "B", "FamilyName": "King", "Suffix": "Jr", "FullyQualifiedName": "King Groceries", "CompanyName": "King Groceries", "DisplayName": "Kings Groceries", "PrimaryPhone": { "FreeFormNumber": "(555) 555-5555" }, "PrimaryEmailAddr": { "Address": "jdrew@myemail.com" } }';
     Account acc = new Account();
     acc.name = 'Test Account';
     acc.BOATBUILDING__QBCustomerID__c='108';
     Insert acc;
     acc.BOATBUILDING__QBCustomerID__c='109';
     update acc;
     test.StartTest();
       NewQBConnectTest newQB=new NewQBConnectTest();
        Test.setMock(HttpCalloutMock.class, new MockService());
        NewQBConnectTest.CreateQBCustomer(JSONStr,acc.id);
        
       
        
     test.StopTest();
    }
    
 }