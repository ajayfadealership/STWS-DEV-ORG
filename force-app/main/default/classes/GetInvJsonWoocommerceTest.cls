@isTest
public class GetInvJsonWoocommerceTest {
    static testMethod void myUnitTest(){
        Account a = new Account();
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        

    }
    
}