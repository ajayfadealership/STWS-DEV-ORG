public with sharing class QuoteTriggerHandler {
    
    public static void calculatePayment(List<Quote__c> listNewQuote) {
        for(Quote__c objQuote: listNewQuote) {
            if(objQuote.BOATBUILDING__Quote_Rate__c != null
               && objQuote.BOATBUILDING__Quote_Total_Amount_Financed_Calculated__c != null
               && objQuote.BOATBUILDING__Quote_Term__c != null) {
                   Double termInt = Integer.valueOf(objQuote.BOATBUILDING__Quote_Term__c.subString(0, 2).trim());
                   termInt = termInt * 12;
                   System.debug('termInt: '+termInt);
                   Double interestRate = objQuote.BOATBUILDING__Quote_Rate__c;
                   interestRate = interestRate/(12*100); 
                   System.debug('interestRate: '+interestRate);
                   Double financeVal = objQuote.BOATBUILDING__Quote_Total_Amount_Financed_Calculated__c;
                   System.debug('financeVal: '+financeVal);
                   Double paymentVal= (financeVal*interestRate*Math.pow(1+interestRate,termInt))/(Math.pow(1+interestRate,termInt)-1);
                   System.debug('paymentVal: '+paymentVal);
                   objQuote.BOATBUILDING__Quote_Payment__c = Decimal.valueOf(paymentVal).setscale(2);
                   System.debug('objQuote.BOATBUILDING__Quote_Payment__c: '+objQuote.BOATBUILDING__Quote_Payment__c);
               }
        } 
    }
    
    public Static void onBeforeInsert(List<Quote__c> listNewQuote){
        updateTrailerInfo(listNewQuote);
        Map<Id, Quote__c> mapOldQuote = new Map<Id, Quote__c>();
        updateEngineTrailerInfo(listNewQuote, mapOldQuote, True);
        
        calculateSalesTax(listNewQuote);
        calculatePayment(listNewQuote);
    }
    
    public Static void onBeforeUpdate(List<Quote__c> listNewQuote, Map<Id, Quote__c> mapOldQuote){
        updateEngineTrailerInfo(listNewQuote, mapOldQuote, False);
        calculateSalesTax(listNewQuote);
        calculatePayment(listNewQuote);
    }
    
    public Static void onBeforeDelete(List<Quote__c> listOldQuote){
    }
     
    public Static void onAfterInsert(List<Quote__c> listNewQuote){
        createAccountActivity(listNewQuote);
    }
    
    public Static void onAfterUpdate(List<Quote__c> listNewQuote, Map<Id, Quote__c> mapNewQuote, Map<Id, Quote__c> mapOldQuote){
        
        List<Quote__c> listNewQuoteToProcess = new List<Quote__c>();
        for(Quote__c objQuote: listNewQuote){
            if(objQuote.BOATBUILDING__New_Ordered_Boat__c && objQuote.BOATBUILDING__Status__c != null 
               && objQuote.BOATBUILDING__Status__c.equalsIgnoreCase('final') 
               && objQuote.BOATBUILDING__Related_to_Product__c != null && objQuote.BOATBUILDING__Test_2__c == null
               && !mapOldQuote.get(objQuote.Id).BOATBUILDING__New_Ordered_Boat__c) {
                   listNewQuoteToProcess.add(objQuote);
               }
        }
        if(!listNewQuoteToProcess.isEmpty()) {
            QuoteTriggerHandler.createdOrderInventory(listNewQuoteToProcess);
        }
        
        removeTrailerOptionForNoTrailerQuote(listNewQuote, mapOldQuote);
        
        if(runOnce()){
            updateDealerQuoteLineItems(listNewQuote, mapNewQuote);
        }
        
        createActivitiesForQuote(listNewQuote, mapOldQuote);
    }
    
    public Static void onAfterDelete(List<Quote__c> listOldQuote){
    }
    
    public static void createdOrderInventory(List<Quote__c> lstQuote) {
        System.debug('lstQuote---'+lstQuote);
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
    
    public static void removeTrailerOptionForNoTrailerQuote(List<Quote__c> listNewQuote, Map<Id, Quote__c> mapOldQuote) {
        
        Set<Id> setQuoteId = new Set<Id>();
        for(Quote__c objQuote: listNewQuote){
            if(objQuote.No_Trailer__c && !mapOldQuote.get(objQuote.Id).No_Trailer__c) {
                setQuoteId.add(objQuote.Id);
            }
        }
        
        List<BOATBUILDING__Quote_Line_Item__c> listQuoteLineItemToDelete = [SELECT Id FROM BOATBUILDING__Quote_Line_Item__c WHERE Quote__c IN: setQuoteId
                                                                            AND BOATBUILDING__Product_Type__c = 'Trailer'];
        
        if(!listQuoteLineItemToDelete.isEmpty())
            delete listQuoteLineItemToDelete;
    }
    
    public static void updateDealerQuoteLineItems(List<Quote__c> listNewQuote, Map<Id, Quote__c> mapNewQuote){
        Set<String> setQuoteId = new Set<String>();
        Set<String> setDLRQuoteId = new Set<String>();  
        Id recordTypeId = Schema.SObjectType.BOATBUILDING__Quote__c.getRecordTypeInfosByName().get('Dealer Quote').getRecordTypeId();
        List<Quote__c> lstQT = new List<Quote__c>();
        for(Quote__c objQuote: listNewQuote) {
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
            objQLID.BOATBUILDING__Quote__c = mapNewQuote.get(objQLI.BOATBUILDING__Quote__c).BOATBUILDING__Dealer_Quote__c;
            objQLID.Non_Taxable__c = objQLI.Non_Taxable__c;
            lstQuoteLineItem.add(objQLID); 
        }
        if(!lstQuoteLineItem.isEmpty())
            insert lstQuoteLineItem;
    }
    
    public static void calculateSalesTax(List<Quote__c> listNewQuote){
        
        for(Quote__c objQuote: listNewQuote) {
            
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
    
    public static void createActivitiesForQuote(List<Quote__c> listNewQuote, Map<Id, Quote__c> mapOldQuote){
        List<Task> lstTsk = new List<Task>();
        Set<String> setStoreLocation = new Set<String>();
        for(Quote__c objQuote: listNewQuote) {
            if(objQuote.BOATBUILDING__Status__c != null && objQuote.BOATBUILDING__Status__c == 'Presented' 
               && mapOldQuote.get(objQuote.Id).BOATBUILDING__Status__c != objQuote.BOATBUILDING__Status__c) {
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
        for(Quote__c objQuote: listNewQuote) {
            for(User objUser: lstUsr) {
                System.debug('AccountingStatus: '+AccountingStatus);
                System.debug('SalesManagerStatus: '+SalesManagerStatus);
                if(objQuote.BOATBUILDING__Status__c != null && objQuote.BOATBUILDING__Status__c == 'Final' 
                   && mapOldQuote.get(objQuote.Id).BOATBUILDING__Status__c != objQuote.BOATBUILDING__Status__c) {
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
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}