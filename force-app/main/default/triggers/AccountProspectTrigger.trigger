/** 
* Author : Akshay Kumar 
* Created Date : 07/11/2016
*/
trigger AccountProspectTrigger on Account (before insert, after insert, after update)
{
    Boolean isTriggerON = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__AccountProspectTriggerChackBox__c;
    if(isTriggerON){
        if(Trigger.isBefore && Trigger.isInsert){
            AccountProspectTriggerHandler.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isInsert){
            AccountProspectTriggerHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate){
            AccountProspectTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}