public with sharing class ReceiveAllAtLocation {
    @AuraEnabled
    public static String partAvailabilityAtLocation(String selectedLocation, List<OrderEditWrapper> lstlistItem) {
        System.debug('>>>> before try lstlistItem : '+lstlistItem);
        try { 
            System.debug('>>>>lstlistItem : '+lstlistItem);
            Set<String> setPartNumbers =  new Set<String>();
            List<Parts_Availability__c> lstPA = new List<Parts_Availability__c>();
            Map<String, BOATBUILDING__Inventory__c> mapInv = new Map<String, BOATBUILDING__Inventory__c>();
            for(OrderEditWrapper obj:lstlistItem){
                setPartNumbers.add(obj.partNo);
            }
            Id InvenRecId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();        
            
            List<BOATBUILDING__Inventory__c> lstUpdatedInventory = new List<BOATBUILDING__Inventory__c>();
            List<BOATBUILDING__Inventory__c> lstInventory =[SELECT Id, Vendor__c, Cost__c, Part_Number__c, Part_MSRP_Price__c, Description__c, Quantity__c,
                                                            Taxable__c, Weight__c,
                                                            (Select Id, IsDeleted, Name, BOATBUILDING__Inventory__c, 
                                                             BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                             From BOATBUILDING__Parts_Availability__r)FROM BOATBUILDING__Inventory__c 
                                                            WHERE RecordTypeId =:invenRecId AND BOATBUILDING__Part_Number__c IN:setPartNumbers];
            for(BOATBUILDING__Inventory__c objInv :lstInventory){
                mapInv.put(objInv.BOATBUILDING__Part_Number__c,objInv);
            }
            for(OrderEditWrapper obj:lstlistItem){
                
                BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
                if(mapInv.containskey(obj.partNo)){
                    objInventory = mapInv.get(obj.partNo) ;   
                } 
                if(objInventory.BOATBUILDING__Quantity__c != null){
                    objInventory.BOATBUILDING__Quantity__c  += obj.quantity ;
                }else{
                    objInventory.BOATBUILDING__Quantity__c  = obj.quantity ;    
                }
                objInventory.BOATBUILDING__Part_Number__c =obj.partNo;
                objInventory.RecordTypeId = InvenRecId;
                lstUpdatedInventory.add(objInventory); 
            }
            upsert lstUpdatedInventory;
            
            for(Inventory__c obj: lstUpdatedInventory) {
                
                for(OrderEditWrapper objOrderEditWrapper:lstlistItem){
                    
                    if(obj.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                        for(Parts_Availability__c objPA: objOrderEditWrapper.lstPA) {
                            Parts_Availability__c objPAIN = new Parts_Availability__c();
                            objPAIN = objPA;
                            objPAIN.Inventory__c = obj.Id;
                            lstPA.add(objPAIN);
                        }
                    } else if(!obj.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                        
                        Map<String, Parts_Availability__c> mapStoreLocToPA = new Map<String, Parts_Availability__c>();
                        for(Parts_Availability__c objPA : obj.BOATBUILDING__Parts_Availability__r) {
                            mapStoreLocToPA.put(objPA.Store_Location__c, objPA);
                        }
                        
                        for(Parts_Availability__c objPA: objOrderEditWrapper.lstPA) {
                            if(mapStoreLocToPA.containsKey(objPA.BOATBUILDING__Store_Location__c)){
                                Parts_Availability__c objPAIN = mapStoreLocToPA.get(objPA.BOATBUILDING__Store_Location__c);
                                objPAIN.Store_Location__c = objPA.BOATBUILDING__Store_Location__c;
                                if(objPAIN.BOATBUILDING__Quantity__c != null) {
                                    objPAIN.BOATBUILDING__Quantity__c += objPA.BOATBUILDING__Quantity__c;
                                } else { 
                                    objPAIN.BOATBUILDING__Quantity__c = objPA.BOATBUILDING__Quantity__c;
                                } 
                                lstPA.add(objPAIN); 
                            } else {
                                Parts_Availability__c objPAIN = new Parts_Availability__c();
                                objPAIN.Store_Location__c = objPA.BOATBUILDING__Store_Location__c;
                                objPAIN.Inventory__c = obj.Id;
                                objPAIN.BOATBUILDING__Quantity__c = objOrderEditWrapper.quantity;
                                lstPA.add(objPAIN);
                            }
                        }
                    }
                }
                
                
            }
            return 'SUCCESS';
        }   
        catch(Exception ex) {
            System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
            return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
        }
    }
}