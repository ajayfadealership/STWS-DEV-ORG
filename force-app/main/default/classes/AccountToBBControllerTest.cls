@isTest
public class AccountToBBControllerTest {

    testmethod static void TestController1(){
        
        BOATBUILDING__Inventory__c inv = new BOATBUILDING__Inventory__c();
        //inv.Name = 'Test';
        insert inv;
        
        Account acc = new Account();
        acc.Name = 'Test';
        acc.BOATBUILDING__Related_To_Inventory__c = inv.Id;
        insert acc;
        
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        AccountToBBController objCont = new AccountToBBController();
        objCont.redirectToBB();
        
    }
    
    testmethod static void TestController2(){
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test LastName';
        con.AccountId = acc.Id;
        insert con;
        
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        AccountToBBController objCont = new AccountToBBController();
        objCont.redirectToBB();
        
    }
    
    testmethod static void TestController3(){
        
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        ApexPages.currentPage().getParameters().put('Id', acc.Id);
        
        AccountToBBController objCont = new AccountToBBController();
        objCont.redirectToBB();
        
    }
}