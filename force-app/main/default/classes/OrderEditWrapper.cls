public class OrderEditWrapper {
    @AuraEnabled public String partNo { get; set; }
    @AuraEnabled public String description { get; set; }
    @AuraEnabled public Integer quantity { get; set; }
    @AuraEnabled public Decimal cost { get; set; }
    @AuraEnabled public Integer received { get; set; }
    @AuraEnabled public String lineItemId { get; set; }
    @AuraEnabled public Decimal amount { get; set; }
    @AuraEnabled public Integer backOrderQuantity { get; set; }
  //  @AuraEnabled public Decimal backOrderAmount { get; set; }
    @AuraEnabled public List<BOATBUILDING__Parts_Availability__c> lstPA { get; set; }  
}