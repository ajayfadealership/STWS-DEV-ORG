public class InvoiceLightningController {
    public class PartSearchResult{
        @AuraEnabled
        public String Id{get; set;}
        @AuraEnabled
        public String PartId{get; set;}
        
        @AuraEnabled
        public String PartName{get; set;}
        @AuraEnabled
        public String PartNumber{get; set;}
        @AuraEnabled
        public String partDescription{get; set;}
        @AuraEnabled
        public Boolean isInventoryPart{get; set;}
        @AuraEnabled
        public Decimal partMSRP{get; set;}
        @AuraEnabled
        public Boolean isInventoryLow{get; set;}
        @AuraEnabled
        public Decimal quantity{get; set;}
        @AuraEnabled
        public Decimal QuantityDec{get; set;}
        @AuraEnabled
        public Decimal Cost{get; set;}
        @AuraEnabled
        public String SortingOrder{get; set;}
        
    }
    @AuraEnabled 
    public static List<PurchaseOrderLineItemWrapper> getLineItems(String strPOId) { 
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        List<BOATBUILDING__Invoice_Line_Item__c> lstPOLI = [Select 
                                                            Id,BOATBUILDING__Dealer_Price__c, BOATBUILDING__Quantity__c,BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c, Name, BOATBUILDING__Part_Cost__c,BOATBUILDING__Discount_Price__c,BOATBUILDING__Discount_in_Percent__c
                                                            From 
                                                            BOATBUILDING__Invoice_Line_Item__c Where BOATBUILDING__Related_To_Invoice__c =: strPOId  ORDER BY BOATBUILDING__Sorting_sequence__c ASC];
        
        for(BOATBUILDING__Invoice_Line_Item__c objPOLI: lstPOLI) {
            PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
            objPOLIW.Id = objPOLI.Id;
            objPOLIW.PartId = objPOLI.BOATBUILDING__Part__c;
            objPOLIW.QuantityDec = objPOLI.BOATBUILDING__Quantity__c;
            objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
            objPOLIW.PartName = objPOLI.Name;
            objPOLIW.partMSRP = objPOLI.BOATBUILDING__Part_Cost__c != null ? objPOLI.BOATBUILDING__Part_Cost__c : 0.00;
            objPOLIW.Cost = objPOLI.BOATBUILDING__Dealer_Price__c != null ? objPOLI.BOATBUILDING__Dealer_Price__c: 0.0;
            objPOLIW.discount = objPOLI.BOATBUILDING__Discount_Price__c != null ? objPOLI.BOATBUILDING__Discount_Price__c: 0.0;
            objPOLIW.discountPer = objPOLI.BOATBUILDING__Discount_in_Percent__c != null ? objPOLI.BOATBUILDING__Discount_in_Percent__c: 0.0;
            objPOLIW.Total = (objPOLIW.partMSRP * objPOLIW.QuantityDec) -  objPOLIW.discount;
            objPOLIW.TotalWithoutDisc = objPOLIW.Cost * objPOLIW.QuantityDec;
            objPOLIW.showPill = true;
            objPOLIW.isDisabled = true;
            lstPOLIW.add(objPOLIW); 
        }
        return lstPOLIW;
        
    }
    @AuraEnabled
    public static String deleteInvoiceLineItem(String invoiceLineItemId){
        try{
            delete [Select Id from BOATBUILDING__Invoice_Line_Item__c where Id =: invoiceLineItemId ];
            return 'SUCCESS';
        }
        catch(Exception e){
            return 'FAILURE';
        }
        
    }
    @AuraEnabled
    public static String searchPartsfromInvoiceAndParts(String searchStr){
        return PurchaseOrderLightningController.searchPartsfromInventoryAndParts(searchStr, '');       
    }
    @AuraEnabled
    public static String getSalesTaxCustomSetting(){
        Map<String,BOATBUILDING__SalesTaxConfiguration__c> mapSalesTaxConfig = BOATBUILDING__SalesTaxConfiguration__c.getall();
        return  JSON.serialize(mapSalesTaxConfig); 
        
    }
    @AuraEnabled
    public static String searchPartsfromInventoryAndParts(String searchStr){
        //return PurchaseOrderLightningController.searchPartsfromInventoryAndParts(searchStr, '');
        List<PartSearchResult> lstPartSearchResult = new List<PartSearchResult>();
        String strName = searchStr;
        if(searchStr == 'recentlyViewed'){
            strName = '';
            List<RecentlyViewed> lstrv = [Select Id,Name from RecentlyViewed where Type = 'BOATBUILDING__Part__c'];
            
            for(RecentlyViewed rv : lstrv){
                
                strName = strName+'(\"' + String.escapeSingleQuotes(rv.Name) + '\")';
                strName =  strName + ' OR ';
                
                
            }
            
            strName  = strName+'(\"' + 'test1234dummyString' + '\")';
        }
        System.debug(strName);
        
        
        String searchQuery = 'FIND \'' + strName + '\' IN ALL FIELDS RETURNING BOATBUILDING__Part__c(Id,Name,BOATBUILDING__Part_Cost__c,BOATBUILDING__Quantity__c,BOATBUILDING__Retail_Price__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Vendor_Name__r.Name,BOATBUILDING__Discount__c where BOATBUILDING__Retail_Price__c != null)';
        
        List<List <sObject>> searchList = search.query(searchQuery);
        System.debug(searchList);
        Set<String> setPartNumber = new Set<String>();
        for(Object o : searchList[0]){
            BOATBUILDING__Part__c objInv = (BOATBUILDING__Part__c)o;
            if(!setPartNumber.contains(objInv.BOATBUILDING__Part_Number__c)){
                
                PartSearchResult objPSR = new PartSearchResult();
                objPSR.PartId = objInv.Id;
                objPSR.PartName =   objInv.Name;
                objPSR.PartNumber = objInv.BOATBUILDING__Part_Number__c;
                objPSR.isInventoryPart = false;
                //objPSR.partNumber = objInv.BOATBUILDING__Part_Number__c;
                
                objPSR.partMSRP = objInv.BOATBUILDING__Retail_Price__c;
                objPSR.Cost = objInv.BOATBUILDING__Part_Cost__c;
                if(objInv.BOATBUILDING__Quantity__c < 1){
                    objPSR.isInventoryLow = true;
                } 
                else{
                    objPSR.isInventoryLow = false;
                }
                objPSR.quantity = objInv.BOATBUILDING__Quantity__c != null ? objInv.BOATBUILDING__Quantity__c : 0;
                objPSR.QuantityDec = objInv.BOATBUILDING__Quantity__c != null ? objInv.BOATBUILDING__Quantity__c : 0;
                lstPartSearchResult.add(objPSR);
                setPartNumber.add(objInv.BOATBUILDING__Part_Number__c);
            }
        }
        
        return JSON.serialize(lstPartSearchResult);
        
    } 
    @AuraEnabled
    public static RecordType InvRecordTypeId(String RecordId){
        RecordType rec;
        System.debug('RecordId: '+RecordId);
        if(String.isNotBlank(RecordId)) {
            BOATBUILDING__Invoice__c objInv = [SELECT Id, RecordTypeId FROM BOATBUILDING__Invoice__c WHERE Id =: RecordId LIMIT 1];
            rec = [Select Id, Name From RecordType Where Id =: objInv.RecordTypeId];
        } else {
            rec = [Select Id, Name From RecordType Where Name = 'Standard Invoice' AND SObjectType = 'BOATBUILDING__Invoice__c'];
        }
        return rec;
    }
    @AuraEnabled
    public static Id AccountRecordTypeId(){
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        return RecordTypeId;
        
    }
    @AuraEnabled
    public static void UpdateAccount(Account objA , String InvId) {
        
        
    }
    @AuraEnabled
    public static String UpdateInvoicewithLineItems(String strInvId, String strLineItems , Account objA) {
         
        try{
            system.debug('strLineItems'+strLineItems);
            if(objA.Name != null && objA.Name != ''){
                insert objA;
                Contact objCon = [SELECT Id, Name, Phone, AccountId
                                  FROM Contact WHERE AccountId =: objA.Id];
                BOATBUILDING__Invoice__c objInv = [SELECT Id,BOATBUILDING__Account_Name__c, Related_to_Contact__c,
                                                   Related_to_Contact__r.AccountId FROM BOATBUILDING__Invoice__c 
                                                   WHERE Id =: strInvId LIMIT 1];
                if(String.isnotblank(objA.Id)){
                    objInv.BOATBUILDING__Account_Name__c = objA.Id;
                    objInv.Related_to_Contact__c = objCon.Id;
                    update objInv;
                }
            }
            
            system.debug('>>>>>objA'+objA);
            System.debug('CALL CHECK');
            System.debug('>>>>@#@#@#: '+JSON.serializePretty(JSON.deserializeUntyped(strLineItems)));
            BOATBUILDING__Invoice__c objInv = [SELECT Id, Related_to_Contact__c,BOATBUILDING__Account_Name__c, Related_to_Contact__r.AccountId, (Select Id, BOATBUILDING__Quantity__c From BOATBUILDING__Invoice_Line_Items__r) FROM BOATBUILDING__Invoice__c WHERE Id =: strInvId LIMIT 1];
            List<Contact> lstContact = [SELECT Id, Name, 
                                        Phone, AccountId, MailingStreet, MailingCity, 
                                        Email, MailingState, MailingPostalCode 
                                        FROM Contact 
                                        WHERE AccountId =: objInv.BOATBUILDING__Account_Name__c LIMIT 1];

            if(!lstContact.isEmpty()) { 
                objInv.Related_to_Contact__c = lstContact[0].Id;    
                objInv.Customer_Name__c = lstContact[0].Name;
                objInv.Phone_Number__c = lstContact[0].Phone;
                objInv.Customer_Address__c = lstContact[0].MailingStreet;    
                objInv.City__c = lstContact[0].MailingCity;
                objInv.Email__c = lstContact[0].Email;
                objInv.State__c = lstContact[0].MailingState;
                objInv.Zip_Code__c = lstContact[0].MailingPostalCode;
            }
            update objInv;
            List<Object> lstObj = (List<Object>)JSON.deserializeUntyped(strLineItems);
            List<BOATBUILDING__Invoice_Line_Item__c> lstInLi = new List<BOATBUILDING__Invoice_Line_Item__c> ();
            Set<String> setPNum = new Set<String>();
            for(Object o : lstObj){
                BOATBUILDING__Invoice_Line_Item__c objInLI = new BOATBUILDING__Invoice_Line_Item__c();
                Map<String, Object> dataNode = (Map<String, Object>)o;
                if(strInvId != null &&  strInvId != ''){
                    objInLI.BOATBUILDING__Related_To_Invoice__c = objInv.Id;
                }
                if(dataNode.containsKey('PartId') && String.isNotBlank(String.valueOf(dataNode.get('PartId')))){
                    objInLI.BOATBUILDING__Part__c = String.valueOf(dataNode.get('PartId'));
                }
                if(dataNode.containsKey('PartName')){
                    objInLI.Name = String.valueOf(dataNode.get('PartName'));
                }
                if(dataNode.containsKey('Id') && dataNode.get('Id') != null){
                    objInLI.Id = String.valueOf(dataNode.get('Id'));
                } 
                if(dataNode.containsKey('PartNumber')){
                    objInLI.BOATBUILDING__Part_Number__c = String.valueOf(dataNode.get('PartNumber'));
                    setPNum.add(String.valueOf(dataNode.get('PartNumber')));
                }
                if(dataNode.containsKey('QuantityDec') && dataNode.get('QuantityDec') != null){
                    objInLI.BOATBUILDING__Quantity__c = Decimal.valueOf(String.valueOf(dataNode.get('QuantityDec')));
                } 
                if(dataNode.containsKey('partMSRP') && String.isNotBlank(String.valueOf(dataNode.get('partMSRP')))){
                    objInLI.BOATBUILDING__Part_Cost__c = Decimal.valueOf(String.valueOf(dataNode.get('partMSRP')));
                }
                if(dataNode.containsKey('Cost') && String.isNotBlank(String.valueOf(dataNode.get('Cost')))){
                    objInLI.BOATBUILDING__Dealer_Price__c = Decimal.valueOf(String.valueOf(dataNode.get('Cost'))); 
                }
                if(dataNode.containsKey('discountPer') && String.isNotBlank(String.valueOf(dataNode.get('discountPer')))){
                    objInLI.BOATBUILDING__Discount_in_Percent__c = Decimal.valueOf(String.valueOf(dataNode.get('discountPer')));
                }
                if(dataNode.containsKey('discount') && String.isNotBlank(String.valueOf(dataNode.get('discount')))){
                    objInLI.BOATBUILDING__Discount_Price__c =  Decimal.valueOf(String.valueOf(dataNode.get('discount')));
                }
                if(dataNode.containsKey('SortingOrder') && String.isNotBlank(String.valueOf(dataNode.get('SortingOrder')))){
                    objInLI.BOATBUILDING__Sorting_sequence__c =  Integer.valueOf(String.valueOf(dataNode.get('SortingOrder')));
                }
                
                lstInLi.add(objInLI); 
            }
            List<Part__c> lstPart = [Select Id, BOATBUILDING__Category1__c, BOATBUILDING__Family1__c, Part_Number__c From Part__c Where Part_Number__c IN: setPNum];
            Map<String, Part__c> mapP = new Map<String, Part__c>();
            for(Part__c objp: lstPart) {
                mapP.put(objp.Part_Number__c, objp);
            }
            for(BOATBUILDING__Invoice_Line_Item__c objI: lstInLi) {
                if(mapP.containsKey(objI.BOATBUILDING__Part_Number__c)) {
                    objI.BOATBUILDING__Category__c = mapP.get(objI.BOATBUILDING__Part_Number__c).BOATBUILDING__Category1__c;
                    objI.BOATBUILDING__Family__c = mapP.get(objI.BOATBUILDING__Part_Number__c).BOATBUILDING__Family1__c;
                }
            }
            upsert lstInLi ;   
            return 'SUCCESS';
        }catch(Exception err) { 
            System.debug(err);
            String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
            return error;
        } 
    }
    
    @AuraEnabled
    public static String UpdateInvoicewithLineItemsWithSelectedAccount(String strInvId, String strLineItems ) {
        
        try{
            system.debug('strLineItemsstrLineItems'+strLineItems);
            System.debug('CALL CHECK');
            System.debug('>>>>@#@#@#: '+JSON.serializePretty(JSON.deserializeUntyped(strLineItems)));
            BOATBUILDING__Invoice__c objInv = [SELECT Id, Related_to_Contact__c,BOATBUILDING__Account_Name__c, Related_to_Contact__r.AccountId, (Select Id, BOATBUILDING__Quantity__c From BOATBUILDING__Invoice_Line_Items__r) FROM BOATBUILDING__Invoice__c WHERE Id =: strInvId LIMIT 1];
            List<Contact> lstContact = [SELECT Id, Name, 
                                        Phone, AccountId, MailingStreet, MailingCity, 
                                        Email, MailingState, MailingPostalCode 
                                        FROM Contact 
                                        WHERE AccountId =: objInv.BOATBUILDING__Account_Name__c LIMIT 1];
            
            if(!lstContact.isEmpty()) {  
                objInv.Related_to_Contact__c = lstContact[0].Id;  
                objInv.Customer_Name__c = lstContact[0].Name;
                objInv.Phone_Number__c = lstContact[0].Phone;
                objInv.Customer_Address__c = lstContact[0].MailingStreet;    
                objInv.City__c = lstContact[0].MailingCity;
                objInv.Email__c = lstContact[0].Email;
                objInv.State__c = lstContact[0].MailingState;
                objInv.Zip_Code__c = lstContact[0].MailingPostalCode;
            }
            update objInv;
            
            List<Object> lstObj = (List<Object>)JSON.deserializeUntyped(strLineItems);
            List<BOATBUILDING__Invoice_Line_Item__c> lstInLi = new List<BOATBUILDING__Invoice_Line_Item__c> ();
            Set<String> setPNum = new Set<String>();
            for(Object o : lstObj){
                BOATBUILDING__Invoice_Line_Item__c objInLI = new BOATBUILDING__Invoice_Line_Item__c();
                Map<String, Object> dataNode = (Map<String, Object>)o;
                if(strInvId != null &&  strInvId != ''){
                    objInLI.BOATBUILDING__Related_To_Invoice__c = objInv.Id;
                }
                if(dataNode.containsKey('PartId') && String.isNotBlank(String.valueOf(dataNode.get('PartId')))){
                    objInLI.BOATBUILDING__Part__c = String.valueOf(dataNode.get('PartId'));
                }
                if(dataNode.containsKey('PartName')){
                    objInLI.Name = String.valueOf(dataNode.get('PartName'));
                }
                if(dataNode.containsKey('Id') && dataNode.get('Id') != null){
                    objInLI.Id = String.valueOf(dataNode.get('Id'));
                } 
                if(dataNode.containsKey('PartNumber')){
                    objInLI.BOATBUILDING__Part_Number__c = String.valueOf(dataNode.get('PartNumber'));
                    setPNum.add(String.valueOf(dataNode.get('PartNumber')));
                }
                if(dataNode.containsKey('QuantityDec') && dataNode.get('QuantityDec') != null){
                    objInLI.BOATBUILDING__Quantity__c = Decimal.valueOf(String.valueOf(dataNode.get('QuantityDec')));
                } 
                if(dataNode.containsKey('partMSRP') && String.isNotBlank(String.valueOf(dataNode.get('partMSRP')))){
                    objInLI.BOATBUILDING__Part_Cost__c = Decimal.valueOf(String.valueOf(dataNode.get('partMSRP')));
                }
                if(dataNode.containsKey('Cost') && String.isNotBlank(String.valueOf(dataNode.get('Cost')))){
                    objInLI.BOATBUILDING__Dealer_Price__c = Decimal.valueOf(String.valueOf(dataNode.get('Cost'))); 
                }
                if(dataNode.containsKey('discountPer') && String.isNotBlank(String.valueOf(dataNode.get('discountPer')))){
                    objInLI.BOATBUILDING__Discount_in_Percent__c = Decimal.valueOf(String.valueOf(dataNode.get('discountPer')));
                }
                if(dataNode.containsKey('discount') && String.isNotBlank(String.valueOf(dataNode.get('discount')))){
                    objInLI.BOATBUILDING__Discount_Price__c =  Decimal.valueOf(String.valueOf(dataNode.get('discount')));
                }
                
                 if(dataNode.containsKey('SortingOrder') && String.isNotBlank(String.valueOf(dataNode.get('SortingOrder')))){
                    objInLI.BOATBUILDING__Sorting_sequence__c =  Integer.valueOf(String.valueOf(dataNode.get('SortingOrder')));
                }
                
                lstInLi.add(objInLI); 
            }
            List<Part__c> lstPart = [Select Id, BOATBUILDING__Category1__c, BOATBUILDING__Family1__c, Part_Number__c From Part__c Where Part_Number__c IN: setPNum];
            Map<String, Part__c> mapP = new Map<String, Part__c>();
            for(Part__c objp: lstPart) {
                mapP.put(objp.Part_Number__c, objp);
            }
            for(BOATBUILDING__Invoice_Line_Item__c objI: lstInLi) {
                if(mapP.containsKey(objI.BOATBUILDING__Part_Number__c)) {
                    objI.BOATBUILDING__Category__c = mapP.get(objI.BOATBUILDING__Part_Number__c).BOATBUILDING__Category1__c;
                    objI.BOATBUILDING__Family__c = mapP.get(objI.BOATBUILDING__Part_Number__c).BOATBUILDING__Family1__c;
                }
            }
            upsert lstInLi ;   
            return 'SUCCESS';
        }catch(Exception err) { 
            System.debug(err);
            String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
            return error;
        } 
    }
    
    @AuraEnabled
    public static Double getwebSalestax(String invId) {
        return [Select Id, Sales_Tax_Formula__c From Invoice__c Where Id =: invId].Sales_Tax_Formula__c;
    }
    
    @AuraEnabled
    public static Contact getAccountRelatedCon(String AccId) {
        if(String.isNotBlank(AccId)){
            Contact objContact = [SELECT Id ,Name from Contact Where AccountId =: AccId];
            return objContact;
        }else{
            return null;
        }
    }
    
    @AuraEnabled
    public static boolean isRefunded(String srtInvId){
        try {
            return [SELECT Id, BOATBUILDING__Refunded__c FROM BOATBUILDING__Invoice__c WHERE Id =: srtInvId Limit 1].BOATBUILDING__Refunded__c;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static List<BOATBUILDING__Payments__c> getAllPayment(String srtInvId){
        
        try {
            system.debug('OPPPPP'+srtInvId);
            List<BOATBUILDING__Payments__c> lstPayment = [SELECT Id,BOATBUILDING__Payment_Type__c ,Name ,BOATBUILDING__Amount__c FROM BOATBUILDING__Payments__c WHERE BOATBUILDING__Invoice__c =: srtInvId ];
            system.debug('lstPayment'+lstPayment);
            return lstPayment;
            
        } catch (Exception e) {
            return null;
        }
    }
  

    @AuraEnabled
    public static BOATBUILDING__Invoice__c getdiscount(String recId){
        try {
            BOATBUILDING__Invoice__c objINV = [SELECT Id,BOATBUILDING__Discount_on_Invoice__c FROM BOATBUILDING__Invoice__c WHERE Id =: recId];
            return objINV;
        } catch (Exception e) {
            return null;
        }
    }
}