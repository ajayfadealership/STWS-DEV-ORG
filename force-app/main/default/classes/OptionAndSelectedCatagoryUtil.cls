/** 
* Author : Akshay Kumar 360 
* Created Date : 21/10/2016
*/
public with sharing class OptionAndSelectedCatagoryUtil{
    
    List<String> lstSelectedCatagory = new List<String>();
    Map<String , List<BOATBUILDING__ProductPrice__c>> mapProductPriceForSelectedCategory = new Map<String , List<BOATBUILDING__ProductPrice__c>>();
    
    private Boolean modelVarientFlag;

    private OptionAndSelectedCatagoryUtil(String strProductId2, String strManufacturerId2, String strYear, String strRecordType){
        modelVarientFlag = false;
        Set<String> setSelectedOptions = new Set<String>();
        String strModelName = '';
        List<BOATBUILDING__ProductPrice__c> lstProductPriceForSelectedCategory = new List<BOATBUILDING__ProductPrice__c>(); 
        String strRecTypeId = '';
        
        List<RecordType> lstRec =   [Select 
                                        Id 
                                FROM 
                                        RecordType 
                                WHERE 
                                        SobjectType='BOATBUILDING__ProductPrice__c' 
                                AND 
                                        Name =: strRecordType];
        if(lstRec.size() > 0){
            strRecTypeId = lstRec[0].Id;
        }                                        
        if(strRecordType.equalsIgnoreCase('New Boats') || strRecordType.equalsIgnoreCase('Trailer') || strRecordType.equalsIgnoreCase('Engine')) { 
            String strManufacturerName = '';
            List<BOATBUILDING__Manufacturer__c> lstManufacturer =    [Select  
                                                                                Id, 
                                                                                Name, 
                                                                                Model_Variant__c 
                                                                        FROM 
                                                                                BOATBUILDING__Manufacturer__c 
                                                                        WHERE 
                                                                                Id =: strManufacturerId2
                                                                        LIMIT
                                                                                1];
            if(lstManufacturer.size() > 0) {
                strManufacturerName = lstManufacturer[0].Name;
                modelVarientFlag = lstManufacturer[0].Model_Variant__c;
            }                                        
            if(modelVarientFlag){
                strModelName =  [Select 
                                        id, 
                                        M_Model_Variant__c 
                                FROM    
                                        BOATBUILDING__Product__c 
                                WHERE 
                                        Id =: strProductId2 
                                LIMIT 
                                        1].M_Model_Variant__c;
                String strMainModel = [Select 
	                                        id, 
	                                        MModel2__c 
	                                FROM    
	                                        BOATBUILDING__Product__c 
	                                WHERE 
	                                        Id =: strProductId2 
	                                LIMIT 
	                                        1].MModel2__c;
                System.debug('>>>>>>>>>>>>>>>>>strModelName '+strModelName );
                lstProductPriceForSelectedCategory =    [SELECT 
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
                                                        		  Product_Model__c =: strMainModel
                                                        AND
                                                                Model_Variant__c =: strModelName 
                                                        AND   
                                                                ProductManufacturer__c =: strManufacturerName 
                                                        AND 
                                                                Year__c =: strYear 
                                                        AND 
                                                                RecordTypeId =: strRecTypeId
                                                        ORDER BY
                                                                Sorting_Order__c ASC        
                                                                
                                                        Limit 
                                                                1000];
                
            }else if(!modelVarientFlag){
                strModelName =      [SELECT 
                                            id, 
                                            MModel2__c 
                                    FROM 
                                            BOATBUILDING__Product__c 
                                    WHERE 
                                            Id =: strProductId2 
                                    LIMIT 
                                            1].MModel2__c;
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strModelName );
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strManufacturerName );
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strRecTypeId );
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strYear );                       
                lstProductPriceForSelectedCategory =    [SELECT 
                                                                Id, 
                                                                Option_Category__c, 
                                                                ProductSelected_Category__c, 
                                                                ProductRetail_Price__c, 
                                                                Dealer_Price__c, 
                                                                Product_Code__c, 
                                                                ProductManufacturer__c, 
                                                                Year__c, 
                                                                Product_Model__c, 
                                                                Model_Variant__c,
                                                                Sorting_Order__c,
                                                                RecordType.Name 
                                                         FROM 
                                                                BOATBUILDING__ProductPrice__c 
                                                         WHERE 
                                                                Product_Model__c=: strModelName 
                                                         AND 
                                                                ProductManufacturer__c =: strManufacturerName 
                                                         AND 
                                                                Year__c =: strYear 
                                                         AND 
                                                                RecordTypeId =: strRecTypeId
                                                                
                                                         ORDER BY 
                                                                Sorting_Order__c ASC       
                                                         LIMIT
                                                                1000];
            System.debug('Debug log for o : '+lstProductPriceForSelectedCategory);                                                                
            }
        }else if(strRecordType.equalsIgnoreCase('Used Boats')) {
            System.debug('Debug Log For strRecTypeId: '+strRecTypeId+' + '+strRecordType); 
            lstProductPriceForSelectedCategory =    [Select 
                                                            Id, 
                                                            Option_Category__c, 
                                                            ProductSelected_Category__c, 
                                                            ProductRetail_Price__c, 
                                                            Dealer_Price__c, 
                                                            Product_Code__c, 
                                                            ProductManufacturer__c, 
                                                            Year__c, 
                                                            Product_Model__c, 
                                                            Model_Variant__c,
                                                            RecordType.Name 
                                                              
                                                    FROM 
                                                            BOATBUILDING__ProductPrice__c 
                                                    WHERE 
                                                            RecordTypeId =: strRecTypeId
                                                    LIMIT
                                                            1000]; 
        } /*else if(strRecordType.equalsIgnoreCase('Trailer')) {
        		List<BOATBUILDING__Manufacturer__c> lstManufacturer =    [Select  
                                                                                Id, 
                                                                                Name, 
                                                                                Model_Variant__c 
                                                                        FROM 
                                                                                BOATBUILDING__Manufacturer__c 
                                                                        WHERE 
                                                                                Id =: strManufacturerId2
                                                                        LIMIT
                           
                                                                                1];
        	
        		String strManufacturerName = '';
        		if(lstManufacturer.size() > 0) {
                strManufacturerName = lstManufacturer[0].Name;
        		}
        		strModelName =      [SELECT 
                                            id, 
                                            M_Year__c 
                                    FROM 
                                            BOATBUILDING__Product__c 
                                    WHERE 
                                            Id =: strProductId2 
                                    LIMIT 
                                            1].M_Year__c	;
                                            
                           
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strModelName );
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strManufacturerName );
                 System.debug('>>>>>>>>>>>>>>>>>strModelName '+strRecTypeId );                     
                lstProductPriceForSelectedCategory =    [SELECT 
                                                                Id, 
                                                                Option_Category__c, 
                                                                ProductSelected_Category__c, 
                                                                ProductRetail_Price__c, 
                                                                Dealer_Price__c, 
                                                                Product_Code__c, 
                                                                ProductManufacturer__c, 
                                                                Year__c, 
                                                                Product_Model__c, 
                                                                Model_Variant__c,
                                                                Sorting_Order__c  
                                                         FROM 
                                                                BOATBUILDING__ProductPrice__c 
                                                         WHERE 
                                                                Year__c=: strModelName //For Year
                                                         AND 
                                                                ProductManufacturer__c =: strManufacturerName 
                                                         AND 
                                                                RecordTypeId =: strRecTypeId
                                                                
                                                         ORDER BY 
                                                                Sorting_Order__c ASC       
                                                         LIMIT
                                                                1000];
        }*/
        
        
        
        System.debug('Debug Log For strModelName : '+ strModelName);
        if(lstProductPriceForSelectedCategory.size() > 0){
            for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : lstProductPriceForSelectedCategory){
                setSelectedOptions.add(objProductPriceForSelectedCategory.Option_Category__c);
            }
        }
        if(setSelectedOptions.size() > 0){
            for(String strCSString : setSelectedOptions){
                if(!mapProductPriceForSelectedCategory.keySet().contains(strCSString)){
                    mapProductPriceForSelectedCategory.put(strCSString, new List<BOATBUILDING__ProductPrice__c>());
                }
                for(BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory : lstProductPriceForSelectedCategory){
                    
                    if(objProductPriceForSelectedCategory.Option_Category__c == strCSString){
                        mapProductPriceForSelectedCategory.get(strCSString).add(objProductPriceForSelectedCategory);
                    }
                }
            }
        }
        System.debug('_____________mapProductPriceForSelectedCategory: '+mapProductPriceForSelectedCategory);
    }
     
    public static OptionAndSelectedCatagoryUtil getInstance(String strProductId, String strManufacturerId, String strYear, String strRecordType){
        
        return new OptionAndSelectedCatagoryUtil(strProductId, strManufacturerId, strYear, strRecordType);
    }
    
    public Map<String, List<BOATBUILDING__ProductPrice__c>> getSelectedCatagory(){
        
        return mapProductPriceForSelectedCategory;
    }
    
}