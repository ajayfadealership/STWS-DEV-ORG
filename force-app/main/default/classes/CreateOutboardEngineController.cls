public with sharing class CreateOutboardEngineController {
    public Inventory__c objInv { get; set; }
    
    public CreateOutboardEngineController() {
        objInv = new Inventory__c();
    }
    
    public PageReference createEngine() {
        Id engRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Engine').getRecordTypeId();
        if(objInv!= null){
            objInv.RecordTypeId = engRecordTypeId;
            insert objInv;
        }
        
        PageReference pgRef = new PageReference('/'+objInv.Id);
        return pgRef;
    }
}