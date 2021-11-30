@isTest
public class WorkOrderDMLBatchScheduleTest {
    static testMethod void workOrderDMLBatchScheduleTest() {
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon; 
        BOATBUILDING__Work_Order__c objWk = new BOATBUILDING__Work_Order__c(
            BOATBUILDING__Account__c= objAcc.Id,
            BOATBUILDING__Contact__c=objCon.Id
        );
        insert objWk;     
        Time_Management__c objTime = new Time_Management__c(    
            BOATBUILDING__Work_Order__c = objWk.Id, 
            RecordTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId(),
            BOATBUILDING__Schedule_Date_Time__c = Date.today().addDays(2)
        );
        insert objTime;     
        WorkOrderDMLBatchSchedule objWorkOrderDMLBatchSchedule = new WorkOrderDMLBatchSchedule();
        String sch = '0 0 23 * * ?'; 
        System.schedule('Test WorkOrderDMLBatchSchedule Check', sch, objWorkOrderDMLBatchSchedule);
        WorkOrderDMLBatch objWorkOrderDMLBatch = new WorkOrderDMLBatch();
        database.executeBatch(objWorkOrderDMLBatch);
    }
}