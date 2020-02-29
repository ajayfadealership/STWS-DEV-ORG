trigger PartTrigger on Part__c (after update, after insert) {
    
    Boolean isActive = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__PartTrigger__c;
    if(isActive){
        if(Trigger.isAfter && Trigger.isUpdate) {
            PartTriggerHandler.onAfterUpdate(trigger.newMap, trigger.oldMap);
        } 
        if(Trigger.isAfter && Trigger.isInsert){
        	PartTriggerHandler.onAfterInsert(Trigger.new);    
        }
    }
}