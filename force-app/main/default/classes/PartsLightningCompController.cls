public class PartsLightningCompController {
    @AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Part__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();        
        return recid;
    }
}