/**
* Author:              Akshay Kumar
* Organization:        CloudCodiots LLP.
* Created Date:        21/10/2016
* Last Modified Date:  22/03/2018
* To be modified
*/
public class BoatBuilderController {
    public Boolean isSideContent { get; set; }
    public Boolean isBowContent { get; set; }
    public Boolean isCanadian { get; set; }
    public Boolean isCanadianCurrency {get; set;}
    private String emailDebugBody = '';
    public List<SelectOption> setModelVariant { get; set; }
    
    public String selectedModelVariant { get; set; }
    
    public Boolean noTrailer { get; set; }
    
    public Boolean checkCustomer { get; set; }
    public Boolean checkCoBuyer { get; set; }
    
    public Boolean checkBoxExist { get; set; }
    public Boolean showPopup { get; set; }
    
    public List<SelectOption> setModel { get; set; }
    public List<SelectOption> setYear { get; set; } 
    public List<SelectOption>lstManufacture { get; set; }
    public List<SelectOption>lstManufacturepop { get; set; }
    public List<BOATBUILDING__Quote_Line_Item__c> lstQuoteLineItem;
    public List<BOATBUILDING__Quote_Line_Item__c> lstQuoteLineItem1;
    
    
    
    public List<BOATBUILDING__Inventory_Line_Item__c> lstInventoryLineItem;
    public BOATBUILDING__Product__c objProduct { get; set; }
    public BOATBUILDING__Product__c objProductpop { get; set; }
    public BOATBUILDING__Item__c objItem { get; set; }
    public BOATBUILDING__Order__c objOrder { get; set; } 
    public Contact objContact { get; set; }
    public Account objAccount { get; set; } 
    public BOATBUILDING__Quote__c objQuote { get; set; }
    public BOATBUILDING__Quote__c objQuote2 { get; set; }
    public BOATBUILDING__Quote__c objQuote3 { get; set; }
    public String yearForQuotePDF { get; set; }
    public String modelForQuotePDF { get; set; }
    public String modelVarForQuotePDF { get; set; }
    
    public BOATBUILDING__Inventory__c objInventory { get; set; }
    public BOATBUILDING__Inventory__c objInventory2 { get; set; }
    
    String myAttchId;
    public Boolean pcCheckDis { get; set; }
    
    public List<String> lstSelectedCategory;
    public Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory;
    public Map<String , List<CheckBoxWraper>> mapCheckBoxWraper;
    public List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass { get; set; }
    
    public List<DealerOptionWraper> lstDealerOptionWraper { get; set; } 
    
    public List<String> lstKeySet { get; set; }
    public String objCustomerName { get; set; }
    public String selectedModel { get; set; }
    public String selectedYear { get; set; }
    public String selectedManufacture { get; set; }
    public String selectedManufacturepop { get; set; }
    String strSupraName = '';
    Set<String> setModelV;
    
    public String selectedManufacturerSecondPage { get; set; }
    public String selectedYearSecondPage { get; set; }
    public String selectedModelSecondPage { get; set; }
    public String getManufacturerName {get;set;}
    
    public String selectedManufacturerThirdPage { get; set; }
    public String selectedYearThirdPage { get; set; }
    public String selectedModelThirdPage { get; set; }
    public String selectedProductDCId { get; set; }
    public Decimal yourPriceThirdPageForProductPrice { get; set; }
    public Decimal yourPriceThirdPageForProductPriceDealer { get; set; }
    
    public String manufacturerStatus { get; set; }
    public String dealerStatus { get; set; }
    public String rowNumber { get; set; }
    public String selectedOptionString { get; set; }
    public String selectedOptionCategory { get; set; }
    public String dealerPartNumber { get; set; } 
    
    
    public Decimal MfgOptTota { get; set; }
    public Decimal MfgOptDealerTota { get; set; }
    public Decimal totalPrice { get; set; }
    public Decimal totalPriceDealer { get; set; }
    public Decimal tradInValue { get; set; }
    public Decimal trailerPrice { get; set; }
    public Decimal totalRetailPrice { get; set; }
    public Decimal calculateOptionsPrice {get; set; }
    public String smVrnt { get; set; }
    public Decimal dealerOptionTotal { get; set; }
    public Decimal dealerOptionCostTotal { get; set; }

    public Decimal cwoRetailTotal { get; set; }
    public Decimal cwoDealerTotal { get; set; }

    Decimal tempFreight = 0.00;
    Decimal tempPrep = 0.00;
    Decimal tempCustom = 0.00;
    
    public String discountInPC { get; set; }
    public Boolean nameCheck { get; set; }
    Integer tempdiscountInPC;
    private Boolean yearAdding;
    private Boolean isError;
    
    
    public Boolean buttonRenderForPlaceOrder { get; set; }
    public Boolean buttonRenderForSaveAndReCal { get; set; } 
    public Boolean buttonRenderForCustomerDetail {get;set;}
    
    public String strDocId { get; set; }
    public Boolean modelVarientFlag { get; set; }
    public List<QuoteOptionCatagoryWrapper> lstQuoteOptionCatagoryWrapper { get; set; }
    
    public List<QuoteOptionCatagoryWrapper> lstQLIDis1 { get; set; }
    public List<QuoteOptionCatagoryWrapper> lstQLIDis2 { get; set; }
    
    
    public Boolean InvUpdateStatus { get; set; }
    public String decDO { get; set; }
    public String retDO { get; set; }
    public String delDO { get; set; }
    public String pnDO { get; set; } 
    public String tcDo { get; set; }
    public String qtDo { get; set; }
    
    public String selectedType { get; set; }
    public List<SelectOption> lstType { get; set; }
    
    public Decimal QuoteTrailerPrice { get; set; }
    public Decimal QuoteEnginePrice { get; set; } 
    
    public boolean TrailerInfo { get; set; }
    public boolean EngineInfo { get; set; }
    
    public boolean TrailerInfoQuote { get ; set; }
    public boolean EngineInfoQuote { get ; set; }
    
    public String QuoteDisclaimer { get; set; }
    
    public Product__c objNewProduct { get; set; }
    public String ST { get; set; }

    public List<WritinCustomOption> lstWritinCustomOption { get; set; }


