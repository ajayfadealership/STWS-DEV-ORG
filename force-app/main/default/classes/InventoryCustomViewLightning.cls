/** 
* Author : Shubham Sharma 
* Created Date : 26/3/2020
*/
public class InventoryCustomViewLightning {

    @AuraEnabled
    public static List<BOATBUILDING__Inventory__c> fetchAllInventories(){
        String strQuery;
        List<BOATBUILDING__Inventory__c> listInventoryToReturn = new List<BOATBUILDING__Inventory__c>();
        
        strQuery = 'SELECT Id, Name,BOATBUILDING__Total_MSRP_Price__c, BOATBUILDING__Boat_Type__c,BOATBUILDING__Stage__c, RecordType.Name, '; 
        strQuery += 'Model_Variant__c, Manufacturer__c, BOATBUILDING__Year__c, Model__c, Store_Location__c, HIN_Number__c, BOATBUILDING__Location__c,';
        strQuery += 'Suggested_List_Price__c, Engine_SN__c, Trailer_VIN__c, Boat_Length_in_feets__c,Status_for_Days_on_the_Lot__c, ';
        strQuery += 'Status_for_Interest_Start_Date__c,Status_for_Curtailment_Start_Date__c,BOATBUILDING__Curtailment_Start_Date__c, ';
        strQuery += 'BOATBUILDING__Interest_Start_Date__c,BOATBUILDING__Days_on_Lot__c,BOATBUILDING__Owner__c, Main_color__c, Accent_color__c, ';
        strQuery += '(SELECT Id FROM Attachments WHERE Name LIKE \'%side__c%\' LIMIT 1) FROM ';
        strQuery += 'BOATBUILDING__Inventory__c WHERE BOATBUILDING__Stage__c != \'Sold\' ';
        strQuery += 'AND RecordType.Name != \'Inventory for Parts\' ';
        strQuery += 'AND BOATBUILDING__Stage__c != \'No Longer For Sale\' ';
        
        System.debug('strQuery----'+strQuery);
        listInventoryToReturn = database.query(strQuery);
        
        System.debug('lstINV----'+listInventoryToReturn);
        return listInventoryToReturn;
    }

