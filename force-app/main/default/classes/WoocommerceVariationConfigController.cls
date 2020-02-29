public class WoocommerceVariationConfigController {
    public List<BOATBUILDING__Woocommerce_Attribute__c> lstWooComAtt { get; set; }
    public String strNewAttName { get; set; }
    public List<Part__c> lstPart { get; set; }
    public BOATBUILDING__Woocom_Variant_Option__c objWVP { get; set; }
    public List<VariationCreationWrapper> lstVCW { get; set; }
    public String strNewVriationName { get; set; }
    public String dltPartId { get; set; }
    
    public String strTempName;
    public Part__c objPart { get; set; }
    public List<BOATBUILDING__Woocom_Variant_Option__c> lstWVO { get; set; }
    public String strPartId { get; set; }
    public List<VariationCreationWrapper> lstVCWForFields { get; set; }
    
    public WoocommerceVariationConfigController(ApexPages.StandardController sc) {
    	strNewAttName = '';
        lstWooComAtt = [Select Id, Name, BOATBUILDING__WooCom_Attribute_Id__c From BOATBUILDING__Woocommerce_Attribute__c ORDER BY Name ASC limit 1000];
        objWVP = new BOATBUILDING__Woocom_Variant_Option__c();
        lstWVO = new List<BOATBUILDING__Woocom_Variant_Option__c>();
        lstVCWForFields = new List<VariationCreationWrapper>();
        //Getting Variations
        strPartId = ApexPages.currentPage().getParameters().get('id');
        dltPartId = '';
        lstPart = [Select
		       	   		   RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
		                   BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,
		                   BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c,
		                   BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
		                   BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
		                   BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
		                   BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
		                   BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c,
		                   (
		                   		Select 
			                   		Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c, 
			                   		BOATBUILDING__Woocommerce_Attribute__r.Name
		                   		From BOATBUILDING__Woocom_Variant_Options__r
		                   )
		           From 
		           		   Part__c Where Part__c =: strPartId];
   		
        lstVCW = new List<VariationCreationWrapper>();
        objPart = [Select Name, Part__c from Part__c Where Id =: strPartId];
        strNewVriationName = objPart.Name;
        strTempName = strNewVriationName;
        
        lstWVO = [Select Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c, 
			                   		BOATBUILDING__Woocommerce_Attribute__r.Name
		                   		From BOATBUILDING__Woocom_Variant_Option__c Where BOATBUILDING__Part__c =: strPartId AND BOATBUILDING__Field_Option__c = true];
		                   		
	                 		
    }
    
    public void saveAttribute() {
    	System.debug('Debug Log For strNewAttName: '+strNewAttName);
    	if(String.isNotBlank(strNewAttName)) {
    		BOATBUILDING__Woocommerce_Attribute__c objAtt = new BOATBUILDING__Woocommerce_Attribute__c();
    		objAtt.Name = strNewAttName;
    		insert objAtt;
    		strNewAttName = '';
        	lstWooComAtt = [Select Id, Name, BOATBUILDING__WooCom_Attribute_Id__c From BOATBUILDING__Woocommerce_Attribute__c ORDER BY Name ASC limit 1000];
    	}
    }
    
    public void addNewAttToVarList() {
    	Integer randomNumber = Integer.valueof((Math.random() * 100));
    	String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
	    String randStr = '';
	    while (randStr.length() < 5) {
	       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
	       randStr += chars.substring(idx, idx+1);
	    }
	    String TempId = String.valueOf(randomNumber) + randStr;
	    System.debug('Debug Log For TempId: '+TempId);
	    VariationCreationWrapper objVariationCreationWrapper = new VariationCreationWrapper(TempId);
    	lstVCW.add(objVariationCreationWrapper);
    }
    
    public void addNewAttToVarListField() {
    	Integer randomNumber = Integer.valueof((Math.random() * 100));
    	String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
	    String randStr = '';
	    while (randStr.length() < 5) {
	       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
	       randStr += chars.substring(idx, idx+1);
	    }
	    String TempId = String.valueOf(randomNumber) + randStr;
	    System.debug('Debug Log For TempId: '+TempId);
	    VariationCreationWrapper objVariationCreationWrapper = new VariationCreationWrapper(TempId);
    	lstVCWForFields.add(objVariationCreationWrapper);
    }
    
    public void saveVariantWithAttributesApex() {
    	if(!lstVCW.isEmpty()) {
    		Part__c objPart = [Select 
                                   RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
                                   BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,
                                   BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c,
                                   BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                   BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
                                   BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
                                   BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
                                   BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c
                                   
                               From 
                                   BOATBUILDING__Part__c b
                               Where 	
                                   Id =: ApexPages.currentPage().getParameters().get('id')];

			Part__c objPart1 = objPart.clone(false, true);
			objPart1.Name = strNewVriationName;
			Integer randomNumber = Integer.valueof((Math.random() * 100));
	    	String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
		    String randStr = '';
		    while (randStr.length() < 5) {
		       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
		       randStr += chars.substring(idx, idx+1);
		    }
		    String TempId = String.valueOf(randomNumber) + randStr;
			objPart1.BOATBUILDING__Part_Number__c = objPart1.BOATBUILDING__Part_Number__c + ':'+randStr;
			objPart1.BOATBUILDING__SKU__c = objPart1.BOATBUILDING__SKU__c + ':'+randStr;
			objPart1.Part__c = objPart.Id;
			insert objPart1;
			List<BOATBUILDING__Woocom_Variant_Option__c> lstWVO = new List<BOATBUILDING__Woocom_Variant_Option__c>(); 
			for(VariationCreationWrapper objVCW: lstVCW) {
				BOATBUILDING__Woocom_Variant_Option__c objWVO = objVCW.objWVO;
				objWVO.Part__c = objPart1.Id;
				lstWVO.add(objWVO); 
			}
			insert lstWVO;
			strNewVriationName = strTempName;
			lstVCW = new List<VariationCreationWrapper>();
			String strPartId = ApexPages.currentPage().getParameters().get('id');
        
	        lstPart = [Select
			       	   		   RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
			                   BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,
			                   BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c,
			                   BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
			                   BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
			                   BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
			                   BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
			                   BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c,
			                   (
			                   		Select 
				                   		Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c, 
				                   		BOATBUILDING__Woocommerce_Attribute__r.Name
			                   		From BOATBUILDING__Woocom_Variant_Options__r
			                   )
			           From 
			           		   Part__c Where Part__c =: strPartId];
    	}
    }
    
    public void saveVariantWithAttributesApexField() {
    	if(!lstVCWForFields.isEmpty()) {
    		String strPartId = ApexPages.currentPage().getParameters().get('id');
			List<BOATBUILDING__Woocom_Variant_Option__c> lstWVO = new List<BOATBUILDING__Woocom_Variant_Option__c>(); 
			for(VariationCreationWrapper objVCW: lstVCWForFields) { 
				BOATBUILDING__Woocom_Variant_Option__c objWVO = objVCW.objWVO;
				objWVO.Part__c = strPartId;
				objWVO.BOATBUILDING__Field_Option__c = true;
				lstWVO.add(objWVO); 
			} 
			insert lstWVO;
	        lstWVO = [Select Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c, 
			                   		BOATBUILDING__Woocommerce_Attribute__r.Name
		                   		From BOATBUILDING__Woocom_Variant_Option__c Where BOATBUILDING__Part__c =: strPartId AND BOATBUILDING__Field_Option__c = true];
   			lstVCWForFields = new List<VariationCreationWrapper>();
    	}
    }
    
    public void deleteAttFromVarListApex() {
    	System.debug('Debug Log For dltPartId: '+dltPartId);
    	List<VariationCreationWrapper> lstVCWTemp = new List<VariationCreationWrapper>();
    	for(VariationCreationWrapper objVCW: lstVCW) {
    		if(objVCW.strTempId != dltPartId) {
    			lstVCWTemp.add(objVCW);
    		} 
    	}
    	lstVCW = lstVCWTemp;
    }
    
    public void deleteAttFromVarListApexField() {
    	System.debug('Debug Log For dltPartId: '+dltPartId);
    	List<VariationCreationWrapper> lstVCWTemp = new List<VariationCreationWrapper>();
    	for(VariationCreationWrapper objVCW: lstVCW) {
    		if(objVCW.strTempId != dltPartId) {
    			lstVCWTemp.add(objVCW);
    		} 
    	}
    	lstVCWForFields = lstVCWTemp;
    }
    
    public void deleteVarFromHomeListApex() {
    	System.debug('Debug Log For dltPartId: '+dltPartId);
    	delete [Select Id From BOATBUILDING__Woocom_Variant_Option__c Where Part__c =: dltPartId];
    	delete [Select Id From Part__c Where Id =: dltPartId];
    	String strPartId = ApexPages.currentPage().getParameters().get('id');
        
        lstPart = [Select
		       	   		   RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
		                   BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,
		                   BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c, BOATBUILDING__WooCommerce_Id__c,
		                   BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
		                   BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
		                   BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
		                   BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
		                   BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c,
		                   (
		                   		Select 
			                   		Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c, 
			                   		BOATBUILDING__Woocommerce_Attribute__r.Name
		                   		From BOATBUILDING__Woocom_Variant_Options__r
		                   )
		           From 
		           		   Part__c Where Part__c =: strPartId];
    	
    }
    public void deleteFieldFromHomeListApex() {
    	System.debug('Debug Log For dltPartId: '+dltPartId);
    	delete [Select Id From BOATBUILDING__Woocom_Variant_Option__c Where Id =: dltPartId];
    }
    public class VariationCreationWrapper {
    	public String strTempId { get; set; }
    	public BOATBUILDING__Woocom_Variant_Option__c objWVO { get; set; }
    	public String strMessage { get; set; }
    	public VariationCreationWrapper(String strTempId) {
    		this.strTempId = strTempId;
    		strMessage = '';
    		objWVO = new BOATBUILDING__Woocom_Variant_Option__c();
    	}
    }
     
}