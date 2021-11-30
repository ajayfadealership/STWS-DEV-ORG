trigger TMTrigger on BOATBUILDING__Time_Management__c (before insert, before update, after insert, after update) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__TMTriggerCheckBox__c;
    if(isOff==true){
        if(trigger.isBefore) {
            if(trigger.isInsert) { 
                TMTriggerHandler.updateName(trigger.new, new Map<Id, BOATBUILDING__Time_Management__c>());
            }
            if(trigger.isUpdate) {
                TMTriggerHandler.updateName(trigger.new, trigger.oldMap);
            }
        }
    }
    
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)) {
        TMTriggerHandler.updateWOStatus(trigger.new, trigger.newMap);
        TMTriggerHandler.doChatterPost(trigger.new, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate);
        TMTriggerHandler.updateScheduleDateTime(trigger.new, trigger.newMap, trigger.oldMap, trigger.isInsert, trigger.isUpdate);
    }
}