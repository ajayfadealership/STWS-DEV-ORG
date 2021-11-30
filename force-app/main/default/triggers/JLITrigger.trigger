trigger JLITrigger on Work_Order_Job_Line_Item__c (before insert, before update, after insert, after update, before delete, after delete) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__JLITriggerCheckBox__c;
    if(isOff==true){

        if(Trigger.isBefore && Trigger.isInsert) {
            JLITriggerHandler.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isBefore && Trigger.isUpdate) {
            JLITriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isBefore && Trigger.isDelete) {
            JLITriggerHandler.onBeforeDelete(Trigger.old);
        }
        
        if(Trigger.isAfter && Trigger.isInsert) {
            JLITriggerHandler.onAfterInsert(Trigger.newMap);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            JLITriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isDelete) {
            JLITriggerHandler.onAfterDelete(Trigger.old);
        }


        if(trigger.isAfter && trigger.isUpdate) {
            //JLITriggerHandler.onJLIQuantityChange(trigger.newMap, trigger.oldMap);
        }
    }
}