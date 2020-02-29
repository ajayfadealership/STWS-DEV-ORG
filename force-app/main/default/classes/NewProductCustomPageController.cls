/** 
* Author : Akshay Kumar 360 
* Created Date : 21/10/2016
*/
public with sharing class NewProductCustomPageController {
    public BOATBUILDING__Product__c objProduct { get; set; }
    public List<SelectOption> lstManufacturer { get; set; }
    public List<SelectOption> lstYear { get; set; }
    public List<SelectOption> lstModel { get; set; }
    public List<SelectOption> lstModelVariant { get; set; }
    public List<SelectOption> lstEngine { get; set; }
    public List<SelectOption> lstOptionCategory { get; set; }
    public List<SelectOption> lstSCategory { get; set; }
    
    public String selectedManufacturer { get; set; }
    public String selectedYear { get; set; }
    public String selectedModel { get; set; }
    public String selectedModelVariant { get; set; }
    public String selectedEngine { get; set; }
    public String selectedOptionCategory { get; set; }
    public String selectedSCategory { get; set; }
    
    public Boolean modelVariantCheck { get; set; }
    private String srtManuTemp;
    private Boolean modelVarientFlag;
    
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public NewProductCustomPageController(ApexPages.StandardController controller) {
        
        modelVariantCheck = false;
        modelVarientFlag = false;
        srtManuTemp = '';
        objProduct = new BOATBUILDING__Product__c();
        lstManufacturer = new List<SelectOption>();
        lstYear = new List<SelectOption>();
        lstModel = new List<SelectOption>();
        lstModelVariant = new List<SelectOption>();
        lstEngine  = new List<SelectOption>();
        lstOptionCategory = new List<SelectOption>();
        lstSCategory = new List<SelectOption>();
        
        List<BOATBUILDING__Manufacturer__c> lstTempManufacturer = [Select Id, Name from BOATBUILDING__Manufacturer__c]; 
        lstManufacturer .add(new SelectOption('','--None--'));
        lstYear .add(new SelectOption('','--None--'));
        lstModel .add(new SelectOption('','--None--'));
        lstModelVariant .add(new SelectOption('','--None--'));
        lstEngine .add(new SelectOption('','--None--'));
        lstOptionCategory .add(new SelectOption('','--None--'));
        lstSCategory .add(new SelectOption('','--None--'));
        
        for(BOATBUILDING__Manufacturer__c objManufacturer : lstTempManufacturer ){
            if(objManufacturer.Name != null){
                 lstManufacturer.add(new SelectOption(objManufacturer.Id, objManufacturer.Name));
             }
        }
    }

    public PageReference getYears(){
        
        lstOptionCategory.clear();
        lstOptionCategory .add(new SelectOption('','--None--'));
        lstSCategory .clear();
        lstSCategory .add(new SelectOption('','--None--'));
        
        Set<String> setYear = new Set<String>();
        List<BOATBUILDING__ProductPrice__c> lstManu = new List<BOATBUILDING__ProductPrice__c>();
        if(selectedManufacturer != null){
            List<Manufacturer__c> lstMnfctr = [Select Name, Model_Variant__c from BOATBUILDING__Manufacturer__c where Id =: selectedManufacturer limit 1];
            if(lstMnfctr.size() > 0) {
                srtManuTemp = lstMnfctr[0].Name;
                modelVarientFlag = lstMnfctr[0].Model_Variant__c; 
            }
            if(modelVarientFlag){
                modelVariantCheck = true;
            }else{
                modelVariantCheck = false;
            }
            lstManu  = [Select Id, Year__c from BOATBUILDING__ProductPrice__c where ProductManufacturer__c =: srtManuTemp ];
        }else{
            lstYear.clear();
            lstModel.clear();
            lstModel.add(new SelectOption('','--None--'));
            lstModelVariant .clear();
            lstModelVariant .add(new SelectOption('','--None--'));
        }
        if(lstManu.size() > 0){
            setYear.clear();
            for(BOATBUILDING__ProductPrice__c objPP : lstManu ){
                if(objPP.Year__c != null)
                setYear.add(objPP.Year__c);
            }
        }
        if(setYear.size() > 0){
            lstYear.clear();
            lstYear .add(new SelectOption('','--None--'));
            for(String str : setYear){
                lstYear.add(new SelectOption(str,str));
            }
        }
        
         Set<String> setModel = new Set<String>();
        List<BOATBUILDING__ProductPrice__c> lstProMod = new List<BOATBUILDING__ProductPrice__c>();
        if(selectedYear != null && selectedManufacturer != null){
            if(srtManuTemp != null){
                lstProMod = [Select Product_Model__c from BOATBUILDING__ProductPrice__c where ProductManufacturer__c =: srtManuTemp AND Year__c =: selectedYear];
            }
        }else{
            lstModel.clear();
            lstModel.add(new SelectOption('','--None--'));
        }
        if(lstProMod.size() > 0){
            for( BOATBUILDING__ProductPrice__c objPro : lstProMod){
                if(objPro.Product_Model__c != null){
                    setModel.add(objPro.Product_Model__c);
                }
            }
        }
        if(setModel.size() > 0){
            lstModel.clear();
            lstModel.add(new SelectOption('','--None--'));
            for(String strTemp : setModel){
                lstModel.add(new SelectOption(strTemp, strTemp));
            }
        }
        return null;
    }
    
    public PageReference getModel(){
        Set<String> setModel = new Set<String>();
        List<BOATBUILDING__ProductPrice__c> lstProMod = new List<BOATBUILDING__ProductPrice__c>();
        if(selectedYear != null && selectedManufacturer != null){
            if(srtManuTemp != null){
                lstProMod = [Select Product_Model__c from BOATBUILDING__ProductPrice__c where ProductManufacturer__c =: srtManuTemp AND Year__c =: selectedYear];
            }
        }else{
            lstModel.clear();
            lstModel.add(new SelectOption('','--None--'));
        }
        if(lstProMod.size() > 0){
            for( BOATBUILDING__ProductPrice__c objPro : lstProMod){
                if(objPro.Product_Model__c != null){
                    setModel.add(objPro.Product_Model__c);
                }
            }
        }
        if(setModel.size() > 0){
            lstModel.clear();
            lstModel.add(new SelectOption('','--None--'));
            for(String strTemp : setModel){
                lstModel.add(new SelectOption(strTemp, strTemp));
            }
        }
        return null;
    }
    
    public PageReference getEngineOptionCatAndModelVariant(){
        if(modelVariantCheck){
            Set<String> setModVar = new Set<String>();
            List<BOATBUILDING__ProductPrice__c> lstModVar = new List<BOATBUILDING__ProductPrice__c>();
            if(selectedYear != null && selectedManufacturer != null && selectedModel != null){
                if(srtManuTemp != null){
                    lstModVar = [Select Model_Variant__c from BOATBUILDING__ProductPrice__c where ProductManufacturer__c =: srtManuTemp AND Year__c =: selectedYear AND Product_Model__c =: selectedModel];
                }   
                if(lstModVar.size() > 0 ){
                    for(BOATBUILDING__ProductPrice__c objPP : lstModVar){
                        if(objPP.Model_Variant__c != null){
                            setModVar.add(objPP.Model_Variant__c);
                        }
                    }
                }
                lstModelVariant.clear();
                lstModelVariant.add(new SelectOption('','--None--'));
                for(String strSMV : setModVar){
                    lstModelVariant.add(new SelectOption(strSMV, strSMV));
                }
            }
        }else{
            lstModelVariant .clear();
            lstModelVariant .add(new SelectOption('','--None--'));
        }
        
        
        if(selectedModel != null){
            Set<String> setOppCat = new Set<String>();
            List<BOATBUILDING__ProductPrice__c> lstOppCat = new List<BOATBUILDING__ProductPrice__c>();
            lstOppCat = [Select Option_Category__c from BOATBUILDING__ProductPrice__c where Product_Model__c =: selectedModel];
            if(lstOppCat.size() > 0){
                for(BOATBUILDING__ProductPrice__c objPPp : lstOppCat){
                    if(objPPp.Option_Category__c != null){
                        setOppCat.add(objPPp.Option_Category__c);
                    }
                }
                if(setOppCat.size() > 0){
                    for(String strPPP : setOppCat){
                        lstOptionCategory.add(new SelectOption(strPPP, strPPP));
                    }
                }
            }
        }else{
            lstOptionCategory.clear();
            lstOptionCategory.add(new SelectOption('','--None--'));
        }
        
        return null;
    }
 
    public PageReference getSelectedCategory(){
        if(selectedOptionCategory != null){
            Set<String> setSelCat = new Set<String>();
            List<BOATBUILDING__ProductPrice__c> lstSelCat = new List<BOATBUILDING__ProductPrice__c>();
            lstSelCat = [Select ProductSelected_Category__c from BOATBUILDING__ProductPrice__c where Option_Category__c =: selectedOptionCategory];
            if(lstSelCat.size() > 0){
                for(BOATBUILDING__ProductPrice__c objPPPP : lstSelCat){
                    if(objPPPP.ProductSelected_Category__c != null){
                        setSelCat.add(objPPPP.ProductSelected_Category__c);
                    }
                }
            }
            if(setSelCat.size() > 0){
                for(String strPPPP : setSelCat){
                    lstSCategory.add(new SelectOption(strPPPP, strPPPP));
                }
            }
        }else{
            lstSCategory.clear();
            lstSCategory.add(new SelectOption('','--None--'));
        }
        return null;
    }
    
    public PageReference saveNewProduct(){
        boolean isError = false;
        if(selectedManufacturer != null && selectedManufacturer != ''){
            objProduct.Product_Manufacturer__c = selectedManufacturer;
        }
        if(srtManuTemp != null && srtManuTemp != ''){
            objProduct.M_Manufacturer1__c = srtManuTemp;
        }
        if(selectedYear != null && selectedYear != ''){
            objProduct.M_Year__c = selectedYear;
        }
        if(selectedModel != null && selectedModel != ''){
            objProduct.MModel2__c = selectedModel;
        }
        if(selectedModelVariant != null && selectedModelVariant != ''){
            objProduct.M_Model_Variant__c = selectedModelVariant;
        }
        if(selectedOptionCategory != null && selectedOptionCategory != ''){
            objProduct.M_Option_Category__c = selectedOptionCategory;
        }
        if(selectedSCategory != null && selectedSCategory != ''){
            objProduct.M_Selected_Category__c = selectedSCategory;
        }
        
        try{
            insert objProduct;
        }catch(Exception ex){
            isError = true;
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
        }
        if(!isError){
            return new PageReference('/'+objProduct.Id);
        }else{
            return null;
        }
    }
    
    public PageReference saveAndNewForm(){
        boolean isError = false;
        if(selectedManufacturer != null && selectedManufacturer != ''){
            objProduct.Product_Manufacturer__c = selectedManufacturer;
        }
        if(srtManuTemp != null && srtManuTemp != ''){
            objProduct.M_Manufacturer1__c = srtManuTemp;
        }
        if(selectedYear != null && selectedYear != ''){
            objProduct.M_Year__c = selectedYear;
        }
        if(selectedModel != null && selectedModel != ''){
            objProduct.MModel2__c = selectedModel;
        }
        if(selectedModelVariant != null && selectedModelVariant != ''){
            objProduct.M_Model_Variant__c = selectedModelVariant;
        }
        if(selectedOptionCategory != null && selectedOptionCategory != ''){
            objProduct.M_Option_Category__c = selectedOptionCategory;
        }
        if(selectedSCategory != null && selectedSCategory != ''){
            objProduct.M_Selected_Category__c = selectedSCategory;
        }
        
        try{
            insert objProduct;
        }catch(Exception ex){
            isError = true;
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
        }
        if(!isError){
            PageReference pr = new PageReference('/apex/NewProductCustomPage');
            pr.setRedirect(true);
            return pr;
        }else{
            return null;
        }
    }
    
    public PageReference cancelBack(){
        return new PageReference('/a10/o');
    }
    
}