public with sharing class LowStockBackOrderController {
    
    public BOATBUILDING__Order__c objOrder { get; set; }
    
    public LowStockBackOrderController() {
        objOrder = new BOATBUILDING__Order__c();
    }
    
    @RemoteAction
    public static List<InventoryListViewWrapper> getLowStockPart() {
        List<Inventory__c> lstInv = new List<Inventory__c>();
        Id invRId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        BackOrderCount__c boc = BackOrderCount__c.getOrgDefaults();
        Decimal count = 0.00;
        if(boc.Back_Order_Min_Quantity__c != null) {
            count = boc.Back_Order_Min_Quantity__c;
        }
        List<InventoryListViewWrapper> lstInventoryListViewWrapper = new List<InventoryListViewWrapper>();
        
        List<RecordType> lstOrderRT = [SELECT           
                                       Id
                                       FROM    
                                       RecordType
                                       WHERE       
                                       DeveloperName = 'Order'
                                       AND
                                       SobjectType = 'BOATBUILDING__Order__c'
                                       LIMIT 
                                       1];
        Map<String, Integer> mapPartOnOrder = new Map<String, Integer>();
        if(lstOrderRT.size() > 0){
            for(BOATBUILDING__Line_Items__c objLI : [Select Id, Quantity__c, Part_Number_del__c From BOATBUILDING__Line_Items__c WHERE Order__r.RecordTypeId =: lstOrderRT[0].Id]) {
                if(!mapPartOnOrder.containsKey(objLI.Part_Number_del__c)) {
                    if(objLI.Quantity__c != null) {
                        mapPartOnOrder.put(String.valueOf(objLI.Part_Number_del__c), Integer.valueOf(objLI.Quantity__c));
                    }else {
                        mapPartOnOrder.put(String.valueOf(objLI.Part_Number_del__c), 0);
                    }
                } 
                else {
                    if(objLI.Quantity__c != null) {
                        Integer calValue = mapPartOnOrder.get(String.valueOf(objLI.Part_Number_del__c)) + Integer.valueOf(objLI.Quantity__c);
                        mapPartOnOrder.put(String.valueOf(objLI.Part_Number_del__c), calValue);
                    }else {
                        Integer calValue = mapPartOnOrder.get(String.valueOf(objLI.Part_Number_del__c)) + 0;
                        mapPartOnOrder.put(String.valueOf(objLI.Part_Number_del__c), calValue);
                    } 
                    
                }
            } 
        }
        
        List<BOATBUILDING__Inventory__c>  listInventoryToProcess = [SELECT  Name, Vendor__c, Vendor__r.Name, Part_Number__c, Description__c, Category__c, Map_Price__c, Discount__c, Family__c, Size__c, Color__c, Cost__c, Minimum_Amount__c, Part_Location__c, Part_MSRP_Price__c, Part_Name__c, Quantity__c  FROM  BOATBUILDING__Inventory__c  WHERE RecordTypeId =: invRId  AND Quantity__c <=: count limit 10000];
        if(invRId != null && lstOrderRT.size() > 0 && !listInventoryToProcess.isEmpty()) {
            for(BOATBUILDING__Inventory__c objInv1 : listInventoryToProcess) { 
                if(mapPartOnOrder.containsKey(String.valueOf(objInv1.Part_Number__c))) {                      
                    lstInventoryListViewWrapper.add(new InventoryListViewWrapper(objInv1, mapPartOnOrder.get(String.valueOf(objInv1.Part_Number__c))));
                }
                else {                    
                    lstInventoryListViewWrapper.add(new InventoryListViewWrapper(objInv1, 0));
                }
            }
        }
        
        return lstInventoryListViewWrapper;
    }
    
    public class InventoryListViewWrapper {
        public BOATBUILDING__Inventory__c objInventory { get; set; }
        public Integer partsOnOrder { get; set; }
        public InventoryListViewWrapper(BOATBUILDING__Inventory__c objInventory, Integer partsOnOrder) {
            this.objInventory = objInventory;
            this.partsOnOrder = partsOnOrder;
        }
    }
}