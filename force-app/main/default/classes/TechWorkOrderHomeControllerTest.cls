@isTest
public class TechWorkOrderHomeControllerTest {
    private static testmethod void MyTest(){
        TechWorkOrderHomeController objTechWorkOrderHomeController = new TechWorkOrderHomeController();
        List<User> lstUser = [SELECT Id , Name  FROM User Where Name =:'Ajay Sharma'];
        
        BOATBUILDING__Item__c objBoat = new BOATBUILDING__Item__c();
        objBoat.BOATBUILDING__Boat_HIN_No__c = 'test';
        insert objBoat;
        
         Account objAcc = new Account();
        objAcc.Name = 'test';
        insert objAcc;
        
        Contact objCont = new Contact();
        objCont.AccountId = objAcc.Id;
        objCont.LastName = 'test';
        insert objCont;
        
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        objWO.BOATBUILDING__Boat__c = objBoat.Id;
        objWO.BOATBUILDING__Contact__c = objCont.Id;
        insert objWO;
        
        BOATBUILDING__Work_Order_Job__c objWOJob = new BOATBUILDING__Work_Order_Job__c();
        objWOJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objWO.Id ;
        insert objWOJob;
        
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.BOATBUILDING__Technician__c = lstUser[0].Id;
        objTm.BOATBUILDING__Schedule_Date_Time__c = DateTime.Now().AddDays(-1);
        objTm.BOATBUILDING__End_Schedule_Date_Time__c = DateTime.Now().AddDays(1);
        objTm.BOATBUILDING__Work_Order__c = objWO.Id;
        objTm.BOATBUILDING__Related_Work_Order_Job__c = objWOJob.Id;
        objTm.RecordTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();         
        insert objTm;
        System.debug('>>>>objTm>>'+objTm);
      TechWorkOrderHomeController.WorkOrderWrapper objWorkOrderWrapper = new TechWorkOrderHomeController.WorkOrderWrapper();
       objWorkOrderWrapper.CustomerName = 'Ajay Sharma';
        
        TechWorkOrderHomeController.getUserDetails('Ajay Sharma');
       
        TechWorkOrderHomeController.getCurrentUser();
        TechWorkOrderHomeController.getUser('Ajay Sharma');
      	TechWorkOrderHomeController.getTechnicianJobByDate(3,lstUser[0].Id);
        TechWorkOrderHomeController.getTodaysWO();
        
    }

}