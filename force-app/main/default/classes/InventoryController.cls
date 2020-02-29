public with sharing class InventoryController {

    public BOATBUILDING__Inventory__c objInventory { get;set; }
    public transient List<InventoryListViewWrapper> lstInventoryListViewWrapper { get; set; }
    public transient List<BOATBUILDING__Inventory__c> listInventoryToProcess {get; set;}
    public InventoryController() {
       lstInventoryListViewWrapper = new List<InventoryListViewWrapper>();
        List<RecordType> lstInventoryRT = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Inventory_for_Parts'
                                        AND
                                                SobjectType = 'BOATBUILDING__Inventory__c'
                                        LIMIT 
                                                1];
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
            for(BOATBUILDING__Line_Items__c objLI : [Select Id, Quantity__c, Part_Number_del__c From BOATBUILDING__Line_Items__c WHERE Order__r.RecordTypeId =: lstOrderRT[0].Id ORDER BY CreatedDate DESC]) {
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
        
        listInventoryToProcess = [SELECT  Name, Vendor__c, Vendor__r.Name, Part_Number__c, Description__c, Category__c, Map_Price__c, Discount__c, Family__c, Size__c, Color__c, Cost__c, Minimum_Amount__c, Part_Location__c, Part_MSRP_Price__c, Part_Name__c, Quantity__c  FROM  BOATBUILDING__Inventory__c  WHERE RecordTypeId = :lstInventoryRT[0].Id  ORDER BY CreatedDate DESC limit 1000];
        if(lstInventoryRT.size()>0 && lstOrderRT.size() > 0 && !listInventoryToProcess.isEmpty()) {
            for(BOATBUILDING__Inventory__c objInv1 : listInventoryToProcess) {
                if(mapPartOnOrder.containsKey(String.valueOf(objInv1.Part_Number__c))) {  
                    if(lstInventoryListViewWrapper.size() < 1000) {
                        lstInventoryListViewWrapper.add(new InventoryListViewWrapper(objInv1, mapPartOnOrder.get(String.valueOf(objInv1.Part_Number__c))));
                    }
                }
                else {
                    if(lstInventoryListViewWrapper.size() < 1000) {
                        lstInventoryListViewWrapper.add(new InventoryListViewWrapper(objInv1, 0));
                    }
                }
            }
        }
        if(lstInventoryRT.size()>0) {
            objInventory = new BOATBUILDING__Inventory__c(RecordTypeId = lstInventoryRT[0].Id);
        }
        
    }

     @RemoteAction
    public static String saveInventory(Map<String,String> objInventoryMap) {
        BOATBUILDING__Inventory__c objInventory2 = new BOATBUILDING__Inventory__c();
        
        
            objInventory2.Vendor__c = objInventoryMap.get('vendor');
                
            if(objInventoryMap.get('MSRP')!=null && objInventoryMap.get('MSRP')!='') {
                objInventory2.Part_MSRP_Price__c = Decimal.valueOf(objInventoryMap.get('MSRP'));
            }
            
             if(objInventoryMap.get('InvPartWeight')!=null && objInventoryMap.get('InvPartWeight')!='') {
                objInventory2.Weight__c = objInventoryMap.get('InvPartWeight');
            }
            
            if(objInventoryMap.get('Quantity')!=null && objInventoryMap.get('Quantity')!='') {
                objInventory2.Quantity__c = Integer.valueOf(objInventoryMap.get('Quantity'));
            }
            if(objInventoryMap.get('Description')!=null && objInventoryMap.get('Description')!='') {
                objInventory2.Part_Name__c = objInventoryMap.get('Description');
            }
            
            if(objInventoryMap.get('PartNumber')!=null && objInventoryMap.get('PartNumber')!='') {
                objInventory2.Part_Number__c = objInventoryMap.get('PartNumber');
            }
            
            if(objInventoryMap.get('Category')!=null && objInventoryMap.get('Category')!='') {
                objInventory2.Category__c = objInventoryMap.get('Category');
            }
            
             if(objInventoryMap.get('MapPrice')!=null && objInventoryMap.get('MapPrice')!='') {
                objInventory2.Map_Price__c = Decimal.valueOf(objInventoryMap.get('MapPrice'));
            }
            
            if(objInventoryMap.get('Discount')!=null && objInventoryMap.get('Discount')!='') {
                objInventory2.Discount__c = Decimal.valueOf(objInventoryMap.get('Discount'));
            }
            
            if(objInventoryMap.get('Family')!=null && objInventoryMap.get('Family')!='') {
                objInventory2.Family__c = objInventoryMap.get('Family');
            }
            
            if(objInventoryMap.get('Size')!=null && objInventoryMap.get('Size')!='') {
                objInventory2.Size__c = objInventoryMap.get('Size');
            }
            
            if(objInventoryMap.get('Color')!=null && objInventoryMap.get('Color')!='') {
                objInventory2.Color__c = objInventoryMap.get('Color');
            }
            
            if(objInventoryMap.get('Cost')!=null && objInventoryMap.get('Cost')!='') {
                objInventory2.Cost__c = Decimal.valueOf(objInventoryMap.get('Cost'));
            }
            
            if(objInventoryMap.get('MinAmount')!=null && objInventoryMap.get('MinAmount')!='') {
                objInventory2.Minimum_Amount__c = Decimal.valueOf(objInventoryMap.get('MinAmount'));
            }
            
            if(objInventoryMap.get('inventoryLocation')!=null && objInventoryMap.get('inventoryLocation')!='') {
                objInventory2.Part_Location__c = objInventoryMap.get('inventoryLocation');
            }
            
            if(objInventoryMap.get('inventoryBin')!=null && objInventoryMap.get('inventoryBin')!='') {
                objInventory2.BOATBUILDING__Bin__c = objInventoryMap.get('inventoryBin');
            }
            
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();                                                
        if(String.isNotBlank(partInvRecordTypeId)) {
            objInventory2.RecordTypeId = partInvRecordTypeId;
        }
        
        else{
            
            return null;
        }
            
        try {
            System.debug('Debug Log for objInventory2 :'+objInventory2);
            insert objInventory2;
            
            
        }catch(Exception ex) {
            
              System.debug('_________Catch___'+ex);
              System.debug('_________Catch___'+ex.getLineNumber());
             
        }
        if(objInventory2.id != null) {
                
                return 'SUCCESS';
        }
        else {
            
            return null;
        }   
    }
    
    @RemoteAction
    public static List<InventoryListViewWrapper> getInvList() {
    	
    		List<InventoryListViewWrapper> lstInventoryListViewWrapper = new List<InventoryListViewWrapper>();
        List<RecordType> lstInventoryRT = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Inventory_for_Parts'
                                        AND
                                                SobjectType = 'BOATBUILDING__Inventory__c'
                                        LIMIT 
                                                1];
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
            for(BOATBUILDING__Line_Items__c objLI : [Select Id, Quantity__c, Part_Number_del__c From BOATBUILDING__Line_Items__c WHERE Order__r.RecordTypeId =: lstOrderRT[0].Id ORDER BY CreatedDate DESC]) {
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
        
        List<BOATBUILDING__Inventory__c>  listInventoryToProcess = [SELECT  Name, Vendor__c, Vendor__r.Name, Part_Number__c, Description__c, Category__c, Map_Price__c, Discount__c, Family__c, Size__c, Color__c, Cost__c, Minimum_Amount__c, Part_Location__c, Part_MSRP_Price__c, Part_Name__c, Quantity__c  FROM  BOATBUILDING__Inventory__c  WHERE RecordTypeId = :lstInventoryRT[0].Id  ORDER BY CreatedDate DESC limit 1000];
        if(lstInventoryRT.size()>0 && lstOrderRT.size() > 0 && !listInventoryToProcess.isEmpty()) {
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