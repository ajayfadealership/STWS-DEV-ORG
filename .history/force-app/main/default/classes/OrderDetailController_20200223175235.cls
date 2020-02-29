public class OrderDetailController {
    public OrderDetailController() { }
    @AuraEnabled
    public static string getRecordTypeDetail(String strRecId){
        String strRecType = [Select Id, RecordType.DeveloperName From BOATBUILDING__Order__c Where Id =: strRecId].RecordType.DeveloperName;
        return strRecType;  
    }
}