trigger JLITrigger on Work_Order_Job_Line_Item__c (before insert, before update, after insert, after update, before delete, after delete) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__JLITriggerCheckBox__c;
    if(isOff==true){

        if(Trigger.isBefore && Trigger.isInsert) {
            JLITriggerHandler.onBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isBefore && Trigger.isUpdate) {
            JLITriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isBefore && Trigger.isDelete) {
            JLITriggerHandler.onBeforeDelete(Trigger.old);
        }
        
        if(Trigger.isAfter && Trigger.isInsert) {
            JLITriggerHandler.onAfterInsert(Trigger.new);
        }
        
        if(Trigger.isAfter && Trigger.isUpdate) {
            JLITriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isDelete) {
            JLITriggerHandler.onAfterDelete(Trigger.old);
        }

        if(trigger.isBefore) {
            if(trigger.isInsert) {
                JLITriggerHandler.onBeforeInsertAndUpdate(trigger.new);
            }
            if(trigger.isUpdate) {
                JLITriggerHandler.onBeforeInsertAndUpdate(trigger.new);
            }
            if(trigger.isDelete) {
                JLITriggerHandler.onBeforeDelete(trigger.old);
            }
        } 
        if(trigger.isAfter && trigger.isUpdate) {
            JLITriggerHandler.onJLIQuantityChange(trigger.newMap, trigger.oldMap);
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        Map<String, Integer> mapPQ = new Map<String, Integer>();
        
        for(BOATBUILDING__Work_Order_Job_Line_Item__c objILI: Trigger.old) {
            if(String.isNotBlank(objILI.Part_Number__c) && objILI.Quantity__c != null) {
                if(!mapPQ.containsKey(objILI.Part_Number__c)) {
                    mapPQ.put(objILI.Part_Number__c, 0);
                }
                
                if(mapPQ.containsKey(objILI.Part_Number__c)) {
                    mapPQ.put(objILI.Part_Number__c, Integer.valueOf(mapPQ.get(objILI.Part_Number__c) + objILI.Quantity__c)); 
                }
            }
        }
        System.debug('>>>>mapPQ: '+mapPQ);
        List<Inventory__c> lstInv = [Select Id, BOATBUILDING__Part_Number__c, Quantity__c, (Select Id, Quantity__c From BOATBUILDING__Parts_Availability__r Limit 1) From Inventory__c Where BOATBUILDING__Part_Number__c IN: mapPQ.keySet()];
        System.debug('>>>>lstInv: '+lstInv);
        List<BOATBUILDING__Parts_Availability__c> lstPA = new List<BOATBUILDING__Parts_Availability__c>();
        List<Inventory__c> lstInvv = new List<Inventory__c>();
        for(Inventory__c objInv: lstInv) {
            if(!objInv.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                objInv.BOATBUILDING__Parts_Availability__r[0].Quantity__c += mapPQ.get(objInv.BOATBUILDING__Part_Number__c);
            	lstPA.add(objInv.BOATBUILDING__Parts_Availability__r[0]);
            } else {
                objInv.Quantity__c += mapPQ.get(objInv.BOATBUILDING__Part_Number__c);
               lstInvv.add(objInv);
            }
            
        }
        
        if(!lstInvv.isEmpty()) {
            update lstInvv;
        }
        
         if(!lstPA.isEmpty()) {
            update lstPA;
        }

    }
}