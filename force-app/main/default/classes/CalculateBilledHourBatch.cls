global with sharing class CalculateBilledHourBatch implements Database.Batchable<sObject> {
    
    global CalculateBilledHourBatch() {}
        
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = 'Select BOATBUILDING__Worked_Hour_For_Completed_Job__c, Id, OwnerId, BOATBUILDING__Day_In__c,'; 
        strQuery += ' BOATBUILDING__Day_Out__c, BOATBUILDING__Billed_Hour__c From BOATBUILDING__Time_Management__c ';
        strQuery += ' Where RecordType.DeveloperName = \'Standard_Time_Sheet\' AND BOATBUILDING__Day_In__c <> NULL ';
        strQuery += ' AND BOATBUILDING__Day_Out__c <> NULL Order By BOATBUILDING__Day_In__c ASC';
        return Database.getQueryLocator(strQuery);
    } 
    global void execute(Database.BatchableContext BC, List<BOATBUILDING__Time_Management__c> scope) {
            try {
                Map<String, Map<Date, Decimal>> mapDateHr = new Map<String, Map<Date, Decimal>>();
                Map<String, Map<Date, Decimal>> mapAllHr = new Map<String, Map<Date, Decimal>>();
                System.debug('Debug Log For scope: '+scope);
                for(BOATBUILDING__Time_Management__c objTM: scope) {
                    if(!mapDateHr.containsKey(objTM.OwnerId)) {
                        mapDateHr.put(objTM.OwnerId, new Map<Date, Decimal>()); 
                    } 
                    if(!mapAllHr.containsKey(objTM.OwnerId)) {
                        mapAllHr.put(objTM.OwnerId, new Map<Date, Decimal>()); 
                    }
                    if(mapDateHr.containsKey(objTM.OwnerId)) {
                        mapDateHr.get(objTM.OwnerId).put(objTM.BOATBUILDING__Day_In__c.date(), 0.00);
                    }
                    if(mapAllHr.containsKey(objTM.OwnerId)) {
                        mapAllHr.get(objTM.OwnerId).put(objTM.BOATBUILDING__Day_In__c.date(), 0.00);
                    } 
                }
                System.debug('Debug Log For mapDateHr: '+mapDateHr);
                DateTime StartDate = scope[0].BOATBUILDING__Day_In__c;
                DateTime EndDate = scope[scope.size() - 1].BOATBUILDING__Day_Out__c;
            List<BOATBUILDING__Time_Management__c> lstTMTime = [Select Id, BOATBUILDING__Technician__c, Name, BOATBUILDING__Allowed_hours_on_JOB__c ,BOATBUILDING__Clock_In__c, BOATBUILDING__Clock_Out__c
                                                                 From BOATBUILDING__Time_Management__c 
                                                                    Where RecordType.DeveloperName = 'Time_Management_for_Jobs' 
                                                                        AND BOATBUILDING__Clock_In__c <> NULL 
                                                                            AND BOATBUILDING__Clock_Out__c <> NULL 
                                                                                AND BOATBUILDING__Clock_In__c >=: StartDate
                                                                                    AND BOATBUILDING__Clock_Out__c <=: EndDate
                                                                                    	AND Related_Work_Order_Job__r.BOATBUILDING__Completed__c = true];
            System.debug('Debug Log For lstTMTime: '+lstTMTime);
            if(!lstTMTime.isEmpty()) {
                for(BOATBUILDING__Time_Management__c objTM: lstTMTime) {
                    if(mapDateHr.containsKey(objTM.BOATBUILDING__Technician__c)) {
                        if(mapDateHr.get(objTM.BOATBUILDING__Technician__c).containsKey(objTM.BOATBUILDING__Clock_In__c.date())) {
                            Decimal dt1Long = objTM.BOATBUILDING__Clock_In__c.getTime();
                            Decimal dt2Long = objTM.BOATBUILDING__Clock_Out__c.getTime();
                            Decimal milliseconds = dt2Long - dt1Long;
                            Decimal seconds = milliseconds / 1000; 
                            Decimal minutes = seconds / 60; 
                            Decimal hours = minutes / 60;
                            Decimal existingHr = mapDateHr.get(objTM.BOATBUILDING__Technician__c).get(objTM.BOATBUILDING__Clock_In__c.date());
                            //Decimal finalHr = objTM.BOATBUILDING__Allowed_hours_on_JOB__c + existingHr;
                            Decimal finalHr = hours + existingHr;
                            mapDateHr.get(objTM.BOATBUILDING__Technician__c).put(objTM.BOATBUILDING__Clock_In__c.date(), finalHr);
                        }
                    }
                    if(mapAllHr.containsKey(objTM.BOATBUILDING__Technician__c)) {
                        if(mapAllHr.get(objTM.BOATBUILDING__Technician__c).containsKey(objTM.BOATBUILDING__Clock_In__c.date())) {
                            
                            Decimal existingHr = mapAllHr.get(objTM.BOATBUILDING__Technician__c).get(objTM.BOATBUILDING__Clock_In__c.date());
                            Decimal finalHr = objTM.BOATBUILDING__Allowed_hours_on_JOB__c + existingHr;
                            //Decimal finalHr = hours + existingHr;
                            mapAllHr.get(objTM.BOATBUILDING__Technician__c).put(objTM.BOATBUILDING__Clock_In__c.date(), finalHr);
                        }
                    }
                }
            }  
            System.debug('Debug Log For lstTMTime2: '+lstTMTime);                                                                   
            for(BOATBUILDING__Time_Management__c objTM: scope) {
                objTM.BOATBUILDING__Billed_Hour__c = mapAllHr.get(objTM.OwnerId).get(objTM.BOATBUILDING__Day_In__c.date());
                //objTM.BOATBUILDING__Worked_Hour_For_Completed_Job__c = mapDateHr.get(objTM.OwnerId).get(objTM.BOATBUILDING__Day_In__c.date());    
            }
                
                update scope; 
            } catch(Exception ex) { 
                System.debug('Debug Log For Exception: '+ex);
            }
    }
    global void finish(Database.BatchableContext BC) {
            /*DateTime todayDate = DateTime.now();
            String day = String.valueOf(todayDate.date().day() + 1);
            String month = String.valueOf(todayDate.date().month());
            String year = String.valueOf(todayDate.date().year());
            String hr = '00';
            String min = '00';
            String sec = '00';
            String sch = sec + ' ' + min + ' ' + hr + ' ' + month + ' ' + day + ' ? ' + year;
            System.schedule('Execute Batch: '+DateTime.now(), sch, new ScheduleCBHB()); 
            */
    } 
}