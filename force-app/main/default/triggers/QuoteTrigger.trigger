/*
DO NOT TOUCH THIS CODE. Modify Handler for any changes.
Updated By: Sajal Bansal
*/
trigger QuoteTrigger on Quote__c (before insert, before update,after insert, after update, before Delete, after delete) {
    
    Boolean isActive = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__QuoteTriggerCheckBox__c;
    if(isActive){
        if(Trigger.isBefore && Trigger.isInsert) {
            QuoteTriggerHandler.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isBefore && Trigger.isUpdate) {
            QuoteTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isBefore && Trigger.isDelete) {
            QuoteTriggerHandler.onBeforeDelete(Trigger.old);
        }
        
        if(Trigger.isAfter && Trigger.isInsert) {
            QuoteTriggerHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            QuoteTriggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isDelete) {
            QuoteTriggerHandler.onAfterDelete(Trigger.old);
        }
    }
}