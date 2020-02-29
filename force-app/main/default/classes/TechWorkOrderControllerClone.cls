/** 
* Author:               Akshay Kumar
* Organization:         CloudCodiots LLP. 
* Created Date:         13/02/2017 
* Last Modified Date:   13/02/2017 
*/


public with sharing class TechWorkOrderControllerClone {

//--------------------------------------Tech Work Order---------------------------------------//
    public BOATBUILDING__Work_Order_Job__c objJob2 { get; set; }
    public BOATBUILDING__Work_Order__c objCaseForTWO {get; set; }
    
    public TechWorkOrderControllerClone(){
        objJob2 = new BOATBUILDING__Work_Order_Job__c(); 
        objCaseForTWO = new BOATBUILDING__Work_Order__c();
    }

    
    
    @RemoteAction
    public static List<Object> getDetailsOfWrkOrder(String WrkOrderId){
      
        List<Object> lstFinalList = new List<Object>();
        List<RecordType> lstRecType = [SELECT 
                                                Id 
                                       FROM 
                                                RecordType 
                                       WHERE 
                                                SobjectType = 'BOATBUILDING__Work_Order__c' 
                                       AND 
                                                (
                                                        DeveloperName = 'Work_Order'
                                                    OR
                                                        DeveloperName = 'Warranty_Work_Order'
                                                )
                                                limit 2];
              
      if(lstRecType.size()>0) {
                
            List<BOATBUILDING__Work_Order__c> lstCase = [SELECT 
                                            BOATBUILDING__Account__c,
                                            BOATBUILDING__Contact__c,
                                            BOATBUILDING__ContactEmail__c,
                                            BOATBUILDING__Contact__r.Name,
                                            BOATBUILDING__Contact__r.FirstName,
                                            BOATBUILDING__Contact__r.LastName,
                                            BOATBUILDING__Contact__r.MailingStreet,
                                            BOATBUILDING__Contact__r.Email,
                                            BOATBUILDING__Contact__r.MailingPostalCode,
                                            BOATBUILDING__Contact__r.MailingCity,
                                            RecordType.Name,
                                            RecordTypeId,
                                            Boat__c,
                                            Store_Location__c, 
                                            Boat__r.Name,
                                            Boat__r.Boat_Model__c,
                                            Boat__r.Engine_Model__c,
                                            Boat__r.M_Boat_Year__c,
                                            Boat__r.Boat_HIN_No__c,
                                            Boat__r.CreatedDateCustom__c,
                                            BOATBUILDING__Boat__r.BOATBUILDING__Engine_SN__c,
                                            Name,
                                            Drive__c,
                                            Hours__c,
                                            BOATBUILDING__Status__c,
                                            BOATBUILDING__Priority__c,
                                            BOATBUILDING__ContactPhone__c,
                                            Total_Parts__c,
                                            Total_Labor__c,
                                            Total_Shop_Supplies__c,
                                            Total__c,
                                            Sales_Tax__c,
                                            Total_Amount_Due__c,
                                            BOATBUILDING__Total_Payment_payment__c,
                                            Balance__c,
                                            ID
                                    FROM 
                                            BOATBUILDING__Work_Order__c
                                    WHERE 
                                            RecordTypeId IN: lstRecType 
                                    AND 
                                            ID =: WrkOrderId
                                    ];

                if(lstCase.size()>0){
                        lstFinalList.add(lstCase);
                        List<BOATBUILDING__Work_Order_Job__c> joblist = [Select 
                                                        Work_Type__c, 
                                                        Type__c, 
                                                        Name, 
                                                        No_of_Labors__c, 
                                                        Price_per_Labor__c, 
                                                        Total_Cost_Labor__c, 
                                                        Shop_Supplies_Total__c, 
                                                        Total_Amount_Job__c, 
                                                        Customer_Pay__c,
                                                        Total_Hours_Job__c,
                                                        Worked_Hours__c,
                                                        Id,
                                                        Job_Name__c,
                                                        
                                                        Work_Requested__c,
                                                        BOATBUILDING__Completed__c,
                                                        BOATBUILDING__TWO_Worked_Hour__c,
                                                        BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Description__c    ,
                                                        Comments__c,
                                                            (Select
                                                                    Id,
                                                                    Name,
                                                                    Part_Number__c,
                                                                    Part_Name__c,
                                                                    Quantity__c,
                                                                    Price__c,
                                                                    Total__c,
                                                                    Related_to_Job__c
                                                            From 
                                                                    BOATBUILDING__Work_Order_Job_Line_Items__r 
                                                            ), 
                                                            (SELECT Id,BOATBUILDING__Clock_In__c,BOATBUILDING__Clock_Out__c, Status__c, Service_writer_comment__c, Technician__c, Technician__r.Name	  
                                                            FROM BOATBUILDING__Time_Management__r where BOATBUILDING__Clock_In__c != null AND BOATBUILDING__Clock_Out__c =null 
                                                            Order BY BOATBUILDING__Clock_In__c DESC limit 1)
                                            From 
                                                        BOATBUILDING__Work_Order_Job__c where BOATBUILDING__Work_Order_Warranty_Work_Order__c =: lstCase[0].Id];
                      System.debug('====joblist==='+joblist);
                      if(joblist.size() > 0){
                        lstFinalList.add(joblist); 
                     } else {
                        lstFinalList.add(new List<BOATBUILDING__Work_Order_Job__c>());
                     }
                }
        }
             
                
           
            System.debug('Debug Log for Final List'+lstFinalList);
            
            lstFinalList.add(BOATBUILDING__WorkTypePricing__c.getAll().values());  
            
            if(lstFinalList.size()>0){
                return lstFinalList; 
            }
            else{
                return null;
            }
           
    }
    @RemoteAction
    public static BOATBUILDING__Time_Management__c insertclockin(String JobId){
         
        Boolean isError = false;
        BOATBUILDING__Work_Order_Job__c SelectedJob = [Select 
                                                            Work_Type__c, 
                                                            Type__c, 
                                                            Name, 
                                                            No_of_Labors__c, 
                                                            Price_per_Labor__c, 
                                                            Total_Cost_Labor__c, 
                                                            Shop_Supplies_Total__c, 
                                                            Total_Amount_Job__c, 
                                                            Customer_Pay__c,
                                                            Total_Hours_Job__c,
                                                            BOATBUILDING__TWO_Worked_Hour__c,
                                                            Worked_Hours__c,
                                                            Id
                                                From 
                                                            BOATBUILDING__Work_Order_Job__c where Id =: JobId
                                                            LIMIT 1
                                                            ];
        System.debug('Debug Log for WorkedHours'+SelectedJob.Worked_Hours__c);
        System.debug('Debug Log for Total Hours'+SelectedJob.Total_Hours_Job__c);
        if(SelectedJob.Id != null ) {
            String RecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Time_Management__c' AND DeveloperName = 'Time_Management_for_Jobs' limit 1].Id;
            BOATBUILDING__Time_Management__c insertclockin = new BOATBUILDING__Time_Management__c();
            insertclockin.RecordTypeId = RecordType;
            insertclockin.Clock_In__c = DateTime.now();
            //insertclockin.Related_to_Job__c = JobId;
            //commented above line to fix time chehck in vivek on 27/7/2017
            insertclockin.Related_Work_Order_Job__c = JobId;
            insertclockin.BOATBUILDING__Technician__c = UserInfo.getUserId();
            try{ 
                insert insertclockin;
                //return insertclockin.id;
            }
            catch(Exception err){
                System.debug(err);
                isError = true;
            }   
            if(isError == true){
                return null;    
            }
            insertclockin = [Select Id, Clock_In__c, Related_Work_Order_Job__c, BOATBUILDING__Technician__c, BOATBUILDING__Technician__r.Name 
        						From BOATBUILDING__Time_Management__c Where Id =: insertclockin.Id Limit 1];
            return insertclockin; 
            
        }
        return null;
    }
    
    @RemoteAction
    public static BOATBUILDING__Time_Management__c updateclockout(String JobId, String tmid ){
        Boolean isError1 = false;
        String RecordType = [SELECT Id 
                                    FROM 
                                    RecordType 
                                    WHERE 
                                    SobjectType = 'BOATBUILDING__Time_Management__c' 
                                    AND 
                                    DeveloperName = 'Time_Management_for_Jobs' 
                                    limit 1].Id;
        BOATBUILDING__Time_Management__c updateclockout = [Select Clock_In__c, 
                                                    Clock_Out__c, 
                                                    Number_of_Hours_Worked__c,
                                                    Related_to_Job__c,
                                                    
                                                    Related_to_Job__r.Worked_Hours__c,Related_Work_Order_Job__r.Worked_Hours__c
                                                    From 
                                                    BOATBUILDING__Time_Management__c 
                                                    where 
                                                    Related_Work_Order_Job__c =: JobId and 
                                                    RecordTypeId =: RecordType and 
                                                    Id =: tmid 
                                                    limit 
                                                    1]; 
        updateclockout.Clock_Out__c = DateTime.now();
        Decimal clockInHr = 0.0, clockInMin = 0.0, currentHr = 0.0, currentMin = 0.0 , totalTime = 0.0, DtotalTime = 0.0  ;
        clockInHr = (updateclockout.Clock_In__c).hour();
        clockInMin = (clockInHr * 60 + (updateclockout.Clock_In__c).minute());
        DateTime dt = datetime.now();
        currentHr = dt.hour();
        currentMin = (currentHr * 60 + dt.minute());
        if(currentMin > clockInMin){
            totalTime = currentMin - clockInMin;
        }
        else{
            totalTime = clockInMin - currentMin;
        }
        
        DtotalTime = (totalTime/60).setscale(2);
        System.debug('Log for current hour----'+currentHr);
        System.debug('Log for current Minute----'+currentMin);
        updateclockout.Number_of_Hours_Worked__c = DtotalTime;
        if(updateclockout.Related_Work_Order_Job__r.Worked_Hours__c!=null)
            updateclockout.Related_Work_Order_Job__r.Worked_Hours__c += updateclockout.Number_of_Hours_Worked__c;
        
        try{
            update updateclockout;
            update updateclockout.Related_Work_Order_Job__r;
        }
        catch(Exception err){
            System.debug(err);
            return null;
        }   
           return updateclockout;
    }
    
    @RemoteAction
    public static BOATBUILDING__Time_Management__c addCommentonJob(String TimeMgmtID,String comment,string servicewritercom){
        
        if(TimeMgmtID != null){
            String RecordType = [SELECT Id 
                                    FROM 
                                    RecordType 
                                    WHERE 
                                    SobjectType = 'BOATBUILDING__Time_Management__c' 
                                    AND 
                                    DeveloperName = 'Time_Management_for_Jobs' 
                                    limit 1].Id;
            BOATBUILDING__Time_Management__c SelectedTimeEntry = [Select 
                                                            Clock_In__c, 
                                                            Clock_Out__c, 
                                                            Number_of_Hours_Worked__c,
                                                            Related_Work_Order_Job__c,
                                                            Related_to_Job__r.Worked_Hours__c,
                                                            Status__c,Service_writer_comment__c,Related_Work_Order_Job__r.Worked_Hours__c,
                                                            Related_Work_Order_Job__r.Name,
                                                            Related_Work_Order_Job__r.Job_Name__c,
                                                            Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                                                            Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c,
                                                            Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c
                                                    From 
                                                            BOATBUILDING__Time_Management__c 
                                                    where 
                                                            RecordTypeId =: RecordType
                                                    and 
                                                            Id =: TimeMgmtID 
                                                            limit 1]; 
            
            if(SelectedTimeEntry.Id != null){
                SelectedTimeEntry.Status__c = (comment != null ? comment :'');
                SelectedTimeEntry.Service_writer_comment__c = (servicewritercom != null ? servicewritercom :'');
                try{
                    update SelectedTimeEntry;
                	RecordEventActivityController.addCustomerComment('Tech Comment @ '+SelectedTimeEntry.Related_Work_Order_Job__r.Job_Name__c,
							                    						servicewritercom, 
							                    							SelectedTimeEntry.Related_Work_Order_Job__c, 
							                    								SelectedTimeEntry.Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, 
							                    									SelectedTimeEntry.Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c, 'Tech Comment');
                    
                }
                catch(Exception ex) {
                    System.debug('Debug Log for Exception while updating Comment on TimeSheet' +ex.getMessage()+' : '+ex.getLineNumber()+' : '+ex.getStackTraceString());
                    return null;
                }
                return SelectedTimeEntry;
            }
        }
        return null;
    }
   
    
    @RemoteAction
    public static String updateHoursWO(String strWOId, String strHours) {
        BOATBUILDING__Work_Order__c objWO = [SELECT Id, Hours__c FROM BOATBUILDING__Work_Order__c WHERE Id =: strWOId LIMIT 1];
        try {
            objWO.Hours__c = strHours;
            update objWO;       
            return 'SUCCESS';
        }
        catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex); 
            return null;
        }
    }
    
    @RemoteAction
    public static String fetchOOWH(String strJID) {
        return String.valueOf([Select Id, BOATBUILDING__TWO_Worked_Hour__c From Work_Order_Job__c Where Id =: strJID LIMIT 1].BOATBUILDING__TWO_Worked_Hour__c);
    }
    
    @RemoteAction
    public static String updateEngineSN(String woId, String strEnSnVal) {
        try {
            BOATBUILDING__Work_Order__c objTWO = [SELECt Id, BOATBUILDING__Boat__c, BOATBUILDING__Boat__r.BOATBUILDING__Engine_SN__c FROM BOATBUILDING__Work_Order__c WHERE Id =: woId LIMIT 1];
            if(objTWO.BOATBUILDING__Boat__c != null) {
                BOATBUILDING__Item__c objItm = [SELECT Id, BOATBUILDING__Engine_SN__c FROM BOATBUILDING__Item__c WHERE Id =: objTWO.BOATBUILDING__Boat__c LIMIT 1]; 
                objItm.BOATBUILDING__Engine_SN__c = strEnSnVal;   
                update objItm;
            }  
        } catch(Exception ex) {
            return 'Exception: '+ex;
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static String completeTheJob(String strJobId, String status) {
        try {
            Work_Order_Job__c objJob =   [Select Id, BOATBUILDING__Completed__c From Work_Order_Job__c Where Id =: strJobId LIMIT 1];
            objJob.BOATBUILDING__Completed__c = status == '1' ? true : false;
            update objJob; 
        } catch(Exception ex) {
            return 'Exception: '+ex;
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static List<String> getCommentList(String strJobId) {
        List<String> lstString = new List<String>();
        List<BOATBUILDING__Time_Management__c> lstTM = [Select 
        															Id,
        															Name, 
        															Service_writer_comment__c 
														From 
																BOATBUILDING__Time_Management__c 
														Where 
																Related_Work_Order_Job__c =: strJobId 
														AND 
																RecordType.DeveloperName = 'Time_Management_for_Jobs'
														ORDER By 
																CreatedDate DESC];
        for(BOATBUILDING__Time_Management__c objTM: lstTM) {
        		if(objTM.Service_writer_comment__c != null) {
        			lstString.add(objTM.Name + ' : ' + objTM.Service_writer_comment__c);
        		}
        }
        return lstString;
    }
    //--------------------------------------Tech Work Order---------------------------------------//


}