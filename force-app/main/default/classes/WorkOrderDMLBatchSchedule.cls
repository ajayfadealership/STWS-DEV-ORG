global class WorkOrderDMLBatchSchedule implements Schedulable {
    global WorkOrderDMLBatchSchedule() { }
    global void execute(SchedulableContext sc) {
        WorkOrderDMLBatch objWorkOrderDMLBatch = new WorkOrderDMLBatch(); 
        database.executebatch( objWorkOrderDMLBatch, 200 );
    }
}