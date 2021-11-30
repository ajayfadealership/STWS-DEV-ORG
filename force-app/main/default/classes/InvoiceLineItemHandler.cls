public class InvoiceLineItemHandler{
    
    public Static void onBeforeInsert(List<Invoice_Line_Item__c> lstNewInvLnItem){
        updateInventoryPartLookupOnInvoiceLine(lstNewInvLnItem);
    }
    
    public Static void onBeforeUpdate(List<Invoice_Line_Item__c> lstNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        updateInventoryPartLookupOnInvoiceLine(lstNewInvLnItem);
    }
    
    public Static void onBeforeDelete(List<Invoice_Line_Item__c> lstOldInvLnItem){
    }
    
    public Static void onAfterInsert(Map<Id, Invoice_Line_Item__c> mapNewInvLnItem){
        try {
            updateInventoryQuantity(getILIToManageInventory( mapNewInvLnItem, new Map<Id, Invoice_Line_Item__c>()), null);
        } catch(Exception ex) {
            System.debug('onAfterInsert: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv From Invoice Line Item';
                String customLog = 'onAfterInsert : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
             }
        }
    }
    
    public Static void onAfterUpdate(Map<Id, Invoice_Line_Item__c> mapNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        try {
            updateInventoryQuantity(getILIToManageInventory( mapNewInvLnItem, mapOldInvLineItem ), mapOldInvLineItem);
        } catch(Exception ex) {
            System.debug('onAfterUpdate: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Invoice Line Item';
                String customLog = 'onAfterUpdate : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }
    
    public Static void onAfterDelete(Map<Id, Invoice_Line_Item__c> mapOldInvLnItem) {
        try {
            Set<String> setInvId = new Set<String>();
            Map<String, List<Invoice_Line_Item__c>> mapInvILI = new Map<String, List<Invoice_Line_Item__c>>();
            for(Invoice_Line_Item__c objILI : mapOldInvLnItem.values()) {
                setInvId.add(objILI.BOATBUILDING__Related_To_Invoice__c);
                List<Invoice_Line_Item__c> lst = mapInvILI.get(objILI.BOATBUILDING__Related_To_Invoice__c);
                if(lst== null) {
                    lst = new List<Invoice_Line_Item__c>();
                }
                lst.add( objILI );
                mapInvILI.put(objILI.BOATBUILDING__Related_To_Invoice__c, lst);
            }
            List<BOATBUILDING__Invoice__c> lstInv = [SELECT Id, BOATBUILDING__Invoice_Status__c From BOATBUILDING__Invoice__c WHERE Id IN :setInvId];
            List<Invoice_Line_Item__c> lstILIToUpdateInventory = new List<Invoice_Line_Item__c>();
            for(BOATBUILDING__Invoice__c objI : lstInv) {
                if(objI.BOATBUILDING__Invoice_Status__c != 'Quote' && mapInvILI.containsKey(objI.Id)) {
                    lstILIToUpdateInventory.addAll(mapInvILI.get(objI.Id));
                }
            }
            if( !lstILIToUpdateInventory.isEmpty() ) {
                updateInventoryQuantity(lstILIToUpdateInventory, null);
            }
        } catch(Exception ex) {
            System.debug('onAfterDelete: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Invoice Line Item';
                String customLog = 'onAfterDelete : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }
    

    private static List<Invoice_Line_Item__c> getILIToManageInventory(Map<Id, Invoice_Line_Item__c> mapNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem) {
        System.debug('getILIToManageInventory: ');
        List<Invoice_Line_Item__c> lstILI = new List<Invoice_Line_Item__c>();
        List<Invoice_Line_Item__c> lstILIQuoteCheck = [ SELECT Id, BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c, BOATBUILDING__Quantity__c, BOATBUILDING__Inventory__c, BOATBUILDING__Store_Location__c 
                                                        FROM Invoice_Line_Item__c WHERE Id IN :mapNewInvLnItem.keySet()];
        for(Invoice_Line_Item__c objILI : lstILIQuoteCheck) {
            if(objILI.BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c != 'Quote' 
                && (mapOldInvLineItem.isEmpty() || objILI.BOATBUILDING__Quantity__c != mapOldInvLineItem.get(objILI.Id).BOATBUILDING__Quantity__c)) {
                    System.debug('getILIToManageInventory objILI: '+objILI);
                lstILI.add(objILI);
            }
        }
        return lstILI;
    }

    public Static void createQBInvoiceLineItem(list<Invoice_Line_Item__c> lstInvLnItem){
        String payload;
    }
    
    public Static void updateInventoryPartLookupOnInvoiceLine(List<Invoice_Line_Item__c> lstNewInvLnItem) {
        Map<String, BOATBUILDING__Inventory__c> mapPartNumberToInventory = new Map<String, BOATBUILDING__Inventory__c>();
        Map<String, Invoice_Line_Item__c> mapPartNumberILI = new Map<String, Invoice_Line_Item__c>();
        Set<Id> setInv = new Set<Id>();
        for(Invoice_Line_Item__c objJLI: lstNewInvLnItem) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                mapPartNumberILI.put(objJLI.BOATBUILDING__Part_Number__c, objJLI);
            }
            setInv.add(objJLI.BOATBUILDING__Related_To_Invoice__c);
        }
        Map<Id, Invoice__c> mapInv = new Map<Id, Invoice__c>([SELECT Id, Store_Location__c FROM Invoice__c WHERE Id IN :setInv]);

        List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                           FROM BOATBUILDING__Inventory__c 
                                                           WHERE BOATBUILDING__Part_Number__c IN: mapPartNumberILI.keySet()];
        Map<String, String> mapPartNumberStoreLocation = new Map<String, String>();
        for(BOATBUILDING__Inventory__c objInventory: listInvToQuery) {
            mapPartNumberToInventory.put(objInventory.Part_Number__c, objInventory);  
        }
        
        for(Invoice_Line_Item__c objJLI: lstNewInvLnItem) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                if(mapPartNumberToInventory.containsKey(objJLI.BOATBUILDING__Part_Number__c)){
                    objJLI.Part__c = mapPartNumberToInventory.get(objJLI.BOATBUILDING__Part_Number__c).BOATBUILDING__Part__c;
                    objJLI.BOATBUILDING__Inventory__c = mapPartNumberToInventory.get(objJLI.BOATBUILDING__Part_Number__c).Id;
                } else {
                    mapPartNumberStoreLocation.put(objJLI.BOATBUILDING__Part_Number__c, mapInv.get(objJLI.BOATBUILDING__Related_To_Invoice__c).Store_Location__c);
                }
            }
        }
        Map<String, Id> mapPartNumberInvId = PartInventoryManagerController.generateInventory(mapPartNumberStoreLocation);
        for(Invoice_Line_Item__c objJLI: lstNewInvLnItem) {
            if(objJLI.BOATBUILDING__Part_Number__c != null && mapPartNumberInvId.containsKey(objJLI.BOATBUILDING__Part_Number__c)) {
                objJLI.BOATBUILDING__Inventory__c = mapPartNumberInvId.get(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
    }
    
    public Static void updateInventoryQuantity(List<Invoice_Line_Item__c> lstNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        System.debug('lstNewInvLnItem: '+lstNewInvLnItem);
        Set<String> setInvLineItemId = new Set<String>();
        Set<String> setInventoryId = new Set<String>();
        List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
        for(Invoice_Line_Item__c objInvLineItem: lstNewInvLnItem) {
            if(objInvLineItem.BOATBUILDING__Quantity__c != null){
                PartInventoryManagerController.PartInventoryWrapper objWrap = new PartInventoryManagerController.PartInventoryWrapper();
                objWrap.inventoryId = objInvLineItem.BOATBUILDING__Inventory__c;
                objWrap.storeLocation = objInvLineItem.BOATBUILDING__Store_Location__c;
                if(mapOldInvLineItem == null){
                    if(Trigger.isDelete){
                        objWrap.quantity = 0 - objInvLineItem.BOATBUILDING__Quantity__c;
                    } else {
                        objWrap.quantity = objInvLineItem.BOATBUILDING__Quantity__c;
                    }
                    
                } else if(objInvLineItem.BOATBUILDING__Quantity__c != mapOldInvLineItem.get(objInvLineItem.Id).BOATBUILDING__Quantity__c){
                    objWrap.quantity = objInvLineItem.BOATBUILDING__Quantity__c - mapOldInvLineItem.get(objInvLineItem.Id).BOATBUILDING__Quantity__c;
                }
                listWrapToProcess.add(objWrap);
                System.debug('objWrap: '+objWrap);
            }
        }
        System.debug('listWrapToProcess: '+listWrapToProcess);
        PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
    }
}