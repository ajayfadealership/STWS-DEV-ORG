trigger TMRollUpTrigger on Time_Management__c (after insert, after update, after delete, after undelete) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__TMRollUpTriggerCheckBox__c;
    //isOff==true && 
    if(trigger.isAfter){
     if(trigger.isInsert || trigger.isUpdate){ //|| trigger.isUnDelete
        try {
        // for Work Hour Rollup
        //list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Number_of_Hours_Worked__c', 'BOATBUILDING__TWO_Worked_Hour__c')};
        //RollUpSummaryUtility.rollUpTrigger(fieldDefinitions1, trigger.new,'BOATBUILDING__Time_Management__c', 'BOATBUILDING__Related_Work_Order_Job__c','BOATBUILDING__Work_Order_Job__c','');
        
        Set<String> setJobId = new Set<String>();
        List<RecordType> lstRec = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Time_Management__c' AND DeveloperName = 'Time_Management_for_Jobs' limit 1];
        for(Time_Management__c objTML: trigger.new) {
            if(objTML.Related_Work_Order_Job__c != null) {
                setJobId.add(objTML.Related_Work_Order_Job__c);
            }
        }
        
        
        List<Work_Order_Job__c> lstWOJ = [Select Id, TWO_Worked_Hour__c,BOATBUILDING__Technician__c, (Select Id, Total_Work__c, RecordTypeId,BOATBUILDING__Technician__c From Time_Management__r) From Work_Order_Job__c Where Id IN: setJobId]; 
        
        for(Work_Order_Job__c objWOJ: lstWOJ) {
            Decimal TWH =0.00;
            if(objWOJ.Time_Management__r.size() > 0) {
                for(Time_Management__c objTM: objWOJ.Time_Management__r) {
                    if(objTM.Total_Work__c != null && objTM.RecordTypeId == lstRec[0].Id) {
                        TWH += objTM.Total_Work__c;     
                        objWOJ.BOATBUILDING__Technician__c =  objTM.BOATBUILDING__Technician__c;
                    }
                }
            }
            objWOJ.TWO_Worked_Hour__c = TWH; 
            
        }
        
        update lstWOJ; 
        } catch(Exception ex) {
            System.debug('Exception: '+ex);
        }
     }
     if(trigger.isDelete) {
         // for Work Hour Rollup
        //list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Number_of_Hours_Worked__c', 'BOATBUILDING__TWO_Worked_Hour__c')};
        //RollUpSummaryUtility.rollUpTrigger(fieldDefinitions1, trigger.old,'BOATBUILDING__Time_Management__c', 'BOATBUILDING__Related_Work_Order_Job__c','BOATBUILDING__Work_Order_Job__c','');
     }
    }
}