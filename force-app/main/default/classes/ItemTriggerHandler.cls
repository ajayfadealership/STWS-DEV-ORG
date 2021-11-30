public with sharing class ItemTriggerHandler {
    
    public static void UpdateItemRecordFromInventory(List<BOATBUILDING__Item__c> lstnew, Map<Id,BOATBUILDING__Item__c> oldMap) {
        List<BOATBUILDING__Inventory__c> lstInven = new  List<BOATBUILDING__Inventory__c>();
        BOATBUILDING__Item__c oldItem = new  BOATBUILDING__Item__c ();
        Set<Id> setId = new Set<Id>();
        for(BOATBUILDING__Item__c objItem : lstnew ){
            if(String.IsNotBlank(objItem.Id)){
                oldItem = oldMap != null ? oldMap.get(objItem.Id) : new  BOATBUILDING__Item__c();
            }
            if(objItem.BOATBUILDING__Related_to_Inventory__c != null && oldItem.BOATBUILDING__Related_to_Inventory__c != objItem.BOATBUILDING__Related_to_Inventory__c ){
                setId.add(objItem.BOATBUILDING__Related_to_Inventory__c);
            }            
        }
        
        List<BOATBUILDING__Manufacturer__c> lstOfManufacturer = new List<BOATBUILDING__Manufacturer__c>();
        System.debug('setIdsetIdsetIdsetId'+setId);
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        
        lstInven = [SELECT Id ,BOATBUILDING__Year__c, BOATBUILDING__HIN_Number__c,BOATBUILDING__Model__c ,	BOATBUILDING__Boat_Length_in_feets__c,
                    BOATBUILDING__Manufacturer__c,   BOATBUILDING__Model_Variant__c,BOATBUILDING__Engine_Model__c,BOATBUILDING__Engine_Year__c,	BOATBUILDING__Engine_SN__c,	
                    BOATBUILDING__Boat_Capacities__c,BOATBUILDING__Boat_Type__c,BOATBUILDING__Make__c
                    FROM BOATBUILDING__Inventory__c WHERE Id IN: setId AND RecordTypeId !=: partInvRecordTypeId];
        System.debug('lstInven'+lstInven);
        Set<String> lstManu = new Set<String> ();
        for(BOATBUILDING__Inventory__c objInventory : lstInven){
            if(String.IsNotBlank(objInventory.BOATBUILDING__Manufacturer__c)){
                lstManu.add(objInventory.BOATBUILDING__Manufacturer__c);
            }
        }
        
        Map<String ,BOATBUILDING__Manufacturer__c> MapOfNameManu = new  Map<String ,BOATBUILDING__Manufacturer__c>();
        if(lstManu.size()> 0){
            lstOfManufacturer = [SELECT Id,Name FROM BOATBUILDING__Manufacturer__c WHERE Name IN : lstManu];
        }
        
        for(BOATBUILDING__Manufacturer__c objMFr : lstOfManufacturer ){
            MapOfNameManu.put(objMFr.Name , objMFr);
        }
        
        if(lstInven.size() > 0){
            for(BOATBUILDING__Item__c objI : lstnew ){
                for(BOATBUILDING__Inventory__c objInv : lstInven){     
                    objI.BOATBUILDING__M_Boat_Year__c = objInv.BOATBUILDING__Year__c;
                    objI.BOATBUILDING__Boat_Model__c = objInv.BOATBUILDING__Model__c;
                    objI.BOATBUILDING__Boat_HIN_No__c = objInv.BOATBUILDING__HIN_Number__c;
                    objI.BOATBUILDING__Boat_Length_in_Feets__c  = objInv.BOATBUILDING__Boat_Length_in_feets__c;
                    objI.BOATBUILDING__Boat_Model_Variant__c = objInv.BOATBUILDING__Model_Variant__c;
                    objI.BOATBUILDING__Boat_Type__c = objInv.BOATBUILDING__Boat_Type__c;
                    objI.BOATBUILDING__Boat_Manufacturer__c  =  MapOfNameManu.get(objInv.BOATBUILDING__Manufacturer__c).Id;                    
                    System.debug('objI'+objI);
                }                
            }
        }
        
        //for HIN NO.
        Set<String> setItemBoatHin = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInven2 = new  List<BOATBUILDING__Inventory__c>();
        
        for(BOATBUILDING__Item__c objItems : lstnew){
            if(String.IsNotBlank(objItems.Id)){
                oldItem = oldMap != null ? oldMap.get(objItems.Id) : new  BOATBUILDING__Item__c();
            }
            if(String.isNotBlank(objItems.BOATBUILDING__Boat_HIN_No__c)  && oldItem.BOATBUILDING__Boat_HIN_No__c  != objItems.BOATBUILDING__Boat_HIN_No__c && objItems.BOATBUILDING__Related_to_Inventory__c == null){
                setItemBoatHin.add(objItems.Boat_HIN_No__c);
                system.debug('*****'+objItems.Boat_HIN_No__c);
            }            
        }
        
        List<BOATBUILDING__Manufacturer__c> lstOfManufacturer2 = new List<BOATBUILDING__Manufacturer__c>();
        lstInven2  = [SELECT Id ,BOATBUILDING__Year__c, BOATBUILDING__HIN_Number__c,BOATBUILDING__Model__c ,BOATBUILDING__Boat_Length_in_feets__c,BOATBUILDING__Manufacturer__c,	
                      BOATBUILDING__Model_Variant__c,	BOATBUILDING__Engine_Model__c,BOATBUILDING__Engine_Year__c,	BOATBUILDING__Engine_SN__c,	
                      BOATBUILDING__Boat_Capacities__c,BOATBUILDING__Boat_Type__c,BOATBUILDING__Make__c
                      FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__HIN_Number__c IN: setItemBoatHin AND RecordTypeId !=: partInvRecordTypeId];
        
        system.debug('lstInven2*****'+lstInven2);
        Map<String,BOATBUILDING__Inventory__c> mapInvent = new Map<String,BOATBUILDING__Inventory__c>();
        Set<String> SetofM = new Set<String> ();
        for(BOATBUILDING__Inventory__c objInventory2 : lstInven2){
            if(String.IsNotBlank(objInventory2.BOATBUILDING__Manufacturer__c)){
                SetofM.add(objInventory2.BOATBUILDING__Manufacturer__c);
            }            
        }
        
        if(SetofM.size()> 0){
            lstOfManufacturer2 = [SELECT Id,Name  FROM BOATBUILDING__Manufacturer__c WHERE Name IN : SetofM ];
        }
        
        Map<String,BOATBUILDING__Manufacturer__c> MAPofMctrer = new Map<String,BOATBUILDING__Manufacturer__c>();
        for(BOATBUILDING__Manufacturer__c objmftr : lstOfManufacturer2){
            MAPofMctrer.put(objmftr.Name , objmftr);
        }
        
        for(BOATBUILDING__Inventory__c objInvent : lstInven2 ){
            if(String.isNotBlank(objInvent.BOATBUILDING__HIN_Number__c)){
                mapInvent.put(objInvent.BOATBUILDING__HIN_Number__c,objInvent);
            }
        }
        
        for(BOATBUILDING__Item__c objI2 : lstnew){
            if(String.isNotBlank(objI2.BOATBUILDING__Boat_HIN_No__c) && mapInvent.containsKey(objI2.BOATBUILDING__Boat_HIN_No__c) &&  objI2.BOATBUILDING__Related_to_Inventory__c == null){
                objI2.BOATBUILDING__Related_to_Inventory__c = mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).Id;
                objI2.BOATBUILDING__M_Boat_Year__c =   mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Year__c;
                objI2.BOATBUILDING__Boat_Model__c =    mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Model__c;
                objI2.BOATBUILDING__Boat_Length_in_Feets__c  =  mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Boat_Length_in_feets__c;
                objI2.BOATBUILDING__Boat_Model_Variant__c =   mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Model_Variant__c;
                objI2.BOATBUILDING__Boat_Type__c =  mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Boat_Type__c;
                if(mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Manufacturer__c != null){
                    objI2.BOATBUILDING__Boat_Manufacturer__c =  MAPofMctrer.get(mapInvent.get(objI2.BOATBUILDING__Boat_HIN_No__c).BOATBUILDING__Manufacturer__c).Id;
                }
                system.debug('SSSSSSSS'+lstnew[0].Name);
            }            
        }
        system.debug('$$$$$$$'+lstnew[0].Name);        
    }
    
    public static void ShowDuplicateHinNoError(List<BOATBUILDING__Item__c> lstnew) {
        
        Set<String> setContactId = new Set<String>();
        Set<String> setBoatHin = new Set<String>();
        for(BOATBUILDING__Item__c objItm: lstnew) {
            if(objItm.BOATBUILDING__Contact__c != null){
                setContactId.add(objItm.BOATBUILDING__Contact__c);
            }
            if(String.isNotBlank(objItm.Boat_HIN_No__c)) {
                setBoatHin.add(objItm.Boat_HIN_No__c);
            }
        } 
        
        List<Contact> listCont = [SELECT Id, AccountId FROM Contact WHERE Id IN: setContactId];
        
        for(BOATBUILDING__Item__c objItm: lstnew) {
            for(Contact c: listCont){
                if(objItm.BOATBUILDING__Contact__c == c.Id){
                    objItm.BOATBUILDING__Account__c = c.AccountId;
                }
            }
        }
        
        System.debug('Debug Log For setBoatHin: '+setBoatHin);
        List<BOATBUILDING__Item__c> lstItm = [Select Id, Boat_HIN_No__c From BOATBUILDING__Item__c Where Boat_HIN_No__c IN: setBoatHin];
        Set<String> setBoatHinExisting = new Set<String>(); 
        
        if(!lstItm.isEmpty()) {
            
            for(BOATBUILDING__Item__c objItm: lstnew) {
                for(BOATBUILDING__Item__c objItmm: lstItm) {
                    if(objItmm.Id != null) {
                        if(objItm.Boat_HIN_No__c == objItmm.Boat_HIN_No__c && objItm.Id != objItmm.Id) {
                            objItm.addError('This boat is already exist. Please try with different Boat HIN.');
                        }
                    } else {
                        if(objItm.Boat_HIN_No__c == objItmm.Boat_HIN_No__c) {
                            objItm.addError('This boat is already exist. Please try with different Boat HIN.');
                        }
                    }
                }   
            }
        }
        
        system.debug('$$$$$$$'+lstnew[0].Name);
        
    }
    
    public static void syncAccountInApp(List<BOATBUILDING__Item__c> lstNew, Map<Id, BOATBUILDING__Item__c> oldMap){
        Set<Id> setItemIds = new Set<Id>();
        for(BOATBUILDING__Item__c objItem : lstNew){
            if(objItem.BOATBUILDING__Account__c != oldMap.get(objItem.id).BOATBUILDING__Account__c){
                // we will uncomment this code when swadeesh fix the user sync service with two params.
                //appAccountSyncCallout(oldMap.get(objItem.id).BOATBUILDING__Account__c);
                //appAccountSyncCallout(objItem.BOATBUILDING__Account__c);                
            }
        }
    }
    
    @future(callout = true)
    public static void appAccountSyncCallout(String accountId){
        BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
        
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', objConfig.BOATBUILDING__AppOrgId__c);
        mapRequestBody.put('salesforce_user_id', accountId);
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
        req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/workOrder/update'); 
        req.setMethod('POST');
        String body = JSON.serialize(mapRequestBody);
        req.setBody(body);
        System.debug('APP req---'+req);
        System.debug('APP body---'+body);
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('APP res---'+res);
        }
    }    
}