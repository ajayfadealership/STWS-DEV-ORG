/*
DO NOT TOUCH THIS CODE. Modify Handler for any changes.
Updated By: Sajal Bansal
*/
trigger CustomerInquiryTrigger on BOATBUILDING__Customer_Inquiry__c (before insert, before update,after insert, after update, before Delete, after delete) {
    
    Boolean isActive = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__CustomerInquiryTrigger__c;
    if(isActive){
        if(Trigger.isBefore && Trigger.isInsert) {
            CustomerInquiryTriggerHandler.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isBefore && Trigger.isUpdate) {
            CustomerInquiryTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isBefore && Trigger.isDelete) {
            CustomerInquiryTriggerHandler.onBeforeDelete(Trigger.old);
        }
        
        if(Trigger.isAfter && Trigger.isInsert) {
            CustomerInquiryTriggerHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            CustomerInquiryTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isDelete) {
            CustomerInquiryTriggerHandler.onAfterDelete(Trigger.old);
        }
    }
}