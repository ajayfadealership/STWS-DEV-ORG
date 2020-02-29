@istest
public class BatchSendWoToQb_Test{
    
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
        custSetEndPoint.Name = 'QBCreateInvoiceEndPont';
        custSetEndPoint.BOATBUILDING__URL__c = 'https://sandbox-quickbooks.api.intuit.com/v3/company/';
        
        Insert custSetEndPoint;
        
        Account acc = new Account();
        acc.name = 'Test Account';
        acc.BOATBUILDING__QBCustomerID__c='108';
        Insert acc;
        Contact con = new contact();
        con.lastname= 'testcon';
        con.QBCustomerID__c ='1234';
        insert con;
        
        BOATBUILDING__Work_Order__c objBOATBUILDINGWork_Order = new BOATBUILDING__Work_Order__c();
        objBOATBUILDINGWork_Order.BOATBUILDING__Account__c = acc.id;
        objBOATBUILDINGWork_Order.BOATBUILDING__Contact__c = con.id;
        objBOATBUILDINGWork_Order.BOATBUILDING__Status__c ='Approved';
        objBOATBUILDINGWork_Order.BOATBUILDING__SendInvoiceToQB__c = true;
        objBOATBUILDINGWork_Order.BOATBUILDING__QBInvoiceID__c ='';
        objBOATBUILDINGWork_Order.BOATBUILDING__Store_Location__c = 'Other';
        insert objBOATBUILDINGWork_Order;
    }
    
     static testMethod void TestBatchSendWoToQbPositive() {
     
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockService());
        try{
        BatchSendWoToQb objBatchSendWoToQb = new BatchSendWoToQb();
        dataBase.executeBatch(objBatchSendWoToQb,1);
        }
        
        catch(Exception e)
        {
        
        }
        
        Test.StopTest();
    }
    
 }