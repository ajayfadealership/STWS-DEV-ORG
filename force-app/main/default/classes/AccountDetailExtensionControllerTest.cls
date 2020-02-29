@isTest
public class AccountDetailExtensionControllerTest {
    static testMethod void myUnitTest() {
        Account objAccP = new Account();
        objAccP.Name = 'Test P';
        insert objAccP;
        
        Account objAcct = new Account();
        objAcct.Name ='Test';
        objAcct.BOATBUILDING__Lead_Account_History__c = objAccP.Id;
        insert objAcct;
        ApexPages.StandardController sc = new ApexPages.StandardController(objAcct);
        AccountDetailExtensionController testAccPlan = new AccountDetailExtensionController(sc);
        testAccPlan.printaccount();
        //ApexPages.currentPage().getParameters().put('productId','TestProdId');
        
        //ApexPages.StandardController sc = new ApexPages.StandardController(objAccount);
        
        
    }
    
    
}