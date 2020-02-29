public class PaymentCalculatorController {
    @AuraEnabled
    public static BOATBUILDING__ProductPrice__c getPPDetails(String PPid) {
        BOATBUILDING__ProductPrice__c objPP = [Select b.BOATBUILDING__ProductRetail_Price__c, b.BOATBUILDING__Dealer_Price__c From BOATBUILDING__ProductPrice__c b Where Id =: PPid]; 
        return objPP;
    }
    @AuraEnabled
    public static List<BOATBUILDING__Dealer_Option__c> getPPDODetails(List<String> PPDOid) {
        List<BOATBUILDING__Dealer_Option__c> objPP = [Select b.BOATBUILDING__Retail_Price__c, b.BOATBUILDING__Cost__c From BOATBUILDING__Dealer_Option__c b Where Id IN: PPDOid]; 
        return objPP; 
    }
}