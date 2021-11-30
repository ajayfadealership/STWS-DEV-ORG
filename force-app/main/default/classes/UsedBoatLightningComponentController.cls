public class UsedBoatLightningComponentController {
    public UsedBoatLightningComponentController() { }
    @AuraEnabled
    public static string getPORecordTypeId(){
        String poRecTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Used Boats').getRecordTypeId(); 
        return poRecTypeId;
    }

    @AuraEnabled
    public static List<PriceAndProductOptionWraperClass> getProductLineItem() {
        Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
        Map<String , List<CheckBoxWraper>> mapCheckBoxWraper = new Map<String , List<CheckBoxWraper>>();
        List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
        mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
        System.debug('>>>mapSelectedCategory: '+mapSelectedCategory);
        List<CheckBoxWraper> lstCheckBoxWraper;
        
        for(String strMapValues : mapSelectedCategory.keySet()){
            lstCheckBoxWraper = new List<CheckBoxWraper>();
            for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : mapSelectedCategory.get(strMapValues)){
                lstCheckBoxWraper.add(new CheckBoxWraper(false,lstCheckBoxWraper.size()+1, objProductPriceForSelectedCategory));
            }
            mapCheckBoxWraper.put(strMapValues, lstCheckBoxWraper);
        }
        
        for(String strUtil : mapSelectedCategory.keySet()){
            lstPriceAndProductOptionWraperClass.add(new PriceAndProductOptionWraperClass(strUtil, mapCheckBoxWraper.get(strUtil)));
        }
        return lstPriceAndProductOptionWraperClass;
    }
    @AuraEnabled
    public static List<DealerOptionWraper> getDealerOptions() {
        List<DealerOptionWraper> lstDealerOptionWraper = new List<DealerOptionWraper>();
        List<BOATBUILDING__Dealer_Option__c> lstDealerOption = [SELECT 
                                                                Id,
                                                                Name,
                                                                Part_Number__c,
                                                                Retail_Price__c,
                                                                Cost__c
                                                                FROM
                                                                BOATBUILDING__Dealer_Option__c];
        
        if(lstDealerOption.size() > 0){
            for(BOATBUILDING__Dealer_Option__c objDealerOption : lstDealerOption){
                lstDealerOptionWraper.add(new DealerOptionWraper(false, objDealerOption, false));
            }
        }
        return lstDealerOptionWraper;
    }

    @AuraEnabled
    public static string updateLineItems(String strInvId, List<String> lstProductPrice, List<String> lstDealerOption, String allDOList) {
        try {
            System.debug('#@#@#@#@ '+lstProductPrice);
            List<BOATBUILDING__Inventory_Line_Item__c> lstILI = new List<BOATBUILDING__Inventory_Line_Item__c>();
            //List<String> lstProductPrice = (List<String>)JSON.deserializeUntyped(strLineItems);

            Inventory__c objInventory = [Select Id, Total_MSRP_Price__c, Total_Dealer_Price__c, BOATBUILDING__ACV__c, Suggested_List_Price__c From Inventory__c Where Id =: strInvId];

            Decimal totalPrice = 0.00;
            Decimal totalPriceDealer = 0.00;
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
                    objILI.BOATBUILDING__Related_to_Inventory__c = strInvId;
                    objILI.Product_Type__c = 'Used Boat'; 
                    
                    lstILI.add(objILI);
                    totalPrice += objProductPriceForSelectedCategory.ProductRetail_Price__c;
                    totalPriceDealer += objProductPriceForSelectedCategory.Dealer_Price__c;
                }
            }
            System.debug('Debug Log For totalPrice: '+totalPrice);
            System.debug('Debug Log For lstDealerOption: '+lstDealerOption);
            System.debug('Debug Log For allDOList: '+allDOList);
            
            if(!lstDealerOption.isEmpty() && String.isNotBlank(allDOList)) { 
                Set<String> setPrtNum = new Set<String>();                
               for(String str: lstDealerOption) {
                       System.debug('Debug Log For str: '+str);
                       if(String.isNotBlank(str)) {
                           setPrtNum.add(str);
                       }
               }   			
                List<DealerOptionWraper> lstDO2 = (List<DealerOptionWraper>)JSON.deserialize(allDOList,List<DealerOptionWraper>.class);               
                System.debug('lstDO2>>>: '+lstDO2);
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
                    objILI.BOATBUILDING__Related_to_Inventory__c = strInvId;
                    objILI.Product_Type__c = 'Used Boat'; 
                    lstILI.add(objILI);
                    totalPrice += objDP.objDealerOption.Retail_Price__c;
                    totalPriceDealer += objDP.objDealerOption.Cost__c; 
                    } 
                }
               System.debug('Debug Log For totalPrice: '+totalPrice);
            }
           
           System.debug('Debug Log For totalPrice: '+totalPrice);
            if(totalPrice != null){
                objInventory.Total_MSRP_Price__c = totalPrice + objInventory.Suggested_List_Price__c;
            }
            if(totalPriceDealer != null && objInventory.BOATBUILDING__ACV__c != null){
                objInventory.Total_Dealer_Price__c = totalPriceDealer + objInventory.BOATBUILDING__ACV__c;
            } else if(totalPriceDealer != null ){
                objInventory.Total_Dealer_Price__c = totalPriceDealer;
            }
            System.debug('Debug Log For lstILI: '+lstILI);
            if(!lstILI.isEmpty()) {
                insert lstILI;
            }
            update objInventory;
            return 'SUCCESS';
        } catch(Exception ex) {
            return 'Error: '+ex.getMessage() + '   :   '+ ex.getStackTraceString() + '   :   '+ ex.getLineNumber();
        }
    }

    public class PriceAndProductOptionWraperClass{
        @AuraEnabled public Decimal retailPrice { get; set; }
        @AuraEnabled public String partNumber { get; set; }
        @AuraEnabled public String strSelectedOption {    get; set; }
        @AuraEnabled public List<CheckBoxWraper> lstProductPriceForSelectedCategory { get; set; }
        
        public PriceAndProductOptionWraperClass( String strSelectedOption, list<CheckBoxWraper> lstProductPriceForSelectedCategory){
            this.lstProductPriceForSelectedCategory = lstProductPriceForSelectedCategory;
            this.strSelectedOption = strSelectedOption;
            this.partNumber = partNumber;
            this.retailPrice = retailPrice;
        }
    }
    
    public class CheckBoxWraper{
        @AuraEnabled public Boolean checkBox { get; set; }
        @AuraEnabled public BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory { get; set; } 
        @AuraEnabled public Integer rowNumber { get; set; }
        
        public CheckBoxWraper(Boolean checkBox,Integer rowNumber, BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory){
            this.checkBox = checkBox;
            this.rowNumber = rowNumber;
            this.objProductPriceForSelectedCategory = objProductPriceForSelectedCategory;
        }
    }
    public class DealerOptionWraper {
        @AuraEnabled public Boolean isSelect { get; set; }
        @AuraEnabled public Boolean ShowRemoveIcon { get; set; }
        @AuraEnabled public BOATBUILDING__Dealer_Option__c objDealerOption { get; set; }
        public DealerOptionWraper(Boolean isSelect, BOATBUILDING__Dealer_Option__c objDealerOption, Boolean ShowRemoveIcon) {
            this.isSelect = isSelect;
            this.objDealerOption = objDealerOption;
            this.ShowRemoveIcon = ShowRemoveIcon;
        }
    }
}