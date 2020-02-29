trigger QuoteTrigger on Quote__c (before insert, after insert, before update, after update) {
    
    Boolean isActive = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__QuoteTriggerCheckBox__c;
    if(isActive){
        if(trigger.isAfter && trigger.isUpdate) {
            List<Task> lstTsk = new List<Task>();
            Set<String> setStoreLocation = new Set<String>();
            for(Quote__c objQuote: trigger.new) {
                if(objQuote.BOATBUILDING__Status__c != null && objQuote.BOATBUILDING__Status__c == 'Presented' 
                   && trigger.oldMap.get(objQuote.Id).BOATBUILDING__Status__c != trigger.newMap.get(objQuote.Id).BOATBUILDING__Status__c) {
                       Task objTk = new Task();
                       objTk.Subject = 'Please follow up';
                       objTk.ActivityDate = Date.today().addDays(3);
                       objTk.WhatId = objQuote.Id;
                       objTk.WhoId = objQuote.BOATBUILDING__Contact_Name__c;
                       objTk.OwnerId = objQuote.OwnerId;
                       lstTsk.add(objTk);
                       if(objQuote.BOATBUILDING__Store_Location__c != null) {
                           setStoreLocation.add(objQuote.BOATBUILDING__Store_Location__c);
                       }
                   }
            }
            
            List<User> lstUsr = [Select Id, BOATBUILDING__Store_Location__c, UserRole.Name From User Where (BOATBUILDING__Store_Location__c IN: setStoreLocation OR (UserRole.Name = 'Accounting' OR UserRole.Name = 'Sales Manager')) AND isActive = True];
            System.debug('lstUsr: '+lstUsr);
            Boolean AccountingStatus = false;
            Boolean SalesManagerStatus = false;
            for(Quote__c objQuote: trigger.new) {
                for(User objUser: lstUsr) {
                    System.debug('AccountingStatus: '+AccountingStatus);
                    System.debug('SalesManagerStatus: '+SalesManagerStatus);
                    if(objQuote.BOATBUILDING__Status__c != null && objQuote.BOATBUILDING__Status__c == 'Final' 
                       && trigger.oldMap.get(objQuote.Id).BOATBUILDING__Status__c != trigger.newMap.get(objQuote.Id).BOATBUILDING__Status__c) {
                           Task objTk = new Task();
                           objTk.Subject = 'Please look at final quote('+objQuote.Quote_Number__c+')';
                           objTk.ActivityDate = Date.today();
                           objTk.WhatId = objQuote.Id;
                           objTk.WhoId = objQuote.BOATBUILDING__Contact_Name__c;
                           if(objUser.UserRole.Name == 'Accounting' && !AccountingStatus) {
                               if(objQuote.BOATBUILDING__Store_Location__c != null  && objUser.BOATBUILDING__Store_Location__c != null
                                  && objQuote.BOATBUILDING__Store_Location__c == objUser.BOATBUILDING__Store_Location__c && !AccountingStatus) {
                                      
                                      objTk.OwnerId = objUser.Id;
                                      AccountingStatus = true; 
                                  } else if((objQuote.BOATBUILDING__Store_Location__c == null  || objUser.BOATBUILDING__Store_Location__c == null) && !AccountingStatus) {
                                      objTk.OwnerId = objUser.Id;
                                      AccountingStatus = true;
                                  } 
                               lstTsk.add(objTk);
                           }
                           if(objUser.UserRole.Name == 'Sales Manager' && !SalesManagerStatus) {
                               if(objQuote.BOATBUILDING__Store_Location__c != null  && objUser.BOATBUILDING__Store_Location__c != null
                                  && objQuote.BOATBUILDING__Store_Location__c == objUser.BOATBUILDING__Store_Location__c && !SalesManagerStatus) {
                                      
                                      objTk.OwnerId = objUser.Id;
                                      SalesManagerStatus = true; 
                                  } else if((objQuote.BOATBUILDING__Store_Location__c == null  || objUser.BOATBUILDING__Store_Location__c == null) && !SalesManagerStatus) {
                                      objTk.OwnerId = objUser.Id;
                                      SalesManagerStatus = true;
                                  } 
                               lstTsk.add(objTk);
                           }
                       }
                }
            }
            insert lstTsk;
        }
        
        if(trigger.isBefore) {
            
            if(trigger.isInsert || trigger.isUpdate) {
                
                for(Quote__c objQuote: trigger.new) {
                    
                    if(objQuote.BOATBUILDING__State__c != null) {
                        
                        BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objQuote.BOATBUILDING__State__c);
                        Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                        Decimal VehicleSalestax = objBoatBuilderUtil.getVehicleSalestax();
                        
                        Decimal CappingAmountForVehicleSalesTax = 0.00;
                        Date dateOfTaxCapChange = Date.newInstance(2017,9,23);
                        Decimal NetSellingPriceFormula = 0.00;
                        
                        if(objQuote.CreatedDate <= dateOfTaxCapChange && objQuote.BOATBUILDING__State__c.equalsIgnoreCase('South Carolina')) {
                            CappingAmountForVehicleSalesTax = 300.00;
                        } else { 
                            CappingAmountForVehicleSalesTax = objBoatBuilderUtil.getCappingAmountForVehicleSalesTax();
                        }
                        
                        if(objQuote.BOATBUILDING__Quote_Net_Selling_Price_Calculated__c != null) {
                            NetSellingPriceFormula = objQuote.BOATBUILDING__Quote_Net_Selling_Price_Calculated__c;  
                        }
                        
                        Decimal additionalSalesTax = 0.00;
                        
                        if(objQuote.BOATBUILDING__Additional_Sales_Tax_Percent_Formula__c != null) {
                            additionalSalesTax = objQuote.BOATBUILDING__Additional_Sales_Tax_Percent_Formula__c;
                            VehicleSalestax += additionalSalesTax;
                        } 
                        
                        if(objQuote.BOATBUILDING__Non_Taxable_Total__c != null) {
                            NetSellingPriceFormula -= objQuote.BOATBUILDING__Non_Taxable_Total__c;
                        }
                        
                        Boolean isActiveDocfee = objBoatBuilderUtil.getdocFeeTaxable();
                        if(objQuote.BOATBUILDING__Quote_Doc_Fee__c != null && isActiveDocfee) {
                            NetSellingPriceFormula += objQuote.BOATBUILDING__Quote_Doc_Fee__c;
                        }
                        
                        Boolean isActiveRegfee = objBoatBuilderUtil.getboatRegFeeTaxable();
                        if(objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c != null && isActiveRegfee) {
                            NetSellingPriceFormula += objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c;
                        }
                        Boolean isActiveTradeAllowance = objBoatBuilderUtil.getboatTradeAllowanceTaxable();
                        if(objQuote.BOATBUILDING__Quote_Trade_Allowance__c != null && isActiveTradeAllowance){
                           NetSellingPriceFormula += objQuote.BOATBUILDING__Quote_Trade_Allowance__c;
                        }

                        
                        Decimal BSTF = (NetSellingPriceFormula * VehicleSalestax)/100;
                        if(CappingAmountForVehicleSalesTax > 0) {
                            if(BSTF<= CappingAmountForVehicleSalesTax) {
                                objQuote.BOATBUILDING__Boat_Sales_Tax2_Backend__c = BSTF;
                            }
                            else {
                                objQuote.BOATBUILDING__Boat_Sales_Tax2_Backend__c = CappingAmountForVehicleSalesTax;
                            }
                        } else {
                            objQuote.BOATBUILDING__Boat_Sales_Tax2_Backend__c = BSTF;
                        }
                    }
                    
                    if(objQuote.BOATBUILDING__Status__c == 'Final' && !objQuote.Name.containsIgnoreCase('final')) {
                        objQuote.Name = 'Final ' + objQuote.Name; 
                    }
                }
            }
        }
        
        
        if(trigger.isAfter && trigger.isUpdate) {
            QuoteTriggerHandler.noTrailerOperationAfter(Trigger.newMap);
        }
        
        if(Trigger.isBefore && Trigger.isInsert){
            QuoteTriggerHandler.isBeforeInsert(Trigger.new);
        }
        
        if(Trigger.isBefore && Trigger.isUpdate){
            QuoteTriggerHandler.isBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
        
        if(Trigger.isAfter && Trigger.isInsert){
            QuoteTriggerHandler.isAfterInsert(Trigger.new);
        }
        
        if(trigger.isAfter) {
            if(trigger.isInsert || trigger.isUpdate) {
                if(QuoteTriggerHandler.runOnce()) {
                    List<Quote__c> lstQuote = new List<Quote__c>();
                    for(Quote__c objQuote: trigger.new) {
                        if(objQuote.BOATBUILDING__New_Ordered_Boat__c && objQuote.BOATBUILDING__Status__c != null && objQuote.BOATBUILDING__Status__c.equalsIgnoreCase('final') && 
                            objQuote.BOATBUILDING__Related_to_Product__c != null && objQuote.BOATBUILDING__Test_2__c == null) {
                                lstQuote.add(objQuote);
                            }
                    }
                    if(!lstQuote.isEmpty()) {
                        QuoteTriggerHandler.createdOrderInventory(lstQuote);
                    }
                }
            }
        }
        if(trigger.isUpdate) {
        	if(QuoteTriggerHandler.runOnce()) {
	        	Set<String> setQuoteId = new Set<String>();
	        	Set<String> setDLRQuoteId = new Set<String>();  
	        	Id recordTypeId = Schema.SObjectType.BOATBUILDING__Quote__c.getRecordTypeInfosByName().get('Dealer Quote').getRecordTypeId();
	        	List<Quote__c> lstQT = new List<Quote__c>();
	        	for(Quote__c objQuote: trigger.new) {
	        		if(objQuote.BOATBUILDING__Dealer_Quote__c != null) {
	        			setDLRQuoteId.add(objQuote.BOATBUILDING__Dealer_Quote__c);
	        			setQuoteId.add(objQuote.Id);
	        			BOATBUILDING__Quote__c objDlrQuote = objQuote.clone(false, true);
	        			objDlrQuote.Id = objQuote.BOATBUILDING__Dealer_Quote__c;
	        			objDlrQuote.BOATBUILDING__Dealer_Quote__c = null;
	        			objDlrQuote.RecordTypeId = recordTypeId;
	        			lstQT.add(objDlrQuote);
	        		}	
	        	}
	        	if(!lstQT.isEmpty())
	        		update lstQT;        
		        List<BOATBUILDING__Quote_Line_Item__c> lstMainQLI = [Select Id, Name, Name__c, Product__c, Option_Category__c, Total_Price__c, Date__c, Dealer_Price__c, Product_Code__c, 
		        															BOATBUILDING__Quote__c, Non_Taxable__c From BOATBUILDING__Quote_Line_Item__c Where Quote__c IN: setQuoteId];
		        delete [Select Id From BOATBUILDING__Quote_Line_Item__c Where BOATBUILDING__Quote__c IN: setDLRQuoteId];
		        List<BOATBUILDING__Quote_Line_Item__c> lstQuoteLineItem = new List<BOATBUILDING__Quote_Line_Item__c>();
		        for(BOATBUILDING__Quote_Line_Item__c objQLI: lstMainQLI) {
		            BOATBUILDING__Quote_Line_Item__c objQLID = new BOATBUILDING__Quote_Line_Item__c();
		            objQLID.Name = 'QLI';
		            objQLID.Name__c = objQLI.Name__c;
		            objQLID.Product__c = objQLI.Product__c;
		            objQLID.Option_Category__c = objQLI.Option_Category__c;
		            objQLID.Total_Price__c = objQLI.Total_Price__c;
		            objQLID.Date__c =  objQLI.Date__c;
		            objQLID.Dealer_Price__c = objQLI.Dealer_Price__c;
		            objQLID.Product_Code__c = objQLI.Product_Code__c ;
		            objQLID.BOATBUILDING__Quote__c = trigger.newMap.get(objQLI.BOATBUILDING__Quote__c).BOATBUILDING__Dealer_Quote__c;
		            objQLID.Non_Taxable__c = objQLI.Non_Taxable__c;
		            lstQuoteLineItem.add(objQLID); 
		        }
		        if(!lstQuoteLineItem.isEmpty())
		        	insert lstQuoteLineItem;
        	}
        }
    }
}