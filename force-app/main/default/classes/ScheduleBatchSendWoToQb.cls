global class ScheduleBatchSendWoToQb implements Schedulable {
   global void execute(SchedulableContext sc) {
      BatchSendWoToQb objBatchSendWoToQb = new BatchSendWoToQb(); 
      database.executebatch(objBatchSendWoToQb,1);
   }
}