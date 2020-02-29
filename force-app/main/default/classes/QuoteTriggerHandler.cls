public with sharing class QuoteTriggerHandler {
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    public static void createdOrderInventory(List<Quote__c> lstQuote) {
    	Set<String> setProductId = new Set<String>();
    	Set<String> setQuoteId = new Set<String>();
    	
        List<Inventory_Line_Item__c> lstILI = new List<Inventory_Line_Item__c>();
        List<Inventory__c> lstInventory = new List<Inventory__c>();
        Map<String, Quote__c> mapProductQuote = new Map<String, Quote__c>();
        Map<String, Decimal> mapTotalPrice = new Map<String, Decimal>(); 
        Map<String, Decimal> mapTotalPriceDealer = new Map<String, Decimal>();
        
    	for(Quote__c objQt: lstQuote) {
    		setProductId.add(objQt.BOATBUILDING__Related_to_Product__c);
    		setQuoteId.add(objQt.Id);
    	}
    	List<Product__c> lstProduct = [Select b.Name,b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__State__c, b.BOATBUILDING__Sale_Price__c, b.BOATBUILDING__Quantity_In_Stock__c, b.BOATBUILDING__Product_Type__c, b.BOATBUILDING__Product_Short_Description__c, b.BOATBUILDING__Product_Manufacturer__c, b.BOATBUILDING__Product_Long_Description__c, b.BOATBUILDING__ProductName__c, b.BOATBUILDING__Prep__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__M_Your_Price_Calculated__c, b.BOATBUILDING__M_Year__c, b.BOATBUILDING__M_V_Drive__c, b.BOATBUILDING__M_Trailer_Trade_Allowance__c, b.BOATBUILDING__M_Trailer_Sales_Tax__c, b.BOATBUILDING__M_Trailer_Reg_Fee__c, b.BOATBUILDING__M_Trailer_MSRP_PRICE__c, b.BOATBUILDING__M_Trailer_Actual_Cost_Value_ACV__c, b.BOATBUILDING__M_Trade_PayOFF__c, b.BOATBUILDING__M_Total_Price_Calculated__c, b.BOATBUILDING__M_Total_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Total_MSRP__c, b.BOATBUILDING__M_Total_Due__c, b.BOATBUILDING__M_Total_Amount_Financed_Calculated__c, b.BOATBUILDING__M_Shipped_Date__c, b.BOATBUILDING__M_Selected_Category__c, b.BOATBUILDING__M_Rfinance_Rate__c, b.BOATBUILDING__M_Retail_Price__c, b.BOATBUILDING__M_Requested_Ship_Date__c, b.BOATBUILDING__M_Received_Date__c, b.BOATBUILDING__M_Quote_Date__c, b.BOATBUILDING__M_Quantity__c, b.BOATBUILDING__M_Purchase_Line_Item__c, b.BOATBUILDING__M_Product_Salesperson_new__c, b.BOATBUILDING__M_Product_Retail_Price_To__c, b.BOATBUILDING__M_Product_Retail_Price_From__c, b.BOATBUILDING__M_Product_Family__c, b.BOATBUILDING__M_Payment__c, b.BOATBUILDING__M_Order_Date_To__c, b.BOATBUILDING__M_Order_Date_From__c, b.BOATBUILDING__M_Option_Category__c, b.BOATBUILDING__M_Net_Selling_Price_Calculated__c, b.BOATBUILDING__M_Model_Variant__c, b.BOATBUILDING__M_Manufacturer1__c, b.BOATBUILDING__M_Manufacture_Status__c, b.BOATBUILDING__M_Hidden_Box__c, b.BOATBUILDING__M_Finance_Term__c, b.BOATBUILDING__M_Engine__c, b.BOATBUILDING__M_Down_Payment__c, b.BOATBUILDING__M_Doc_Fee__c, b.BOATBUILDING__M_Discount__c, b.BOATBUILDING__M_Description__c, b.BOATBUILDING__M_Dealer_Stock__c, b.BOATBUILDING__M_Dealer_Status__c, b.BOATBUILDING__M_Dealer_Flat_Discount__c, b.BOATBUILDING__M_Dealer_Discount__c, b.BOATBUILDING__M_Dealer_Comments__c, b.BOATBUILDING__M_Dealer_COD_Discount__c, b.BOATBUILDING__M_Dealer_Base_Price__c, b.BOATBUILDING__M_Deal_Margin__c, b.BOATBUILDING__M_Date_Received__c, b.BOATBUILDING__M_Boat_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Boat_Trade_Allowance__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c, b.BOATBUILDING__M_Boat_Reg_Fee__c, b.BOATBUILDING__M_Boat_MSRP_PRICE__c, b.BOATBUILDING__M_Boat_Actual_Cost_Value_ACV__c, b.BOATBUILDING__MSRP__c, b.BOATBUILDING__MModel2__c, b.BOATBUILDING__Is_Active__c, b.BOATBUILDING__Hull_Id__c, b.BOATBUILDING__Freight__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Custom__c, b.BOATBUILDING__Cost_Price__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Account__c From BOATBUILDING__Product__c b Where Id IN: setProductId];
    	List<Quote__c> lstQuoteLI = [Select b.Id, b.BOATBUILDING__Test_2__c, b.BOATBUILDING__Status__c, b.BOATBUILDING__Related_to_Product__c, 
    									(Select Id, Name, BOATBUILDING__Quote__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Line_Item_Description__c,
	    									 BOATBUILDING__List_Price__c, BOATBUILDING__Product_Code__c, BOATBUILDING__Quantity__c, BOATBUILDING__Sales_Price__c, BOATBUILDING__Sub_Total__c, 
	    									 BOATBUILDING__Total_Price__c, BOATBUILDING__Option_Category__c, BOATBUILDING__Name__c, BOATBUILDING__Product_Type__c, BOATBUILDING__Non_Taxable__c 
									 	From BOATBUILDING__Quote_Line_Item__r) 
								 	From 
								 		BOATBUILDING__Quote__c b Where Id IN: setQuoteId];
    	
    	for(Quote__c objQt: lstQuoteLI) {
    		mapProductQuote.put(objQt.BOATBUILDING__Related_to_Product__c,objQt);
    		Decimal totalPrice = 0.00;
            Decimal totalPriceDealer = 0.00;
    		for(BOATBUILDING__Quote_Line_Item__c objQLI: objQt.BOATBUILDING__Quote_Line_Item__r) {
                Inventory_Line_Item__c objILI = new Inventory_Line_Item__c();
                objILI.Name__c = objQLI.Name__c;
                objILI.Name = 'ILI';
                objILI.Option_Category__c = objQLI.Option_Category__c;
                objILI.Price__c = objQLI.BOATBUILDING__Total_Price__c;
                objILI.Product_Code__c = objQLI.Product_Code__c ;
                objILI.Dealer_Price__c = objQLI.Dealer_Price__c;
        		objILI.Product_Type__c = 'New Boat'; 
                objILI.BOATBUILDING__Item_Description__c = objQt.Id;
                lstILI.add(objILI);
                totalPrice += objQLI.BOATBUILDING__Total_Price__c;
                totalPriceDealer += objQLI.Dealer_Price__c;
            }
            mapTotalPrice.put(objQt.Id, totalPrice);
            mapTotalPriceDealer.put(objQt.Id, totalPriceDealer);
    	}
    	
    	for(Product__c objProduct: lstProduct) {
    		Inventory__c objInventory = new Inventory__c();
    		Decimal totalPrice = mapTotalPrice.get(mapProductQuote.get(objProduct.Id).Id);
        	Decimal totalPriceDealer = mapTotalPriceDealer.get(mapProductQuote.get(objProduct.Id).Id);
        		
        	if(objProduct.M_Boat_MSRP_PRICE__c != null ){
                totalPrice += objProduct.M_Boat_MSRP_PRICE__c;
            } 
            if(objProduct.Cost_Price__c != null){
                totalPriceDealer += objProduct.Cost_Price__c; 
            }
            objInventory.Stage__c = 'Ordered';
            List<RecordType> lstRecT = new List<RecordType>();
            if(objProduct.Product_Type__c != null && objProduct.Product_Type__c.equalsIgnoreCase('New Boat')) { 
                lstRecT = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name = 'New Boats' limit 1];
            } else {
                lstRecT = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name =: objProduct.Product_Type__c limit 1];
            }
            if(lstRecT.size() > 0){
                objInventory.RecordTypeId = lstRecT[0].Id;  
            }
            if(objProduct.BOATBUILDING__Product_Manufacturer__c	 != null){
                objInventory.Manufacturer__c = [Select Name from BOATBUILDING__Manufacturer__c where Id =: objProduct.BOATBUILDING__Product_Manufacturer__c	 limit 1].Name;
            }
            if(objProduct.M_Year__c != null) {
                objInventory.Year__c = objProduct.M_Year__c;
            }
            if(objProduct.MModel2__c != null) {   
                objInventory.Model__c = objProduct.MModel2__c;
            }
            
            if(objProduct.M_Model_Variant__c != null){
                objInventory.Model_Variant__c = objProduct.M_Model_Variant__c; 
            }
            if(objProduct.Cost_Price__c != null){
                objInventory.Cost__c = objProduct.Cost_Price__c; 
            }
            
            if(objProduct.Part_Number__c != null){
                objInventory.Part_Number__c = objProduct.Part_Number__c; 
            }
            if(objProduct.Dealer__c !=null){
                objInventory.Dealer__c = objProduct.Dealer__c;
            }
            if(objProduct.M_Dealer_Base_Price__c !=null){
                objInventory.Dealer_Base_Price__c = objProduct.M_Dealer_Base_Price__c;
            }
            if(objProduct.M_Dealer_Discount__c !=null){
                objInventory.Dealer_Discount__c = objProduct.M_Dealer_Discount__c;
            }
            if(objProduct.M_Dealer_COD_Discount__c !=null){
                objInventory.Dealer_COD_Discount__c = objProduct.M_Dealer_COD_Discount__c;
            }
            if(objProduct.M_Dealer_Flat_Discount__c !=null){
                objInventory.Dealer_Flat_Discount__c = objProduct.M_Dealer_Flat_Discount__c;
            }
            if(objProduct.M_Dealer_Stock__c !=null){
                objInventory.Dealer_Stock__c = objProduct.M_Dealer_Stock__c;
            }
            if(objProduct.M_Dealer_Status__c !=null){
                objInventory.Dealer_Status__c = objProduct.M_Dealer_Status__c;
            }
            if(objProduct.M_Dealer_Comments__c !=null){
                objInventory.Dealer_Comments__c = objProduct.M_Dealer_Comments__c;
            }
            if(objProduct.Transmission_Gearbox_SN__c !=null){
                objInventory.Transmission_Gearbox_SN__c = objProduct.Transmission_Gearbox_SN__c;
            }
            if(objProduct.Hull_Id__c !=null){
                objInventory.HIN_Number__c = objProduct.Hull_Id__c;
            }
            if(objProduct.Engine_SN__c !=null){
                objInventory.Engine_SN__c = objProduct.Engine_SN__c;
            }
            if(objProduct.Trailer_VIN__c !=null){
                objInventory.Trailer_VIN__c = objProduct.Trailer_VIN__c;
            }
            if(objProduct.Boat_Length_in_feets__c !=null){
                objInventory.Boat_Length_in_feets__c = objProduct.Boat_Length_in_feets__c;
            }
            if(totalPrice != null){
                objInventory.Total_MSRP_Price__c = totalPrice;
            }
            if(totalPrice != null){
                objInventory.Total_Dealer_Price__c = totalPriceDealer;
            }
            objInventory.BOATBUILDING__Description__c = mapProductQuote.get(objProduct.Id).Id;
            lstInventory.add(objInventory);
    	}
    	insert lstInventory;
    	
    	for(Inventory__c objInv: lstInventory) {
    		for(Inventory_Line_Item__c objILI: lstILI) {
    			if(objInv.BOATBUILDING__Description__c == objILI.BOATBUILDING__Item_Description__c) {
    				objILI.BOATBUILDING__Related_to_Inventory__c = objInv.Id;
    				objILI.BOATBUILDING__Item_Description__c = '';
    			}
    		}
    	}
    	insert lstILI;
    	for(Inventory__c objInv: lstInventory) {
    		for(Quote__c objQt: lstQuoteLI) {
    			if(objInv.BOATBUILDING__Description__c == String.valueOf(objQt.Id)) {
    				objQt.BOATBUILDING__Test_2__c = objInv.Id;
    				objInv.BOATBUILDING__Description__c = '';
    			}
    		}
    	}
    	update lstInventory;
    	update lstQuoteLI;
    	
    }
    
    public static void isBeforeInsert(List<Quote__c> lstNewQuote){
        updateTrailerInfo(lstNewQuote);
        Map<Id, Quote__c> mapOldQuote = new Map<Id, Quote__c>();
        updateEngineTrailerInfo(lstNewQuote, mapOldQuote, True);
    }
    
    public static void isAfterInsert(List<Quote__c> lstNewQuote){
        createAccountActivity(lstNewQuote);
    }
    
    public static void isBeforeUpdate(List<Quote__c> lstNewQuote, Map<Id, Quote__c> mapOldQuote){
        //updateTrailerInfo(lstNewQuote);
        updateEngineTrailerInfo(lstNewQuote, mapOldQuote, False);
    }
    
    
    public static void updateTrailerInfo(List<Quote__c> lstNewQuote){
        
        Id trailerRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Trailer').getRecordTypeId();
        Id engineRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Engine').getRecordTypeId();
        Set<Id> setInventoryId = new Set<Id>();
        
        for(Quote__c objQ: lstNewQuote){
            if(objQ.BOATBUILDING__Test_2__c != null){
                setInventoryId.add(objQ.BOATBUILDING__Test_2__c);
            }
        }
        
        Map<Id, BOATBUILDING__Inventory__c> mapTrailerToCheck = new Map<Id, BOATBUILDING__Inventory__c>([SELECT Id, Name, BOATBUILDING__Trailer_VIN__c, BOATBUILDING__Total_MSRP_Price__c FROM BOATBUILDING__Inventory__c WHERE Id IN: setInventoryId AND RecordTypeId =: trailerRecordTypeId]);
        
        Map<Id, BOATBUILDING__Inventory__c> mapEngineCheck = new Map<Id, BOATBUILDING__Inventory__c>([SELECT Id, Name, BOATBUILDING__Engine_SN__c, BOATBUILDING__Total_MSRP_Price__c FROM BOATBUILDING__Inventory__c WHERE Id IN: setInventoryId AND RecordTypeId =: engineRecordTypeId]);
        
        for(Quote__c objQ: lstNewQuote){
            if(mapTrailerToCheck.containsKey(objQ.BOATBUILDING__Test_2__c)){
                objQ.BOATBUILDING__Trailer__c = objQ.BOATBUILDING__Test_2__c;
                if( mapTrailerToCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Trailer_VIN__c != null)
                    objQ.BOATBUILDING__Mapped_Trailer_VIN__c = mapTrailerToCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Trailer_VIN__c;
                //objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapEngineCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Total_MSRP_Price__c;
            }
        }
        
        for(Quote__c objQ: lstNewQuote){
            if(mapEngineCheck.containsKey(objQ.BOATBUILDING__Test_2__c)){
                if(mapEngineCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Engine_SN__c != null)
                    objQ.BOATBUILDING__Mapped_Engine_SN__c = mapEngineCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Engine_SN__c;
                objQ.BOATBUILDING__Engine__c = objQ.BOATBUILDING__Test_2__c;
                //objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapEngineCheck.get(objQ.BOATBUILDING__Test_2__c).BOATBUILDING__Total_MSRP_Price__c;
            } 
        }
    }
    
    public static void updateEngineTrailerInfo(List<Quote__c> lstNewQuote, Map<Id, Quote__c> mapOldQuote, Boolean isInsert){
        
        Id trailerRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Trailer').getRecordTypeId();
        Id engineRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Engine').getRecordTypeId();
        Set<Id> setEngineInventoryId = new Set<Id>();
        Set<Id> setTrailerInventoryId = new Set<Id>();
        
        for(Quote__c objQ: lstNewQuote){
            if(isInsert){
                if(objQ.BOATBUILDING__Engine__c != null){
                    setEngineInventoryId.add(objQ.BOATBUILDING__Engine__c);
                }
                if(objQ.BOATBUILDING__Trailer__c != null){
                    setTrailerInventoryId.add(objQ.BOATBUILDING__Trailer__c);
                }
            } else {
                if(mapOldQuote.get(objQ.Id).BOATBUILDING__Engine__c != objQ.BOATBUILDING__Engine__c){
                    setEngineInventoryId.add(objQ.BOATBUILDING__Engine__c);
                    setEngineInventoryId.add(mapOldQuote.get(objQ.Id).BOATBUILDING__Engine__c);
                } else if(mapOldQuote.get(objQ.Id).BOATBUILDING__Trailer__c != objQ.BOATBUILDING__Trailer__c){
                    setTrailerInventoryId.add(objQ.BOATBUILDING__Trailer__c);
                    setTrailerInventoryId.add(mapOldQuote.get(objQ.Id).BOATBUILDING__Trailer__c);
                }
            }
        }
        
        //Update Engine Info/Pricing
        if(!setEngineInventoryId.isEmpty()){
            Map<Id, BOATBUILDING__Inventory__c> mapEngineCheck = new Map<Id, BOATBUILDING__Inventory__c>([SELECT Id, Name, BOATBUILDING__Engine_SN__c, BOATBUILDING__Total_MSRP_Price__c FROM BOATBUILDING__Inventory__c WHERE Id IN: setEngineInventoryId AND RecordTypeId =: engineRecordTypeId]);
            
            for(Quote__c objQ: lstNewQuote){
                if(mapOldQuote.containsKey(objQ.Id) && !isInsert){
                    Quote__c oldQuote = mapOldQuote.get(objQ.Id);
                    if(oldQuote.BOATBUILDING__Engine__c == null && objQ.BOATBUILDING__Engine__c != null){
                        if(mapEngineCheck.containsKey(objQ.BOATBUILDING__Engine__c)){
                            objQ.BOATBUILDING__Mapped_Engine_SN__c = mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Engine_SN__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                        }
                    } else if(oldQuote.BOATBUILDING__Engine__c != null && objQ.BOATBUILDING__Engine__c == null){
                        if(mapEngineCheck.containsKey(oldQuote.BOATBUILDING__Engine__c)){
                            objQ.BOATBUILDING__Mapped_Engine_SN__c = '';
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c - mapEngineCheck.get(oldQuote.BOATBUILDING__Engine__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                        }
                    } else if(oldQuote.BOATBUILDING__Engine__c != null && objQ.BOATBUILDING__Engine__c != null){
                        if(mapEngineCheck.containsKey(oldQuote.BOATBUILDING__Engine__c) && mapEngineCheck.containsKey(objQ.BOATBUILDING__Engine__c)){
                            objQ.BOATBUILDING__Mapped_Engine_SN__c = mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Engine_SN__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c - mapEngineCheck.get(oldQuote.BOATBUILDING__Engine__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                        }
                    }
                } /* We are commenting this as automatic quote will be created by Re-Negotiation only
else if(isInsert){
if(mapEngineCheck.containsKey(objQ.BOATBUILDING__Engine__c)){
objQ.BOATBUILDING__Mapped_Engine_SN__c = mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Engine_SN__c;
objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapEngineCheck.get(objQ.BOATBUILDING__Engine__c).BOATBUILDING__Total_MSRP_Price__c;
}
}*/
            }
        }
        
        //Update Trailer Info/Pricing
        if(!setTrailerInventoryId.isEmpty()){
            Map<Id, BOATBUILDING__Inventory__c> mapTrailerToCheck = new Map<Id, BOATBUILDING__Inventory__c>([SELECT Id, Name, BOATBUILDING__Trailer_VIN__c, BOATBUILDING__Total_MSRP_Price__c 
                                                                                                             FROM BOATBUILDING__Inventory__c 
                                                                                                             WHERE Id IN: setTrailerInventoryId AND RecordTypeId =: trailerRecordTypeId]);
            
            for(Quote__c objQ: lstNewQuote){
                if(mapOldQuote.containsKey(objQ.Id) && !isInsert){
                    Quote__c oldQuote = mapOldQuote.get(objQ.Id);
                    if(oldQuote.BOATBUILDING__Trailer__c == null && objQ.BOATBUILDING__Trailer__c != null){
                        if(mapTrailerToCheck.containsKey(objQ.BOATBUILDING__Trailer__c)){
                            System.debug('objQ.BOATBUILDING__Total_Price_Quote__c---1--'+objQ.BOATBUILDING__Total_Price_Quote__c);
                            objQ.BOATBUILDING__Mapped_Trailer_VIN__c = mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Trailer_VIN__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                            System.debug('objQ.BOATBUILDING__Total_Price_Quote__c---2---'+objQ.BOATBUILDING__Total_Price_Quote__c);
                        }
                    } else if(oldQuote.BOATBUILDING__Trailer__c != null && objQ.BOATBUILDING__Trailer__c == null){
                        if(mapTrailerToCheck.containsKey(oldQuote.BOATBUILDING__Trailer__c)){
                            objQ.BOATBUILDING__Mapped_Trailer_VIN__c = '';
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c - mapTrailerToCheck.get(oldQuote.BOATBUILDING__Trailer__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                        }
                    } else if(oldQuote.BOATBUILDING__Trailer__c != null && objQ.BOATBUILDING__Trailer__c != null){
                        if(mapTrailerToCheck.containsKey(oldQuote.BOATBUILDING__Trailer__c) && mapTrailerToCheck.containsKey(objQ.BOATBUILDING__Trailer__c)){
                            System.debug('objQ.BOATBUILDING__Total_Price_Quote__c---3---'+objQ.BOATBUILDING__Total_Price_Quote__c);
                            objQ.BOATBUILDING__Mapped_Trailer_VIN__c = mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Trailer_VIN__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c - mapTrailerToCheck.get(oldQuote.BOATBUILDING__Trailer__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Total_MSRP_Price__c;
                            objQ.BOATBUILDING__Quote_Sale_Price__c = objQ.BOATBUILDING__Total_Price_Quote__c;
                            System.debug('objQ.BOATBUILDING__Total_Price_Quote__c---4---'+objQ.BOATBUILDING__Total_Price_Quote__c);
                        }
                    }
                } /* We are commenting this as automatic quote will be created by Re-Negotiation only
else if(isInsert){
if(mapTrailerToCheck.containsKey(objQ.BOATBUILDING__Trailer__c)){
objQ.BOATBUILDING__Mapped_Trailer_VIN__c = mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Trailer_VIN__c;
objQ.BOATBUILDING__Total_Price_Quote__c = objQ.BOATBUILDING__Total_Price_Quote__c + mapTrailerToCheck.get(objQ.BOATBUILDING__Trailer__c).BOATBUILDING__Total_MSRP_Price__c;
}
}*/
            }
        }
    }
    
    
    public static void createAccountActivity(List<Quote__c> lstNewQuote){
        
        List<Task> lstTaskToBeCreated = new List<Task>();
        for(Quote__c objQ: lstNewQuote){
            Task objT = new Task();
            objT.Subject = objQ.Name+' Quote has been created';
            objT.OwnerId = objQ.CreatedbyId;
            objT.Status = 'Completed';
            objT.WhatId = objQ.BOATBUILDING__Account_Name__c;
            objT.ActivityDate = System.today();
            lstTaskToBeCreated.add(objT);
        }
        
        if(!lstTaskToBeCreated.isEmpty()){
            insert lstTaskToBeCreated;
        }
    }
    
    
    public static void noTrailerOperationAfter(Map<Id, Quote__c> newMapQT) {
        List<Quote__c> lstQuote = [Select Id, Discount_On_Quote__c, Quote_Sale_Price__c, Total_Price_Quote__c, No_Trailer__c, 
                                   Related_to_Product__r.M_Boat_MSRP_PRICE__c, Related_to_Product__c, 
                                   (Select Id, BOATBUILDING__Total_Price__c, BOATBUILDING__Name__c, BOATBUILDING__Product_Type__c From BOATBUILDING__Quote_Line_Item__r) 
                                   From Quote__c Where Id IN: newMapQT.keySet()];
        Set<String> strQLIId = new Set<String>(); 								
        for(Quote__c obj: lstQuote) {
            System.debug('Debug log for newMapQT.No_Trailer__c: '+newMapQT.get(obj.Id).No_Trailer__c);
            if(newMapQT.get(obj.Id).No_Trailer__c) {
                if(!obj.BOATBUILDING__Quote_Line_Item__r.isEmpty()) {
                    for(BOATBUILDING__Quote_Line_Item__c objQLI: obj.BOATBUILDING__Quote_Line_Item__r) {
                        if(objQLI.BOATBUILDING__Product_Type__c == 'Trailer') { 
                            strQLIId.add(objQLI.Id);
                        }
                    }
                }
            }
        }
        System.debug('Debug log for strQLIId: '+strQLIId);
        if(!strQLIId.isEmpty())
            delete [Select Id From BOATBUILDING__Quote_Line_Item__c Where Id IN: strQLIId];
    }
    
}