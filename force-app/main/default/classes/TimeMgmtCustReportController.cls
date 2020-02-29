public with sharing class TimeMgmtCustReportController {
    @RemoteAction
    public static List<User> getUserDetails() {
        List<User> lstUser = new List<User>();
        lstUser = [Select Id, Name From User Where isActive = true AND UserRole.Name = 'Service Tech' limit 1000 ];
        return lstUser;
    }
    
    String LongDate = ' ';

  // Init cLongDate with the current Datetime in long date format    
  public String getLongDate() {
    Datetime cDT = System.now();
    LongDate = cDT.format('EEEE, MMMM d, yyyy');
    return LongDate;
  } 
    
    @RemoteAction
    public static List<Work_Order_Job__c> getReport(String strUserId, String strRange) {
        
        List<Work_Order_Job__c> lstObj = new List<Work_Order_Job__c>();
        List<Work_Order_Job__c> lstForPrint = new List<Work_Order_Job__c>();
        if(strUserId.Contains('ALL')) {
            if(strRange.equalsIgnoreCase('ALL')) {
                String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, BOATBUILDING__Technician__c, (Select Id,Technician__r.Name, Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r) From Work_Order_Job__c WHERE BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000'; 
                lstObj = DataBase.query(strQuery);
            } else if(strRange.equalsIgnoreCase('CurrentWeek') || strRange.equalsIgnoreCase('CurrentMonth') || strRange.equalsIgnoreCase('CurrentYear')) {
                
                if(strRange.equalsIgnoreCase('CurrentMonth')) {
                    
                    Integer days = Date.today().day();
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, BOATBUILDING__Technician__c, (Select Id, Technician__r.Name,Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c WHERE BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC  limit 10000';
                    lstObj = DataBase.query(strQuery); 
                } else if(strRange.equalsIgnoreCase('CurrentWeek')) {
                    DateTime myDate = Date.today();
                    String day = myDate.format('EEEE');
                    
                    Map<String, Integer> dayNum = new Map<String, Integer>();
                    dayNum.put('Sunday', 0);
                    dayNum.put('Monday', 1);
                    dayNum.put('Tuesday', 2); 
                    dayNum.put('Wednesday', 3);
                    dayNum.put('Thursday', 4); 
                    dayNum.put('Friday', 5);
                    dayNum.put('Saturday', 6);
                    
                    Integer days = dayNum.get(day);
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id,Technician__r.Name, Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c WHERE BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                    lstObj = DataBase.query(strQuery);
                    
                } else if(strRange.equalsIgnoreCase('CurrentYear')) {
                    
                    Date endDate = Date.today();
                    Integer year = Date.today().year();
                    Date startDate =  Date.newInstance(year, 1, 1);
                    Integer days = startDate.daysBetween(endDate);
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id,Technician__r.Name, Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c WHERE BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                    lstObj = DataBase.query(strQuery);
                }   
            } else {
                
                Integer days = Integer.valueOf(strRange);
                String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id,Technician__r.Name, Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c WHERE BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                lstObj = DataBase.query(strQuery); 
            }
            
            for(Integer i = 0; i < lstObj.size(); i++) {
                if(!lstObj[i].Time_Management__r.isEmpty()) {
                    lstForPrint.add(lstObj[i]);
                }
            }
        } else {
            String UserIdsStr = strUserId.remove('[');
            UserIdsStr = UserIdsStr.remove(']');
            String[] arrayIds = UserIdsStr.split(',');
            Set<String> setUserIds = new Set<String>();
            for(Integer i = 0; i < arrayIds.size(); i++)
            {
                setUserIds.add(arrayIds[i].trim());
            }
            System.debug('setUserIds---72---'+setUserIds);
            if(strRange.equalsIgnoreCase('ALL')) {
                String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Name,Technician__r.Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r) From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000'; 
                System.debug('strQuery--75---'+strQuery);
                lstObj = DataBase.query(strQuery);
                System.debug('--lstObj--'+lstObj);
            } else if(strRange.equalsIgnoreCase('CurrentWeek') || strRange.equalsIgnoreCase('CurrentMonth') || strRange.equalsIgnoreCase('CurrentYear')) {
                
                if(strRange.equalsIgnoreCase('CurrentMonth')) {
                    
                    Integer days = Date.today().day();
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Technician__r.Name,Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC  limit 10000';
                    lstObj = DataBase.query(strQuery); 
                } else if(strRange.equalsIgnoreCase('CurrentWeek')) {
                    DateTime myDate = Date.today();
                    String day = myDate.format('EEEE');
                    
                    Map<String, Integer> dayNum = new Map<String, Integer>();
                    dayNum.put('Sunday', 0);
                    dayNum.put('Monday', 1);
                    dayNum.put('Tuesday', 2); 
                    dayNum.put('Wednesday', 3);
                    dayNum.put('Thursday', 4);
                    dayNum.put('Friday', 5);
                    dayNum.put('Saturday', 6);
                    
                    Integer days = dayNum.get(day);
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id,Technician__r.Name, Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                    lstObj = DataBase.query(strQuery);
                    
                } else if(strRange.equalsIgnoreCase('CurrentYear')) {
                    
                    Date endDate = Date.today();
                    Integer year = Date.today().year();
                    Date startDate =  Date.newInstance(year, 1, 1);
                    Integer days = startDate.daysBetween(endDate);
                    String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Name, Technician__c, Technician__r.Name,CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                    lstObj = DataBase.query(strQuery);
                }   
            } else {
                
                Integer days = Integer.valueOf(strRange);
                String strQuery = 'Select Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Name, Technician__c,Technician__r.Name, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000';
                lstObj = DataBase.query(strQuery); 
            }
            
            
            for(Integer i = 0; i < lstObj.size(); i++) {
                if(!lstObj[i].Time_Management__r.isEmpty()) {
                    lstForPrint.add(lstObj[i]);
                }
            }
        }
        return lstForPrint;
    }
    
    @RemoteAction
    public static List<Time_Management__c> getTM(String strUserId, String strRange) {
        List<Time_Management__c> lstTm = new List<Time_Management__c>();
        Integer days = 0;
        Boolean isAllDays = False;
        Set<String> setUserIds = new Set<String>();
        if(strUserId.Contains('ALL')) {
            if(strRange.Contains('ALL')) {
                String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Technician__r.Name,Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                lstTm = DataBase.query(strQuery);
                isAllDays = True;
            } else if(strRange.equalsIgnoreCase('CurrentWeek') || strRange.equalsIgnoreCase('CurrentMonth') || strRange.equalsIgnoreCase('CurrentYear')) {
                if(strRange.equalsIgnoreCase('CurrentMonth')) {
                    
                    days = Date.today().day(); 
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId,Technician__r.Name, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    lstTm = DataBase.query(strQuery); 
                } else if(strRange.equalsIgnoreCase('CurrentWeek')) {
                    
                    DateTime myDate = Date.today();
                    String day = myDate.format('EEEE'); 
                    
                    Map<String, Integer> dayNum = new Map<String, Integer>();
                    dayNum.put('Sunday', 0);
                    dayNum.put('Monday', 1);
                    dayNum.put('Tuesday', 2); 
                    dayNum.put('Wednesday', 3);
                    dayNum.put('Thursday', 4); 
                    dayNum.put('Friday', 5);
                    dayNum.put('Saturday', 6);
                    
                    days = dayNum.get(day);
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c,Technician__r.Name, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    lstTm = DataBase.query(strQuery);
                } else if(strRange.equalsIgnoreCase('CurrentYear')) {
                    
                    Date endDate = Date.today();
                    Integer year = Date.today().year();
                    Date startDate =  Date.newInstance(year, 1, 1);
                    days = startDate.daysBetween(endDate);
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c,  Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Technician__r.Name,Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    lstTm = DataBase.query(strQuery);
                }  
                
            } else {
                days = Integer.valueOf(strRange);
                String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId,Technician__r.Name, Id, Name, BOATBUILDING__Billed_Hour__c,  BOATBUILDING__Technician_Efficiency__c, Technician__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                System.debug('strQuery--168---'+strQuery);
                lstTm = DataBase.query(strQuery);
            }
        } else {
            String UserIdsStr = strUserId.remove('[');
            UserIdsStr = UserIdsStr.remove(']');
            String[] arrayIds = UserIdsStr.split(',');
            for(Integer i = 0; i < arrayIds.size(); i++)
            {
                setUserIds.add(arrayIds[i].trim());
            }
            System.debug('setUserIds---179---'+setUserIds);
            if(strRange.equalsIgnoreCase('ALL')) {
                String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId,Technician__r.Name, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where OwnerId IN : setUserIds AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                lstTm = DataBase.query(strQuery);
            } else if(strRange.equalsIgnoreCase('CurrentWeek') || strRange.equalsIgnoreCase('CurrentMonth') || strRange.equalsIgnoreCase('CurrentYear')) {
                if(strRange.equalsIgnoreCase('CurrentMonth')) {
                    
                    days = Date.today().day(); 
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId,Technician__r.Name, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND OwnerId IN : setUserIds AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    System.debug('strQuery--189---'+strQuery);
                    lstTm = DataBase.query(strQuery); 
                } else if(strRange.equalsIgnoreCase('CurrentWeek')) {
                    
                    DateTime myDate = Date.today();
                    String day = myDate.format('EEEE'); 
                    
                    Map<String, Integer> dayNum = new Map<String, Integer>();
                    dayNum.put('Sunday', 0);
                    dayNum.put('Monday', 1);
                    dayNum.put('Tuesday', 2); 
                    dayNum.put('Wednesday', 3);
                    dayNum.put('Thursday', 4);
                    dayNum.put('Friday', 5);
                    dayNum.put('Saturday', 6);
                    
                    days = dayNum.get(day);
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Id,Technician__r.Name, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND OwnerId IN : setUserIds AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    System.debug('strQuery--206---'+strQuery);
                    lstTm = DataBase.query(strQuery);
                } else if(strRange.equalsIgnoreCase('CurrentYear')) {
                    
                    Date endDate = Date.today();
                    Integer year = Date.today().year();
                    Date startDate =  Date.newInstance(year, 1, 1);
                    days = startDate.daysBetween(endDate);
                    String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Technician__r.Name, Id, Name, Technician__c, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c,  Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND OwnerId IN : setUserIds AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                    System.debug('strQuery--214---'+strQuery);
                    lstTm = DataBase.query(strQuery);
                }  
                
            } else {
                days = Integer.valueOf(strRange);
                String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId, Id, Name, BOATBUILDING__Billed_Hour__c,  BOATBUILDING__Technician_Efficiency__c, Technician__c,Technician__r.Name, Working_Hours__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c From Time_Management__c Where createddate = last_n_days: ' + days + ' AND OwnerId IN : setUserIds AND RecordType.DeveloperName = \'Standard_Time_Sheet\' limit 10000';
                System.debug('strQuery--220---'+strQuery);
                lstTm = DataBase.query(strQuery);
            }
        }
        
        List<Time_Management__c> listTMToReturn = calculateBilledHour(lstTm, setUserIds, days, null, null, isAllDays);
        
        return listTMToReturn;
    }
    
    @RemoteAction
    public static List<Work_Order_Job__c> getReportDateRange(String strUserId, String strStrtDate, String strEndDate) {
        List<Work_Order_Job__c> lstObj = new List<Work_Order_Job__c>();
        System.debug('Debug Log For strStrtDate: '+strStrtDate);
        System.debug('Debug Log For strEndDate: '+strEndDate);
        String[] strngStrtDate = strStrtDate.split('-');
        String[] strngEndDate = strEndDate.split('-');
        if(strngStrtDate.size() > 2 && strngEndDate.size() > 2) {
            
            
            Date StartDate = date.newinstance(Integer.valueOf(strngStrtDate[0]), Integer.valueOf(strngStrtDate[1]), Integer.valueOf(strngStrtDate[2]));
            Date EndDate = date.newinstance(Integer.valueOf(strngEndDate[0]), Integer.valueOf(strngEndDate[1]), Integer.valueOf(strngEndDate[2]));
            EndDate = EndDate.addDays(1);            
            System.debug('Debug Log For StartDate: '+StartDate);
            System.debug('Debug Log For EndDate: '+EndDate);
            
            if(strUserId.Contains('ALL')) {
                lstobj = [Select 
                          Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, 
                          Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Name,Technician__r.Name, Technician__c, CreatedDate, 
                                                                                                                    Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c 
                                                                                                                    From Time_Management__r Where CreatedDate >=: StartDate and CreatedDate <=:  EndDate) 
                          From 
                          Work_Order_Job__c
                          
                          Order By
                          Work_Order_Warranty_Work_Order__r.Name DESC limit 10000];
            } else {
                String UserIdsStr = strUserId.remove('[');
                UserIdsStr = UserIdsStr.remove(']');
                String[] arrayIds = UserIdsStr.split(',');
                Set<String> setUserIds = new Set<String>();
                for(Integer i = 0; i < arrayIds.size(); i++)
                {
                    setUserIds.add(arrayIds[i].trim());
                }
                System.debug('setUserIds---263---'+setUserIds);
                lstobj = [Select 
                          Owner.Name, OwnerId, TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, 
                          Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Name, Technician__c,Technician__r.Name, CreatedDate, 
                                                                                                                    Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c 
                                                                                                                    From Time_Management__r Where CreatedDate >=: StartDate and CreatedDate <=:  EndDate) 
                          From 
                          Work_Order_Job__c 
                          Where 
                          Technician__c IN : setUserIds Order By Work_Order_Warranty_Work_Order__r.Name DESC limit 10000];
            }
            
            
        }
        
        List<Work_Order_Job__c> lstForPrint = new List<Work_Order_Job__c>();
        for(Integer i = 0; i < lstObj.size(); i++) {
            //System.debug('Debug Log For lstObj['+i+']: '+lstObj[i]);
            if(!lstObj[i].Time_Management__r.isEmpty()) {
                lstForPrint.add(lstObj[i]);
            } 
        }
        
        
        return lstForPrint;
    } 
    
    @RemoteAction
    public static List<Time_Management__c> getTMWithDateRange(String strUserId, String strStrtDate, String strEndDate) {
        List<Time_Management__c> lstTm = new List<Time_Management__c>();
        String[] strngStrtDate = strStrtDate.split('-');
        String[] strngEndDate = strEndDate.split('-');
        Set<String> setUserIds = new Set<String>();
        Date StartDate = null;
        Date EndDate = null;
        if(strngStrtDate.size() > 2 && strngEndDate.size() > 2) {
            StartDate = date.newinstance(Integer.valueOf(strngStrtDate[0]), Integer.valueOf(strngStrtDate[1]), Integer.valueOf(strngStrtDate[2]));
            EndDate = date.newinstance(Integer.valueOf(strngEndDate[0]), Integer.valueOf(strngEndDate[1]), Integer.valueOf(strngEndDate[2]));
            EndDate = EndDate.addDays(1);
            System.debug('StartDate--'+StartDate+'---End Date---'+EndDate);
            if(strUserId.Contains('ALL')) {
                lstTm = [Select  
                         Id, Name, Technician__c, Technician__r.Name, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, BOATBUILDING__Working_Hours__c, CreatedDate, Total_Work__c, 
                         Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c, BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId 
                         From 
                         Time_Management__c 
                         Where 
                         RecordType.DeveloperName = 'Standard_Time_Sheet'  AND CreatedDate >=: StartDate and CreatedDate <=:  EndDate limit 10000];
            } else {
                String UserIdsStr = strUserId.remove('[');
                UserIdsStr = UserIdsStr.remove(']');
                String[] arrayIds = UserIdsStr.split(',');
                for(Integer i = 0; i < arrayIds.size(); i++)
                {
                    setUserIds.add(arrayIds[i].trim());
                }
                System.debug('setUserIds---316---'+setUserIds);
                lstTm = [Select 
                         Id, Name, Technician__c,Technician__r.Name, BOATBUILDING__Technician_Efficiency__c, BOATBUILDING__Billed_Hour__c, BOATBUILDING__Working_Hours__c, CreatedDate, Total_Work__c, 
                         Allowed_hours_on_JOB__c, Day_In__c, Day_Out__c, Lunch_In__c, Lunch_Out__c, BOATBUILDING__Worked_Hour_For_Completed_Job__c, OwnerId 
                         From 
                         Time_Management__c 
                         Where 
                         OwnerId IN : setUserIds AND RecordType.DeveloperName = 'Standard_Time_Sheet'  AND CreatedDate >=: StartDate and CreatedDate <=:  EndDate limit 10000];
            }
        }
        List<Time_Management__c> listTMToReturn = calculateBilledHour(lstTm, setUserIds, null, StartDate, EndDate, False);
        return listTMToReturn;
    }
    
    public static List<Time_Management__c> calculateBilledHour(List<Time_Management__c> listTm, Set<String> setUserIds, Integer days, DateTime startDate, DateTime endDate, Boolean isAllDays){

        List<Time_Management__c> listTMForJobs = new List<Time_Management__c>();
        
        //String strQuery = 'Select TWO_Worked_Hour__c, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name, Work_Order_Warranty_Work_Order__r.Id, Work_Order_Warranty_Work_Order__r.Name, Id, Efficiency__c, No_of_Labors__c, Job_Name__c, BOATBUILDING__Technician__r.Name, (Select Id, Technician__r.Name,Name, Technician__c, CreatedDate, Total_Work__c, Allowed_hours_on_JOB__c, Clock_In__c, Clock_Out__c From Time_Management__r Where createddate = last_n_days: ' + days + ') From Work_Order_Job__c Where Technician__c IN : setUserIds AND BOATBUILDING__Completed__c = True Order By Work_Order_Warranty_Work_Order__r.Name DESC  limit 10000';
        
         
        
        String strQuery = 'SELECT Id, Name, BOATBUILDING__Technician__c, BOATBUILDING__Allowed_hours_on_JOB__c, OwnerId, BOATBUILDING__Related_Work_Order_Job__c, CreatedDate,';
        strQuery += ' BOATBUILDING__Clock_In__c, BOATBUILDING__Clock_Out__c, BOATBUILDING__Billed_Hour__c FROM Time_Management__c ';
        strQuery += 'WHERE RecordType.DeveloperName = \'Time_Management_for_Jobs\'';
        strQuery += ' AND BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c = True ';
        
        
        //NOT All users
        if(setUserIds != null && !setUserIds.isEmpty()) {
            strQuery += ' AND BOATBUILDING__Technician__c IN: setUserIds '; 
            if(!isAllDays){
                if(days != null  && days > 0){
                    strQuery += 'AND createddate = last_n_days:'+ days; 
                } 
                else if(startDate !=null && endDate != null){
                    strQuery += 'AND createddate >=: startDate AND createddate <=: endDate';
                }
            } 
        } 
        // All Users
        else {
            if(!isAllDays){
                if(days != null && days > 0){
                    strQuery += 'AND createddate = last_n_days:'+ days;
                } 
                else if(startDate !=null && endDate != null){
                    strQuery += 'AND createddate >=: startDate AND createddate <=: endDate';
                }
            } 
        }
        System.debug('--setUserIds--'+setUserIds);
        System.debug('strQuery-'+strQuery);
        listTMForJobs = Database.query(strQuery);
         
        //BOATBUILDING__No_of_Labors__c
        
        Set<String> setJobId = new Set<String>();
        
        for(Time_Management__c tmj: listTMForJobs){
	        	setJobId.add(tmj.BOATBUILDING__Related_Work_Order_Job__c);
        }
         
        Map<Id, Work_Order_Job__c> mapWOJ = new Map<Id, Work_Order_Job__c>([Select
									        											Id,
									        											BOATBUILDING__No_of_Labors__c
									        									From 
									        											Work_Order_Job__c
									        									Where 
									        											Id IN: setJobId
									        									AND
									        											BOATBUILDING__Completed__c = true]);
        
        
        //Map<String, String> mapTIDJID = new Map<String, String>();
        
        for(Time_Management__c tm: listTM){
            System.debug('listTMForJobs--'+listTMForJobs);
            tm.BOATBUILDING__Billed_Hour__c = 0; 
            for(Time_Management__c tmj: listTMForJobs){
                if(tm.BOATBUILDING__Technician__c == tmj.BOATBUILDING__Technician__c && tm.CreatedDate.date() == tmj.CreatedDate.date()){
                    //tm.BOATBUILDING__Billed_Hour__c += tmj.BOATBUILDING__Allowed_hours_on_JOB__c;
                    if(mapWOJ.containsKey(tmj.BOATBUILDING__Related_Work_Order_Job__c) && mapWOJ.get(tmj.BOATBUILDING__Related_Work_Order_Job__c).BOATBUILDING__No_of_Labors__c != null) {
                    		tm.BOATBUILDING__Billed_Hour__c += mapWOJ.get(tmj.BOATBUILDING__Related_Work_Order_Job__c).BOATBUILDING__No_of_Labors__c;
                    		mapWOJ.remove(tmj.BOATBUILDING__Related_Work_Order_Job__c); 
                    } 
                }
            }
        }
        
        
        
        update listTM;
        return listTM;
    }
}