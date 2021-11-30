trigger InvoiceTrigger on Invoice__c (before insert, after insert, after update, before update, before delete) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        InvoiceHandlerClass.onBeforeInsert(Trigger.new);
        
    }
     if(Trigger.isBefore && Trigger.isUpdate){
        InvoiceHandlerClass.onBeforeUpdate(Trigger.new);
        
    }
    if(Trigger.isBefore && trigger.isDelete) {
        System.debug('>>>>>>>: After Delete');
        InvoiceHandlerClass.onBeforeDelete(trigger.oldMap);
    }
    
    if(trigger.isAfter) {
        
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
     
    
    Boolean isOn = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__InvoiceTriggerCheckBox__c;
    if(isOn){
        if(trigger.isBefore) {
            if(trigger.isInsert || trigger.isUpdate) {
                Set<String> setQtId = new Set<String>(); 
                for(BOATBUILDING__Invoice__c objInv: trigger.new) {
                    
                    if(objInv.BOATBUILDING__State_Province__c != null) {
                        if(objInv.BOATBUILDING__Quote__c != null)
                    	    setQtId.add(objInv.BOATBUILDING__Quote__c);
                    } 
                    
                    if(objInv.BOATBUILDING__Billing_State_Province__c != null && !objInv.BOATBUILDING__Non_Taxable__c) {
                        System.debug('>>>>>: '+objInv.BOATBUILDING__Billing_State_Province__c);
                        BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objInv.BOATBUILDING__Billing_State_Province__c, objInv.RecordTypeId);
                        Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                        objInv.BOATBUILDING__Sales_TaxPer_Backend__c = RegularSalestax;
                        System.debug('>>>>>objBoatBuilderUtil.isCanadianTax(): '+objBoatBuilderUtil.isCanadianTax());
                        if(objBoatBuilderUtil.isCanadianTax()) {
                            objInv.BOATBUILDING__GST__c = objBoatBuilderUtil.getGST(); 
                            objInv.BOATBUILDING__PST__c = objBoatBuilderUtil.getPST();
                            System.debug('>>>>>objInv.BOATBUILDING__GST__c: '+objInv.BOATBUILDING__GST__c);
                            System.debug('>>>>>objInv.BOATBUILDING__PST__c: '+objInv.BOATBUILDING__PST__c);
                        }
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