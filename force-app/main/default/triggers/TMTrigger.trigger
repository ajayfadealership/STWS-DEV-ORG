trigger TMTrigger on BOATBUILDING__Time_Management__c (before insert, before update, after insert, after update) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__TMTriggerCheckBox__c;
    if(isOff==true){
    	
    	
        if(trigger.isBefore) {
            if(trigger.isUpdate || trigger.isInsert) { 
                TMTriggerHandler.updateName(trigger.new);
            }
        }
    }
    
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)) {
        TMTriggerHandler.updateWOStatus(trigger.new, trigger.newMap);
        TMTriggerHandler.doChatterPost(trigger.new, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate);
    }
}