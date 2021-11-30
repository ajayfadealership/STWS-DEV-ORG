@isTest
public class RecordEventActivityControllerTest {
    static testMethod void unitTest(){

        List<String> setCommentTypes = new  List<String>();
        setCommentTypes.add('Customer Comment');
        setCommentTypes.add('Comment for Customer');
        Account objAcc = new Account();
        objAcc.Name='Test';
        objAcc.Phone='12345678';
        insert objAcc;

        contact objCont = new contact();
        objCont.AccountId = objAcc.id;
        objCont.LastName = 'test';
        objCont.FirstName = 'Test Con';
        insert objCont;

        BOATBUILDING__Work_Order__c objOrder = new BOATBUILDING__Work_Order__c();
        objOrder.BOATBUILDING__Contact__c = objCont.Id;
        objOrder.BOATBUILDING__Boat_Make__c = 'test';
        insert objOrder;
       
        
        Event objEvent = new Event();
        objEvent.Subject = 'test';
        objEvent.Description = 'test';
        objEvent.whatId = objOrder.Id;
        objEvent.DurationInMinutes = 2;
        objEvent.ActivityDateTime = Datetime.now();
        objEvent.Type = 'Comment for Technician';   
        insert objEvent;

        
        RecordEventActivityController.getAllEventsForJob(objOrder.Id,setCommentTypes);
      
        

    }
    static testMethod void unitTest1(){
        
        List<String> setCommentTypes = new  List<String>();
        setCommentTypes.add('All');
        User us = [select id ,name from user where name = 'Ajay Sharma'];
        Account objAcC = new Account();
        objAcc.Name='Test';
        objAcc.Phone='12345678';
        insert objAcc;

        contact objCont = new contact();
        objCont.AccountId = objAcc.id;
        objCont.LastName = 'test';
        objCont.FirstName = 'Test Con';
        insert objCont;
        
        BOATBUILDING__Work_Order__c objOrder = new BOATBUILDING__Work_Order__c();
        objOrder.BOATBUILDING__Contact__c = objCont.Id;
        objOrder.BOATBUILDING__Boat_Make__c = 'test';
        insert objOrder;
        Event objEvent = new Event();
        objEvent.Subject = 'test1';
        objEvent.Description = 'test2';
        objEvent.whatId = objOrder.Id;
        objEvent.DurationInMinutes = 2;
        objEvent.ActivityDateTime = Datetime.now();
        objEvent.Type = 'Comment for Technician';
        insert objEvent;
        
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
        objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objOrder.Id;
        objWOJ.Technician__c = us.Id; 
        insert objWOJ;
        Test.startTest();
       //  RecordEventActivityController.getAllEventsForJob(objOrder.Id,setCommentTypes);
        //  RecordEventActivityController.addCustomerComment('test','test comment',objEvent.whatId,objOrder.Id,objAcc.Id,'Work Order Section');
        RecordEventActivityController.doChatterPostFromTechToServiceWriter('test comment' ,objWOJ.Id);
        RecordEventActivityController.doChatterPostFromServiceWriterToTechnician('test comment' ,objWOJ.Id);
        Test.stopTest();
        
    }
    
}