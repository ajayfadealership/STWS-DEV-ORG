/*
DO NOT TOUCH THIS CODE. Modify Handler for any changes.
Updated By: Sajal Bansal
*/
trigger PaymentsTrigger on Payments__c (before insert, before update,after insert, after update, before Delete, after delete) {
    
    if(Trigger.isBefore && Trigger.isInsert) {
        PaymentsTriggerHandler.onBeforeInsert(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        PaymentsTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        PaymentsTriggerHandler.onBeforeDelete(Trigger.old);
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        PaymentsTriggerHandler.onAfterInsert(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        PaymentsTriggerHandler.onAfterUpdate(Trigger.new, Trigger.newMap, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        PaymentsTriggerHandler.onAfterDelete(Trigger.old);
    }
}