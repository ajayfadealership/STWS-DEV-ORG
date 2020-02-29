public class NewDealerOptionController {
    
    @AuraEnabled
	public static DealerOptionWraper updateDealerOptionApex(String strName, String strDealerPrice, String strRetailPrice, String strPrtName, String taxCheck) {
		String UserId = UserInfo.getUserId();
		Dealer_Option__c objDO = new Dealer_Option__c();
		objDO.Name = strName;
		objDO.Cost__c = Decimal.valueOf(strDealerPrice);
		objDO.Retail_Price__c = Decimal.valueOf(strRetailPrice);
		objDO.Part_Number__c = String.valueOf(strPrtName);
		
		if(taxCheck == '1') {
			objDO.Non_Taxable__c = true;
		} else {
			objDO.Non_Taxable__c = false;
		}
		
		DealerOptionWraper objDOW = new DealerOptionWraper(true, objDO, true);
		
		return objDOW;
	}
}