trigger ChangeInventoryQuantity on Invoice__c (after update , after insert, after delete) {
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__ChangeInventoryQuantityCheckBox__c;
    if(isOff==true){
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            ChangeInventoryQuantityHandler.onUpdate(Trigger.new,Trigger.old);
        }
     }
   }
}