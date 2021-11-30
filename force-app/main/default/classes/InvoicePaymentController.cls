public class InvoicePaymentController {
    public InvoicePaymentController() { }

    @AuraEnabled
    public static List<Object> getPaymentURLInfo(String strInvId) {
        List<Object> lstObj = new List<Object>();
        String baseUrlINV = ''; 
        BOATBUILDING__EndPointURL__c objEndPointUrl = BOATBUILDING__EndPointURL__c.getInstance('BaseUrlWPayINV');
        if(objEndPointUrl != null){
            if(String.isNotBlank(objEndPointUrl.BOATBUILDING__URL__c)){
                baseUrlINV = objEndPointUrl.BOATBUILDING__URL__c;
            }
        }
        lstObj.add(baseUrlINV);
        BOATBUILDING__Invoice__c objInv = [SELECT Id, BOATBUILDING__Balance__c From BOATBUILDING__Invoice__c Where Id =: strInvId];
        lstObj.add(objInv);
        System.debug('>>>>: '+ lstObj);
        //1. URL, 2. Invoice
        return lstObj; 
    }
    @AuraEnabled
    public static String getType(String strInvId){
        List<BOATBUILDING__Invoice__c> lstInv = [SELECT Id FROM BOATBUILDING__Invoice__c WHERE Id =: strInvId];
        List<BOATBUILDING__Work_Order__c> lstWO = [SELECT Id FROM BOATBUILDING__Work_Order__c WHERE Id =: strInvId];
        if(!lstInv.isEmpty()) {
            return 'INVOICE';
        }
        else if(!lstWO.isEmpty()) {
            return 'WORKORDER';
        }
        return 'NONE';
    }
    @AuraEnabled
    public static String getRecTypeId(String strType, String recId) {
        if(strType == 'INVOICE') {
            String recName = [Select Id, RecordType.Name From Invoice__c Where Id =: recId].RecordType.Name;
            return Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get(recName).getRecordTypeId();
        } else if(strType == 'WORKORDER') {
            String recName = [Select Id, RecordType.Name From BOATBUILDING__Work_Order__c Where Id =: recId].RecordType.Name; 
            return Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get(recName).getRecordTypeId();
        }
        return '';
    } 
    @AuraEnabled
    public static List<Object> getPaymentURLInfoWO(String strInvId) {
        List<Object> lstObj = new List<Object>();
        String baseUrl = ''; 
        BOATBUILDING__EndPointURL__c objEndPointUrl = BOATBUILDING__EndPointURL__c.getInstance('BaseUrlWPay');
        if(objEndPointUrl != null){
            if(String.isNotBlank(objEndPointUrl.BOATBUILDING__URL__c)){
                baseUrl = objEndPointUrl.BOATBUILDING__URL__c;
            }
        }
        lstObj.add(baseUrl);
        BOATBUILDING__Work_Order__c objWO = [SELECT Id, BOATBUILDING__Balance__c, BOATBUILDING__Deducted_Total_Due_Amount__c From BOATBUILDING__Work_Order__c Where Id =: strInvId];
        lstObj.add(objWO);
        System.debug('>>>>: '+ lstObj); 
        //1. URL, 2. WO
        return lstObj; 
    }
}