public class TimeManagementController {
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c getTimeManagement(){
        Id recId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Standard Time Sheet').getRecordTypeId();
        List <BOATBUILDING__Time_Management__c> recordlist= [Select t.Day_In__c,t.Id,t.Day_Out__c,t.Working_Hours__c,t.Lunch_Out__c,t.Lunch_In__c From BOATBUILDING__Time_Management__c t where CreatedDate = today and RecordType.Name = 'Standard Time Sheet' and OwnerId =: UserInfo.getUserId() ORDER BY CreatedDate DESC Limit 1];
        if(recordlist.size() > 0){
            return recordlist[0];
        }else{
            BOATBUILDING__Time_Management__c objTM = new BOATBUILDING__Time_Management__c();
            objTM.RecordTypeId = recId;
            objTM.Logged_In_User__c = UserInfo.getUserId();
            objTM.BOATBUILDING__Technician__c = UserInfo.getUserId();
            return objTM;
        }
        
        
    }
    
}