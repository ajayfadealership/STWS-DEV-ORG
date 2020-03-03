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
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c updateDayIn(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Day_In__c = Datetime.now();
            upsert dayIn;
            return dayIn;
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c updateLunchOut(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Lunch_Out__c = Datetime.now();
            upsert dayIn;
            return dayIn;
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c updateDayOut(BOATBUILDING__Time_Management__c dayIn){
        try{
            finalCallOut(dayIn.Id);
            return dayIn;
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    @AuraEnabled
    public static BOATBUILDING__Time_Management__c updateLunchIn(BOATBUILDING__Time_Management__c dayIn){
        try{
            dayIn.BOATBUILDING__Lunch_In__c = Datetime.now();
            upsert dayIn;
            return dayIn;
        }
        catch(Exception e)
        {
            return null;
        }
       
    }
    @AuraEnabled
    public static String finalCallOut(String tmid){
        BOATBUILDING__Time_Management__c updatedayout= [Select t.Lunch_In__c, t.Lunch_Out__c,t.Id, t.Day_In__c, t.Day_Out__c ,t.Working_Hours__c From BOATBUILDING__Time_Management__c t where t.Id = : tmid limit 1];
        updatedayout.Day_Out__c= DateTime.now();
       
        if(updatedayout.Day_In__c != null)
        {   
            Decimal dTotalTime=0.0; Decimal lTotalTime=0.0; Decimal dTotalMin; 
            Decimal dOutHr=0.0, dInHr=0.0 , dOutMin=0.0, dInMin=0.0, lOutHr=0.0, lInHr=0.0, lOutMin=0.0, lInMin = 0.0;
            dOutHr = (updatedayout.Day_Out__c).hour();
            dInHr = (updatedayout.Day_In__c).hour();
            dOutMin = (dOutHr*60 +(updatedayout.Day_Out__c).minute());
            dInMin = (dInHr * 60 + (updatedayout.Day_In__c).minute());
            System.debug('Debug Log For dOutHr: '+dOutHr);  
            System.debug('Debug Log For dInHr: '+dInHr);  
            System.debug('Debug Log For dOutMin: '+dOutMin);  
            System.debug('Debug Log For dInMin: '+dInMin);  
           
            if(updatedayout.Lunch_Out__c !=null && updatedayout.Lunch_In__c !=null){
                System.debug('Log for block : All Conditions true');
                lOutHr = (updatedayout.Lunch_Out__c).hour();
                lInHr = (updatedayout.Lunch_In__c).hour();
                lOutMin = (lOutHr * 60 + (updatedayout.Lunch_Out__c).minute());
                lInMin = (lInHr*60 + (updatedayout.Lunch_In__c).minute());
                System.debug('Debug Log For lOutHr: '+lOutHr);  
                System.debug('Debug Log For lInHr: '+lInHr);  
                System.debug('Debug Log For lOutMin: '+lOutMin);  
                System.debug('Debug Log For lInMin: '+lInMin); 
                
                if(dOutMin >= dInMin){
                System.debug('Log for block : dout greater');
                    dTotalMin = dOutMin - dInMin;
                    //dTotalTime = (dTotalMin/60).setscale(2);
                }
                else if(dInMin >= dOutMin){ 
                System.debug('Log for block : din greater');
                    dTotalMin = dInMin - dOutMin;
                    //dTotalTime = (dTotalMin/60).setscale(2);
                }
                 Decimal lTotalMin = 0.00;
                if(lOutMin >= lInMin){
                System.debug('Log for block : lout greater');
                    lTotalMin = lOutMin - lInMin;
                    //lTotalTime = (lTotalMin/60).setscale(2);
                }
                else if(lInMin >= lOutMin){
                System.debug('Log for block : lin greater');
                    lTotalMin = lInMin - lOutMin;
                    //lTotalTime = (lTotalMin/60).setscale(2);
                }
                updatedayout.Working_Hours__c = ((dTotalMin - lTotalMin)/60).setscale(2);   
            }
            else if(updatedayout.Lunch_Out__c != null && updatedayout.Lunch_In__c == null){
                lOutHr = (updatedayout.Lunch_Out__c).hour();
                lOutMin = (dInHr * 60 + (updatedayout.Lunch_Out__c).minute());
                System.debug('Log for block : Lunch in true only');
                System.debug('Debug Log For lOutHr: '+lOutHr);  
                System.debug('Debug Log For lOutMin: '+lOutMin);  
                System.debug('Debug Log For dInMin: '+dInMin);  
                //lOutMin = 296;
                
                if(dInMin >= lOutMin){
                   System.debug('Log for block : dInMin greater');
                    dTotalTime = dInMin - lOutMin; 
                    updatedayout.Working_Hours__c = (dTotalTime/60).setscale(2);
                }
                else {
                   System.debug('Log for block : lout greater');
                   dTotalTime = lOutMin - dInMin; 
                   updatedayout.Working_Hours__c = (dTotalTime/60).setscale(2);
                }
            }
            else{ 
                if(dOutMin >= dInMin){
                    System.debug('Log for block : Else dout greater');
                    dTotalMin = dOutMin - dInMin;
                    dTotalTime = (dTotalMin/60).setscale(2);
                }
                else if(dInMin >= dOutMin){
                    System.debug('Log for block : Else din greater');
                    dTotalMin = dInMin - dOutMin;
                    dTotalTime = (dTotalMin/60).setscale(2);
                }
                updatedayout.Working_Hours__c = dTotalTime;           
            }
            
            System.debug('Debug Log For total time : '+updatedayout.Working_Hours__c); 
        }
        
          
        //updatedayout.Workinghours__c = updatedayout.Day_In__c + updatedayout.Day_Out__c;
        try{
            update updatedayout;
            Database.executeBatch(new CalculateBilledHourBatch(), 20);
            return 'SUCCESS';  
        }
        catch(Exception err){
            System.debug(err);
            return 'ERROR'; 
        }   
        
    }
    
}