global with sharing class ScheduleCBHB Implements Schedulable {
        global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CalculateBilledHourBatch(), 20);
    }           
}