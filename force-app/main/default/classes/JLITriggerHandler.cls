public class JLITriggerHandler {

    public Static void onBeforeInsert(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem){
    }
    
    public Static void onBeforeUpdate(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem){
    }
    
    public Static void onBeforeDelete(List<Work_Order_Job_Line_Item__c> lstOldJobLnItem){
    }
    
    public Static void onAfterInsert(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem){
        updateInventoryQuantity(lstNewJobLnItem, null);
    }
    
    public Static void onAfterUpdate(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem){
        updateInventoryQuantity(lstNewJobLnItem, mapOldJobLineItem);
    }
    
    public Static void onAfterDelete(List<Work_Order_Job_Line_Item__c> lstOldJobLnItem){
        updateInventoryQuantity(lstOldJobLnItem, null);
    }

    public static void onBeforeInsertAndUpdate(List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI) {
        
        set<String>setPrtNum = new Set<String>();
        Map<String, Decimal> mapPartDetail = new Map<String, Decimal>();
        Map<String, String> mapPartId = new Map<String, String>();
        
        for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                setPrtNum.add(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [SELECT Id, Part_Cost__c, Part_Number__c FROM BOATBUILDING__Part__c WHERE Part_Number__c IN: setPrtNum];
        for(BOATBUILDING__Part__c objPrt: lstPrt) {
            if(objPrt.Part_Number__c != null) {
                mapPartDetail.put(objPrt.Part_Number__c, objPrt.Part_Cost__c);   
                mapPartId.put(objPrt.Part_Number__c, objPrt.Id);  
            }
        }
        for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                objJLI.Dealer_Price__c = mapPartDetail.get(objJLI.BOATBUILDING__Part_Number__c);
                objJLI.Part__c = mapPartId.get(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
    }   
    
    public static void onJLIQuantityChange(Map<Id, Work_Order_Job_Line_Item__c> newMapJLI, Map<Id, Work_Order_Job_Line_Item__c> oldMapJLI) {
        try {
            Map<String, Work_Order_Job_Line_Item__c> newMapJLI2 = new Map<String, Work_Order_Job_Line_Item__c>();
            Map<String, Work_Order_Job_Line_Item__c> oldMapJLI2 = new Map<String, Work_Order_Job_Line_Item__c>();
            
            for(Id objJILId: newMapJLI.keySet()) {
                if(String.isNotBlank(newMapJLI.get(objJILId).Part_Number__c) && newMapJLI.get(objJILId).Quantity__c != null) {
                    if(newMapJLI.get(objJILId).Quantity__c != oldMapJLI.get(objJILId).Quantity__c) {
                        newMapJLI2.put(newMapJLI.get(objJILId).Part_Number__c, newMapJLI.get(objJILId));
                        oldMapJLI2.put(oldMapJLI.get(objJILId).Part_Number__c, oldMapJLI.get(objJILId));
                    }  
                }
            }
            List<Inventory__c> lstInv = new List<Inventory__c>();
            
            
            for(Inventory__c objInv:        [Select 
                                                    Id, Part_Number__c, Quantity__c
                                            From
                                                    Inventory__c 
                                            Where
                                                    Part_Number__c IN: newMapJLI2.keySet()]) {
                                                        
                if(newMapJLI2.get(objInv.Part_Number__c).Quantity__c > oldMapJLI2.get(objInv.Part_Number__c).Quantity__c) {
                    Decimal Q = newMapJLI2.get(objInv.Part_Number__c).Quantity__c - oldMapJLI2.get(objInv.Part_Number__c).Quantity__c;
                    if(objInv.Quantity__c != null) {
                        objInv.Quantity__c -= Q;
                    } else {
                        objInv.Quantity__c = (0- Q);
                    }
                } else {
                    Decimal Q = oldMapJLI2.get(objInv.Part_Number__c).Quantity__c - newMapJLI2.get(objInv.Part_Number__c).Quantity__c;
                    if(objInv.Quantity__c != null) {
                        objInv.Quantity__c += Q;
                    } else {
                        objInv.Quantity__c = Q;
                    }
                }
                 
                lstInv.add(objInv);
            }
            if(!lstInv.isEmpty()) {
                update lstInv;
            }
        } catch(Exception ex) { 
            System.debug('Debug Log For Exception: '+ex);
        }
    }
    
    /*public static void onBeforeDelete(List<Work_Order_Job_Line_Item__c> oldLstJLI) {
        /*Map<String, Work_Order_Job_Line_Item__c> oldMapJLI = new Map<String, Work_Order_Job_Line_Item__c>();  
        for(Work_Order_Job_Line_Item__c objJlI: oldLstJLI) {
            if(String.isNotBlank(objJlI.Part_Number__c) && objJlI.Quantity__c != null) {
                oldMapJLI.put(objJlI.Part_Number__c, objJlI);
            }
        }
        List<Inventory__c> lstInv = new List<Inventory__c>();
        Set<String> setInvPrtNum = new Set<String>();    
            
        for(Inventory__c objInv:        [Select 
                                                    Id, Part_Number__c, Quantity__c
                                            From
                                                    Inventory__c 
                                            Where
                                                    Part_Number__c IN: oldMapJLI.keySet()]) {
        
            if(objInv.Quantity__c != null) {
                objInv.Quantity__c += oldMapJLI.get(objInv.Part_Number__c).Quantity__c;
            } else {
                objInv.Quantity__c = oldMapJLI.get(objInv.Part_Number__c).Quantity__c;
            }
            lstInv.add(objInv);
            setInvPrtNum.add(objInv.Part_Number__c);
        }
        Id invRId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        
        
        for(Part__c objPrt : [Select 
                                        Id, Name, Part_Number__c, Retail_Price__c, Map_Price__c, Weight__c, Part_Size__c, Part_Color__c, Part_Cost__c, Minimum_Amount__c, Location__c, Vendor_Name__c
                                From
                                        Part__c
                                Where
                                        Part_Number__c IN: oldMapJLI.keySet() 
                                AND 
                                        Part_Number__c NOT IN: setInvPrtNum]) { 
            
                Inventory__c objInv = new Inventory__c();
                objInv.RecordTypeId = invRId;
                objInv.Part_Name__c = oldMapJLI.get(objPrt.Part_Number__c).Part_Name__c;
                objInv.Part_Number__c = objPrt.Part_Number__c;
                objInv.Part_MSRP_Price__c = objPrt.Retail_Price__c;
                objInv.Map_Price__c = objPrt.Map_Price__c;
                objInv.Weight__c = objPrt.Weight__c;
                objInv.Size__c = objPrt.Part_Size__c;
                objInv.Color__c = objPrt.Part_Color__c;
                objInv.Cost__c = objPrt.Part_Cost__c;
                objInv.Minimum_Amount__c = objPrt.Minimum_Amount__c;
                objInv.Location__c = objPrt.Location__c; 
                objInv.Vendor__c = objPrt.Vendor_Name__c;
                objInv.Quantity__c = oldMapJLI.get(objPrt.Part_Number__c).Quantity__c;
                lstInv.add(objInv);    
        }
        
        if(!lstInv.isEmpty()) {
            upsert lstInv; 
        }
    } */

    public Static void updateInventoryQuantity(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem){
        
        Set<String> setInvLineItemId = new Set<String>();
        Set<String> setInventoryId = new Set<String>();
        List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
        for(Work_Order_Job_Line_Item__c objJobLineItem: lstNewJobLnItem) {
            if(objJobLineItem.BOATBUILDING__Quantity__c != null){
                PartInventoryManagerController.PartInventoryWrapper objWrap = new PartInventoryManagerController.PartInventoryWrapper();
                objWrap.inventoryId = objJobLineItem.BOATBUILDING__Select_Part__c;
                objWrap.storeLocation = objJobLineItem.BOATBUILDING__Store_Location__c;
                if(mapOldJobLineItem == null){
                    if(Trigger.isDelete){
                        objWrap.quantity = 0 - objJobLineItem.BOATBUILDING__Quantity__c;
                    } else {
                        objWrap.quantity = objJobLineItem.BOATBUILDING__Quantity__c;
                    }
                    
                } else if(objJobLineItem.BOATBUILDING__Quantity__c != mapOldJobLineItem.get(objJobLineItem.Id).BOATBUILDING__Quantity__c){
                    objWrap.quantity = objJobLineItem.BOATBUILDING__Quantity__c - mapOldJobLineItem.get(objJobLineItem.Id).BOATBUILDING__Quantity__c;
                }
                listWrapToProcess.add(objWrap);
            }
        }
        PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
    }
}