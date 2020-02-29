public class QuotePDFLayoutController {
    public Quote__c objQuote2 { get; set; }
    public String width { get; set; }
    public BOATBUILDING__Store_Location_Config__mdt objSLC1 { get; set; }   
    public BOATBUILDING__Store_Location_Config__mdt objSLC2 { get; set; }
    public BOATBUILDING__Product__c objProduct { get; set; }
    public String website { get; set; }
    public String CompanyBanner { get; set; }
    public String yearForQuotePDF { get; set; }
    public String getManufacturerName {get;set;}
    public String modelForQuotePDF { get; set; }
    public String modelVarForQuotePDF { get; set; }   
    public String quoteImg1 { get; set; }
    public String quoteImg2 { get; set; }
    public boolean TrailerInfoQuote { get ; set; }
    public boolean EngineInfoQuote { get ; set; }  
    public string BoatDis{get; set;}
    public Boolean checkBoxExist { get; set; }
    public Account objAccount { get; set; } 
    public List<QuoteOptionCatagoryWrapper> lstQuoteOptionCatagoryWrapper { get; set; }
    
    public List<QuoteOptionCatagoryWrapper> lstQLIDis1 { get; set; }
    public List<QuoteOptionCatagoryWrapper> lstQLIDis2 { get; set; }
     
    public QuotePDFLayoutController(ApexPages.StandardController stdController) {
        lstQLIDis1 = new List<QuoteOptionCatagoryWrapper>();
        lstQLIDis2 = new List<QuoteOptionCatagoryWrapper>();
        lstQuoteOptionCatagoryWrapper = new List<QuoteOptionCatagoryWrapper>();
        BOATBUILDING__System_Configure__c objSCC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        if(objSCC != null && objSCC.BOATBUILDING__Quote_Pdf_Width__c != null) {
            width = String.valueOf(objSCC.BOATBUILDING__Quote_Pdf_Width__c);
        }
        
        objSLC1 = new BOATBUILDING__Store_Location_Config__mdt();
        objSLC2 = new BOATBUILDING__Store_Location_Config__mdt();
        website = '';
        CompanyBanner = '';
        List<Document> lstDocBanner = [SELECT Id FROM Document WHERE DeveloperName = 'VFTemplateLogoBlack'];
        if(!lstDocBanner.isEmpty()) {
            CompanyBanner = lstDocBanner[0].Id;
        }
        Map<String, BOATBUILDING__Template_WhyBuyFromUS__c> mpTWBFS = BOATBUILDING__Template_WhyBuyFromUS__c.getAll();
        if(mpTWBFS != null && mpTWBFS.keySet().size() > 0) {
            website = mpTWBFS.values()[0].BOATBUILDING__Company_Website__c;
        }
        objQuote2 = [SELECT 
                     q.Engine__c, q.Trailer__c, q.Engine__r.Total_MSRP_Price__c, q.Engine__r.Manufacturer__c, ACV_FORM__r.BOATBUILDING__Account__r.BOATBUILDING__Trade_Lien_Bank__c,
                     ACV_FORM__r.BOATBUILDING__Account__r.BOATBUILDING__Trade_Pay_Off__c, 
                     q.Engine__r.Model__c, q.Engine__r.Year__c, q.Engine__r.Engine_SN__c, q.Engine__r.Serial_Number_2__c,
                     q.Engine__r.Transmission_Gearbox_SN__c, q.Trailer__r.Total_MSRP_Price__c, q.Trailer__r.Manufacturer__c,
                     q.Trailer__r.Model__c, q.Trailer__r.Year__c, q.Trailer__r.Trailer_Axles__c, q.Trailer__r.Trailer_VIN__c,
                     q.Tyre_Tax__c, Account_Name__r.BOATBUILDING__Trade_Lien_Bank__c, Account_Name__r.BOATBUILDING__Trade_Pay_Off__c, 
                     q.Show_MSRP_Option_Pricing__c, q.State__c, q.Tax__c, q.Syncing__c, q.Account_Name__r.Name, 
                     Contact_Name__r.Name, q.Test_2__r.Name,q.Test_2__r.Engine_Make__c, q.Test_2__r.Engine_Year__c, 
                     q.Test_2__r.Engine_Model__c, q.Test_2__r.Serial_Number_2__c , Q.Test_2__r.BOATBUILDING__Engine_SN__c,
                     q.Status__c,q.Quote_Total_Price_Calculated__c , q.Shipping_And_Handling__c, q.Ship_To__c, 
                     q.Ship_To_Name__c, q.Related_to_Order__c,q.Discount_On_Quote__c, q.Related_to_Product__c, 
                     q.Test_2__r.Trailer_Make__c,q.Test_2__r.Trailer_Model__c,q.Test_2__r.Trailer_VIN__c,
                     q.Test_2__r.Trailer_Year__c, q.Quote_Trailer_Sales_Tax__c, q.Quote_Trailer_Reg_Fee__c,
                     q.Mapped_Boat_Length__c, q.Mapped_Engine_SN__c, q.Mapped_HIN__c, q.Mapped_Trailer_VIN__c, 
                     q.Transmission_Gearbox_SN__c,q.Dealer_Comments_and_Notes__c, q.Test_2__r.Trailer_Axles__c, 
                     q.Test_2__r.Transmission_Gearbox_SN__c, q.Quote_Trailer_Allowance__c,q.Quote_Your_Price_Formula__c, 
                     q.Quote_Total_Over_Allowance_Calculated__c, q.Quote_Net_Selling_Price_Calculated__c ,
                     q.Boat_Sales_Tax2__c ,q.Quote_Trailer_ACV__c, q.Quote_Trade_Payoff__c, q.Quote_Trade_Allowance__c,
                     q.Quote_Total_Amount_Financed_Calculated__c, q.Quote_To_Name__c, q.Quote_To_Address__c, 
                     q.Quote_Trade_ACV__c,CO_Buyer_Name__r.Name, CO_Buyer_Name__c,  CO_Buyer_Name__r.MailingCity,
                     q.Quote_Term__c, q.Quote_Rate__c, q.Quote_Payment__c,q.Total_Price_Quote__c, q.Quote_Number__c,
                     q.Quote_MSRP_Trailer_Price__c, q.Quote_MSRP_Boat_Price__c, q.Quote_Down_Payment__c, q.Quote_Doc_Fee__c,
                     q.Quote_Deal_Margin__c, q.Quote_Cost_Clone__c, q.Test_2__c, q.Quote_Total_MSRP__c , 
                     q.Quote_Boat_Reg_Fee__c,q.Dealer_Disclaimer__c, q.ACV_FORM__r.Boat_Make__c, q.ACV_FORM__r.Boat_Model__c,
                     q.ACV_FORM__r.Boat_Year__c, q.ACV_FORM__r.Boat_HIN__c, q.ACV_FORM__r.Engine_SN__c, 
                     q.ACV_FORM__r.BOATBUILDING__Trailer_Axles__c, q.ACV_FORM__r.BOATBUILDING__Trailer_Make__c, 
                     q.ACV_FORM__r.BOATBUILDING__Trailer_Model__c, q.Phone__c, q.OwnerId,q.Quote_Sale_Price__c, 
                     q.Name,q.ACV_FORM__r.BOATBUILDING__Trailer_Vin__c, q.ACV_FORM__r.BOATBUILDING__Engine_Model__c,
                     q.LastActivityDate, q.IsDeleted, q.Id, q.Grand_Total__c,  q.Fax__c, q.Expiration_Date__c, 
                     q.Email__c, q.No_Trailer__c, q.Discount__c, q.Description__c,q.CreatedDate, q.CreatedById, 
                     q.Contact_Name__c, q.Bill_To__c, q.Bill_To_Name__c, q.Additional_To__c, Store_Location__c, 
                     q.Additional_To_Name__c, q.Account_Name__c,
                     (SELECT Id, Name, CreatedDate, CreatedById, Date__c, Discount__c, Line_Item_Description__c, 
                      List_Price__c, Product__c, Product_Code__c, Quantity__c,
                      Quote__c, Sales_Price__c, Sub_Total__c, Total_Price__c, Option_Category__c, Name__c 
                      FROM BOATBUILDING__Quote_Line_Item__r) FROM BOATBUILDING__Quote__c q WHERE
                     q.Id =:ApexPages.currentPage().getParameters().get('Id')];
        
        if(objQuote2.Trailer__c != null) {
            TrailerInfoQuote = true;
        }
        
        if(objQuote2.Engine__c != null) {
            EngineInfoQuote = true;
        }
        Inventory__c objInventory2 = new Inventory__c();
        if(objQuote2.Related_to_Product__c != null){
            objProduct = [Select M_Year__c, M_Hidden_Box__c,Boat_Length_in_feets__c,M_Dealer_Base_Price__c,Hull_Id__c,Engine_SN__c,Trailer_VIN__c,Transmission_Gearbox_SN__c,M_Model_Variant__c , Product_Manufacturer__c, Product_Manufacturer__r.Name ,MModel2__c,M_Boat_MSRP_PRICE__c,M_Manufacture_Status__c,M_Dealer_Status__c From Product__c where id =:  objQuote2.Related_to_Product__c];
            if(objProduct.Id != null) {
                getManufacturerName =  objProduct.Product_Manufacturer__r.Name;
                if(objProduct.M_Year__c != null) yearForQuotePDF = objProduct.M_Year__c;
                if(objProduct.MModel2__c != null) modelForQuotePDF = objProduct.MModel2__c;
                if(objProduct.M_Model_Variant__c != null) modelVarForQuotePDF = objProduct.M_Model_Variant__c;
            }
        }
        else if(objQuote2.Test_2__c != null) {
            if(objInventory2.Id == null || objInventory2.Id == '') {
                objInventory2 = [SELECT Manufacturer__c, Year__c, Model__c, Model_Variant__c FROM BOATBUILDING__Inventory__c WHERE Id =: objQuote2.Test_2__c LIMIT 1];
            }
            if(objInventory2.Id != null) {
                if(objInventory2.Manufacturer__c != null) getManufacturerName =  objInventory2.Manufacturer__c;
                if(objInventory2.Year__c != null) yearForQuotePDF = objInventory2.Year__c;
                if(objInventory2.Model__c != null) modelForQuotePDF = objInventory2.Model__c;
                if(objInventory2.Model_Variant__c != null) modelVarForQuotePDF = objInventory2.Model_Variant__c;
            }
        } 
        if(objQuote2.Test_2__c != null){
	        List<Attachment> att = [Select Id, Name From Attachment Where ParentId =: objQuote2.Test_2__c];
	        if(att.size() > 0) {
	            for(Attachment objAttt: att) {
	                if(objAttt.Name.containsIgnoreCase('side__c')) {
	                    quoteImg1 = objAttt.Id;
	                }
	                if(objAttt.Name.containsIgnoreCase('bow__c')) {
	                    quoteImg2 = objAttt.Id;
	                } 
	            }
	        }
	    }
        if(objQuote2.Account_Name__c != null){
            objAccount = [Select a.Year__c, a.Work_Phone__c,a.Do_they_have_a_trade__c ,a.Desire_Price_low__c ,a.Desire_price_high__c ,a.Prospect_Desired_Boat_Length__c ,a.Desire_boat_model__c , a.Website, a.URI__c, a.Type, a.Telephone__c,a.Desired_Boat_Manufacturer__c , 
                          a.ShippingPostalCode, a.ShippingLongitude, a.ShippingLatitude, a.ShippingGeocodeAccuracy, a.ShippingCountry, a.ShippingCity, 
                          a.ShippingAddress, a.Sale_Class__c, a.Request_Type__c, a.RecordTypeId, a.Price__c, a.PhotoUrl, a.Phone,
                          a.ParentId, a.OwnerId, a.NumberOfEmployees, a.NewsletterOptIn__c, a.Name, a.Model__c, a.MasterRecordId, a.Make__c, 
                          a.Lead_Status__c,a.Lead_Source__c, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, 
                          a.LastActivityDate, a.JigsawCompanyId, a.Jigsaw, a.IsDeleted, a.Industry, a.Id, a.IMT_ID__c, a.Formpage__c, 
                          a.Fax, a.Email__c, a.Description, a.Date_Time__c, a.CreatedDate, a.CreatedById, a.Comments__c, 
                          a.Catalog__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingLongitude, a.BillingLatitude, a.BillingGeocodeAccuracy, 
                          a.BillingCountry, a.BillingCity, a.BillingAddress, a.AnnualRevenue, a.AccountSource From Account a where Id =: objQuote2.Account_Name__c limit 1];
        }
        
        List<BOATBUILDING__Store_Location_Config__mdt> lstSLC = [SELECT 
                                                                 Id, MasterLabel, DeveloperName, BOATBUILDING__Street__c, BOATBUILDING__Phone__c,
                                                                 BOATBUILDING__City__c, BOATBUILDING__State__c, BOATBUILDING__Country__c, 
                                                                 BOATBUILDING__Zip_Postal_Code__c, BOATBUILDING__Priority__c 
                                                                 FROM    
                                                                 BOATBUILDING__Store_Location_Config__mdt 
                                                                 Order BY 
                                                                 BOATBUILDING__Priority__c ASC];
        if(!lstSLC.isEmpty()) {
            objSLC1 = lstSLC[0];
            if(String.isNotBlank(objSLC1.City__c)) {
                objSLC1.City__c += ',';
            }
            if(String.isNotBlank(objSLC1.State__c)) {
                objSLC1.State__c += ',';
            }
            if(lstSLC.size() > 1) {
                objSLC2 = lstSLC[1];
                if(String.isNotBlank(objSLC2.City__c)) {
                    objSLC2.City__c += ',';
                }
                if(String.isNotBlank(objSLC2.State__c)) {
                    objSLC2.State__c += ',';
                }
            }
        }
        Map<String, List<Quote_Line_Item__c>> mapQuoteLineItem = new Map<String, List<Quote_Line_Item__c>>();
        Map<String, List<Quote_Line_Item__c>> mapQuoteLineItem1 = new Map<String, List<Quote_Line_Item__c>>();
        
        if(objQuote2.BOATBUILDING__Quote_Line_Item__r != null && objQuote2.BOATBUILDING__Quote_Line_Item__r.size() > 0) {
            for(BOATBUILDING__Quote_Line_Item__c objQLI2 :  objQuote2.BOATBUILDING__Quote_Line_Item__r) {
                if(!mapQuoteLineItem.containsKey(objQLI2.Option_Category__c)){
                    mapQuoteLineItem.put(objQLI2.Option_Category__c, new List<Quote_Line_Item__c>());
                }
                if(mapQuoteLineItem.containsKey(objQLI2.Option_Category__c)) {
                    mapQuoteLineItem.get(objQLI2.Option_Category__c).add(objQLI2);
                }
            } 
            for(String srtQuoteMapKeys : mapQuoteLineItem.keySet()) {
                lstQuoteOptionCatagoryWrapper.add(new QuoteOptionCatagoryWrapper(srtQuoteMapKeys, mapQuoteLineItem.get(srtQuoteMapKeys) ));
            }
            
            //New Change
            for(Integer i = 0; i < objQuote2.BOATBUILDING__Quote_Line_Item__r.size(); i++) {
                if(!mapQuoteLineItem1.containsKey(objQuote2.BOATBUILDING__Quote_Line_Item__r[i].Option_Category__c)){   
                    mapQuoteLineItem1.put(objQuote2.BOATBUILDING__Quote_Line_Item__r[i].Option_Category__c, new List<Quote_Line_Item__c>());
                }
                if(mapQuoteLineItem1.containsKey(objQuote2.BOATBUILDING__Quote_Line_Item__r[i].Option_Category__c)) {
                    mapQuoteLineItem1.get(objQuote2.BOATBUILDING__Quote_Line_Item__r[i].Option_Category__c).add(objQuote2.BOATBUILDING__Quote_Line_Item__r[i]);
                }
            }
            Integer ModVal = Math.mod(mapQuoteLineItem1.keySet().size(), 2);
            Integer MidVal = Integer.valueOf(mapQuoteLineItem1.keySet().size()/2);
            
            if(mapQuoteLineItem1.keySet().size() == 1) {
                for(String srtQuoteMapKeys : mapQuoteLineItem1.keySet()) {
                    lstQLIDis1.add(new QuoteOptionCatagoryWrapper(srtQuoteMapKeys, mapQuoteLineItem1.get(srtQuoteMapKeys) ));
                }
            } else if(mapQuoteLineItem1.keySet().size() > 1) {
                List<String> lstString = new List<String>(); 
                for(String srtQuoteMapKeys : mapQuoteLineItem1.keySet()) {
                    lstString.add(srtQuoteMapKeys);
                }
                System.debug('>>>: '+mapQuoteLineItem1);
                System.debug('>>>: '+mapQuoteLineItem1.size());
                if(ModVal == 1) {
                    for(Integer i = 0; i <= MidVal; i++) {
                        lstQLIDis1.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                    }
                    for(Integer i = MidVal + 1; i < lstString.size(); i++) { 
                        lstQLIDis2.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                    }
                }
                else if(ModVal == 0) {
                    for(Integer i = 0; i < MidVal; i++) {
                        lstQLIDis1.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                    }
                    for(Integer i = MidVal; i < lstString.size(); i++) {
                    	lstQLIDis2.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                    }
                }
                
            }
            
        }
        
    }
    public class QuoteOptionCatagoryWrapper {
        public String strOptionCategory { get; set; }
        public List<Quote_line_Item__c> lstSelectedOptionCategory { get; set; }
        public List<Decimal> lstPrice { get; set; }
        public QuoteOptionCatagoryWrapper (String strOptionCategory, List<Quote_line_Item__c> lstSelectedOptionCategory) {
            this.strOptionCategory = strOptionCategory;
            this.lstSelectedOptionCategory = lstSelectedOptionCategory;
        }
    }
}