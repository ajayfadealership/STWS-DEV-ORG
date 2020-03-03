public class PurchaseOrderLightningController {
    @AuraEnabled
    public static BOATBUILDING__Manufacturer__c fetchManuDetailsApex(String strManuId, String strPoId){
        
        if(String.isNotBlank(strPoId)){
            BOATBUILDING__Order__c objO = [SELECT Id, BOATBUILDING__Vendor_Name__c FROM BOATBUILDING__Order__c WHERE Id =: strPoId];
            strManuId = objO.BOATBUILDING__Vendor_Name__c;
        } 
        return  [ 
                    SELECT 
                            Id, Name, BOATBUILDING__Availability__c,BOATBUILDING__Boat_Builder__c,BOATBUILDING__City__c,BOATBUILDING__Contact_Person__c,
                            BOATBUILDING__Description__c,BOATBUILDING__Email__c,BOATBUILDING__Manufacturer_name__c,
                            BOATBUILDING__Model_Variant__c,BOATBUILDING__Oustanding_Amount_on_Orders__c,BOATBUILDING__Phone__c,BOATBUILDING__State__c,
                            BOATBUILDING__Street__c,BOATBUILDING__Terms__c,BOATBUILDING__Zip__c 
                    FROM 
                            BOATBUILDING__Manufacturer__c WHERE Id =: strManuId LIMIT 1
                ];
    }
    @AuraEnabled
    public static List<PurchaseOrderLineItemWrapper> getLineItems(String strPOId) { 
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = [Select 
                                                                            Id, BOATBUILDING__Quantity__c, BOATBUILDING__Part_Number__c, Name, BOATBUILDING__Cost__c 
                                                                    From 
                                                                            BOATBUILDING__Purchase_Order_Line_Item__c Where BOATBUILDING__Purchase_Order__c =: strPOId];

        for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI: lstPOLI) {
            PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
            objPOLIW.PartId = objPOLI.Id;
            objPOLIW.Quantity = Integer.valueOf(objPOLI.BOATBUILDING__Quantity__c);
            objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
            objPOLIW.PartName = objPOLI.Name;
            objPOLIW.Cost = objPOLI.BOATBUILDING__Cost__c;
            objPOLIW.showPill = true;
            lstPOLIW.add(objPOLIW); 
        }
        return lstPOLIW;
    }
    @AuraEnabled
    public static String searchPartsfromInventoryAndParts(String searchStr) {
        List<PartSearchResult> lstPartSearchResult = new List<PartSearchResult>();
        String strName = searchStr;
        if(searchStr == 'recentlyViewed') {
            strName = '';
            List<RecentlyViewed> lstrv = [Select Id,Name from RecentlyViewed where Type = 'BOATBUILDING__Inventory__c' OR Type = 'BOATBUILDING__Part__c'];
            for(RecentlyViewed rv : lstrv){
                 strName = strName+'(\"' + String.escapeSingleQuotes(rv.Name) + '\")';
                 strName =  strName + ' OR ';
            
                }
                strName  = '(\"' + 'test' + '\")';
            //strName  = '(\"' + vendorId + '\")';
        } 
        String searchQuery = 'FIND \'' + strName + '\' IN ALL FIELDS RETURNING  BOATBUILDING__Part__c(Id,Name,BOATBUILDING__Quantity__c,BOATBUILDING__Part_Cost__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Vendor_Name__r.Name,BOATBUILDING__Discount__c ORDER BY CreatedDate)';
        List<List <sObject>> searchList = search.query(searchQuery);
            system.debug('%%%%%'+searchList);
        for(Object o : searchList[0]){
            BOATBUILDING__Part__c objPrt = (BOATBUILDING__Part__c)o;
            PartSearchResult objPSR = new PartSearchResult();
            objPSR.partId = objPrt.Id; 
            objPSR.partName =   objPrt.Name;
            objPSR.partNumber = objPrt.BOATBUILDING__Part_Number__c;
            objPSR.partCost = objPrt.BOATBUILDING__Part_Cost__c;
            lstPartSearchResult.add(objPSR);
        }
        return JSON.serialize(lstPartSearchResult);
    }

    @AuraEnabled
    public static String updatePOwithLineItems(String strPOId, String strLineItems) {
        try {
            System.debug('#@#@#@#@ '+JSON.deserializeUntyped(strLineItems));
            
            
            BOATBUILDING__Order__c objOrder = [SELECT Id, (Select Id, BOATBUILDING__Quantity__c From BOATBUILDING__Purchase_Order_Line_Items__r) FROM BOATBUILDING__Order__c WHERE Id =: strPOId LIMIT 1];
            List<Object> lstObj = (List<Object>)JSON.deserializeUntyped(strLineItems);
            Map<String, Integer> mapPartNum = new Map<String, Integer>();
            Map<String, String> mapPartIdNum = new Map<String, String>();
            for(Object obj: lstObj) {
                Map<String, Object> mapObj = (Map<String, Object>)obj;
                if(mapPartNum.containsKey(String.valueOf(mapObj.get('PartNumber')))) {
                    mapPartNum.put(String.valueOf(mapObj.get('PartNumber')), Integer.valueOf(mapObj.get('Quantity')) + mapPartNum.get(String.valueOf(mapObj.get('PartNumber'))));
                } 
                if(!mapPartNum.containsKey(String.valueOf(mapObj.get('PartNumber')))) {
                    mapPartNum.put(String.valueOf(mapObj.get('PartNumber')),  Integer.valueOf(mapObj.get('Quantity')));
                }
                if(String.isNotBlank(String.valueOf(mapObj.get('PartId')))) {
                    mapPartIdNum.put(String.valueOf(mapObj.get('PartId')), String.valueOf(mapObj.get('PartNumber')));
                }
            }
            System.debug('>>>>mapPartIdNum: '+mapPartIdNum);
            
            if(!objOrder.BOATBUILDING__Purchase_Order_Line_Items__r.isEmpty()) {
                List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLIDLT = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
                for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI: objOrder.BOATBUILDING__Purchase_Order_Line_Items__r) {
                    if(!mapPartIdNum.containsKey(objPOLI.Id)) {
                        lstPOLIDLT.add(objPOLI);
                    }
                }
                if(!lstPOLIDLT.isEmpty()) {
                    delete lstPOLIDLT;
                }
            }

            List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
            List<BOATBUILDING__Part__c> lstPart = [Select 
                                                            Bin__c, Vendor_Name__c,  Retail_Price__c,  Part_Number__c,  Name,  Id, Dealer_Price__c, Part_Cost__c, Category1__c, 
                                                            Discount__c, Family1__c, Location__c, Map_Price__c, Minimum_Amount__c, Part_Color__c, Part_Size__c, Taxable__c, Weight__c
                                                    From 
                                                            BOATBUILDING__Part__c 
                                                    WHERE 
                                                            Part_Number__c 
                                                    IN
                                                            :mapPartNum.keySet()]; 

            objOrder.PO_Date__c = Date.today();
            Decimal amntOnOrder = 0.00;
            for(BOATBUILDING__Part__c objPrt : lstPart) {
                for(Object obj: lstObj) {
                    BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
                    Map<String, Object> mapObj = (Map<String, Object>)obj;
                    if(String.valueOf(mapObj.get('PartNumber')) == objPrt.Part_Number__c) {
                        if(String.isNotBlank(String.valueOf(mapObj.get('PartId')))) {
                            objPOLI.Id = String.valueOf(mapObj.get('PartId'));
                        } else {
                            objPOLI.Purchase_Order__c = objOrder.Id;
                        }
                        objPOLI.Name = objPrt.Name;
                        objPOLI.Retail_Price__c = objPrt.Retail_Price__c;
                        objPOLI.Dealer_Price__c = objPrt.Dealer_Price__c;
                        objPOLI.Part_Number__c = objPrt.Part_Number__c;
                        objPOLI.Vendor_Name__c = objPrt.Vendor_Name__c;
                        objPOLI.Cost__c = objPrt.Part_Cost__c;
                        objPOLI.Quantity__c = Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c));
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
                            amntOnOrder += Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c)) * objPrt.Part_Cost__c;
                        }
                        lstPOLI.add(objPOLI);   
                    }
                }
            }
            upsert lstPOLI;
            objOrder.Amount_On_Order__c = amntOnOrder;
            update objOrder;            
            return 'SUCCESS';
        } catch(Exception ex) {
           return 'Error: '+ex.getLineNumber()+' : '+ex.getStackTraceString()+' : '+ex.getMessage();
        }
    }

    @AuraEnabled
    public static string getPORecordTypeId(){
        String poRecTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId(); 
        return poRecTypeId;
    }
    @AuraEnabled
    public static String generateOrderApex(String strRecId) {
        try { 
            BOATBUILDING__Order__c objPurchaseOrder = [SELECT Vendor_Name__c, Total_Amount__c, PO_Date__c, Name, Id, Amount_On_Order__c, 
                                                            (SELECT Id, Vendor_Name__c, Quantity__c, Cost__c, Retail_Price__c, Dealer_Price__c, Part_Number__c,
                                                            Purchase_Order__c, Name, Bin__c, Category__c, Color__c, Discount__c, Family__c,
                                                            Location__c, Map_Price__c, Minimum_Amount__c, Size__c, Taxable__c, Weight__c 
                                                            From BOATBUILDING__Purchase_Order_Line_Items__r) FROM BOATBUILDING__Order__c WHERE Id =: strRecId LIMIT 1];
            List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPurchaseOrderLineItems = objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r;                   
            System.debug('Order Generation.');
            Boolean isError = false;
            BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
            List<BOATBUILDING__Line_Items__c> lstOrderLineItem = new List<BOATBUILDING__Line_Items__c>();
            objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId(); 
            if(objPurchaseOrder.Vendor_Name__c != null) {
                objOrder.Vendor_Name__c = objPurchaseOrder.Vendor_Name__c;
            }
            objOrder.PO_Date__c = System.today();
            System.debug('Debug Log for objOrder'+objOrder);
            insert objOrder;
            
            Decimal quantityBaseTotal = 0.00;
            for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : lstPurchaseOrderLineItems) {
                BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
                if(objPOLI.Part_Number__c!=null && objPOLI.Part_Number__c!='') {
                    objLI.Part_Number_del__c = objPOLI.Part_Number__c;                      
                }
                if(objPOLI.Weight__c!=null && objPOLI.Weight__c!='') {
                    objLI.Weight__c = objPOLI.Weight__c;                      
                }
                if(objPOLI.Name!=null && objPOLI.Name!='') {
                    objLI.Name__c = objPOLI.Name;
                }
                if(objPOLI.Retail_Price__c!=null) {
                    objLI.Retail_Price__c = objPOLI.Retail_Price__c;
                }
                else {
                    objLI.Retail_Price__c = 0.00;
                }
                if(objPOLI.Dealer_Price__c!=null) {
                    objLI.Dealer_Price__c = objPOLI.Dealer_Price__c;
                }
                else {
                    objLI.Dealer_Price__c = 0.00;
                }
                if(objPOLI.Cost__c!=null) {
                    objLI.Cost__c = objPOLI.Cost__c;
                }
                else {
                    objLI.Cost__c = 0.00;
                }
                if(objPOLI.Quantity__c!=null) {
                    objLI.Quantity__c = objPOLI.Quantity__c;
                }
                objLI.Order__c = objOrder.Id;
                objLI.Bin__c = objPOLI.Bin__c;
                objLI.Category__c = objPOLI.Category__c;
                objLI.Color__c = objPOLI.Color__c;
                objLI.Discount__c = objPOLI.Discount__c;
                objLI.Family__c = objPOLI.Family__c;
                objLI.Location__c = objPOLI.Location__c;
                objLI.Map_Price__c = objPOLI.Map_Price__c;
                objLI.Minimum_Amount__c = objPOLI.Minimum_Amount__c;
                objLI.Size__c = objPOLI.Size__c;
                if(objPOLI.Vendor_Name__c != null) {
                    objLI.Vendor_Name__c = objPOLI.Vendor_Name__c;
                }
                objLI.Taxable__c = objPOLI.Taxable__c;
                quantityBaseTotal += objLI.Cost__c * objLI.Quantity__c ;
                lstOrderLineItem.add(objLI);
                
            }
            
            insert lstOrderLineItem;
            objOrder.Amount_On_Order__c = quantityBaseTotal;
            update objOrder;
            delete objPurchaseOrder;
            
            return objOrder.Id;
        }
        catch(Exception ex) {
    		System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
    	}
    }

    public class PartSearchResult{

       @AuraEnabled
       public String partId{get; set;} 
       @AuraEnabled
       public String partName{get; set;}
       @AuraEnabled
       public String partNumber{get; set;}
       @AuraEnabled
       public Decimal partCost{get; set;}
       
    }
}