@isTest
public class ItemToACVTest {
    static testMethod void myUnitTest(){
        ItemToACV objItem = new ItemToACV();
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        
       
        BOATBUILDING__ACV_Form__c objForm = new BOATBUILDING__ACV_Form__c();
        objForm.BOATBUILDING__Contact_Name__c = objContact.Id;
        objForm .BOATBUILDING__High_Comp_1_Amount__c = 123;
        objForm.BOATBUILDING__High_Comp_2_Amount__c = 12;
        objForm.BOATBUILDING__High_Comp_3_Amount__c = 1;
        objForm.BOATBUILDING__Low_Comp_1_Amount__c = 0;
        objForm.BOATBUILDING__Low_Comp_2_Amount__c = 51;
        objForm.BOATBUILDING__Low_Comp_3_Amount__c = 23;
        insert objForm; 
        ItemToACV.generateACVFormClassic(objForm.Id);
        
    }
    
}