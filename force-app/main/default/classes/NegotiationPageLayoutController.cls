global with sharing class NegotiationPageLayoutController {
	global Quote__c objQuote { get; set; }
	global String disStatus { get; set; }
	global Decimal RegularSalestax { get; set; }
    global Decimal VehicleSalestax { get; set; }
    global Decimal CappingAmountForVehicleSalesTax { get; set; }
	global Decimal AboveCostline { get; set; }
	global Decimal UnderCostline { get; set; }
	global Decimal stip { get; set; }
    global NegotiationPageLayoutController(ApexPages.StandardController stdController) {
    	AboveCostline = 2;
    	UnderCostline = 1; 
    	stip = 0.00; 
    	BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
    	if(objSC != null && objSC.BOATBUILDING__Above_Costline__c != null) {
    		AboveCostline = objSC.BOATBUILDING__Above_Costline__c;
    	}
    	
    	if(objSC != null && objSC.BOATBUILDING__Under_Costline__c != null) {
    		UnderCostline = objSC.BOATBUILDING__Under_Costline__c;
    	}
    	//this.objQuote = (Quote__c)stdController.getRecord();
    	
    	objQuote= [Select q.BOATBUILDING__Commission_Stip__c,(Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Date__c, Discount__c,  
                            Line_Item_Description__c, List_Price__c, Product__c, Product_Code__c, Quantity__c, Quote__c, Sales_Price__c, Sub_Total__c, Total_Price__c 
                                From Quote_Line_Item__r limit 1000), q.Engine__c, q.BOATBUILDING__Costline_Sell_Price__c, q.BOATBUILDING__Booked_Sale_Price__c, 
                    q.Quote_Cost_Clone__c,q.Total_Price_Quote__c, q.Tax__c, q.SystemModstamp, q.Syncing__c, q.Status__c, q.State__c, q.Shipping_And_Handling__c, q.Ship_To__c, q.Related_to_Product__c ,
                        q.Ship_To_Name__c, q.Related_to_Order__c, q.Quote_Your_Price_Negotiation__c, q.Quote_Your_Price_Formula__c, q.Quote_Trailer_Sales_Tax__c, q.Mapped_Boat_Length__c,
                            q.Quote_Trailer_Sales_Tax_Negotiation__c, q.Quote_Trailer_Reg_Fee__c, q.Quote_Trailer_Reg_Fee_Negotiation__c, q.Quote_Trailer_Allowance__c, q.APPROVED_ACV__c,
                                q.Quote_Trailer_Allowance_Negotiation__c, q.Quote_Trailer_Allowance_Calculated__c, q.Quote_Trailer_ACV__c, q.Quote_Trailer_ACV_Negotiation__c, 
                                    q.Quote_Trade_Payoff__c, q.Quote_Trade_Allowance__c, q.Quote_Trade_Allowance_Negotiation__c, q.Transmission_Gearbox_SN__c, q.Quote_Trade_ACV__c,
                                        q.Quote_Trade_ACV_Negotiation__c, q.Quote_Total_Price_Calculated__c, q.Quote_Total_Over_Allowance_Calculated__c, q.Quote_Total_MSRP__c,
                                             q.Quote_Total_Amount_Financed_Calculated__c, q.Quote_To_Name__c, q.Quote_To_Address__c, q.Quote_Term__c, q.Quote_Sale_Price__c, q.ACV_FORM__c, 
                                                q.Quote_Rate__c, q.Quote_Payment__c, q.Quote_Payment_Negotiation__c, q.Quote_Number__c, q.Quote_Net_Selling_Price_Calculated__c, 
                                                    q.Quote_MSRP_Trailer_Price__c, q.Quote_MSRP_Trailer_Price_Negotiation__c, q.Quote_MSRP_Boat_Price__c, q.Quote_Down_Payment__c, 
                                                        q.Quote_Doc_Fee__c, q.Quote_Deal_Margin__c, q.Quote_Cost__c, q.Quote_Boat_Trade_Over_Allowance_Calculat__c, q.Mapped_HIN__c,
                                                            q.Quote_Boat_Sales_Tax_Negotiation__c, q.Quote_Boat_Sales_Tax_Calculated__c, q.Quote_Boat_Reg_Fee__c, q.Mapped_Engine_SN__c,
                                                                q.QuoteHiddenBox__c, q.Phone__c, q.OwnerId, q.NetSalesTax__c, q.Negotiation_Trailer_ACV__c, q.Mapped_Trailer_VIN__c,
                                                                    q.Negotiation_Trade_Payoff__c, q.Negotiation_MSRP_Boat_Price__c, q.Name, q.MSRP_Boat_Price_Negotiation__c,
                                                                         q.LastViewedDate, q.LastReferencedDate, q.LastModifiedDate, q.LastModifiedById, q.LastActivityDate, 
                                                                            q.IsDeleted, q.Id, q.Grand_Total__c, q.Fax__c, q.Expiration_Date__c, q.Email__c, q.Discount__c, q.Trailer__c,
                                                                                q.Discount_On_Quote__c, q.Description__c, q.CreatedDate, q.CreatedById, q.Contact_Name__c, q.Boat_Costline__c,
                                                                                     q.Boat_Sales_Tax2__c, q.Bill_To__c, q.Bill_To_Name__c, q.Test_2__r.Boat_Costline__c, 
                                                                                        q.Additional_To__c, q.Additional_To_Name__c, q.Account_Name__c, q.Test_2__c, 
                                                                                        q.Commission__c, q.Sales_Tax_County__c, q.Additional_Sales_Tax_Percent__c,
                                                                                        	q.Manual_Sales_Tax_Entry__c From BOATBUILDING__Quote__c q 
                                                                                            where id =:stdController.getId()  Limit 1];
    	
    	if(objQuote.BOATBUILDING__Commission_Stip__c != null)
    		 stip = objQuote.BOATBUILDING__Commission_Stip__c;
    	Profile p = [Select Id, Name From Profile Where Id =: UserInfo.getProfileId()];   
      	disStatus = '0';
      	if(p.Name.containsIgnoreCase('without') && p.Name.containsIgnoreCase('cost')) {
        	disStatus = '1'; 
      	}
      	
      	BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objQuote.BOATBUILDING__State__c);
        RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
        VehicleSalestax = objBoatBuilderUtil.getVehicleSalestax();
        CappingAmountForVehicleSalesTax = objBoatBuilderUtil.getCappingAmountForVehicleSalesTax();
    }
    
    @RemoteAction
     global static String save(Map<String , String> objmap) {
      BOATBUILDING__Quote__c objQuote2; 
      try{   
        objQuote2 = new BOATBUILDING__Quote__c();
       	objQuote2.Id = objmap.get('Id');
        if(objmap.get('tempName')!= null){
            if(String.valueOf(objmap.get('tempName')).contains('(')){
                objQuote2.Name = String.valueOf(objmap.get('tempName')).subString(0,String.valueOf(objmap.get('tempName')).indexOf('(')) + ' ('+ String.valueOf(Date.today())+')';
            }else{
                objQuote2.Name = objmap.get('tempName') + ' ('+ String.valueOf(Date.today())+')';
            }
        }
        if(objmap.get('ACVFORM')!= null && objmap.get('ACVFORM') != ''){
            objQuote2.ACV_FORM__c = objmap.get('ACVFORM');
        }
        if(objmap.get('relatedInv')!= null && objmap.get('relatedInv') != ''){
            objQuote2.Test_2__c = objmap.get('relatedInv');
        }
        if(objmap.get('accountName')!= null && objmap.get('accountName') != ''){
            objQuote2.Account_Name__c = objmap.get('accountName');
        }
        if(objmap.get('additionalTo')!= null){
            objQuote2.Additional_To__c = objmap.get('additionalTo');
        }
         if(objmap.get('quoteTotalMSRP')!= null){
            objQuote2.Quote_Total_MSRP__c = Decimal.valueOf(objmap.get('quoteTotalMSRP'));
        }
        if(objmap.get('additionalToName')!= null){
            objQuote2.Additional_To_Name__c = objmap.get('additionalToName');
        }
        if(objmap.get('billTo')!= null){
            objQuote2.Bill_To__c = objmap.get('billTo');
        }
        if(objmap.get('billToName')!= null){
            objQuote2.Bill_To_Name__c = objmap.get('billToName');
        }
        if(objmap.get('contactName')!= null && objmap.get('contactName')!= ''){
            objQuote2.Contact_Name__c = objmap.get('contactName');
        }
        if(objmap.get('descriptionTemp')!= null){
            objQuote2.Description__c = objmap.get('descriptionTemp');
        }
        if(objmap.get('discountTemp')!= null){
            objQuote2.Discount__c = Decimal.valueOf(objmap.get('discountTemp'));
        }
        if(objmap.get('emailTemp')!= null){
            objQuote2.Email__c = objmap.get('emailTemp');
        }
      
        if(objmap.get('faxTemp')!= null){
            objQuote2.Fax__c = objmap.get('faxTemp');
        }
        if(objmap.get('grandTotal')!= null){
            objQuote2.Grand_Total__c = Decimal.valueOf(objmap.get('grandTotal'));
        }
        if(objmap.get('phoneTemp')!= null){
            objQuote2.Phone__c = objmap.get('phoneTemp');
        }
        if(objmap.get('quoteToAddress')!= null){
            objQuote2.Quote_To_Address__c = objmap.get('quoteToAddress');
        }
        if(objmap.get('quoteToName')!= null){
            objQuote2.Quote_To_Name__c = objmap.get('quoteToName');
        }
        if(objmap.get('shippingAndHandling')!= null){
            objQuote2.Shipping_And_Handling__c = Decimal.valueOf(objmap.get('shippingAndHandling'));
        }
        if(objmap.get('shipTo')!= null){
            objQuote2.Ship_To__c = objmap.get('shipTo');
        }
        if(objmap.get('shipToName')!= null){
            objQuote2.Ship_To_Name__c = objmap.get('shipToName');
        }
        if(objmap.get('statusTemp')!= null){
            objQuote2.Status__c = objmap.get('statusTemp');
        }
        if(objmap.get('relatedToOrder')!= null && objmap.get('relatedToOrder') != ''){
            system.debug('DebugLog For : objmap.get(\'relatedToOrder\') '+ objmap.get('relatedToOrder'));
            objQuote2.Related_to_Order__c = String.valueOf(objmap.get('relatedToOrder'));
        }
        if(objmap.get('taxTemp')!= null){
            objQuote2.Tax__c = Decimal.valueOf(objmap.get('taxTemp'));
        }else{
            objQuote2.Tax__c = 0.00;
        }
        if(objmap.get('syncTemp')!= null){
            objQuote2.Syncing__c = Boolean.valueOf(objmap.get('syncTemp'));
        }
        if(objmap.get('YourPrice')!= null){
            objQuote2.Quote_Sale_Price__c = Decimal.valueOf(objmap.get('YourPrice'));
            
            
        }else{
            objQuote2.Quote_Sale_Price__c = 0.00;
        } 
        if(objmap.get('Payment')!= null){
            objQuote2.Quote_Payment__c = Decimal.valueOf(objmap.get('Payment'));
        }
        else
        {
            objQuote2.Quote_Payment__c = 0.00;
        }
        if(objmap.get('totalPriceQuote')!= null){
            System.debug('Debug Log For total price : '+Decimal.valueOf(objmap.get('totalPriceQuote')));
            objQuote2.Total_Price_Quote__c = Decimal.valueOf(objmap.get('totalPriceQuote'));
        }else{
            objQuote2.Total_Price_Quote__c = 0.00;
        }
        if(objmap.get('stateTemp')!= null){
            objQuote2.State__c = objmap.get('stateTemp');
        }
        
        if(objmap.get('trailer') != null && objmap.get('trailer') != ''){
            objQuote2.Trailer__c = objmap.get('trailer');
        }
        System.debug('Debug Log For objQuote2:'+ objQuote2 );
        if(objmap.get('Rate') != null && objmap.get('Rate') != '')
              objQuote2.Quote_Rate__c= Double.valueOf(objmap.get('Rate'));
        //objQuote2.Quote_Your_Price_Formula__c= Integer.valueOf(objmap.get('YourPrice')); 
        if(objmap.get('TradeAllowance') != null && objmap.get('TradeAllowance') != '')
            objQuote2.Quote_Trade_Allowance__c = Double.valueOf(objmap.get('TradeAllowance'));
        if(objmap.get('TrailerAllowance') != null && objmap.get('TrailerAllowance') != '')
            objQuote2.Quote_Trailer_Allowance__c = Double.valueOf(objmap.get('TrailerAllowance'));
        if(objmap.get('Discount') != null && objmap.get('Discount') != '')
            objQuote2.Discount_On_Quote__c= Double.valueOf(objmap.get('Discount'));
        if(objmap.get('msrpBoatPrice') != null && objmap.get('msrpBoatPrice') != '')
            objQuote2.Quote_MSRP_Boat_Price__c= Double.valueOf(objmap.get('msrpBoatPrice'));
        if(objmap.get('msrpTrailerPrice') != null && objmap.get('msrpTrailerPrice') != '')
            objQuote2.Quote_MSRP_Trailer_Price__c= Double.valueOf(objmap.get('msrpTrailerPrice'));
        if(objmap.get('TradeAllowance') != null && objmap.get('TradeAllowance') != '')
            objQuote2.Quote_Trade_Allowance__c = Double.valueOf(objmap.get('TradeAllowance'));
        if(objmap.get('TrailerAllowance') != null && objmap.get('TrailerAllowance') != '')
            objQuote2.Quote_Trailer_Allowance__c= Double.valueOf(objmap.get('TrailerAllowance'));
            
            
        if(objmap.get('Sales_Tax_County__c') != null && objmap.get('Sales_Tax_County__c') != '') 
            objQuote2.Sales_Tax_County__c= String.valueOf(objmap.get('Sales_Tax_County__c'));
        if(objmap.get('Additional_Sales_Tax_Percent__c') != null && objmap.get('Additional_Sales_Tax_Percent__c') != '')
            objQuote2.Additional_Sales_Tax_Percent__c= Double.valueOf(objmap.get('Additional_Sales_Tax_Percent__c'));
        if(objmap.get('Manual_Sales_Tax_Entry__c') != null && objmap.get('Manual_Sales_Tax_Entry__c') != '')
            objQuote2.Manual_Sales_Tax_Entry__c= Double.valueOf(objmap.get('Manual_Sales_Tax_Entry__c'));
            
            
            
        
        if(objmap.get('TrailerACV') != null && objmap.get('TrailerACV') != '')
            objQuote2.Quote_Trailer_ACV__c= Double.valueOf(objmap.get('TrailerACV'));
        if(objmap.get('TrailerSalesTax') != null && objmap.get('TrailerSalesTax') != '')
             objQuote2.Quote_Trailer_Sales_Tax__c= Double.valueOf(objmap.get('TrailerSalesTax'));
         if(objmap.get('BoatRegfee') != null && objmap.get('BoatRegfee') != '')
            objQuote2.Quote_Boat_Reg_Fee__c= Double.valueOf(objmap.get('BoatRegfee'));
        if(objmap.get('TrailerRegfee') != null && objmap.get('TrailerRegfee') != '')
            objQuote2.Quote_Trailer_Reg_Fee__c= Double.valueOf(objmap.get('TrailerRegfee'));
        if(objmap.get('Docfee') != null && objmap.get('Docfee') != '')
            objQuote2.Quote_Doc_Fee__c= Double.valueOf(objmap.get('Docfee'));
        if(objmap.get('Tradepayoff') != null && objmap.get('Tradepayoff') != '')
            objQuote2.Quote_Trade_Payoff__c= Double.valueOf(objmap.get('Tradepayoff'));
        if(objmap.get('Downpayment') != null && objmap.get('Downpayment') != '')
            objQuote2.Quote_Down_Payment__c= Double.valueOf(objmap.get('Downpayment'));
        
        if(objmap.get('cost') != null && objmap.get('cost') != ''){
            objQuote2.Quote_Cost__c= Double.valueOf(objmap.get('cost'));
        }
        if(objmap.get('dealMargin') != null && objmap.get('dealMargin') != ''){
            objQuote2.Quote_Deal_Margin__c= Double.valueOf(objmap.get('dealMargin'));
        }
        if(objmap.get('relatedToProduct') != null && objmap.get('relatedToProduct') != ''){
            objQuote2.Related_to_Product__c = objmap.get('relatedToProduct');
        }
        
        if(objmap.get('Term') != null && objmap.get('Term') != ''){
            objQuote2.Quote_Term__c = objmap.get('Term');
        }
        
        if(objmap.get('engineSN') != null && objmap.get('engineSN') != ''){
            objQuote2.Mapped_Engine_SN__c = objmap.get('engineSN');
        }
        if(objmap.get('hin') != null && objmap.get('hin') != ''){
            objQuote2.Mapped_HIN__c = objmap.get('hin');
        }
        if(objmap.get('trailerVIN') != null && objmap.get('trailerVIN') != ''){
            objQuote2.Mapped_Trailer_VIN__c = objmap.get('trailerVIN');
        }
        if(objmap.get('QuoteTrailer') != null && objmap.get('QuoteTrailer') != ''){
            objQuote2.Trailer__c = objmap.get('QuoteTrailer');
        }
        if(objmap.get('QuoteEngine') != null && objmap.get('QuoteEngine') != ''){
            objQuote2.Engine__c = objmap.get('QuoteEngine');
        }
        /* 
            if(objmap.get('boatLength') != null && objmap.get('boatLength') != ''){
                objQuote2.Mapped_Boat_Length__c = objmap.get('boatLength');
            }
        */
        if(objmap.get('Id') != null){
            List<BOATBUILDING__Quote__c> lstQuote = [Select Mapped_Boat_Length__c from BOATBUILDING__Quote__c Where Id =: objmap.get('Id') limit 1];
            if(lstQuote.size() > 0){
                objQuote2.Mapped_Boat_Length__c = lstQuote[0].Mapped_Boat_Length__c;
            }
        }
        if(objmap.get('tranGearSN') != null && objmap.get('tranGearSN') != ''){
            objQuote2.Transmission_Gearbox_SN__c = objmap.get('tranGearSN');
        }
                
        System.debug('Debug Log For objQuote2 : '+objQuote2);
        
        
         update objQuote2;
             /*List<BOATBUILDING__Quote_Line_Item__c> lstQLI = new List<BOATBUILDING__Quote_Line_Item__c>();
             if(objmap.get('lstQuoteLineItem') != null && objQuote2.id != null){
                System.debug('DebugLog For objmap.get(\'lstQuoteLineItem\'):' + objmap.get('lstQuoteLineItem'));
                Set<String> setQliId = new Set<String>();
                String []strTemp = String.valueOf(objmap.get('lstQuoteLineItem')).split(',');
                for(String objQliId : strTemp){
                    setQliId.add(objQliId);
                } 
                for(BOATBUILDING__Quote_Line_Item__c objQLI : [Select Id, Name__c, Total_Price__c,Option_Category__c, Quote__c, Product__c, Product_Code__c, Name, Date__c, Dealer_Price__c From BOATBUILDING__Quote_Line_Item__c WHERE Quote__c =: objmap.get('Id')]){
                    for(String str : setQliId){
                        if(str.containsIgnoreCase(objQLI.Id) || string.valueOf(objQLI.Id).containsIgnoreCase(str)){
                            BOATBUILDING__Quote_Line_Item__c qli = new BOATBUILDING__Quote_Line_Item__c();
                            qli.Name__c = objQli.Name__c; 
                            qli.Name = 'QLI';  
                            qli.Dealer_Price__c = objQli.Dealer_Price__c;
                            qli.Date__c = Date.today();
                            qli.Product__c = objQLI.Product__c;
                            qli.Option_Category__c = objQLI.Option_Category__c;
                            qli.Product_Code__c = objQLI.Product_Code__c;
                            qli.Quote__c = objQuote2.id;
                            qli.Total_Price__c = objQLI.Total_Price__c;
                            lstQLI.add(qli);
                        }
                    }
                }
                
                try{
                    insert lstQLI;
                }catch(Exception ex){
                    System.debug('Debug Log For Catch : '+ex);
                }
             }*/
           
             
            return objQuote2.id;
             
           }catch(Exception ex){
              System.debug('_________Catch___'+ex);
              System.debug('_________Catch___'+ex.getLineNumber());
              return 'error: '+ex+' : '+ex.getLineNumber();
           }
       // String s = objQuote2.id;
        
    }
}