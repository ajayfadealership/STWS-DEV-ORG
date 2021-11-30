@isTest
public class CustomerInquiryTriggerHandlerTest {

    testmethod static void testMethod1(){
        BOATBUILDING__Customer_Inquiry__c objCI = new BOATBUILDING__Customer_Inquiry__c();
        objCI.BOATBUILDING__Lead_Source__c = 'Get A Quote';
        objCI.BOATBUILDING__Email__c = 'test@test.com';
        objCI.BOATBUILDING__First_Name__c = 'Get A Quote';
        objCI.BOATBUILDING__Last_Name__c = 'Get A Quote';
        objCI.BOATBUILDING__IsCreatedFromWeb__c = True;
        insert objCI;
    }
}