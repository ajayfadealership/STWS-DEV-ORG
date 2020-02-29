trigger LeadTrigger on Lead (after insert) {
    
    Boolean isActive = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__LeadTriggerCheckBox__c;
    if(isActive){
        if(Trigger.isAfter && Trigger.isInsert){
            LeadTriggerHandler.isAfterInsert(Trigger.new);
        }
    }
}