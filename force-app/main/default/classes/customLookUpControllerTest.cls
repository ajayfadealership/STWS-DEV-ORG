@isTest
public class customLookUpControllerTest {
    testmethod static void TestController(){
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;    
        customLookUpController objCust= new customLookUpController();
        customLookUpController.fetchLookUpValues('test last','Contact');
        
        
    }

}