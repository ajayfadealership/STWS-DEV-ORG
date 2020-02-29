public class PartInventoryManagerController {
    
    public PartInventoryManagerController() {
    }

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
        for(PartInventoryWrapper objWrap: listWrapToProcess) {
            if(objWrap.quantity != null){
                if(mapInventory.containsKey(objWrap.inventoryId)){
                    if(mapInventory.get(objWrap.inventoryId).BOATBUILDING__Parts_Availability__r.isEmpty()){
                        Inventory__c objInvToUpdate = new Inventory__c(Id = objWrap.inventoryId);
                        objInvToUpdate.BOATBUILDING__Quantity__c =  mapInventory.get(objWrap.inventoryId).BOATBUILDING__Quantity__c - objWrap.quantity;
                        listInvToUpdate.add(objInvToUpdate);
                    } else {
                        for(BOATBUILDING__Parts_Availability__c objPA: mapInventory.get(objWrap.inventoryId).BOATBUILDING__Parts_Availability__r){
                            if(objWrap.storeLocation == objPA.BOATBUILDING__Store_Location__c){
                                BOATBUILDING__Parts_Availability__c objPAToUpdate = new BOATBUILDING__Parts_Availability__c(Id = objPA.Id);
                                objPAToUpdate.Quantity__c = objPA.Quantity__c - objWrap.quantity;
                                listPAToUpdate.add(objPAToUpdate);
                            }
                        }
                    }
                }
            }
        }
        
        if(!listInvToUpdate.isEmpty()){
            update listInvToUpdate;
        }
        
        if(!listPAToUpdate.isEmpty()){
            update listPAToUpdate;
        }
    } 

    public Class PartInventoryWrapper{

        public String inventoryId;
        public Decimal quantity;
        public String storeLocation;
    }

}