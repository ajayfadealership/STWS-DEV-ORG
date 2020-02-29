global class BatchCaptureGoogleAnalyticsData implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BOATBUILDING__Work_Order__c> scope) {
        
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}