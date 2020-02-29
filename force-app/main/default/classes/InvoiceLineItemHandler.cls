public class InvoiceLineItemHandler{
    
    public Static void onBeforeInsert(List<Invoice_Line_Item__c> lstNewInvLnItem){
        updateInventoryPartLookupOnInvoiceLine(lstNewInvLnItem);
    }
    
    public Static void onBeforeUpdate(List<Invoice_Line_Item__c> lstNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        updateInventoryPartLookupOnInvoiceLine(lstNewInvLnItem);
    }
    
    public Static void onBeforeDelete(List<Invoice_Line_Item__c> lstOldInvLnItem){
    }
    
    public Static void onAfterInsert(List<Invoice_Line_Item__c> lstNewInvLnItem){
        updateInventoryQuantity(lstNewInvLnItem, null);
    }
    
    public Static void onAfterUpdate(List<Invoice_Line_Item__c> lstNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        updateInventoryQuantity(lstNewInvLnItem, mapOldInvLineItem);
    }
    
    public Static void onAfterDelete(List<Invoice_Line_Item__c> lstOldInvLnItem){
        updateInventoryQuantity(lstOldInvLnItem, null);
    }
    
    public Static void createQBInvoiceLineItem(list<Invoice_Line_Item__c> lstInvLnItem){
        String payload;
        
        /*  Set<Id> accID = new Set<Id>();
for(Invoice_Line_Item__c inv : lstInvLnItem){
accID.add(inv.Account_Name__c);
}
System.debug('===accID==='+accID);
Map<id,Account> mapAcc = new Map<id,Account>([Select id,QBCustomerID__c from Account where id IN: accID]);
System.debug('===mapAcc===='+mapAcc);

for(Invoice__c inv: lstInv){
System.debug('==inv.Account_Name__r.QBCustomerID__c===' +mapAcc.get(inv.Account_Name__c).QBCustomerID__c);
payload = generateInvoiceJson(inv, mapAcc.get(inv.Account_Name__c).QBCustomerID__c);
NewQBConnectTest.CreateQBInvoice(payload, inv.id);
}

System.debug('====payload===='+payload);
*/
    }
    
    public Static void updateInventoryPartLookupOnInvoiceLine(List<Invoice_Line_Item__c> lstNewInvLnItem){
        Set<String> setPrtNum = new Set<String>();
        Map<String, BOATBUILDING__Inventory__c> mapPartNumberToInventory = new Map<String, BOATBUILDING__Inventory__c>();
        
        for(Invoice_Line_Item__c objJLI: lstNewInvLnItem) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                setPrtNum.add(objJLI.BOATBUILDING__Part_Number__c);
            }
        }
        
        List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                           FROM BOATBUILDING__Inventory__c 
                                                           WHERE BOATBUILDING__Part_Number__c IN: setPrtNum];
        
        for(BOATBUILDING__Inventory__c objInventory: listInvToQuery) {
            if(objInventory.BOATBUILDING__Part_Number__c != null) {   
                mapPartNumberToInventory.put(objInventory.Part_Number__c, objInventory);  
            }
        }
        
        for(Invoice_Line_Item__c objJLI: lstNewInvLnItem) {
            if(objJLI.BOATBUILDING__Part_Number__c != null) {
                if(mapPartNumberToInventory.containsKey(objJLI.BOATBUILDING__Part_Number__c)){
                    objJLI.Part__c = mapPartNumberToInventory.get(objJLI.BOATBUILDING__Part_Number__c).BOATBUILDING__Part__c;
                    objJLI.BOATBUILDING__Inventory__c = mapPartNumberToInventory.get(objJLI.BOATBUILDING__Part_Number__c).Id;
                }
            }
        }
    }
    
    public Static void updateInventoryQuantity(List<Invoice_Line_Item__c> lstNewInvLnItem, Map<Id, Invoice_Line_Item__c> mapOldInvLineItem){
        
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
            }
        }
        PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
    }
}