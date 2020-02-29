trigger JobTrigger on Job_Line_Item__c (after insert,after update,after delete) {
    /*if(trigger.isAfter && trigger.isInsert) {
        JLITriggertoCalculateShopSuppliesHandler.onAfterInsert(trigger.new);
    }
    if(trigger.isAfter && trigger.isUpdate) {
        JLITriggertoCalculateShopSuppliesHandler.onAfterInsert(trigger.new);
    }
    if(trigger.isAfter && trigger.isDelete) {
        JLITriggertoCalculateShopSuppliesHandler.onAfterDelete(trigger.old);
    }
    */
}