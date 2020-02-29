global class ScheduleBatchGoogleAnalytics implements Schedulable {
   global void execute(SchedulableContext sc) {
      BOATBUILDING.GoogleAnalyticsTokenRefresh objBatchSchedule = new BOATBUILDING.GoogleAnalyticsTokenRefresh(); 
      database.executebatch(objBatchSchedule,1);
   }
}