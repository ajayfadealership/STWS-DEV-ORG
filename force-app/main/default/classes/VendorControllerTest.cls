@isTest
private class VendorControllerTest{
    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        insert objManuFacturer1;
    
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        Map<String,String> objMap = new Map<String,String>();
        objMap.put('Name','test1');
        objMap.put('Phone','123415674890');
        objMap.put('ContactPerson',String.valueOf(objContact.Id));
        objMap.put('Email','test1@gmail.com');
        objMap.put('Street','test1');
        objMap.put('City','test');
        objMap.put('State','test1');
        objMap.put('Zip','test1');
        objMap.put('Terms','test1');
        
        VendorController.saveDetails(objMap);
        new VendorController().getlstOfManu();
        
    }
}