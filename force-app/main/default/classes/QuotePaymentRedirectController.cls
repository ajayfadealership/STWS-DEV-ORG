public class QuotePaymentRedirectController {
    public Quote__c objQuote { get; set; }
    public BOATBUILDING__Payments__c objQTP { get; set; }
    
    public QuotePaymentRedirectController() {
        String qId = ApexPages.currentPage().getParameters().get('QuoteId');
        objQuote = [SELECT 
                    BOATBUILDING__Quote_Sale_Price__c, BOATBUILDING__Contact_Name__c,
                    BOATBUILDING__Contact_Name__r.AccountId, Name, Quote_Number__c
                    FROM BOATBUILDING__Quote__c WHERE Id = :qId]; 
        objQTP = new BOATBUILDING__Payments__c();
        objQTP.RecordTypeId = Schema.SObjectType.BOATBUILDING__All_Payment__c.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
        objQTP.BOATBUILDING__Quote__c = objQuote.Id; 			
    }
    
    public PageReference generatePayment() {
        if(objQTP.BOATBUILDING__Payment_Type__c == 'Credit Card') {
            return new PageReference('/apex/FADPAY__AddCreditCardInfoFQP?QuoteId='+objQuote.Id);
        } else { 
            insert objQTP;
            return new PageReference('/'+objQuote.Id);	
        }
        
    }
}