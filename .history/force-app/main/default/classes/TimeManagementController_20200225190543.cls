public class TimeManagementController {
    @AuraEnabled
    public static List<BOATBUILDING__Time_Management__c> getTimeManagement(){
        Id recId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Standard Time Sheet').getRecordTypeId();
        List <BOATBUILDING__Time_Management__c> recordlist= [Select t.Day_In__c,t.Id,t.Day_Out__c,t.Working_Hours__c,t.Lunch_Out__c,t.Lunch_In__c From BOATBUILDING__Time_Management__c t where createddate= today and RecordTypeId =: recId and ownerid =: userinfo.getUserId() ORDER BY CreatedDate DESC Limit 1];
        return recordlist;
        
    }
    
}