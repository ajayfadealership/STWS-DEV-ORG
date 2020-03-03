trigger InvoiceTrigger on Invoice__c (before insert, after insert, after update, before update) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        InvoiceHandlerClass.onBeforeInsert(Trigger.new);
        
    }
    
    if(trigger.isAfter) {
    	System.debug('>>>>>>>: After');
	    if(trigger.isInsert || trigger.isUpdate) {
	    	System.debug('>>>>>>>: Insert Update');
	    	for(Invoice__c objInv: trigger.new) {
	    		System.debug('>>>>>>>: Loop'); 
	    		if(String.isNotBlank(objInv.BOATBUILDING__Woocommerce_Id__c) && String.isNotBlank(objInv.BOATBUILDING__Woocommerce_Status__c) 
	    			&& String.isNotBlank(objInv.BOATBUILDING__Web_Source__c) && objInv.BOATBUILDING__Web_Source__c == 'Woocommerce') {
	    			System.debug('>>>>>>>: loop if');
	    			WooCommerce_Connect.updateInvoice(objInv.Id);
	    		}
	    	}
	    }
    } 
     
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__InvoiceTriggerCheckBox__c;
    if(isOff==true){
        if(trigger.isBefore) {
            if(trigger.isInsert || trigger.isUpdate) {
                Set<String> setQtId = new Set<String>(); 
                for(BOATBUILDING__Invoice__c objInv: trigger.new) {
                    
                    if(objInv.BOATBUILDING__State_Province__c != null && objInv.BOATBUILDING__Quote__c != null) {
                    	setQtId.add(objInv.BOATBUILDING__Quote__c);
                        //System.debug('@'+objInv.BOATBUILDING__Non_Taxable__c);
                       /* BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objInv.BOATBUILDING__State_Province__c);
                        Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                        Decimal VehicleSalestax = objBoatBuilderUtil.getVehicleSalestax();
                        
                        Decimal CappingAmountForVehicleSalesTax = 0.00;
                        Date dateOfTaxCapChange = Date.newInstance(2017,9,23);
                        Decimal NetSellingPriceFormula = 0.00;
                        
                        if(objInv.CreatedDate <= dateOfTaxCapChange && objInv.BOATBUILDING__State_Province__c.equalsIgnoreCase('South Carolina')) {
                            CappingAmountForVehicleSalesTax = 300.00;
                        } else { 
                            CappingAmountForVehicleSalesTax = objBoatBuilderUtil.getCappingAmountForVehicleSalesTax();
                        }
                        
                        if(objInv.BOATBUILDING__Net_Selling_Price_Formula__c != null) {
                            NetSellingPriceFormula = objInv.BOATBUILDING__Net_Selling_Price_Formula__c;	
                        }
                        
                        Decimal BSTF = 0.00;
                        BSTF = (NetSellingPriceFormula * VehicleSalestax)/100;
                        if(CappingAmountForVehicleSalesTax > 0) {
                            if(BSTF<= CappingAmountForVehicleSalesTax) {
                                objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = BSTF;
                            } 
                            else {
                                objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = CappingAmountForVehicleSalesTax;
                            } 
                        } else {
                            objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = BSTF;
                        }*/
                        
                        
                        
                    } 
                    
                    if(objInv.BOATBUILDING__Billing_State_Province__c != null && !objInv.BOATBUILDING__Non_Taxable__c) {
                        BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objInv.BOATBUILDING__Billing_State_Province__c);
                        Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                        objInv.BOATBUILDING__Sales_TaxPer_Backend__c = RegularSalestax;
                    } else {
                        objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = 0.00;
                        objInv.BOATBUILDING__Sales_TaxPer_Backend__c = 0.00;
                        objInv.BOATBUILDING__Sales_Tax__c = 0.00;
                        objInv.BOATBUILDING__Sales_Tax_percent__c = 0.00;
                    }
                }
                
                Map<Id, Quote__c> mpQT = new Map<Id, Quote__c>([Select Id, BOATBUILDING__Boat_Sales_Tax2__c, BOATBUILDING__Quote_Trailer_Sales_Tax__c From Quote__c Where Id =: setQtId]);
                for(BOATBUILDING__Invoice__c objInv: trigger.new) {
                    if(objInv.BOATBUILDING__State_Province__c != null && objInv.BOATBUILDING__Quote__c != null) {
                    	if(mpQT.get(objInv.BOATBUILDING__Quote__c).BOATBUILDING__Boat_Sales_Tax2__c != null) {
                    		objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = mpQT.get(objInv.BOATBUILDING__Quote__c).BOATBUILDING__Boat_Sales_Tax2__c;
                    	} else {
                    		objInv.BOATBUILDING__Boat_Sales_Tax_Formula_Backend__c = 0.00; 
                    	}
                    	if(mpQT.get(objInv.BOATBUILDING__Quote__c).BOATBUILDING__Quote_Trailer_Sales_Tax__c != null) {
                    		objInv.BOATBUILDING__Trailer_Sales_Tax__c = mpQT.get(objInv.BOATBUILDING__Quote__c).BOATBUILDING__Quote_Trailer_Sales_Tax__c;
                    	} else {
                    		objInv.BOATBUILDING__Trailer_Sales_Tax__c = 0.00;
                    	}
                    }
                }
            }
        } 
        
        //Code added
        if(trigger.isAfter && trigger.isInsert) {
            InvoiceHandlerClass.onAfterInsert(Trigger.new); 
        }
        else if(trigger.isAfter && trigger.isUpdate){
            InvoiceHandlerClass.onAfterUpdate(Trigger.new, Trigger.oldMap); 
        }
    }
}