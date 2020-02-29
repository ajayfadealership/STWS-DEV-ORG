@isTest
private class CreditAppPageControllerTest {
    
    static testMethod void myUnitTest() {
        Id creditAppRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Credit App').getRecordTypeId();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Email__c='Test@test.com';
        objAccount.RecordTypeId = creditAppRecordTypeId;
        insert objAccount;
        
        ApexPages.currentPage().getParameters().put('productId','TestProdId');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        CreditAppPageController objCont = new CreditAppPageController(sc);
        
        objCont.saveCreditDetails();
    }
    
    static testMethod void myUnitTest2() {
        Id creditAppRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Credit App').getRecordTypeId();
        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        objAccount.Email__c='Test@test.com';
        objAccount.RecordTypeId = creditAppRecordTypeId;
        insert objAccount;
        
        Contact con = new Contact();
        con.AccountId = objAccount.Id;
        con.LastName = objAccount.Id;
        con.Email = objAccount.Email__c;
        insert con;
        
        ApexPages.currentPage().getParameters().put('productId','TestProdId');
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        CreditAppPageController objCont = new CreditAppPageController(sc);
        
        objCont.saveCreditDetails();
    }
}