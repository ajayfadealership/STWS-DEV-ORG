/** 
    * Author:     Shobhit Saxena 
    * Organization:   360 Degree Cloud Technologies Pvt. Ltd. 
    * Created Date:   13/02/2016 
    * Last Modified Date:  13/02/2016 
    */
  
 
public with sharing class TechWorkOrderController {
/*
//--------------------------------------Tech Work Order---------------------------------------//
    public BOATBUILDING__Job__c objJob2 { get; set; }
    public Case objCaseForTWO {get; set; }
    
    public TechWorkOrderController(){
        objJob2 = new BOATBUILDING__Job__c();
        objCaseForTWO = new Case();
    }

    
    
    @RemoteAction
    public static List<Object> getDetailsOfWrkOrder(String WrkOrderId){
      
        List<Object> lstFinalList = new List<Object>();
        List<RecordType> lstRecType = [SELECT 
                                                Id 
                                       FROM 
                                                RecordType 
                                       WHERE 
                                                SobjectType = 'Case' 
                                       AND 
                                                (
                                                        DeveloperName = 'Work_Order'
                                                    OR
                                                        DeveloperName = 'Warranty_Work_Order'
                                                )
                                                limit 2];
              
      if(lstRecType.size()>0) {
                
            List<Case> lstCase = [SELECT 
                                            AccountID,
                                            ContactID,
                                            ContactEmail,
                                            Contact.FirstName,
                                            Contact.LastName,
                                            Contact.MailingStreet,
                                            Contact.Email,
                                            Contact.MailingPostalCode,
                                            Contact.MailingCity,
                                            RecordType.Name, 
                                            Boat__c,
                                            Boat__r.Name,
                                            Boat__r.BOATBUILDING__Boat_HIN_No__c,
                                            Boat__r.Boat_Model__c,
                                            Boat__r.M_Boat_Year__c,
                                            Boat__r.CreatedDateCustom__c,
                                            CaseNumber,
                                            Drive__c,
                                            Hours__c,
                                            Status,
                                            Priority,
                                            ContactPhone,
                                            Total_Parts__c,
                                            Total_Labor__c,
                                            Total_Shop_Supplies__c,
                                            Total__c,
                                            Sales_Tax__c,
                                            Total_Amount_Due__c,
                                            Total_Payment__c,
                                            Balance__c,
                                            ID
                                    FROM 
                                            Case
                                    WHERE 
                                            RecordTypeId IN: lstRecType 
                                    AND 
                                            ID =: WrkOrderId
                                    ];

                if(lstCase.size()>0){
                        lstFinalList.add(lstCase);
                        List<BOATBUILDING__Job__c> joblist = [Select 
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
                                                        Work_Request__r.Description,
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
                                                                    BOATBUILDING__Job_Line_Items__r
                                                            )
                                            From 
                                                        BOATBUILDING__Job__c where Work_Request__c =: lstCase[0].Id];
                      if(joblist.size() > 0){
                            lstFinalList.add(joblist);
                        } 

                }
        }
            
                
           
            System.debug('Debug Log for Final List'+lstFinalList);
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
        BOATBUILDING__Job__c SelectedJob = [Select 
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
                                                            Id
                                                From 
                                                            BOATBUILDING__Job__c where Id =: JobId
                                                            LIMIT 1
                                                            ];
        System.debug('Debug Log for WorkedHours'+SelectedJob.Worked_Hours__c);
        System.debug('Debug Log for Total Hours'+SelectedJob.Total_Hours_Job__c);
        if(SelectedJob.Id != null ) {
            String RecordType = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Time_Management__c' AND DeveloperName = 'Time_Management_for_Jobs' limit 1].Id;
            BOATBUILDING__Time_Management__c insertclockin = new BOATBUILDING__Time_Management__c();
            insertclockin.RecordTypeId = RecordType;
            insertclockin.Clock_In__c = DateTime.now();
            insertclockin.Related_to_Job__c = JobId;
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
                                                    Related_to_Job__r.Worked_Hours__c
                                                    From 
                                                    BOATBUILDING__Time_Management__c 
                                                    where 
                                                    Related_to_Job__c =: JobId and 
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
        updateclockout.Related_to_Job__r.Worked_Hours__c += updateclockout.Number_of_Hours_Worked__c;
        
        try{
            update updateclockout;
            update updateclockout.Related_to_Job__r;
        }
        catch(Exception err){
            System.debug(err);
            return null;
        }   
           return updateclockout;
    }
    
    @RemoteAction
    public static BOATBUILDING__Time_Management__c addCommentonJob(String TimeMgmtID,String comment){
        
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
                                                            Related_to_Job__c,
                                                            Related_to_Job__r.Worked_Hours__c,
                                                            Status__c
                                                    From 
                                                            BOATBUILDING__Time_Management__c 
                                                    where 
                                                            RecordTypeId =: RecordType
                                                    and 
                                                            Id =: TimeMgmtID 
                                                            limit 1]; 
            
            if(SelectedTimeEntry.Id != null){
                SelectedTimeEntry.Status__c = (comment != null ? comment :'');
                try{
                    update SelectedTimeEntry;
                }
                catch(Exception ex) {
                    System.debug('Debug Log for Exception while updating Comment on TimeSheet' +ex);
                    return null;
                }
                return SelectedTimeEntry;
            }
        }
        return null;
    }
   
    
    //--------------------------------------Tech Work Order---------------------------------------//

*/
}