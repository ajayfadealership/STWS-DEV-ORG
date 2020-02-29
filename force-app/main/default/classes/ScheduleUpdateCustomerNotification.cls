global class ScheduleUpdateCustomerNotification implements Schedulable {
    global void execute(SchedulableContext sc) {
        
        BatchSendWoUpdateNotification objBatchSendWoUpdateNotification = new BatchSendWoUpdateNotification(); 
        database.executebatch(objBatchSendWoUpdateNotification,10);      
    }
}