trigger ContactTrigger on Contact (after insert, after update) {
    
    BOATBUILDING__TriggerSetting__c support = BOATBUILDING__TriggerSetting__c.getInstance();
    Boolean isOn = support.BOATBUILDING__ContactTriggerCheckbox__c;
    if(isOn){
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                ContactTriggerHandler.onAfterInsert(Trigger.new);
            }
            
            if(Trigger.isUpdate ){
                ContactTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }
        } 
    }
}