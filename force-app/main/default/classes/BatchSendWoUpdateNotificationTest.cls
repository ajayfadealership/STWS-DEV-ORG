@isTest
public class BatchSendWoUpdateNotificationTest {
    static testMethod void unitTest(){
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact; 
        
        BOATBUILDING__Update_Customer_Notification__c updateCusEmailSetting = new BOATBUILDING__Update_Customer_Notification__c();
        updateCusEmailSetting.BOATBUILDING__Email_Notification__c = true;
        updateCusEmailSetting.BOATBUILDING__Frequency_of_Reminder__c = 5;
        updateCusEmailSetting.BOATBUILDING__Task_Notification__c = False;
        updateCusEmailSetting.Name = 'STWS';
        insert updateCusEmailSetting;
        
        List<BOATBUILDING__Work_Order__c> lst= new List<BOATBUILDING__Work_Order__c>();
        BOATBUILDING__Work_Order__c objWO =  new BOATBUILDING__Work_Order__c();
        objWO.BOATBUILDING__Discount_on_Jobs__c = 122;
        objWO.BOATBUILDING__Description__c  = 'test';
        objWO.BOATBUILDING__Status__c  = 'Closed';
        objWO.BOATBUILDING__Account__c = objAccount.Id;
        objWO.BOATBUILDING__Contact__c = objContact.Id;
        objWO.BOATBUILDING__Discount__c = 2;
        objWO.BOATBUILDING__SendInvoiceToQB__c = true;
        objWO.BOATBUILDING__Customer_Last_updated__c = System.now().addDays(-10);
        lst.add(objWO);
        insert lst;
        
        Test.startTest();
        
        BatchSendWoUpdateNotification obj = new BatchSendWoUpdateNotification();
        DataBase.executeBatch(obj); 
        
        Test.stopTest(); 
        
    }
    
}