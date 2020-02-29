trigger WorkOrderJobTrigger on Work_Order_Job__c(before insert, before update, after insert, after update, after undelete, before delete, after delete) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__WorkOrderJobTriggerCheckBox__c;
    //Id wojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Work Order Job').getRecordTypeId();
    
    
    
    
    if(isOff==true){ 
        //Update Work Order Status
        if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert))
	    {
	        RollUpSummaryUtility.isCompleteOperation(trigger.new, trigger.OldMap, trigger.isInsert, trigger.isUpdate);
	    }
	    //Automation for notification via chatter post
	    if(trigger.isAfter && trigger.isUpdate) 
	    {
	    	RollUpSummaryUtility.updateWOStatus(Trigger.new, Trigger.oldMap);
	    } 
	    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)) {
	    	//RollUpSummaryUtility.doChatterPost(trigger.new, trigger.OldMap, trigger.isInsert, trigger.isUpdate);
	    } 
        
        
        if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
            Set<String> setWOId = new Set<String>();
            for(Work_Order_Job__c objWOJ: trigger.new) {
                if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                    setWOId.add(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
                }
            } 
            if(!setWOId.isEmpty()) {
                RollUpSummaryUtility.rollAllTheDataOnWO(setWOId); 
            }
        }    
        if(trigger.isDelete) {
            Set<String> setWOId = new Set<String>();
            if(trigger.isBefore) {
                for(Work_Order_Job__c objWOJ: trigger.old) {
                    if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                        setWOId.add(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
                    }
                } 
            } 
            if(trigger.isAfter) {
                if(!setWOId.isEmpty()) {
                    RollUpSummaryUtility.rollAllTheDataOnWO(setWOId); 
                }
            }
        }
        
        
        if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) { 
            RiggingHandler.updateInventoryOnWO(trigger.newMap);
            RollUpSummaryUtility.doChatterPost(trigger.new, trigger.OldMap, trigger.isInsert, trigger.isUpdate);  
        }
        
    }     
}