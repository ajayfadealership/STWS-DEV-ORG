public class BBWizardController {
    
    @AuraEnabled
    public static String getApprovalCheck(String AcvId) {
        if(ACVController.checkApprovalStatus(AcvId)) {
            return '1';
        }
        return '0';
    }   
    
    @AuraEnabled
    public static Quote__c generateQuote(String strAccountId, String strInvId, String ProId, String ACVId, String regFee, String docFee, 
                                            String trlRegFee, List<String> lstProductPrice, List<String> lstProductPriceQT, List<String> lstDealerOption, 
                                                    Quote__c objQT, String lstDO, List<String> lstDealerOptionQT) {
        Quote__c objQuote = new Quote__c();
        try {
            System.debug('Debug Log For strAccountId: '+strAccountId);
            System.debug('Debug Log For strInvId: '+strInvId);
            System.debug('Debug Log For ProId: '+ProId);
            System.debug('Debug Log For ACVId: '+ACVId);
            System.debug('Debug Log For regFeeId: '+regFee);    
            System.debug('Debug Log For docFee: '+docFee);
            System.debug('Debug Log For trlRegFee: '+trlRegFee); 
            System.debug('Debug Log For lstProductPrice: '+lstProductPrice);
            System.debug('Debug Log For lstProductPriceQT: '+lstProductPriceQT);
            System.debug('Debug Log For lstDealerOption: '+lstDealerOption);
            System.debug('Debug Log For objQT: '+objQT);
            System.debug('Debug Log For lstDO: '+lstDO);
            System.debug('Debug Log For lstDealerOptionQT: '+lstDealerOptionQT);
            
            String selectedType = '';
            Decimal yourPriceThirdPageForProductPrice = 0.00;
            Decimal totalPrice = 0.00;
            Decimal MfgOptTota = 0.00;
            Decimal dealerOptionTotal = 0.00;
            String smVrnt = '';
            String strSupraName = '';
            String ManufacturerCheck = '';
            String selectedManufacture = '';
            String selectedModel = '';
            String selectedModelVariant = '';
            String manufacturerStatus = '';
            String dealerStatus = '';
            Boolean modelVarientFlag = false; 
            
            Item__c objItem = new Item__c(); 
            
            objQuote = objQT;
            objQuote.BOATBUILDING__State__c = objQT.BOATBUILDING__State__c;
            List<Quote_Line_Item__c> lstQLI = new List<Quote_Line_Item__c>();
            Product__c objProduct = new Product__c();
            Inventory__c objInventory = new Inventory__c();
            Contact objContact = new Contact();
            Account objAccount = new Account();
            
            List<Contact> listConToProcess = [SELECT Id, FirstName,LastName,MailingStreet,AccountId, MailingCity, MailingState, MailingCountry,
                                              Email, Phone FROM Contact where Id =: strAccountId limit 1 ];
            
            if(!listConToProcess.isEmpty()){
                objContact = listConToProcess[0];             
            }
            if(objContact!= null && objContact.AccountId != null) {
                objAccount = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingCountry, ShippingPostalCode, Email__c,
                              Phone FROM Account where Id =:objContact.AccountId];
            } 
            
            if(ProId != '0') {
                List<BOATBUILDING__Product__c> listProdToProcess = [Select b.OwnerId, b.Name,  b.LastModifiedDate, b.LastModifiedById, b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__State__c, b.BOATBUILDING__Sale_Price__c, b.BOATBUILDING__Quantity_In_Stock__c, b.BOATBUILDING__Product_Type__c, b.BOATBUILDING__Product_Short_Description__c, b.BOATBUILDING__Product_Manufacturer__c, b.BOATBUILDING__Product_Long_Description__c, b.BOATBUILDING__ProductName__c, b.BOATBUILDING__Prep__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__M_Your_Price_Calculated__c, b.BOATBUILDING__M_Year__c, b.BOATBUILDING__M_V_Drive__c, b.BOATBUILDING__M_Trailer_Trade_Allowance__c, b.BOATBUILDING__M_Trailer_Sales_Tax__c, b.BOATBUILDING__M_Trailer_Reg_Fee__c, b.BOATBUILDING__M_Trailer_MSRP_PRICE__c, b.BOATBUILDING__M_Trailer_Actual_Cost_Value_ACV__c, b.BOATBUILDING__M_Trade_PayOFF__c, b.BOATBUILDING__M_Total_Price_Calculated__c, b.BOATBUILDING__M_Total_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Total_MSRP__c, b.BOATBUILDING__M_Total_Due__c, b.BOATBUILDING__M_Total_Amount_Financed_Calculated__c, b.BOATBUILDING__M_Shipped_Date__c, b.BOATBUILDING__M_Selected_Category__c, b.BOATBUILDING__M_Rfinance_Rate__c, b.BOATBUILDING__M_Retail_Price__c, b.BOATBUILDING__M_Requested_Ship_Date__c, b.BOATBUILDING__M_Received_Date__c, b.BOATBUILDING__M_Quote_Date__c, b.BOATBUILDING__M_Quantity__c, b.BOATBUILDING__M_Purchase_Line_Item__c, b.BOATBUILDING__M_Product_Salesperson_new__c, b.BOATBUILDING__M_Product_Retail_Price_To__c, b.BOATBUILDING__M_Product_Retail_Price_From__c, b.BOATBUILDING__M_Product_Family__c, b.BOATBUILDING__M_Payment__c, b.BOATBUILDING__M_Order_Date_To__c, b.BOATBUILDING__M_Order_Date_From__c, b.BOATBUILDING__M_Option_Category__c, b.BOATBUILDING__M_Net_Selling_Price_Calculated__c, b.BOATBUILDING__M_Model_Variant__c, b.BOATBUILDING__M_Manufacturer1__c, b.BOATBUILDING__M_Manufacture_Status__c, b.BOATBUILDING__M_Hidden_Box__c, b.BOATBUILDING__M_Finance_Term__c, b.BOATBUILDING__M_Engine__c, b.BOATBUILDING__M_Down_Payment__c, b.BOATBUILDING__M_Doc_Fee__c, b.BOATBUILDING__M_Discount__c, b.BOATBUILDING__M_Description__c, b.BOATBUILDING__M_Dealer_Stock__c, b.BOATBUILDING__M_Dealer_Status__c, b.BOATBUILDING__M_Dealer_Flat_Discount__c, b.BOATBUILDING__M_Dealer_Discount__c, b.BOATBUILDING__M_Dealer_Comments__c, b.BOATBUILDING__M_Dealer_COD_Discount__c, b.BOATBUILDING__M_Dealer_Base_Price__c, b.BOATBUILDING__M_Deal_Margin__c, b.BOATBUILDING__M_Date_Received__c, b.BOATBUILDING__M_Boat_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Boat_Trade_Allowance__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c, b.BOATBUILDING__M_Boat_Reg_Fee__c, b.BOATBUILDING__M_Boat_MSRP_PRICE__c, b.BOATBUILDING__M_Boat_Actual_Cost_Value_ACV__c, b.BOATBUILDING__MSRP__c, b.BOATBUILDING__MModel2__c, b.BOATBUILDING__Is_Active__c, b.BOATBUILDING__Hull_Id__c, b.BOATBUILDING__Freight__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Custom__c, b.BOATBUILDING__Cost_Price__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Account__c From BOATBUILDING__Product__c b Where Id =: ProId Limit 1];
                if(!listProdToProcess.isEmpty()){
                    objProduct = listProdToProcess[0];
                }
            } else if(strInvId != '0') { 
                objInventory = [Select b.BOATBUILDING__Engine_1_SN__c, b.BOATBUILDING__Engine_2_SN__c, b.BOATBUILDING__Engine_3_SN__c, b.BOATBUILDING__Engine_4_SN__c, b.RecordType.Name, b.BOATBUILDING__Our_Instant_Quote_Price__c ,b.RecordTypeId, b.OwnerId, b.Name, b.LastModifiedDate, b.LastModifiedById, b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Year__c, b.BOATBUILDING__Window_sticker_Term__c, b.BOATBUILDING__Window_Sticker_Your_Price__c, b.BOATBUILDING__Window_Sticker_Payment__c, b.BOATBUILDING__Window_Sticker_Our_Discount__c, b.BOATBUILDING__Window_Sticker_MSRP__c, b.BOATBUILDING__Window_Sticker_Interest_Rate__c, b.BOATBUILDING__Website__c, b.BOATBUILDING__Website_Page_Name__c, b.BOATBUILDING__Web_width__c, b.BOATBUILDING__Web_Year__c, b.BOATBUILDING__Web_Video__c, b.BOATBUILDING__Web_Term__c, b.BOATBUILDING__Web_Propulsion__c, b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Product_ID__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Payment__c, b.BOATBUILDING__Web_Payment_Formula__c, b.BOATBUILDING__Web_Part_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__Web_Part_Name__c, b.BOATBUILDING__Web_Part_Description__c, b.BOATBUILDING__Web_Page_Name__c, b.BOATBUILDING__Web_Model__c, b.BOATBUILDING__Web_Make__c, b.BOATBUILDING__Web_MSRP__c, b.BOATBUILDING__Web_Location__c, b.BOATBUILDING__Web_Interest_Rate__c, b.BOATBUILDING__Web_Hull_Material__c, b.BOATBUILDING__Web_Fuel_Type__c, b.BOATBUILDING__Web_Engine__c, b.BOATBUILDING__Web_Engine_HP__c, b.BOATBUILDING__Web_Down_Payment__c, b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Web_Condition__c, b.BOATBUILDING__Web_Color__c, b.BOATBUILDING__Web_Boat_Length__c, b.BOATBUILDING__Web_360_Video__c, b.BOATBUILDING__Walkthrough__c, b.BOATBUILDING__Vendor__c, b.BOATBUILDING__Vehicle_Type__c, b.BOATBUILDING__UsedBoatStatus__c, b.BOATBUILDING__Underwater_lights__c, b.BOATBUILDING__Transom_remote__c, b.BOATBUILDING__Transom__c, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_wheels__c, b.BOATBUILDING__Trailer_Year__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Model__c, b.BOATBUILDING__Trailer_Make__c, b.BOATBUILDING__Trailer_ID__c, b.BOATBUILDING__Trailer_Axles__c, b.BOATBUILDING__Tower_speakers__c, b.BOATBUILDING__Total_Profit__c, b.BOATBUILDING__Total_MSRP_Price__c, b.BOATBUILDING__Total_Inventory_MSRP__c, b.BOATBUILDING__Total_Inventory_Cost__c, b.BOATBUILDING__Total_Dealer_Price__c, b.BOATBUILDING__Tied_Up_Cash__c, b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Surf_system__c, b.BOATBUILDING__Suggested_List_Price__c, b.BOATBUILDING__Sub_Class_Pick_List__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__Steering_wheel_controls__c, b.BOATBUILDING__Status_for_Interest_Start_Date__c, b.BOATBUILDING__Status_for_Days_on_the_Lot__c, b.BOATBUILDING__Status_for_Curtailment_Start_Date__c, b.BOATBUILDING__Status__c, b.BOATBUILDING__Stage__c, b.BOATBUILDING__Speed_Wakeplate_levers__c, b.BOATBUILDING__Sold_Date__c, b.BOATBUILDING__Sold_By__c, b.BOATBUILDING__Size__c, b.BOATBUILDING__Side__c, b.BOATBUILDING__Serial_Number_2__c, b.BOATBUILDING__Running_gear__c, b.BOATBUILDING__Rigging_Cost__c, b.BOATBUILDING__Quantity__c, b.BOATBUILDING__Phone_holder__c, b.BOATBUILDING__Payment_base_on_financing__c, b.BOATBUILDING__Part__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Name__c, b.BOATBUILDING__Part_MSRP_Price__c, b.BOATBUILDING__Part_Location__c, b.BOATBUILDING__Owner__c, b.BOATBUILDING__Order_Number__c, b.BOATBUILDING__Net_Weight__c, b.BOATBUILDING__Model__c, b.BOATBUILDING__Model_Variant__c, b.BOATBUILDING__Model_Image__c, b.BOATBUILDING__Minimum_Sell_Price__c, b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Min_ACV_Difference__c, b.BOATBUILDING__Mfg_Invoice__c, b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Manufacturer__c, b.BOATBUILDING__Manufacture_Invoice__c, b.BOATBUILDING__Manufacture_Invoice2__c, b.BOATBUILDING__Location__c, b.BOATBUILDING__Invoice_Number__c, b.BOATBUILDING__Inventory_Deposit_Account__c, b.BOATBUILDING__Interior_Design_Bow__c, b.BOATBUILDING__Interest_Start_Date__c, b.BOATBUILDING__Hull_Material__c, b.BOATBUILDING__Hull_ID__c, b.BOATBUILDING__HIN_Number__c, b.BOATBUILDING__Floor_Plan_Bank__c, b.BOATBUILDING__Family__c, b.BOATBUILDING__Extra_Pic_one__c, b.BOATBUILDING__Extra_Pic_Two__c, b.BOATBUILDING__Extra_Pic_Three__c, b.BOATBUILDING__Extra_Pic_Four__c, b.BOATBUILDING__Engine_compartment__c, b.BOATBUILDING__Engine__c, b.BOATBUILDING__Engine_Year__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Engine_Model__c, b.BOATBUILDING__Engine_Make__c, b.BOATBUILDING__Engine_Key_Number__c, b.BOATBUILDING__Display_On_Web__c, b.BOATBUILDING__Discount__c, b.BOATBUILDING__Description__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Dealer_Stock__c, b.BOATBUILDING__Dealer_Status__c, b.BOATBUILDING__Dealer_Prep__c, b.BOATBUILDING__Dealer_Flat_Discount__c, b.BOATBUILDING__Dealer_Discount__c, b.BOATBUILDING__Dealer_Comments__c, b.BOATBUILDING__Dealer_COD_Discount__c, b.BOATBUILDING__Dealer_Base_Price__c, b.BOATBUILDING__Days_on_Lot__c, b.BOATBUILDING__Date_on_FloorPlan__c, b.BOATBUILDING__Date_First_on_Sales_Lot__c, b.BOATBUILDING__Date_Arrived__c, b.BOATBUILDING__Dash_cluster__c, b.BOATBUILDING__Dash_Screen__c, b.BOATBUILDING__Curtailment_Start_Date__c, b.BOATBUILDING__Costline__c, b.BOATBUILDING__Costline_Value__c, b.BOATBUILDING__Costline_Points__c, b.BOATBUILDING__Cost__c, b.BOATBUILDING__Cooler__c, b.BOATBUILDING__Convertible_seating__c, b.BOATBUILDING__Color__c, b.BOATBUILDING__Category__c, b.BOATBUILDING__Cabin__c, b.BOATBUILDING__Bow__c, b.BOATBUILDING__Boat_Weight__c, b.BOATBUILDING__Boat_Weight_Maximum_Capacity__c, b.BOATBUILDING__Boat_Type__c, b.BOATBUILDING__Boat_Seating_Capacity__c, b.BOATBUILDING__Boat_Overall_Length__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Fuel_Capacity__c, b.BOATBUILDING__Boat_EST_Arrival_Date__c, b.BOATBUILDING__Boat_Draft__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Boat_Cargo_Capacity__c, b.BOATBUILDING__Boat_Capacities__c, b.BOATBUILDING__Boat_Ballast_Weight__c, b.BOATBUILDING__Board_racks__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Beam__c, b.BOATBUILDING__Backup_Camera__c, b.BOATBUILDING__B_roll__c, b.BOATBUILDING__Amount_Boat_Is_Floored__c, b.BOATBUILDING__ACV__c, b.BOATBUILDING__ACV_Floored_Difference__c From BOATBUILDING__Inventory__c b Where Id =: strInvId Limit 1];
                
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
                if(objInventory.BOATBUILDING__Engine_1_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_1_SN__c = objInventory.BOATBUILDING__Engine_1_SN__c;
                }
                if(objInventory.BOATBUILDING__Engine_2_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_2_SN__c = objInventory.BOATBUILDING__Engine_2_SN__c;
                }   
                if(objInventory.BOATBUILDING__Engine_3_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_3_SN__c = objInventory.BOATBUILDING__Engine_3_SN__c;
                }
                if(objInventory.BOATBUILDING__Engine_4_SN__c != null){             
                    objQuote.BOATBUILDING__Engine_4_SN__c = objInventory.BOATBUILDING__Engine_4_SN__c;
                }
                //objQuote.BOATBUILDING__State__c = state;
                //if(state == 'Other') {
                //objQuote.BOATBUILDING__Manual_Sales_Tax_Entry__c  = Decimal.valueOf(MaualTax);
                //}
                
                if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'New Boats') {
                    selectedType = 'New Boat'; 
                } else if(objInventory.RecordType.Name != null && objInventory.RecordType.Name == 'Used Boats') {
                    selectedType = 'Used Boat';
                } else {
                    selectedType = objInventory.RecordType.Name; 
                }
                
                List<RecordType> lstRecTT = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
                
                if(lstRecTT[0].Id == objInventory.RecordTypeId) {
                    if(objInventory.Cost__c != null){                                                      
                        yourPriceThirdPageForProductPrice = objInventory.Cost__c;
                    }else{  
                        yourPriceThirdPageForProductPrice = 0.00;
                    }
                } else {
                    if(objInventory.Suggested_List_Price__c != null){                                                      
                        yourPriceThirdPageForProductPrice = objInventory.Suggested_List_Price__c;
                    }else{
                        yourPriceThirdPageForProductPrice = 0.00;
                    }
                }  
                totalPrice += yourPriceThirdPageForProductPrice;
                System.debug('Debug Log For totalPrice: '+totalPrice);
                
                if(objInventory.Model_Variant__c != null){
                    smVrnt = objInventory.Model_Variant__c;
                }
                if(objInventory.Manufacturer__c != null){
                    strSupraName = objInventory.Manufacturer__c;
                    BOATBUILDING__Manufacturer__c objManufacurer = [Select Id,Name, BOATBUILDING__Model_Variant__c from BOATBUILDING__Manufacturer__c where Name =: objInventory.Manufacturer__c limit 1];
                    if(objManufacurer != null) {
                        selectedManufacture = objManufacurer.Name;
                        modelVarientFlag = objManufacurer.BOATBUILDING__Model_Variant__c;
                    }
                    
                }
                if(objInventory.Model__c != null){
                    selectedModel = objInventory.Model__c;
                }
                if(objInventory.Model_Variant__c!=null){
                    selectedModelVariant = objInventory.Model_Variant__c;
                }
                
                
                if(objInventory.Year__c != null && (!modelVarientFlag) ){
                    if(selectedModel != null){
                        List<Product__c> lstPro = [Select  b.OwnerId, b.Name, b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__State__c, b.BOATBUILDING__Sale_Price__c, b.BOATBUILDING__Quantity_In_Stock__c, b.BOATBUILDING__Product_Type__c, b.BOATBUILDING__Product_Short_Description__c, b.BOATBUILDING__Product_Manufacturer__c, b.BOATBUILDING__Product_Long_Description__c, b.BOATBUILDING__ProductName__c, b.BOATBUILDING__Prep__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__M_Your_Price_Calculated__c, b.BOATBUILDING__M_Year__c, b.BOATBUILDING__M_V_Drive__c, b.BOATBUILDING__M_Trailer_Trade_Allowance__c, b.BOATBUILDING__M_Trailer_Sales_Tax__c, b.BOATBUILDING__M_Trailer_Reg_Fee__c, b.BOATBUILDING__M_Trailer_MSRP_PRICE__c, b.BOATBUILDING__M_Trailer_Actual_Cost_Value_ACV__c, b.BOATBUILDING__M_Trade_PayOFF__c, b.BOATBUILDING__M_Total_Price_Calculated__c, b.BOATBUILDING__M_Total_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Total_MSRP__c, b.BOATBUILDING__M_Total_Due__c, b.BOATBUILDING__M_Total_Amount_Financed_Calculated__c, b.BOATBUILDING__M_Shipped_Date__c, b.BOATBUILDING__M_Selected_Category__c, b.BOATBUILDING__M_Rfinance_Rate__c, b.BOATBUILDING__M_Retail_Price__c, b.BOATBUILDING__M_Requested_Ship_Date__c, b.BOATBUILDING__M_Received_Date__c, b.BOATBUILDING__M_Quote_Date__c, b.BOATBUILDING__M_Quantity__c, b.BOATBUILDING__M_Purchase_Line_Item__c, b.BOATBUILDING__M_Product_Salesperson_new__c, b.BOATBUILDING__M_Product_Retail_Price_To__c, b.BOATBUILDING__M_Product_Retail_Price_From__c, b.BOATBUILDING__M_Product_Family__c, b.BOATBUILDING__M_Payment__c, b.BOATBUILDING__M_Order_Date_To__c, b.BOATBUILDING__M_Order_Date_From__c, b.BOATBUILDING__M_Option_Category__c, b.BOATBUILDING__M_Net_Selling_Price_Calculated__c, b.BOATBUILDING__M_Model_Variant__c, b.BOATBUILDING__M_Manufacturer1__c, b.BOATBUILDING__M_Manufacture_Status__c, b.BOATBUILDING__M_Hidden_Box__c, b.BOATBUILDING__M_Finance_Term__c, b.BOATBUILDING__M_Engine__c, b.BOATBUILDING__M_Down_Payment__c, b.BOATBUILDING__M_Doc_Fee__c, b.BOATBUILDING__M_Discount__c, b.BOATBUILDING__M_Description__c, b.BOATBUILDING__M_Dealer_Stock__c, b.BOATBUILDING__M_Dealer_Status__c, b.BOATBUILDING__M_Dealer_Flat_Discount__c, b.BOATBUILDING__M_Dealer_Discount__c, b.BOATBUILDING__M_Dealer_Comments__c, b.BOATBUILDING__M_Dealer_COD_Discount__c, b.BOATBUILDING__M_Dealer_Base_Price__c, b.BOATBUILDING__M_Deal_Margin__c, b.BOATBUILDING__M_Date_Received__c, b.BOATBUILDING__M_Boat_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Boat_Trade_Allowance__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c, b.BOATBUILDING__M_Boat_Reg_Fee__c, b.BOATBUILDING__M_Boat_MSRP_PRICE__c, b.BOATBUILDING__M_Boat_Actual_Cost_Value_ACV__c, b.BOATBUILDING__MSRP__c, b.BOATBUILDING__MModel2__c, b.BOATBUILDING__Is_Active__c, b.BOATBUILDING__Hull_Id__c, b.BOATBUILDING__Freight__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Custom__c, b.BOATBUILDING__Cost_Price__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Account__c From BOATBUILDING__Product__c b
                                      where 
                                      MModel2__c=: selectedModel 
                                      AND 
                                      M_Year__c =: objInventory.Year__c AND Product_Type__c =: selectedType
                                      limit 1];
                        if(!lstPro.isEmpty())
                            objProduct = lstPro[0];
                    }
                    
                    
                }else if(objInventory.Year__c != null && modelVarientFlag  ){
                    if(selectedModelVariant != null){ 
                        List<Product__c> lstPro = [Select b.OwnerId, b.Name, b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__State__c, b.BOATBUILDING__Sale_Price__c, b.BOATBUILDING__Quantity_In_Stock__c, b.BOATBUILDING__Product_Type__c, b.BOATBUILDING__Product_Short_Description__c, b.BOATBUILDING__Product_Manufacturer__c, b.BOATBUILDING__Product_Long_Description__c, b.BOATBUILDING__ProductName__c, b.BOATBUILDING__Prep__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__M_Your_Price_Calculated__c, b.BOATBUILDING__M_Year__c, b.BOATBUILDING__M_V_Drive__c, b.BOATBUILDING__M_Trailer_Trade_Allowance__c, b.BOATBUILDING__M_Trailer_Sales_Tax__c, b.BOATBUILDING__M_Trailer_Reg_Fee__c, b.BOATBUILDING__M_Trailer_MSRP_PRICE__c, b.BOATBUILDING__M_Trailer_Actual_Cost_Value_ACV__c, b.BOATBUILDING__M_Trade_PayOFF__c, b.BOATBUILDING__M_Total_Price_Calculated__c, b.BOATBUILDING__M_Total_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Total_MSRP__c, b.BOATBUILDING__M_Total_Due__c, b.BOATBUILDING__M_Total_Amount_Financed_Calculated__c, b.BOATBUILDING__M_Shipped_Date__c, b.BOATBUILDING__M_Selected_Category__c, b.BOATBUILDING__M_Rfinance_Rate__c, b.BOATBUILDING__M_Retail_Price__c, b.BOATBUILDING__M_Requested_Ship_Date__c, b.BOATBUILDING__M_Received_Date__c, b.BOATBUILDING__M_Quote_Date__c, b.BOATBUILDING__M_Quantity__c, b.BOATBUILDING__M_Purchase_Line_Item__c, b.BOATBUILDING__M_Product_Salesperson_new__c, b.BOATBUILDING__M_Product_Retail_Price_To__c, b.BOATBUILDING__M_Product_Retail_Price_From__c, b.BOATBUILDING__M_Product_Family__c, b.BOATBUILDING__M_Payment__c, b.BOATBUILDING__M_Order_Date_To__c, b.BOATBUILDING__M_Order_Date_From__c, b.BOATBUILDING__M_Option_Category__c, b.BOATBUILDING__M_Net_Selling_Price_Calculated__c, b.BOATBUILDING__M_Model_Variant__c, b.BOATBUILDING__M_Manufacturer1__c, b.BOATBUILDING__M_Manufacture_Status__c, b.BOATBUILDING__M_Hidden_Box__c, b.BOATBUILDING__M_Finance_Term__c, b.BOATBUILDING__M_Engine__c, b.BOATBUILDING__M_Down_Payment__c, b.BOATBUILDING__M_Doc_Fee__c, b.BOATBUILDING__M_Discount__c, b.BOATBUILDING__M_Description__c, b.BOATBUILDING__M_Dealer_Stock__c, b.BOATBUILDING__M_Dealer_Status__c, b.BOATBUILDING__M_Dealer_Flat_Discount__c, b.BOATBUILDING__M_Dealer_Discount__c, b.BOATBUILDING__M_Dealer_Comments__c, b.BOATBUILDING__M_Dealer_COD_Discount__c, b.BOATBUILDING__M_Dealer_Base_Price__c, b.BOATBUILDING__M_Deal_Margin__c, b.BOATBUILDING__M_Date_Received__c, b.BOATBUILDING__M_Boat_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Boat_Trade_Allowance__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c, b.BOATBUILDING__M_Boat_Reg_Fee__c, b.BOATBUILDING__M_Boat_MSRP_PRICE__c, b.BOATBUILDING__M_Boat_Actual_Cost_Value_ACV__c, b.BOATBUILDING__MSRP__c, b.BOATBUILDING__MModel2__c, b.BOATBUILDING__Is_Active__c, b.BOATBUILDING__Hull_Id__c, b.BOATBUILDING__Freight__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Custom__c, b.BOATBUILDING__Cost_Price__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Account__c From BOATBUILDING__Product__c b 
                                      where MModel2__c =: selectedModel AND M_Model_Variant__c=: selectedModelVariant AND M_Year__c =: objInventory.Year__c AND Product_Type__c =: selectedType limit 1];
                        if(!lstPro.isEmpty())
                            objProduct = lstPro[0];
                    }
                } 
                
            } 
            if(objProduct != null && objProduct.Id != null){ 
                if(objProduct.M_Boat_MSRP_PRICE__c!= null)
                {
                    totalprice =  MfgOptTota + objProduct.M_Boat_MSRP_PRICE__c;
                }else{
                    totalprice =  MfgOptTota;
                }
                
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
                upsert objContact;
            }
            if(objContact.Id != null && objContact.Email != null && objContact.AccountId != null) {
                List<Contact> lstConForDel = [SELECT Id From Contact WHERE Id <>: objContact.Id AND Email =: objContact.Email AND AccountId =: objContact.AccountId LIMIT 1];
                if(lstConForDel.size() > 0) {    
                    delete lstConForDel[0];
                }
            }
            if(objContact.Id != null){
                objQuote.Contact_Name__c = objContact.Id; 
            }
            
            if(objAccount.Id != null){
                objQuote.Account_Name__c = objAccount.Id;
            }
            if(objInventory.Cost__c != null){
                objQuote.Quote_Total_MSRP__c = objInventory.Cost__c;
            }
            if(objAccount.Name != null && objAccount.Name != ''){
                objQuote.Name = 'Quote For '+objAccount.Name;   
            }else{
                if(objContact.FirstName != null && objContact.FirstName != ''){
                    objQuote.Name = 'Quote For '+objContact.FirstName + ' ' + objContact.LastName;
                }else{
                    objQuote.Name = 'Quote For '+objInventory.Name;
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
            if(objProduct.M_Finance_Term__c != null && objProduct.M_Finance_Term__c != 'None'){
                objQuote.Quote_Term__c = objProduct.M_Finance_Term__c;
            }else{
                objQuote.Quote_Term__c ='More';
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
            
            System.debug('Debug log for objProduct.Id : '+objProduct.Id);
            if(objProduct.Id != null){
                objQuote.Related_to_Product__c = objProduct.Id;
            }
            
            if(lstProductPrice != null && !lstProductPrice.isEmpty()) {
                Map<String, Double> mapIdQT = new Map<String, Double>();
                for(String strQT: lstProductPriceQT) {
                    String []st = strQT.split(':');
                    mapIdQT.put(st[0], Double.valueOf(st[1]));
                }
                List<BOATBUILDING__ProductPrice__c> lstPP =  [SELECT 
                                                              Id, 
                                                              Option_Category__c, 
                                                              ProductSelected_Category__c, 
                                                              ProductRetail_Price__c, 
                                                              Dealer_Price__c, 
                                                              Product_Code__c, 
                                                              ProductManufacturer__c, 
                                                              Year__c,
                                                              Sorting_Order__c, 
                                                              Product_Model__c, 
                                                              Model_Variant__c,
                                                              RecordType.Name   
                                                              FROM 
                                                              BOATBUILDING__ProductPrice__c
                                                              WHERE
                                                              Id IN: lstProductPrice];
                System.debug('Debug Log For lstPP: '+lstPP);
                
                for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory: lstPP) {
                    BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                    objQLI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                    objQLI.Name = 'QLI';
                    objQLI.Product__c = objProduct.Id;
                    objQLI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                    objQLI.Total_Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                    objQLI.Date__c =  Date.today();
                    objQLI.Quantity__c =  mapIdQT.get(objProductPriceForSelectedCategory.Id);
                    objQLI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c ;
                    objQLI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c;
                    if(objProductPriceForSelectedCategory.RecordType.Name == 'New Boats') {
                        objQLI.Product_Type__c = 'New Boat';
                    } else {
                        objQLI.Product_Type__c = objProductPriceForSelectedCategory.RecordType.Name;
                    }
                    lstQLI.add(objQLI);
                    MfgOptTota += (objProductPriceForSelectedCategory.ProductRetail_Price__c * objQLI.Quantity__c); 
                }
                totalPrice += MfgOptTota;
                System.debug('Debug Log For MfgOptTota: '+MfgOptTota);
                System.debug('Debug Log For totalPrice: '+totalPrice);
            }
            if(String.isNotBlank(lstDO) && !lstDealerOption.isEmpty()) {
                Map<String, Double> mapPCQT = new Map<String, Double>();
                for(String strQT: lstDealerOptionQT) {
                    String []st = strQT.split(':');
                    mapPCQT.put(st[0], Double.valueOf(st[1]));
                }
                Set<String> setPrtNum = new Set<String>();               
                for(String str: lstDealerOption) {
                    System.debug('Debug Log For str: '+str);
                    if(String.isNotBlank(str)) {
                        setPrtNum.add(str);
                    }
                }
                List<DealerOptionWraper> lstDO2 = (List<DealerOptionWraper>)JSON.deserialize(lstDO,List<DealerOptionWraper>.class);                                                           
                
                for(DealerOptionWraper objDP: lstDO2) {
                    if(setPrtNum.contains(objDP.objDealerOption.Part_Number__c)) {
                        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
                        objQLI.Name = 'QLI';
                        objQLI.Name__c = objDP.objDealerOption.Name;
                        objQLI.Product__c = objProduct.Id;
                        objQLI.Option_Category__c = 'Dealer Options';
                        objQLI.Total_Price__c = objDP.objDealerOption.Retail_Price__c;
                        objQLI.Date__c =  Date.today(); 
                        objQLI.Dealer_Price__c = objDP.objDealerOption.Cost__c; 
                        objQLI.Product_Code__c = objDP.objDealerOption.Part_Number__c ;
                        objQLI.Quantity__c = mapPCQT.get(objDP.objDealerOption.Part_Number__c);
                        objQLI.Non_Taxable__c = objDP.objDealerOption.Non_Taxable__c ;
                        lstQLI.add(objQLI);
                        dealerOptionTotal += (objDP.objDealerOption.Retail_Price__c * objQLI.Quantity__c);
                    }
                }
                totalPrice += dealerOptionTotal;
                System.debug('Debug Log For totalPrice: '+totalPrice);
            }
            
            if(totalPrice != null){
                
                objQuote.Quote_Sale_Price__c = totalPrice;
                objQuote.Total_Price_Quote__c = totalPrice;
            }else{
                objQuote.Quote_Sale_Price__c = 0.00;
                objQuote.Total_Price_Quote__c = 0.00;
            }   
            
            
            //if(objProduct.State__c!= 'None'){
            //objQuote.State__c= objProduct.State__c;
            //}
            //String regFee, String docFee, String trlRegFee
            objQuote.BOATBUILDING__Quote_Doc_Fee__c = String.isNotBlank(docFee)? Decimal.valueOf(docFee):0.0;
            objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c = String.isNotBlank(regFee)? Decimal.valueOf(regFee):0.0;
            objQuote.BOATBUILDING__Quote_Trailer_Reg_Fee__c = String.isNotBlank(trlRegFee)? Decimal.valueOf(trlRegFee):0.0;
            if(strInvId != '0') {
                objQuote.BOATBUILDING__Test_2__c = strInvId;
            }
            insert objQuote;
            if(ACVId != '0') {
                objQuote.BOATBUILDING__ACV_FORM__c = ACVId;
                update objQuote; 
            }
            for(BOATBUILDING__Quote_Line_Item__c qli : lstQLI){
                qli.Quote__c = objQuote.Id; 
            } 
            
            insert lstQLI;
            
            return objQuote;
        } catch(Exception ex) {
            System.debug('Debug log for exception: '+ex.getStackTraceString()+' : '+ex.getLineNumber()+'messagr'+ex.getCause()+ex.getMessage()); 
            throw new AuraHandledException(ex.getStackTraceString()+'--'+ex.getLineNumber()+'--'+ex.getCause()+ex.getMessage()); 
            //return null;    
        }
    }
    
    @AuraEnabled
    public static List<Key_Value> getState() {
        List<Key_Value> lstKV = new List<Key_Value>();
        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Quote__c.State__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            Key_Value obj = new Key_Value();
            obj.key = pickListVal.getLabel();
            obj.value = pickListVal.getLabel();
            lstKV.add(obj);
        }  
        
        return lstKV;
    }
    
    @AuraEnabled
    public static Quote__c updateStateApex(String quoteId, String state) {
        Quote__c objQuote = new Quote__c();
        objQuote.Id = quoteId;
        objQuote.State__c = state;
        update objQuote;
        objQuote = QuoteSelector.queryQuoteFromId(quoteId)[0];
        return objQuote;
    }
    
    @AuraEnabled
    public static Boolean isNoSalesmanWithoutCost() {
        Boolean isSWC = true;
        User u = [Select Id, ProfileId, Profile.Name From User Where Id =: UserInfo.getUserId()];
        if(u.ProfileId != null && u.Profile.Name.containsIgnoreCase('without cost')) {
            isSWC = false;
        }
        return isSWC;
    }
}