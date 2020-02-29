@isTest
private class CreateAccountControllerTest {
    
    static testMethod void myUnitTest() {
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManufacturer1.Model_Variant__c = false;
        insert objManuFacturer1;
        
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objCont = new Contact();
        objCont.AccountId = a.Id;
        objCont.lastname = 'Test contact';
        insert objCont;
        
        Map<String, String> mapAccountDetail = new Map<String, String>();
        mapAccountDetail.put('AccountName', objCont.Id);
        mapAccountDetail.put('Email', 'test@cc.in');
        mapAccountDetail.put('Phone', '9876543210');
        mapAccountDetail.put('LeadSource', 'Boat.com');
        mapAccountDetail.put('BillingStreet', 'test');
        mapAccountDetail.put('BillingPostalCode', '12345');
        mapAccountDetail.put('BillingState', 'test');
        mapAccountDetail.put('BillingCity', 'test');
        mapAccountDetail.put('ShippingStreet', 'test');
        mapAccountDetail.put('ShippingZip', 'test');
        mapAccountDetail.put('ShippingState', 'test');
        mapAccountDetail.put('ShippingCity', 'test');
        mapAccountDetail.put('FirstName', 'test');
        mapAccountDetail.put('LastName', 'test');
        mapAccountDetail.put('ItemStatus', 'YES');
        mapAccountDetail.put('BoatName', 'BoatName');
        mapAccountDetail.put('BoatHIN', 'BoatHIN');
        mapAccountDetail.put('EngineSN', 'EngineSN');
        mapAccountDetail.put('TrailerVIN', 'TrailerVIN');
        mapAccountDetail.put('BoatMake', objManuFacturer1.Id);
        mapAccountDetail.put('BoatModel', 'BoatModel');
        mapAccountDetail.put('BoatYear', '2017');
    
        
        CreateAccountController objCreateAccountController = new CreateAccountController();
        CreateAccountController.SaveAccount(mapAccountDetail);
        CreateAccountController.fetchContact(string.valueof(objCont.id));
    }
    static testMethod void myUnitTest2()
    {
        BOATBUILDING__Manufacturer__c objManuFacturer = new BOATBUILDING__Manufacturer__c();
        objManuFacturer.Name = 'Skiers Choice(Moomba)';
        objManuFacturer.Manufacturer_name__c = '1234';
        objManufacturer.Model_Variant__c = false;
        insert objManuFacturer;
        
        Id AccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Account objAccount=new Account();
        objAccount.name ='test';
        objAccount.RecordTypeId = AccountRecordTypeId;
        insert objAccount;
        
        
        
        Contact objCont1 = new Contact();
        objCont1.lastname = 'Test contact';
        objCont1.AccountId = objAccount.Id;
        insert objCont1;
        
        Map<String, String> mapAccountDetails = new Map<String, String>();
        mapAccountDetails.put('Name','test1');
        mapAccountDetails.put('Email__c', 'test@cc.in');
        mapAccountDetails.put('Phone', '9876543210');
        mapAccountDetails.put('Lead_Source__c', 'Boat.com');
        mapAccountDetails.put('BillingStreet', 'test');
        mapAccountDetails.put('BillingPostalCode', '12345');
        mapAccountDetails.put('BillingState', 'test');
        mapAccountDetails.put('BillingCity', 'test');
        mapAccountDetails.put('ShippingStreet', 'test');
        mapAccountDetails.put('ShippingZip', 'test');
        mapAccountDetails.put('ShippingState', 'test');
        mapAccountDetails.put('ShippingCity', 'test');
        mapAccountDetails.put('manufMV', 'true');
        mapAccountDetails.put('ManufId', 'test');
        
        CreateAccountController objCreateAccountController = new CreateAccountController();
        CreateAccountController.SaveAccount(mapAccountDetails);
        CreateAccountController.createManufacturer(mapAccountDetails);
    }
}