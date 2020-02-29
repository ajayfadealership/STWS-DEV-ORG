@isTest
public class AccountDetailControllerTest {
    static testMethod void myUnitTest(){
        
        Account objAcc = new Account();
        objAcc.Name='Test';
        objAcc.Phone='Test';
        objAcc.BOATBUILDING__Account_Customer_Type__c = 'Test';
        objAcc.Id = AccountWizardController.createAccountApex(objAcc);
//        insert objAcc;
        ApexPages.currentPage().getParameters().put('Id',objAcc.Id);
        
        AccountDetailController objCont = new AccountDetailController();
    }
}