public class CheckBoxWraper{
    @AuraEnabled public Boolean checkBox { get; set; }
    @AuraEnabled public BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory { get; set; } 
    @AuraEnabled public Integer rowNumber { get; set; }
    
    public CheckBoxWraper(Boolean checkBox, Integer rowNumber, BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory){
        this.checkBox = checkBox;
        this.rowNumber = rowNumber;
        this.objProductPriceForSelectedCategory = objProductPriceForSelectedCategory;
    }
}