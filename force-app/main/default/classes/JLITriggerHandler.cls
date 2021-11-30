public class JLITriggerHandler {

    public Static void onBeforeInsert(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem){
        updatePartLookup(lstNewJobLnItem);
    }
    
    public Static void onBeforeUpdate(List<Work_Order_Job_Line_Item__c> lstNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem){ }
    
    public Static void onBeforeDelete(List<Work_Order_Job_Line_Item__c> lstOldJobLnItem){ }
    
    public Static void onAfterInsert(Map<Id, Work_Order_Job_Line_Item__c> mapNewJobLnItem){
        try {
            updateInventoryQuantity( getJLIToManageInventory( mapNewJobLnItem, new Map<Id, Work_Order_Job_Line_Item__c>() ), null);
        } catch(Exception ex) {
            System.debug('onAfterInsert: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Job Line Item';
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
    
    public Static void onAfterUpdate(Map<Id, Work_Order_Job_Line_Item__c> mapNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem){
        try {
            updateInventoryQuantity( getJLIToManageInventory( mapNewJobLnItem, mapOldJobLineItem ), mapOldJobLineItem);
        } catch(Exception ex) {
            System.debug('onAfterUpdate: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Job Line Item';
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
    
    public Static void onAfterDelete(List<Work_Order_Job_Line_Item__c> lstOldJobLnItem){
        try {
            updateInventoryQuantity(lstOldJobLnItem, null);
        } catch(Exception ex) {
            System.debug('onAfterUpdate: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Inv Management From Job Line Item';
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

    private static List<Work_Order_Job_Line_Item__c> getJLIToManageInventory(Map<Id, Work_Order_Job_Line_Item__c> mapNewJobLnItem, Map<Id, Work_Order_Job_Line_Item__c> mapOldJobLineItem) {
        System.debug('getJLIToManageInventory : ');
        List<Work_Order_Job_Line_Item__c> lstJLI = new List<Work_Order_Job_Line_Item__c>();
        List<Work_Order_Job_Line_Item__c> lstJLIQuoteCheck = [  SELECT  Id, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Related_to_Job__c,
                                                                        BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c,
                                                                        BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c, BOATBUILDING__Select_Part__c
                                                                FROM    BOATBUILDING__Work_Order_Job_Line_Item__c WHERE Id IN :mapNewJobLnItem.keySet()];
        for(Work_Order_Job_Line_Item__c objJLI : lstJLIQuoteCheck) {
            System.debug('Status: '+objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c);
            System.debug('Status: '+objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
            System.debug('Status: '+objJLI.BOATBUILDING__Related_to_Job__c);
            if(objJLI.BOATBUILDING__Related_to_Job__c != null && objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null
                && objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c != 'Quote' &&
                    (mapOldJobLineItem.isEmpty() || mapOldJobLineItem.get(objJLI.Id).BOATBUILDING__Quantity__c != objJLI.BOATBUILDING__Quantity__c) ) {
                        System.debug('objJLI.BOATBUILDING__Quantity__c : '+objJLI.BOATBUILDING__Quantity__c);
                        lstJLI.add(objJLI);
            }
        }
        return lstJLI;
    }

    public static void updatePartLookup(List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI) {
        try {
            set<String>setPrtNum = new Set<String>();
            Map<String, BOATBUILDING__Part__c> mapPart = new Map<String, BOATBUILDING__Part__c>();
            Set<Id> setWOJId = new Set<Id>();
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
                if(objJLI.BOATBUILDING__Part_Number__c != null) {
                    setPrtNum.add(objJLI.BOATBUILDING__Part_Number__c);
                }
                setWOJId.add(objJLI.BOATBUILDING__Related_to_Job__c);
            }
            List<BOATBUILDING__Part__c> lstPrt = [SELECT Id, Part_Cost__c, Part_Number__c FROM BOATBUILDING__Part__c WHERE Part_Number__c IN: setPrtNum];
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                if(objPrt.Part_Number__c != null) {
                    mapPart.put(objPrt.Part_Number__c, objPrt);  
                }
            }
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
                if(objJLI.BOATBUILDING__Part_Number__c != null && mapPart.containsKey(objJLI.BOATBUILDING__Part_Number__c)) {
                    objJLI.Part__c = mapPart.get(objJLI.BOATBUILDING__Part_Number__c).Id;
                }
            }
            Map<Id, BOATBUILDING__Work_Order_Job__c> mapWOJ = new Map<Id, BOATBUILDING__Work_Order_Job__c>([SELECT Id, Store_Location__c FROM BOATBUILDING__Work_Order_Job__c WHERE Id IN :setWOJId]);
            List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part_Number__c  FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__Part_Number__c IN: setPrtNum];
            Map<String, BOATBUILDING__Inventory__c> mapInv = new Map<String, BOATBUILDING__Inventory__c>();
            for(BOATBUILDING__Inventory__c objInv: listInvToQuery) {
                mapInv.put(objInv.BOATBUILDING__Part_Number__c, objInv);
            }
            Map<String, String> mapPartNumberStoreLocation = new Map<String, String>();
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
                if(objJLI.BOATBUILDING__Part_Number__c != null) {
                    if(!mapInv.containsKey(objJLI.BOATBUILDING__Part_Number__c)) {
                        mapPartNumberStoreLocation.put(objJLI.BOATBUILDING__Part_Number__c, mapWOJ.get(objJLI.BOATBUILDING__Related_to_Job__c).Store_Location__c);
                    }
                    else {
                        objJLI.BOATBUILDING__Select_Part__c = mapInv.get(objJLI.BOATBUILDING__Part_Number__c).Id;
                    }
                }
            }
            Map<String, Id> mapPartNumberInvId = PartInventoryManagerController.generateInventory(mapPartNumberStoreLocation);
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstJLI) {
                if(mapPartNumberInvId.containsKey(objJLI.BOATBUILDING__Part_Number__c)) {
                    objJLI.BOATBUILDING__Select_Part__c = mapPartNumberInvId.get(objJLI.BOATBUILDING__Part_Number__c);
                }
            }
        } catch(Exception ex) {
            System.debug('on Before: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'JLI From updatePartLookup Method';
                String customLog = 'updatePartLookup : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }   
    

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
        System.debug('listWrapToProcess : '+listWrapToProcess);
        PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
    }
}