    Set<String> setcodeId = new Set<String>();
    Map<String, Decimal> mapCodeQuantity = new Map<String, Decimal>();
    public PageReference checkAccess() {
        String strAccessKey = '';
        if(!Test.isRunningTest()) {
            strAccessKey = AccessControllCheck.ckeckAccess();
        } else {
            strAccessKey = 'Sales';
        }
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public String ManuName { get; set; }
    
    public BoatBuilderController(ApexPages.StandardController stdController) {
        generateQuoteFromPrint();
    }
    public BoatBuilderController(){
        
        
        try {
            if(UserInfo.isMultiCurrencyOrganization()){
                isCanadianCurrency = true;
            }else{
                isCanadianCurrency = false;
            }
            //isCanadianCurrency = true;
            //isCanadianCurrency = true; // for testing
            isSideContent = false;
            isBowContent = false;
            isCanadian = false;
            cwoRetailTotal = 0.00;
            cwoDealerTotal = 0.00; 
            lstWritinCustomOption = new List<WritinCustomOption>();
            objNewProduct = new Product__c();
            QuoteDisclaimer = '';
            BOATBUILDING__System_Configure__c objSCC = BOATBUILDING__System_Configure__c.getOrgDefaults();
            
            if(objSCC != null) {
                if(objSCC.BOATBUILDING__Quote_Disclaimer__c != null) 
                    QuoteDisclaimer = objSCC.BOATBUILDING__Quote_Disclaimer__c;
            } 
            
            TrailerInfo = false;
            EngineInfo = false;
            
            TrailerInfoQuote = false;
            EngineInfoQuote = false;
            
            QuoteTrailerPrice = 0.00;
            QuoteEnginePrice = 0.00;
            selectedType = '0';
            lstType = new List<SelectOption>();
            
            decDO = '';
            retDO = '0.00';
            delDO = '0.00';
            pnDO = '';
            tcDo = '';
            qtDo = '1';
            InvUpdateStatus = false;
            ST = '0';
            showPopup = false;
            noTrailer = false;
            modelVarientFlag = false;
            strDocId = '';
            dealerPartNumber = '';
            dealerOptionTotal = 0.00;
            calculateOptionsPrice = 0.00;
            myAttchId = '';
            MfgOptTota = 0.00;
            MfgOptDealerTota = 0.00;
            totalPrice = 0.00;
            totalPriceDealer = 0.00;
            tradInValue = 0.00;
            trailerPrice = 0.00;
            discountInPC = '0';
            tempdiscountInPC = 0;
            totalRetailPrice = 0.00;
            smVrnt = '';
            yourPriceThirdPageForProductPrice = 0.00;
            yourPriceThirdPageForProductPriceDealer = 0.00;
            dealerOptionCostTotal = 0.00;
            pcCheckDis = false;
            isError = false;
            selectedManufacturepop = '';
            lstManufacture = new List<SelectOption>();
            lstManufacturepop = new List<SelectOption>();
            setYear = new List<SelectOption>(); 
            setModel = new List<SelectOption>(); 
            lstSelectedCategory = new List<String>();
            setModelVariant = new List<SelectOption>(); 
            lstQuoteLineItem = new List<BOATBUILDING__Quote_Line_Item__c>();
            lstQuoteLineItem1 = new List<BOATBUILDING__Quote_Line_Item__c>();
            lstQLIDis1 = new List<QuoteOptionCatagoryWrapper>();
            lstQLIDis2 = new List<QuoteOptionCatagoryWrapper>();
            objItem = new BOATBUILDING__Item__c();
            objOrder = new BOATBUILDING__Order__c();
            objContact = new Contact(); 
            objAccount = new Account();
            objQuote = new BOATBUILDING__Quote__c();
            objQuote2 = new BOATBUILDING__Quote__c();
            objQuote3 = new BOATBUILDING__Quote__c();
            objInventory = new BOATBUILDING__Inventory__c();
            lstInventoryLineItem = new List<BOATBUILDING__Inventory_Line_Item__c>();
            objInventory2 = new BOATBUILDING__Inventory__c();
            objProduct = new BOATBUILDING__Product__c();
            objProductpop = new BOATBUILDING__Product__c();
            checkBoxExist = true;
            setModelV = new Set<String>();
            nameCheck = false;
            mapCheckBoxWraper = new  Map<String , List<CheckBoxWraper>>();  
            lstDealerOptionWraper = new List<DealerOptionWraper>();
            lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
            lstQuoteOptionCatagoryWrapper = new List<QuoteOptionCatagoryWrapper>();
            //Manufacturer 
            lstManufacture.add(new SelectOption('', '--None--'));
            
            
            lstType.add(new SelectOption('0', '--None--'));
            lstType.add(new SelectOption('New Boat', 'New Boat'));
            lstType.add(new SelectOption('Trailer', 'Trailer'));
            lstType.add(new SelectOption('Engine', 'Engine')); 
            lstType.add(new SelectOption('Used Boat', 'Used Boat'));
            if(ApexPages.currentPage().getParameters().get('SelectedType') != null ) {
                selectedType = ApexPages.currentPage().getParameters().get('SelectedType');
                getManufacturer();
            } 
            //year
            //setYear.add(new SelectOption('', '--None--'));
            yearAdding = true;
            
            //Model
            setModel.add(new SelectOption('', '--None--'));
            
            //Model V
            setModelVariant.add(new SelectOption('', '--None--'));
            
            
            if(ApexPages.currentPage().getParameters().get('Id') != null){
                
                generateQuoteFromPrint();
            }
            
            Set<String> selectedOptionsforInventory = new Set<String>();
            
            if(ApexPages.currentPage().getParameters().get('invId') != null) {
                objQuote.Test_2__c = ApexPages.currentPage().getParameters().get('invId');
                buttonRenderForCustomerDetail =true;
                buttonRenderForSaveAndReCal = true;
                buttonRenderForPlaceOrder = false;
                objInventory2 = [Select     i.Transmission_Gearbox_SN__c, i.Year__c,  i.Trailer_VIN__c, i.Boat_Length_in_feets__c,  i.SystemModstamp,  i.Stage__c,  i.Part_Number__c,  i.Total_Dealer_Price__c, i.OwnerId, 
                                            i.Hull_ID__c, i.Name,  i.Model__c,  i.Model_Variant__c,  i.Manufacturer__c,  i.Location__c,  i.LastViewedDate,  i.RecordTypeId, i.LastReferencedDate,  i.LastModifiedDate, 
                                            i.LastModifiedById,  i.LastActivityDate,  i.IsDeleted,  i.Interest_Start_Date__c, i.Id,  i.HIN_Number__c,  i.Engine_SN__c, i.Dealer__c,  i.Dealer_Stock__c,  i.Dealer_Status__c,  
                                            i.Cost__c, i.Dealer_Flat_Discount__c,  i.Dealer_Discount__c,  i.Dealer_Comments__c,  i.Dealer_COD_Discount__c,  i.Dealer_Base_Price__c, i.Days_on_Lot__c,  i.Date_First_on_Sales_Lot__c, 
                                            i.Curtailment_Start_Date__c,  i.CreatedDate,  i.CreatedById,  i.Suggested_List_Price__c,  i.RecordType.Name, i.BOATBUILDING__Engine_1_SN__c, i.BOATBUILDING__Engine_2_SN__c,
                                            i.BOATBUILDING__Engine_3_SN__c, i.BOATBUILDING__Engine_4_SN__c, 
                                            (
                                                 Select  Id,  IsDeleted,  Name,  Name__c, Related_to_Inventory__c,  Item_Description__c,  Discount__c, Dealer_Price__c,  Option_Category__c, Price__c,  Product_Code__c, 
                                                        Quantity__c, Non_Taxable__c, BOATBUILDING__Total_Retail_Price__c, BOATBUILDING__Total_Dealer_Price__c  From    BOATBUILDING__Inventory_Line_Items__r
                                            )
                                From  BOATBUILDING__Inventory__c i  where  Id=: ApexPages.currentPage().getParameters().get('invId')];

                
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                    for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                        mapCodeQuantity.put(objInventoryLineItem.Product_Code__c, objInventoryLineItem.Quantity__c);
                        setcodeId.add(objInventoryLineItem.Product_Code__c);
                        lstInventoryLineItem.add(objInventoryLineItem);
                        if(objInventoryLineItem.BOATBUILDING__Option_Category__c == 'CWO') {
                            lstWritinCustomOption.add(new WritinCustomOption(true, 
                                                                                    objInventoryLineItem.BOATBUILDING__Name__c, 
                                                                                    objInventoryLineItem.BOATBUILDING__Quantity__c, 
                                                                                    objInventoryLineItem.BOATBUILDING__Price__c, 
                                                                                    objInventoryLineItem.BOATBUILDING__Dealer_Price__c, 
                                                                                    objInventoryLineItem.BOATBUILDING__Product_Code__c, 
                                                                                    objInventoryLineItem.BOATBUILDING__Non_Taxable__c));
                            cwoRetailTotal += objInventoryLineItem.BOATBUILDING__Total_Retail_Price__c;
                            cwoDealerTotal += objInventoryLineItem.BOATBUILDING__Total_Dealer_Price__c;

                            BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                            objQLI.Option_Category__c = 'CWO';
                            objQLI.Name = 'QLI'; 
                            if(objInventoryLineItem.BOATBUILDING__Name__c != null){
                                objQLI.Name__c = objInventoryLineItem.BOATBUILDING__Name__c;
                            }
                            if(objInventoryLineItem.BOATBUILDING__Price__c != null){
                                objQLI.Total_Price__c = objInventoryLineItem.BOATBUILDING__Price__c;
                            }
                            if(objInventoryLineItem.BOATBUILDING__Dealer_Price__c != null){
                                objQLI.Dealer_Price__c = objInventoryLineItem.BOATBUILDING__Dealer_Price__c;
                            }
                            objQLI.Date__c =  Date.today(); 
                            if(objInventoryLineItem.BOATBUILDING__Product_Code__c != null){
                                objQLI.Product_Code__c = objInventoryLineItem.BOATBUILDING__Product_Code__c;
                            }
                            if(objInventoryLineItem.BOATBUILDING__Quantity__c != null){
                                objQLI.Quantity__c = objInventoryLineItem.BOATBUILDING__Quantity__c;
                            }
                            objQLI.Non_Taxable__c = objInventoryLineItem.BOATBUILDING__Non_Taxable__c;
                            lstQuoteLineItem.add(objQLI);
                        }   
                    }
                }
                System.debug('Debug Log For mapCodeQuantity 1: '+mapCodeQuantity);
                if(objInventory2.RecordType.Name != null && objInventory2.RecordType.Name == 'New Boats') {
                    selectedType = 'New Boat'; 
                } else if(objInventory2.RecordType.Name != null && objInventory2.RecordType.Name == 'Used Boats') {
                    selectedType = 'Used Boat';
                } else {
                    selectedType = objInventory2.RecordType.Name; 
                }
                
                if(objInventory2.Stage__c != null && objInventory2.Stage__c.equalsignoreCase('Ordered')) {
                    InvUpdateStatus = true; 
                }  
                List<RecordType> lstRecTT = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
                
                if(lstRecTT[0].Id == objInventory2.RecordTypeId) {
                    if(objInventory2.Cost__c != null){                                                      
                        yourPriceThirdPageForProductPrice = objInventory2.Cost__c;
                    }else{  
                        yourPriceThirdPageForProductPrice = 0.00;
                    }
                } else {
                    if(objInventory2.Suggested_List_Price__c != null){                                                      
                        yourPriceThirdPageForProductPrice = objInventory2.Suggested_List_Price__c;
                    }else{
                        yourPriceThirdPageForProductPrice = 0.00;
                    }
                }     
                System.debug('yourPriceThirdPageForProductPrice: '+yourPriceThirdPageForProductPrice);
                System.debug('objInventory2.RecordTypeId: '+objInventory2.RecordTypeId);
                System.debug('objInventory2.totalPrice: '+totalPrice);
                System.debug('objInventory2.Suggested_List_Price__c: '+objInventory2.Suggested_List_Price__c);                                
                totalPrice = totalPrice + yourPriceThirdPageForProductPrice;
                System.debug('objInventory2.totalPrice: '+totalPrice);
                Set<String> setProductCode = new Set<String>();
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                    for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r)
                    {
                        selectedOptionsforInventory.add(objInventoryLineItem.Name__c);
                        if(objInventoryLineItem.Product_Code__c != null){
                            setProductCode.add(objInventoryLineItem.Product_Code__c);
                        }
                        if(objInventoryLineItem.Dealer_Price__c != null){
                            MfgOptDealerTota += objInventoryLineItem.Dealer_Price__c;
                        }
                    }
                    
                    
                }
                if(objInventory2.Cost__c != null){
                    totalPriceDealer = objInventory2.Cost__c + MfgOptDealerTota;
                }else{
                    totalPriceDealer = MfgOptDealerTota;
                } 
                System.debug('>>>>>>totalPriceDealer: '+totalPriceDealer);
                if(objInventory2.Manufacturer__c != null){
                    selectedManufacturerThirdPage = objInventory2.Manufacturer__c;
                }
                if(objInventory2.Year__c != null){
                    selectedYearSecondPage = objInventory2.Year__c ;
                }
                if(objInventory2.Model__c != null){
                    selectedModelThirdPage = objInventory2.Model__c;
                }
                if(objInventory2.Model_Variant__c != null){
                    smVrnt = objInventory2.Model_Variant__c;
                }
                //MfgOptTota = calculateOptionsPrice;
                if(objInventory2.Manufacturer__c != null){
                    strSupraName = objInventory2.Manufacturer__c;
                    List<BOATBUILDING__Manufacturer__c> lstManu = [Select Id,Name from BOATBUILDING__Manufacturer__c 
                                                                    where Name =: objInventory2.Manufacturer__c AND RecordType.DeveloperName = 'Boat_Manufacturer' limit 1];
                    String ManufacturerCheck = '';
                    if(!lstManu.isEmpty()) {                                                
                        ManufacturerCheck = lstManu[0].Id;
                    }
                    if(ManufacturerCheck != null && ManufacturerCheck != '') {
                        selectedManufacture = ManufacturerCheck;
                    }
                    //selectedManufacture = [Select Id,Name from BOATBUILDING__Manufacturer__c where Name =: objInventory2.Manufacturer__c limit 1].Id;
                }
                if(objInventory2.Model__c != null){
                    selectedModel = objInventory2.Model__c;
                }
                if(objInventory2.Model_Variant__c!=null){
                    selectedModelVariant = objInventory2.Model_Variant__c;
                }
                BOATBUILDING__Manufacturer__c objManufacurer = new BOATBUILDING__Manufacturer__c();
                if(selectedManufacture != null){
                    objManufacurer = [Select Id, Model_Variant__c, Name from BOATBUILDING__Manufacturer__c where Id =: selectedManufacture  limit 1];
                    selectedManufacturerSecondPage = String.valueOf(objManufacurer.Name);
                    modelVarientFlag = objManufacurer.Model_Variant__c;
                }
                String strRecordTypeName = '';
                if(objInventory2.RecordTypeId != null){
                    List<RecordType> lstRecType = [Select Name from RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' AND Id =: objInventory2.RecordTypeId limit 1];
                    if(lstRecType.size() > 0){
                        strRecordTypeName = lstRecType[0].Name; 
                    }
                    
                }
                //String strRecordTypeName = [Select Name from RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' AND Id =: objInventory2.RecordTypeId].Name;
                //System.debug('>>>>>>>: ')
                if(objInventory2.Year__c != null && (!modelVarientFlag) && !strRecordTypeName.equalsIgnoreCase('Used Boats')){
                    if(selectedModel != null){
                        
                        emailDebugBody += 'objManufacurer.Id: '+objManufacurer.Id + '\n';
                        emailDebugBody += 'selectedModel: '+selectedModel + '\n';
                        emailDebugBody += 'objInventory2.Year__c: '+objInventory2.Year__c + '\n';
                        emailDebugBody += 'selectedType: '+selectedType + '\n';
                        objProduct = [Select  
                                                Sale_Price__c,  Boat_Length_in_feets__c, Transmission_Gearbox_SN__c,  State__c, M_Manufacturer1__c, Product_Short_Description__c,  Product_Manufacturer__c,  Product_Long_Description__c, 
                                                Part_Number__c,  M_Dealer_Base_Price__c, Name,  M_Year__c, Trailer_VIN__c,   Trailer_Trade_Over_Allowance_Calculated__c,  M_Trailer_Trade_Allowance__c,  M_Trailer_Sales_Tax__c,
                                                Engine_SN__c,  M_Model_Variant__c, M_Dealer_Discount__c, M_Dealer_COD_Discount__c, M_Dealer_Flat_Discount__c, M_Trailer_Reg_Fee__c,  M_Trailer_MSRP_PRICE__c,  M_Trailer_Actual_Cost_Value_ACV__c, 
                                                M_Trade_PayOFF__c,  M_Total_Price_Calculated__c,  M_Hidden_Box__c,  M_Total_Over_Allowance_Calculated__c,  M_Deal_Margin__c, M_Total_MSRP__c,  M_Total_Due__c,  M_Total_Amount_Financed_Calculated__c, 
                                                M_Finance_Term__c, M_Rfinance_Rate__c,  M_Retail_Price__c,  M_Quantity__c,  Freight__c,   M_Product_Family__c,   M_Payment__c,  MModel2__c,   M_Manufacture_Status__c,   M_Down_Payment__c,
                                                M_Doc_Fee__c,  M_Discount__c,  M_Description__c,   M_Dealer_Stock__c, M_Dealer_Status__c,  Prep__c,    M_Dealer_Comments__c,   M_Boat_Trade_Over_Allowance_Calculated__c,  M_Boat_Trade_Allowance__c, 
                                                M_Boat_Sales_Tax_Calculated__c,  M_Boat_Reg_Fee__c,  M_Boat_MSRP_PRICE__c,  M_Boat_Actual_Cost_Value_ACV__c,  M_Net_Selling_Price_Calculated__c,  Id,  Hull_Id__c,  Dealer__c, 
                                                Cost_Price__c,  M_Your_Price_Calculated__c,  M_Product_Salesperson_new__c 
                                    From 
                                                BOATBUILDING__Product__c p 
                                    where  BOATBUILDING__Product_Manufacturer__c =: objManufacurer.Id  AND MModel2__c=: selectedModel  AND  M_Year__c =: objInventory2.Year__c AND Product_Type__c =: selectedType limit 1];
                    }
                    
                    //SendEmailUtility.sendQuickEmail('Email For Product: '+objProduct);
                }else if(objInventory2.Year__c != null && modelVarientFlag  && !strRecordTypeName.equalsIgnoreCase('Used Boats')){
                    if(selectedModelVariant != null) { 
                        objProduct = [Select SystemModstamp, Sale_Price__c,Boat_Length_in_feets__c, M_Manufacturer1__c,Transmission_Gearbox_SN__c, Product_Short_Description__c,State__c, Product_Manufacturer__c, Product_Long_Description__c,
                                      Part_Number__c, Name,M_Model_Variant__c ,Trailer_VIN__c, M_Year__c,  Trailer_Trade_Over_Allowance_Calculated__c, M_Trailer_Trade_Allowance__c, 
                                      M_Trailer_Sales_Tax__c,Engine_SN__c, M_Trailer_Reg_Fee__c,M_Dealer_Discount__c,M_Dealer_COD_Discount__c,M_Dealer_Flat_Discount__c,
                                      M_Trailer_MSRP_PRICE__c, M_Hidden_Box__c, M_Trailer_Actual_Cost_Value_ACV__c, M_Trade_PayOFF__c,M_Finance_Term__c,M_Total_Price_Calculated__c, M_Total_Over_Allowance_Calculated__c, M_Deal_Margin__c,M_Total_MSRP__c, M_Total_Due__c, M_Total_Amount_Financed_Calculated__c,  
                                      M_Rfinance_Rate__c, M_Retail_Price__c, M_Quantity__c, Freight__c, M_Product_Family__c,  M_Payment__c, 
                                      MModel2__c,  M_Manufacture_Status__c,   M_Down_Payment__c,M_Dealer_Base_Price__c,
                                      M_Doc_Fee__c, M_Discount__c, M_Description__c,  M_Dealer_Stock__c,
                                      M_Dealer_Status__c, Prep__c,   M_Dealer_Comments__c,  M_Boat_Trade_Over_Allowance_Calculated__c, 
                                      M_Boat_Trade_Allowance__c, M_Boat_Sales_Tax_Calculated__c, M_Boat_Reg_Fee__c, M_Boat_MSRP_PRICE__c, M_Boat_Actual_Cost_Value_ACV__c,
                                      
                                      M_Net_Selling_Price_Calculated__c, LastViewedDate, LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, Id, 
                                      Hull_Id__c, Dealer__c, Cost_Price__c, M_Your_Price_Calculated__c, M_Product_Salesperson_new__c From BOATBUILDING__Product__c p where
                                      BOATBUILDING__Product_Manufacturer__c =: objManufacurer.Id 
                                      AND MModel2__c =: selectedModel AND M_Model_Variant__c=: selectedModelVariant AND M_Year__c =: objInventory2.Year__c AND Product_Type__c =: selectedType limit 1];
                    }
                } 
                else if(strRecordTypeName.equalsIgnoreCase('Used Boats')) {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', strRecordTypeName).getSelectedCatagory();
                    List<CheckBoxWraper> lstCheckBoxWraper; 
                    for(String strMapValues : mapSelectedCategory.keySet()){
                        lstCheckBoxWraper = new List<CheckBoxWraper>();
                        for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                            if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))){
                                //mapCodeQuantity
                                if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                    objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                }
                                lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                
                                BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                objQLI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                                objQLI.Name = 'QLI';
                                objQLI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                                objQLI.Total_Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                                objQLI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c;
                                objQLI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c;
                                objQLI.Quantity__c = mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c) ? mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c) : 1;
                                objQLI.Date__c =  Date.today();
                                MfgOptTota = MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objQLI.Quantity__c);
                                lstQuoteLineItem.add(objQLI);
                            } else {  
                                
                                lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                
                            }
                        }
                        mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
                    }
                    
                    totalPrice = MfgOptTota + yourPriceThirdPageForProductPrice;
                    
                    System.debug('yourPriceThirdPageForProductPrice: '+yourPriceThirdPageForProductPrice);
                    System.debug('U objInventory2.RecordTypeId: '+objInventory2.RecordTypeId);
                    System.debug('U objInventory2.totalPrice: '+totalPrice);
                    System.debug('U objInventory2.Suggested_List_Price__c: '+objInventory2.Suggested_List_Price__c);
                    
                    

                    for(String strUtil : mapSelectedCategory.keySet()){
                        System.debug('Debug log for strUtil'+strUtil); 
                        lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                    }
                    
                    
                    
                    List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();
                    // [SELECT 
                    //                                                         Id,
                    //                                                         Name,
                    //                                                         Part_Number__c,
                    //                                                         Retail_Price__c,
                    //                                                         Cost__c,
                    //                                                         Non_Taxable__c
                    //                                                         FROM
                    //                                                         BOATBUILDING__Dealer_Option__c];
                    Map<String, BOATBUILDING__Inventory_Line_Item__c> mapILI= new Map<String, BOATBUILDING__Inventory_Line_Item__c>();
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                        for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                            if(objInventoryLineItem.Product_Code__c != null){
                                mapILI.put(objInventoryLineItem.Product_Code__c, objInventoryLineItem);     
                                System.debug('objInventoryLineItem load loop>>: '+objInventoryLineItem);
                            }
                        }
                    }

                    Set<String> ProductCodeForNonExist = new Set<String>();
                    
                    for(BOATBUILDING__Dealer_Option__c objDP : lstDealerOption){
                        ProductCodeForNonExist.add(objDP.Part_Number__c);  
                        if(mapILI.keySet().contains(objDP.Part_Number__c)){
                            objDP.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            objDP.Quantity__c = mapILI.get(objDP.Part_Number__c).Quantity__c;
                            lstDealerOptionWraper.add(new DealerOptionWraper(true, objDP, false));
                            dealerOptionTotal += objDP.Retail_Price__c * objDP.Quantity__c;
                            dealerOptionCostTotal += objDP.Cost__c * objDP.Quantity__c;
                            
                            BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                            objQLI.Name = 'QLI';
                            objQLI.Name__c = objDP.Name; 
                            objQLI.Product__c = objProduct.Id;
                            objQLI.Option_Category__c = 'Dealer Options';
                            objQLI.Total_Price__c = objDP.Retail_Price__c;
                            objQLI.Date__c =  Date.today();
                            objQLI.Dealer_Price__c = objDP.Cost__c;
                            objQLI.Quantity__c =  objDP.Quantity__c;
                            objQLI.Product_Code__c = objDP.Part_Number__c ;
                            objQLI.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            lstQuoteLineItem.add(objQLI);
                            
                        }else{
                            lstDealerOptionWraper.add(new DealerOptionWraper(false, objDP, false));
                        }
                    }
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                        for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                            if(objInventoryLineItem.BOATBUILDING__Option_Category__c.equalsIgnoreCase('Dealer Options')) {
                                if(!ProductCodeForNonExist.contains(objInventoryLineItem.BOATBUILDING__Product_Code__c)) {
                                    dealerOptionTotal += objInventoryLineItem.BOATBUILDING__Price__c * objInventoryLineItem.Quantity__c;
                                    dealerOptionCostTotal += objInventoryLineItem.BOATBUILDING__Dealer_Price__c * objInventoryLineItem.Quantity__c;
                                    BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
                                    objDOO.Name = objInventoryLineItem.BOATBUILDING__Name__c;
                                    objDOO.BOATBUILDING__Retail_Price__c = objInventoryLineItem.BOATBUILDING__Price__c;
                                    objDOO.BOATBUILDING__Cost__c = objInventoryLineItem.BOATBUILDING__Dealer_Price__c;
                                    objDOO.BOATBUILDING__Part_Number__c = objInventoryLineItem.BOATBUILDING__Product_Code__c;
                                    objDOO.Quantity__c = objInventoryLineItem.Quantity__c;
                                    objDOO.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c;
                                    lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, false));
                                    
                                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                    objQLI.Name = 'QLI';
                                    objQLI.Name__c = objDOO.Name;
                                    objQLI.Product__c = objProduct.Id;
                                    objQLI.Option_Category__c = 'Dealer Options';
                                    objQLI.Total_Price__c = objDOO.Retail_Price__c;
                                    objQLI.Date__c =  Date.today();
                                    objQLI.Dealer_Price__c = objDOO.Cost__c;
                                    objQLI.Quantity__c = objDOO.Quantity__c;
                                    objQLI.Product_Code__c = objDOO.Part_Number__c ;
                                    objQLI.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c; 
                                    lstQuoteLineItem.add(objQLI);
                                }
                            }
                        }
                    }
                    totalPrice += dealerOptionTotal;
                } 
                if(objProduct.Cost_Price__c != null){
                    yourPriceThirdPageForProductPriceDealer = objProduct.Cost_Price__c;
                }else{
                    yourPriceThirdPageForProductPriceDealer = 0.00;
                }
                System.debug('Debug Log For strRecordTypeName: '+strRecordTypeName);
                if(objProduct.Id != null) {
                    if(objProduct.M_Boat_MSRP_PRICE__c!= null)
                    {
                        totalprice =  MfgOptTota + objProduct.M_Boat_MSRP_PRICE__c;
                    }
                    else{
                        totalprice =  MfgOptTota;
                    }
                    //selectedModelSecondPage = String.valueOf(objProduct.MModel2__c);
                    if(objProduct.M_Manufacture_Status__c != null && objProduct.M_Manufacture_Status__c != ''){
                        manufacturerStatus = String.valueOf(objProduct.M_Manufacture_Status__c);
                    }
                    if(objProduct.M_Dealer_Status__c != null && objProduct.M_Dealer_Status__c != ''){
                        dealerStatus = String.valueOf(objProduct.M_Dealer_Status__c);
                    }
                    
                    if(objProduct.M_Boat_MSRP_PRICE__c == null){
                        yourPriceThirdPageForProductPrice = 0.00;
                    }else{
                        yourPriceThirdPageForProductPrice = objProduct.M_Boat_MSRP_PRICE__c;
                    }
                    
                    if(!strRecordTypeName.equalsIgnoreCase('Used Boats')) {
                        if(!modelVarientFlag){
                            mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(objProduct.Id, selectedManufacture, objProduct.M_Year__c, strRecordTypeName).getSelectedCatagory();
                            if(strRecordTypeName == 'New Boats') {
                                Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(objProduct.Id, selectedManufacture, objProduct.M_Year__c, 'Trailer').getSelectedCatagory();
                                mapSelectedCategory.putAll(mapSelectedCategory2);
                            }
                        }else if(modelVarientFlag){
                            mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(objProduct.Id, selectedManufacture, objProduct.M_Year__c, strRecordTypeName).getSelectedCatagory();
                            if(strRecordTypeName == 'New Boats') {
                                Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(objProduct.Id, selectedManufacture, objProduct.M_Year__c, 'Trailer').getSelectedCatagory();
                                mapSelectedCategory.putAll(mapSelectedCategory2);
                            }
                        }
                    } else if(strRecordTypeName.equalsIgnoreCase('Used Boats')) {
                        //mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
                    }
                    
                    
                    
                    //System.debug('Debug Log For objProduct.Id: '+objProduct.Id);
                    List<CheckBoxWraper> lstCheckBoxWraper;
                    System.debug('Debug Log For mapSelectedCategory: '+mapSelectedCategory);
                    System.debug('Debug Log For selectedOptionsforInventory: '+selectedOptionsforInventory);
                    
                    for(String strMapValues : mapSelectedCategory.keySet()) {
                        lstCheckBoxWraper = new List<CheckBoxWraper>();
                        for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                            if(!modelVarientFlag){
                                System.debug('Debug Log For objProductPriceForSelectedCategory**** :  '+objProductPriceForSelectedCategory);
                                if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
                                   && String.valueOf(objInventory2.Manufacturer__c).containsIgnoreCase(objProductPriceForSelectedCategory.ProductManufacturer__c)
                                   && String.valueOf(objInventory2.Year__c).containsIgnoreCase(objProductPriceForSelectedCategory.Year__c)
                                   && String.valueOf(objInventory2.Model__c).containsIgnoreCase(objProductPriceForSelectedCategory.Product_Model__c)
                                   && setProductCode.contains(String.ValueOf(objProductPriceForSelectedCategory.Product_Code__c)))
                                   {
                                        //mapCodeQuantity
                                        if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                            objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                        }   
                                        
                                        lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                       
                                       BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                       objQLI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                                       objQLI.Name = 'QLI';
                                       objQLI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                                       objQLI.Product__c = objProduct.Id;
                                       objQLI.Total_Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                                       objQLI.Date__c =  Date.today();
                                       objQLI.Quantity__c =  mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c) ? mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c) : 1;
                                       objQLI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c ;
                                       objQLI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c; 
                                       //objQLI.Product_Type__c = objProductPriceForSelectedCategory.RecordType.Name;
                                       if(objProductPriceForSelectedCategory.RecordType.Name == 'New Boats') {
                                           objQLI.Product_Type__c = 'New Boat';
                                       } else { 
                                           objQLI.Product_Type__c = objProductPriceForSelectedCategory.RecordType.Name;
                                       }
                                       lstQuoteLineItem.add(objQLI);
                                       System.debug('Debug Log For moomba objProductPriceForSelectedCategory True: '+objProductPriceForSelectedCategory);
                                       
                                       MfgOptTota = MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objQLI.Quantity__c);
                                   }
                                   else
                                   { 
                                       System.debug('Debug Log For moomba objProductPriceForSelectedCategory False : '+objProductPriceForSelectedCategory);
                                       lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                   }
                            }else if(modelVarientFlag){
                                if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
                                   && objInventory2.Manufacturer__c == objProductPriceForSelectedCategory.ProductManufacturer__c
                                   && objInventory2.Year__c == objProductPriceForSelectedCategory.Year__c
                                   && objInventory2.Model__c == objProductPriceForSelectedCategory.Product_Model__c
                                   && objInventory2.Model_Variant__c == objProductPriceForSelectedCategory.Model_Variant__c
                                   && setProductCode.contains(String.ValueOf(objProductPriceForSelectedCategory.Product_Code__c)))
                                   {
                                       //mapCodeQuantity
                                       if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                            objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                        }   
                                       lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                       BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                       objQLI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                                       objQLI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                                       objQLI.Name = 'QLI'; 
                                       objQLI.Product__c = objProduct.Id;
                                       objQLI.Total_Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                                       objQLI.Quantity__c =  mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c) ? mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c) : 1;
                                       objQLI.Date__c =  Date.today();
                                       objQLI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c;
                                       objQLI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c ;
                                       
                                       if(objProductPriceForSelectedCategory.RecordType.Name == 'New Boats') {
                                           objQLI.Product_Type__c = 'New Boat';
                                       } else {
                                           objQLI.Product_Type__c = objProductPriceForSelectedCategory.RecordType.Name;
                                       }
                                       
                                       lstQuoteLineItem.add(objQLI);
                                       MfgOptTota = MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objQLI.Quantity__c);
                                   }
                                   else
                                   { 
                                       lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));    
                                   }
                            }
                        }
                        mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
                        //System.debug('Debug Log For strMapValues: '+strMapValues+' Debug Log For lstCheckBoxWraper: '+lstCheckBoxWraper);
                    }
                    
                    
                    
                    
                    
                    for(String strUtil : mapSelectedCategory.keySet()){
                        
                        lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                        
                    }
                    
                    
                    
                    
                    totalPrice = MfgOptTota + yourPriceThirdPageForProductPrice;
                    
                    List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();
                                                                            // [SELECT 
                                                                            // Id,
                                                                            // Name,
                                                                            // Part_Number__c,
                                                                            // Retail_Price__c,
                                                                            // Cost__c,
                                                                            // Non_Taxable__c,

                                                                            // FROM
                                                                            // BOATBUILDING__Dealer_Option__c];
                    Map<String, BOATBUILDING__Inventory_Line_Item__c> mapILI= new Map<String, BOATBUILDING__Inventory_Line_Item__c>();
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                        for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                            if(objInventoryLineItem.Product_Code__c != null){
                                mapILI.put(objInventoryLineItem.Product_Code__c, objInventoryLineItem);     
                            }
                        }
                    }
                    Set<String> ProductCodeForNonExist = new Set<String>();
                    
                    for(BOATBUILDING__Dealer_Option__c objDP : lstDealerOption){
                        ProductCodeForNonExist.add(objDP.Part_Number__c);  
                        if(mapILI.keySet().contains(objDP.Part_Number__c)){
                            objDP.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            objDP.Quantity__c = mapILI.get(objDP.Part_Number__c).Quantity__c;
                            lstDealerOptionWraper.add(new DealerOptionWraper(true, objDP, false));
                            dealerOptionTotal += objDP.Retail_Price__c * objDP.Quantity__c;
                            dealerOptionCostTotal += objDP.Cost__c * objDP.Quantity__c;
                            BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                            objQLI.Name = 'QLI';
                            objQLI.Name__c = objDP.Name; 
                            objQLI.Product__c = objProduct.Id;
                            objQLI.Option_Category__c = 'Dealer Options';
                            objQLI.Total_Price__c = objDP.Retail_Price__c;
                            objQLI.Date__c =  Date.today();
                            objQLI.Dealer_Price__c = objDP.Cost__c;
                            objQLI.Quantity__c = objDP.Quantity__c;
                            objQLI.Product_Code__c = objDP.Part_Number__c ;
                            objQLI.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            lstQuoteLineItem.add(objQLI);
                            
                        }else{
                            lstDealerOptionWraper.add(new DealerOptionWraper(false, objDP, false));
                        }
                    }
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() > 0){
                        for(BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem : objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                            if(objInventoryLineItem.BOATBUILDING__Option_Category__c.equalsIgnoreCase('Dealer Options')) {
                                if(!ProductCodeForNonExist.contains(objInventoryLineItem.BOATBUILDING__Product_Code__c)) {
                                    dealerOptionTotal += (objInventoryLineItem.BOATBUILDING__Price__c * objInventoryLineItem.Quantity__c) ;
                                    dealerOptionCostTotal += (objInventoryLineItem.BOATBUILDING__Dealer_Price__c * objInventoryLineItem.Quantity__c);
                                    System.debug('>>>>>>objInventoryLineItem.BOATBUILDING__Dealer_Price__c: '+objInventoryLineItem.BOATBUILDING__Dealer_Price__c);
                                    BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
                                    objDOO.Name = objInventoryLineItem.BOATBUILDING__Name__c;
                                    objDOO.BOATBUILDING__Retail_Price__c = objInventoryLineItem.BOATBUILDING__Price__c;
                                    objDOO.BOATBUILDING__Cost__c = objInventoryLineItem.BOATBUILDING__Dealer_Price__c;
                                    objDOO.BOATBUILDING__Part_Number__c = objInventoryLineItem.BOATBUILDING__Product_Code__c;
                                    objDOO.Quantity__c = objInventoryLineItem.Quantity__c;
                                    objDOO.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c;
                                    lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, false));
                                    
                                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                    objQLI.Name = 'QLI';
                                    objQLI.Name__c = objDOO.Name;
                                    objQLI.Product__c = objProduct.Id;
                                    objQLI.Option_Category__c = 'Dealer Options';
                                    objQLI.Total_Price__c = objDOO.Retail_Price__c;
                                    objQLI.Date__c =  Date.today();
                                    objQLI.Quantity__c = objDOO.Quantity__c;
                                    objQLI.Dealer_Price__c = objDOO.Cost__c;
                                    objQLI.Product_Code__c = objDOO.Part_Number__c ;
                                    objQLI.Non_Taxable__c = objInventoryLineItem.Non_Taxable__c; 
                                    lstQuoteLineItem.add(objQLI);
                                }
                            }
                        }
                        System.debug('>>>>>>dealerOptionCostTotal: '+dealerOptionCostTotal);
                    }
                    System.debug('lstQuoteLineItem: '+lstQuoteLineItem);
                    totalPrice += dealerOptionTotal; 
                    System.debug('>>>>>>totalPriceDealer Last: '+totalPriceDealer); 
                    System.debug('Debug for cwoRetailTotal:  '+cwoRetailTotal);
                    totalPrice += cwoRetailTotal;
                    System.debug('Debug for totalPrice:  '+totalPrice);
                    totalPriceDealer += cwoDealerTotal;
                }
            }
            //--------------------------------------Quote to Boat Builder---------------------------------------//
            /** 
            * Author : Akshay Kumar 
            * Created Date : 06/01/2017
            */
            if(ApexPages.currentPage().getParameters().get('quoteId') != null) {
                buttonRenderForCustomerDetail =true;
                buttonRenderForSaveAndReCal = true;
                buttonRenderForPlaceOrder = false;
                objQuote3 = [SELECT  
                                    q.Transmission_Gearbox_SN__c, q.Total_Price_Quote__c,  q.Test_2__c,  q.Tax__c, q.Syncing__c,  q.Status__c,  q.State__c,  q.Shipping_And_Handling__c,  q.Ship_To__c,  q.Ship_To_Name__c, 
                                    q.Related_to_Product__c,  q.Related_to_Order__c, q.RecordTypeId,  q.Quote_Your_Price_Negotiation__c, q.Quote_Your_Price_Formula__c,  q.Quote_Trailer_Sales_Tax__c,  q.Quote_Trailer_Sales_Tax_Negotiation__c,
                                    q.Quote_Trailer_Reg_Fee__c,  q.Quote_Trailer_Reg_Fee_Negotiation__c,  q.Quote_Trailer_Allowance__c,  q.Quote_Trailer_Allowance_Negotiation__c,  q.Quote_Trailer_Allowance_Calculated__c, 
                                    q.Quote_Trailer_ACV__c,  q.Quote_Trailer_ACV_Negotiation__c,  q.Quote_Trade_Payoff__c,  q.Quote_Trade_Allowance__c,  q.Quote_Trade_Allowance_Negotiation__c,  q.Quote_Trade_ACV__c, 
                                    q.Quote_Trade_ACV_Negotiation__c,  q.Quote_Total_Price_Calculated__c,  q.Quote_Total_Over_Allowance_Calculated__c,  q.Quote_Total_MSRP__c,  q.Quote_Total_Amount_Financed_Calculated__c, 
                                    q.Quote_To_Name__c,  q.Quote_To_Address__c,  q.Quote_Term__c,  q.Quote_Sale_Price__c,  q.Quote_Rate__c,  q.Quote_Payment__c,  q.Quote_Payment_Negotiation__c,  q.Quote_Number__c,  q.Quote_Net_Selling_Price_Calculated__c, 
                                    q.Quote_MSRP_Trailer_Price__c,  q.Quote_MSRP_Trailer_Price_Negotiation__c,  q.Quote_MSRP_Boat_Price__c,  q.Quote_Down_Payment__c,  q.Quote_Doc_Fee__c,  q.Quote_Deal_Margin__c,  q.Quote_Cost_Clone__c, 
                                    q.Quote_Boat_Trade_Over_Allowance_Calculat__c,  q.Quote_Boat_Sales_Tax_Negotiation__c,  q.Quote_Boat_Sales_Tax_Calculated__c,  q.Quote_Boat_Reg_Fee__c,  q.QuoteHiddenBox__c,  q.Phone__c,
                                    q.NetSalesTax__c,  q.Negotiation_Trailer_ACV__c,  q.Negotiation_Trade_Payoff__c,  q.Negotiation_MSRP_Boat_Price__c,  q.Name,  q.Mapped_Trailer_VIN__c,  q.Mapped_HIN__c,  q.Mapped_Engine_SN__c, 
                                    q.Mapped_Boat_Length__c,  q.MSRP_Boat_Price_Negotiation__c,  q.Lock_Record__c, q.Id,  q.Grand_Total__c,  q.Fax__c,  q.Expiration_Date__c,  q.Email__c,  q.Discount__c,  q.Discount_On_Quote__c, 
                                    q.Description__c,   q.Contact_Name__c,  q.Commission__c,  q.Booked_Sale_Price__c,  q.Booked_ACV__c,  q.Boat_Sales_Tax2__c,  q.Boat_Costline__c,  q.Bill_To__c,  q.Bill_To_Name__c,  q.Additional_To__c, 
                                    q.Additional_To_Name__c,  q.Account_Name__c,  q.APPROVED_ACV__c,  q.ACV_FORM__c, q.Related_to_Product__r.Product_Manufacturer__r.Name, q.Related_to_Product__r.Product_Manufacturer__r.Model_Variant__c,
                                    q.Related_to_Product__r.M_Year__c, q.Related_to_Product__r.MModel2__c, q.Related_to_Product__r.M_Model_Variant__c, q.Related_to_Product__r.M_Boat_MSRP_PRICE__c, q.Related_to_Product__r.M_Manufacture_Status__c,
                                    q.Related_to_Product__r.M_Dealer_Status__c, Related_to_Product__r.Product_Type__c, q.Test_2__r.RecordTypeId, q.Test_2__r.RecordType.Name, q.Test_2__r.Suggested_List_Price__c, q.No_Trailer__c, q.Engine__c,
                                    q.Trailer__c, q.Engine__r.Total_MSRP_Price__c, q.Engine__r.Manufacturer__c, q.Engine__r.Model__c, q.Engine__r.Year__c, q.Trailer__r.Total_MSRP_Price__c, q.Trailer__r.Manufacturer__c, q.Trailer__r.Model__c, q.Trailer__r.Year__c,
                                    (
                                        SELECT  Id,  IsDeleted,  Name, Date__c,  Discount__c,  Line_Item_Description__c,  BOATBUILDING__Product_Type__c, List_Price__c,  Product__c,  Product_Code__c,  Quantity__c,  Quote__c,  Sales_Price__c,  Sub_Total__c,  Total_Price__c,  Dealer_Price__c, Option_Category__c,
                                                Name__c, Non_Taxable__c, BOATBUILDING__Total_Dealer_Price__c, BOATBUILDING__Total_Retail_Price__c FROM  BOATBUILDING__Quote_Line_Item__r 
                                    ) 
                                    FROM  BOATBUILDING__Quote__c q WHERE  Id=: ApexPages.currentPage().getParameters().get('quoteId')];
                
                
                if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                    for(BOATBUILDING__Quote_Line_Item__c objQLI : objQuote3.BOATBUILDING__Quote_Line_Item__r) {
                        mapCodeQuantity.put(objQLI.Product_Code__c, objQLI.Quantity__c);
                        setcodeId.add(objQLI.Product_Code__c);
                        lstQuoteLineItem.add(objQLI);
                        if(objQLI.BOATBUILDING__Option_Category__c == 'CWO') {
                            lstWritinCustomOption.add(new WritinCustomOption(true, 
                                                                                    objQLI.BOATBUILDING__Name__c, 
                                                                                    objQLI.BOATBUILDING__Quantity__c, 
                                                                                    objQLI.BOATBUILDING__Total_Price__c, 
                                                                                    objQLI.BOATBUILDING__Dealer_Price__c, 
                                                                                    objQLI.BOATBUILDING__Product_Code__c, 
                                                                                    objQLI.BOATBUILDING__Non_Taxable__c));
                            cwoRetailTotal += objQLI.BOATBUILDING__Total_Retail_Price__c;
                            cwoDealerTotal += objQLI.BOATBUILDING__Total_Dealer_Price__c;
                        }
                    }
                }
                System.debug('log for setcodeId: '+setcodeId);
                System.debug('log for lstQuoteLineItem: '+lstQuoteLineItem);
                System.debug('log for lstQuoteLineItem size: '+lstQuoteLineItem.size());
                modelVarientFlag = objQuote3.Related_to_Product__r.Product_Manufacturer__r.Model_Variant__c;
                
                //noTrailer = objQuote3.No_Trailer__c;
                System.debug('Debug Log For objQuote3.Test_2__r.RecordType.Name: '+objQuote3.Test_2__r.RecordType.Name);
                if(objQuote3.Test_2__c != null && objQuote3.Test_2__r.RecordType.Name == 'Used Boats') {
                    if(objQuote3.Test_2__r.Suggested_List_Price__c != null) {
                        
                        yourPriceThirdPageForProductPrice = objQuote3.Test_2__r.Suggested_List_Price__c;
                        System.debug('Debug Log For yourPriceThirdPageForProductPrice1: '+yourPriceThirdPageForProductPrice);
                    } else {
                        yourPriceThirdPageForProductPrice = 0.00;
                    }

                }else if(objQuote3.Quote_Total_MSRP__c!= null){                                                      
                    yourPriceThirdPageForProductPrice = objQuote3.Quote_Total_MSRP__c;
                }
                else{
                    yourPriceThirdPageForProductPrice = 0.00;
                }        
                
                
                totalPrice = totalPrice + yourPriceThirdPageForProductPrice;
                System.debug('Debug Log For yourPriceThirdPageForProductPrice2: '+yourPriceThirdPageForProductPrice);
                System.debug('Debug Log For totalPrice: '+totalPrice);
                System.debug('Debug Log For QuoteEnginePrice: '+QuoteEnginePrice);
                
                Set<String> selectedOptionsforQuote = new Set<String>();
                Map<String,String> mapOptionstoQLI = new Map<String,String>();
                Set<String> setProductCode = new Set<String>();
                Set<String> setProductOptions = new Set<String>();
                if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                    for(BOATBUILDING__Quote_Line_Item__c objQuoteLineItem : objQuote3.BOATBUILDING__Quote_Line_Item__r)
                    {
                        selectedOptionsforInventory.add(objQuoteLineItem.Name__c);
                        setProductOptions.add(objQuoteLineItem.Option_Category__c);
                        mapOptionstoQLI.put(objQuoteLineItem.Product_Code__c,objQuoteLineItem.Id);
                        selectedOptionsforQuote.add(objQuoteLineItem.Name__c);
                        if(objQuoteLineItem.Product_Code__c != null){
                            setProductCode.add(objQuoteLineItem.Product_Code__c);
                        }
                        
                        if(objQuoteLineItem.Dealer_Price__c != null){
                            MfgOptDealerTota += objQuoteLineItem.Dealer_Price__c;
                        }
                    }
                    
                    
                }
                
                if(objQuote3.Quote_Total_MSRP__c != null){
                    totalPriceDealer = objQuote3.Quote_Total_MSRP__c + MfgOptDealerTota;
                }else{
                    totalPriceDealer = MfgOptDealerTota;
                }
                String strRecordTypeName = '';
                if(objQuote3.Test_2__r != null && objQuote3.Test_2__r.RecordTypeId != null){
                    //List<RecordType> lstRecType = [Select Name from RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' AND Id =: objQuote3.Test_2__r.RecordTypeId limit 1];
                    //if(lstRecType.size() > 0){
                        strRecordTypeName = objQuote3.Test_2__r.RecordType.Name; 
                    //}
                }
                else{
                    strRecordTypeName = '';
                }
                
                System.debug('Debug Log For strRecordTypeName: '+strRecordTypeName);
                System.debug('Debug Log For strRecordTypeName: '+strRecordTypeName);
                if(String.isNotBlank(strRecordTypeName) && strRecordTypeName == 'Used Boats') {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', strRecordTypeName).getSelectedCatagory();
                    List<CheckBoxWraper> lstCheckBoxWraper; 
                    for(String strMapValues : mapSelectedCategory.keySet()){
                        lstCheckBoxWraper = new List<CheckBoxWraper>();
                        for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                            if(selectedOptionsforInventory.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))){
                                if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                    objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                }
                                lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                
                                BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                objQLI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                                objQLI.Name = 'QLI';
                                objQLI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                                objQLI.Total_Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                                objQLI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c;
                                objQLI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c;
                                objQLI.Quantity__c = mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c) ? mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c) : 1;
                                objQLI.Date__c =  Date.today();
                                lstQuoteLineItem.add(objQLI);
                                MfgOptTota = (MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objQLI.Quantity__c)).setScale(2);
                                
                            } else {  
                                
                                lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                
                            }
                        }
                        mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
                    }
                    
                    totalPrice += MfgOptTota;
                    for(String strUtil : mapSelectedCategory.keySet()){
                        System.debug('Debug log for strUtil'+strUtil); 
                        lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                    }
                    
                    
                    List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();
                    // [SELECT 
                    //                                                         Id,
                    //                                                         Name,
                    //                                                         Part_Number__c,
                    //                                                         Retail_Price__c,
                    //                                                         Cost__c,
                    //                                                         Non_Taxable__c
                    //                                                         FROM
                    //                                                         BOATBUILDING__Dealer_Option__c];
                    Map<String, BOATBUILDING__Quote_Line_Item__c> mapILI= new Map<String, BOATBUILDING__Quote_Line_Item__c>();
                    if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                        for(BOATBUILDING__Quote_Line_Item__c objQLI : objQuote3.BOATBUILDING__Quote_Line_Item__r) {
                            if(objQLI.Product_Code__c != null){
                                mapILI.put(objQLI.Product_Code__c, objQLI);     
                            }
                        }
                    }
                    Set<String> ProductCodeForNonExist = new Set<String>();
                    
                    for(BOATBUILDING__Dealer_Option__c objDP : lstDealerOption){
                        ProductCodeForNonExist.add(objDP.Part_Number__c);  
                        if(mapILI.keySet().contains(objDP.Part_Number__c)){
                            objDP.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            objDP.Quantity__c = mapILI.get(objDP.Part_Number__c).Quantity__c;
                            lstDealerOptionWraper.add(new DealerOptionWraper(true, objDP, false));
                            dealerOptionTotal += (objDP.Retail_Price__c * objDP.Quantity__c);
                            dealerOptionCostTotal += (objDP.Cost__c * objDP.Quantity__c);
                            // BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                            // objQLI.Name = 'QLI';
                            // objQLI.Name__c = objDP.Name; 
                            // objQLI.Product__c = objProduct.Id;
                            // objQLI.Option_Category__c = 'Dealer Options';
                            // objQLI.Total_Price__c = objDP.Retail_Price__c;
                            // objQLI.Date__c =  Date.today();
                            // objQLI.Dealer_Price__c = objDP.Cost__c;
                            // objQLI.Product_Code__c = objDP.Part_Number__c ;
                            // objQLI.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            // lstQuoteLineItem.add(objQLI);
                            
                        }else{
                            lstDealerOptionWraper.add(new DealerOptionWraper(false, objDP, false));
                        }
                    }
                    
                    if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                        for(BOATBUILDING__Quote_Line_Item__c objQLI : objQuote3.BOATBUILDING__Quote_Line_Item__r) {
                            if(objQLI.BOATBUILDING__Option_Category__c.equalsIgnoreCase('Dealer Options')) {
                                if(!ProductCodeForNonExist.contains(objQLI.BOATBUILDING__Product_Code__c)) {
                                    
                                    dealerOptionTotal += (objQLI.BOATBUILDING__Total_Price__c * objQLI.Quantity__c) ;
                                    dealerOptionCostTotal += (objQLI.BOATBUILDING__Dealer_Price__c * objQLI.Quantity__c);
                                    
                                    BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
                                    objDOO.Name = objQLI.BOATBUILDING__Name__c;
                                    objDOO.BOATBUILDING__Retail_Price__c = objQLI.BOATBUILDING__Total_Price__c;
                                    objDOO.BOATBUILDING__Cost__c = objQLI.BOATBUILDING__Dealer_Price__c; 
                                    objDOO.BOATBUILDING__Part_Number__c = objQLI.BOATBUILDING__Product_Code__c;
                                    objDOO.Non_Taxable__c = objQLI.Non_Taxable__c;
                                    objDOO.Quantity__c = objQLI.Quantity__c;
                                    lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, false));
                                    
                                    // BOATBUILDING__Quote_Line_Item__c objQLI1 = new BOATBUILDING__Quote_Line_Item__c();
                                    // objQLI1.Name = 'QLI';
                                    // objQLI1.Name__c = objDOO.Name;
                                    // objQLI1.Product__c = objProduct.Id;
                                    // objQLI1.Option_Category__c = 'Dealer Options';
                                    // objQLI1.Total_Price__c = objDOO.Retail_Price__c;
                                    // objQLI1.Date__c =  Date.today();
                                    // objQLI1.Dealer_Price__c = objDOO.Cost__c;
                                    // objQLI1.Product_Code__c = objDOO.Part_Number__c ;
                                    // objQLI1.Non_Taxable__c = objDOO.Non_Taxable__c; 
                                    // lstQuoteLineItem.add(objQLI1);
                                }
                            }
                        }
                    }
                    totalPrice += dealerOptionTotal;
                    
                    
                }
                
                if(objQuote3.Related_to_Product__c != null) {
                    if(objQuote3.Related_to_Product__r.Product_Type__c != null) {
                        if(objQuote3.Related_to_Product__r.Product_Type__c == 'New Boat') {
                            strRecordTypeName = 'New Boats';
                        } else if(objQuote3.Related_to_Product__r.Product_Type__c == 'Used Boat') {
                            strRecordTypeName = 'Used Boats';
                        } else {
                            strRecordTypeName = objQuote3.Related_to_Product__r.Product_Type__c;
                        }
                    }
                    
                    if(objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name != null){
                        selectedManufacturerThirdPage = objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name;
                        strSupraName = objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name;
                        selectedManufacture = objQuote3.Related_to_Product__r.Product_Manufacturer__c;
                        selectedManufacturerSecondPage = objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name;
                    }
                    if(objQuote3.Related_to_Product__r.M_Year__c != null){
                        selectedYearSecondPage = objQuote3.Related_to_Product__r.M_Year__c ;
                    }
                    if(objQuote3.Related_to_Product__r.MModel2__c != null){
                        selectedModel = objQuote3.Related_to_Product__r.MModel2__c;
                        selectedModelThirdPage = objQuote3.Related_to_Product__r.MModel2__c;
                    }
                    if(objQuote3.Related_to_Product__r.M_Model_Variant__c != null){
                        selectedModelVariant = objQuote3.Related_to_Product__r.M_Model_Variant__c;
                        smVrnt = objQuote3.Related_to_Product__r.M_Model_Variant__c ;
                    }
                    
                    if(objQuote3.Related_to_Product__r.M_Boat_MSRP_PRICE__c != null)
                    {
                        totalprice =  MfgOptTota + objQuote3.Related_to_Product__r.M_Boat_MSRP_PRICE__c;
                    }else{
                        totalprice =  MfgOptTota;
                    }
                    //selectedModelSecondPage = String.valueOf(objProduct.MModel2__c);
                    if(objQuote3.Related_to_Product__r.M_Manufacture_Status__c != null && objQuote3.Related_to_Product__r.M_Manufacture_Status__c != ''){
                        manufacturerStatus = String.valueOf(objQuote3.Related_to_Product__r.M_Manufacture_Status__c);
                    }
                    if(objQuote3.Related_to_Product__r.M_Dealer_Status__c != null && objQuote3.Related_to_Product__r.M_Dealer_Status__c != ''){
                        dealerStatus = String.valueOf(objQuote3.Related_to_Product__r.M_Dealer_Status__c);
                    }
                    
                    if(objQuote3.Related_to_Product__r.M_Boat_MSRP_PRICE__c == null){
                        yourPriceThirdPageForProductPrice = 0.00;
                    }else{
                        yourPriceThirdPageForProductPrice = objQuote3.Related_to_Product__r.M_Boat_MSRP_PRICE__c;
                    }
                    
                    if((!modelVarientFlag) && strRecordTypeName != 'Used Boats'){
                        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(objQuote3.Related_to_Product__r.Id, selectedManufacture, objQuote3.Related_to_Product__r.M_Year__c, 'New Boats').getSelectedCatagory();
                        if(strRecordTypeName == 'New Boats') {
                            Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(objQuote3.Related_to_Product__r.Id, selectedManufacture, objQuote3.Related_to_Product__r.M_Year__c, 'Trailer').getSelectedCatagory();
                            mapSelectedCategory.putAll(mapSelectedCategory2);
                        }
                    }else if(modelVarientFlag && strRecordTypeName != 'Used Boats'){
                        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(objQuote3.Related_to_Product__r.Id, selectedManufacture, objQuote3.Related_to_Product__r.M_Year__c, 'New Boats').getSelectedCatagory();
                        if(strRecordTypeName == 'New Boats') {
                            Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(objQuote3.Related_to_Product__r.Id, selectedManufacture, objQuote3.Related_to_Product__r.M_Year__c, 'Trailer').getSelectedCatagory();
                            mapSelectedCategory.putAll(mapSelectedCategory2);
                        }
                    }
                    System.debug('Debug Log For objQuote3.Related_to_Product__r.Id: '+objQuote3.Related_to_Product__r.Id);
                    List<CheckBoxWraper> lstCheckBoxWraper;
                    System.debug('Debug Log For mapSelectedCategory: '+mapSelectedCategory.keySet());
                    System.debug('Debug Log For selectedOptionsforQuote: '+selectedOptionsforQuote);
                    for(String strMapValues : mapSelectedCategory.keySet()){
                        lstCheckBoxWraper = new List<CheckBoxWraper>();
                        for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                            if(!modelVarientFlag){
                                System.debug('Debug Log For objProductPriceForSelectedCategory**** :  '+objProductPriceForSelectedCategory);
                                if(selectedOptionsforQuote.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
                                   && String.valueOf(objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name).containsIgnoreCase(objProductPriceForSelectedCategory.ProductManufacturer__c)
                                   && String.valueOf(objQuote3.Related_to_Product__r.M_Year__c).containsIgnoreCase(objProductPriceForSelectedCategory.Year__c)
                                   && String.valueOf(objQuote3.Related_to_Product__r.MModel2__c).containsIgnoreCase(objProductPriceForSelectedCategory.Product_Model__c)
                                   && setProductCode.contains(String.valueOf(objProductPriceForSelectedCategory.Product_Code__c))){
                                        if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                            objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                        }   
                                        lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                        MfgOptTota = (MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objProductPriceForSelectedCategory.Quantity__c)).setScale(2);
                                   } 
                                
                                else{ 
                                    System.debug('Debug Log For moomba objProductPriceForSelectedCategory False : '+objProductPriceForSelectedCategory);
                                    lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                    
                                }
                            }else if(modelVarientFlag){
                                if(selectedOptionsforQuote.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))  
                                   && objQuote3.Related_to_Product__r.Product_Manufacturer__r.Name == objProductPriceForSelectedCategory.ProductManufacturer__c
                                   && objQuote3.Related_to_Product__r.M_Year__c == objProductPriceForSelectedCategory.Year__c
                                   && objQuote3.Related_to_Product__r.MModel2__c == objProductPriceForSelectedCategory.Product_Model__c
                                   && objQuote3.Related_to_Product__r.M_Model_Variant__c == objProductPriceForSelectedCategory.Model_Variant__c
                                   && setProductCode.contains(String.ValueOf(objProductPriceForSelectedCategory.Product_Code__c))){
                                        if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                            objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                        }   
                                       lstCheckBoxWraper.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                       MfgOptTota = (MfgOptTota + (objProductPriceForSelectedCategory.ProductRetail_Price__c * objProductPriceForSelectedCategory.Quantity__c)).setScale(2);
                                   }else{
                                       System.debug('______________objProductPriceForSelectedCategory.ProductSelected_Category__cfalse: '+objProductPriceForSelectedCategory.ProductSelected_Category__c);
                                       lstCheckBoxWraper.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                       
                                   }
                            }
                            
                        }
                        mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
                    } 
                    
                    if(strRecordTypeName.equalsIgnoreCase('Used Boats')){
                        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', strRecordTypeName).getSelectedCatagory();
                        List<CheckBoxWraper> lstCheckBoxWraper1;
                        for(String strMapValues : mapSelectedCategory.keySet()){
                            lstCheckBoxWraper1 = new List<CheckBoxWraper>();
                            for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                                if(selectedOptionsforQuote.contains(String.valueOf(objProductPriceForSelectedCategory.ProductSelected_Category__c))){
                                    if(mapCodeQuantity.containsKey(objProductPriceForSelectedCategory.Product_Code__c)) {
                                        objProductPriceForSelectedCategory.Quantity__c = mapCodeQuantity.get(objProductPriceForSelectedCategory.Product_Code__c);
                                    }   
                                    lstCheckBoxWraper1.add(new CheckBoxWraper(true, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                }else{ 
                                    
                                    lstCheckBoxWraper1.add(new CheckBoxWraper(false, lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                                    
                                }
                            }
                            mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
                        }
                        
                        
                        for(String strUtil : mapSelectedCategory.keySet()){
                            System.debug('Debug log for strUtil'+strUtil); 
                            lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                        }
                    }
                    
                    for(String strUtil : mapSelectedCategory.keySet()){
                        lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                    }
                    
                    
                    
                    totalPrice = MfgOptTota + yourPriceThirdPageForProductPrice;
                    
                    List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();

                    Map<String, BOATBUILDING__Quote_Line_Item__c> mapILI= new Map<String, BOATBUILDING__Quote_Line_Item__c>();
                    if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                        for(BOATBUILDING__Quote_Line_Item__c objQuoteLineItem : objQuote3.BOATBUILDING__Quote_Line_Item__r) {
                            if(objQuoteLineItem.Product_Code__c != null){
                                mapILI.put(objQuoteLineItem.Product_Code__c, objQuoteLineItem);     
                            }
                        }
                    }
                    
                    Set<String> ProductCodeForNonExistQuote = new Set<String>();
                    
                    for(BOATBUILDING__Dealer_Option__c objDP : lstDealerOption){
                        ProductCodeForNonExistQuote.add(objDP.Part_Number__c);
                        if(mapILI.keySet().contains(objDP.Part_Number__c)){
                            
                            // BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                            
                            // objQLI.Name = 'QLI';
                            // objQLI.Name__c = objDP.Name;
                            // objQLI.Product__c = objProduct.Id;
                            // objQLI.Option_Category__c = 'Dealer Options';
                            // objQLI.Total_Price__c = objDP.Retail_Price__c;
                            // objQLI.Date__c =  Date.today();
                            // objQLI.Dealer_Price__c = objDP.Cost__c;
                            // objQLI.Product_Code__c = objDP.Part_Number__c;
                            // objQLI.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            // lstQuoteLineItem.add(objQLI);
                            objDP.Non_Taxable__c = mapILI.get(objDP.Part_Number__c).Non_Taxable__c;
                            objDP.Quantity__c = mapILI.get(objDP.Part_Number__c).Quantity__c;
                            lstDealerOptionWraper.add(new DealerOptionWraper(true, objDP, false));
                            dealerOptionTotal += (objDP.Retail_Price__c * objDP.Quantity__c);
                            
                        } else {
                            lstDealerOptionWraper.add(new DealerOptionWraper(false, objDP, false));
                        }
                    }
                    
                    if(objQuote3.BOATBUILDING__Quote_Line_Item__r.size() > 0){
                        for(BOATBUILDING__Quote_Line_Item__c objQuoteLineItem : objQuote3.BOATBUILDING__Quote_Line_Item__r) {
                            if(objQuoteLineItem.Product_Code__c != null){
                                if(objQuoteLineItem.BOATBUILDING__Option_Category__c.equalsIgnoreCase('Dealer Options')) {
                                    if(!ProductCodeForNonExistQuote.contains(objQuoteLineItem.Product_Code__c)) {
                                        dealerOptionTotal += (objQuoteLineItem.Total_Price__c * objQuoteLineItem.Quantity__c);
                                        BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
                                        objDOO.Name = objQuoteLineItem.BOATBUILDING__Name__c;
                                        objDOO.BOATBUILDING__Retail_Price__c = objQuoteLineItem.Total_Price__c;
                                        objDOO.Quantity__c = objQuoteLineItem.Quantity__c;
                                        objDOO.BOATBUILDING__Cost__c = objQuoteLineItem.BOATBUILDING__Dealer_Price__c;
                                        objDOO.BOATBUILDING__Part_Number__c = objQuoteLineItem.BOATBUILDING__Product_Code__c;
                                        objDOO.Non_Taxable__c = objQuoteLineItem.Non_Taxable__c;
                                        lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, false));
                                        
                                        // BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                                        // objQLI.Name = 'QLI';
                                        // objQLI.Name__c = objDOO.Name; 
                                        // objQLI.Product__c = objProduct.Id;
                                        // objQLI.Option_Category__c = 'Dealer Options';
                                        // objQLI.Total_Price__c = objDOO.Retail_Price__c;
                                        // objQLI.Date__c =  Date.today();
                                        // objQLI.Dealer_Price__c = objDOO.Cost__c;
                                        // objQLI.Product_Code__c = objDOO.Part_Number__c;
                                        // objQLI.Non_Taxable__c = objQuoteLineItem.Non_Taxable__c;
                                        
                                        // lstQuoteLineItem.add(objQLI);
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    totalPrice += dealerOptionTotal;  
                    
                }
                
            }
            
            //New Change For Quote Trailer and Engine
            
            if(objQuote3.Engine__c != null && objQuote3.Engine__r.Total_MSRP_Price__c != null) {
                QuoteEnginePrice = objQuote3.Engine__r.Total_MSRP_Price__c;
                totalPrice += QuoteEnginePrice;
                EngineInfo = true;
            }
            
            if(objQuote3.Trailer__c != null && objQuote3.Trailer__r.Total_MSRP_Price__c != null) {
                QuoteTrailerPrice = objQuote3.Trailer__r.Total_MSRP_Price__c;
                totalPrice += QuoteTrailerPrice;
                TrailerInfo = true;
            }
            System.debug('Debug for cwoRetailTotal:  '+cwoRetailTotal);
            totalPrice += cwoRetailTotal;
            System.debug('Debug for totalPrice:  '+totalPrice);
            totalPriceDealer += cwoDealerTotal;
            //--------------------------------------Quote to Boat Builder---------------------------------------//
        } catch(Exception ex) {
            SendEmailUtility.sendQuickEmail('BoatBuilderController : '+ex.getMessage() +'  :  '+ex.getLineNumber() + ' : '+ex.getStackTraceString() + ' : '+ex.getTypeName()+'---'+emailDebugBody);
            System.debug(ex.getMessage() +'  :  '+ex.getLineNumber());

        }
        
        
        List<RecordType> lstRecT = [SELECT          
                                    Id
                                    FROM    
                                    RecordType
                                    WHERE       
                                    DeveloperName = 'Boat_Manufacturer'
                                    AND
                                    SobjectType = 'BOATBUILDING__Manufacturer__c'
                                    LIMIT 
                                    1];
        lstManufacturepop.add(new SelectOption('', '--None--'));
        
        if(lstRecT.size() > 0) {                                        
            for(BOATBUILDING__Manufacturer__c objManufacturer : [Select Id, Name from BOATBUILDING__Manufacturer__c Where RecordTypeId =: lstRecT[0].Id LIMIT 990]){
                lstManufacturepop.add(new SelectOption(objManufacturer.id, objManufacturer.Name ));
            }
        }
        lstManufacturepop.add(new SelectOption('NEW', 'Create New...'));
        ManuName = '';
    } 
    
    public void getExistManuDetail() {
        if(selectedManufacturepop != null && selectedManufacturepop != '' && selectedManufacturepop != 'NEW') {
            ManuName = [Select Id, Name From BOATBUILDING__Manufacturer__c Where Id =: selectedManufacturepop].Name;
        } else {
            ManuName = '';
        }
    }
    public PageReference saveProduct() {
        Manufacturer__c objManu = new Manufacturer__c();
        if(String.isBlank(selectedManufacturepop)) {
            PageReference pg = new PageReference('/apex/Purchase_Item2?');
            pg.setRedirect(true);
            return pg;
        }
        if(selectedManufacturepop != '' && selectedManufacturepop == 'NEW') {
            
            if(ManuName != '') {
                objManu.Name = ManuName;
                if(objProductpop.M_Model_Variant__c != null && objProductpop.M_Model_Variant__c != '') {
                    objManu.Model_Variant__c = true;
                }
                List<RecordType> lstRecT = [SELECT          
                                            Id
                                            FROM    
                                            RecordType
                                            WHERE       
                                            DeveloperName = 'Boat_Manufacturer'
                                            AND
                                            SobjectType = 'BOATBUILDING__Manufacturer__c'
                                            LIMIT 
                                            1];
                objManu.RecordTypeId = lstRecT[0].Id;
                objManu.Manufacturer_name__c = ManuName;
                insert objManu;
                selectedManufacturepop = objManu.Id;
                
            }
        }
        if(String.isNotBlank(selectedManufacturepop) && selectedManufacturepop != 'NEW') {
            //selectedManufacture = selectedManufacturepop;
            //lstManufacture.add(new SelectOption(selectedManufacture, ManuName));
            //System.debug('>>>>>>>>lstManufacture: '+lstManufacture);
            //getYearAndModel();
            if(objProductpop.MModel2__c != null && objProductpop.M_Model_Variant__c  != null && objProductpop.M_Year__c != null) {
                
                List<Product__c> lstProduct = [Select Id, MModel2__c, M_Model_Variant__c, M_Year__c, Cost_Price__c, M_Boat_MSRP_PRICE__c, Product_Manufacturer__c From Product__c 
                                               Where MModel2__c =: objProductpop.MModel2__c AND
                                               M_Model_Variant__c =: objProductpop.M_Model_Variant__c AND
                                               M_Year__c =: objProductpop.M_Year__c AND
                                               Product_Manufacturer__c =: selectedManufacturepop];
                if(lstProduct.isEmpty()) {
                    
                    objProductpop.Product_Manufacturer__c = selectedManufacturepop;
                    objProductpop.Product_Type__c = ST;
                    
                    insert objProductpop;
                }
            }
        }
        System.debug('>>>>selectedType: '+ST);
        PageReference pg = new PageReference('/apex/Purchase_Item2?manuId='+selectedManufacturepop+'&SelectedType='+ST);
        pg.setRedirect(true);
        return pg;
    }
    public PageReference directToUsedBoat() {
        return new PageReference('/apex/BOATBUILDING__UsedBoatForm?ManuId='+selectedManufacture);
    } 
    
    public void getManufacturer() {
        lstManufacture = new List<SelectOption>();
        lstManufacture.add(new SelectOption('', '--None--' ));
        setModel = new List<SelectOption>();
        setModel.add(new SelectOption('', '--None--'));
        setYear = new List<SelectOption>();
        setYear.add(new SelectOption('', '--None--'));
        setModelVariant = new List<SelectOption>();
        setModelVariant.add(new SelectOption('', '--None--'));
        selectedModelVariant = '';
        selectedModel = '';
        selectedYear = '';
        selectedManufacture = '';
        if(selectedType != '0' ) {
            List<RecordType> lstRecT = [SELECT          
                                        Id
                                        FROM    
                                        RecordType
                                        WHERE       
                                        DeveloperName = 'Boat_Manufacturer'
                                        AND
                                        SobjectType = 'BOATBUILDING__Manufacturer__c'
                                        LIMIT 
                                        1];
            if(lstRecT.size() > 0) {                                        
                for(BOATBUILDING__Manufacturer__c objManufacturer : [Select Id, Name from BOATBUILDING__Manufacturer__c Where RecordTypeId =: lstRecT[0].Id AND BOATBUILDING__Boat_Builder__c = true LIMIT 990]){
                    lstManufacture.add(new SelectOption(objManufacturer.id, objManufacturer.Name ));
                }
            }
        } 
        
        if(ApexPages.currentPage().getParameters().get('SelectedType') != null && ApexPages.currentPage().getParameters().get('manuId') != null) {
            //selectedType = ApexPages.currentPage().getParameters().get('SelectedType');
            List<RecordType> lstRecT = [SELECT          
                                        Id
                                        FROM    
                                        RecordType
                                        WHERE       
                                        DeveloperName = 'Boat_Manufacturer'
                                        AND
                                        SobjectType = 'BOATBUILDING__Manufacturer__c'
                                        LIMIT 
                                        1];
            for(BOATBUILDING__Manufacturer__c objManufacturer : [Select Id, Name from BOATBUILDING__Manufacturer__c Where RecordTypeId =: lstRecT[0].Id AND Id =: ApexPages.currentPage().getParameters().get('manuId')]){
                lstManufacture.add(new SelectOption(objManufacturer.id, objManufacturer.Name ));
                selectedManufacture = objManufacturer.id;
                getYearAndModel();
            }
        } 
        
    } 
    
    
    
    //________________________Update Inventory_____________________//
    
    Set<String> invLineIdDlt = new Set<String>(); 
    public PageReference updateInventory(){
        try {
            if(totalPrice != null){
                objInventory2.Total_MSRP_Price__c = totalPrice;
            }
            if(totalPriceDealer != null){
                objInventory2.Total_Dealer_Price__c = totalPriceDealer;
            } 
            System.debug('>>>>>>totalPriceDealer: '+totalPriceDealer);
            update objInventory2;
            if(!invLineIdDlt.isEmpty()) {
                delete [Select Id From BOATBUILDING__Inventory_Line_Item__c Where Id IN: invLineIdDlt];
                for(Integer i = 0; i < lstInventoryLineItem.size(); i++) {
                    if(lstInventoryLineItem[i].Id != null && invLineIdDlt.contains(lstInventoryLineItem[i].Id)) {
                        lstInventoryLineItem.remove(i);
                    }
                }
            }
            if(!objInventory2.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
                List<BOATBUILDING__Inventory_Line_Item__c> lstILII = new List<BOATBUILDING__Inventory_Line_Item__c>(); 
                for(DealerOptionWraper objDP :lstDealerOptionWraper) {
                    System.debug('objDP: '+objDP);
                    for(BOATBUILDING__Inventory_Line_Item__c objILIU: objInventory2.BOATBUILDING__Inventory_Line_Items__r) {
                        System.debug('objILIU: '+objILIU);
                        if(objDP.objDealerOption.Part_Number__c == objILIU.BOATBUILDING__Product_Code__c && !invLineIdDlt.contains(objILIU.Id)) {
                            objILIU.Non_Taxable__c = objDP.Non_Taxable;
                            lstILII.add(objILIU);
                        }
                    }
                }
                update lstILII;
            }
            if(!lstInventoryLineItem.isEmpty()) {
                for(BOATBUILDING__Inventory_Line_Item__c objILIU: lstInventoryLineItem) {
                    if(objILIU.BOATBUILDING__Related_to_Inventory__c == null) 
                    {
                        objILIU.BOATBUILDING__Related_to_Inventory__c = objInventory2.Id;
                    }
                }
                System.debug('lstDealerOptionWraper: '+lstDealerOptionWraper);
                for(DealerOptionWraper objDP :lstDealerOptionWraper) {
                    System.debug('objDP: '+objDP);
                    for(BOATBUILDING__Inventory_Line_Item__c objILIU: lstInventoryLineItem) {
                        System.debug('objILIU: '+objILIU);
                        if(objDP.objDealerOption.Part_Number__c == objILIU.BOATBUILDING__Product_Code__c) {
                            objILIU.Non_Taxable__c = objDP.Non_Taxable;
                        }
                    }
                }
                
                

                upsert lstInventoryLineItem;
            }
        } catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex);
            return null;
        }
        return new PageReference('/'+objInventory2.Id);
    }
    
    
    
    public String quoteImg1 { get; set; }
    public String quoteImg2 { get; set; }
    public boolean showDiscount { get; set; }
    public string BoatDis{get; set;}
    
    
    public BOATBUILDING__Store_Location_Config__mdt objSLC1 { get; set; }   
    public BOATBUILDING__Store_Location_Config__mdt objSLC2 { get; set; }
    public BOATBUILDING__Store_Location_Config__mdt objSLC3 { get; set; } 
    public String website { get; set; }
    public String CompanyBanner { get; set; }
    public String width { get; set; }
    public PageReference generateQuoteFromPrint(){
        try {
            width = '100';
            
            BOATBUILDING__System_Configure__c objSCC = BOATBUILDING__System_Configure__c.getOrgDefaults();
            if(objSCC != null && objSCC.BOATBUILDING__Quote_Pdf_Width__c != null) {
                width = String.valueOf(objSCC.BOATBUILDING__Quote_Pdf_Width__c);
            }
            objSLC1 = new BOATBUILDING__Store_Location_Config__mdt();
            objSLC2 = new BOATBUILDING__Store_Location_Config__mdt();
            objSLC3 = new BOATBUILDING__Store_Location_Config__mdt();
            website = '';
            CompanyBanner = '';
            Map<String, BOATBUILDING__Template_WhyBuyFromUS__c> mpTWBFS = BOATBUILDING__Template_WhyBuyFromUS__c.getAll();
            if(mpTWBFS != null && mpTWBFS.keySet().size() > 0) {
                website = mpTWBFS.values()[0].BOATBUILDING__Company_Website__c;
            }
            yearForQuotePDF = '';
            modelForQuotePDF = '';
            modelVarForQuotePDF = '';
            quoteImg1 = '';
            quoteImg2 = '';
            showDiscount = false;
            if(objQuote2.Id == null || objQuote2.Id == '') {
                List<BOATBUILDING__Store_Location_Config__mdt> lstSLC = [Select 
                                                                         Id, MasterLabel, DeveloperName, BOATBUILDING__Street__c, BOATBUILDING__Phone__c,
                                                                         BOATBUILDING__City__c, BOATBUILDING__State__c, BOATBUILDING__Country__c, 
                                                                         BOATBUILDING__Zip_Postal_Code__c, BOATBUILDING__Priority__c 
                                                                         From    
                                                                         BOATBUILDING__Store_Location_Config__mdt 
                                                                         Order By 
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
                    if(lstSLC.size() > 2) {
                        objSLC3 = lstSLC[2];
                        if(String.isNotBlank(objSLC2.City__c)) {
                            objSLC3.City__c += ',';
                        }
                        if(String.isNotBlank(objSLC2.State__c)) {
                            objSLC3.State__c += ',';
                        }
                    }
                }
                objQuote2 = [Select 
                             q.Engine__c,
                             q.GST__c,
                             q.PST__c,
                             q.GST_D__c,
                             q.PST_D__c,
                             q.Trailer__c,
                             q.Engine__r.Total_MSRP_Price__c,
                             q.Engine__r.Manufacturer__c,
                             q.Engine__r.Model__c,
                             q.Engine__r.Year__c,
                             q.Engine__r.Engine_SN__c,
                             q.Engine__r.Serial_Number_2__c,
                             q.Engine__r.Transmission_Gearbox_SN__c,
                             q.Trailer__r.Total_MSRP_Price__c,
                             q.Trailer__r.Manufacturer__c,
                             q.Trailer__r.Model__c,
                             q.Trailer__r.Year__c, 
                             q.Trailer__r.Trailer_Axles__c, 
                             q.Trailer__r.Trailer_VIN__c, Tyre_Tax__c,
                             Account_Name__r.BOATBUILDING__Trade_Lien_Bank__c, Account_Name__r.BOATBUILDING__Trade_Pay_Off__c, 
                             q.Show_MSRP_Option_Pricing__c,
                             q.BOATBUILDING__Dealer_Discount__c,
                             q.State__c, q.Tax__c, q.SystemModstamp, q.Syncing__c, q.Account_Name__r.Name, Contact_Name__r.Name, q.Test_2__r.Name,q.Test_2__r.Engine_Make__c, q.Test_2__r.Engine_Year__c, q.Test_2__r.Engine_Model__c, q.Test_2__r.Serial_Number_2__c , Q.Test_2__r.BOATBUILDING__Engine_SN__c,
                             q.Status__c,q.Quote_Total_Price_Calculated__c , q.Shipping_And_Handling__c, q.Ship_To__c, q.Ship_To_Name__c, q.Related_to_Order__c,q.Discount_On_Quote__c, q.Related_to_Product__c,q.Test_2__r.Trailer_Make__c,q.Test_2__r.Trailer_Model__c,q.Test_2__r.Trailer_VIN__c,q.Test_2__r.Trailer_Year__c,
                             q.Quote_Trailer_Sales_Tax__c, q.Quote_Trailer_Reg_Fee__c,q.Mapped_Boat_Length__c , q.Mapped_Engine_SN__c, q.Mapped_HIN__c, q.Mapped_Trailer_VIN__c, q.Transmission_Gearbox_SN__c,q.Dealer_Comments_and_Notes__c, q.Test_2__r.Trailer_Axles__c, Q.Test_2__r.Transmission_Gearbox_SN__c, 
                             q.Quote_Trailer_Allowance__c,q.Quote_Your_Price_Formula__c ,q.Quote_Total_Over_Allowance_Calculated__c ,q.Quote_Net_Selling_Price_Calculated__c ,q.Boat_Sales_Tax2__c ,q.Quote_Trailer_ACV__c, q.Quote_Trade_Payoff__c, q.Quote_Trade_Allowance__c,
                             q.Quote_Total_Amount_Financed_Calculated__c , q.Quote_To_Name__c, q.Quote_To_Address__c, q.Quote_Trade_ACV__c,CO_Buyer_Name__r.Name, CO_Buyer_Name__c,  CO_Buyer_Name__r.MailingCity,
                             q.Quote_Term__c, q.Quote_Rate__c, q.Quote_Payment__c,q.Total_Price_Quote__c, q.Quote_Number__c, q.Quote_MSRP_Trailer_Price__c, 
                             q.Quote_MSRP_Boat_Price__c, q.Quote_Down_Payment__c, q.Quote_Doc_Fee__c, q.Quote_Deal_Margin__c, q.Quote_Cost_Clone__c, q.Test_2__c,
                             q.Quote_Total_MSRP__c , q.Quote_Boat_Reg_Fee__c,q.Dealer_Disclaimer__c,  
                             q.ACV_FORM__r.Boat_Make__c, q.ACV_FORM__r.Boat_Model__c, q.ACV_FORM__r.Boat_Year__c, q.ACV_FORM__r.Boat_HIN__c, q.ACV_FORM__r.Engine_SN__c,  q.ACV_FORM__r.BOATBUILDING__Trailer_Axles__c,  q.ACV_FORM__r.BOATBUILDING__Trailer_Make__c, q.ACV_FORM__r.BOATBUILDING__Trailer_Model__c,
                             q.Phone__c, q.OwnerId,q.Quote_Sale_Price__c, q.Name, q.LastViewedDate, q.LastReferencedDate, q.LastModifiedDate, q.LastModifiedById,q.ACV_FORM__r.BOATBUILDING__Trailer_Vin__c, q.ACV_FORM__r.BOATBUILDING__Engine_Model__c,
                             q.LastActivityDate, q.IsDeleted, q.Id, q.Grand_Total__c,  q.Fax__c, q.Expiration_Date__c, q.Email__c, q.No_Trailer__c, 
                             q.Discount__c, q.Description__c,q.CreatedDate, q.CreatedById, q.Contact_Name__c, q.Bill_To__c, q.Bill_To_Name__c, q.Additional_To__c, Store_Location__c, 
                             q.Additional_To_Name__c, q.Account_Name__c,(Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                                                         SystemModstamp, LastActivityDate, Date__c, Discount__c, Line_Item_Description__c, List_Price__c, Product__c, Product_Code__c, Quantity__c, BOATBUILDING__Product_Type__c,
                                                                         Quote__c, Sales_Price__c, Sub_Total__c, Total_Price__c, Option_Category__c, Name__c, BOATBUILDING__Total_Dealer_Price__c, BOATBUILDING__Total_Retail_Price__c From BOATBUILDING__Quote_Line_Item__r) From BOATBUILDING__Quote__c q where q.Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];

                
                system.debug('>>>>>>>###'+objQuote2.ACV_FORM__r.Boat_HIN__c);
                if(objQuote2.Trailer__c != null) {
                    TrailerInfoQuote = true;
                }
                
                if(objQuote2.Engine__c != null) {
                    EngineInfoQuote = true;
                }
                
                if(objQuote2.BOATBUILDING__State__c != null) {
                    BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objQuote2.BOATBUILDING__State__c); 
                    isCanadian = objBoatBuilderUtil.isCanadianTax();
                }

                BoatDis = '';  
                System.debug('Debug Log for Disclaimer: '+objQuote2.BOATBUILDING__Dealer_Disclaimer__c);
                if(String.isNotBlank(objQuote2.BOATBUILDING__Dealer_Disclaimer__c)){
                    //BOATBUILDING__System_Configure__c objBoatSymCon = BOATBUILDING__System_Configure__c.getOrgDefaults();

                    List<BOATBUILDING__Store_Location_Config__mdt> lstSLCDis = [Select Id, MasterLabel, BOATBUILDING__New_Boat_Disclaimer__c, BOATBUILDING__Used_Boat_Disclaimer__c From BOATBUILDING__Store_Location_Config__mdt ORDER BY BOATBUILDING__Priority__c ASC];

                    /*if(objBoatSymCon != null) {
                        if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('New Boat Disclaimer'))
                        {
                            BoatDis = objBoatSymCon.BOATBUILDING__New_Boat_Disclaimer__c;
                        }
                        else if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('Used Boat Disclaimer'))
                        {
                            BoatDis = objBoatSymCon.BOATBUILDING__Used_Boat_Disclaimer__c;
                        }
                    }*/
                     
                    if(!lstSLCDis.isEmpty()) {
                        if(String.isNotBlank(objQuote2.BOATBUILDING__Store_Location__c)) {
                            if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('New Boat Disclaimer'))
                            {
                                for(BOATBUILDING__Store_Location_Config__mdt objSLC: lstSLCDis) {
                                    if(objSLC.MasterLabel == objQuote2.BOATBUILDING__Store_Location__c && String.isNotBlank(objSLC.BOATBUILDING__New_Boat_Disclaimer__c)) {
                                        BoatDis = objSLC.BOATBUILDING__New_Boat_Disclaimer__c;
                                        break;
                                    }
                                }
                            }
                            else if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('Used Boat Disclaimer'))
                            {
                                //BoatDis = objBoatSymCon.BOATBUILDING__Used_Boat_Disclaimer__c;
                                for(BOATBUILDING__Store_Location_Config__mdt objSLC: lstSLCDis) {
                                    if(objSLC.MasterLabel == objQuote2.BOATBUILDING__Store_Location__c && String.isNotBlank(objSLC.BOATBUILDING__Used_Boat_Disclaimer__c)) {
                                        BoatDis = objSLC.BOATBUILDING__Used_Boat_Disclaimer__c;
                                        break;
                                    }
                                }
                            }
                            
                        }
                        
                        if(String.isBlank(BoatDis)) {
                            String defaultVal = ''; 
                            Schema.DescribeFieldResult F = BOATBUILDING__Quote__c.BOATBUILDING__Store_Location__c.getDescribe(); 
                            List <Schema.PicklistEntry> pickVals = F.getPicklistValues();         
                            for (Schema.PicklistEntry pv: pickVals) {     
                                if (pv.isDefaultValue()) {         
                                    defaultVal = pv.getValue();     
                                }     
                            }
                            if(String.isNotBlank(defaultVal)) {
                                if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('New Boat Disclaimer'))
                                {
                                    for(BOATBUILDING__Store_Location_Config__mdt objSLC: lstSLCDis) {
                                        if(objSLC.MasterLabel == defaultVal && String.isNotBlank(objSLC.BOATBUILDING__New_Boat_Disclaimer__c)) {
                                            BoatDis = objSLC.BOATBUILDING__New_Boat_Disclaimer__c;
                                            break;
                                        } 
                                    }
                                }
                                else if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('Used Boat Disclaimer'))
                                {
                                    //BoatDis = objBoatSymCon.BOATBUILDING__Used_Boat_Disclaimer__c;
                                    for(BOATBUILDING__Store_Location_Config__mdt objSLC: lstSLCDis) {
                                        if(objSLC.MasterLabel == defaultVal && String.isNotBlank(objSLC.BOATBUILDING__Used_Boat_Disclaimer__c)) {
                                            BoatDis = objSLC.BOATBUILDING__Used_Boat_Disclaimer__c;
                                            break; 
                                        }
                                    }
                                }
                            }
                        }
                        if(String.isBlank(BoatDis)) {
                            if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('New Boat Disclaimer') && String.isNotBlank(lstSLCDis[0].BOATBUILDING__New_Boat_Disclaimer__c)) 
                            {
                                BoatDis = lstSLCDis[0].BOATBUILDING__New_Boat_Disclaimer__c; 
                            } 
                            else if(objQuote2.BOATBUILDING__Dealer_Disclaimer__c.equalsIgnoreCase('Used Boat Disclaimer') && String.isNotBlank(lstSLCDis[0].BOATBUILDING__Used_Boat_Disclaimer__c)) 
                            {
                                BoatDis = lstSLCDis[0].BOATBUILDING__Used_Boat_Disclaimer__c;
                            }
                        }

                    }
                }
                
                
                String DocName = 'Company_Logo';
                if(objQuote2.Store_Location__c != null) {
                    DocName = DocName + '_' + objQuote2.Store_Location__c.replaceAll(' ','');
                }
                List<Document> lstDoc = [SELECT Id FROM Document Where DeveloperName =: DocName LIMIT 1];
                if(lstDoc.size() > 0) {
                    strDocId = String.valueOf(lstDoc[0].Id);
                } else {
                    List<Document> lstDoc2 = [SELECT Id FROM Document Where DeveloperName = 'Company_Logo' LIMIT 1];
                    if(lstDoc2.size() > 0) {
                        strDocId = String.valueOf(lstDoc2[0].Id);
                    }
                }
                //CompanyBanner
                List<Document> lstDocBanner = [Select Id From Document Where DeveloperName = 'VFTemplateLogoBlack'];
                if(!lstDocBanner.isEmpty()) {
                    CompanyBanner = lstDocBanner[0].Id;
                }
                
                if(objQuote2.Discount_On_Quote__c != null && objQuote2.Discount_On_Quote__c > 0) {
                    showDiscount = true;    
                } 
                
                if(objQuote2.CO_Buyer_Name__c == null) {
                    checkBoxExist = false;
                }
                
                if(objQuote2.No_Trailer__c == true) {
                    noTrailer = false;
                } else { 
                    noTrailer = true;
                }
                
                
                
                if(objQuote2.Test_2__c != null){
                    // isSideContent = false;
                    // isBowContent = false;
        
                    List<ContentDocumentLink> lstContentDocLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =: objQuote2.Test_2__c];
                    Map<String, String> mapCDID_LEID = new Map<String, String>(); 
                    for(ContentDocumentLink cdl: lstContentDocLink){
                        System.debug('Debug Log For lstContentDocLink cdl : '+cdl.ContentDocumentId);
                        mapCDID_LEID.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                    }
        
                    List<ContentVersion> lstContentVersion = [select id,FileType, Title,FileExtension, Versiondata, ContentDocumentId from ContentVersion where islatest = true AND ContentDocumentId IN : mapCDID_LEID.keySet()];
                    for(ContentVersion objAtt: lstContentVersion) {
                        System.debug('Debug Log For lstContentVersion objAtt : '+objAtt.Id);
        
                        if(objAtt.Title.containsIgnoreCase('side__c')) {
                            isSideContent = true;
                            quoteImg1 = objAtt.Id;
                        }
                        if(objAtt.Title.containsIgnoreCase('bow__c')) {
                            isBowContent = true;
                            quoteImg2 = objAtt.Id;
                        } 
        
                    }
        
                    List<Attachment> att = [Select Id, Name From Attachment Where ParentId =: objQuote2.Test_2__c];
                    if(att.size() > 0 && ( !isSideContent || !isBowContent )) {
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
                        objInventory2 = [SELECT Manufacturer__c, BOATBUILDING__Engine_1_SN__c, BOATBUILDING__Engine_2_SN__c, BOATBUILDING__Engine_3_SN__c, BOATBUILDING__Engine_4_SN__c,Year__c, Model__c, Model_Variant__c FROM BOATBUILDING__Inventory__c WHERE Id =: objQuote2.Test_2__c LIMIT 1];
                    }
                    if(objInventory2.Id != null) {
                        if(objInventory2.Manufacturer__c != null) getManufacturerName =  objInventory2.Manufacturer__c;
                        if(objInventory2.Year__c != null) yearForQuotePDF = objInventory2.Year__c;
                        if(objInventory2.Model__c != null) modelForQuotePDF = objInventory2.Model__c;
                        if(objInventory2.Model_Variant__c != null) modelVarForQuotePDF = objInventory2.Model_Variant__c;
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
                
                Map<String, List<Quote_Line_Item__c>> mapQuoteLineItem = new Map<String, List<Quote_Line_Item__c>>();
                Map<String, List<Quote_Line_Item__c>> mapQuoteLineItem1 = new Map<String, List<Quote_Line_Item__c>>();
                List<String> lstQLITSort = new  List<String>();
                if(objQuote2.BOATBUILDING__Quote_Line_Item__r != null && objQuote2.BOATBUILDING__Quote_Line_Item__r.size() > 0) {
                    for(BOATBUILDING__Quote_Line_Item__c objQLI2 :  objQuote2.BOATBUILDING__Quote_Line_Item__r) {
                        if(!mapQuoteLineItem.containsKey(objQLI2.Option_Category__c)){
                            mapQuoteLineItem.put(objQLI2.Option_Category__c, new List<Quote_Line_Item__c>());
                        }
                        if(mapQuoteLineItem.containsKey(objQLI2.Option_Category__c)) {
                            mapQuoteLineItem.get(objQLI2.Option_Category__c).add(objQLI2);
                        }
                    } 
                   /* lstQLITSort.addAll(mapQuoteLineItem.keySet());
                    system.debug('<><><><><><>B'+lstQLITSort);
                    lstQLITSort.sort();
                    system.debug('<><><><><><>A'+lstQLITSort); */
                    for(String srtQuoteMapKeys : mapQuoteLineItem.keySet()) {
                       // for(String srtQuoteMapKeys : lstQLITSort) {
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
                       
                        if(ModVal == 1) {
                            for(Integer i = 0; i <= MidVal; i++) {
                                lstQLIDis1.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                            }
                            for(Integer i = MidVal + 1; i < objQuote2.BOATBUILDING__Quote_Line_Item__r.size(); i++) {
                                lstQLIDis2.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                            }
                        }
                        else if(ModVal == 0) {
                            for(Integer i = 0; i < MidVal; i++) {
                                lstQLIDis1.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                            }
                            for(Integer i = MidVal; i < objQuote2.BOATBUILDING__Quote_Line_Item__r.size(); i++) {
                                lstQLIDis2.add(new QuoteOptionCatagoryWrapper(lstString[i], mapQuoteLineItem1.get(lstString[i]) ));
                            }
                        }
                        
                    }
                    
                }
                System.debug('Debug Log For mapQuoteLineItem : '+mapQuoteLineItem);
                return new PageReference('/apex/BOATBUILDING__Quote_As_PDF_Example?scontrolCaching=1&id='+objQuote2.Id);
            }else{
                return null;
            }  
        } catch(Exception ex) {
            //SendEmailUtility.sendQuickEmail(ex.getStackTraceString()+'--'+ex.getMessage()+'---'+ex.getLineNumber() + ' : '+objQuote2);
            System.debug(ex.getStackTraceString()+'--'+ex.getMessage()+'---'+ex.getLineNumber() + ' : '+objQuote2);
            return null;
        }
    }
    
    
    public PageReference getYearAndModel(){
        
        setYear.clear();
        setYear.add(new SelectOption('', '--None--'));
        setModel.clear();
        setModel.add(new SelectOption('', '--None--'));
        selectedYear = '';
        selectedModel = '';
        if(selectedManufacture != null) {
            
            /*if(selectedType == 'Trailer') {

List<BOATBUILDING__Product__c> lstProduct = [Select Id, M_Year__c From BOATBUILDING__Product__c Where Product_Manufacturer__c =: selectedManufacture limit 49000];

for(BOATBUILDING__Product__c obj : lstProduct) {
if(obj.M_Year__c != null && obj.M_Year__c != '') {
setYear.add(new SelectOption(obj.Id, String.valueOf(obj.M_Year__c)));
}
}
} else (selectedType != 'Trailer') {*/
            
            List<BOATBUILDING__Manufacturer__c> lstManu = [SELECT Model_Variant__c FROM BOATBUILDING__Manufacturer__c WHERE Id =: selectedManufacture LIMIT 1];
            if(lstManu.size() > 0) {
                modelVarientFlag = lstManu[0].Model_Variant__c;
                System.debug('Debug Log For modelVarientFlag : '+modelVarientFlag);
            }
            //List<Schema.PicklistEntry> fieldResult = BOATBUILDING__Product__c.M_Year__c.getDescribe().getPicklistValues();
            List<BOATBUILDING__Product__c> lstProduct = [Select Id, M_Year__c From BOATBUILDING__Product__c Where Product_Manufacturer__c =: selectedManufacture AND Product_Type__c =: selectedType limit 49000];
            Set<String> setyr = new Set<String>();
            for(BOATBUILDING__Product__c obj : lstProduct) {
                if(obj.M_Year__c != null && obj.M_Year__c != '') {
                    setyr.add(obj.M_Year__c);
                }
            }
            List<Integer> lst = new List<Integer>();
            
            for(String f : setyr){
                lst.add(Integer.valueOf(f)); 
            }
            //lst.sort();
            
            Integer num = lst.size();
            Integer temp, i, j;
            
            for (i = 0; i < ( num - 1 ); i++) {
                for (j = 0; j < num - i - 1; j++) {
                    if (lst[j] < lst[j+1]) 
                    {
                        temp = lst[j]; 
                        lst[j] = lst[j+1]; 
                        lst[j+1] = temp;
                    }
                }
            }
            for(Integer f : lst){
                setYear.add(new SelectOption(String.valueOf(f), String.valueOf(f))); 
            }
            
            
            List<BOATBUILDING__Product__c> lstProductModel = new List<BOATBUILDING__Product__c>();
            if(selectedYear != null){
                lstProductModel = [Select Id, MModel2__c From BOATBUILDING__Product__c where Product_Manufacturer__c =: selectedManufacture AND Product_Type__c =: selectedType  AND M_Year__c =: selectedYear];
            }
            
            if(lstProductModel.size() > 0){
                for(BOATBUILDING__Product__c objProduct : lstProductModel ){
                    if(objProduct.MModel2__c != null && objProduct.MModel2__c != ''){
                        setModel.add(new SelectOption(objProduct .Id, objProduct.MModel2__c));
                    }
                }
            }
        }else{
            setYear.clear();
            setYear.add(new SelectOption('', '--None--'));
            setModel.clear();
            setModel.add(new SelectOption('', '--None--'));
            selectedYear = '';
            selectedModel = '';
        }
        System.debug('Debug Log For modelVarientFlag : '+modelVarientFlag);
        if(selectedManufacture != null){
            strSupraName = [Select Name From BOATBUILDING__Manufacturer__c where Id =: selectedManufacture limit 1].Name;
            if(modelVarientFlag){
                nameCheck = true;
            }else{
                nameCheck = false;
            }
            //}
            
        }
        return null;
    }
    
    public PageReference getModel() {
        System.debug('Hello_Model________________ : '+ selectedYear );
        setModel.clear();
        setModel.add(new SelectOption('', '--None--'));
        selectedModel = '';
        
        //if(selectedType != 'Trailer') {
        
        if(selectedYear != null) {
            
            List<BOATBUILDING__Product__c> lstProductModel = [Select Id, MModel2__c From BOATBUILDING__Product__c where M_Year__c =: selectedYear AND Product_Manufacturer__c =: selectedManufacture AND Product_Type__c =: selectedType ORDER BY CreatedDate ASC];
            
            if(lstProductModel.size()>0){
                if(modelVarientFlag){
                    for(BOATBUILDING__Product__c objPro : lstProductModel){
                        if(objPro.MModel2__c != null){
                            setModelV.add(objPro.MModel2__c);
                        }
                    }
                    for(String strModelName : setModelV){
                        setModel.add(new SelectOption(strModelName, strModelName)); 
                    }
                    setModelV.clear(); 
                }else {
                    for(BOATBUILDING__Product__c objProduct : lstProductModel ){
                        if(objProduct.MModel2__c != null){
                            setModel.add(new SelectOption(objProduct .Id, objProduct.MModel2__c));
                        }
                    }       
                }
            }
        }else{
            selectedModel = '';
            setModel.clear();
            setModel.add(new SelectOption('', '--None--'));
        }
        //} 
        /*else {
if(selectedYear != null) {

List<BOATBUILDING__Product__c> lstProductModel = [Select Id, MModel2__c From BOATBUILDING__Product__c where M_Year__c =: selectedYear AND Product_Manufacturer__c =: selectedManufacture ORDER BY CreatedDate ASC];

if(lstProductModel.size()>0){
for(BOATBUILDING__Product__c objProduct : lstProductModel ){
if(objProduct.MModel2__c != null){
setModel.add(new SelectOption(objProduct .Id, objProduct.MModel2__c));
}
}     
}
}else{
selectedModel = '';
setModel.clear();
setModel.add(new SelectOption('', '--None--'));
}
}*/
        return null; 
    }
    
    public PageReference getModelVariant() { 
        System.debug('Debug Log For selectedModel : '+ selectedModel);
        if(selectedModel != null && modelVarientFlag){
            setModelVariant.clear();
            setModelVariant.add(new SelectOption('', '--None--'));
            List<BOATBUILDING__Product__c> lstProductModelVrnt = [Select Id, M_Model_Variant__c From BOATBUILDING__Product__c where MModel2__c =: selectedModel AND M_Year__c =: selectedYear AND Product_Manufacturer__c =: selectedManufacture AND Product_Type__c =: selectedType];
            for(BOATBUILDING__Product__c objProduct : lstProductModelVrnt ){
                if(objProduct.M_Model_Variant__c != null){
                    setModelVariant.add(new SelectOption(objProduct.Id, objProduct.M_Model_Variant__c));
                }
            }        
        }else{
            selectedModelVariant = '';
            setModelVariant.clear();
            setModelVariant.add(new SelectOption('', '--None--'));
        }
        System.debug('Debug Log For setModelVariant : '+ setModelVariant);
        return null;
    }
    
    //On First Page
    public Pagereference secondPage(){
        return null;
    }
    
    public PageReference cancelPage() {
        return new PageReference('/home/home.jsp');
    }
    
    
    //On Second Page
    public PageReference callFirstPage() {
        return new PageReference('/apex/BOATBUILDING__Purchase_Item2');
    }
    
    
    
    public PageReference callThirdPage(){
        
        if(selectedManufacture != null){
            BOATBUILDING__Manufacturer__c objManufacurer = [Select Id, Name from BOATBUILDING__Manufacturer__c where Id =: selectedManufacture limit 1];
            selectedManufacturerSecondPage = String.valueOf(objManufacurer.Name);
        }
        
        selectedYearSecondPage = selectedYear; 
        //if(selectedType != 'Trailer') {
        if(!modelVarientFlag) {
            if(selectedModel != null){
                System.debug('>>>>>>>>>>>>>selectedModel'+selectedModel);
                objProduct = [Select SystemModstamp,Trailer_VIN__c, Boat_Length_in_feets__c,Transmission_Gearbox_SN__c,Sale_Price__c,  State__c,M_Manufacturer1__c,Product_Short_Description__c, Product_Manufacturer__c, Product_Long_Description__c,
                              Part_Number__c, Name, M_Year__c,  Engine_SN__c,Trailer_Trade_Over_Allowance_Calculated__c, M_Trailer_Trade_Allowance__c, 
                              M_Trailer_Sales_Tax__c, M_Model_Variant__c,M_Dealer_Discount__c,M_Dealer_COD_Discount__c,M_Dealer_Flat_Discount__c,
                              M_Trailer_Reg_Fee__c, M_Trailer_MSRP_PRICE__c, M_Trailer_Actual_Cost_Value_ACV__c, M_Trade_PayOFF__c, 
                              M_Total_Price_Calculated__c, M_Total_Over_Allowance_Calculated__c, M_Deal_Margin__c,M_Total_MSRP__c, M_Total_Due__c, M_Total_Amount_Financed_Calculated__c,
                              M_Finance_Term__c,M_Rfinance_Rate__c, M_Retail_Price__c, M_Quantity__c, Freight__c,  
                              M_Product_Family__c,  M_Payment__c, M_Dealer_Base_Price__c, 
                              MModel2__c,  M_Manufacture_Status__c, M_Hidden_Box__c,  M_Down_Payment__c,M_Doc_Fee__c, M_Discount__c, M_Description__c,  M_Dealer_Stock__c,
                              M_Dealer_Status__c, Prep__c,  M_Dealer_Comments__c,  M_Boat_Trade_Over_Allowance_Calculated__c, 
                              M_Boat_Trade_Allowance__c, M_Boat_Sales_Tax_Calculated__c, M_Boat_Reg_Fee__c, M_Boat_MSRP_PRICE__c, M_Boat_Actual_Cost_Value_ACV__c, M_Net_Selling_Price_Calculated__c, LastViewedDate, LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, Id, 
                              Hull_Id__c, Dealer__c, Cost_Price__c, M_Your_Price_Calculated__c, M_Product_Salesperson_new__c From BOATBUILDING__Product__c p where id =: selectedModel limit 1];
            }
        } else if(modelVarientFlag) {
            if(selectedModelVariant != null){
                System.debug('>>>>>>>>>>>>>selectedModelVariant'+selectedModelVariant);
                objProduct = [Select SystemModstamp, Trailer_VIN__c,Sale_Price__c, M_Manufacturer1__c,Boat_Length_in_feets__c ,Transmission_Gearbox_SN__c,Product_Short_Description__c,State__c, Product_Manufacturer__c, Product_Long_Description__c,
                              Part_Number__c, Name,M_Model_Variant__c ,Engine_SN__c, M_Year__c,  Trailer_Trade_Over_Allowance_Calculated__c, M_Trailer_Trade_Allowance__c, 
                              M_Trailer_Sales_Tax__c, M_Trailer_Reg_Fee__c,M_Dealer_Discount__c,M_Dealer_COD_Discount__c,M_Dealer_Flat_Discount__c,
                              M_Trailer_MSRP_PRICE__c, M_Trailer_Actual_Cost_Value_ACV__c, M_Trade_PayOFF__c,M_Finance_Term__c,M_Total_Price_Calculated__c, M_Total_Over_Allowance_Calculated__c, M_Deal_Margin__c,M_Total_MSRP__c, M_Total_Due__c, M_Total_Amount_Financed_Calculated__c,  
                              M_Rfinance_Rate__c, M_Retail_Price__c, M_Hidden_Box__c, M_Quantity__c, Freight__c, M_Product_Family__c,  M_Payment__c,
                              MModel2__c,  M_Manufacture_Status__c,   M_Down_Payment__c, M_Dealer_Base_Price__c,
                              M_Doc_Fee__c, M_Discount__c, M_Description__c,  M_Dealer_Stock__c,
                              M_Dealer_Status__c, Prep__c,   M_Dealer_Comments__c,  M_Boat_Trade_Over_Allowance_Calculated__c, 
                              M_Boat_Trade_Allowance__c, M_Boat_Sales_Tax_Calculated__c, M_Boat_Reg_Fee__c, M_Boat_MSRP_PRICE__c, M_Boat_Actual_Cost_Value_ACV__c,
                              
                              M_Net_Selling_Price_Calculated__c, LastViewedDate, LastReferencedDate, LastModifiedDate, LastModifiedById, LastActivityDate, Id, 
                              Hull_Id__c, Dealer__c, Cost_Price__c, M_Your_Price_Calculated__c, M_Product_Salesperson_new__c From BOATBUILDING__Product__c p where id =: selectedModelVariant limit 1];
                if(objProduct.M_Model_Variant__c != null){              
                    smVrnt =  objProduct.M_Model_Variant__c;  
                }            
            }
        }
        if(objProduct.Id != null){
            selectedModelSecondPage = String.valueOf(objProduct.MModel2__c);
            manufacturerStatus = String.valueOf(objProduct.M_Manufacture_Status__c);
            dealerStatus = String.valueOf(objProduct.M_Dealer_Status__c);
            if(objProduct.M_Boat_MSRP_PRICE__c == null ){
                yourPriceThirdPageForProductPrice = 0.00;
            }else{
                yourPriceThirdPageForProductPrice = objProduct.M_Boat_MSRP_PRICE__c;
            } 
            if(objProduct.Cost_Price__c != null){
                yourPriceThirdPageForProductPriceDealer = objProduct.Cost_Price__c;
            }else{
                yourPriceThirdPageForProductPriceDealer = 0.00;
            }
            
            if(selectedType == 'New Boat' ||  selectedType == 'Used Boat') { 
                if(!modelVarientFlag) {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManufacture, selectedYear, 'New Boats').getSelectedCatagory();
                }else if(modelVarientFlag) {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManufacture, selectedYear, 'New Boats').getSelectedCatagory();
                } 
            } else if(selectedType == 'Trailer' ||  selectedType == 'Engine') {
                if(!modelVarientFlag) {  
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManufacture, selectedYear, selectedType).getSelectedCatagory();
                }else if(modelVarientFlag) {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManufacture, selectedYear, selectedType).getSelectedCatagory();
                }
            }
            
            List<CheckBoxWraper> lstCheckBoxWraper;
            
            for(String strMapValues : mapSelectedCategory.keySet()){
                lstCheckBoxWraper = new List<CheckBoxWraper>();
                for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                    lstCheckBoxWraper.add(new CheckBoxWraper(false,lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                }
                mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
            }
            
            for(String strMapValues : mapCheckBoxWraper.keySet()){
                System.debug('>>>>>>>>>> mapCheckBoxWraperstrMapValues: '+strMapValues);
            }

            System.debug('Debug Log for mapCheckBoxWraper:' +mapCheckBoxWraper.size());
            System.debug('Debug Log for mapSelectedCategory:' +mapSelectedCategory.size());   
            for(String strUtil : mapSelectedCategory.keySet()){
                lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
            }
            
            if(selectedType == 'New Boat') {
                if(!modelVarientFlag) {  
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManufacture, selectedYear, 'Trailer').getSelectedCatagory();
                }else if(modelVarientFlag) {
                    mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManufacture, selectedYear, 'Trailer').getSelectedCatagory();
                }
                
                
                List<CheckBoxWraper> lstCheckBoxWraper2;
                
                for(String strMapValues : mapSelectedCategory.keySet()){
                    lstCheckBoxWraper2 = new List<CheckBoxWraper>();
                    for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                        lstCheckBoxWraper2.add(new CheckBoxWraper(false,lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
                    }
                    mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper2);
                }
                System.debug('Debug Log for mapCheckBoxWraper:' +mapCheckBoxWraper.size());
                System.debug('Debug Log for mapSelectedCategory:' +mapSelectedCategory.size());   
                for(String strUtil : mapSelectedCategory.keySet()){
                    
                    lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
                }
            }
            //lstPriceAndProductOptionWraperClass.sort();
        }
        
        List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();
        // [SELECT 
        //                                                         Id,
        //                                                         Name,
        //                                                         Part_Number__c,
        //                                                         Retail_Price__c,
        //                                                         Cost__c,
        //                                                         Non_Taxable__c
        //                                                         FROM
        //                                                         BOATBUILDING__Dealer_Option__c];
        
        if(lstDealerOption.size() > 0){
            for(BOATBUILDING__Dealer_Option__c objDealerOption : lstDealerOption){
                lstDealerOptionWraper.add(new DealerOptionWraper(false, objDealerOption, false));
            }
        }
        System.debug('Debug Log For lstDealerOptionWraper: '+lstDealerOptionWraper);
        if(objOrder.ContactName__c != null){
            objContact = [Select   c.Phone, c.OtherStreet, c.OtherState, c.OtherPostalCode, c.OtherPhone, c.OtherLongitude, 
                          c.OtherLatitude, c.OtherGeocodeAccuracy, c.OtherCountry, c.OtherCity, c.OtherAddress, c.Name, c.MobilePhone,  
                          c.MailingStreet, c.MailingState, c.MailingPostalCode, c.MailingLongitude, c.MailingLatitude, c.MailingGeocodeAccuracy, c.MailingCountry,
                          c.MailingCity, c.MailingAddress, c.LeadSource, c.LastName, c.Id, c.HomePhone, c.FirstName, c.Fax, c.Email, c.AssistantPhone, 
                          c.AssistantName, c.AccountId From Contact c where Id =: objOrder.ContactName__c limit 1];
            
            if(objContact.AccountId != null){                                           
                objAccount = [Select a.Year__c,a.Prospect_Desired_Boat_Length__c ,a.Do_they_have_a_trade__c ,a.Desire_Price_low__c , a.Desire_price_high__c ,a.Work_Phone__c,a.Desire_boat_model__c , a.Website, a.Desired_Boat_Manufacturer__c ,a.URI__c, a.Type, a.Telephone__c, 
                              a.SystemModstamp, a.Source__c, a.SourcePage__c, a.SicDesc, a.ShippingStreet, a.ShippingState, 
                              a.ShippingPostalCode, a.ShippingLongitude, a.ShippingLatitude, a.ShippingGeocodeAccuracy, a.ShippingCountry, a.ShippingCity, 
                              a.ShippingAddress, a.Sale_Class__c, a.Request_Type__c, a.RecordTypeId, a.Price__c, a.PhotoUrl, a.Phone, 
                              a.ParentId, a.OwnerId, a.NumberOfEmployees, a.NewsletterOptIn__c, a.Name, a.Model__c, a.MasterRecordId, a.Make__c, 
                              a.Lead_Status__c,a.Lead_Source__c, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, 
                              a.LastActivityDate, a.JigsawCompanyId, a.Jigsaw, a.IsDeleted, a.Industry, a.Id, a.IMT_ID__c, a.Formpage__c, 
                              a.Fax, a.Email__c, a.Description, a.Date_Time__c, a.CreatedDate, a.CreatedById, a.Comments__c, 
                              a.Catalog__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingLongitude, a.BillingLatitude, a.BillingGeocodeAccuracy, 
                              a.BillingCountry, a.BillingCity, a.BillingAddress, a.AnnualRevenue, a.AccountSource From Account a where Id =: objContact.AccountId limit 1];
            }else{
                objAccount.Name = objContact.FirstName +' '+ objContact.LastName;
                objAccount.Email__c = objContact.Email;
                objAccount.Phone = objContact.Phone;
                objAccount.BillingStreet = objContact.MailingStreet;
                objAccount.BillingPostalCode = objContact.MailingPostalCode;
                objAccount.ShippingStreet = objContact.OtherStreet;
            }
        }
        
        //MfgOptTota = 0.00;
        totalPrice = totalPrice + yourPriceThirdPageForProductPrice;
        totalPriceDealer = totalPriceDealer + yourPriceThirdPageForProductPriceDealer;
        
        selectedManufacturerThirdPage = selectedManufacturerSecondPage;
        selectedModelThirdPage = selectedModelSecondPage;
        if(objProduct.M_Retail_Price__c != null){
            totalRetailPrice = objProduct.M_Retail_Price__c;
        }
        PageReference pg = new PageReference('/apex/BOATBUILDING__ProductOrder');
        pg.setRedirect(false);
        return pg;
    }
    
    
    
    public PageReference thirdPageSave(){
        if(ApexPages.currentPage().getParameters().get('invId') != null && objOrder.ContactName__c != null){
            
            objContact = [SELECT Id, FirstName,LastName,MailingStreet,AccountId, MailingCity, MailingState, MailingCountry,
                          Email, Phone FROM Contact where Id =: objOrder.ContactName__c limit 1 ];
            
            if(objContact.AccountId != null){
                objAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, Email__c,
                              Phone FROM Account where Id =:objContact.AccountId];
            }
            
            
        }else if(objProduct.Id != null){
            
            if(objProduct.Engine_SN__c != null){             
                objItem.Engine_SN__c = objInventory2.Engine_SN__c;
            }
            if(objProduct.Boat_Length_in_feets__c != null){             
                objItem.Boat_Length_in_Feets__c = objInventory2.Boat_Length_in_feets__c;
            }             
            if(objProduct.Hull_Id__c != null){             
                objItem.Boat_HIN_No__c = objInventory2.HIN_Number__c;
            }
            if(objProduct.Trailer_VIN__c != null){             
                objItem.Trailer_VIN__c = objInventory2.Trailer_VIN__c;
            }
            if(objProduct.Transmission_Gearbox_SN__c != null){             
                objItem.Transmission_Gearbox_SN__c = objInventory2.Transmission_Gearbox_SN__c;
            }
            
            
        }
        if(objProduct.Product_Manufacturer__c != null){
            objItem.Boat_Manufacturer__c = objProduct.Product_Manufacturer__c;
        }else If(objInventory2.Manufacturer__c != null) {
            objItem.Boat_Manufacturer__c = [SELECT Id, Name FROM BOATBUILDING__Manufacturer__c WHERE Name =: objInventory2.Manufacturer__c].Id;
        }
        
        if(objProduct.MModel2__c != null){
            objItem.Boat_Model__c = objProduct.MModel2__c;
        }else If(objInventory2.Model__c != null) {
            objItem.Boat_Model__c = objInventory2.Model__c;
        }
        
        if(objProduct.M_Model_Variant__c != null){
            objItem.Boat_Model_Variant__c = objProduct.M_Model_Variant__c;
        }else If(objInventory2.Model_Variant__c != null) {
            objItem.Boat_Model_Variant__c = objInventory2.Model_Variant__c;
        }
        
        if(objProduct.M_Year__c != null){
            objItem.M_Boat_Year__c = objProduct.M_Year__c;
        }else If(objInventory2.Year__c != null) {
            objItem.M_Boat_Year__c = objInventory2.Year__c;
        }
        
        if(String.isNotBlank(objAccount.Name)){
            try{
                List<RecordType> lstRec = [Select Id FROM RecordType where sObjectType = 'Account' AND Name = 'Prospect' limit 1];
                if(lstRec.size() > 0){
                    objAccount.RecordTypeId = lstRec[0].Id; 
                }
                upsert objAccount;
            }catch(Exception ex){
                isError = true; 
                //SendEmailUtility.sendQuickEmail(ex.getStackTraceString()+'--'+ex.getMessage()+'---'+ex.getLineNumber());
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getStackTraceString()));
            }
        }
        if(objAccount.Id != null){
            if(String.valueOf(objAccount.Name).removeStartIgnoreCase(' ').removeEndIgnoreCase(' ').containsIgnoreCase(' ')){
                String[] strConName = String.valueOf(objAccount.Name).split(' ');
                objContact.FirstName = strConName[0];
                objContact.LastName = strConName[1];
            }else{
                objContact.LastName = String.valueOf(objAccount.Name);
            }
            objContact.AccountId = objAccount.Id;
            
            objContact.MailingStreet = objAccount.BillingStreet;
            objContact.MailingPostalCode = objAccount.BillingPostalCode;
            objContact.OtherStreet = objAccount.ShippingStreet;
            objContact.Phone = objAccount.Phone;
            objContact.Email = objAccount.Email__c;
            try{
                upsert objContact;
            }catch(Exception ex){
                isError = true;
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL, ex.getStackTraceString()));
            }
        }
        if(objContact.Id != null && objContact.Email != null && objContact.AccountId != null) {
            List<Contact> lstConForDel = [SELECT Id From Contact WHERE Id <>: objContact.Id AND Email =: objContact.Email AND AccountId =: objContact.AccountId LIMIT 1];
            if(lstConForDel.size() > 0) {
                try {
                    //delete lstConForDel[0];
                }
                catch(Exception ex) {
                    System.debug('Debug Log For Exception : '+ex);
                }
            }
        }
        if(objInventory2.Id != null) {
            if(objInventory2.Engine_SN__c != null){             
                objItem.Engine_SN__c = objInventory2.Engine_SN__c;
            }
            if(objInventory2.Boat_Length_in_feets__c != null){             
                objItem.Boat_Length_in_Feets__c = objInventory2.Boat_Length_in_feets__c;
            }             
            if(objInventory2.HIN_Number__c != null){             
                objItem.Boat_HIN_No__c = objInventory2.HIN_Number__c;
            }
            if(objInventory2.Trailer_VIN__c != null){             
                objItem.Trailer_VIN__c = objInventory2.Trailer_VIN__c;
            }
            if(objInventory2.Transmission_Gearbox_SN__c != null){             
                objItem.Transmission_Gearbox_SN__c = objInventory2.Transmission_Gearbox_SN__c;
            }
        }
        if(objContact.Id != null){
            objItem.Contact__c = objContact.Id;
        }
        if(objAccount.Name != null){
            objItem.Name = 'Item For '+objAccount.Name;
        }
        if(objProduct.Id != null) {
            objItem.Related_To_Product__c = objProduct.Id;
        }
        
        
        
        try {
            insert objItem;
        } 
        catch(Exception ex) {
            System.debug('Debug Log For Exception : '+ex);
        }
        
        List<Item_Line_Item__c> lstILI = new List<Item_Line_Item__c>();
        if(objItem.Id != null) {    
            if(lstQuoteLineItem.size() > 0) {
                for(BOATBUILDING__Quote_Line_Item__c  objQLI : lstQuoteLineItem) {
                    Item_Line_Item__c objILICreate = new Item_Line_Item__c();
                    objILICreate.Name = objQLI.Name__c;
                    objILICreate.Item__c = objItem.Id;
                    objILICreate.Retail_Price__c = objQLI.Total_Price__c;
                    objILICreate.Product_Code__c = objQLI.Product_Code__c ;
                    objILICreate.Dealer_Price__c = objQLI.Dealer_Price__c;
                    lstILI.add(objILICreate);
                }
            }
            
            try {
                insert lstILI;
            }
            catch(Exception ex){
                System.debug('Debug Log For Exception : '+ex);
            }
        }
        return new PageReference('/'+objItem.Id);
    }
    
    
    
    public void getMFGPrice() {
        try {
            Integer index = Integer.valueOf(rowNumber);
            Boolean executeFlag = false;
            String recId = '';
            System.debug('Debug Log for buttonRenderForPlaceOrder: '+buttonRenderForPlaceOrder);
            Boolean tempbuttonRenderForPlaceOrder = buttonRenderForPlaceOrder; 
            System.debug('Debug Log for selectedOptionString: '+selectedOptionString);
            System.debug('Debug Log for mapCheckBoxWraper: '+mapCheckBoxWraper);
            System.debug('Debug Log for index: '+index);
            System.debug('Debug Log for mapCheckBoxWraper.get(selectedOptionString): '+mapCheckBoxWraper.get(selectedOptionString));
            for(String strMapValues : mapCheckBoxWraper.keySet()){
                System.debug('>>>>>>>>>> mapCheckBoxWraperstrMapValues: '+strMapValues);
            }
            if(mapCheckBoxWraper.get(selectedOptionString)[index-1] != null) {
                selectedOptionCategory = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductSelected_Category__c;
                executeFlag = mapCheckBoxWraper.get(selectedOptionString)[index-1].checkBox;
                System.debug('Debug Log for Quantity: '+mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c);
                System.debug('Debug Log for checkBox: '+mapCheckBoxWraper.get(selectedOptionString)[index-1].checkBox);
                Decimal qt = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c != null ? mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c : 0.00;
                renderPPList(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Id, qt);
                
            }
            buttonRenderForPlaceOrder = tempbuttonRenderForPlaceOrder;

            if(executeFlag) {
                Decimal tempInt;
                Decimal tempIntDealer;
                Decimal tempQuantity = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c != null ? mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c : 0.00;
                String strPartNumberP = String.valueOf(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c);
                if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductRetail_Price__c != null){
                    tempInt = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductRetail_Price__c;
                }else{
                    tempInt = 0.00;
                }
                if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Dealer_Price__c != null){
                    tempIntDealer = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Dealer_Price__c;
                }else{
                    tempIntDealer = 0.00;
                }

                String typeAssign = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.RecordType.Name;
                if(typeAssign.containsIgnoreCase('new boat')) {
                    typeAssign = 'New Boat';
                }
                if(buttonRenderForSaveAndReCal){
                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                    if(String.isNotBlank(selectedOptionString)) {
                        objQLI.Option_Category__c = selectedOptionString;
                    }
                    if(selectedOptionCategory != null && selectedOptionCategory != ''){
                        objQLI.Name = 'QLI';
                        objQLI.Name__c = selectedOptionCategory;
                    }
                    if(objProduct.Id != null){
                        objQLI.Product__c = objProduct.Id;
                    }
                    if(tempInt != null){
                        objQLI.Total_Price__c = tempInt;
                    }
                    if(tempIntDealer != null){
                        objQLI.Dealer_Price__c = tempIntDealer;
                    
                    }
                    objQLI.Quantity__c =  tempQuantity;
                    objQLI.Date__c =  Date.today();
                    objQLI.Product_Type__c =  typeAssign;
                    objQLI.Non_Taxable__c = false;
                    if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c != null){
                        String strPartNumber = String.valueOf(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c);
                        objQLI.Product_Code__c = strPartNumber ;
                    }
                    if(!setcodeId.contains(objQLI.Product_Code__c)) {
                        lstQuoteLineItem.add(objQLI);
                    } else {
                        if(lstQuoteLineItem.size() > 0){
                            for(Integer i=0 ; i<lstQuoteLineItem.size() ; i++){
                                if(lstQuoteLineItem[i].Product_Code__c == strPartNumberP) {
                                    lstQuoteLineItem[i].Quantity__c =  tempQuantity;
                                    lstQuoteLineItem[i].Total_Price__c = tempInt;
                                    lstQuoteLineItem[i].Dealer_Price__c = tempIntDealer;
                                }
                            }
                        }
                    }
                }
                
                if(buttonRenderForPlaceOrder || ApexPages.currentPage().getParameters().get('invId') != null) {
                    
                    
                    BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
                    if(String.isNotBlank(selectedOptionString)) {
                        objILI.Option_Category__c = selectedOptionString;
                    }
                    if(selectedOptionCategory != null && selectedOptionCategory != ''){
                        objILI.Name = 'ILI'; //Dummy value
                        objILI.Name__c = selectedOptionCategory;
                    }
                    if(tempInt != null){
                        objILI.Price__c = tempInt;
                    }
                    if(tempIntDealer != null){
                        objILI.Dealer_Price__c = tempIntDealer;
                    }
                    if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c != null){
                        String strPartNumber = String.valueOf(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c);
                        objILI.Product_Code__c = strPartNumber ;
                        
                    }
                    objILI.Quantity__c =  tempQuantity;
                    objILI.Non_Taxable__c = false;
                    objILI.Product_Type__c =  typeAssign;
                    if(!setcodeId.contains(objILI.Product_Code__c)) {
                        lstInventoryLineItem.add(objILI);
                    } else {
                        if(lstInventoryLineItem.size() > 0){
                            for(Integer i=0 ; i<lstInventoryLineItem.size() ; i++){
                                if(lstInventoryLineItem[i].Product_Code__c == strPartNumberP) {
                                    lstInventoryLineItem[i].Quantity__c =  tempQuantity;
                                    lstInventoryLineItem[i].Price__c = tempInt;
                                    lstInventoryLineItem[i].Dealer_Price__c = tempIntDealer;
                                }
                            } 
                        }
                    }
                }
                if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c != null){
                    String strPartNumber = String.valueOf(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Product_Code__c);
                    setcodeId.add(strPartNumber);
                }
            }
            
            System.debug('Debug Log for lstQuoteLineItem : '+lstQuoteLineItem);
            System.debug('Debug Log for lstQuoteLineItem : '+lstQuoteLineItem.size());
            System.debug('Debug Log for lstInventoryLineItem : '+lstInventoryLineItem);
            
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getStackTraceString() + ' : ' +ex.getLineNumber()));
            System.debug('Debug log For Exception: '+ex.getMessage()+ ' : ' +ex.getStackTraceString() + ' : ' +ex.getLineNumber());
        }
        //System.debug('Debug log For lstQuoteLineItem: '+lstQuoteLineItem);
    }
    public void getDealerOptionPrice(){
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);  
        
        for(DealerOptionWraper objDD :lstDealerOptionWraper){
            renderDOList(objDD.objDealerOption.Id);
            if(objDD.objDealerOption.Part_Number__c == dealerPartNumber && objDD.isSelect){
                System.debug('Debug Log For objDD.objDealerOption.Quantity__c: '+objDD.objDealerOption.Quantity__c);
                BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                objQLI.Option_Category__c = 'Dealer Options';
                if(objDD.objDealerOption.Name != null){
                    objQLI.Name = 'QLI'; 
                    objQLI.Name__c = objDD.objDealerOption.Name;
                }
                if(objProduct.Id != null){
                    objQLI.Product__c = objProduct.Id;
                }
                if(objDD.objDealerOption.Retail_Price__c != null){
                    objQLI.Total_Price__c = objDD.objDealerOption.Retail_Price__c;
                }
                if(objDD.objDealerOption.Cost__c != null){
                    objQLI.Dealer_Price__c = objDD.objDealerOption.Cost__c;
                }
                objQLI.Date__c =  Date.today();
                if(objDD.objDealerOption.Part_Number__c != null){
                    objQLI.Product_Code__c = objDD.objDealerOption.Part_Number__c ;
                }
                if(objDD.objDealerOption.Quantity__c != null){
                    objQLI.Quantity__c = objDD.objDealerOption.Quantity__c ;
                }
                objQLI.Non_Taxable__c = objDD.Non_Taxable;
                if(!setcodeId.contains(objDD.objDealerOption.Part_Number__c)) {
                    lstQuoteLineItem.add(objQLI);
                } else {
                    if(lstQuoteLineItem.size() > 0){
                        for(Integer i=0 ; i<lstQuoteLineItem.size() ; i++){
                            if(lstQuoteLineItem[i].Product_Code__c == objDD.objDealerOption.Part_Number__c) {
                                lstQuoteLineItem[i].Quantity__c =  objDD.objDealerOption.Quantity__c;
                                lstQuoteLineItem[i].Total_Price__c = objDD.objDealerOption.Retail_Price__c;
                                lstQuoteLineItem[i].Dealer_Price__c = objDD.objDealerOption.Cost__c;
                                System.debug('>>>>lstQuoteLineItem[i].Quantity__c: '+lstQuoteLineItem[i].Quantity__c);
                            }
                        } 
                    }
                }
                
                BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
                objILI.Option_Category__c = 'Dealer Options';
                if(objDD.objDealerOption.Name != null){
                    objILI.Name = 'ILI'; //Dummy Value
                    objILI.Name__c = objDD.objDealerOption.Name;
                }
                if(objDD.objDealerOption.Retail_Price__c != null){
                    objILI.Price__c = objDD.objDealerOption.Retail_Price__c;
                }
                if(objDD.objDealerOption.Cost__c != null){
                    objILI.Dealer_Price__c = objDD.objDealerOption.Cost__c;
                }
                if(objDD.objDealerOption.Part_Number__c != null){
                    objILI.Product_Code__c = objDD.objDealerOption.Part_Number__c ;
                }
                if(objDD.objDealerOption.Quantity__c != null){
                    objILI.Quantity__c = objDD.objDealerOption.Quantity__c ;
                }
                objILI.Non_Taxable__c = objDD.Non_Taxable;
                if(!setcodeId.contains(objDD.objDealerOption.Part_Number__c)) {
                    lstInventoryLineItem.add(objILI);
                } else {
                    if(lstInventoryLineItem.size() > 0){
                        for(Integer i=0 ; i<lstInventoryLineItem.size() ; i++){
                            if(lstInventoryLineItem[i].Product_Code__c == objDD.objDealerOption.Part_Number__c) {
                                lstInventoryLineItem[i].Quantity__c =  objDD.objDealerOption.Quantity__c;
                                lstInventoryLineItem[i].Price__c = objDD.objDealerOption.Retail_Price__c;
                                lstInventoryLineItem[i].Dealer_Price__c = objDD.objDealerOption.Cost__c;
                                System.debug('>>>>lstInventoryLineItem[i].Quantity__c: '+lstInventoryLineItem[i].Quantity__c);
                            }
                        } 
                    }
                }
                setcodeId.add(objDD.objDealerOption.Part_Number__c);
            }
        }
        System.debug('setcodeId: '+setcodeId);
    }
    public void getMFGPriceSubtrct(){
        Integer index = Integer.valueOf(rowNumber);
        selectedOptionCategory = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductSelected_Category__c;
        String productCodee = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.BOATBUILDING__Product_Code__c;

        Decimal tempQuantity = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c != null ? mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c : 0.00;

        Decimal tempInt;
        Decimal tempIntDealer;
        if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductRetail_Price__c != null){
            tempInt = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductRetail_Price__c;
        }else{
            tempInt = 0.00;
        }
        tempInt = tempInt * tempQuantity;
        if(mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Dealer_Price__c != null){
            tempIntDealer = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Dealer_Price__c;
        }else{
            tempIntDealer = 0.00;
        }
        tempIntDealer = tempIntDealer * tempQuantity;
        System.debug('Debug Log index: '+index);
        System.debug('Debug Log tempInt: '+tempInt);
        if(MfgOptTota > 0){
            MfgOptTota -= tempInt;
            totalPrice -= tempInt;
        }
        if(MfgOptDealerTota > 0){ 
            MfgOptDealerTota -= tempIntDealer;
            totalPriceDealer -= tempIntDealer;
        }
        if(lstQuoteLineItem.size() > 0){
            for(Integer i=0 ; i<lstQuoteLineItem.size() ; i++){
                if(lstQuoteLineItem[i].Name__c == selectedOptionCategory) {
                    if(lstQuoteLineItem[i].Id != null) {
                        invLineIdDlt.add(lstQuoteLineItem[i].Id);
                    }
                    lstQuoteLineItem.remove(i); 
                }
            }
        }
        
        if(lstInventoryLineItem.size() > 0){
            for(Integer i=0 ; i<lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Name == selectedOptionCategory){
                    lstInventoryLineItem.remove(i);
                }
            }
        }
        
        if(setcodeId.size() > 0 && setcodeId.contains(productCodee)){
            setcodeId.remove(productCodee);
        }
         
        if(objInventory2 != null && !objInventory2.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
            for(Integer i = 0 ; i < objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() ; i++){
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Product_Code__c == productCodee) { 
                    invLineIdDlt.add(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Id);    
                } 
            }   
        }
    }
    
    public void getDealerOptionPriceSub() {
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);
        if(setcodeId.size() > 0 && setcodeId.contains(dealerPartNumber)){
            setcodeId.remove(dealerPartNumber);
        }
        if(lstQuoteLineItem.size() > 0){
            for(Integer i = 0 ; i < lstQuoteLineItem.size() ; i++) {
                if(lstQuoteLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstQuoteLineItem[i].Total_Price__c != null && dealerOptionTotal > 0){
                    if(lstQuoteLineItem[i].Total_Price__c != null){
                        dealerOptionTotal -= (lstQuoteLineItem[i].Total_Price__c * lstQuoteLineItem[i].Quantity__c);
                    }
                    if(lstQuoteLineItem[i].Total_Price__c != null && totalPrice > 0){
                        totalPrice -= (lstQuoteLineItem[i].Total_Price__c * lstQuoteLineItem[i].Quantity__c);
                    }
                    if(lstQuoteLineItem[i].Id != null) {
                        invLineIdDlt.add(lstQuoteLineItem[i].Id);
                    }
                    lstQuoteLineItem.remove(i);
                }
            }
        }
        if(lstInventoryLineItem.size() > 0){
            for(Integer i = 0 ; i < lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Product_Code__c == dealerPartNumber){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null ){
                        dealerOptionCostTotal -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    if(lstInventoryLineItem[i].Dealer_Price__c != null){
                        totalPriceDealer -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    lstInventoryLineItem.remove(i);
                }
            }
        }
        if(!objInventory2.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
            for(Integer i = 0 ; i < objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() ; i++){
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Product_Code__c == dealerPartNumber){
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null ){
                        dealerOptionCostTotal -= (objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c * objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Quantity__c);
                    }
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null){
                        totalPriceDealer -= (objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c * objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Quantity__c);
                    }
                    
                    invLineIdDlt.add(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Id);    
                } 
            }   
        }
    }

    public void saveAndRecaculate(){
        System.debug('Debug Log For Check');
        
        if(objItem.Trailer_Price__c != null){
            if(objItem.Trailer_Price__c > 0 && objItem.Trailer_Price__c > trailerPrice){
                totalPrice = totalPrice + (objItem.Trailer_Price__c - trailerPrice);
                trailerPrice = objItem.Trailer_Price__c;
                
            }else if(objItem.Trailer_Price__c > 0 && objItem.Trailer_Price__c < trailerPrice){
                totalPrice = totalPrice + (trailerPrice - objItem.Trailer_Price__c );
                trailerPrice = objItem.Trailer_Price__c;
                
            }else if(objItem.Trailer_Price__c > 0 && objItem.Trailer_Price__c == trailerPrice){
                
            }else{
                totalPrice = totalPrice - trailerPrice; 
            }
        }else{
            trailerPrice = 0.00;
        }
        
        if(objItem.Trade_In_Price_Value__c != null){
            if(objItem.Trade_In_Price_Value__c > 0 && objItem.Trade_In_Price_Value__c <= totalPrice &&  objItem.Trade_In_Price_Value__c > tradInValue && totalPrice > 0){
                totalPrice = totalPrice - (objItem.Trade_In_Price_Value__c - tradInValue);
                tradInValue = objItem.Trade_In_Price_Value__c;
                
            }else if(objItem.Trade_In_Price_Value__c > 0 && objItem.Trade_In_Price_Value__c < trailerPrice){
                totalPrice = totalPrice + (tradInValue - objItem.Trade_In_Price_Value__c );
                tradInValue = objItem.Trade_In_Price_Value__c;
                
            }else if(objItem.Trade_In_Price_Value__c > 0 && objItem.Trade_In_Price_Value__c == trailerPrice){
                
            }else{
                totalPrice = totalPrice + tradInValue; 
            }
        }else{
            tradInValue = 0.00;
        }
        
        if(pcCheckDis == true){
            totalRetailPrice = (totalRetailPrice + (totalPrice - totalRetailPrice)) - (totalPrice * ( Decimal.valueOf(discountInPC) / 100 ));
            objProduct.M_Retail_Price__c = totalRetailPrice;
        }else{
            discountInPC = '0';
            totalRetailPrice = 0.00;
            if(objProduct.M_Retail_Price__c != null){
                totalRetailPrice = objProduct.M_Retail_Price__c;
            }
        }
        
        
        
    }
    
    public PageReference placeOrderForInventory(){
        objInventory.Stage__c = 'Ordered';
        List<RecordType> lstRecT = new List<RecordType>();
        if(selectedType.equalsIgnoreCase('New Boat')) { 
            lstRecT = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name = 'New Boats' limit 1];
        } else {
            lstRecT = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name =: selectedType limit 1];
        }
        if(lstRecT.size() > 0){
            objInventory.RecordTypeId = lstRecT[0].Id;  
        }
        //objInventory.RecordTypeId = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name = 'New Boats'].Id;
        if(selectedManufacture != null){
            objInventory.Manufacturer__c = [Select Name from BOATBUILDING__Manufacturer__c where Id =: selectedManufacture limit 1].Name;
        }
        //if(selectedYear != null && selectedType != 'Trailer'){
        objInventory.Year__c = selectedYear;
        //} else {
        //objInventory.Year__c =  [Select M_Year__c from BOATBUILDING__Product__c where Id=: selectedYear limit 1].M_Year__c;
        //}
        //if(selectedModel != null && selectedType != 'Trailer'){
        if(modelVarientFlag){
            objInventory.Model__c = selectedModel;
        }else if(!modelVarientFlag){
            objInventory.Model__c = [Select MModel2__c from BOATBUILDING__Product__c where Id=: selectedModel limit 1].MModel2__c;
        }
        //} 
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
        if(totalPriceDealer != null){
            objInventory.Total_Dealer_Price__c = totalPriceDealer;
        }
        try{
            insert objInventory;
        }catch(Exception ex){
            isError = true;
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
        }
        
        if(objInventory.Id != null && lstInventoryLineItem.size() > 0){
            for(BOATBUILDING__Inventory_Line_Item__c objILI1 : lstInventoryLineItem){
                if(objILI1.Related_to_Inventory__c == null) 
                {
                    objILI1.Related_to_Inventory__c = objInventory.Id;
                }
            }
            for(DealerOptionWraper objDP :lstDealerOptionWraper) {
                System.debug('objDP: '+objDP);
                for(BOATBUILDING__Inventory_Line_Item__c objILIU: lstInventoryLineItem) {
                    System.debug('objILIU: '+objILIU);
                    if(objDP.objDealerOption.Part_Number__c == objILIU.BOATBUILDING__Product_Code__c) {
                        objILIU.Non_Taxable__c = objDP.Non_Taxable;
                    }
                }
            }

            for(WritinCustomOption objDP : lstWritinCustomOption) {
                System.debug('objDP: '+objDP);
                for(BOATBUILDING__Inventory_Line_Item__c objILIU: lstInventoryLineItem) {
                    System.debug('objILIU: '+objILIU);
                    if(objDP.ProductCode == objILIU.BOATBUILDING__Product_Code__c) {
                        objILIU.Non_Taxable__c = objDP.Non_Taxable;
                        objILIU.Quantity__c = objDP.Quantity; 
                    }
                }
            }

            try{
                upsert lstInventoryLineItem;
            }catch(Exception ex){
                isError = true;
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
            }
        }
        
        if(!isError){
            return new PageReference('/'+objInventory.Id);
        }
        
        return null;
    }
    
    
    public PageReference sendQuote() {
        try {
            //--------------------------------------Quote to Boat Builder---------------------------------------//
            
            if(ApexPages.currentPage().getParameters().get('quoteId') != null) {
                System.debug('Debug Log for lstQuoteLineItem'+lstQuoteLineItem);
                System.debug('Debug Log for lstQuoteLineItemsize: '+lstQuoteLineItem.size());
                if(!invLineIdDlt.isEmpty()) {
                    delete [Select Id From Quote_Line_Item__c Where Id IN: invLineIdDlt];
                    for(Integer i = 0; i < lstQuoteLineItem.size(); i++) {
                        if(lstQuoteLineItem[0].Id != null && invLineIdDlt.contains(lstQuoteLineItem[0].Id)) {
                            lstQuoteLineItem.remove(i); 
                        }
                    }
                }
                noTrailer = true;
                for(BOATBUILDING__Quote_Line_Item__c objQLI : lstQuoteLineItem){
                    if(objQLI.Product_Type__c == 'Trailer' && noTrailer) {
                        noTrailer = false;
                    }
                    if(objQLI.Quote__c == null) {
                        objQLI.Quote__c = objQuote3.Id;
                    }
                    for(DealerOptionWraper objDP :lstDealerOptionWraper) {
                        if(objDP.objDealerOption.Part_Number__c == objQLI.BOATBUILDING__Product_Code__c) {
                            objQLI.Non_Taxable__c = objDP.Non_Taxable;
                        }
                    }

                    for(WritinCustomOption objDP :lstWritinCustomOption) {
                        if(objDP.ProductCode == objQLI.BOATBUILDING__Product_Code__c) {
                            objQLI.Non_Taxable__c = objDP.Non_Taxable;
                            objQLI.Quantity__c = objDP.Quantity;
                        } 
                    }
                }
             
                
                upsert lstQuoteLineItem ;
                
                if(totalPrice == null) {
                    totalPrice = 0;
                }
                If(totalPrice != null) {
                    System.debug('Debug Log For objQuote3.Discount_On_Quote__c: '+objQuote3.Discount_On_Quote__c);
                    if(objQuote3.Discount_On_Quote__c != null) {
                        objQuote3.Quote_Sale_Price__c = totalPrice - objQuote3.Discount_On_Quote__c;
                    } else {
                        objQuote3.Quote_Sale_Price__c = totalPrice;
                    }
                    objQuote3.Total_Price_Quote__c = totalPrice; 
                }
                
                objQuote3.No_Trailer__c = noTrailer;
                
                update objQuote3;
                if(!isError){
                    return new PageReference('/'+objQuote3.Id);
                }
                else{
                    return null;
                }
            }
            //--------------------------------------Quote to Boat Builder---------------------------------------//
            
            if(ApexPages.currentPage().getParameters().get('invId') != null && objOrder.ContactName__c != null) {
                
                objContact = [SELECT Id, FirstName,LastName,MailingStreet,AccountId, MailingCity, MailingState, MailingCountry,
                              Email, Phone FROM Contact where Id =: objOrder.ContactName__c limit 1 ];
                if(objContact.AccountId != null) {
                    objAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, Email__c,
                                  Phone FROM Account where Id =:objContact.AccountId];
                }                        
                if(objInventory2.Engine_SN__c != null){             
                    objQuote.Mapped_Engine_SN__c = objInventory2.Engine_SN__c;
                }
                if(objInventory2.Boat_Length_in_feets__c != null){             
                    objQuote.Mapped_Boat_Length__c = objInventory2.Boat_Length_in_feets__c;
                }             
                if(objInventory2.HIN_Number__c != null && objInventory2.HIN_Number__c != ''){             
                    objQuote.Mapped_HIN__c = objInventory2.HIN_Number__c;
                }
                else if(objInventory2.Hull_ID__c != null && objInventory2.Hull_ID__c != '') {
                    objQuote.Mapped_HIN__c = objInventory2.Hull_ID__c;
                }
                if(objInventory2.Trailer_VIN__c != null){             
                    objQuote.Mapped_Trailer_VIN__c = objInventory2.Trailer_VIN__c;
                }
                if(objInventory2.Transmission_Gearbox_SN__c != null){             
                    objQuote.Transmission_Gearbox_SN__c = objInventory2.Transmission_Gearbox_SN__c;
                }
                if(objInventory2.BOATBUILDING__Engine_1_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_1_SN__c = objInventory2.BOATBUILDING__Engine_1_SN__c;
                }
                if(objInventory2.BOATBUILDING__Engine_2_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_2_SN__c = objInventory2.BOATBUILDING__Engine_2_SN__c;
                }   
                if(objInventory2.BOATBUILDING__Engine_3_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_3_SN__c = objInventory2.BOATBUILDING__Engine_3_SN__c;
                }
                if(objInventory2.BOATBUILDING__Engine_4_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_4_SN__c = objInventory2.BOATBUILDING__Engine_4_SN__c;
                }
                /*if(totalPriceDealer != null){
objQuote.Quote_Cost__c = totalPriceDealer;
}else{
objQuote.Quote_Cost__c = 0.00;
}*/
            }else if(objProduct.Id != null){
                
                if(objProduct.Engine_SN__c != null){             
                    objQuote.Mapped_Engine_SN__c = objProduct.Engine_SN__c;
                }
                if(objProduct.Boat_Length_in_feets__c != null){             
                    objQuote.Mapped_Boat_Length__c = objProduct.Boat_Length_in_feets__c;
                }             
                if(objProduct.Hull_Id__c != null){             
                    objQuote.Mapped_HIN__c = objProduct.Hull_Id__c;
                }
                if(objProduct.Trailer_VIN__c != null){             
                    objQuote.Mapped_Trailer_VIN__c = objProduct.Trailer_VIN__c;
                }
                if(objProduct.Transmission_Gearbox_SN__c != null){             
                    objQuote.Transmission_Gearbox_SN__c = objProduct.Transmission_Gearbox_SN__c;
                }
                if(objProduct.Cost_Price__c != null){
                    objQuote.Quote_Total_MSRP__c = objProduct.Cost_Price__c;
                }
            }
            if(String.isNotBlank(objAccount.Name)){
                
                Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                objAccount.RecordTypeId = prospectRecordTypeId; 
                //objAccount.RecordTypeId = [Select Id FROM RecordType where sObjectType = 'Account' AND Name = 'Prospect'].id;
                upsert objAccount;
                
            }
            if(objAccount.Id != null){
                if(String.valueOf(objAccount.Name).removeStartIgnoreCase(' ').removeEndIgnoreCase(' ').containsIgnoreCase(' ')){
                    String[] strConName = String.valueOf(objAccount.Name).split(' ');
                    objContact.FirstName = strConName[0];
                    objContact.LastName = strConName[1];
                    if(String.isBlank(objContact.LastName)) {
                        objContact.LastName = strConName[0];
                    }
                }else{
                    objContact.LastName = String.valueOf(objAccount.Name);
                }
                
                objContact.AccountId = objAccount.Id;
                
                objContact.MailingStreet = objAccount.BillingStreet;
                objContact.MailingPostalCode = objAccount.BillingPostalCode;
                objContact.OtherStreet = objAccount.ShippingStreet;
                objContact.Phone = objAccount.Phone;
                objContact.Email = objAccount.Email__c;
                
                if(String.isNotBlank(objContact.LastName)) {
                    upsert objContact;
                } 
                
            }
            if(objContact.Id != null && objContact.Email != null && objContact.AccountId != null) {
                List<Contact> lstConForDel = [SELECT Id From Contact WHERE Id <>: objContact.Id AND Email =: objContact.Email AND AccountId =: objContact.AccountId LIMIT 1];
                if(lstConForDel.size() > 0) {
                    
                    //delete lstConForDel[0];
                    
                }
            }
            if(objContact.Id != null){
                objQuote.Contact_Name__c = objContact.Id; 
            }
            
            if(objAccount.Id != null){
                objQuote.Account_Name__c = objAccount.Id;
            }
            if(objInventory2.Cost__c != null){
                objQuote.Quote_Total_MSRP__c = objInventory2.Cost__c;
            }
            if(objOrder.Id != null){
                objItem.Name = 'Item For '+[Select Name from BOATBUILDING__Order__c where Id =: objOrder.Id limit 1].Name;
                objItem.M_Order__c = objOrder.Id;   
            }else{
                objItem.Name = 'Item For '+objAccount.Name;
            }
            if(ApexPages.currentPage().getParameters().get('invId') == null) {
                try{
                    insert objItem; 
                }catch(Exception ex){
                    isError = true;
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                } 
            }
            if(objAccount.Name != null && objAccount.Name != ''){
                objQuote.Name = 'Quote For '+objAccount.Name;   
            }else{
                if(objContact.FirstName != null && objContact.FirstName != ''){
                    objQuote.Name = 'Quote For '+objContact.FirstName + ' ' + objContact.LastName;
                }else{
                    objQuote.Name = 'Quote For '+objInventory2.Name;
                }
            }
            
            if(objContact.FirstName != null && objContact.FirstName != ''){
                objQuote.Quote_To_Name__c = objContact.FirstName + ' ' + objContact.LastName;
            }else{
                objQuote.Quote_To_Name__c = objContact.LastName;
            }
            objQuote.Quote_To_Address__c = ' ';
            
            if(objContact.Email != null && objContact.Email != ''){
                objQuote.Email__c = objContact.Email;
            }else if(objAccount.Email__c != null && objAccount.Email__c != ''){
                objQuote.Email__c = objAccount.Email__c;
            }else{
                objQuote.Email__c = ' ';
            }
            
            if(objContact.Phone != null && objContact.Phone != ''){
                objQuote.Phone__c = objContact.Phone;
            }else if(objAccount.Phone != null && objAccount.Phone !=''){
                objQuote.Phone__c = objAccount.Phone;
            }else{
                objQuote.Phone__c = ' ';
            }
            
            if(objProduct.M_Boat_MSRP_PRICE__c != null){
                objQuote.Quote_MSRP_Boat_Price__c = objProduct.M_Boat_MSRP_PRICE__c;
            }else{
                objQuote.Quote_MSRP_Boat_Price__c = 0;
            }
            
            if(objProduct.M_Trailer_MSRP_PRICE__c != null ) {
                objQuote.Quote_MSRP_Trailer_Price__c = objProduct.M_Trailer_MSRP_PRICE__c;
            } else {
                objQuote.Quote_MSRP_Trailer_Price__c = 0;
            }
            
            if(objProduct.M_Discount__c != null ){
                objQuote.Discount_On_Quote__c = objProduct.M_Discount__c;
            }else{
                objQuote.Discount_On_Quote__c = 0;
            }
            
            if(objProduct.M_Boat_Trade_Allowance__c != null){
                objQuote.Quote_Trade_Allowance__c = objProduct.M_Boat_Trade_Allowance__c;
            }else{
                objQuote.Quote_Trade_Allowance__c = 0;
            }
            
            if(objProduct.M_Trailer_Trade_Allowance__c != null){
                objQuote.Quote_Trailer_Allowance__c = objProduct.M_Trailer_Trade_Allowance__c;
            }else{
                objQuote.Quote_Trailer_Allowance__c = 0;
            }
            
            
            if(objProduct.M_Trailer_Actual_Cost_Value_ACV__c != null ){
                objQuote.Quote_Trailer_ACV__c = objProduct.M_Trailer_Actual_Cost_Value_ACV__c;
            }else{
                objQuote.Quote_Trailer_ACV__c = 0;
            }
            
            if(objProduct.M_Trailer_Sales_Tax__c != null){
                objQuote.Quote_Trailer_Sales_Tax__c = objProduct.M_Trailer_Sales_Tax__c;
            }else{
                objQuote.Quote_Trailer_Sales_Tax__c = 0;
            }
            
            if(objProduct.M_Boat_Reg_Fee__c != null ){
                objQuote.Quote_Boat_Reg_Fee__c = objProduct.M_Boat_Reg_Fee__c;
            }else{
                objQuote.Quote_Boat_Reg_Fee__c = 0;
            }
            
            if(objProduct.M_Trailer_Reg_Fee__c != null ){
                objQuote.Quote_Trailer_Reg_Fee__c = objProduct.M_Trailer_Reg_Fee__c;
            }else{
                objQuote.Quote_Trailer_Reg_Fee__c = 0;
            }
            
            if(objProduct.M_Doc_Fee__c != null ){
                objQuote.Quote_Doc_Fee__c = objProduct.M_Doc_Fee__c;
            }else{
                objQuote.Quote_Doc_Fee__c = 0;
            }
            
            if(objProduct.M_Trade_PayOFF__c != null){
                objQuote.Quote_Trade_Payoff__c = objProduct.M_Trade_PayOFF__c;
            }else{
                objQuote.Quote_Trade_Payoff__c =0;
            }
            
            if(objProduct.M_Down_Payment__c != null){
                objQuote.Quote_Down_Payment__c = objProduct.M_Down_Payment__c;
            }else{
                objQuote.Quote_Down_Payment__c =0;
            }
            
            if(objProduct.M_Rfinance_Rate__c != null ){
                objQuote.Quote_Rate__c = objProduct.M_Rfinance_Rate__c;
            }else{
                objQuote.Quote_Rate__c =0;
            }
            //objQuote.Quote_Total_Amount_Financed_Calculated__c = objProduct.M_Total_Amount_Financed_Calculated__c;
            if(objProduct.M_Finance_Term__c != null && objProduct.M_Finance_Term__c != 'None'){
                objQuote.Quote_Term__c = objProduct.M_Finance_Term__c;
            }else{
               // objQuote.Quote_Term__c ='More';
            }
            
            if(objProduct.M_Payment__c != null ){
                objQuote.Quote_Payment__c = objProduct.M_Payment__c;
            }else{
                objQuote.Quote_Payment__c =0;
            }
            
            
            if(objProduct.M_Deal_Margin__c != null ){
                objQuote.Quote_Deal_Margin__c = objProduct.M_Deal_Margin__c;
            }else{
                objQuote.Quote_Deal_Margin__c =0;
            }
            
            System.debug('>>>>>>>totalPrice: '+totalPrice);
            if(totalPrice != null){
                System.debug('>>>>>>>totalPrice: in '+totalPrice);    
                objQuote.Quote_Sale_Price__c = totalPrice;
                objQuote.Total_Price_Quote__c = totalPrice;
            }else{
                objQuote.Quote_Sale_Price__c = 0.00;
                objQuote.Total_Price_Quote__c = 0.00;
            }   
            
            /*if(totalPriceDealer != null){
objQuote.Quote_Cost__c = totalPriceDealer;
}else{
objQuote.Quote_Cost__c = 0.00;
}*/
            
            if(objProduct.State__c!= 'None'){
                objQuote.State__c= objProduct.State__c;
            }
            
            
            
            System.debug('Debug log for objProduct.Id : '+objProduct.Id);
            if(objProduct.Id != null){
                objQuote.Related_to_Product__c = objProduct.Id;
            }
            
            //objQuote.No_Trailer__c = noTrailer;
            noTrailer = true;
            for(BOATBUILDING__Quote_Line_Item__c objQLI : lstQuoteLineItem){
                if(objQLI.Product_Type__c == 'Trailer' && noTrailer) {
                    noTrailer = false;
                }
                
            }
            objQuote.No_Trailer__c = noTrailer;
            
            insert objQuote;
            
            
            if(objQuote.Id != null && lstQuoteLineItem.size() > 0){
                System.debug('lstQuoteLineItem: '+lstQuoteLineItem);
                for(BOATBUILDING__Quote_Line_Item__c qli : lstQuoteLineItem){
                    qli.Quote__c = objQuote.Id; 
                    for(DealerOptionWraper objDP :lstDealerOptionWraper) {
                        if(objDP.objDealerOption.Part_Number__c == qli.BOATBUILDING__Product_Code__c) {
                            qli.Non_Taxable__c = objDP.Non_Taxable;
                        }
                    }
                } 
                
                insert lstQuoteLineItem;
                
            } 
            
            if(!isError && objQuote.Id != null){ 
                objQuote2 = [Select  
                             q.Engine__c,
                             q.Trailer__c,
                             q.Engine__r.Total_MSRP_Price__c,
                             q.Engine__r.Manufacturer__c,
                             q.Engine__r.Model__c,
                             q.Engine__r.Year__c,
                             q.Engine__r.Engine_SN__c,
                             q.Engine__r.Serial_Number_2__c,
                             q.Engine__r.Transmission_Gearbox_SN__c,
                             q.Trailer__r.Total_MSRP_Price__c,
                             q.Trailer__r.Manufacturer__c,
                             q.Trailer__r.Model__c,
                             q.Trailer__r.Year__c, 
                             q.Trailer__r.Trailer_Axles__c,  
                             q.Trailer__r.Trailer_VIN__c,
                             q.BOATBUILDING__Dealer_Discount__c,
                             
                             q.State__c, q.Tax__c, q.SystemModstamp, q.Syncing__c,q.Related_to_Product__c,
                             q.Status__c,q.Quote_Total_Price_Calculated__c , q.Shipping_And_Handling__c, q.Ship_To__c, q.Ship_To_Name__c, q.Related_to_Order__c,q.Discount_On_Quote__c,
                             q.Quote_Trailer_Sales_Tax__c, q.Quote_Trailer_Reg_Fee__c,q.Mapped_Boat_Length__c , q.Mapped_Engine_SN__c, q.Mapped_HIN__c, q.Mapped_Trailer_VIN__c, q.Transmission_Gearbox_SN__c,
                             q.Quote_Trailer_Allowance__c,q.Quote_Your_Price_Formula__c ,q.Quote_Total_Over_Allowance_Calculated__c ,q.Quote_Net_Selling_Price_Calculated__c ,q.Boat_Sales_Tax2__c ,q.Quote_Trailer_ACV__c, q.Quote_Trade_Payoff__c, q.Quote_Trade_Allowance__c,q.Quote_Trade_ACV__c,
                             q.Quote_Total_Amount_Financed_Calculated__c , q.Quote_To_Name__c, q.Quote_To_Address__c,CO_Buyer_Name__r.Name,CO_Buyer_Name__c,
                             q.Quote_Term__c, q.Quote_Rate__c, q.Quote_Payment__c,q.Total_Price_Quote__c, q.Quote_Number__c, q.Quote_MSRP_Trailer_Price__c,
                             q.Quote_MSRP_Boat_Price__c, q.Quote_Down_Payment__c, q.Quote_Doc_Fee__c, q.Quote_Deal_Margin__c, q.Quote_Cost_Clone__c, 
                             q.Quote_Total_MSRP__c , q.Quote_Boat_Reg_Fee__c, Contact_Name__r.Name, 
                             q.Phone__c, q.OwnerId,q.Quote_Sale_Price__c, q.Name, q.LastViewedDate, q.LastReferencedDate, q.LastModifiedDate, q.LastModifiedById,
                             q.LastActivityDate, q.IsDeleted, q.Id, q.Grand_Total__c,  q.Fax__c, q.Expiration_Date__c, q.Email__c,
                             q.Discount__c, q.Description__c,q.CreatedDate, q.CreatedById, q.Contact_Name__c, q.Bill_To__c, q.Bill_To_Name__c, q.Additional_To__c, 
                             q.Additional_To_Name__c, q.Account_Name__c,(Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                                                         SystemModstamp, LastActivityDate, Date__c, Discount__c, Line_Item_Description__c, List_Price__c, Product__c, Product_Code__c, Quantity__c, BOATBUILDING__Product_Type__c,
                                                                         Quote__c, Sales_Price__c, Sub_Total__c, Total_Price__c, Name__c, BOATBUILDING__Total_Dealer_Price__c, BOATBUILDING__Total_Retail_Price__c From BOATBUILDING__Quote_Line_Item__r) From BOATBUILDING__Quote__c q where q.Id =: objQuote.Id limit 1];
                if(objQuote2.CO_Buyer_Name__c == null) {
                    checkBoxExist = false; 
                }
                
                
                
                if(objItem.Trailer_Manufacturer__c != null){
                    getManufacturerName = [Select Id, Name from BOATBUILDING__Manufacturer__c where Id =: objItem.Trailer_Manufacturer__c].Name;
                }
                return new PageReference('/'+objQuote2.Id);
            }else{
                return null;
            }
        } catch(Exception ex) {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage() + ' : ' +ex.getStackTraceString() + ' : ' +ex.getLineNumber()));
            System.debug(ex.getMessage() + ' : ' +ex.getStackTraceString() + ' : ' +ex.getLineNumber());
            return null;
        } 
    }
    
    public PageReference showpopup1() {
        showPopup = true;
        return null; 
    }
    
    public PageReference changeCustomer() {
        //public Boolean checkCustomer { get; set; }
        //public Boolean checkCoBuyer { get; set; }
        try {
            if(checkCustomer == true) {
                String coByer = '';
                if(objQuote2.CO_Buyer_Name__c != null && objQuote2.Contact_Name__c != null) { 
                    coByer = objQuote2.Contact_Name__c; 
                    objQuote2.Contact_Name__c = objQuote2.CO_Buyer_Name__c;
                    objQuote2.CO_Buyer_Name__c = coByer;
                }
                objQuote2.No_Trailer__c = noTrailer;
                update objQuote2;  
                
                objQuote2 = [Select 
                             q.Engine__c,
                             q.Trailer__c,
                             q.Engine__r.Total_MSRP_Price__c,
                             q.Engine__r.Manufacturer__c,
                             q.Engine__r.Model__c,
                             q.Engine__r.Year__c, 
                             q.Engine__r.Engine_SN__c,
                             q.Engine__r.Serial_Number_2__c,
                             q.Engine__r.Transmission_Gearbox_SN__c,
                             q.Trailer__r.Total_MSRP_Price__c,
                             q.Trailer__r.Manufacturer__c,
                             q.Trailer__r.Model__c,
                             q.Trailer__r.Year__c, 
                             q.Trailer__r.Trailer_Axles__c, 
                             q.Trailer__r.Trailer_VIN__c,
                             q.BOATBUILDING__Dealer_Discount__c,
                             q.State__c, q.Tax__c, q.SystemModstamp, q.Syncing__c, q.Account_Name__r.Name, Contact_Name__r.Name, q.Test_2__r.Name,q.Test_2__r.Engine_Make__c, q.Test_2__r.Engine_Year__c, q.Test_2__r.Engine_Model__c, q.Test_2__r.Serial_Number_2__c,
                             q.Status__c,q.Quote_Total_Price_Calculated__c , q.Shipping_And_Handling__c, q.Ship_To__c, q.Ship_To_Name__c, q.Related_to_Order__c,q.Discount_On_Quote__c, q.Related_to_Product__c,q.Test_2__r.Trailer_Make__c,q.Test_2__r.Trailer_Model__c,q.Test_2__r.Trailer_VIN__c,q.Test_2__r.Trailer_Year__c,
                             q.Quote_Trailer_Sales_Tax__c, q.Quote_Trailer_Reg_Fee__c,q.Mapped_Boat_Length__c , q.Mapped_Engine_SN__c, q.Mapped_HIN__c, q.Mapped_Trailer_VIN__c, q.Transmission_Gearbox_SN__c,q.Dealer_Comments_and_Notes__c, q.Test_2__r.Trailer_Axles__c,
                             q.Quote_Trailer_Allowance__c,q.Quote_Your_Price_Formula__c ,q.Quote_Total_Over_Allowance_Calculated__c ,q.Quote_Net_Selling_Price_Calculated__c ,q.Boat_Sales_Tax2__c ,q.Quote_Trailer_ACV__c, q.Quote_Trade_Payoff__c, q.Quote_Trade_Allowance__c,
                             q.Quote_Total_Amount_Financed_Calculated__c , q.Quote_To_Name__c, q.Quote_To_Address__c, q.Quote_Trade_ACV__c,CO_Buyer_Name__r.Name,CO_Buyer_Name__c, 
                             q.Quote_Term__c, q.Quote_Rate__c, q.Quote_Payment__c,q.Total_Price_Quote__c, q.Quote_Number__c, q.Quote_MSRP_Trailer_Price__c, 
                             q.Quote_MSRP_Boat_Price__c, q.Quote_Down_Payment__c, q.Quote_Doc_Fee__c, q.Quote_Deal_Margin__c, q.Quote_Cost_Clone__c, q.Test_2__c,
                             q.Quote_Total_MSRP__c , q.Quote_Boat_Reg_Fee__c,q.Dealer_Disclaimer__c,  
                             q.ACV_FORM__r.Boat_Make__c, q.ACV_FORM__r.Boat_Model__c, q.ACV_FORM__r.Boat_Year__c, q.ACV_FORM__r.Boat_HIN__c, q.ACV_FORM__r.Engine_SN__c,   
                             q.Phone__c, q.OwnerId,q.Quote_Sale_Price__c, q.Name, q.LastViewedDate, q.LastReferencedDate, q.LastModifiedDate, q.LastModifiedById,
                             q.LastActivityDate, q.IsDeleted, q.Id, q.Grand_Total__c,  q.Fax__c, q.Expiration_Date__c, q.Email__c,
                             q.Discount__c, q.Description__c,q.CreatedDate, q.CreatedById, q.Contact_Name__c, q.Bill_To__c, q.Bill_To_Name__c, q.Additional_To__c, 
                             q.Additional_To_Name__c, q.Account_Name__c,(Select Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                                                         SystemModstamp, LastActivityDate, Date__c, Discount__c, Line_Item_Description__c, List_Price__c, Product__c, Product_Code__c, Quantity__c, BOATBUILDING__Product_Type__c,
                                                                         Quote__c, Sales_Price__c, Sub_Total__c, Total_Price__c, Option_Category__c, Name__c, BOATBUILDING__Total_Dealer_Price__c, BOATBUILDING__Total_Retail_Price__c From BOATBUILDING__Quote_Line_Item__r) From BOATBUILDING__Quote__c q where q.Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];    
                if(objQuote2.CO_Buyer_Name__c == null) { 
                    checkBoxExist = false;  
                }
                checkCustomer = false;
                checkCoBuyer = false;
                showPopup = false;
            }
        } catch(Exception ex){System.debug('Debug log: '+ex);}
        return null;
    }
    
    public PageReference changeCoBuyer() {
        //public Boolean checkCustomer { get; set; }
        //public Boolean checkCoBuyer { get; set; }
        if(checkCoBuyer == true) {
            checkCustomer = false;
            checkCoBuyer = false; 
            showPopup = false;
        }  
        return null;
    }
    
    public PageReference saveAndSendQuote(){
        
        Attachment myAttach = new Attachment();
        if(objQuote.Id != null){
            myAttach.ParentId = objQuote.Id;//Id of the object to which the page is attached
            myAttach.name = 'Quotation.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
                try{
                    insert myAttach;
                    System.debug('DebugLog For myAttach: '+myAttach + ' ' +objQuote2.Id);
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }
            }
            
        }else if(objQuote2.Id != null){
            
            myAttach.ParentId = objQuote2.Id;
            myAttach.name = 'Quotation.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
                try{
                    insert myAttach;
                    System.debug('DebugLog For myAttach: '+myAttach + ' ' +objQuote2.Id);
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }
            }
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(ApexPages.currentPage().getParameters().get('strSubject') != null && ApexPages.currentPage().getParameters().get('strSubject') != '') {
            mail.setSubject(ApexPages.currentPage().getParameters().get('strSubject'));
        }
        else {
            mail.setSubject('** Quote **');
        }
        if(ApexPages.currentPage().getParameters().get('strBody') != null && ApexPages.currentPage().getParameters().get('strBody') != '') {
            mail.setPlainTextBody(ApexPages.currentPage().getParameters().get('strBody'));
            
        }
        else {
            mail.setPlainTextBody('Please Find The Attachment.');
        }
        if(ApexPages.currentPage().getParameters().get('strCC') != null && ApexPages.currentPage().getParameters().get('strCC') != '') {
            mail.setCcAddresses(new String[]{ApexPages.currentPage().getParameters().get('strCC')});
        }
        if(objContact.Email != null && objContact.Email != ''){
            mail.setToAddresses(new String[]{objContact.Email});
        }else if(objQuote2.Email__c != null && objQuote2.Email__c != ''){
            mail.setToAddresses(new String[]{objQuote2.Email__c});
        }
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment where Id = :myAttach.Id limit 1])
        {
            // Add to attachment file list
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
        }
        mail.setFileAttachments(fileAttachments);
        
        mail.setSenderDisplayName(UserInfo.getOrganizationName());
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            Task t1 =  new Task(
                Subject = 'Email : ' + ApexPages.currentPage().getParameters().get('strSubject'),
                WhatId = objQuote2.Id,
                TaskSubtype = 'Email',
                ActivityDate = Date.today()
            );
            String body = ApexPages.currentPage().getParameters().get('strBody');
            if( String.isNotBlank(body) && body.length() <= 32000){
                t1.Description = body;
            }
            insert t1;

            Task t2 =  new Task(
                Subject = 'Email : ' + ApexPages.currentPage().getParameters().get('strSubject'),
                WhatId = objQuote2.Account_Name__c,
                TaskSubtype = 'Email',
                ActivityDate = Date.today()
            );
            if( String.isNotBlank(body) && body.length() <= 32000){
                t2.Description = body;
            }
            insert t2;
            
        }
        
        
        
        return new PageReference('/'+objQuote2.Id);  
    }
    // To check if the user has send email permission
    private static Boolean canSendEmails = null;
    public static Boolean getCanSendEmails() {
        if (canSendEmails == null) {
            // An attempt to reserve some email capacity is the only means available for determining permissions
            // or limits issues. In the case of a lack of permissions, System.NoAccessException is thrown. If
            // limits are exhausted then System.HandledException is thrown
            try {
                Messaging.reserveSingleEmailCapacity(1);

                canSendEmails = true;
            } catch (Exception e) {
                canSendEmails = false;
            }
        }

        return canSendEmails;
    }
    
    public PageReference saveQuoteasPDF() {
        Attachment myAttach = new Attachment();
        List<Attachment> lstAttachment = new List<Attachment>();
        if(objQuote.Id != null){
            lstAttachment = [SELECT Id,IsDeleted,ParentId FROM Attachment WHERE ParentId =: objQuote.Id];
            if(lstAttachment.size()>0){
                try{
                    delete lstAttachment;
                }
                catch(Exception ex){
                    System.debug('Debug log for Exception while deleting Attachments'+ex);
                }
            }
            myAttach.ParentId = objQuote.Id;//Id of the object to which the page is attached
            myAttach.name = 'Quotation.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
                try{
                    insert myAttach;
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }
            }
            
        }else if(objQuote2.Id != null){
            lstAttachment = [SELECT Id,IsDeleted,ParentId FROM Attachment WHERE ParentId =: objQuote2.Id];
            if(lstAttachment.size()>0){
                try{
                    delete lstAttachment;
                }
                catch(Exception ex){
                    System.debug('Debug log for Exception while deleting Attachments'+ex);
                }
            }
            myAttach.ParentId = objQuote2.Id;//Id of the object to which the page is attached
            myAttach.name = 'Quotation.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
                try{
                    insert myAttach;
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }
            }
            
        }
        
        return new PageReference('/servlet/servlet.FileDownload?file='+myAttchId);
    }
    
    
    
    
    
    
    
    
    public void getDeleteDealerOptionPriceSub() {
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);
        if(lstQuoteLineItem.size() > 0){
            for(Integer i = 0 ; i < lstQuoteLineItem.size() ; i++) {
                if(lstQuoteLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstQuoteLineItem[i].Total_Price__c != null && dealerOptionTotal > 0){
                    if(lstQuoteLineItem[i].Total_Price__c != null){
                        dealerOptionTotal -= lstQuoteLineItem[i].Total_Price__c;
                    }
                    if(lstQuoteLineItem[i].Total_Price__c != null && totalPrice > 0){
                        totalPrice -= lstQuoteLineItem[i].Total_Price__c;
                    }
                    lstQuoteLineItem.remove(i);
                }
            }
        }
        if(lstInventoryLineItem.size() > 0){
            for(Integer i = 0 ; i < lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && dealerOptionCostTotal > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null ){
                        dealerOptionCostTotal -= lstInventoryLineItem[i].Dealer_Price__c;
                    }
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && totalPriceDealer > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null){
                        totalPriceDealer -= lstInventoryLineItem[i].Dealer_Price__c;
                    }
                    lstInventoryLineItem.remove(i);
                }
            }
        }
        if(!objInventory2.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
            for(Integer i = 0 ; i < objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() ; i++){
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Product_Code__c == dealerPartNumber){
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null ){
                        dealerOptionCostTotal -= objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c;
                    }
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null){
                        totalPriceDealer -= objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c;
                    }
                    
                    invLineIdDlt.add(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Id);    
                } 
            }   
        }
        System.debug('Debug Log For lstDealerOptionWraper1: '+lstDealerOptionWraper);
        System.debug('Debug Log For lstDealerOptionWraper.size()1: '+lstDealerOptionWraper.size());
        for(Integer i = 0; i < lstDealerOptionWraper.size(); i++) {
            if(lstDealerOptionWraper[i].objDealerOption.Part_Number__c == dealerPartNumber) {
                lstDealerOptionWraper.remove(i);
            }
        }
        System.debug('Debug Log For lstDealerOptionWraper2: '+lstDealerOptionWraper);
        System.debug('Debug Log For lstDealerOptionWraper.size()2: '+lstDealerOptionWraper.size());
    }

    public void renderDOList(String recId) {
        Decimal totalRetail = 0.00;
        Decimal totalDealer = 0.00;
        for(DealerOptionWraper objDO: lstDealerOptionWraper) {
            if(objDO.objDealerOption.Id == recId) {
                Decimal Quantity = objDO.objDealerOption.Quantity__c != null ? objDO.objDealerOption.Quantity__c : 1;
                objDO.totalRetailPrice = objDO.objDealerOption.BOATBUILDING__Retail_Price__c != null ? objDO.objDealerOption.BOATBUILDING__Retail_Price__c * Quantity : 0.00;
                objDO.totalDealerPrice = objDO.objDealerOption.BOATBUILDING__Cost__c != null ? objDO.objDealerOption.BOATBUILDING__Cost__c * Quantity: 0.00;
            }
            if(objDO.isSelect) {
                totalRetail += objDO.totalRetailPrice;
                totalDealer += objDO.totalDealerPrice;
            }
        } 
        dealerOptionCostTotal = totalDealer.setScale(2);
        dealerOptionTotal = totalRetail.setScale(2);
        totalPriceDealer = yourPriceThirdPageForProductPriceDealer + MfgOptDealerTota + dealerOptionCostTotal;
        totalPrice = yourPriceThirdPageForProductPrice + MfgOptTota + dealerOptionTotal;
    }

    public void renderPPList(String recId, Decimal qt) {
        Decimal totalRetail = 0.00;
        Decimal totalDealer = 0.00;
        for(PriceAndProductOptionWraperClass obj: lstPriceAndProductOptionWraperClass) {
            for(CheckBoxWraper objC: obj.lstProductPriceForSelectedCategory) {
                if(objC.objProductPriceForSelectedCategory.Id == recId) {
                    Decimal Quantity = qt;
                    objC.totalRetailWithQuantity = objC.objProductPriceForSelectedCategory.ProductRetail_Price__c != null ? objC.objProductPriceForSelectedCategory.ProductRetail_Price__c * Quantity : 0.00;
                    objC.totalDealerWithQuantity = objC.objProductPriceForSelectedCategory.Dealer_Price__c != null ? objC.objProductPriceForSelectedCategory.Dealer_Price__c * Quantity: 0.00;
                }
                if(objC.checkBox) {
                    totalRetail += objC.totalRetailWithQuantity;
                    totalDealer += objC.totalDealerWithQuantity;
                } 
            }
        }
        MfgOptDealerTota = totalDealer;
        MfgOptTota = totalRetail;
        totalPriceDealer = yourPriceThirdPageForProductPriceDealer + MfgOptDealerTota + dealerOptionCostTotal;
        totalPrice = yourPriceThirdPageForProductPrice + MfgOptTota + dealerOptionTotal;
        System.debug('renderPPList>>>>>yourPriceThirdPageForProductPriceDealer: '+yourPriceThirdPageForProductPriceDealer);
        System.debug('renderPPList>>>>>MfgOptDealerTota: '+MfgOptDealerTota);
        System.debug('renderPPList>>>>>MfgOptTota: '+MfgOptTota);
        System.debug('renderPPList>>>>>totalPriceDealer: '+totalPriceDealer);
        System.debug('renderPPList>>>>>totalPrice: '+totalPrice);
    }
    
    public class PriceAndProductOptionWraperClass{
        public Decimal retailPrice { get; set; }
        public String partNumber { get; set; }
        public String strSelectedOption {    get; set; }
        public List<CheckBoxWraper> lstProductPriceForSelectedCategory { get; set; }
        
        public PriceAndProductOptionWraperClass( String strSelectedOption, list<CheckBoxWraper> lstProductPriceForSelectedCategory){
            this.lstProductPriceForSelectedCategory = lstProductPriceForSelectedCategory;
            this.strSelectedOption = strSelectedOption;
            this.partNumber = partNumber;
            this.retailPrice = retailPrice;
        } 
    }
    
    public class CheckBoxWraper{
        public Boolean checkBox { get; set; }
        public BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory { get; set; } 
        public Double totalRetailWithQuantity { get; set; }
        public Double totalDealerWithQuantity { get; set; } 
        public Integer rowNumber { get; set; }
        
        public CheckBoxWraper(Boolean checkBox,Integer rowNumber, BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory){
            this.checkBox = checkBox;
            this.rowNumber = rowNumber;
            this.objProductPriceForSelectedCategory = objProductPriceForSelectedCategory;
            Decimal Quantity = objProductPriceForSelectedCategory.Quantity__c != null ? objProductPriceForSelectedCategory.Quantity__c : 0.00;
            this.totalRetailWithQuantity = objProductPriceForSelectedCategory.ProductRetail_Price__c != null ? objProductPriceForSelectedCategory.ProductRetail_Price__c * Quantity : 0.00;
            this.totalDealerWithQuantity = objProductPriceForSelectedCategory.Dealer_Price__c != null ? objProductPriceForSelectedCategory.Dealer_Price__c * Quantity: 0.00;
        }
    }
    
    public class DealerOptionWraper {
        public Boolean isSelect { get; set; }
        public Boolean ShowRemoveIcon { get; set; }
        public BOATBUILDING__Dealer_Option__c objDealerOption { get; set; }
        public Boolean Non_Taxable { get; set; }
        public Decimal totalRetailPrice { get; set; }
        public Decimal totalDealerPrice { get; set; } 
        public DealerOptionWraper(Boolean isSelect, BOATBUILDING__Dealer_Option__c objDealerOption, Boolean ShowRemoveIcon) {
            this.isSelect = isSelect;
            this.objDealerOption = objDealerOption;
            this.ShowRemoveIcon = ShowRemoveIcon;
            this.Non_Taxable = objDealerOption.BOATBUILDING__Non_Taxable__c; 
            objDealerOption.Quantity__c = objDealerOption.Quantity__c != null ? objDealerOption.Quantity__c : 1;
            totalRetailPrice = objDealerOption.Quantity__c * objDealerOption.Retail_Price__c;
            totalDealerPrice = objDealerOption.Quantity__c * objDealerOption.Cost__c;
        }
    }
    
    public class WritinCustomOption {
        public Boolean isSelect { get; set; }
        public String ProductName { get; set; }
        public Decimal Quantity { get; set; }
        public Decimal RetailPrice { get; set; }
        public Decimal DealerPrice { get; set; }
        public String ProductCode { get; set; }

        public Boolean Non_Taxable { get; set; }
        public Decimal totalRetailPrice { get; set; }
        public Decimal totalDealerPrice { get; set; } 

        public WritinCustomOption(Boolean isSelect, String ProductName, Decimal Quantity, Decimal RetailPrice, Decimal DealerPrice, String ProductCode, Boolean Non_Taxable) {
            this.isSelect = isSelect; 
            this.ProductName = ProductName;
            this.Quantity = Quantity;
            this.RetailPrice = RetailPrice;
            this.DealerPrice = DealerPrice;
            this.ProductCode = ProductCode;
            this.Non_Taxable = Non_Taxable;
            this.totalRetailPrice = RetailPrice * Quantity;
            this.totalDealerPrice = DealerPrice * Quantity;
            this.totalRetailPrice = totalRetailPrice.setscale(2);
            this.totalDealerPrice = totalDealerPrice.setscale(2);
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
    /*
decDO = '';
retDO = '0.00';
delDO = '0.00';
pnDO = '';
*/ 
    public PageReference updateDealerOptionList() {
        //lstDealerOptionWraper
        BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
        objDOO.Name = decDO;
        System.debug('Debug Log For retDO: '+retDO);
        System.debug('Debug Log For delDO: '+delDO); 
        objDOO.BOATBUILDING__Retail_Price__c = Decimal.valueOf(retDO);
        objDOO.BOATBUILDING__Cost__c = Decimal.valueOf(delDO);
        objDOO.BOATBUILDING__Part_Number__c = pnDO;
        objDOO.Quantity__c = Double.valueOf(qtDo);
        if(tcDo == '1') {
            objDOO.Non_Taxable__c = true;
        } else { 
            objDOO.Non_Taxable__c = false;
        }
        dealerPartNumber = pnDO;
        System.debug('Debug Log For objDOO: '+objDOO);
        buttonRenderForPlaceOrder = true;
        lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, true));
        getDealerOptionPrice();
        return null;
    }

    public PageReference updateCWROList() {

        System.debug('Debug Log For retDO: '+retDO);
        System.debug('Debug Log For delDO: '+delDO);
        System.debug('Debug Log For pnDO: '+pnDO); 
        System.debug('Debug Log For qtDo: '+qtDo);
        System.debug('Debug Log For tcDo: '+tcDo);
        Boolean taxable = false;
        if(tcDo == '1') {
            taxable = true;
        } else { 
            taxable = false;
        }
        WritinCustomOption objWritinCustomOption = new WritinCustomOption(true, 
                                                                            decDO, 
                                                                                Decimal.valueOf(qtDo), 
                                                                                    Decimal.valueOf(retDO), 
                                                                                        Decimal.valueOf(delDO), 
                                                                                            pnDO, 
                                                                                                taxable);  
        lstWritinCustomOption.add(objWritinCustomOption);
        dealerPartNumber = pnDO;
        getCWOPrice();
        return null;
    } 

    public void getCWOPrice(){
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);  
        
        for(WritinCustomOption objDD :lstWritinCustomOption){
            renderCWOList(objDD.ProductCode);    
            if(objDD.ProductCode == dealerPartNumber && objDD.isSelect){
                System.debug('Debug Log For objDD.objDealerOption.Quantity__c: '+objDD.Quantity);
                BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                objQLI.Option_Category__c = 'CWO';
                objQLI.Name = 'QLI'; 
                if(objDD.ProductName != null){
                    objQLI.Name__c = objDD.ProductName;
                }
                if(objProduct.Id != null){
                    objQLI.Product__c = objProduct.Id;
                }
                if(objDD.RetailPrice != null){
                    objQLI.Total_Price__c = objDD.RetailPrice;
                }
                if(objDD.DealerPrice != null){
                    objQLI.Dealer_Price__c = objDD.DealerPrice;
                }
                objQLI.Date__c =  Date.today(); 
                if(objDD.ProductCode != null){
                    objQLI.Product_Code__c = objDD.ProductCode;
                }
                if(objDD.Quantity != null){
                    objQLI.Quantity__c = objDD.Quantity;
                }
                objQLI.Non_Taxable__c = objDD.Non_Taxable;
                if(!setcodeId.contains(objDD.ProductCode)) {
                    lstQuoteLineItem.add(objQLI);
                } else {
                    if(lstQuoteLineItem.size() > 0){
                        for(Integer i=0 ; i<lstQuoteLineItem.size() ; i++){
                            if(lstQuoteLineItem[i].Product_Code__c == objDD.ProductCode) {
                                lstQuoteLineItem[i].Quantity__c =  objDD.Quantity;
                                lstQuoteLineItem[i].Total_Price__c = objDD.RetailPrice;
                                lstQuoteLineItem[i].Dealer_Price__c = objDD.DealerPrice;
                                System.debug('>>>>lstQuoteLineItem[i].Quantity__c: '+lstQuoteLineItem[i].Quantity__c);
                            }
                        } 
                    }
                }
                
                BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
                objILI.Option_Category__c = 'CWO';
                objILI.Name = 'ILI';
                if(objDD.ProductName != null){
                    objILI.Name__c = objDD.ProductName;
                }
                if(objDD.RetailPrice != null){
                    objILI.Price__c = objDD.RetailPrice;
                }
                if(objDD.DealerPrice != null){
                    objILI.Dealer_Price__c = objDD.DealerPrice;
                }
                if(objDD.ProductCode != null){
                    objILI.Product_Code__c = objDD.ProductCode;
                }
                if(objDD.Quantity != null){
                    objILI.Quantity__c = objDD.Quantity;
                }
                objILI.Non_Taxable__c = objDD.Non_Taxable;
                if(!setcodeId.contains(objDD.ProductCode)) {
                    lstInventoryLineItem.add(objILI);
                } else {
                    if(lstInventoryLineItem.size() > 0){
                        for(Integer i=0 ; i<lstInventoryLineItem.size() ; i++){
                            if(lstInventoryLineItem[i].Product_Code__c == objDD.ProductCode) {
                                lstInventoryLineItem[i].Quantity__c =  objDD.Quantity;
                                lstInventoryLineItem[i].Price__c = objDD.RetailPrice;
                                lstInventoryLineItem[i].Dealer_Price__c = objDD.DealerPrice;
                                System.debug('>>>>lstInventoryLineItem[i].Quantity__c: '+lstInventoryLineItem[i].Quantity__c);
                            }
                        } 
                    }
                }
                setcodeId.add(objDD.ProductCode);
            }
        }
        System.debug('setcodeId: '+setcodeId);
    }

    public void getCWOPriceSub() {
        System.debug('>>>setcodeId: '+setcodeId);
        if(setcodeId.size() > 0 && setcodeId.contains(dealerPartNumber)){
            setcodeId.remove(dealerPartNumber);
        }
        System.debug('>>>dealerPartNumber: '+dealerPartNumber);
        System.debug('>>>cwoRetailTotal: '+cwoRetailTotal);
        System.debug('>>>cwoDealerTotal: '+cwoDealerTotal);
        System.debug('>>>totalPrice: '+totalPrice);
        System.debug('>>>totalPriceDealer: '+totalPriceDealer);
        if(lstQuoteLineItem.size() > 0){
            System.debug('>>>lstQuoteLineItem: '+lstQuoteLineItem);
            for(Integer i = 0 ; i < lstQuoteLineItem.size() ; i++) {
                if(lstQuoteLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstQuoteLineItem[i].Total_Price__c != null && dealerOptionTotal > 0){
                    if(lstQuoteLineItem[i].Total_Price__c != null){
                        cwoRetailTotal -= (lstQuoteLineItem[i].Total_Price__c * lstQuoteLineItem[i].Quantity__c);
                    }
                    if(lstQuoteLineItem[i].Total_Price__c != null && totalPrice > 0){
                        totalPrice -= (lstQuoteLineItem[i].Total_Price__c * lstQuoteLineItem[i].Quantity__c);
                    }
                    if(lstQuoteLineItem[i].Id != null) {
                        invLineIdDlt.add(lstQuoteLineItem[i].Id);
                    }
                    lstQuoteLineItem.remove(i);
                }
            }
        }
        if(lstInventoryLineItem.size() > 0){
            System.debug('>>>lstInventoryLineItem: '+lstInventoryLineItem);
            for(Integer i = 0 ; i < lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Product_Code__c == dealerPartNumber){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null ){
                        cwoDealerTotal -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    if(lstInventoryLineItem[i].Dealer_Price__c != null){
                        totalPriceDealer -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    lstInventoryLineItem.remove(i);
                }
            }
        }
        if(!objInventory2.BOATBUILDING__Inventory_Line_Items__r.isEmpty()) {
            for(Integer i = 0 ; i < objInventory2.BOATBUILDING__Inventory_Line_Items__r.size() ; i++){
                if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Product_Code__c == dealerPartNumber){
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null ){
                        cwoDealerTotal -= (objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c * objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Quantity__c);
                    }
                    
                    if(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c != null){
                        totalPriceDealer -= (objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Dealer_Price__c * objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Quantity__c);
                    }
                    
                    invLineIdDlt.add(objInventory2.BOATBUILDING__Inventory_Line_Items__r[i].Id);    
                } 
            }   
        }
        totalPriceDealer = totalPriceDealer.setScale(2);
        totalPrice = totalPrice.setScale(2);
    }

    public void renderCWOList(String recId) {
        Decimal totalRetail = 0.00;
        Decimal totalDealer = 0.00;
        for(WritinCustomOption objDO :lstWritinCustomOption){
            if(objDO.ProductCode == recId) {
                Decimal Quantity = objDO.Quantity != null ? objDO.Quantity : 1;
                objDO.totalRetailPrice = objDO.RetailPrice != null ? objDO.RetailPrice * Quantity : 0.00;
                objDO.totalDealerPrice = objDO.DealerPrice != null ? objDO.DealerPrice * Quantity: 0.00;
                objDO.totalRetailPrice = objDO.totalRetailPrice.setScale(2);
                objDO.totalDealerPrice = objDO.totalDealerPrice.setScale(2);
            }
            if(objDO.isSelect) { 
                totalRetail += objDO.totalRetailPrice;
                totalDealer += objDO.totalDealerPrice;
            }
        } 
        cwoDealerTotal = totalDealer.setScale(2);
        cwoRetailTotal = totalRetail.setScale(2);
        totalPriceDealer = yourPriceThirdPageForProductPriceDealer + MfgOptDealerTota + cwoDealerTotal;
        totalPrice = yourPriceThirdPageForProductPrice + MfgOptTota + cwoRetailTotal;
        totalPriceDealer = totalPriceDealer.setScale(2);
        totalPrice = totalPrice.setScale(2);
    }

}