public with sharing class OrderEditController {
    //method to add Inventory
    @AuraEnabled
    public static String addInventory(String strOrderId,  List<OrderEditWrapper> lstlistItem) {
        try {
            Integer sCount = 0;
            List<String> pickListValuesList= new List<String>();
            Set<String> setPicklistSL = new Set<String>();
            List<Object> lstObj = new List<Object>();
            List<Parts_Availability__c> lstPA = new List<Parts_Availability__c>();
            Schema.DescribeFieldResult fieldResult = Order__c.Store_Location__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
                setPicklistSL.add(pickListVal.getLabel());
            }  
            String oneValue = '';
            sCount = ple.size(); 
            if(sCount == 1) {
                oneValue = pickListValuesList[0];
            }
            /*if(sCount == 2 && (setPicklistSL.contains('Other') || setPicklistSL.contains('other'))) {
                sCount = 1;
                List<String> lstAll2 = new List<String>(); 
                lstAll2.addAll(setPicklistSL); 
                if(lstAll2[0] == 'Other' || lstAll2[0] == 'other') {
                    oneValue = lstAll2[1];
                } else if(lstAll2[1] == 'Other' || lstAll2[1] == 'other') {
                    oneValue = lstAll2[0];
                }
            }*/
            Set<String> setPartNumbers =  new Set<String>();
            for(OrderEditWrapper obj:lstlistItem){
                if(obj.received > 0){
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
            
            for(OrderEditWrapper obj:lstlistItem){
                if(obj.received > 0){
                    if(mapPart.containsKey(obj.partNo)) {
                        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
                        if(mapInv.containskey(obj.partNo)){
                            objInventory = mapInv.get(obj.partNo) ;   
                        } 
                        if(objInventory.BOATBUILDING__Quantity__c != null){
                            objInventory.BOATBUILDING__Quantity__c  += obj.received ;
                        }else{
                            objInventory.BOATBUILDING__Quantity__c  = obj.received ;    
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
                        objInventory.Bin__c = mapPart.get(obj.partNo).Bin__c    ;
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
            for(Inventory__c obj: lstUpdatedInventory) {
                System.debug('obj: '+obj);
                for(OrderEditWrapper objOrderEditWrapper:lstlistItem){
                    if(obj.Part_Number__c == objOrderEditWrapper.partNo) {
                        if(objOrderEditWrapper.received > 0 && sCount > 1){
                            if(obj.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                                for(Parts_Availability__c objPA: objOrderEditWrapper.lstPA) {
                                    Parts_Availability__c objPAIN = new Parts_Availability__c();
                                    objPAIN = objPA;
                                    objPAIN.Inventory__c = obj.Id;
                                    lstPA.add(objPAIN);
                                }
                            } else if(!obj.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                                System.debug('obj.BOATBUILDING__Parts_Availability__r: '+obj.BOATBUILDING__Parts_Availability__r);
                                Map<String, Parts_Availability__c> mapStoreLocToPA = new Map<String, Parts_Availability__c>();
                                for(Parts_Availability__c objPA : obj.BOATBUILDING__Parts_Availability__r) {
                                    mapStoreLocToPA.put(objPA.Store_Location__c, objPA);
                                }
                                System.debug('objOrderEditWrapper.lstPA: '+objOrderEditWrapper.lstPA);
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
                                        objPAIN.BOATBUILDING__Quantity__c = objOrderEditWrapper.received;
                                        lstPA.add(objPAIN);
                                    }
                                }
                            }
                        } else if(sCount == 1){
                            Map<String, Parts_Availability__c> mapStoreLocToPA = new Map<String, Parts_Availability__c>();
                            for(Parts_Availability__c objPA : obj.BOATBUILDING__Parts_Availability__r) {
                                mapStoreLocToPA.put(objPA.Store_Location__c, objPA);
                            }
                            Parts_Availability__c objPAIN;
                            if(mapStoreLocToPA.containsKey(oneValue)) {
                                objPAIN = mapStoreLocToPA.get(oneValue);
                            } else {
                                objPAIN = new Parts_Availability__c();
                                objPAIN.Inventory__c = obj.Id;
                            }
                            objPAIN.Store_Location__c = oneValue;
                            objPAIN.BOATBUILDING__Quantity__c = objOrderEditWrapper.received;
                            lstPA.add(objPAIN);
                        }
                    }
                } 
            }
            if(!lstPA.isEmpty()) 
                upsert lstPA;
            BOATBUILDING__Order__c objOrder = [Select Id, RecordTypeId, Vendor_Name__c, PO_Date__c From Order__c Where Id =: strOrderId];
            objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order Approved').getRecordTypeId(); 
            objOrder.Is_Approved__c = true;
            update objOrder;
            return 'SUCCESS';
        } catch(Exception ex) {
    		System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
    	}
    }
    
    @AuraEnabled
    public static String addToInventoryWithBackOrder(String strOrderId, List<OrderEditWrapper> lstlistItem){
        String strResponse = addInventory(strOrderId, lstlistItem);
        if(!strResponse.containsIgnoreCase('error')) {
            try {
                Boolean isBackOrder = false;
                Set<String> setPartNumbers =  new Set<String>();
                for(OrderEditWrapper objOrderEditWrapper: lstlistItem) {
                    if(objOrderEditWrapper.backOrderQuantity > 0) {
                        isBackOrder = true;
                        setPartNumbers.add(objOrderEditWrapper.partNo);
                    }
                }
                
                if(isBackOrder) {
                    List<BOATBUILDING__Part__c> lstPart = [Select 
                                                            Bin__c, Vendor_Name__c,  Retail_Price__c,  Part_Number__c,  Name,  Id, Dealer_Price__c, Part_Cost__c, Category1__c, 
                                                            Discount__c, Family1__c, Location__c, Map_Price__c, Minimum_Amount__c, Part_Color__c, Part_Size__c, Taxable__c, Weight__c
                                                    From 
                                                            BOATBUILDING__Part__c 
                                                    WHERE 
                                                            Part_Number__c 
                                                    IN
                                                            :setPartNumbers]; 
                    BOATBUILDING__Order__c objOrder = [Select Id, RecordTypeId, Vendor_Name__c, PO_Date__c From Order__c Where Id =: strOrderId];
                    BOATBUILDING__Order__c objBackPurchaseOrder = new BOATBUILDING__Order__c();
                    objBackPurchaseOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId(); 
                    objBackPurchaseOrder.Vendor_Name__c = objOrder.Vendor_Name__c;
                    objBackPurchaseOrder.PO_Date__c = System.Today();
                    insert objBackPurchaseOrder;
                    Decimal amntOnOrder = 0.00; 
                    List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
                    for(BOATBUILDING__Part__c objPrt : lstPart) {
                        for(OrderEditWrapper objOrderEditWrapper: lstlistItem) {
                            BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
                            if(objOrderEditWrapper.partNo == objPrt.Part_Number__c && objOrderEditWrapper.backOrderQuantity > 0) {
                                objPOLI.Purchase_Order__c = objBackPurchaseOrder.Id;
                                objPOLI.Name = objPrt.Name;
                                objPOLI.Retail_Price__c = objPrt.Retail_Price__c;
                                objPOLI.Dealer_Price__c = objPrt.Dealer_Price__c;
                                objPOLI.Part_Number__c = objPrt.Part_Number__c;
                                objPOLI.Vendor_Name__c = objPrt.Vendor_Name__c;
                                objPOLI.Cost__c = objPrt.Part_Cost__c;
                                objPOLI.Quantity__c = Decimal.valueOf(objOrderEditWrapper.backOrderQuantity);
                                objPOLI.Bin__c = objPrt.Bin__c;
                                objPOLI.Category__c = objPrt.Category1__c;
                                objPOLI.Discount__c = objPrt.Discount__c;
                                objPOLI.Family__c = objPrt.Family1__c;
                                objPOLI.Location__c = objPrt.Location__c;
                                objPOLI.Map_Price__c = objPrt.Map_Price__c;
                                objPOLI.Minimum_Amount__c = objPrt.Minimum_Amount__c;
                                objPOLI.Color__c = objPrt.Part_Color__c;
                                objPOLI.Size__c = objPrt.Part_Size__c;
                                objPOLI.Taxable__c = objPrt.Taxable__c;
                                if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                                    objPOLI.Weight__c = objPrt.Weight__c; 
                                }
                                if(objPrt.Part_Cost__c != null){
                                    amntOnOrder += Integer.valueOf(objOrderEditWrapper.backOrderQuantity) * objPrt.Part_Cost__c;
                                }
                                lstPOLI.add(objPOLI);   
                            }
                        }
                    }
                    insert lstPOLI;
                    objBackPurchaseOrder.Amount_On_Order__c = amntOnOrder;
                    update objBackPurchaseOrder;            
                }
                return 'SUCCESS';
            } catch(Exception ex) {
                System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		    return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
            }
        } else {
            return strResponse;
        }
    }
    

    @AuraEnabled
    public static List<OrderEditWrapper> getLineItemDetail(String recordOrderId){
        List<BOATBUILDING__Line_Items__c> lstlineItem = [SELECT Id, BOATBUILDING__Order__c, BOATBUILDING__Amount__c,
                                                         BOATBUILDING__Cost__c,BOATBUILDING__Discount__c,BOATBUILDING__Part_Number_del__c,
                                                         BOATBUILDING__Quantity__c,BOATBUILDING__Total_Cost__c,BOATBUILDING__Name__c
                                                         FROM BOATBUILDING__Line_Items__c WHERE BOATBUILDING__Order__c =: recordOrderId];
        
        List<OrderEditWrapper> lstWrapper = new List<OrderEditWrapper>();
        System.debug('>>>>lstLineItem -'+ lstlineItem);
        for(BOATBUILDING__Line_Items__c objlstlineItem : lstlineItem){
            OrderEditWrapper objOrderEditWrapper = new OrderEditWrapper();
            objOrderEditWrapper.lineItemId= objlstlineItem.Id;
            objOrderEditWrapper.amount= objlstlineItem.BOATBUILDING__Amount__c;
            objOrderEditWrapper.cost= objlstlineItem.BOATBUILDING__Cost__c;
            objOrderEditWrapper.quantity= Integer.valueof(objlstlineItem.BOATBUILDING__Quantity__c);
            // objOrderEditWrapper.totalOfQuantity +=Integer.valueof(objlstlineItem.BOATBUILDING__Quantity__c);
            objOrderEditWrapper.partNo= objlstlineItem.BOATBUILDING__Part_Number_del__c;
            objOrderEditWrapper.description= objlstlineItem.BOATBUILDING__Name__c;
            objOrderEditWrapper.received= 0;
            objOrderEditWrapper.lstPA = new List<BOATBUILDING__Parts_Availability__c>();
            lstWrapper.add(objOrderEditWrapper);
        }
        return lstWrapper;
    }
    
    @AuraEnabled
    public static BOATBUILDING__Order__c getOrderDetail(String recordId){
        BOATBUILDING__Order__c objOrder = [SELECT Id, BOATBUILDING__Vendor_Name__c,BOATBUILDING__Grand_Total__c,BOATBUILDING__Shipping_Charges__c,
                                           BOATBUILDING__Discount_Price__c,BOATBUILDING__Amount_On_Order__c FROM BOATBUILDING__Order__c WHERE Id =: recordId];
        return objOrder;
    }
    @AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();        
        return recid;
    }
    @AuraEnabled
    public static List<Object> getSlocationDetails(){
        Integer sCount = 0;
        Set<String> setPicklistSL = new Set<String>();
        List<Object> lstObj = new List<Object>();
        Schema.DescribeFieldResult fieldResult = Order__c.Store_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            setPicklistSL.add(pickListVal.getLabel());
        }  
        sCount = ple.size(); 
        if(sCount == 2 && (setPicklistSL.contains('Other') || setPicklistSL.contains('other'))) {
        	//sCount = 1;
        } 

        lstObj.add(sCount);
        lstObj.add(setPicklistSL);
        //1. Count
        //2. Slocation Set
        return lstObj;
    }
}