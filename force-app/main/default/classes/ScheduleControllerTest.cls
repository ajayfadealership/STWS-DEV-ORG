@isTest
public class ScheduleControllerTest {
    
    Public static  testMethod void myUnitTest2(){
        ScheduleController objR = new ScheduleController();  
        Profile q = [SELECT Id FROM Profile WHERE Name = 'System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = q.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='standardasdasdasdsdasduserbnvhv@testorg.com');
        User r = [Select Id From User Limit 1];
        r.UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'GM' Limit 1 ].Id;
        insert u;
        ScheduleController.getUserDetails();
        BOATBUILDING__Time_Management__c objT= new BOATBUILDING__Time_Management__c();
        Id RecordTypeId1 =  Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();
        objT.RecordTypeId = RecordTypeId1;
        objT.BOATBUILDING__Event_Id__c='1234';
        objT.BOATBUILDING__End_Schedule_Date_Time__c= Date.newInstance(2016,12,9);
        objT.BOATBUILDING__Type__c = 'All';
        objT.BOATBUILDING__Schedule_Date_Time__c = Date.newInstance(2016,12,8);
        objT.BOATBUILDING__Technician__c  =UserInfo.getUserId();
        //ObjT.BOATBUILDING__Related_Work_Order_Job__c= UserInfo.getUserId();
        
        insert objT;
        Map<String, String> MyMap = new map<String, String>();
        MYMap.put('StartDate','2019-12-31T23:59');
        MYMap.put('EndDate','2020-12-31T23:59');
        
        BOATBUILDING__Work_Order__c ObjW= new  BOATBUILDING__Work_Order__c();
        
        insert ObjW;
        ScheduleController.deleteEvent(objT.BOATBUILDING__Event_Id__c);  
        ScheduleController.fetchRelatedEvents('All','All');
        //ScheduleController.fetchRelatedEvents('All','ABC')   
        objT.BOATBUILDING__Type__c = 'ABC';
        update objT;
        ScheduleController.fetchRelatedEvents('All','ABC');
        ScheduleController.fetchRelatedEvents(UserInfo.getUserId(),'All');
        ScheduleController.fetchRelatedEvents(UserInfo.getUserId(),'ABC');
        ScheduleController.fetchRelatedEventsWithType('ABC', 'All');   
        ScheduleController.fetchRelatedEventsWithType('All','All' );  
        ScheduleController.fetchRelatedEventsWithType('All',UserInfo.getUserId()); 
        ScheduleController.fetchRelatedEventsWithType('ABC',UserInfo.getUserId()); 
        ScheduleController.fetchRelatedWorkOrders('r1.UserRoleId');
        ScheduleController.resizeEvent('Date.newInstance(2016,12,9)',ObjT.Id);
        ScheduleController.drageEvent( 'Date.newInstance(2016,12,8)','Date.newInstance(2016,12,9)',ObjT.Id);
        ScheduleController.SaveEvent(MyMap);
        ScheduleController.SaveEventPD(MyMap);
        
        ScheduleController.updateEvent(MyMap);
        
        ScheduleController.checkEvent(ObjT.Id);
        ScheduleController.fetchWorkOrder(ObjW.Id);
        
        
    }
    
    
    
    
    
}