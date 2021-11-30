public class TechWorkOrderHomeController {
    public TechWorkOrderHomeController() { }
    @AuraEnabled
    public static List<WorkOrderWrapper> getTechnicianJobByDate(Integer dateRange, String technician){
        Set<String> setWOId = new Set<String>();
        List<BOATBUILDING__Time_Management__c> lstTimeMgmt = new List<BOATBUILDING__Time_Management__c>();
        Date dateRange1 = Date.Today().addDays(-dateRange) ;
       // Integer intDateRange = Integer.valueOf(dateRange);
        lstTimeMgmt = [SELECT Id, BOATBUILDING__Schedule_Date_Time__c, BOATBUILDING__Technician__c, 
                       BOATBUILDING__Related_Work_Order_Job__c,BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                       BOATBUILDING__Work_Order__c,BOATBUILDING__Work_Order__r.Name,BOATBUILDING__Work_Order__r.BOATBUILDING__Contact__r.Name,
                       BOATBUILDING__Work_Order__r.BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c FROM BOATBUILDING__Time_Management__c 
                       WHERE BOATBUILDING__Technician__c =:technician 
                       AND 
                       //BOATBUILDING__Schedule_Date_Time__c =: LAST_N_DAYS: intDateRange ];
                       BOATBUILDING__Schedule_Date_Time__c <= TODAY AND BOATBUILDING__Schedule_Date_Time__c >= :dateRange1];   
        System.debug('>>>>>lstTimeMgmt'+ lstTimeMgmt);
        
        List<WorkOrderWrapper> lstWOWrap = new  List<WorkOrderWrapper>();
        
        for(BOATBUILDING__Time_Management__c objTM: lstTimeMgmt){
             WorkOrderWrapper objWOWrap = new WorkOrderWrapper();
            if(objTM.BOATBUILDING__Work_Order__c != null && !setWOId.contains(objTM.BOATBUILDING__Work_Order__c)){
            objWOWrap.WOId = objTM.BOATBUILDING__Work_Order__c ;
            objWOWrap.WOName =objTM.BOATBUILDING__Work_Order__r.Name;
            if(objTM.BOATBUILDING__Work_Order__r.BOATBUILDING__Contact__r.Name != null) {
                objWOWrap.CustomerName = objTM.BOATBUILDING__Work_Order__r.BOATBUILDING__Contact__r.Name;
            }
            if(objTM.BOATBUILDING__Work_Order__r.BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c != null) {
                objWOWrap.BoatName = objTM.BOATBUILDING__Work_Order__r.BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c ;
            }
                  lstWOWrap.add(objWOWrap);
                setWOId.add(objWOWrap.WOId);
            }
          
              
        }
        System.debug('>>>>lst of WO wrapper '+ lstWOWrap);
        return lstWOWrap;
    }
    
    @RemoteAction
    public static List<User> getUserDetails(String strUser) {
        List<User> lstUser = new List<User>(); 
        strUser = '%'+strUser+'%';
        lstUser = [Select Id, Name, Email From User Where Name LIKE :strUser AND isActive = true Limit 1000 ];
        return lstUser;
    }
    @AuraEnabled
    public static List<Object> getTodaysWO() {
       
        List<BOATBUILDING__Time_Management__c> lstTM = [SELECT Id, BOATBUILDING__Work_Order__c, BOATBUILDING__Related_Work_Order_Job__c 
                                                        FROM BOATBUILDING__Time_Management__c 
                                                        WHERE RecordType.DeveloperName = 'Schedule' AND BOATBUILDING__Schedule_Date_Time__c <= TODAY 
                                                        AND BOATBUILDING__End_Schedule_Date_Time__c >= TODAY];
        System.debug('>>> lstTM :'+lstTM);
         List<WorkOrderWrapper> lstWorkOrderWrapper = new List<WorkOrderWrapper>();
        if(!lstTM.isEmpty()) {
            Set<String> setWOId = new Set<String>();
            Set<String> setWOJId = new Set<String>();
            for(BOATBUILDING__Time_Management__c objTM: lstTM) {
                if(objTM.BOATBUILDING__Related_Work_Order_Job__c != null) {
                    setWOJId.add(objTM.BOATBUILDING__Related_Work_Order_Job__c);
                }
                if(objTM.BOATBUILDING__Work_Order__c != null) {
                    setWOId.add(objTM.BOATBUILDING__Work_Order__c);
                }
            }
            if(!setWOJId.isEmpty()) {
                List<BOATBUILDING__Work_Order_Job__c> lstWOJ = [SELECT Id, BOATBUILDING__Work_Order_Warranty_Work_Order__c FROM BOATBUILDING__Work_Order_Job__c Where Id IN: setWOJId];
                for(BOATBUILDING__Work_Order_Job__c objJob : lstWOJ) {
                    if (objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                        setWOId.add(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
                    }
                }
            }
            if(!setWOId.isEmpty()) {
                List<BOATBUILDING__Work_Order__c> lstWO = [SELECT 
                                                           Id, BOATBUILDING__Contact__c, BOATBUILDING__Contact__r.Name, BOATBUILDING__BOAT__c, 
                                                           BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c, Name 
                                                           FROM BOATBUILDING__Work_Order__c Where Id IN: setWOId ORDER BY CreatedDate DESC Limit 10];
                for(BOATBUILDING__Work_Order__c objWO: lstWO) {
                    WorkOrderWrapper objWorkOrderWrapper = new WorkOrderWrapper();
                    objWorkOrderWrapper.WOId = objWO.Id;
                    objWorkOrderWrapper.WOName = objWO.Name; 
                    if(objWO.BOATBUILDING__Contact__c != null) {
                        objWorkOrderWrapper.CustomerName = objWO.BOATBUILDING__Contact__r.Name;
                    }
                    if(objWO.BOATBUILDING__BOAT__c != null 
                       && objWO.BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c != null) {
                           objWorkOrderWrapper.BoatName = objWO.BOATBUILDING__BOAT__r.BOATBUILDING__Boat_HIN_No__c;
                       }
                    lstWorkOrderWrapper.add(objWorkOrderWrapper);
                }
                
            }
        }
        
        return lstWorkOrderWrapper;
    }
    @AuraEnabled
    public static List<User> getUser(String strUserId) {
        strUserId = '%'+strUserId+'%';
        return [SELECT Id, Name, Email FROM User Where Name LIKE :strUserId AND IsActive = true];
    } 
    @AuraEnabled
    public static User getCurrentUser() {
        return [SELECT Id, Name, Email FROM User Where Id =: UserInfo.getUserId() LIMIT 1];
    } 
    public class WorkOrderWrapper {
        @AuraEnabled public String WOId { get; set; }
        @AuraEnabled public String WOName { get; set; }
        @AuraEnabled public String CustomerName { get; set; }
        @AuraEnabled public String BoatName { get; set; }
    }
    
}