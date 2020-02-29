public class PriceAndProductOptionWraperClass{
        @AuraEnabled public Decimal retailPrice { get; set; }
        @AuraEnabled public String partNumber { get; set; }
        @AuraEnabled public String strSelectedOption {    get; set; }
        @AuraEnabled public List<CheckBoxWraper> lstProductPriceForSelectedCategory { get; set; }
        
        public PriceAndProductOptionWraperClass( String strSelectedOption, list<CheckBoxWraper> lstProductPriceForSelectedCategory){
            this.lstProductPriceForSelectedCategory = lstProductPriceForSelectedCategory;
            this.strSelectedOption = strSelectedOption;
            this.partNumber = partNumber;
            this.retailPrice = retailPrice;
        } 
    }