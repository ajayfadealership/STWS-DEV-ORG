public with sharing class BoatMatchController {
    public String boatMatchLogoId { get; set; }
    public String boatMatchCompanyName { get; set; }
    public String fontColot { get; set; }
    public BoatMatchController() {
        List<Document> lstDoc = [SELECT Id FROM Document Where DeveloperName = 'Boat_Match_Logo' LIMIT 1];
        if(lstDoc.size() > 0) { 
            boatMatchLogoId = '/servlet/servlet.FileDownload?file='+String.valueOf(lstDoc[0].Id);
            fontColot = 'white';
        } else { 
            //boatMatchLogoId = 'https://s-media-cache-ak0.pinimg.com/originals/c0/2f/02/c02f0286e5d0a1a394359f176be753ca.jpg';
            fontColot = 'black';
        }
       
        List<BOATBUILDING__BoatMatch__c> lstBM = BOATBUILDING__BoatMatch__c.getAll().values();
        if(!lstBM.isEmpty()) {
            boatMatchCompanyName = lstBM[0].Name;
        } else {
            boatMatchCompanyName = 'SouthTown Watersports';
        }
    }
     
    @RemoteAction
    public static List<Account> searchAccount(String strParam, String srtParamSearch)
    {
        system.debug('strParam====='+strParam);
        system.debug('srtParamSearch====='+srtParamSearch);
        
        List<Account> lstAccount = new List<Account>();
        
        if(strParam.equalsIgnoreCase('all')) {
            lstAccount = [Select 
                                    Id, Name, Phone, BOATBUILDING__Email__c
                            From 
                                    Account
                            Limit 
                                    1000];  
        }
        else if(strParam.equalsIgnoreCase('boat')) {
            srtParamSearch = '%'+srtParamSearch+'%';
            
            List<BOATBUILDING__Item__c> lstItem = new List<BOATBUILDING__Item__c>();
            lstItem = [Select 
                                Id, BOATBUILDING__Contact__c, BOATBUILDING__Contact__r.AccountId 
                        From 
                                BOATBUILDING__Item__c
                        Where
                                BOATBUILDING__Boat_Model__c Like: srtParamSearch
                        OR 
                                BOATBUILDING__Boat_Model_Variant__c Like: srtParamSearch
                        OR
                                BOATBUILDING__M_Boat_Year__c Like: srtParamSearch
                        OR
                                BOATBUILDING__Boat_Manufacturer__r.Name Like: srtParamSearch];
            
            Set<String> setAccId = new Set<String>();
            if(!lstItem.isEmpty()) {
                for(BOATBUILDING__Item__c objItem: lstItem) {
                    if(objItem.BOATBUILDING__Contact__c != null && objItem.BOATBUILDING__Contact__r.AccountId != null) {
                        setAccId.add(objItem.BOATBUILDING__Contact__r.AccountId);
                    }
                }
            }
            
            if(!setAccId.isEmpty()) {
                lstAccount = [Select 
                                    Id, Name, Phone, BOATBUILDING__Email__c
                                From 
                                        Account
                                Where
                                        Id IN: setAccId 
                                Limit 
                                        1000];  
            }
            
        }
        else if(strParam.equalsIgnoreCase('desiredboat')) {
            try {
                Decimal priceVal = Decimal.valueOf(srtParamSearch);
                
                lstAccount = [Select  
                                    Id, Name, Phone, BOATBUILDING__Email__c, 
                                    BOATBUILDING__Desired_Boat_Manufacturer__c, BOATBUILDING__Desire_boat_model__c,
                                    BOATBUILDING__Prospect_Desired_Boat_Length__c, BOATBUILDING__Desire_price_high__c,
                                    BOATBUILDING__Desire_Price_low__c
                            From 
                                    Account
                            Where 
                                    BOATBUILDING__Prospect_Desired_Boat_Length__c =: priceVal 
                            OR
                                    BOATBUILDING__Desire_price_high__c =: priceVal  
                            OR
                                    BOATBUILDING__Desire_price_high__c =: priceVal   
                            LIMIT 
                                    1000];
                                    System.debug(lstAccount);
                return lstAccount;
            } catch(Exception ex) {
                srtParamSearch = '%'+srtParamSearch+'%';
                lstAccount = [Select 
                                    Id, Name, Phone, BOATBUILDING__Email__c, 
                                    BOATBUILDING__Desired_Boat_Manufacturer__c, BOATBUILDING__Desire_boat_model__c,
                                    BOATBUILDING__Prospect_Desired_Boat_Length__c, BOATBUILDING__Desire_price_high__c,
                                    BOATBUILDING__Desire_Price_low__c
                            From 
                                    Account
                            Where 
                                    BOATBUILDING__Desired_Boat_Manufacturer__c LIKE: srtParamSearch 
                            OR
                                    BOATBUILDING__Desire_boat_model__c LIKE: srtParamSearch  
                            LIMIT 
                                    1000];
                return lstAccount;
            }
        }
        else if(strParam.equalsIgnoreCase('trade')) {
            srtParamSearch = '%'+srtParamSearch+'%';
            lstAccount = [Select 
                                Id, Name, Phone, BOATBUILDING__Email__c, 
                                BOATBUILDING__Trade_Make__c, BOATBUILDING__Trade_Model__c,
                                BOATBUILDING__Trade_Model_Year__c
                        From 
                                Account
                        Where
                                BOATBUILDING__Trade_Make__c LIKE: srtParamSearch 
                        OR
                                BOATBUILDING__Trade_Model__c LIKE: srtParamSearch  
                        OR
                                BOATBUILDING__Trade_Model_Year__c LIKE: srtParamSearch  
                        LIMIT 
                                1000]; 
        }
        
        return lstAccount;
    }
}