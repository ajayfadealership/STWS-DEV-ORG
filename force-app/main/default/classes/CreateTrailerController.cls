public class CreateTrailerController {
    
    public BOATBUILDING__Inventory__c objTrailer {get; set;}
    
    public CreateTrailerController(){
        objTrailer = new BOATBUILDING__Inventory__c();
    }
    
    public PageReference createTrailer() {
        
        Id trailerRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Trailer').getRecordTypeId();
        if(objTrailer!= null){
            objTrailer.RecordTypeId = trailerRecordTypeId;
            insert objTrailer;
        }
        
        PageReference pgRef = new PageReference('/'+objTrailer.Id);
        return pgRef;
    }
}