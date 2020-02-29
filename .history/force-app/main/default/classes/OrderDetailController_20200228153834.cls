public class OrderDetailController {
    public OrderDetailController() { }
    @AuraEnabled
    public static string getRecordTypeDetail(String strRecId){
        String strRecType = [Select Id, RecordType.DeveloperName From BOATBUILDING__Order__c Where Id =: strRecId].RecordType.DeveloperName;
        return strRecType;  
    }
    @AuraEnabled
    public static string getRecordType(String recTypeName){
        Id recordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId(); 
        return String.valueOf(recordTypeId);
    }
}