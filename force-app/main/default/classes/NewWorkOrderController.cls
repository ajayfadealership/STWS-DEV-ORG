public with sharing class NewWorkOrderController {
    @AuraEnabled
    public static List<RecordType>  getRecordType(String RecTy) {
        List<RecordType> lstRT =   [SELECT Id, Name,developerName FROM RecordType WHERE Id =: RecTy AND SobjectType =: 'BOATBUILDING__Work_Order__c'];
        return lstRT;
    }
    
    @AuraEnabled
    public static List<BOATBUILDING__Item__c> getAccountRelatedItems(String recId) {
        List<BOATBUILDING__Item__c> lstItem =   [SELECT Id, Name FROM BOATBUILDING__Item__c WHERE BOATBUILDING__Account__c =: recId ];
        return lstItem;
    }
    
    @AuraEnabled
    public static List<BOATBUILDING__Item__c> getItemsDetail(String itemId) {
        List<BOATBUILDING__Item__c> lstItem =   [SELECT Id, 
                                                 Name, 
                                                 BOATBUILDING__Boat_Manufacturer__r.Name,
                                                 BOATBUILDING__Engine_Manufacturer__r.Name,
                                                 BOATBUILDING__M_Boat_Year__c ,
                                                 BOATBUILDING__Engine_Year__c,
                                                 BOATBUILDING__Boat_Model__c,
                                                 BOATBUILDING__Boat_HIN_No__c,
                                                 BOATBUILDING__Engine_Model__c
                                                 FROM BOATBUILDING__Item__c WHERE Id =: itemId Limit 1 ];
        return lstItem;
    }
    
    
    @AuraEnabled 
    public static List<WODetailPageController.LayoutSection> getPageLayoutFields() {
        List<WODetailPageController.LayoutSection> lstSections = WODetailPageController.getPageLayoutFields();
        return lstSections; 
    }
    
    @AuraEnabled 
    public static String getStoreLocation(String UserId) {
        List<User> lstUser = [SELECT BOATBUILDING__Store_Location__c FROM User WHERE Id =: UserId];
        if(!lstUser.isEmpty() && String.IsNotBlank(lstUser[0].BOATBUILDING__Store_Location__c)){
            return lstUser[0].BOATBUILDING__Store_Location__c;
        }else {
            
            return null;
            
        }
        
    }
    
    Public class ItemWrapper{
        @AuraEnabled 
        Public List<BOATBUILDING__Item__c> lstItem  {get; set;}
        @AuraEnabled 
        Public String  AccountId {get; set;}
        @AuraEnabled 
        Public Boolean itemIsAvailble {get; set;}
        
    }
    
    @AuraEnabled 
    public static  ItemWrapper getItemFromContact(String ContactId) {
        try{
            List<BOATBUILDING__Item__c> lstItem = new List<BOATBUILDING__Item__c> ();
            List<Contact> lstContact = [SELECT Id,AccountId from Contact Where Id =:ContactId Limit 1];
            ItemWrapper objIW = new ItemWrapper();
            if(!lstContact.isEmpty()){
                lstItem = [SELECT Id, Name, BOATBUILDING__Account__c FROM BOATBUILDING__Item__c WHERE BOATBUILDING__Account__c =: lstContact[0].AccountId];
                if(!lstItem.isEmpty()) {
                    
                    objIW.lstItem =  lstItem;
                    objIW.AccountId = lstContact[0].AccountId;
                    objIW.itemIsAvailble = true;
                }
                
                if(lstItem.isEmpty()) {
                    lstItem = [SELECT Id, Name, BOATBUILDING__Account__c FROM BOATBUILDING__Item__c ORDER BY CreatedDate DESC Limit 10000];
                    
                    objIW.lstItem =  lstItem;
                    objIW.AccountId = lstContact[0].AccountId;
                    objIW.itemIsAvailble = false;
                    
                } 
                system.debug('&&&&&'+lstItem);
                return objIW;
                
            }else{
                return null;
            }
        }catch(Exception ex){
              throw new AuraHandledException('Darn it! Something went wrong: ' + ex.getMessage()); 
             
        }
        
        
    }
    
    
    
    
    
}