public class DealerOptionWraper {
        @AuraEnabled public Boolean isSelect { get; set; }
        @AuraEnabled public Boolean ShowRemoveIcon { get; set; }
        @AuraEnabled public BOATBUILDING__Dealer_Option__c objDealerOption { get; set; }
        @AuraEnabled public Boolean Non_Taxable { get; set; }
        public DealerOptionWraper(Boolean isSelect, BOATBUILDING__Dealer_Option__c objDealerOption, Boolean ShowRemoveIcon) {
            this.isSelect = isSelect;
            this.objDealerOption = objDealerOption;
            this.ShowRemoveIcon = ShowRemoveIcon;
            this.Non_Taxable = objDealerOption.BOATBUILDING__Non_Taxable__c;
        }
    }