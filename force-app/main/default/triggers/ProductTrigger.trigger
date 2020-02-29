trigger ProductTrigger on BOATBUILDING__Product__c (before insert, before update) {
    /*
    if(trigger.isBefore) {
    		
    		if(trigger.isInsert || trigger.isUpdate) {
    			
    			for(BOATBUILDING__Product__c objPro: trigger.new) {
    				if(objPro.BOATBUILDING__State__c != null) {
    					BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objPro.BOATBUILDING__State__c);
					Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
					Decimal VehicleSalestax = objBoatBuilderUtil.getVehicleSalestax();
					
					Decimal CappingAmountForVehicleSalesTax = 0.00;
					Date dateOfTaxCapChange = Date.newInstance(2017,9,23);
					Decimal NetSellingPriceFormula = 0.00;
					
					if(objPro.CreatedDate <= dateOfTaxCapChange && objPro.BOATBUILDING__State__c.equalsIgnoreCase('South Carolina')) {
						CappingAmountForVehicleSalesTax = 300.00;
					} else { 
						CappingAmountForVehicleSalesTax = objBoatBuilderUtil.getCappingAmountForVehicleSalesTax();
					}
					
					if(objPro.BOATBUILDING__M_Net_Selling_Price_Calculated__c != null) {
						NetSellingPriceFormula = objPro.BOATBUILDING__M_Net_Selling_Price_Calculated__c;	
					}
					
					Decimal BSTF = 0.00;
					BSTF = (NetSellingPriceFormula * VehicleSalestax)/100;
					if(CappingAmountForVehicleSalesTax > 0) {
						if(BSTF<= CappingAmountForVehicleSalesTax) {
							objPro.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c = BSTF;
						} 
						else {
							objPro.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c = CappingAmountForVehicleSalesTax;
						} 
					} else {
						objPro.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c = BSTF;
					}
    				}	
    			}
    		}
    }
*/
}