@isTest
public class SendEmailPageControllerTest {
    static testMethod void myUnitTest(){
       
        BOATBUILDING__Dealership_Form__c objDealer = new BOATBUILDING__Dealership_Form__c();
        ApexPages.currentPage().getParameters().put('Id',objDealer.Id);
        insert objDealer;
        SendEmailPageController objSendEmail = new SendEmailPageController();
        //objSendEmail.sendEmail();
        // objSendEmail.checkAccess();
        
        
    }
    
}