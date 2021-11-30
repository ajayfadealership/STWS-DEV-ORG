public class PartInventoryManagerController {
    
    public PartInventoryManagerController() { }

    public Static void updateInventoryQuantity(List<PartInventoryWrapper> listWrapToProcess){

        Set<String> setInvLineItemId = new Set<String>();
        Set<String> setInventoryId = new Set<String>();
        for(PartInventoryWrapper objWrap: listWrapToProcess){
            if(String.isNotBlank(objWrap.inventoryId)){
                setInventoryId.add(objWrap.inventoryId);
            }
        }

        Map<Id, Inventory__c> mapInventory = new Map<Id, Inventory__c>([SELECT Id, BOATBUILDING__Part_Number__c, Quantity__c, 
                                            (SELECT Id, Quantity__c, BOATBUILDING__Store_Location__c
                                            FROM BOATBUILDING__Parts_Availability__r) 
                                            FROM Inventory__c WHERE Id IN: setInventoryId]);
        
        List<Inventory__c> listInvToUpdate = new List<Inventory__c>();
        List<BOATBUILDING__Parts_Availability__c> listPAToUpdate = new List<BOATBUILDING__Parts_Availability__c>();
        Map<Id, BOATBUILDING__Parts_Availability__c> mapPA = new Map<Id, BOATBUILDING__Parts_Availability__c>();
        Map<Id, Inventory__c> mapInv = new Map<Id, Inventory__c>();
        for(PartInventoryWrapper objWrap: listWrapToProcess) {
            if(objWrap.quantity != null){
                if(mapInventory.containsKey(objWrap.inventoryId)){
                    if(mapInventory.get(objWrap.inventoryId).BOATBUILDING__Parts_Availability__r.isEmpty()){
                        // Inventory__c objInvToUpdate = new Inventory__c(Id = objWrap.inventoryId);
                        // objInvToUpdate.BOATBUILDING__Quantity__c =  mapInventory.get(objWrap.inventoryId).BOATBUILDING__Quantity__c - objWrap.quantity;
                        // listInvToUpdate.add(objInvToUpdate);
                        // mapInv.put(objInvToUpdate.Id, objInvToUpdate);

                        BOATBUILDING__Parts_Availability__c objPAToUpdate = new BOATBUILDING__Parts_Availability__c(BOATBUILDING__Inventory__c = objWrap.inventoryId);
                        objPAToUpdate.Quantity__c = mapInventory.get(objWrap.inventoryId).BOATBUILDING__Quantity__c - objWrap.quantity;
                        objPAToUpdate.BOATBUILDING__Store_Location__c = objWrap.storeLocation;
                        listPAToUpdate.add(objPAToUpdate);
                        mapPA.put(objPAToUpdate.Id, objPAToUpdate);

                    } else {
                        Boolean isExisting = false;
                        for(BOATBUILDING__Parts_Availability__c objPA: mapInventory.get(objWrap.inventoryId).BOATBUILDING__Parts_Availability__r){
                            if(objWrap.storeLocation == objPA.BOATBUILDING__Store_Location__c){
                                BOATBUILDING__Parts_Availability__c objPAToUpdate = new BOATBUILDING__Parts_Availability__c(Id = objPA.Id);
                                objPAToUpdate.Quantity__c = objPA.Quantity__c - objWrap.quantity;
                                listPAToUpdate.add(objPAToUpdate);
                                mapPA.put(objPAToUpdate.Id, objPAToUpdate);
                                isExisting = true;
                            }
                        }
                        if(!isExisting) {
                            BOATBUILDING__Parts_Availability__c objPAToUpdate = new BOATBUILDING__Parts_Availability__c(BOATBUILDING__Inventory__c = objWrap.inventoryId);
                            objPAToUpdate.Quantity__c = 0 - objWrap.quantity;
                            objPAToUpdate.BOATBUILDING__Store_Location__c = objWrap.storeLocation;
                            listPAToUpdate.add(objPAToUpdate);
                            mapPA.put(objPAToUpdate.Id, objPAToUpdate);
                            isExisting = true;
                        }
                    }
                }
            }
        }
        
        if(!mapInv.values().isEmpty()){
            //upsert mapInv.values();
        }
        System.debug('>>>>>>>listPAToUpdate: '+listPAToUpdate);
        if(!mapPA.values().isEmpty()){
            upsert mapPA.values();
        }
    } 

    public static Map<String, Id> generateInventory(Map<String, String> mapPartNumberStoreLocation) {
        List<BOATBUILDING__Part__c> lstPart = [SELECT 
                                                   Bin__c, Vendor_Name__c,  Retail_Price__c,  Part_Number__c,  Name, 
                                                   Id, Dealer_Price__c, Part_Cost__c, Category1__c, 
                                                   Discount__c, Family1__c, Location__c, Map_Price__c, Minimum_Amount__c,
                                                   Part_Color__c, Part_Size__c, Taxable__c, Weight__c
                                                   FROM BOATBUILDING__Part__c 
                                                   WHERE Part_Number__c  IN :mapPartNumberStoreLocation.keySet()];
        Id invForPartRecTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        List<BOATBUILDING__Inventory__c> lstInventory = new List<BOATBUILDING__Inventory__c>();
        for(BOATBUILDING__Part__c objPart : lstPart) {
            BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
            objInventory.BOATBUILDING__Quantity__c = 0;    
            objInventory.BOATBUILDING__Part_Number__c = objPart.Part_Number__c;
            objInventory.RecordTypeId = invForPartRecTypeId;
            objInventory.Part_Name__c = objPart.Name;
            objInventory.Size__c = objPart.BOATBUILDING__Part_Size__c;
            objInventory.Vendor__c = objPart.BOATBUILDING__Vendor_Name__c;
            objInventory.Part_Number__c = objPart.Part_Number__c;
            objInventory.Description__c = objPart.Name;
            objInventory.Cost__c = objPart.BOATBUILDING__Part_Cost__c;
            objInventory.Category__c = objPart.BOATBUILDING__Category1__c;
            objInventory.Bin__c = objPart.Bin__c;
            objInventory.Color__c = objPart.BOATBUILDING__Part_Color__c;
            objInventory.Part_Location__c = objPart.BOATBUILDING__Location__c; 
            objInventory.Map_Price__c = objPart.BOATBUILDING__Map_Price__c;
            objInventory.Taxable__c= objPart.BOATBUILDING__Taxable__c;
            objInventory.Weight__c = objPart.BOATBUILDING__Weight__c;
            objInventory.Part_MSRP_Price__c = objPart.BOATBUILDING__Retail_Price__c;
            lstInventory.add(objInventory);
        }
        insert lstInventory;
        List<BOATBUILDING__Parts_Availability__c> listPAToInsert = new List<BOATBUILDING__Parts_Availability__c>();
        Map<String, Id> mapPartNumberInvId = new Map<String, Id>();
        for(BOATBUILDING__Inventory__c objInv : lstInventory) {
            BOATBUILDING__Parts_Availability__c objPAToInsert = new BOATBUILDING__Parts_Availability__c(BOATBUILDING__Inventory__c = objInv.Id);
            objPAToInsert.Quantity__c = 0;
            objPAToInsert.BOATBUILDING__Store_Location__c = mapPartNumberStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
            listPAToInsert.add(objPAToInsert);
            mapPartNumberInvId.put(objInv.Part_Number__c, objInv.Id);
        }

        insert listPAToInsert;
        return mapPartNumberInvId;
    }    

    public Class PartInventoryWrapper{

        public String inventoryId;
        public Decimal quantity;
        public String storeLocation;
    }

}