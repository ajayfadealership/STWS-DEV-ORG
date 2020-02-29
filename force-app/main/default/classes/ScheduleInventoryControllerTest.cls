@istest
public class ScheduleInventoryControllerTest 
{
    static testmethod void test1()
    {  
        
        
        //inserting Inventory
        BOATBUILDING__Inventory__c objInventory=new BOATBUILDING__Inventory__c();
        objInventory.BOATBUILDING__Manufacturer__c = 'Skiers Choice(Moomba)';
        insert objInventory;
        ApexPages.currentPage().getParameters().put('invId',objInventory.Id);
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.BOATBUILDING__Test_2__c = objInventory.Id;
        insert objQuote;
        ApexPages.currentPage().getParameters().put('quoteId',objQuote.Id);
                                                                 
         
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
            //UserRoleId = ur.Id
        );
        system.runAs(u)
        {
        //inserting BOATBUILDING Time Management
        Id devRecordTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();
        BOATBUILDING__Time_Management__c objTimeManag1=new BOATBUILDING__Time_Management__c();
        objTimeManag1.RecordTypeID=devRecordTypeId;
        objTimeManag1.BOATBUILDING__Logged_In_User__c=u.id;
        objTimeManag1.BOATBUILDING__Day_In__c=system.today();
        objTimeManag1.BOATBUILDING__Type__c='Event';
        insert objTimeManag1;
        }
        
        ScheduleInventoryController objScheduleInventory=new ScheduleInventoryController();
        ScheduleInventoryController.getInventory(objInventory.id);
        map<string,string>mapString=new  map<string,string>();
        ScheduleInventoryController.saveEvent(mapString);
        
        
        
    } 
    
}