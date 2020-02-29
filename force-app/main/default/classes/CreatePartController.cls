public with sharing class CreatePartController {
    public string strpart{get; set;}
    
    //public transient List<BOATBUILDING__Part__c> lstOfParts{get; set;}
    public BOATBUILDING__Part__c objPart1 { get;set; }
    
    public CreatePartController() {
        objPart1 = new BOATBUILDING__Part__c();
        /*lstOfParts = [SELECT 
                            Id,
                            Name, 
                            Dealer_Price__c, 
                            Part_Number__c,
                            Part_Cost__c, 
                            Retail_Price__c, 
                            Vendor_Name__c,
                            Vendor_Name__r.Name,
                            Map_Price__c
                    FROM  
                            BOATBUILDING__Part__c 
                    ORDER BY
                            CreatedDate DESC
                            LIMIT 999 
                   ];*/
    }
	public List<BOATBUILDING__Part__c> getlstOfParts() { 
		return [SELECT 
                            Id,
                            Name, 
                            Dealer_Price__c, 
                            Part_Number__c,
                            Part_Cost__c, 
                            Retail_Price__c, 
                            Vendor_Name__c,
                            Vendor_Name__r.Name,
                            Map_Price__c
                    FROM  
                            BOATBUILDING__Part__c 
                    ORDER BY
                            CreatedDate DESC
                            LIMIT 999 
                   ];
	}
    @RemoteAction
    public static List<BOATBUILDING__Manufacturer__c> fetchManufacturer(String strManuId) {
        if(strManuId != null) { 
            return [SELECT Id, Name, City__c, Contact_Person__c, Contact_Person__r.Name, Email__c, Phone__c, State__c, Street__c, Terms__c, Zip__c FROM BOATBUILDING__Manufacturer__c WHERE Id =: strManuId LIMIT 1];
        }
        else { 
            return null;
        }
    }
    
   
    @RemoteAction
    public static String savePart(Map<String,String> objPartmap) {
        list<BOATBUILDING__Part__c> lstPart = [select Id, Part_Number__c from BOATBUILDING__Part__c WHERE Part_Number__c =: objPartMap.get('partNumber')];
          if(!lstPart.isEmpty()){
              return 'DUPLICATE';
          }
        System.debug('Debug Log for savePart Method Called?');
        BOATBUILDING__Part__c objPart2 = new BOATBUILDING__Part__c();
            
            if(objPartMap.get('vendor')!=null) {
                objPart2.Vendor_Name__c = objPartMap.get('vendor');
            }
            
            if(objPartMap.get('partMSRP')!=null && objPartMap.get('partMSRP')!='') {
                objPart2.Retail_Price__c = Decimal.valueOf(objPartMap.get('partMSRP'));
            }
            
            if(objPartMap.get('partWeight')!=null && objPartMap.get('partWeight')!='') {
                objPart2.Weight__c = objPartMap.get('partWeight');
            }
            
            if(objPartMap.get('partSize')!=null && objPartMap.get('partSize')!='') {
                objPart2.Part_Size__c = objPartMap.get('partSize');
            }
            
            if(objPartMap.get('partNumber')!=null && objPartMap.get('partNumber')!='') {
                objPart2.Part_Number__c = objPartMap.get('partNumber');
            }
            
            if(objPartMap.get('StoreLocation')!=null && objPartMap.get('StoreLocation')!='') {
                objPart2.Store_Location__c = objPartMap.get('StoreLocation');
            }
            
            if(objPartMap.get('partColor')!=null && objPartMap.get('partColor')!='') {
                objPart2.Part_Color__c = objPartMap.get('partColor');
            }
            
            if(objPartMap.get('partDescription')!=null && objPartMap.get('partDescription')!='') {
                objPart2.Name = objPartMap.get('partDescription');
            }
            
            if(objPartMap.get('partDiscount')!=null && objPartMap.get('partDiscount')!='') {
                objPart2.Discount__c = Decimal.valueOf(objPartMap.get('partDiscount'));
            }
            
            if(objPartMap.get('partCost')!=null && objPartMap.get('partCost')!='') {
                objPart2.Part_Cost__c = Decimal.valueOf(objPartMap.get('partCost'));
            }
            
            if(objPartMap.get('partCategory')!=null && objPartMap.get('partCategory')!='') {
                objPart2.Category1__c = objPartMap.get('partCategory');
            }
            
            if(objPartMap.get('partFamily')!=null && objPartMap.get('partFamily')!='') {
                objPart2.Family1__c = objPartMap.get('partFamily');
            }
            
            if(objPartMap.get('partMinAmount')!=null && objPartMap.get('partMinAmount')!='') {
                objPart2.Minimum_Amount__c = Decimal.valueOf(objPartMap.get('partMinAmount'));
            }
            
            if(objPartMap.get('partLocation')!=null && objPartMap.get('partLocation')!='') {
                objPart2.Location__c = objPartMap.get('partLocation');
            }
            
            if(objPartMap.get('partBin')!=null && objPartMap.get('partBin')!='') {
                objPart2.Bin__c = objPartMap.get('partBin');
            }
            
            if(objPartMap.get('MapPrice')!=null && objPartMap.get('MapPrice')!='') {
                objPart2.Map_Price__c = Decimal.valueOf(objPartMap.get('MapPrice'));
            }
            if(objPartMap.get('OEM_Part_Number')!=null && objPartMap.get('OEM_Part_Number')!='') {
                objPart2.OEM_Part_Number__c = objPartMap.get('OEM_Part_Number');
            }
            
            /*if(objPartMap.get('shippingCharges')!=null && objPartMap.get('shippingCharges')!='') {
                objPart2.Shipping_Charge__c = Decimal.valueOf(objPartMap.get('shippingCharges'));
            }*/
            
        try {
            System.debug('Debug Log for objPart2 :'+objPart2);
           
            insert objPart2;
            
            
        }catch(Exception ex) {
            
              System.debug('_________Catch___'+ex);
              System.debug('_________Catch___'+ex.getLineNumber());
             
        }
        if(objPart2.id!=null) {
                
                return 'SUCCESS';
            }
            else {
                
                return null;
            }
        
    }
    @RemoteAction
	public static List<Part__c> getPartList() {
		return [SELECT 
                            Id,
                            Name, 
                            Dealer_Price__c, 
                            Part_Number__c,
                            Part_Cost__c, 
                            Retail_Price__c, 
                            Vendor_Name__c,
                            Vendor_Name__r.Name,
                            Map_Price__c
                    FROM  
                            BOATBUILDING__Part__c 
                    ORDER BY
                            CreatedDate DESC
                            LIMIT 50000   
                   ];	
	}
}