 /*   @AuraEnabled 
    public static List<AggregateResult> getInventoryRecordType(){
        //  List<RecordType> lstRecTypeBoats = [SELECT  Name FROM RecordType
        //                                      WHERE  SobjectType = 'BOATBUILDING__Inventory__c' AND DeveloperName != 'Inventory_for_Parts']; 
        List<AggregateResult> ag = [SELECT count(Id) tc,RecordType.Name recName   FROM BOATBUILDING__Inventory__c 
         WHERE RecordType.Name != 'Inventory for Parts'  AND BOATBUILDING__Stage__c != 'Sold' group by RecordType.Name  ];
        return ag;
    }
    
    @AuraEnabled 
    public static list<InventoryStageCount> getInventoryBoatType(String Type){
        if(String.isNotBlank(Type)){
            Map<String, string> MapOfBoatType = new Map<String,String>();
            List<InventoryStageCount> lstBoatType = new  list<InventoryStageCount> ();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Boat_Type__c BoatType FROM BOATBUILDING__Inventory__c 
            WHERE BOATBUILDING__Boat_Type__c != null AND  RecordType.Name =: Type   AND BOATBUILDING__Stage__c != 'Sold' group by BOATBUILDING__Boat_Type__c ];
            // List<BOATBUILDING__Inventory__c> lstyear = [SELECT BOATBUILDING__Boat_Type__c from BOATBUILDING__Inventory__c];
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.BoatTypes = (String)obj.get('BoatType');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstBoatType.add(objSCountWrap);
            }        
            return lstBoatType;
        }
        else{
            Map<String, string> MapOfBoatType = new Map<String,String>();
            List<InventoryStageCount> lstBoatType = new  list<InventoryStageCount> ();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Boat_Type__c BoatType FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__Boat_Type__c != null  AND BOATBUILDING__Stage__c != 'Sold'  group by BOATBUILDING__Boat_Type__c ];
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.BoatTypes = (String)obj.get('BoatType');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstBoatType.add(objSCountWrap);
            }        
            return lstBoatType;
            
        }
    }
    
    @AuraEnabled 
    public static  List<InventoryStageCount> getInventoryStage(String Type){
        system.debug('/././././././.'+Type);
        if(String.isNotBlank(Type)){
            Map<String,Integer> MapOfStage = new Map<String,Integer>();
            List<InventoryStageCount> lstY = new List<InventoryStageCount>();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Stage__c stageName FROM BOATBUILDING__Inventory__c  WHERE RecordType.Name =: Type AND BOATBUILDING__Stage__c != 'Sold' AND BOATBUILDING__Stage__c != null group by BOATBUILDING__Stage__c ];
            // List<BOATBUILDING__Inventory__c> lstyear = [SELECT BOATBUILDING__Stage__c FROM BOATBUILDING__Inventory__c WHERE RecordType.Name =: Type AND  BOATBUILDING__Stage__c != 'Sold'];
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.stage = (String)obj.get('stageName');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
                
            }    
            return lstY; 
        } else{
            Map<String,Integer> MapOfStage = new Map<String,Integer>();
            List<InventoryStageCount> lstY = new List<InventoryStageCount>();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Stage__c stageName FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__Stage__c != 'Sold' AND BOATBUILDING__Stage__c != null group by BOATBUILDING__Stage__c ];
            // List<BOATBUILDING__Inventory__c> lstyear = [SELECT BOATBUILDING__Stage__c FROM BOATBUILDING__Inventory__c WHERE RecordType.Name =: Type AND  BOATBUILDING__Stage__c != 'Sold'];
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.stage = (String)obj.get('stageName');
                objSCountWrap.count = (Integer)obj.get('tc');
                MapOfStage.put( objSCountWrap.stage, objSCountWrap.count);
                lstY.add(objSCountWrap);
            }
            return lstY; 
            
        }
    }

    @AuraEnabled 
    public static List<InventoryStageCount> getInventoryYear(String Type){
        system.debug('>>>>>>>>>');
        if(String.isNotBlank(Type)){
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Year__c YearName FROM BOATBUILDING__Inventory__c  WHERE RecordType.Name =: Type  AND BOATBUILDING__Year__c != null  AND BOATBUILDING__Stage__c != 'Sold' group by BOATBUILDING__Year__c ];
            List<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Year = (String)obj.get('YearName');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
            }        
            return lstY;
        } else{
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Year__c YearName FROM BOATBUILDING__Inventory__c  WHERE BOATBUILDING__Stage__c != 'Sold' AND BOATBUILDING__Year__c != null group by BOATBUILDING__Year__c ];
            Map<String, string> MapOfYear = new Map<String,String>();
            list<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Year = (String)obj.get('YearName');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
            }        
            return lstY;
        }
    }
    
    @AuraEnabled 
    public static list<Integer> getYearCount(String Type){
        List<AggregateResult> ag = [SELECT count(Id) tc FROM BOATBUILDING__Inventory__c  WHERE RecordType.Name =: Type  group by BOATBUILDING__Year__c ];
        List<Integer>  lstCount = new List<Integer>();
        Map<Integer, Integer> MapOfCount = new Map<Integer,Integer>();
        for(AggregateResult obj : ag){
            lstCount.add((Integer)obj.get('tc'));
            MapOfCount.put((Integer)obj.get('tc'),(Integer)obj.get('tc'));
            lstCount = MapOfCount.values();
        }
        return lstCount;
    }
    
    @AuraEnabled 
    public static list<InventoryStageCount>  getInventoryModle(String Type, String Make ){
        if(String.isNotBlank(Make)){
            List<AggregateResult> ag = [SELECT count(Id) tc ,Model__c modle FROM BOATBUILDING__Inventory__c  WHERE BOATBUILDING__Manufacturer__c =: Make AND BOATBUILDING__Manufacturer__c != null  AND  BOATBUILDING__Stage__c != 'Sold' group by Model__c ];
            Map<String, string> MapOfYear = new Map<String,String>();
            list<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Model = (String)obj.get('modle');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
            }        
            return lstY;
            
            
        }else{
            
            List<AggregateResult> ag = [SELECT count(Id) tc ,Model__c modle FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__Manufacturer__c != null AND  BOATBUILDING__Stage__c != 'Sold' group by Model__c ];
            Map<String, string> MapOfYear = new Map<String,String>();
            list<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            //   List<BOATBUILDING__Inventory__c> lstyear = [SELECT Model__c from BOATBUILDING__Inventory__c WHERE  BOATBUILDING__Stage__c != 'Sold' AND  BOATBUILDING__Web_Make__c =: Make];
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Model = (String)obj.get('modle');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
            }    
            return  lstY;
        }
    }

    @AuraEnabled 
    public static list<InventoryStageCount>  getInventoryMake(String Type){
        if(String.isNotBlank(Type)){
            Map<String, Integer> MapOfMake = new Map<String,Integer>();
            list<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Manufacturer__c Make FROM BOATBUILDING__Inventory__c  WHERE RecordType.Name =: Type AND BOATBUILDING__Manufacturer__c != null AND BOATBUILDING__Manufacturer__c != null  AND  BOATBUILDING__Stage__c != 'Sold' group by BOATBUILDING__Manufacturer__c ];
            // List<BOATBUILDING__Inventory__c> lstyear = [SELECT BOATBUILDING__Manufacturer__c  from BOATBUILDING__Inventory__c WHERE  BOATBUILDING__Stage__c != 'Sold' AND   RecordType.Name =: Type];
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Makes = (String)obj.get('Make');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);

            }
            return lstY;
        }else{
            Map<String, Integer> MapOfMake = new Map<String,Integer>();
            list<InventoryStageCount> lstY = new  list<InventoryStageCount> ();
            List<AggregateResult> ag = [SELECT count(Id) tc ,BOATBUILDING__Manufacturer__c Make FROM BOATBUILDING__Inventory__c  WHERE  BOATBUILDING__Manufacturer__c != null AND BOATBUILDING__Manufacturer__c != null  AND  BOATBUILDING__Stage__c != 'Sold' group by BOATBUILDING__Manufacturer__c ];
            // List<BOATBUILDING__Inventory__c> lstyear = [SELECT BOATBUILDING__Manufacturer__c  from BOATBUILDING__Inventory__c WHERE  BOATBUILDING__Stage__c != 'Sold' AND   RecordType.Name =: Type];
            
            for(AggregateResult obj : ag ){
                InventoryStageCount objSCountWrap = new InventoryStageCount();
                objSCountWrap.Makes = (String)obj.get('Make');
                objSCountWrap.count = (Integer)obj.get('tc');
                lstY.add(objSCountWrap);
                
            }
            
            return lstY;            
        }
    } 
    
    @AuraEnabled 
    public static List<List<BOATBUILDING__Inventory__c>> SerchingOfInventory(String strSearch) {
        try {
            if(strSearch.length() > 1){
                system.debug('Call Check>>>>');
                String searchStr1 = '*'+strSearch+'*';
                String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  BOATBUILDING__Inventory__c (Id,Name,Stage__c,Model_Variant__c,Store_Location__c,RecordType.Name,Manufacturer__c,Model__c,HIN_Number__c,Engine_SN__c,Status_for_Days_on_the_Lot__c,Boat_Length_in_feets__c,Status_for_Interest_Start_Date__c,Main_color__c,Accent_color__c)';
                List<List<BOATBUILDING__Inventory__c>> searchList = search.query(searchQuery);
                system.debug('$#$#$'+searchList);
                return searchList;
            }else {
                return null;
            }
        }catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<Sobject> fetchInventory(String Type, string stage ,String year, String Modle , String BoatType, String Make ,String StoreLoc){
        
        String strQuery;
        List<Sobject> lstInv = new   List<Sobject>();
        system.debug('>>>StoreLoc'+StoreLoc);
            
        // lstInv =  [SELECT Id,Name,  BOATBUILDING__Stage__c, RecordType.Name, Model_Variant__c, Manufacturer__c,	BOATBUILDING__Year__c, Model__c ,Store_Location__c,HIN_Number__c,Suggested_List_Price__c,Engine_SN__c,Trailer_VIN__c,Boat_Length_in_feets__c,Location__c,Status_for_Days_on_the_Lot__c,Status_for_Interest_Start_Date__c,Status_for_Curtailment_Start_Date__c,Main_color__c,Accent_color__c, (SELECT Id FROM Attachments WHERE Name LIKE '%side__c%' LIMIT 1) FROM  BOATBUILDING__Inventory__c  WHERE  BOATBUILDING__Stage__c != 'Sold'];
        // return lstInv;
        strQuery = 'SELECT Id, Name,BOATBUILDING__Total_MSRP_Price__c, BOATBUILDING__Boat_Type__c,BOATBUILDING__Stage__c, RecordType.Name, '; 
        strQuery += 'Model_Variant__c, Manufacturer__c, BOATBUILDING__Year__c, Model__c, Store_Location__c, HIN_Number__c, ';
        strQuery += 'Suggested_List_Price__c, Engine_SN__c, Trailer_VIN__c, Boat_Length_in_feets__c, Location__c, Status_for_Days_on_the_Lot__c, ';
        strQuery += 'Status_for_Interest_Start_Date__c,Status_for_Curtailment_Start_Date__c,BOATBUILDING__Curtailment_Start_Date__c, ';
        strQuery += 'BOATBUILDING__Interest_Start_Date__c,BOATBUILDING__Days_on_Lot__c, Main_color__c, Accent_color__c,';
        strQuery += '(SELECT Id FROM Attachments WHERE Name LIKE \'%side__c%\' LIMIT 1) FROM ';
        strQuery += 'BOATBUILDING__Inventory__c WHERE BOATBUILDING__Stage__c != \'Sold\' ';
        strQuery += 'AND RecordType.Name != \'Inventory for Parts\' ';
        
        if(String.isNotBlank(Type)) {
            strQuery += ' AND RecordType.Name  =:Type';
        }
        if(String.isNotBlank(stage)) {
            strQuery += ' AND BOATBUILDING__Stage__c =:stage';
        }
        if(String.isNotBlank(year)) {
            strQuery += ' AND BOATBUILDING__Year__c =:year';
        }
        if(String.isNotBlank(Modle)) {
            strQuery += ' AND BOATBUILDING__Model__c =:Modle';
        }
        if(String.isNotBlank(BoatType)) {
            strQuery += ' AND BOATBUILDING__Boat_Type__c =:BoatType';
        }
        if(String.isNotBlank(Make)) {
            strQuery += ' AND BOATBUILDING__Web_Make__c =:Make';
        }
        if(String.isNotBlank(StoreLoc)) {
            strQuery += ' AND BOATBUILDING__Store_Location__c =:StoreLoc';
        }

        System.debug('strQuery----'+strQuery);
        lstInv = database.query(strQuery);
        
        System.debug('lstINV----'+lstInv);
        return lstInv;
    }
    
    public class InventoryStageCount{
        @AuraEnabled
        public String  stage{get; set;}
        @AuraEnabled
        public Integer count{get; set;}
        @AuraEnabled
        public String  Year{get; set;}
        @AuraEnabled
        public String  Make{get; set;}
        @AuraEnabled
        public String  Model {get; set;}
        @AuraEnabled
        public String  BoatTypes {get; set;}
        @AuraEnabled
        public String  Makes {get; set;}
        
    } */
}