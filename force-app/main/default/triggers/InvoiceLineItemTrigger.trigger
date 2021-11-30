trigger InvoiceLineItemTrigger on Invoice_Line_Item__c (before insert, before update,after insert, after update, before Delete, after delete) {
    
    if(Trigger.isBefore && Trigger.isInsert) {
        InvoiceLineItemHandler.onBeforeInsert(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate) {
        InvoiceLineItemHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        InvoiceLineItemHandler.onBeforeDelete(Trigger.old);
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        InvoiceLineItemHandler.onAfterInsert(Trigger.newMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        InvoiceLineItemHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        InvoiceLineItemHandler.onAfterDelete(Trigger.oldMap);
    }
    
}