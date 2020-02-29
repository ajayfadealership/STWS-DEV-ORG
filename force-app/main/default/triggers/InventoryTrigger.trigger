trigger InventoryTrigger on BOATBUILDING__Inventory__c ( before insert , before update, after insert, after update) {
    
    Boolean isTriggerOn = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__InventoryTriggerCheckBox__c;
    
    if(isTriggerOn){
        if(trigger.isBefore && Trigger.isInsert){
            InventoryTriggerHandler.isBeforeInsert(trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isInsert) {
            InventoryTriggerHandler.onAfterInsert(trigger.new); 
        }
        
        if(trigger.isBefore && trigger.isUpdate) {
            InventoryTriggerHandler.isBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate){
            InventoryTriggerHandler.isAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);                
        }
    }
}