public with sharing class PartRequestLightningCompController {
@AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Part Request').getRecordTypeId();        
        return recid;
    }  
}