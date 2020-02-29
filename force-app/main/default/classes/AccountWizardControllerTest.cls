@isTest
public class AccountWizardControllerTest {
    static testMethod void myUnitTest(){
        Account a = new Account();
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        a.Name = 'Test';
        insert a ;
     //   AccountWizardController.createAccountApex(a);
        
    }}