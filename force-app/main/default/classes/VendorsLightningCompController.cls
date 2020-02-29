public with sharing class VendorsLightningCompController {
    @AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();        
        return recid;
    }
}