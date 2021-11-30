@isTest
public class ServiceScheduleControllerTest {
    private static testmethod void MyTest(){
        
        User u = [Select id, name, email from User where id=: UserInfo.getUserId()];
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        insert objWO;
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        objJob.BOATBUILDING__Completed__c = false;
        objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objWO.Id;
        insert objJob;
        Id devRecordTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.Lunch_In__c = DateTime.now();
        objTm.Lunch_Out__c = DateTime.now();
        objTm.Clock_In__c = DateTime.now();
        objTm.Schedule_Date_Time__c = DateTime.now();
        objTm.End_Schedule_Date_Time__c = DateTime.now();
        objTm.Technician__c = u.Id;
        objTm.BOATBUILDING__Related_Work_Order_Job__c = objJob.Id;
        objTm.BOATBUILDING__Work_Order__c = objWO.Id;
        objTm.RecordTypeId = devRecordTypeId;
        insert objTm;
        ServiceScheduleController.updateTechOnALlJobs(objTm.Id);
        ServiceScheduleController.fetchRelatedEvents(u.Id,'All', 'other');
        ServiceScheduleController.getUserList('other');
        ServiceScheduleController.getUserListSLGroup('other');
        ServiceScheduleController.getUsersSLocation();
        ServiceScheduleController.getrecordType();
        
    }
    private static testmethod void MyTest1(){
        User u = [Select id, name, email from User where name =: 'Ajay sharma'];
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        insert objWO;
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        objJob.BOATBUILDING__Completed__c = false;
        objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objWO.Id;
        insert objJob;
        Id devRecordTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.Lunch_In__c = DateTime.now();
        objTm.Lunch_Out__c = DateTime.now();
        objTm.Clock_In__c = DateTime.now();
        objTm.Schedule_Date_Time__c = DateTime.now();
        objTm.End_Schedule_Date_Time__c = DateTime.now();
        objTm.Technician__c = u.Id;
        objTm.Type__c = 'All';
        objTm.BOATBUILDING__Work_Order__c = objWO.Id;
        objTm.RecordTypeId = devRecordTypeId;
        insert objTm;
        
        ServiceScheduleController.fetchRelatedEvents('All', objTm.Type__c, 'other');
        ServiceScheduleController.updateTechOnALlJobs(objTm.Id);
    }
    
    private static testmethod void MyTest2(){
        User u = [Select id, name, email from User where name =: 'Ajay sharma'];
        ServiceScheduleController.fetchRelatedEvents(u.Id,'test', 'other');
        ServiceScheduleController.updateTechOnALlJobs(null);
        
    }
}