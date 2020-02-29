trigger EventTrigger on Event (after insert, after update) {
    
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__EventTriggerCheckBox__c;
    if(isOff==true){
        
        if(Trigger.isAfter)
        {
            if(Trigger.isInsert)
            {
                EventTriggerHandler.afterInsert(Trigger.new);
                EventTriggerHandler.afterInsertCount(Trigger.newMap);
            }
            if(Trigger.isUpdate){
                EventTriggerHandler.afterUpdate(Trigger.new);
            }
            
        }
    }
}