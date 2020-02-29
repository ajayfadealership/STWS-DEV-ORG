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
        InvoiceLineItemHandler.onAfterInsert(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        InvoiceLineItemHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        InvoiceLineItemHandler.onAfterDelete(Trigger.old);
    }
    
    /*
    if(Trigger.isBefore && Trigger.isDelete) {
        Map<String, Integer> mapPQ = new Map<String, Integer>();
        List<Invoice_Line_Item__c> lstILI = [Select Id, Name, Part_Number__c, Quantity__c, BOATBUILDING__Related_To_Invoice__c, BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c From Invoice_Line_Item__c Where Id IN: trigger.oldMap.keySet()];
        
        for(Invoice_Line_Item__c objILI: lstILI) {
            if(objILI.BOATBUILDING__Related_To_Invoice__c != null && objILI.BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c != null && objILI.BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c == 'Final') {
                if(String.isNotBlank(objILI.Part_Number__c) && objILI.Quantity__c != null) {
                    if(!mapPQ.containsKey(objILI.Part_Number__c)) {
                        mapPQ.put(objILI.Part_Number__c, 0);
                    }
                    
                    if(mapPQ.containsKey(objILI.Part_Number__c)) {
                        mapPQ.put(objILI.Part_Number__c, Integer.valueOf(mapPQ.get(objILI.Part_Number__c) + objILI.Quantity__c)); 
                    }
                }
            }
        }
        List<Inventory__c> lstInv = [Select Id, BOATBUILDING__Part_Number__c, Quantity__c, (Select Id, Quantity__c From BOATBUILDING__Parts_Availability__r Limit 1) From Inventory__c Where BOATBUILDING__Part_Number__c IN: mapPQ.keySet()];
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
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)) {
        Set<String> setPrtNum = new Set<String>();
        Map<String, String> mapPartId = new Map<String, String>();
        
        for(Invoice_Line_Item__c objJLI: trigger.new) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                setPrtNum.add(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [SELECT Id, Part_Cost__c, Part_Number__c FROM BOATBUILDING__Part__c WHERE Part_Number__c IN: setPrtNum];
        for(BOATBUILDING__Part__c objPrt: lstPrt) {
            if(objPrt.Part_Number__c != null) {   
                mapPartId.put(objPrt.Part_Number__c, objPrt.Id);  
            }
        }
        for(Invoice_Line_Item__c objJLI: trigger.new) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                objJLI.Part__c = mapPartId.get(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
    }*/
}