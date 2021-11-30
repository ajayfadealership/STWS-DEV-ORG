public class GetAQuoteUtility {
    public static Quote__c generateQuote(String strAccountId, String strInvId,   
                                         List<String> lstProductPrice, List<String> lstDealerOption, 
                                         Quote__c objQT, Boolean zipCodeExist, String strState, String strStoreLocation) 
    {
        Quote__c objQuote = new Quote__c();
        try {
            System.debug('Debug Log For strAccountId: '+strAccountId);
            System.debug('Debug Log For strInvId: '+strInvId);
            System.debug('Debug Log For lstProductPrice: '+lstProductPrice);    
            System.debug('Debug Log For lstDealerOption: '+lstDealerOption);
            System.debug('Debug Log For objQT: '+objQT);
            
            Decimal yourPriceThirdPageForProductPrice = 0.00;
            Decimal totalPrice = 0.00;
            Decimal MfgOptTota = 0.00;
            Decimal dealerOptionTotal = 0.00;
            
            objQuote = objQT;
            objQuote.BOATBUILDING__State__c = objQT.BOATBUILDING__State__c;
            List<Quote_Line_Item__c> lstQLI = new List<Quote_Line_Item__c>();
            //Product__c objProduct = new Product__c();
            Inventory__c objInventory = new Inventory__c();
            Account objAccount = new Account();
            
            if(String.isNotBlank(strAccountId)) {
                objAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, 
                              BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, 
                              ShippingPostalCode, Email__c,
                              Phone FROM Account where Id =: strAccountId];
            } 
            
            if(strInvId != null) { 
                objInventory = [Select b.RecordType.Name, b.BOATBUILDING__Our_Instant_Quote_Price__c ,b.RecordTypeId, b.Name, 
                                b.Id, b.BOATBUILDING__Year__c, b.BOATBUILDING__Website__c, b.BOATBUILDING__Web_Price__c, 
                                b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Model__c, 
                                b.BOATBUILDING__Total_MSRP_Price__c, b.BOATBUILDING__Total_Inventory_MSRP__c, 
                                b.BOATBUILDING__Total_Inventory_Cost__c, b.BOATBUILDING__Total_Dealer_Price__c,
                                b.BOATBUILDING__Suggested_List_Price__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__Status__c, 
                                b.Transmission_Gearbox_SN__c, b.BOATBUILDING__Mfg_Invoice__c, b.Boat_Length_in_feets__c,
                                b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__HIN_Number__c, b.BOATBUILDING__Manufacture_Invoice__c,
                                b.BOATBUILDING__Manufacture_Invoice2__c, b.BOATBUILDING__Location__c, 
                                b.BOATBUILDING__Invoice_Number__c, b.BOATBUILDING__Hull_ID__c, 
                                b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Cost__c, b.BOATBUILDING__ACV__c,
                                (
                                    SELECT 
                                    Id, IsDeleted, Name, Name__c, Related_to_Inventory__c, Item_Description__c, Discount__c, Dealer_Price__c, 
                                    Option_Category__c, Price__c, Product_Code__c, Quantity__c, Non_Taxable__c 
                                    FROM
                                    BOATBUILDING__Inventory_Line_Items__r
                                )
                                FROM BOATBUILDING__Inventory__c b WHERE Id =: strInvId LIMIT 1];
                
                objQuote.BOATBUILDING__Our_Instant_Quote_Price__c = objInventory.BOATBUILDING__Our_Instant_Quote_Price__c;
                objQuote.BOATBUILDING__Map_Price__c = objInventory.BOATBUILDING__Map_Price__c;
                if(objInventory.Engine_SN__c != null){             
                    objQuote.Mapped_Engine_SN__c = objInventory.Engine_SN__c;
                }
                if(objInventory.Boat_Length_in_feets__c != null){             
                    objQuote.Mapped_Boat_Length__c = objInventory.Boat_Length_in_feets__c;
                }             
                if(objInventory.HIN_Number__c != null && objInventory.HIN_Number__c != ''){             
                    objQuote.Mapped_HIN__c = objInventory.HIN_Number__c;
                }
                else if(objInventory.Hull_ID__c != null && objInventory.Hull_ID__c != '') {
                    objQuote.Mapped_HIN__c = objInventory.Hull_ID__c;
                }
                if(objInventory.Trailer_VIN__c != null){             
                    objQuote.Mapped_Trailer_VIN__c = objInventory.Trailer_VIN__c;
                }
                if(objInventory.Transmission_Gearbox_SN__c != null){             
                    objQuote.Transmission_Gearbox_SN__c = objInventory.Transmission_Gearbox_SN__c; 
                }
                objQuote.Quote_MSRP_Boat_Price__c = 0;
                objQuote.Quote_MSRP_Trailer_Price__c = 0;
                objQuote.Quote_Trade_Allowance__c = 0;
                objQuote.Quote_Trailer_Allowance__c = 0;
                //objQuote.Quote_Trailer_ACV__c = 0;
                objQuote.Quote_Trailer_Sales_Tax__c = 0;
                objQuote.Quote_Trade_Payoff__c =0;  
                objQuote.Quote_Down_Payment__c =0;
                objQuote.Quote_Rate__c =0;
                objQuote.Quote_Term__c ='More';
                objQuote.Quote_Payment__c =0;
                //objQuote.Quote_Deal_Margin__c =0;
                
                if(zipCodeExist && objInventory.BOATBUILDING__Our_Instant_Quote_Price__c != null) 
                { 
                    objQuote.Total_Price_Quote__c = objInventory.BOATBUILDING__Total_MSRP_Price__c != null ? objInventory.BOATBUILDING__Total_MSRP_Price__c : 
                                                        objInventory.BOATBUILDING__Web_Price__c != null ? objInventory.BOATBUILDING__Web_Price__c : objInventory.BOATBUILDING__Our_Instant_Quote_Price__c;
                    objQuote.Quote_Sale_Price__c = objInventory.BOATBUILDING__Our_Instant_Quote_Price__c;
                    objQuote.BOATBUILDING__Discount_On_Quote__c = objInventory.BOATBUILDING__Total_MSRP_Price__c != null ? objInventory.BOATBUILDING__Total_MSRP_Price__c - objInventory.BOATBUILDING__Our_Instant_Quote_Price__c: 0.00;
                } 
                else if(objInventory.BOATBUILDING__Web_Price__c != null && objInventory.BOATBUILDING__Web_Price__c > 0) 
                { 
                    objQuote.Quote_Sale_Price__c = objInventory.BOATBUILDING__Web_Price__c;
                    objQuote.Total_Price_Quote__c = objInventory.BOATBUILDING__Web_Price__c;
                    objQuote.BOATBUILDING__Discount_On_Quote__c = objInventory.BOATBUILDING__Total_MSRP_Price__c != null ? objInventory.BOATBUILDING__Total_MSRP_Price__c - objInventory.BOATBUILDING__Web_Price__c: 0.00;
                }
                else 
                {
                    objQuote.Quote_Sale_Price__c = objInventory.BOATBUILDING__Total_MSRP_Price__c;
                    objQuote.Total_Price_Quote__c = objInventory.BOATBUILDING__Total_MSRP_Price__c;
                    objQuote.BOATBUILDING__Discount_On_Quote__c = 0.00; 
                }                
            } 
            if(String.isNotBlank(strState) && ( strState == 'South Carolina' || strState == 'North Carolina' )) {
                objQuote.BOATBUILDING__State__c = strState;
            } else {
                objQuote.BOATBUILDING__State__c = 'Other';
            }
            /*if(String.isNotBlank(strStoreLocation)) {
                objQuote.BOATBUILDING__Store_Location__c = strStoreLocation;
                List<BOATBUILDING__Store_Location_Config__mdt> lstSLC =   [ SELECT Id, BOATBUILDING__Doc_Fee__c, BOATBUILDING__Trailer_Registration_Fee__c, BOATBUILDING__Registration_Fee__c 
                                                                            FROM BOATBUILDING__Store_Location_Config__mdt 
                                                                            WHERE Label =: strStoreLocation ];

                if(!lstSLC.isEmpty()) 
                {
                    objQuote.BOATBUILDING__Quote_Doc_Fee__c = lstSLC[0].BOATBUILDING__Doc_Fee__c != null ? lstSLC[0].BOATBUILDING__Doc_Fee__c : 0.00;
                    objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c = lstSLC[0].BOATBUILDING__Registration_Fee__c != null ? lstSLC[0].BOATBUILDING__Registration_Fee__c : 0.00;
                    objQuote.BOATBUILDING__Quote_Trailer_Reg_Fee__c = lstSLC[0].BOATBUILDING__Trailer_Registration_Fee__c != null ? lstSLC[0].BOATBUILDING__Trailer_Registration_Fee__c : 0.00;
                }
            } */
            if(objAccount.Id != null){
                objQuote.Account_Name__c = objAccount.Id;
            }
            if(objInventory.Cost__c != null){
                objQuote.Quote_Total_MSRP__c = objInventory.Cost__c;
            }
            if(objAccount.Name != null && objAccount.Name != ''){
                objQuote.Name = 'Quote For '+objAccount.Name;
                objQuote.Quote_To_Name__c = objAccount.Name;
            }else{
                objQuote.Name = 'Quote For '+objInventory.Name;
            }
            
            objQuote.Quote_To_Address__c = '';
            
            if(objAccount.Email__c != null && objAccount.Email__c != ''){
                objQuote.Email__c = objAccount.Email__c;
            }else{
                objQuote.Email__c = ' ';
            }
            
            if(objAccount.Phone != null && objAccount.Phone !=''){
                objQuote.Phone__c = objAccount.Phone;
            }else{
                objQuote.Phone__c = ' ';
            }
            
            if(strInvId != '0') {
                objQuote.BOATBUILDING__Test_2__c = strInvId;
            }
            objQuote.BOATBUILDING__Instant_Quote__c = True;
            insert objQuote;
             
            if(!objInventory.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
                for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory.BOATBUILDING__Inventory_Line_Items__r) {
                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                    objQLI.Name__c = objInventoryLineItem.Name__c;
                    objQLI.Name = 'QLI';
                    objQLI.Option_Category__c = objInventoryLineItem.Option_Category__c;
                    objQLI.Total_Price__c = objInventoryLineItem.Price__c;
                    objQLI.Date__c = Date.today();
                    objQLI.Product_Code__c = objInventoryLineItem.Product_Code__c ;
                    objQLI.Dealer_Price__c = objInventoryLineItem.Dealer_Price__c;
                    objQLI.BOATBUILDING__Quantity__c = 1;
                    if(objInventory.RecordType.Name == 'New Boats') {
                        objQLI.Product_Type__c = 'New Boat';
                    } else if(objInventory.RecordType.Name == 'Used Boats') {
                        objQLI.Product_Type__c = 'Used Boat';
                    }else {
                        objQLI.Product_Type__c = objInventory.RecordType.Name;
                    }
                    objQLI.Quote__c = objQuote.Id; 
                    lstQLI.add(objQLI);
                }
            }
            
            insert lstQLI;

            return objQuote;
        } catch(Exception ex) {
            System.debug('Debug log for exception: '+ex.getStackTraceString()+' : '+ex.getLineNumber()+'messagr'+ex.getCause()+ex.getMessage()); 
            return null;    
        }
    }
}