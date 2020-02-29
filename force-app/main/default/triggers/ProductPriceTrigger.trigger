/**
* Author       : Akshay Kumar
* Organization : 360 Degree Cloud Techonologies Pvt. Ltd.
* Date         : 17/01/2017   
*/
trigger ProductPriceTrigger on BOATBUILDING__ProductPrice__c (after insert, after update) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__ProductPriceTriggerCheckBox__c;
    if(isOff==true){
        if(trigger.isAfter) {
            if(trigger.isInsert) {
                ProductPriceTriggerHandler.onAfterInsert(trigger.new);
            }
            if(trigger.isUpdate) {
                ProductPriceTriggerHandler.onAfterUpdate(trigger.new);
            }
        }
    }
}