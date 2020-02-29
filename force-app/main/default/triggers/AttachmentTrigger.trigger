trigger AttachmentTrigger on Attachment (after insert, before delete) {
    Set<Id> setInventoryId = new Set<Id>();
    List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
    
    if(trigger.isInsert){
        for(Attachment att: trigger.new){
            setInventoryId.add(att.ParentId);
        }
    }
    
    if(trigger.isdelete){
        for(Attachment att: trigger.old){
            setInventoryId.add(att.ParentId);
        }
    }
    
    for(BOATBUILDING__Inventory__c objInv: [Select Id, BOATBUILDING__Refresh_Images_on_Website__c from BOATBUILDING__Inventory__c where Id IN:setInventoryId]){
        objInv.BOATBUILDING__Refresh_Images_on_Website__c = True;
        lstInv.add(objInv);
        System.debug('lstInv'+lstInv);
    }
    
    if(lstInv.size()>0){
        update lstInv;
    }
}