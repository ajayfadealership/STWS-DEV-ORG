public with sharing class TechWorkOrderDetailController {
    public TechWorkOrderDetailController() { }
    @AuraEnabled
    public static List<Object> getWorkOrderDetail(String strRecId) {
        List<Object> lstFinalList = new List<Object>();
        BOATBUILDING__Work_Order__c objWO = [SELECT BOATBUILDING__Account__c, BOATBUILDING__Contact__c, BOATBUILDING__ContactEmail__c, BOATBUILDING__Contact__r.Name,
                                                            BOATBUILDING__Contact__r.FirstName, BOATBUILDING__Contact__r.LastName, BOATBUILDING__Contact__r.MailingStreet, BOATBUILDING__Contact__r.Email,
                                                            BOATBUILDING__Contact__r.MailingPostalCode, BOATBUILDING__Contact__r.MailingCity, RecordType.Name, RecordTypeId, Boat__c,
                                                            Store_Location__c,  Boat__r.Name, Boat__r.Boat_Model__c, Boat__r.Engine_Model__c, Boat__r.M_Boat_Year__c, Boat__r.Boat_HIN_No__c,
                                                            Boat__r.CreatedDateCustom__c, BOATBUILDING__Boat__r.BOATBUILDING__Engine_SN__c, Name, Drive__c, Hours__c, BOATBUILDING__Status__c,
                                                            BOATBUILDING__Priority__c, BOATBUILDING__ContactPhone__c, Total_Parts__c, Total_Labor__c, Total_Shop_Supplies__c, Total__c,
                                                            Sales_Tax__c, Total_Amount_Due__c, BOATBUILDING__Total_Payment_payment__c, Balance__c, Id
                                                    FROM 
                                                            BOATBUILDING__Work_Order__c
                                                    WHERE 
                                                            Id =: strRecId];
        lstFinalList.add(objWO);
        List<BOATBUILDING__Work_Order_Job__c> lstJob = [SELECT Work_Type__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, Type__c,  Name,  No_of_Labors__c,  Price_per_Labor__c,  Total_Cost_Labor__c,  Shop_Supplies_Total__c, 
                                                                Total_Amount_Job__c,  Customer_Pay__c, Total_Hours_Job__c, Worked_Hours__c, Id, Job_Name__c, Work_Requested__c,
                                                                BOATBUILDING__Completed__c, BOATBUILDING__TWO_Worked_Hour__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Description__c    ,
                                                                Comments__c, Technician__c, Technician__r.Name, BOATBUILDING__Tech_Eff_Job_wise__c, BOATBUILDING__Efficiency__c,
                                                                (
                                                                    SELECT 
                                                                        Id, Name, Part_Number__c, Part_Name__c, Quantity__c, Price__c, Total__c, Related_to_Job__c
                                                                    FROM 
                                                                        BOATBUILDING__Work_Order_Job_Line_Items__r 
                                                                ), 
                                                                (
                                                                    SELECT 
                                                                        BOATBUILDING__Technician_Efficiency__c, Id,BOATBUILDING__Clock_In__c,BOATBUILDING__Clock_Out__c, Status__c, Service_writer_comment__c, Technician__c, Technician__r.Name   
                                                                    FROM 
                                                                        BOATBUILDING__Time_Management__r where BOATBUILDING__Clock_In__c != null AND BOATBUILDING__Clock_Out__c =null 
                                                                    Order BY BOATBUILDING__Clock_In__c DESC limit 1)
                                                        FROM 
                                                                BOATBUILDING__Work_Order_Job__c where BOATBUILDING__Work_Order_Warranty_Work_Order__c =: objWO.Id];
        
        lstFinalList.add(lstJob);  
        lstFinalList.add(BOATBUILDING__WorkTypePricing__c.getAll().values());  
        return lstFinalList;
    }
    @AuraEnabled 
    public static String updateclockout(String JobId, String tmid ) {
        try{
            BOATBUILDING__Time_Management__c updateclockout = [Select Clock_In__c, 
                                                        Clock_Out__c, 
                                                        Number_of_Hours_Worked__c,
                                                        Related_to_Job__c,
                                                        
                                                        Related_to_Job__r.Worked_Hours__c,Related_Work_Order_Job__r.Worked_Hours__c
                                                        From 
                                                        BOATBUILDING__Time_Management__c 
                                                        where 
                                                        Related_Work_Order_Job__c =: JobId and 
                                                        Id =: tmid limit 1]; 
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
            if(updateclockout.Related_Work_Order_Job__r.Worked_Hours__c != null) {
                updateclockout.Related_Work_Order_Job__r.Worked_Hours__c += updateclockout.Number_of_Hours_Worked__c;
            } else {
                updateclockout.Related_Work_Order_Job__r.Worked_Hours__c = updateclockout.Number_of_Hours_Worked__c;
            }
        
            update updateclockout;
            update updateclockout.Related_Work_Order_Job__r;
            return JSON.serialize(updateclockout);
        }
        catch(Exception err){
            System.debug(err);
            String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
            return error;
        }   
    }

    @AuraEnabled
    public static String insertclockin(String JobId) {
        try{  
            System.debug('Debug Log for JobId: '+JobId);
            BOATBUILDING__Work_Order_Job__c SelectedJob =   [Select  
                                                                    Work_Type__c,  Type__c,  Name,  No_of_Labors__c,  Price_per_Labor__c,  Total_Cost_Labor__c,  Shop_Supplies_Total__c, 
                                                                    Total_Amount_Job__c,  Customer_Pay__c, Total_Hours_Job__c, BOATBUILDING__TWO_Worked_Hour__c, Worked_Hours__c, Id
                                                            From 
                                                                BOATBUILDING__Work_Order_Job__c where Id =: JobId LIMIT 1 ];
            System.debug('Debug Log for WorkedHours'+SelectedJob.Worked_Hours__c);
            System.debug('Debug Log for Total Hours'+SelectedJob.Total_Hours_Job__c);
            String RecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Time_Management__c' AND DeveloperName = 'Time_Management_for_Jobs' limit 1].Id;
            BOATBUILDING__Time_Management__c insertclockin = new BOATBUILDING__Time_Management__c();
            insertclockin.RecordTypeId = RecordType;
            insertclockin.Clock_In__c = DateTime.now();
            insertclockin.Related_Work_Order_Job__c = JobId;
            insertclockin.BOATBUILDING__Technician__c = UserInfo.getUserId();
            insert insertclockin;
            insertclockin = [Select Id, Clock_In__c, Related_Work_Order_Job__c, BOATBUILDING__Technician__c, BOATBUILDING__Technician__r.Name 
                                From BOATBUILDING__Time_Management__c Where Id =: insertclockin.Id Limit 1];
            return JSON.serialize(insertclockin);
        }
        catch(Exception err) { 
            System.debug(err);
            String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
            return error;
        }   
    }
    @AuraEnabled
    public static String completeToggle(String strRecId, Boolean ischecked) {
        try{  
            BOATBUILDING__Work_Order_Job__c objJob = [SELECT BOATBUILDING__Completed__c FROM BOATBUILDING__Work_Order_Job__c where Id =: strRecId];
            objJob.BOATBUILDING__Completed__c = ischecked;
            update objJob;
            return 'SUCCESS';
        }
        catch(Exception err){
            System.debug(err);
            String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
            return error;
        }
    }
    
}