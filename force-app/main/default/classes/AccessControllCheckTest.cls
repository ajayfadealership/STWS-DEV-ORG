@isTest
private class AccessControllCheckTest {

    private static testMethod void test() {
            
            BOATBUILDING__AccessController__c objAccessController = new BOATBUILDING__AccessController__c();
            objAccessController.Name= '00D4E0000008pEIUAY';
            objAccessController.AccessKey__c= 'QUYyJ4a21U8JbFn3YbwmWIFVs8SF6f19HquKbO8xWKU';
            objAccessController.EncryptionKey__c= '4632260440328417';
            insert objAccessController;      
            
            AccessControllCheck.ckeckAccess();
    }
    
    private static testMethod void test1() {   
     
            Test.startTest();
                Test.setMock(HttpCalloutMock.class, new AccessControllCheckMock());
                AccessControllCheck.ckeckAccess();
            Test.stopTest(); 
    }
}