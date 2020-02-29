public with sharing class InventoryWizardController {
    @AuraEnabled
    public static String generateInventory(String ProId, List<String> lstProductPrice, List<String> lstDealerOption, Inventory__c objInventory, String lstDO) {
        try {
            System.debug('>>>>>>>>>: '+ProId);
            System.debug('>>>>>>>>>: '+lstProductPrice);
            System.debug('>>>>>>>>>: '+lstDealerOption);
            System.debug('>>>>>>>>>: '+objInventory);
            System.debug('>>>>>>>>>: '+lstDO);
            
            Decimal totalPrice = 0.00;
            Decimal totalPriceDealer = 0.00;
            List<Inventory_Line_Item__c> lstILI = new List<Inventory_Line_Item__c>();  
            
            Product__c objProduct = [Select b.SystemModstamp, b.OwnerId, b.Name, b.LastViewedDate, b.LastReferencedDate, b.LastModifiedDate, b.LastModifiedById, b.LastActivityDate, b.IsDeleted, b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Transmission_Gearbox_SN__c, b.BOATBUILDING__Trailer_VIN__c, b.BOATBUILDING__Trailer_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__State__c, b.BOATBUILDING__Sale_Price__c, b.BOATBUILDING__Quantity_In_Stock__c, b.BOATBUILDING__Product_Type__c, b.BOATBUILDING__Product_Short_Description__c, b.BOATBUILDING__Product_Manufacturer__c, b.BOATBUILDING__Product_Long_Description__c, b.BOATBUILDING__ProductName__c, b.BOATBUILDING__Prep__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__M_Your_Price_Calculated__c, b.BOATBUILDING__M_Year__c, b.BOATBUILDING__M_V_Drive__c, b.BOATBUILDING__M_Trailer_Trade_Allowance__c, b.BOATBUILDING__M_Trailer_Sales_Tax__c, b.BOATBUILDING__M_Trailer_Reg_Fee__c, b.BOATBUILDING__M_Trailer_MSRP_PRICE__c, b.BOATBUILDING__M_Trailer_Actual_Cost_Value_ACV__c, b.BOATBUILDING__M_Trade_PayOFF__c, b.BOATBUILDING__M_Total_Price_Calculated__c, b.BOATBUILDING__M_Total_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Total_MSRP__c, b.BOATBUILDING__M_Total_Due__c, b.BOATBUILDING__M_Total_Amount_Financed_Calculated__c, b.BOATBUILDING__M_Shipped_Date__c, b.BOATBUILDING__M_Selected_Category__c, b.BOATBUILDING__M_Rfinance_Rate__c, b.BOATBUILDING__M_Retail_Price__c, b.BOATBUILDING__M_Requested_Ship_Date__c, b.BOATBUILDING__M_Received_Date__c, b.BOATBUILDING__M_Quote_Date__c, b.BOATBUILDING__M_Quantity__c, b.BOATBUILDING__M_Purchase_Line_Item__c, b.BOATBUILDING__M_Product_Salesperson_new__c, b.BOATBUILDING__M_Product_Retail_Price_To__c, b.BOATBUILDING__M_Product_Retail_Price_From__c, b.BOATBUILDING__M_Product_Family__c, b.BOATBUILDING__M_Payment__c, b.BOATBUILDING__M_Order_Date_To__c, b.BOATBUILDING__M_Order_Date_From__c, b.BOATBUILDING__M_Option_Category__c, b.BOATBUILDING__M_Net_Selling_Price_Calculated__c, b.BOATBUILDING__M_Model_Variant__c, b.BOATBUILDING__M_Manufacturer1__c, b.BOATBUILDING__M_Manufacture_Status__c, b.BOATBUILDING__M_Hidden_Box__c, b.BOATBUILDING__M_Finance_Term__c, b.BOATBUILDING__M_Engine__c, b.BOATBUILDING__M_Down_Payment__c, b.BOATBUILDING__M_Doc_Fee__c, b.BOATBUILDING__M_Discount__c, b.BOATBUILDING__M_Description__c, b.BOATBUILDING__M_Dealer_Stock__c, b.BOATBUILDING__M_Dealer_Status__c, b.BOATBUILDING__M_Dealer_Flat_Discount__c, b.BOATBUILDING__M_Dealer_Discount__c, b.BOATBUILDING__M_Dealer_Comments__c, b.BOATBUILDING__M_Dealer_COD_Discount__c, b.BOATBUILDING__M_Dealer_Base_Price__c, b.BOATBUILDING__M_Deal_Margin__c, b.BOATBUILDING__M_Date_Received__c, b.BOATBUILDING__M_Boat_Trade_Over_Allowance_Calculated__c, b.BOATBUILDING__M_Boat_Trade_Allowance__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated__c, b.BOATBUILDING__M_Boat_Sales_Tax_Calculated_Backend__c, b.BOATBUILDING__M_Boat_Reg_Fee__c, b.BOATBUILDING__M_Boat_MSRP_PRICE__c, b.BOATBUILDING__M_Boat_Actual_Cost_Value_ACV__c, b.BOATBUILDING__MSRP__c, b.BOATBUILDING__MModel2__c, b.BOATBUILDING__Is_Active__c, b.BOATBUILDING__Hull_Id__c, b.BOATBUILDING__Freight__c, b.BOATBUILDING__Engine_SN__c, b.BOATBUILDING__Dealer__c, b.BOATBUILDING__Custom__c, b.BOATBUILDING__Cost_Price__c, b.BOATBUILDING__Boat_Length_in_feets__c, b.BOATBUILDING__Boat_Costline__c, b.BOATBUILDING__Account__c From BOATBUILDING__Product__c b Where Id =: ProId];
            if(objProduct.M_Boat_MSRP_PRICE__c != null ){
                totalPrice = objProduct.M_Boat_MSRP_PRICE__c;
            } 
            if(objProduct.Cost_Price__c != null){
                totalPriceDealer = objProduct.Cost_Price__c;
            }            
            
            if(lstProductPrice != null && !lstProductPrice.isEmpty()) {
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
                    Inventory_Line_Item__c objILI = new Inventory_Line_Item__c();
                    objILI.Name__c = objProductPriceForSelectedCategory.ProductSelected_Category__c;
                    objILI.Name = 'ILI';
                    objILI.Option_Category__c = objProductPriceForSelectedCategory.Option_Category__c;
                    objILI.Price__c = objProductPriceForSelectedCategory.ProductRetail_Price__c;
                    objILI.Product_Code__c = objProductPriceForSelectedCategory.Product_Code__c ;
                    objILI.Dealer_Price__c = objProductPriceForSelectedCategory.Dealer_Price__c;
                    if(objProductPriceForSelectedCategory.RecordType.Name == 'New Boats') {
	                		objILI.Product_Type__c = 'New Boat'; 
	                } else {
	                		objILI.Product_Type__c = objProductPriceForSelectedCategory.RecordType.Name;
	                } 
                    lstILI.add(objILI);
                    totalPrice += objProductPriceForSelectedCategory.ProductRetail_Price__c;
                    totalPriceDealer += objProductPriceForSelectedCategory.Dealer_Price__c;
                }
                //totalPrice += MfgOptTota;
                System.debug('Debug Log For totalPrice: '+totalPrice);
            }
            
            if(String.isNotBlank(lstDO) && !lstDealerOption.isEmpty()) { 
                 Set<String> setPrtNum = new Set<String>();               
	            for(String str: lstDealerOption) {
	            		System.debug('Debug Log For str: '+str);
	            		if(String.isNotBlank(str)) {
	            			setPrtNum.add(str);
	            		}
	            }   			
                //List<DealerOptionWraper> lstDO2 = (List<DealerOptionWraper>)lstDO;
                List<DealerOptionWraper> lstDO2 = (List<DealerOptionWraper>)JSON.deserialize(lstDO,List<DealerOptionWraper>.class);               
                for(DealerOptionWraper objDP: lstDO2) {	
                		System.debug('Debug Log For str: '+objDP);
            			if(setPrtNum.contains(objDP.objDealerOption.Part_Number__c)) {
	                    Inventory_Line_Item__c objILI = new Inventory_Line_Item__c();
	                    objILI.Name = 'ILI';
	                    objILI.Name__c = objDP.objDealerOption.Name;
	                    objILI.Option_Category__c = 'Dealer Options';
	                    objILI.Price__c = objDP.objDealerOption.Retail_Price__c;
	                    objILI.Dealer_Price__c = objDP.objDealerOption.Cost__c;
	                    objILI.Product_Code__c = objDP.objDealerOption.Part_Number__c ;
	                    objILI.Non_Taxable__c = objDP.objDealerOption.Non_Taxable__c ;
	                    lstILI.add(objILI);
	                    totalPrice += objDP.objDealerOption.Retail_Price__c;
	                    totalPriceDealer += objDP.objDealerOption.Cost__c; 
            			}
                }
                System.debug('Debug Log For totalPrice: '+totalPrice);
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
          //  objInventory.RecordTypeId = [Select Id From RecordType where SobjectType ='BOATBUILDING__Inventory__c' AND Name = 'New Boats'].Id;
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
            insert objInventory;
            
            if(objInventory.Id != null && !lstILI.isEmpty()) {
                for(Inventory_Line_Item__c objILI: lstILI) {
                    objILI.BOATBUILDING__Related_to_Inventory__c = objInventory.Id;
                }
                insert lstILI;
                
            }
            return objInventory.Id;
        }
        catch(Exception ex) {
            System.debug('>>>: '+ex);
            return null;
        }
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