@isTest
private class AccountProspectTriggerHandlerTest {
    
    @testSetup
    static void dataSetup() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__AccountProspectTriggerChackBox__c= true;
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
        
      /*    account objAcc = new account();
        list<account> lstacc = new list<account>();
        map<Id,account> mapId = new map<Id,account>();
        objAcc.Name = 'test';
        objAcc.Email__c = 'shiusbhjcbch@gmail.com';
        objAcc.Phone = '123455677';
        lstacc.add(objAcc);
        mapId.put(objAcc.Id,ObjAcc);
        insert lstacc;
        objAcc.BOATBUILDING__IsCreatedFromWeb__c = true;
        update objAcc; */
        Id recTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        account objAcc = new account();
        list<account> lstacc = new list<account>();
        map<Id,account> mapId = new map<Id,account>();
        objAcc.RecordTypeId = recTypeId;
        objAcc.Name = 'test';
        objAcc.Email__c = 'shiusbhjcbch@gmail.com';
        objAcc.Phone = '123455677';
        
        objAcc.BOATBUILDING__Contact_First_Name__c = 'test name';
        objAcc.BOATBUILDING__Contact_Last_Name__c = 'test last';
        objAcc.BOATBUILDING__Friends_First_Name__c = 'test abc';
        objAcc.BOATBUILDING__Friends_Last_Name__c = 'test last';
        
        lstacc.add(objAcc);
        mapId.put(objAcc.Id,ObjAcc);
        Test.startTest();
        insert objAcc;
        Test.stopTest();
        objAcc.BOATBUILDING__Lead_Source__c = 'Boat Show';
        update objAcc;
        Contact objcon = [select Id,name from contact where AccountId =:objAcc.id];
        system.assert(objcon.Id != null);
         objAcc.BOATBUILDING__Contact_First_Name__c = 'test';
         objAcc.BOATBUILDING__Contact_Last_Name__c = 'last';
         update objAcc;
        
        
    /*   Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        User u = new User();
        list<user> lstu = new list<user>();
        u.Alias = 'standt';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.UserName='st@testorg.com';
        u.Email='standarduser@testorg.com';
        u.CommunityNickname = 'Abc';
        u.LastName = 'zxc';
        u.ProfileId = p.Id;
        lstu.add(u);
        insert lstu ; */

            
         AccountProspectTriggerHandler.updateContactOnAccountChange(lstacc,mapId);
       //AccountProspectTriggerHandler.doRoundRobin(lstacc,'other');
     //  AccountProspectTriggerHandler.updateRoundRobinRecord(lstu,lstu,200);
         AccountProspectTriggerHandler.fetchSalesManagerId();
         AccountProspectTriggerHandler.filterRoundRobin(lstacc) ;   
     // AccountProspectTriggerHandler.cobuyerFirstLast(lstacc,mapId) ;  
         
    }

    static testMethod void myUnitTest() {
    
        UserRole r = new UserRole(DeveloperName = 'SalesManager', Name = 'Sales Manager');
        insert r;
        
        User u = new User(
             ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
             LastName = 'last',
             Email = 'puser000@amamama.com',
             Username = 'puser000@amamama.com' + System.currentTimeMillis(),
             CompanyName = 'TEST',
             Title = 'title',
             Alias = 'standard',
             TimeZoneSidKey = 'America/Los_Angeles',
             EmailEncodingKey = 'UTF-8',
             LanguageLocaleKey = 'en_US',
             LocaleSidKey = 'en_US',
             UserRoleId = r.Id
        );
        insert u;
        
        
        
        System.runAs(new user(id=UserInfo.getUserId())){
            Test.setMock(HttpCalloutMock.class, new MockService());
            List<RecordType> lstRecordType = [SELECT
                                                        Id
                                             FROM
                                                        RecordType
                                             WHERE 
                                                        SobjectType = 'Account'
                                             AND
                                                        DeveloperName = 'Prospect'
                                             LIMIT      
                                                        1];
                                                        
            BOATBUILDING__RoundRobin_Config__c objRRConfig = new BOATBUILDING__RoundRobin_Config__c( name = 'test',Lead_Source__c = 'Get a Quote', User_Role_Name__c = 'Sales Manager');
            insert objRRConfig;
            Account objAccount = new Account();
            objAccount.Name = 'Test 360';
            objAccount.Email__c = '360dc@test.com';
            objAccount.Phone = '1234567890';
            if(lstRecordType.size() > 0){
                objAccount.RecordTypeId = lstRecordType[0].Id;
            }  
            objAccount.BillingStreet = 'street';
            objAccount.BillingCity = 'city';
            objAccount.BillingState = 'state';
            objAccount.BillingCountry = 'country';
            objAccount.BillingPostalCode = '000000';
            objAccount.BOATBUILDING__Is_Converted_from_lead__c = true;
        insert objAccount;
        }
    }
    static testMethod void myUnitTest2() {
        Test.setMock(HttpCalloutMock.class, new MockService());
        List<RecordType> lstRecordType = [SELECT
                                                    Id
                                         FROM
                                                    RecordType
                                         WHERE 
                                                    SobjectType = 'Account'
                                         AND
                                                    DeveloperName = 'Company'
                                         LIMIT      
                                                    1];
        Account objAccount = new Account();
        objAccount.Name = 'Test 360';
        objAccount.Email__c = '360dc@test.com';
        objAccount.Phone = '1234567890';
        if(lstRecordType.size() > 0){
            objAccount.RecordTypeId = lstRecordType[0].Id;
        }  
        objAccount.BillingStreet = 'street';
        objAccount.BillingCity = 'city';
        objAccount.BillingState = 'state';
        objAccount.BillingCountry = 'country';
        objAccount.BillingPostalCode = '000000';
        insert objAccount;
        
        List<RecordType> lstRecordType2 = [SELECT
                                                    Id
                                         FROM
                                                    RecordType
                                         WHERE 
                                                    SobjectType = 'Account'
                                         AND
                                                    DeveloperName = 'Prospect'
                                         LIMIT      
                                                    1];
        objAccount.Name = 'Test';
        if(lstRecordType2.size() > 0){
            objAccount.RecordTypeId = lstRecordType2[0].Id;
        }  
        update objAccount;
    }
}