/** 
* Author : Pradeep Thakur
* Created Date : 05/20/2017
*/
trigger PaymentTrigger on Payment__c (before insert, after insert, after update) {
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__PaymentTriggerCheckBox__c;
    if(isOff==true){
    if(Trigger.isBefore){
       if(Trigger.isInsert){
          // PaymentTriggerHandler.onBeforeInsert(Trigger.new);
       }
   
   }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            PaymentTriggerHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            PaymentTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    } 
   
    }   
}