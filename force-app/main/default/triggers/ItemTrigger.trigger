trigger ItemTrigger on BOATBUILDING__Item__c (before insert, before update) {
    Boolean isOn = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__ItemTrigger__c;
    if(isOn) {
        if(trigger.isBefore) {
            if(trigger.isUpdate || trigger.isInsert){
                System.debug('Hi i am in Item trigger');
                Set<String> setItemBoatHin = new Set<String>();
                List<BOATBUILDING__Inventory__c> lstInven = new  List<BOATBUILDING__Inventory__c>();
                
                for(BOATBUILDING__Item__c objItem : trigger.new){
                    
                    if(objItem.BOATBUILDING__Boat_HIN_No__c != null){
                        setItemBoatHin.add(objItem.Boat_HIN_No__c);
                        system.debug('boatHinNumber' +setItemBoatHin);
                        
                    }
                }
                lstInven = [SELECT Id , BOATBUILDING__HIN_Number__c FROM BOATBUILDING__Inventory__c WHERE BOATBUILDING__HIN_Number__c IN: setItemBoatHin];
                Map<String,BOATBUILDING__Inventory__c> mapInvent = new Map<String,BOATBUILDING__Inventory__c>();
                
                for(BOATBUILDING__Inventory__c objInvent : lstInven ){
                    mapInvent.put(objInvent.BOATBUILDING__HIN_Number__c,objInvent);
                }
                for(BOATBUILDING__Item__c objItem : trigger.new){
                    
                    if(String.isNotBlank(objItem.BOATBUILDING__Boat_HIN_No__c) && mapInvent.containsKey(objItem.BOATBUILDING__Boat_HIN_No__c)){
                        objItem.BOATBUILDING__Related_to_Inventory__c = mapInvent.get(objItem.BOATBUILDING__Boat_HIN_No__c).Id;
                    } 
                    else{ 
                        objItem.BOATBUILDING__Related_to_Inventory__c = null;
                    }
                    
                }
                
                Set<String> setContactId = new Set<String>();
                Set<String> setBoatHin = new Set<String>();
                for(BOATBUILDING__Item__c objItm: trigger.new) {
                    if(objItm.BOATBUILDING__Contact__c != null){
                        setContactId.add(objItm.BOATBUILDING__Contact__c);
                    }
                    if(String.isNotBlank(objItm.Boat_HIN_No__c)) {
                        setBoatHin.add(objItm.Boat_HIN_No__c);
                    }
                }
                
                List<Contact> listCont = [SELECT Id, AccountId FROM Contact WHERE Id IN: setContactId];
                
                for(BOATBUILDING__Item__c objItm: trigger.new) {
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
                    
                    for(BOATBUILDING__Item__c objItm: trigger.new) {
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
            }
            
        } 
    } 
}