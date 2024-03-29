public class InvoiceHandlerClass{
    
    public Static string QBAccountID;
    //public Static String accID;
    
    public Static void onBeforeInsert(List<Invoice__c> lstInvoice){
        //write code here for onBeforeInsert
        //updateAccountOnInvoice(lstInvoice);
        genrateInvoiceName(lstInvoice);
        
    }
    public Static void onBeforeUpdate(List<Invoice__c> lstInvoice){
        //write code here for onBeforeInsert
        //updateAccountOnInvoice(lstInvoice);
        genrateInvoiceNameOnUpdate(lstInvoice);
        
    }
    public Static void onAfterInsert(List<BOATBUILDING__Invoice__c > lstInvoice){
        //createQBInvoice(lstInvoice);
        updateSoldByDetailsOnInventoryIns(lstInvoice); 
    }
    public Static void onAfterUpdate(List<BOATBUILDING__Invoice__c > lstInvoice , map<id,Invoice__c> oldMapInv){
        System.debug('====afterUpdate===');
        
        createQBInvoice(lstInvoice, oldMapInv);
        NewQBConnectTest.FetchQBInvoice(); //Added by Pradeep 19aug17 
        updateSoldByDetailsOnInventory(lstInvoice, oldMapInv);
        try {
            updateInventoryQuantity(lstInvoice, oldMapInv);
        } catch(Exception ex) {
            System.debug('onAfterUpdate: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Invenentory Management From Invoice';
                String customLog = 'onAfterUpdate : \n\n' + ex.getMessage() + ' \n\n ' + ex.getLineNumber()+'\n\n'+ex.getStackTraceString(); 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog; 
                } 
                insert objCL;
            }
        }
    }

    public static void onBeforeDelete(Map<Id, BOATBUILDING__Invoice__c> oldMapInvoice) {
        System.debug('onBeforeDelete: '+oldMapInvoice.keySet());
        deleteAllLineItems(oldMapInvoice.keySet());
    }
    public static void deleteAllLineItems(Set<Id> setInvId) {
        List<BOATBUILDING__Invoice_Line_Item__c> lstILI = [ SELECT Id, BOATBUILDING__Quantity__c, BOATBUILDING__Inventory__c, BOATBUILDING__Store_Location__c
                                                                 FROM BOATBUILDING__Invoice_Line_Item__c WHERE BOATBUILDING__Related_To_Invoice__c IN :setInvId 
                                                                    AND BOATBUILDING__Related_To_Invoice__r.BOATBUILDING__Invoice_Status__c != 'Quote'];

        System.debug('deleteAllLineItems: '+lstILI);
        if(!lstILI.isEmpty()) {
            InvoiceLineItemHandler.updateInventoryQuantity(lstILI, null);
        }
    }
    public static void updateInventoryQuantity(List<BOATBUILDING__Invoice__c > lstInvoice , map<id,Invoice__c> oldMapInv) {
        Map<String, Boolean> mapDeduct = new Map<String, Boolean>();
        Map<Id, String> mapNewStoreLocation = new Map<Id, String>();
        Map<Id, String> mapOldStoreLocation = new Map<Id, String>();
        for(BOATBUILDING__Invoice__c objInv : lstInvoice) {
            if(objInv.BOATBUILDING__Store_Location__c != oldMapInv.get(objInv.Id).BOATBUILDING__Store_Location__c && objInv.BOATBUILDING__Invoice_Status__c != 'Quote') {
                mapNewStoreLocation.put(objInv.Id, objInv.BOATBUILDING__Store_Location__c);
                mapOldStoreLocation.put(objInv.Id, oldMapInv.get(objInv.Id).BOATBUILDING__Store_Location__c);
            }
            if(objInv.BOATBUILDING__Invoice_Status__c != null && objInv.BOATBUILDING__Invoice_Status__c != 'Quote' &&
                (oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c == null || oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c != null 
                    && oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c == 'Quote') ) {
                    mapDeduct.put(objInv.Id, true);
            } else if(objInv.BOATBUILDING__Invoice_Status__c != null && objInv.BOATBUILDING__Invoice_Status__c == 'Quote' &&
                (oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c == null || 
                    oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c != null && oldMapInv.get(objInv.Id).BOATBUILDING__Invoice_Status__c != 'Quote' )) {
                    mapDeduct.put(objInv.Id, false);
                }
        }
        if(!mapDeduct.isEmpty()) {
            List<BOATBUILDING__Invoice_Line_Item__c> lstInvLineItem = [SELECT Id, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Related_To_Invoice__c 
                                                                    FROM BOATBUILDING__Invoice_Line_Item__c WHERE BOATBUILDING__Related_To_Invoice__c IN :mapDeduct.keySet()];
            Map<String, Decimal> mapILIQuantity = new Map<String, Decimal>();
            Map<String, String> mapStoreLocation = new Map<String, String>();
            for(BOATBUILDING__Invoice_Line_Item__c objILI : lstInvLineItem) {
                Decimal decQuantity = mapILIQuantity.get(objILI.BOATBUILDING__Part_Number__c);
                if(decQuantity == null) {
                    decQuantity = 0;
                }
                if(mapDeduct.get(objILI.BOATBUILDING__Related_To_Invoice__c)) {
                    decQuantity += objILI.BOATBUILDING__Quantity__c;
                } else {
                    decQuantity += 0 - objILI.BOATBUILDING__Quantity__c;
                }
                mapILIQuantity.put(objILI.BOATBUILDING__Part_Number__c, decQuantity);
                if(!mapStoreLocation.containsKey(objILI.BOATBUILDING__Part_Number__c)) {
                        mapStoreLocation.put(objILI.BOATBUILDING__Part_Number__c, objILI.BOATBUILDING__Store_Location__c);
                }
            }
            List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                            FROM BOATBUILDING__Inventory__c 
                                                            WHERE BOATBUILDING__Part_Number__c IN: mapILIQuantity.keySet()];
            
            List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
            for(BOATBUILDING__Inventory__c objInv : listInvToQuery) {
                PartInventoryManagerController.PartInventoryWrapper objPW = new PartInventoryManagerController.PartInventoryWrapper();
                objPW.inventoryId = objInv.Id;
                objPW.quantity = mapILIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                objPW.storeLocation = mapStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                listWrapToProcess.add(objPW);
            }
            PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
        }
        if(!mapNewStoreLocation.isEmpty()) {
            List<BOATBUILDING__Invoice_Line_Item__c> lstInvLineItem = [SELECT Id, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c, BOATBUILDING__Related_To_Invoice__c 
                                                                        FROM BOATBUILDING__Invoice_Line_Item__c WHERE BOATBUILDING__Related_To_Invoice__c IN :mapNewStoreLocation.keySet()];
            
            Map<String, Decimal> mapILIQuantity = new Map<String, Decimal>();
            Map<String, String> mapILINewStoreLocation = new Map<String, String>();
            Map<String, String> mapILIOldStoreLocation = new Map<String, String>();
            for(BOATBUILDING__Invoice_Line_Item__c objILI : lstInvLineItem) {
                mapILIQuantity.put(objILI.BOATBUILDING__Part_Number__c, objILI.BOATBUILDING__Quantity__c);
                mapILINewStoreLocation.put(objILI.BOATBUILDING__Part_Number__c, mapNewStoreLocation.get(objILI.BOATBUILDING__Related_To_Invoice__c));
                mapILIOldStoreLocation.put(objILI.BOATBUILDING__Part_Number__c, mapOldStoreLocation.get(objILI.BOATBUILDING__Related_To_Invoice__c));
            }
            List<BOATBUILDING__Inventory__c> listInvToQuery = [SELECT Id, BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c 
                                                                FROM BOATBUILDING__Inventory__c 
                                                                WHERE BOATBUILDING__Part_Number__c IN: mapILIQuantity.keySet()];
            List<PartInventoryManagerController.PartInventoryWrapper> listWrapToProcess = new List<PartInventoryManagerController.PartInventoryWrapper>();
            for(BOATBUILDING__Inventory__c objInv : listInvToQuery) {
                PartInventoryManagerController.PartInventoryWrapper objPWNew = new PartInventoryManagerController.PartInventoryWrapper();
                objPWNew.inventoryId = objInv.Id;
                objPWNew.quantity = mapILIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                objPWNew.storeLocation = mapILINewStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                listWrapToProcess.add(objPWNew);

                PartInventoryManagerController.PartInventoryWrapper objPWOld = new PartInventoryManagerController.PartInventoryWrapper();
                objPWOld.inventoryId = objInv.Id;
                objPWOld.quantity = 0 - mapILIQuantity.get(objInv.BOATBUILDING__Part_Number__c);
                objPWOld.storeLocation = mapILIOldStoreLocation.get(objInv.BOATBUILDING__Part_Number__c);
                listWrapToProcess.add(objPWOld);
            }
            PartInventoryManagerController.updateInventoryQuantity(listWrapToProcess);
        }
    }   

    public Static Void updateAccountOnInvoice(list<BOATBUILDING__Invoice__c> lstInvoice){
        
        Set<Id> setContactIds = new Set<Id>();
        for(BOATBUILDING__Invoice__c objBBinv : lstInvoice)
        {
            setContactIds.add(objBBinv.BOATBUILDING__Related_to_Contact__c);
        }
        Map<id, id> mapContactToAccount = new Map<Id, Id>();
        for(Contact objCon : [SELECT AccountId from Contact where ID IN : setContactIds])
        {
            mapContactToAccount.put(objCon.Id, objCon.AccountId); 
        }
        for(BOATBUILDING__Invoice__c objBBinv : lstInvoice){
            objBBinv.BOATBUILDING__Account_Name__c = mapContactToAccount.get(objBBinv.BOATBUILDING__Related_to_Contact__c);
        }
    }
    
    public Static void createQBInvoice(list<Invoice__c> lstInv, map<id,Invoice__c> oldMapInv){
        String payload;
        String PayloadJaournalEntry;
        System.debug('===lstInv===' +lstInv[0].BOATBUILDING__Related_to_Contact__c);
        Set<Id> conID = new Set<Id>();
        for(Invoice__c inv : lstInv){
            conID.add(inv.BOATBUILDING__Related_to_Contact__c);
        }
        System.debug('===conID==='+conID);
        Map<id,Contact> mapCon = new Map<id,Contact>([Select id,QBCustomerID__c from Contact where id IN: conID]);
        System.debug('===mapAcc===='+mapCon);
        
        for(Invoice__c inv: lstInv){
            //System.debug('==inv.Account_Name__r.QBCustomerID__c===' +mapAcc.get(inv.Account_Name__c).QBCustomerID__c);
            if(inv.BOATBUILDING__SendInvoiceToQB__c && !oldMapInv.get(inv.id).BOATBUILDING__SendInvoiceToQB__c){
                System.debug('Enter if send to QB');
                payload = generateInvoiceJson(inv, mapCon.get(inv.BOATBUILDING__Related_to_Contact__c).QBCustomerID__c);
                NewQBConnectTest.CreateQBInvoice(payload, inv.id);
                
                PayloadJaournalEntry = generateJournalEntryJson(inv, mapCon.get(inv.BOATBUILDING__Related_to_Contact__c).QBCustomerID__c);
                NewQBConnectTest.createQBJournalEntry(PayloadJaournalEntry, inv.id);
            }
        }
        System.debug('====payload===='+payload);
        System.debug('====createQBJournalEntry===='+PayloadJaournalEntry);
    }
    
    //This Method is used to create a JSON for Invoice
    public Static String generateInvoiceJson(BOATBUILDING__Invoice__c inv, String QBId){
        
        Map<String, BOATBUILDING__QBProductServiceConfig__c> mapQBProductServiceCS = BOATBUILDING__QBProductServiceConfig__c.getAll();
        list<BOATBUILDING__Invoice_Line_Item__c> lstInvLineItm = [Select Name, BOATBUILDING__Grand_Total__c ,BOATBUILDING__Description__c, BOATBUILDING__Quantity__c, BOATBUILDING__Part_Cost__c from BOATBUILDING__Invoice_Line_Item__c where Related_To_Invoice__c =: inv.id];
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeFieldName('Line');
        gen.writeStartArray();
        //for Boat sales tax
        gen.writeStartObject();
        gen.writeNumberField('Amount',inv.BOATBUILDING__Sales_Tax_Formula__c!=null? inv.BOATBUILDING__Sales_Tax_Formula__c : 0.00);
        gen.writeStringField('Description','Boat Sales Tax');
        gen.writeStringField('DetailType','SalesItemLineDetail');
        gen.writeFieldName('SalesItemLineDetail');
        gen.writeStartObject();
        gen.writeFieldName('ItemRef');
        gen.writeStartObject();
        gen.writeStringField('value',mapQBProductServiceCS.get('Boat Sales Tax').BOATBUILDING__QBID__c);
        gen.writeStringField('name','Services');
        gen.writeEndObject();
        gen.writeNumberField('UnitPrice', inv.BOATBUILDING__Sales_Tax_Formula__c!=null ? inv.BOATBUILDING__Sales_Tax_Formula__c : 0.00);
        gen.writeNumberField('Qty',1);
        /****Code updated on 17th July 2017****/
        gen.writeFieldName('TaxCodeRef');
        gen.writeStartObject();
        gen.writeStringField('value','TAX');
        gen.writeEndObject();
        /****Code updated on 17th July 2017****/
        gen.writeEndObject();
        gen.writeEndObject();
        //for Shipping Charge
        gen.writeStartObject();
        gen.writeNumberField('Amount',inv.BOATBUILDING__Shipping_Charge__c!=null? inv.BOATBUILDING__Shipping_Charge__c : 0.00);
        gen.writeStringField('Description','Shipping Charge');
        gen.writeStringField('DetailType','SalesItemLineDetail');
        gen.writeFieldName('SalesItemLineDetail');
        gen.writeStartObject();
        gen.writeFieldName('ItemRef');
        gen.writeStartObject();
        gen.writeStringField('value',mapQBProductServiceCS.get('Shipping Charge').BOATBUILDING__QBID__c);
        gen.writeStringField('name','Services');
        gen.writeEndObject();
        gen.writeNumberField('UnitPrice', inv.BOATBUILDING__Shipping_Charge__c!=null? inv.BOATBUILDING__Shipping_Charge__c: 0.00 );
        gen.writeNumberField('Qty',1);
        gen.writeEndObject();
        gen.writeEndObject();
        
        //for Sales Tax
        /* gen.writeStartObject();
gen.writeNumberField('Amount',inv.BOATBUILDING__Sales_Tax_Formula__c!=null? inv.BOATBUILDING__Sales_Tax_Formula__c: 0.00);
gen.writeStringField('Description','Sales Tax');
gen.writeStringField('DetailType','SalesItemLineDetail');
gen.writeFieldName('SalesItemLineDetail');
gen.writeStartObject();
gen.writeFieldName('ItemRef');
gen.writeStartObject();
gen.writeStringField('value',mapQBProductServiceCS.get('Shipping Charge').BOATBUILDING__QBID__c);
gen.writeStringField('name','Services');
gen.writeEndObject();
gen.writeNumberField('UnitPrice', inv.BOATBUILDING__Sales_Tax_Formula__c!=null ? inv.BOATBUILDING__Sales_Tax_Formula__c: 0.00);
gen.writeNumberField('Qty',1);
gen.writeEndObject();
gen.writeEndObject();*/
        //For parts
        for(BOATBUILDING__Invoice_Line_Item__c lnItm : lstInvLineItm){
            gen.writeStartObject();
            gen.writeNumberField('Amount',lnItm.BOATBUILDING__Part_Cost__c*lnItm.BOATBUILDING__Quantity__c);
            gen.writeStringField('Description',lnItm.BOATBUILDING__Description__c == null?'': lnItm.BOATBUILDING__Description__c);
            gen.writeStringField('DetailType','SalesItemLineDetail');
            gen.writeFieldName('SalesItemLineDetail');
            gen.writeStartObject();
            gen.writeFieldName('ItemRef');
            gen.writeStartObject();
            gen.writeStringField('value',mapQBProductServiceCS.get('Parts').BOATBUILDING__QBID__c);
            gen.writeStringField('name','Services');
            gen.writeEndObject();
            gen.writeNumberField('UnitPrice', lnItm.BOATBUILDING__Part_Cost__c!=null? lnItm.BOATBUILDING__Part_Cost__c:0.00);
            gen.writeNumberField('Qty',lnItm.BOATBUILDING__Quantity__c!=null? lnItm.BOATBUILDING__Quantity__c : 0);
            /****Code updated on 17th July 2017****/
            gen.writeFieldName('TaxCodeRef');
            gen.writeStartObject();
            gen.writeStringField('value','TAX');
            gen.writeEndObject();
            /****Code updated on 17th July 2017****/
            gen.writeEndObject();
            gen.writeEndObject();
        }
        /***Code Added*/
        gen.writeStartObject();
        gen.writeNumberField('Amount', inv.BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c!=null? inv.BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c: 0.00);
        gen.writeStringField('DetailType','DiscountLineDetail');
        gen.writeFieldName('DiscountLineDetail');
        gen.writeStartObject();
        //gen.writeBooleanField('PercentBased',False);
        //gen.writeNumberField('DiscountPercent', inv.BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c!=null? inv.BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c: 0.00 );
        gen.writeFieldName('DiscountAccountRef');
        gen.writeStartObject();
        gen.writeStringField('value','1');
        gen.writeStringField('name','Discounts given');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        /***Code Added*/
        gen.writeEndArray(); 
        gen.writeFieldName('CustomerRef');
        gen.writeStartObject();
        gen.writeStringField('value',QBId);
        gen.writeEndObject();
        //Code added sales tax  
        gen.writeFieldName('TxnTaxDetail');
        gen.writeStartObject();
        gen.writeFieldName('TxnTaxCodeRef');
        gen.writeStartObject();
        gen.writeNumberField('value', 7);
        gen.writeEndObject();
        gen.writeNumberField('TotalTax', inv.BOATBUILDING__Sales_Tax_Formula__c!=null? inv.BOATBUILDING__Sales_Tax_Formula__c:0.00);
        gen.writeEndObject();
        //Code added for sales tax
        gen.writeEndObject();
        
        String strjson= gen.getAsString(); 
        System.debug('==strjson==' +strjson);
        return strjson;
    }
    
    public Static String generateJournalEntryJson(BOATBUILDING__Invoice__c inv, String QBId){
        
        Map<String, BOATBUILDING__QBProductServiceConfig__c> mapQBProductServiceCS = BOATBUILDING__QBProductServiceConfig__c.getAll();
        list<BOATBUILDING__Invoice_Line_Item__c> lstInvLineItm = [Select Name, BOATBUILDING__Grand_Total__c ,BOATBUILDING__Description__c, BOATBUILDING__Quantity__c, BOATBUILDING__Part_Cost__c from BOATBUILDING__Invoice_Line_Item__c where Related_To_Invoice__c =: inv.id];
        JSONGenerator gen = JSON.createGenerator(true);
        
        gen.writeStartObject();
        gen.writeFieldName('Line');
        gen.writeStartArray();
        //Journal Entry for Debit
        gen.writeStartObject();
        gen.writeStringField('Description','Debit Description');
        gen.writeNumberField('Amount',inv.BOATBUILDING__Sales_Tax_Formula__c!=null? inv.BOATBUILDING__Sales_Tax_Formula__c : 0.00);
        gen.writeStringField('DetailType','JournalEntryLineDetail');
        gen.writeFieldName('JournalEntryLineDetail');
        gen.writeStartObject();
        gen.writeStringField('PostingType','Debit');
        gen.writeFieldName('AccountRef');
        gen.writeStartObject();
        gen.writeStringField('value','47');
        gen.writeStringField('name','Opening Bal Equit');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        //Journal Entry for Credit
        gen.writeStartObject();
        gen.writeStringField('Description','Credit Description');
        gen.writeNumberField('Amount',inv.BOATBUILDING__Sales_Tax_Formula__c!=null? inv.BOATBUILDING__Sales_Tax_Formula__c : 0.00);
        gen.writeStringField('DetailType','JournalEntryLineDetail');
        gen.writeFieldName('JournalEntryLineDetail');
        gen.writeStartObject();
        gen.writeStringField('PostingType','Credit');
        gen.writeFieldName('AccountRef');
        gen.writeStartObject();
        gen.writeStringField('value','47');
        gen.writeStringField('name','Opening Bal Equit');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndArray(); 
        gen.writeEndObject();
        
        String strjson= gen.getAsString(); 
        System.debug('==strjsonFor JournalEntry==' +strjson);
        return strjson;
    }
    
    
    public static void updateSoldByDetailsOnInventoryIns(list<Invoice__c> lstInv){
        
        List<BOATBUILDING__Inventory__c> listInventoryToUpdate = new List<BOATBUILDING__Inventory__c>();
        
        List<User> listUser = [SELECT Id, Name FROM User WHERE isActive = True];
        Map<String, User> mapNameToUser = new Map<String, User>();
        
        for(User u: listUser){
            mapNameToUser.put(u.Name, u);
        }
        
        for(Invoice__c i: lstInv){
            if(i.BOATBUILDING__Boat_Sold_By__c != null && i.BOATBUILDING__Inventory__c != null) {
                BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c(Id = i.BOATBUILDING__Inventory__c);
                if(i.BOATBUILDING__Boat_Sold_By__c != null && mapNameToUser.containsKey(i.BOATBUILDING__Boat_Sold_By__c)){
                    objInventory.BOATBUILDING__Sold_By__c = mapNameToUser.get(i.BOATBUILDING__Boat_Sold_By__c).Id;
                } 
                if(i.BOATBUILDING__Sold_Date__c != null)  
                    objInventory.BOATBUILDING__Sold_Date__c = i.BOATBUILDING__Sold_Date__c;
                listInventoryToUpdate.add(objInventory);
            }
        }
        
        if(!listInventoryToUpdate.isEmpty()){
            update listInventoryToUpdate;
        }
    }
    
    public static void updateSoldByDetailsOnInventory(list<Invoice__c> lstInv, map<id,Invoice__c> oldMapInv){
        
        List<BOATBUILDING__Inventory__c> listInventoryToUpdate = new List<BOATBUILDING__Inventory__c>();
        
        List<User> listUser = [SELECT Id, Name FROM User WHERE isActive = True];
        Map<String, User> mapNameToUser = new Map<String, User>();
        
        for(User u: listUser){
            mapNameToUser.put(u.Name, u);
        }
        
        for(Invoice__c i: lstInv){
            if(i.BOATBUILDING__Boat_Sold_By__c != null && oldMapInv.get(i.Id).BOATBUILDING__Boat_Sold_By__c != null && i.BOATBUILDING__Boat_Sold_By__c != oldMapInv.get(i.Id).BOATBUILDING__Boat_Sold_By__c && i.BOATBUILDING__Inventory__c != null){
                BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c(Id = i.BOATBUILDING__Inventory__c);
                if(i.BOATBUILDING__Boat_Sold_By__c != null && mapNameToUser.containsKey(i.BOATBUILDING__Boat_Sold_By__c)){
                    objInventory.BOATBUILDING__Sold_By__c = mapNameToUser.get(i.BOATBUILDING__Boat_Sold_By__c).Id;
                }
                if(i.BOATBUILDING__Sold_Date__c != null)  
                    objInventory.BOATBUILDING__Sold_Date__c = i.BOATBUILDING__Sold_Date__c;
                listInventoryToUpdate.add(objInventory);
            }
        }
        
        if(!listInventoryToUpdate.isEmpty()){
            update listInventoryToUpdate;
        }
    }
    
    public static void updateInvoiceName(List<Invoice__c> listNewInvoice){
        
        Set<String> setAccId = new Set<String>();
        for(Invoice__c inv: listNewInvoice){
            setAccId.add(inv.BOATBUILDING__Account_Name__c);
        }
        
        Map<Id, Account> mapAccountToProcess = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN: setAccId]);
        
        for(Invoice__c inv: listNewInvoice){
            if(mapAccountToProcess.containsKey(inv.BOATBUILDING__Account_Name__c)){
                inv.Name = 'Invoice For '+mapAccountToProcess.get(inv.BOATBUILDING__Account_Name__c).Name;
            }
        }               
    }
    
    public static void genrateInvoiceName(List<Invoice__c> listNewInvoice){
        
        set<Id> contactId = new set<Id>();
        for(Invoice__c objInv : listNewInvoice){
            if(objInv.BOATBUILDING__Related_to_Contact__c != null){
                contactId.add(objInv.BOATBUILDING__Related_to_Contact__c);
            }
        }
        List<BOATBUILDING__Invoice__c> lstInvoice = [Select Id, BOATBUILDING__Invoice_Number__c,BOATBUILDING__Invoice_Number_Formula__c From BOATBUILDING__Invoice__c Order By BOATBUILDING__Invoice_Number_Formula__c DESC LIMIT 1];
        Map<Id, Contact> mapOfContact = new Map<Id, Contact> ([SELECT Id, Name From Contact Where Id IN: contactId]);
        
        Integer count = 0;
        if(lstInvoice.size() > 0) {
            if(lstInvoice[0].BOATBUILDING__Invoice_Number_Formula__c  != null) {
                count = Integer.valueOf(lstInvoice[0].BOATBUILDING__Invoice_Number_Formula__c);
            } 
            else { 
                count = 1;
            }
        }
        else {
            count  = 1;
        }
        List<BOATBUILDING__Invoice__c > lstInv = new List<BOATBUILDING__Invoice__c >();
        Set<String> setInvNum = new Set<String>();
        for(BOATBUILDING__Invoice__c objInvoice: listNewInvoice) {
            setInvNum.add(objInvoice.BOATBUILDING__Invoice_Number__c);
        }
        for(BOATBUILDING__Invoice__c objInvoice: listNewInvoice) {
            count++;
            if(!setInvNum.contains('000'+count)) {
                if(objInvoice.BOATBUILDING__Related_to_Contact__c != null){
                    objInvoice.BOATBUILDING__Invoice_Number__c = '000'+count;
                    String invName = objInvoice.BOATBUILDING__Invoice_Number__c +'-'+mapOfContact.get(objInvoice.BOATBUILDING__Related_to_Contact__c).Name;
                    if(invName.length() < 80) {
                        objInvoice.Name = invName;
                    } else {
                        objInvoice.Name = invName.substring(0, 79);
                    }
                } else {
                    count++;
                    objInvoice.BOATBUILDING__Invoice_Number__c = '000'+count; 
                    if(mapOfContact.containsKey(objInvoice.BOATBUILDING__Related_to_Contact__c)){
                        String invName = objInvoice.BOATBUILDING__Invoice_Number__c +'-'+mapOfContact.get(objInvoice.BOATBUILDING__Related_to_Contact__c).Name;
                        if(invName.length() < 80) {
                            objInvoice.Name = invName;
                        } else {
                            objInvoice.Name = invName.substring(0, 79);
                        } 
                    }
                    
                }
            }
        }
    }
    public static void genrateInvoiceNameOnUpdate(List<Invoice__c> listNewInvoice){
        set<Id> contactId = new set<Id>();
        for(Invoice__c objInv : listNewInvoice){
            if(objInv.BOATBUILDING__Related_to_Contact__c != null){
                contactId.add(objInv.BOATBUILDING__Related_to_Contact__c);
            }
        }
        List<BOATBUILDING__Invoice__c> lstInvoice = [Select Id, BOATBUILDING__Invoice_Number__c,BOATBUILDING__Invoice_Number_Formula__c From BOATBUILDING__Invoice__c Order By BOATBUILDING__Invoice_Number_Formula__c DESC LIMIT 1];
        Map<Id, Contact> mapOfContact = new Map<Id, Contact> ([SELECT Id, Name From Contact Where Id IN: contactId]);
        
        Integer count = 0;
        if(lstInvoice.size() > 0) {
            if(lstInvoice[0].BOATBUILDING__Invoice_Number_Formula__c  != null) {
                count = Integer.valueOf(lstInvoice[0].BOATBUILDING__Invoice_Number_Formula__c);
            } 
            else { 
                count = 1;
            }
        }
        else {
            count  = 1;
        }
        List<BOATBUILDING__Invoice__c > lstInv = new List<BOATBUILDING__Invoice__c >();
        Set<String> setInvNum = new Set<String>();
        for(BOATBUILDING__Invoice__c objInvoice: listNewInvoice) {
            setInvNum.add(objInvoice.BOATBUILDING__Invoice_Number__c);
        }
        for(BOATBUILDING__Invoice__c objInvoice: listNewInvoice) {
            count++;
            if(!setInvNum.contains('000'+count)) {
                if(objInvoice.BOATBUILDING__Related_to_Contact__c != null){
                    // objInvoice.BOATBUILDING__Invoice_Number__c = '000'+count;
                    String invName = objInvoice.BOATBUILDING__Invoice_Number__c +'-'+mapOfContact.get(objInvoice.BOATBUILDING__Related_to_Contact__c).Name;
                    if(invName.length() < 80) {
                        objInvoice.Name = invName;
                    } else {
                        objInvoice.Name = invName.substring(0, 79);
                    }
                } else {
                    count++;
                    // objInvoice.BOATBUILDING__Invoice_Number__c = '000'+count; 
                    if(mapOfContact.containsKey(objInvoice.BOATBUILDING__Related_to_Contact__c)){
                        String invName = objInvoice.BOATBUILDING__Invoice_Number__c +'-'+mapOfContact.get(objInvoice.BOATBUILDING__Related_to_Contact__c).Name;
                        if(invName.length() < 80) {
                            objInvoice.Name = invName;
                        } else {
                            objInvoice.Name = invName.substring(0, 79);
                        } 
                    }
                    
                }
            }
        }
        
    }
}