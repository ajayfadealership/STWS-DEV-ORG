public class RefundInvoiceLightning {
    @AuraEnabled 
    public static String refundInvoice(String strInvoiceId, String strRefundedAmount) {
          List<Invoice__c> lstInvoice = [SELECT Id, Refunded__c, Refunded_Amount__c, (SELECT Id, Part_Number__c, Quantity__c, Refunded__c From Invoice_Line_Items__r Where Refunded__c = false) From Invoice__c WHERE id =: strInvoiceId LIMIT 1];        
        return 'success';
        
    }
    
}