@isTest
public class ACVFormTriggerTest {
    private static testmethod void ACVFormTriggerTest(){
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        BOATBUILDING__ACV_Form__c ObjAcv = new BOATBUILDING__ACV_Form__c();
        ObjAcv.BOATBUILDING__Contact_Name__c = objContact.Id;
        ObjAcv.BOATBUILDING__Account__c  = a.Id;
        ObjAcv.BOATBUILDING__High_Comp_1_Amount__c = 12;
        ObjAcv.BOATBUILDING__High_Comp_2_Amount__c = 123;
        ObjAcv.BOATBUILDING__High_Comp_3_Amount__c = 1234;
        ObjAcv.BOATBUILDING__Low_Comp_1_Amount__c = 21;
        ObjAcv.BOATBUILDING__Low_Comp_2_Amount__c =22;
        insert objAcv;
        
    }
    
}