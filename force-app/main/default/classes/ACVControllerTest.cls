@isTest
public class ACVControllerTest {
    testmethod static void TestController(){
        ACVController ObjAcv = new ACVController();
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        BOATBUILDING__ACV_Form__c ObjF = new BOATBUILDING__ACV_Form__c();
        ObjF.BOATBUILDING__Contact_Name__c = objContact.Id;
        ObjF.BOATBUILDING__High_Comp_1_Amount__c = 1;
        ObjF.BOATBUILDING__High_Comp_2_Amount__c = 12;
        ObjF.BOATBUILDING__High_Comp_3_Amount__c= 123;
        ObjF.BOATBUILDING__Low_Comp_1_Amount__c = 1234;
        ObjF.BOATBUILDING__Low_Comp_2_Amount__c = 12345;
        insert ObjF;
        ACVController.getNewACVObjInstance();
        ACVController.saveACVForm(ObjF);
        ACVController.checkApprovalStatus(objF.Id);
        
        
    }
    
}