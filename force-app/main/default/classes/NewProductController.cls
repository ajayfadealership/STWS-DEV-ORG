public with sharing class NewProductController {
    @AuraEnabled
    public static List<BOATBUILDING__Manufacturer__c> getManufacturer(String selectedType) {
        List<BOATBUILDING__Manufacturer__c> lstManufacturer = new List<BOATBUILDING__Manufacturer__c>(); 
        if(selectedType != '0' ) { 
            List<RecordType> lstRecT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Boat_Manufacturer' AND SobjectType = 'BOATBUILDING__Manufacturer__c' LIMIT 1];
            lstManufacturer = [Select Id, Name from BOATBUILDING__Manufacturer__c Where RecordTypeId =: lstRecT[0].Id AND BOATBUILDING__Boat_Builder__c = true]; 
        }
        return lstManufacturer;             
    }
    
    @AuraEnabled
    public static List<String> getYear(String strManuId, String selectedType) {
        List<String> lstYear = new List<String>();
        List<BOATBUILDING__Product__c> lstProduct = [Select Id, M_Year__c From BOATBUILDING__Product__c Where Product_Manufacturer__c =: strManuId AND Product_Type__c =: selectedType limit 49000];
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
            lstYear.add(String.valueOf(f)); 
        }
        return lstYear;
    }
    
    @AuraEnabled
    public static String getMVStatus(String strManuId) {
        if(strManuId == '0')
            return '0';
        BOATBUILDING__Manufacturer__c objManu = [Select Id, Model_Variant__c From BOATBUILDING__Manufacturer__c Where Id =: strManuId];
        if(objManu.Model_Variant__c) {
            return '1';
        }
        return '0';
    }
    
    @AuraEnabled
    public static List<Key_Value> getModel(String selectedType, String strManuId, String selectedYear, String MVStatus) {
        List<Key_Value> lstKV = new List<Key_Value>();
        Boolean modelVarientFlag = false; 
        if(MVStatus == '1') { 
            modelVarientFlag = true;
        }
        
        if(selectedYear !=  '0') {
            
            List<BOATBUILDING__Product__c> lstProductModel = [Select Id, MModel2__c From BOATBUILDING__Product__c where M_Year__c =: selectedYear AND Product_Manufacturer__c =: strManuId AND Product_Type__c =: selectedType ORDER BY CreatedDate ASC];
            
            if(lstProductModel.size()>0){
                if(modelVarientFlag){
                    Set<String> setModelV = new Set<String>();
                    for(BOATBUILDING__Product__c objPro : lstProductModel){
                        if(objPro.MModel2__c != null){
                            setModelV.add(objPro.MModel2__c);
                        }
                    }
                    for(String strModelName : setModelV){
                        Key_Value objKV = new Key_Value();
                        objKV.key = strModelName;
                        objKV.value = strModelName;
                        lstKV.add(objKV); 
                    }
                }else {
                    for(BOATBUILDING__Product__c objProduct : lstProductModel ){
                        if(objProduct.MModel2__c != null){
                            Key_Value objKV = new Key_Value();
                            objKV.key = objProduct.Id;
                            objKV.value = objProduct.MModel2__c;
                            lstKV.add(objKV);
                        }
                    }       
                }
            }
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static List<Key_Value> getModelVariantApex(String selectedType, String strManuId, String selectedYear, String selectedModel) {
        List<Key_Value> lstKV = new List<Key_Value>();
        
        if(selectedModel !=  '0') {
            List<BOATBUILDING__Product__c> lstProductModelVrnt = [Select Id, M_Model_Variant__c From BOATBUILDING__Product__c where MModel2__c =: selectedModel AND M_Year__c =: selectedYear AND Product_Manufacturer__c =: strManuId AND Product_Type__c =: selectedType];
            System.debug('lstProductModelVrnt: '+lstProductModelVrnt);
            for(BOATBUILDING__Product__c objProduct : lstProductModelVrnt ){
                if(objProduct.M_Model_Variant__c != null){
                    Key_Value objKV = new Key_Value();
                    objKV.key = objProduct.Id;
                    objKV.value = objProduct.M_Model_Variant__c;
                    lstKV.add(objKV);
                }
            }
        }
        return lstKV;
    }
    
    @AuraEnabled
    public static List<PriceAndProductOptionWraperClass> getProductPriceApex(String SelectedType, String selectedManu, String selectedYear, String selectedModel, String selectedModelVariant, String MVStatus) {
        
        Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
        Map<String , List<CheckBoxWraper>> mapCheckBoxWraper = new Map<String , List<CheckBoxWraper>>();
        List<PriceAndProductOptionWraperClass> lstPriceAndProductOptionWraperClass = new List<PriceAndProductOptionWraperClass>();
        
        if(SelectedType == 'New Boat') {
            SelectedType = 'New Boats';
        }
        System.debug('>>: '+SelectedType);
        
        if(MVStatus == '1') {
            mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManu, selectedYear, SelectedType).getSelectedCatagory();
            System.debug('mapSelectedCategory: '+mapSelectedCategory);
            if(SelectedType == 'New Boats') {
             	Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(selectedModelVariant, selectedManu, selectedYear, 'Trailer').getSelectedCatagory();
             	mapSelectedCategory.putAll(mapSelectedCategory2);
            } 
        } else {
            mapSelectedCategory = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManu, selectedYear, SelectedType).getSelectedCatagory();
            if(SelectedType == 'New Boats') {
             	Map<String , List<BOATBUILDING__ProductPrice__c>> mapSelectedCategory2 = OptionAndSelectedCatagoryUtil.getInstance(selectedModel, selectedManu, selectedYear, 'Trailer').getSelectedCatagory();
             	mapSelectedCategory.putAll(mapSelectedCategory2);
            } 
            System.debug('mapSelectedCategory: '+mapSelectedCategory);
        }
        
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
    public static List<DealerOptionWraper> getDealerPriceApex() {
        return InventorySelectionTableController.getDealerPriceApex();
    }
    
    @AuraEnabled
    public static Product__c getProduct(String ProId) {
        Product__c objProduct = new Product__c();
         
        objProduct = [Select Id, M_Boat_MSRP_PRICE__c, Cost_Price__c, Default_Costline__c From Product__c Where Id =: ProId];
        
        return objProduct;
    }
}