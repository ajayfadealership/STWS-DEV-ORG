public with sharing class ReceiveAllAtLocation {
    //method to add Inventory
    @AuraEnabled
    public static String partAvailabilityAtLocation(String selectedLocation, List<OrderEditWrapper> lstlistItem , String strOrderId) {
        try {
            Integer sCount = 0;
            Set<String> setPartNumbers =  new Set<String>();
            for(OrderEditWrapper obj:lstlistItem){
                if(obj.quantity > 0){
                    setPartNumbers.add(obj.partNo);
                }
            }
            System.debug('>>>: '+lstlistItem);
            Id InvenRecId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();        
            List<BOATBUILDING__Part__c> lstPart = [Select 
                                                   Bin__c, Vendor_Name__c,  Retail_Price__c,  Part_Number__c,  Name,  Id, Dealer_Price__c, Part_Cost__c, Category1__c, 
                                                   Discount__c, Family1__c, Location__c, Map_Price__c, Minimum_Amount__c, Part_Color__c, Part_Size__c, Taxable__c, Weight__c
                                                   From 
                                                   BOATBUILDING__Part__c 
                                                   WHERE 
                                                   Part_Number__c 
                                                   IN
                                                   :setPartNumbers]; 
            Map<String, BOATBUILDING__Part__c> mapPart = new Map<String, BOATBUILDING__Part__c>();
            for(BOATBUILDING__Part__c objP: lstPart) {
                mapPart.put(objP.Part_Number__c, objP);
            }
            List<BOATBUILDING__Inventory__c> lstUpdatedInventory = new List<BOATBUILDING__Inventory__c>();
            List<BOATBUILDING__Inventory__c> lstInventory =[SELECT 
                                                            Id, Vendor__c, Cost__c, Part_Number__c, Part_MSRP_Price__c, Description__c, Quantity__c,
                                                            Taxable__c, Weight__c,
                                                            (Select Id, IsDeleted, Name, BOATBUILDING__Inventory__c, 
                                                             BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                             From BOATBUILDING__Parts_Availability__r)
                                                            FROM 
                                                            BOATBUILDING__Inventory__c WHERE RecordTypeId =:invenRecId AND BOATBUILDING__Part_Number__c IN:setPartNumbers];
            for(Inventory__c obj: lstInventory) {
                System.debug('objINV: '+obj);
                System.debug('objINV.BOATBUILDING__Parts_Availability__r: '+obj.BOATBUILDING__Parts_Availability__r);
            }
            Map<String,BOATBUILDING__Inventory__c> mapInv = new Map<String,BOATBUILDING__Inventory__c>();
            
            for(BOATBUILDING__Inventory__c objInv :lstInventory){
                mapInv.put(objInv.BOATBUILDING__Part_Number__c,objInv);
            }
            Decimal amntOnOrder = 0.00;
            for(OrderEditWrapper obj:lstlistItem){
                if(obj.quantity > 0){
                    if(mapPart.containsKey(obj.partNo)) {
                        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
                        if(mapInv.containskey(obj.partNo)){
                            objInventory = mapInv.get(obj.partNo) ;   
                        } 
                        objInventory.BOATBUILDING__Part_Number__c =obj.partNo;
                        objInventory.RecordTypeId = InvenRecId;
                        objInventory.Part_Name__c = mapPart.get(obj.partNo).Name;
                        objInventory.Size__c = mapPart.get(obj.partNo).BOATBUILDING__Part_Size__c;
                        objInventory.Vendor__c = mapPart.get(obj.partNo).BOATBUILDING__Vendor_Name__c;
                        objInventory.Part_Number__c = mapPart.get(obj.partNo).Part_Number__c;
                        objInventory.Description__c = mapPart.get(obj.partNo).Name;
                        objInventory.Cost__c = mapPart.get(obj.partNo).BOATBUILDING__Part_Cost__c;
                        objInventory.Category__c = mapPart.get(obj.partNo).BOATBUILDING__Category1__c;
                        objInventory.Bin__c = mapPart.get(obj.partNo).Bin__c;
                        objInventory.Color__c = mapPart.get(obj.partNo).BOATBUILDING__Part_Color__c;
                        objInventory.Part_Location__c = mapPart.get(obj.partNo).BOATBUILDING__Location__c; 
                        objInventory.Map_Price__c = mapPart.get(obj.partNo).BOATBUILDING__Map_Price__c;
                        //objInventory.Minimum_Amount__c = mapPart.get(obj.partNo).Name;
                        objInventory.Taxable__c= mapPart.get(obj.partNo).BOATBUILDING__Taxable__c;
                        objInventory.Weight__c = mapPart.get(obj.partNo).BOATBUILDING__Weight__c;
                        objInventory.Part_MSRP_Price__c = mapPart.get(obj.partNo).BOATBUILDING__Retail_Price__c;
                        
                        lstUpdatedInventory.add(objInventory); 
                    }
                }
            }
            upsert lstUpdatedInventory;
            List<Parts_Availability__c> lstPA = new List<Parts_Availability__c>();
            for(Inventory__c obj: lstUpdatedInventory) {
                System.debug('obj: '+obj);
                for(OrderEditWrapper objOrderEditWrapper:lstlistItem){
                    if(obj.Part_Number__c == objOrderEditWrapper.partNo && objOrderEditWrapper.quantity > 0) {
                        if(obj.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                            Parts_Availability__c objPAIN = new Parts_Availability__c();
                            objPAIN.Store_Location__c = selectedLocation;
                            objPAIN.Inventory__c = obj.Id;
                            objPAIN.BOATBUILDING__Quantity__c = objOrderEditWrapper.quantity;
                            lstPA.add(objPAIN);
                        } else {
                            Map<String, Parts_Availability__c> mapStoreLocToPA = new Map<String, Parts_Availability__c>();
                            for(Parts_Availability__c objPA : obj.BOATBUILDING__Parts_Availability__r) {
                                mapStoreLocToPA.put(objPA.Store_Location__c, objPA);
                            }
                            if(mapStoreLocToPA.containsKey(selectedLocation)) {
								Parts_Availability__c objPAIN = mapStoreLocToPA.get(selectedLocation);  
                                if(objPAIN.Quantity__c != null) {
                                  objPAIN.Quantity__c +=   objOrderEditWrapper.quantity;
                                } else {
                                    objPAIN.Quantity__c =   objOrderEditWrapper.quantity;
                                }
                                lstPA.add(objPAIN);
                            } else {
                                Parts_Availability__c objPAIN = new Parts_Availability__c();
                                objPAIN.Store_Location__c = selectedLocation;
                                objPAIN.Inventory__c = obj.Id;
                                objPAIN.BOATBUILDING__Quantity__c = objOrderEditWrapper.quantity;
                                lstPA.add(objPAIN);
                            }
                        }
                        amntOnOrder += Integer.valueOf(objOrderEditWrapper.quantity) * obj.Cost__c; 
                    }
                }
            }
            upsert lstPA;
            BOATBUILDING__Order__c objOrder = [Select Id, RecordTypeId, Vendor_Name__c, PO_Date__c, BOATBUILDING__Shipping_Charges__c, BOATBUILDING__Discount_Price__c From Order__c Where Id =: strOrderId];
            objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order Approved').getRecordTypeId(); 
            objOrder.Is_Approved__c = true;
            objOrder.Amount_On_Order__c = amntOnOrder;
            update objOrder;
            return 'SUCCESS';
        } catch(Exception ex) {
            System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
            return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
        }
    }
    
}