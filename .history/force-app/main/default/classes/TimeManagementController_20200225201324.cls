public class TimeManagementController {
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c getTimeManagement(){
        Id recId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Standard Time Sheet').getRecordTypeId();
        List <BOATBUILDING__Time_Management__c> recordlist= [Select BOATBUILDING__Day_In__c,Id,BOATBUILDING__Day_Out__c,BOATBUILDING__Working_Hours__c,BOATBUILDING__Lunch_Out__c,BOATBUILDING__Lunch_In__c From BOATBUILDING__Time_Management__c where CreatedDate = today and RecordType.Name = 'Standard Time Sheet' and OwnerId =: UserInfo.getUserId() ORDER BY CreatedDate DESC Limit 1];
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
    public static BOATBUILDING__Time_Management__c updateDayIn(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Day_In__c = Datetime.now();
            upsert dayIn;
            return getTimeManagement();
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    public static BOATBUILDING__Time_Management__c updateLunchOut(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Lunch_Out__c = Datetime.now();
            upsert dayIn;
            return getTimeManagement();
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    public static BOATBUILDING__Time_Management__c updateDayOut(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Day_Out__c = Datetime.now();
            upsert dayIn;
            return getTimeManagement();
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    public static BOATBUILDING__Time_Management__c updateLunchIn(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Lunch_In__c = Datetime.now();
            upsert dayIn;
            return getTimeManagement();
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    
}