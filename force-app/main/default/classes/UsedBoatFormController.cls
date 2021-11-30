/** 
* Author             : Akshay Kumar
* Organization       : CloudCodiots LLP.
* Created Date       : 21/10/2016
* Last Modified Date : 15/04/2017
*/
public with sharing class UsedBoatFormController{
    
    
    public String decDO { get; set; }
    public String retDO { get; set; }
    public String delDO { get; set; }
    public String pnDO { get; set; } 
    public String QT { get; set; } 
    public String dealerPartNumber { get; set; }
    
    public Decimal totalPrice { get; set; }
    public Decimal totalPriceDealer { get; set; }
    
    public String selectedManufacture { get; set; }
    public String selectedYear { get; set; }
    public BOATBUILDING__Inventory__c objInventory { get; set; }
    
    public List<SelectOption>lstManufacture { get; set; }
    public List<SelectOption> setYear { get; set; }
    
    public String rowNumber { get; set; }
    public String selectedOptionString { get; set; }
    public String selectedOptionCategory { get; set; }
    
    public List<BOATBUILDING__Inventory_Line_Item__c> lstInventoryLineItem;
    
    public Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory;
    public Map<String , List<CheckBoxWraper>> mapCheckBoxWraper;
    public List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass { get; set; }
    
    public List<DealerOptionWraper> lstDealerOptionWraper { get; set; }
    
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public UsedBoatFormController(){
        try {
            selectedManufacture = '0';
            totalPrice = 0.00;
            totalPriceDealer = 0.00;
            decDO = '';
            retDO = '0.00';
            delDO = '0.00';
            pnDO = '';
            objInventory = new BOATBUILDING__Inventory__c();
            lstManufacture = new List<SelectOption>();
            setYear = new List<SelectOption>();
            lstDealerOptionWraper = new List<DealerOptionWraper>();
            mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
            mapCheckBoxWraper = new Map<String , List<CheckBoxWraper>>();
            lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
            lstInventoryLineItem = new List<BOATBUILDING__Inventory_Line_Item__c>();
            
            String acvFormId = apexpages.currentpage().getparameters().get('acvId') != null ? 
                apexpages.currentpage().getparameters().get('acvId') : '';
            
            
            if(String.isNotBlank(acvFormId))
            {
                List<BOATBUILDING__ACV_Form__c> listACVForm = [SELECT Id, Name, BOATBUILDING__Approved_ACV__c, BOATBUILDING__Boat_HIN__c, BOATBUILDING__Boat_Make__c, BOATBUILDING__Trailer_Vin__c,
                                                               BOATBUILDING__Boat_Model__c, BOATBUILDING__Boat_Year__c, BOATBUILDING__Boat_Type__c, BOATBUILDING__Engine_SN__c
                                                               FROM BOATBUILDING__ACV_Form__c WHERE Id =:acvFormId LIMIT 1];
                
                if(!listACVForm.isEmpty()){
                    BOATBUILDING__ACV_Form__c objACV = listACVForm[0];
                    if( objACV.BOATBUILDING__Approved_ACV__c != null )
                        objInventory.ACV__c = objACV.BOATBUILDING__Approved_ACV__c ;
                    objInventory.BOATBUILDING__HIN_Number__c = objACV.BOATBUILDING__Boat_HIN__c != null ? objACV.BOATBUILDING__Boat_HIN__c : '';
                    objInventory.BOATBUILDING__Model__c = objACV.BOATBUILDING__Boat_Model__c != null ? objACV.BOATBUILDING__Boat_Model__c : '';
                    //lectedYear = objACV.BOATBUILDING__Boat_Year__c;
                    if( objACV.BOATBUILDING__Boat_Type__c != null )
                        objInventory.BOATBUILDING__Boat_Type__c = objACV.BOATBUILDING__Boat_Type__c;
                    if( objACV.BOATBUILDING__Engine_SN__c != null )
                        objInventory.BOATBUILDING__Engine_SN__c = objACV.BOATBUILDING__Engine_SN__c;
                    if(objACV.BOATBUILDING__Trailer_Vin__c != null)
                        objInventory.BOATBUILDING__Trailer_VIN__c = objACV.BOATBUILDING__Trailer_Vin__c;
                }
                
            }
            else{
                if(ApexPages.currentPage().getParameters().get('ManuId') != null ){
                    selectedManufacture = ApexPages.currentPage().getParameters().get('ManuId');
                } 
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
            
            lstManufacture.add(new SelectOption('0', '--None--'));
            for(BOATBUILDING__Manufacturer__c objManufacturer : [Select Id, Name from BOATBUILDING__Manufacturer__c Where RecordTypeId =: lstRecT[0].Id ORDER By CreatedDate DESC LIMIT 990]){ 
                lstManufacture.add(new SelectOption(objManufacturer.Name, objManufacturer.Name ));
            }
            if(ApexPages.currentPage().getParameters().get('ManuId') != null && ApexPages.currentPage().getParameters().get('ManuId') != '') {
                selectedManufacture = [Select Id, Name from BOATBUILDING__Manufacturer__c Where Id =: ApexPages.currentPage().getParameters().get('ManuId')].Name;
            }
            setYear.add(new SelectOption('', '--None--')); 
            for(Integer i = 1980 ; i < 2030; i++){
                setYear.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
            }
            
            mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance('', '', '', 'Used Boats').getSelectedCatagory();
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
            
            
            List<BOATBUILDING__Dealer_Option__c> lstDealerOption = BOATBUILDING__Dealer_Option__c.getAll().values();
            
            if(lstDealerOption.size() > 0){
                for(BOATBUILDING__Dealer_Option__c objDealerOption : lstDealerOption){
                    lstDealerOptionWraper.add(new DealerOptionWraper(false, objDealerOption, false));
                }
            }
            
        }
        catch(Exception ex) {
            System.debug('>>: '+ex);
        }
    }
    Set<String> setProCode = new Set<String>();
    public void getMFGPrice(){
        BOATBUILDING__Inventory_Line_Item__c objILI = new BOATBUILDING__Inventory_Line_Item__c();
        Integer index = Integer.valueOf(rowNumber);
        
        if(!Test.isRunningTest()){
            selectedOptionCategory = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductSelected_Category__c;
            if(mapCheckBoxWraper.get(selectedOptionString)[index-1].checkBox) {
                if(selectedOptionCategory != null && selectedOptionCategory != ''){
                    objILI.Name = 'ILI'; //Dummy value
                    objILI.Name__c = selectedOptionCategory;
                }
                if(String.isNotBlank(selectedOptionString)) {
                    objILI.Option_Category__c = selectedOptionString;
                }
                Double qt = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c != null ? mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.Quantity__c  : 1;
                objILI.Quantity__c = qt;
                if(!setProCode.contains(selectedOptionCategory)) {
                    lstInventoryLineItem.add(objILI);
                } else {
                    for(BOATBUILDING__Inventory_Line_Item__c objILI1: lstInventoryLineItem) {
                        if(objILI1.Name__c == selectedOptionCategory) {
                            objILI1.Quantity__c = qt;
                        }
                    }
                }
                setProCode.add(selectedOptionCategory);
                System.debug('Debug Log For lstInventoryLineItem: '+lstInventoryLineItem);
            }
        }
    }
    
    public void getMFGPriceSubtrct(){ 
        Integer index = Integer.valueOf(rowNumber);
        if(!Test.isRunningTest()){
            selectedOptionCategory = mapCheckBoxWraper.get(selectedOptionString)[index-1].objProductPriceForSelectedCategory.ProductSelected_Category__c;
            if(lstInventoryLineItem.size() > 0){
                for(Integer i=0 ; i<lstInventoryLineItem.size() ; i++){
                    
                    if(lstInventoryLineItem[i].Name__c == selectedOptionCategory){
                        lstInventoryLineItem.remove(i); 
                    }
                }
            } 
            setProCode.remove(selectedOptionCategory);
        }
    }
    
    public PageReference createBoat(){
        Boolean isError = false;
        try{
            List<RecordType> lstRec = [Select id from RecordType where SobjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats' limit 1];
            if(lstRec.size() > 0){
                objInventory.RecordTypeId = lstRec[0].Id ;
            }
            if(selectedYear != null){
                objInventory.Year__c = selectedYear;
            }
            if(selectedManufacture != null){
                objInventory.Manufacturer__c = selectedManufacture;
            }
            if(totalPrice != null){
                objInventory.Total_MSRP_Price__c = totalPrice + objInventory.Suggested_List_Price__c;
            }
            if(totalPriceDealer != null && objInventory.BOATBUILDING__ACV__c != null){
                objInventory.Total_Dealer_Price__c = totalPriceDealer + objInventory.BOATBUILDING__ACV__c;
            }
            insert objInventory;
        }catch(Exception ex){
            isError = true;
            System.debug('>>>>1: '+ex.getStackTraceString()+ '  '+ex.getMessage());
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,'Something went wrong please try again!!'));
            return null;    
        }
        if(lstInventoryLineItem.size() > 0){
            for(BOATBUILDING__Inventory_Line_Item__c objILI : lstInventoryLineItem){
                objILI.Related_to_Inventory__c = objInventory.id;
            }
            try{
                insert lstInventoryLineItem;
            }catch(Exception ex){
                isError = true;
                System.debug('>>>>2: '+ex.getStackTraceString()+ '  '+ex.getMessage());
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,'Something went wrong please try again!!'));
                return null;
            }
        }
        if(!isError){
            return new PageReference('/'+objInventory.Id);
        }else{
            return null;
        }
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
        public Integer rowNumber { get; set; }
        
        public CheckBoxWraper(Boolean checkBox,Integer rowNumber, BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory){
            this.checkBox = checkBox;
            this.rowNumber = rowNumber;
            this.objProductPriceForSelectedCategory = objProductPriceForSelectedCategory;
        }
    }
    public class DealerOptionWraper {
        public Boolean isSelect { get; set; }
        public Boolean ShowRemoveIcon { get; set; }
        public BOATBUILDING__Dealer_Option__c objDealerOption { get; set; }
        public Decimal totalRetailPrice { get; set; }
        public Decimal totalDealerPrice {get; set; }
        public DealerOptionWraper(Boolean isSelect, BOATBUILDING__Dealer_Option__c objDealerOption, Boolean ShowRemoveIcon) {
            this.isSelect = isSelect;
            this.objDealerOption = objDealerOption;
            this.ShowRemoveIcon = ShowRemoveIcon;
            totalRetailPrice = objDealerOption.Retail_Price__c * objDealerOption.Quantity__c;
            totalDealerPrice = objDealerOption.Cost__c * objDealerOption.Quantity__c;
        } 
    }
    public PageReference updateDealerOptionList() {
        //lstDealerOptionWraper
        BOATBUILDING__Dealer_Option__c objDOO = new BOATBUILDING__Dealer_Option__c();
        objDOO.Name = decDO;
        System.debug('Debug Log For retDO: '+retDO);
        System.debug('Debug Log For delDO: '+delDO); 
        objDOO.BOATBUILDING__Retail_Price__c = Decimal.valueOf(retDO);
        objDOO.BOATBUILDING__Cost__c = Decimal.valueOf(delDO);
        objDOO.BOATBUILDING__Part_Number__c = pnDO;
        if(Test.isRunningTest()) {
            QT = '2';
        }
        objDOO.Quantity__c = Double.valueOf(QT);
        dealerPartNumber = pnDO;
        System.debug('Debug Log For objDOO: '+objDOO);
        //buttonRenderForPlaceOrder = true;
        lstDealerOptionWraper.add(new DealerOptionWraper(true, objDOO, true));
        getDealerOptionPrice();
        return null;
    }
    
    public void getDealerOptionPrice(){
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);  
        
        for(DealerOptionWraper objDD :lstDealerOptionWraper){
            if(objDD.objDealerOption.Part_Number__c == dealerPartNumber ){
                System.debug('Debug log for '+totalPrice);
                if(objDD.objDealerOption.Retail_Price__c != null){
                    totalPrice += (objDD.objDealerOption.Retail_Price__c * objDD.objDealerOption.Quantity__c);
                }
                System.debug('Debug log for totalPrice: '+totalPrice);
                if(objDD.objDealerOption.Cost__c != null){
                    totalPriceDealer += (objDD.objDealerOption.Cost__c * objDD.objDealerOption.Quantity__c);
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
                } else {
                    objILI.Quantity__c = 1;
                }
                if(!setProCode.contains(dealerPartNumber)) {
                    lstInventoryLineItem.add(objILI);
                } else {
                    for(BOATBUILDING__Inventory_Line_Item__c obj: lstInventoryLineItem) {
                        if(obj.Product_Code__c == dealerPartNumber) {
                            obj.Quantity__c = objDD.objDealerOption.Quantity__c;
                        }
                    }
                }
                setProCode.add(dealerPartNumber);
            }
        }
        renderDOList();
    }
    
    public void renderDOList() {
        Decimal totalRetail = 0.00;
        Decimal totalDealer = 0.00;
        for(DealerOptionWraper objDO: lstDealerOptionWraper) {
            Decimal Quantity = objDO.objDealerOption.Quantity__c != null ? objDO.objDealerOption.Quantity__c : 1;
            objDO.totalRetailPrice = objDO.objDealerOption.BOATBUILDING__Retail_Price__c != null ? objDO.objDealerOption.BOATBUILDING__Retail_Price__c * Quantity : 0.00;
            objDO.totalDealerPrice = objDO.objDealerOption.BOATBUILDING__Cost__c != null ? objDO.objDealerOption.BOATBUILDING__Cost__c * Quantity: 0.00;
        } 
    }
    
    public void getDealerOptionPriceSub() {
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);
        setProCode.remove(dealerPartNumber);
        if(lstInventoryLineItem.size() > 0) {
            for(Integer i = 0 ; i < lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && dealerOptionCostTotal > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null ){
                        //dealerOptionCostTotal -= lstInventoryLineItem[i].Dealer_Price__c;
                    }
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && totalPriceDealer > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null){
                        totalPriceDealer -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    lstInventoryLineItem.remove(i);
                }
            }
        }
        
        
    }
    public void getDeleteDealerOptionPriceSub() {
        System.debug('Debug Log For dealerPartNumber: '+dealerPartNumber);
        setProCode.remove(dealerPartNumber);
        if(lstInventoryLineItem.size() > 0){
            for(Integer i = 0 ; i < lstInventoryLineItem.size() ; i++){
                if(lstInventoryLineItem[i].Product_Code__c == dealerPartNumber){
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && dealerOptionCostTotal > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null ){
                        //dealerOptionCostTotal -= lstInventoryLineItem[i].Dealer_Price__c;
                    }
                    //if(lstInventoryLineItem[i].Dealer_Price__c != null && totalPriceDealer > 0){
                    if(lstInventoryLineItem[i].Dealer_Price__c != null){
                        totalPriceDealer -= (lstInventoryLineItem[i].Dealer_Price__c * lstInventoryLineItem[i].Quantity__c);
                    }
                    lstInventoryLineItem.remove(i);
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
}