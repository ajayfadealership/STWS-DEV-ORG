/** 
* Author : vivek chauhan
* Created Date : 07/11/2016
*/
trigger UserTrigger on User (after insert, after update,before insert,before update) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__UserTriggerCheckBox__c;
    if(isOff==true){

    if(Trigger.isBefore && Trigger.isInsert){
        UserTriggerHandler.countAccountOnAssignedUserinsert(Trigger.new);
    }
    if(Trigger.isbefore && Trigger.isupdate)
    {
     //UserTriggerHandler.countAccountOnAssignedUserupdate(Trigger.new);
    }
   }  
}