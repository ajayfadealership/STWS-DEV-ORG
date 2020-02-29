public class InventoryLightningCompController {
    @AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();        
        return recid;
    }
}