public class PurchaseOrderLineItemWrapper {
    @AuraEnabled public String Id { get; set; }
    @AuraEnabled public String PartId { get; set; }
    @AuraEnabled public String PartNumber { get; set; }
    @AuraEnabled public String PartName { get; set; }
    @AuraEnabled public Integer Quantity { get; set; }
    @AuraEnabled public Decimal Cost { get; set; } 
    @AuraEnabled public Boolean showPill { get; set; } 
    @AuraEnabled public Decimal discount { get; set; }  
    @AuraEnabled public Decimal partMSRP { get; set; }  
    @AuraEnabled public Decimal discountPer { get; set; } 
    @AuraEnabled public Decimal Total { get; set; } 
    @AuraEnabled public Decimal TotalWithoutDisc { get; set; } 


}