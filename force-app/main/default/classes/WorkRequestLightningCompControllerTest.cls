@isTest
public class WorkRequestLightningCompControllerTest {
    
    public static TestMethod void myTest(){
        ID recId = WorkRequestLightningCompController.getRecTypeId();
        System.assert(recId != null);
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.Email = 'shristiTesting@test.com';
        objContact.Phone = '1231231231';
        insert objContact; 
        
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Test';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Item__c objBoat = new BOATBUILDING__Item__c();
        objBoat.Name = 'Test';
        objBoat.Account__c = objAccount.Id;
        // objBoat.Boat_Manufacturer__c =objManuFacturer1.Id ;
        insert objBoat; 
        
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        objWO.Account__c = objAccount.Id;
        objWO.Boat__c =  objBoat.Id;
        objWO.Contact__c = objContact.Id;
        objWO.Vendor__c = objManuFacturer1.Id;
        objWO.Assigned_to__c = userinfo.getuserid();
        objWO.Status__c = 'Ordered';
        objWO.BOATBUILDING__Part_Number__c = '12541254';
        objWO.BOATBUILDING__Boat_Make__c = 'test';
        objWO.Part_description__c = 'test Description';
        insert objWO;
        String strWorkRequest = WorkRequestLightningCompController.generateWorkOrder(objWO.Id);
    }
    public static TestMethod void myTest2(){
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.Email = 'shristiTesting@test.com';
        objContact.Phone = '1231231231';
        insert objContact; 
        
        Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Test';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Item__c objBoat = new BOATBUILDING__Item__c();
        objBoat.Name = 'Test';
        objBoat.Account__c = objAccount.Id;
        // objBoat.Boat_Manufacturer__c =objManuFacturer1.Id ;
        insert objBoat; 
        
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        objWO.Account__c = objAccount.Id;
        objWO.Boat__c =  objBoat.Id;
        objWO.Contact__c = null;
        objWO.Vendor__c = objManuFacturer1.Id;
        objWO.Assigned_to__c = userinfo.getuserid();
        objWO.Status__c = 'Ordered';
        objWO.BOATBUILDING__Part_Number__c = '12541254';
        objWO.BOATBUILDING__Boat_Make__c = 'test';
        objWO.Part_description__c = 'test Description, Shristi, abc_w';
        insert objWO;
        String strWorkRequest = WorkRequestLightningCompController.generateWorkOrder(objWO.Id);    
    }
}