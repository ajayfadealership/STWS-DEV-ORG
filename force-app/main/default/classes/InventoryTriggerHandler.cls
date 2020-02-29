public with sharing class InventoryTriggerHandler {
    
    public static void isBeforeInsert(List<BOATBUILDING__Inventory__c> lstNewInventory){
        updatePartLookupOnInventory(lstNewInventory);
    }
    
    public static void isBeforeUpdate(List<BOATBUILDING__Inventory__c> lstNewInventory, Map<Id, Inventory__c> mapOldInventory){
        if(lstNewInventory.isEmpty() && mapOldInventory.isEmpty()){
        createCustomerBoatValidation(lstNewInventory, mapOldInventory);
        }
    }
    
    public static void onAfterInsert(List<BOATBUILDING__Inventory__c> lstNewInventory) {
        if(runOnce()){
            createItemForInventory(lstNewInventory);
            shootMailForInvUpate(lstNewInventory);
            updateInventoryQuantityFromParts(lstNewInventory);
        }
    }
    
    public static void isAfterUpdate(List<BOATBUILDING__Inventory__c> lstNewInventory, Map<Id, BOATBUILDING__Inventory__c> mapNewInventory, Map<Id, BOATBUILDING__Inventory__c> mapOldInventory){
        if(runOnce()){
            sendBoatRiggingNotification(lstNewInventory,mapOldInventory);
            shootMailForInvUpateAU(mapNewInventory, mapOldInventory);
            updateInventoryQuantityFromParts(lstNewInventory);
        }
    }
    
    public static void createItemForInventory(List<BOATBUILDING__Inventory__c> lstNewInventory){
        List<BOATBUILDING__Item__c> lstItem = new List<BOATBUILDING__Item__c>(); 
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        Set<String> setInvHIN = new Set<String>(); 
        Map<String, BOATBUILDING__Inventory__c> mapInventory = new Map<String, BOATBUILDING__Inventory__c>();
        for(BOATBUILDING__Inventory__c objInventory: lstNewInventory) {
            if(String.isNotBlank(objInventory.HIN_Number__c) && objInventory.RecordTypeId != partInvRecordTypeId) {
                mapInventory.put(objInventory.HIN_Number__c, objInventory);
            }
        }
        Set<String> setBoatHINItem = new Set<String>();
        if(!mapInventory.keySet().isEmpty()) {
            for(BOATBUILDING__Item__c objItem: [Select Id, Boat_HIN_No__c From BOATBUILDING__Item__c Where Boat_HIN_No__c IN: mapInventory.keySet()]) {
                setBoatHINItem.add(objItem.Boat_HIN_No__c); 
            } 
            for(String strBoatHIN: mapInventory.keySet()) {
                if(!setBoatHINItem.contains(strBoatHIN)) {
                    BOATBUILDING__Item__c objItm = new BOATBUILDING__Item__c();
                    objItm.Name = 'Item For '+mapInventory.get(strBoatHIN).Name;
                    objItm.Boat_HIN_No__c = mapInventory.get(strBoatHIN).HIN_Number__c;
                    objItm.Engine_SN__c = mapInventory.get(strBoatHIN).Engine_SN__c;
                    objItm.Trailer_VIN__c = mapInventory.get(strBoatHIN).Trailer_VIN__c;
                    objItm.Transmission_Gearbox_Serial_Number__c = mapInventory.get(strBoatHIN).Transmission_Gearbox_SN__c;
                    objItm.Boat_Length_in_Feets__c = mapInventory.get(strBoatHIN).Boat_Length_in_feets__c;
                    objItm.Related_to_Inventory__c = mapInventory.get(strBoatHIN).Id; 
                    lstItem.add(objItm);
                }
            }
        }
        if(!lstItem.isEmpty()) {
            try { 
                insert lstItem;
            }
            catch(Exception ex) {
                System.debug('Debug Log for Exception: '+ex);
            }
        }
    }
    
    public static void updatePartLookupOnInventory(List<Inventory__c> listNewInventory) {
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        Set<String> setPrtNum = new Set<String>();
        
        for(Inventory__c objInv: listNewInventory) {
            //Defaulting Refresh Image checkbox to True on creation of Inventory. 
            if(objInv.RecordTypeId != partInvRecordTypeId){
                objInv.BOATBUILDING__Refresh_Images_on_Website__c = True;
            } else { // Update Part Lookup on Inventory from Part Number 
                if(objInv.Part_Number__c != null) {
                    setPrtNum.add(objInv.Part_Number__c);
                }
            }
        }
        
        List<Part__c> listPart = [Select Id, Part_Number__c From Part__c Where Part_Number__c IN: setPrtNum];
        
        if(!listPart.isEmpty()) {
            Map<String, String> mapPartNumberToId = new Map<String, String>();
            for(Part__c objPrt: listPart) {
                mapPartNumberToId.put(objPrt.Part_Number__c, objPrt.Id);
            }
            
            for(Inventory__c objInv: listNewInventory) { 
                if(objInv.RecordTypeId == partInvRecordTypeId && objInv.Part_Number__c != null && mapPartNumberToId.containsKey(objInv.Part_Number__c)) {
                    objInv.Part__c = mapPartNumberToId.get(objInv.Part_Number__c);
                }
            }
        }
    }
    
    public static void sendBoatRiggingNotification(List<BOATBUILDING__Inventory__c> lstNewInventory, Map<Id, BOATBUILDING__Inventory__c> mapOldInventory){
        
        List<User> listUser = [SELECT Id, Email, UserRole.DeveloperName, BOATBUILDING__Store_Location__c FROM User WHERE isActive = True];
        
        Set<String> setServiceEmail = new Set<String>();
        Set<String> setMarketingEmail = new Set<String>();
        Set<String> setInStockEmail = new Set<String>();
        
        Set<String> setServiceUserId = new Set<String>();
        Set<String> setMarketingUserId = new Set<String>();
        Set<String> setInStockUserId = new Set<String>();
        
        List<String> toAddress = new List<String>();
        Map<String, Set<String>> mapStoreLocationToUserEmails = new Map<String, Set<string>>();
        
        for(User u: listUser){
            if(u.UserRole.DeveloperName == 'Service_Manager' || u.UserRole.DeveloperName == 'Service_Writer'){
                setServiceEmail.add(u.Email);
                setServiceUserId.add(u.Id);
            } else if(u.UserRole.DeveloperName == 'Marketing_Manager'){
                setMarketingEmail.add(u.Email);
                setMarketingUserId.add(u.Id);
            } else if(u.UserRole.DeveloperName == 'Sales_Manager' || u.UserRole.DeveloperName == 'Salesperson'){
                if(mapStoreLocationToUserEmails.containsKey(u.BOATBUILDING__Store_Location__c)){
                    mapStoreLocationToUserEmails.get(u.BOATBUILDING__Store_Location__c).add(u.Email);
                }
                else{
                    mapStoreLocationToUserEmails.put(u.BOATBUILDING__Store_Location__c, new Set<String>{u.Email});
                }
                
                setInStockUserId.add(u.Id);
            }
        }
        
        //Get All Additional Emails from Custom Setting
        Map<String, BOATBUILDING__ExternalNotificationEmail__c> mapRolesToExternalEmail = BOATBUILDING__ExternalNotificationEmail__c.getAll();
        List<String> ccAddress = new List<String>();
        
        for(BOATBUILDING__Inventory__c inv: lstNewInventory){
            //Rigging
            if(inv.BOATBUILDING__Stage__c == 'Rigging' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'Rigging'){
                
                //Get Additional Service Writer Emails from Custom Setting
                String additionalServiceWritterEmail = '';
                if(mapRolesToExternalEmail.containsKey('Service Writer')){
                    additionalServiceWritterEmail = mapRolesToExternalEmail.get('Service Writer').BOATBUILDING__Email__c;
                }
                
                if(String.isNotBlank(additionalServiceWritterEmail)){
                    if(additionalServiceWritterEmail.containsIgnoreCase(',')){
                        toAddress.addAll(additionalServiceWritterEmail.split(','));
                    } else {
                        toAddress.add(additionalServiceWritterEmail);
                    }
                }
                
                //Get Additional Service Manager Emails from Custom Setting
                String additionalServiceManagerEmail = '';
                if(mapRolesToExternalEmail.containsKey('Service Manager')){
                    additionalServiceManagerEmail = mapRolesToExternalEmail.get('Service Manager').BOATBUILDING__Email__c;
                }
                
                if(String.isNotBlank(additionalServiceManagerEmail)){
                    if(additionalServiceManagerEmail.containsIgnoreCase(',')){
                        toAddress.addAll(additionalServiceManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalServiceManagerEmail);
                    }
                }
                
                toAddress.addAll(setServiceEmail);
                
                String inventorylink = System.URL.getSalesforceBaseUrl()+'/'+inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat needs to be rigged. <br/> <a target="_blank" href = "'+inventorylink+'">';
                htmlBody += inv.Name+'<a/> <br/>Kindly process accordingly';
                String subject = 'Boat needs to be rigged '+inv.Name;
                SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                createTask('Boat needs to be rigged', inv.Id, setServiceUserId);
            }
            
            //Marketing
            if(inv.BOATBUILDING__Stage__c == 'Marketing Photos' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'Marketing Photos'){
                
                //Get Additional Marketing Manager Emails from Custom Setting
                System.debug('Inventory Status Changed---------');
                String additionalMarketingManagerEmail = '';
                if(mapRolesToExternalEmail.containsKey('Marketing Manager')){
                    additionalMarketingManagerEmail = mapRolesToExternalEmail.get('Marketing Manager').BOATBUILDING__Email__c;
                }
                System.debug('Inventory .  emails'+additionalMarketingManagerEmail);
                if(String.isNotBlank(additionalMarketingManagerEmail)){
                    if(additionalMarketingManagerEmail.containsIgnoreCase(',')){
                        toAddress.addAll(additionalMarketingManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalMarketingManagerEmail);
                    }
                }
                
                toAddress.addAll(setMarketingEmail);
                
                String inventorylink = System.URL.getSalesforceBaseUrl()+'/'+inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat is ready for the Marketing. <br/> <a target="_blank" href = "'+inventorylink+'">';
                htmlBody += inv.Name+'<a/> <br/>Kindly process accordingly.';
                String subject = 'Boat ready for the Marketing '+inv.Name;
                SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                createTask('Boat ready for the Marketing', inv.Id, setMarketingUserId);
            }
            
            //In Stock
            if(inv.BOATBUILDING__Stage__c == 'In Stock' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'In Stock'){
                
                //Get Additional Sales Manager Emails from Custom Setting
                String additionalSalesManagerEmail = '';
                if(mapRolesToExternalEmail.containsKey('Sales Manager')){
                    additionalSalesManagerEmail = mapRolesToExternalEmail.get('Sales Manager').BOATBUILDING__Email__c;
                }
                
                
                if(String.isNotBlank(additionalSalesManagerEmail)){
                    if(additionalSalesManagerEmail.containsIgnoreCase(',')){
                        toAddress.addAll(additionalSalesManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalSalesManagerEmail);
                    }
                }
                
                //Get Additional Salesperson Emails from Custom Setting
                String additionalSalesPersonEmail = '';
                if(mapRolesToExternalEmail.containsKey('Salesperson')){
                    additionalSalesPersonEmail = mapRolesToExternalEmail.get('Salesperson').BOATBUILDING__Email__c;
                }
                
                if(String.isNotBlank(additionalSalesPersonEmail)){
                    if(additionalSalesPersonEmail.containsIgnoreCase(',')){
                        toAddress.addAll(additionalSalesPersonEmail.split(','));
                    } else {
                        toAddress.add(additionalSalesPersonEmail);
                    }
                }
                if(mapStoreLocationToUserEmails.containsKey(inv.BOATBUILDING__Store_Location__c)){
                    toAddress.addAll(mapStoreLocationToUserEmails.get(inv.BOATBUILDING__Store_Location__c));
                }
                
                String inventorylink = System.URL.getSalesforceBaseUrl()+'/'+inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat is ready to Sell. <br/> <a target="_blank" href = "'+inventorylink+'">';
                htmlBody += inv.Name+'<a/> <br/>Kindly process accordingly';
                String subject = 'Boat is ready to Sell '+inv.Name;
                SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                createTask('Boat is ready to Sell', inv.Id, setInStockUserId);
            }
        }
    }
    
    public static void createTask(String subject, Id parentId, Set<String> setOwnerIds){
        
        List<Task> listTask = new List<Task>();
        
        for(String uId: setOwnerIds){
            Task objTask = new Task();
            objTask.Subject = subject;
            objTask.WhatId = parentId;
            objTask.OwnerId = uId;
            listTask.add(objTask);
        }
        System.debug('listTask---'+listTask);
        if(!listTask.isEmpty()){
            insert listTask;
        }
    }
    
    public static void shootMailForInvUpate(List<Inventory__c> lstInv) {
        Set<String> setPartNum = new Set<String>();
        
        for(Inventory__c objInv: lstInv) {
            if(objInv.Quantity__c != null && objInv.Quantity__c > 0) {
                setPartNum.add(objInv.Part_Number__c);
            }
        }
        System.debug('setPartNum: '+setPartNum);
        if(!setPartNum.isEmpty()) {
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstLJI = [SELECT 
                                                                      BOATBUILDING__Related_to_Job__c, 
                                                                      BOATBUILDING__Part_Number__c,
                                                                      BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name,
                                                                      BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                                                                      CreatedById, CreatedBy.Email 
                                                                      FROM 
                                                                      BOATBUILDING__Work_Order_Job_Line_Item__c 
                                                                      WHERE 
                                                                      BOATBUILDING__Part_Number__c IN: setPartNum
                                                                      AND 
                                                                      BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c != 'Closed'];
            
            System.debug('lstLJI: '+lstLJI);
            if(!lstLJI.isEmpty()) {
                Map<String, Set<String>> mapOwnerWOName = new Map<String, Set<String>>();
                Map<String, Set<String>> mapOwnerPartNum = new Map<String, Set<String>>();
                Map<String, String> mapOwnerEmil = new Map<String, String>(); 
                for(BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstLJI) {
                    if(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                        if(!mapOwnerWOName.containsKey(objJLI.CreatedById)) {
                            mapOwnerWOName.put(objJLI.CreatedById, new Set<String>());
                            mapOwnerPartNum.put(objJLI.CreatedById, new Set<String>());
                            mapOwnerEmil.put(objJLI.CreatedById, objJLI.CreatedBy.Email);   
                        }
                        
                        if(mapOwnerWOName.containsKey(objJLI.CreatedById)) {
                            mapOwnerWOName.get(objJLI.CreatedById).add(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name);
                            mapOwnerPartNum.get(objJLI.CreatedById).add(objJLI.BOATBUILDING__Part_Number__c);
                        }
                    }
                }
                
                System.debug('mapOwnerWOName: '+mapOwnerWOName);
                System.debug('mapOwnerPartNum: '+mapOwnerPartNum);
                System.debug('mapOwnerEmil: '+mapOwnerEmil);
                
                for(String strKey: mapOwnerPartNum.keySet()) {
                    String strBody = 'Hi,<br/>Following parts are available in stock now:<br/>';
                    for(String prt: mapOwnerPartNum.get(strKey)) {
                        strBody += '* '+prt+'<br/>';
                    }
                    strBody += '<br/>Please process following work orders:<br/>';
                    for(String wo: mapOwnerWOName.get(strKey)) {
                        strBody += '* '+wo+'<br/>';
                    }
                    strBody += '<br/>Thanks.';
                    
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    string[] to = new string[] {mapOwnerEmil.get(strKey)};
                        email.setToAddresses(to);
                    email.setSubject('Part Update');
                    email.setHtmlBody(strBody);
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                }
            }
        } 
    }
    
    public static void shootMailForInvUpateAU(Map<Id, Inventory__c> newMapInv, Map<Id, Inventory__c> oldMapInv) {
        List<Inventory__c> lstInv = new List<Inventory__c>();
        for(Id ids: newMapInv.keySet()) {
            if(newMapInv.get(ids).Quantity__c != null) {
                if(oldMapInv.get(ids).Quantity__c <= 0 && newMapInv.get(ids).Quantity__c > 0) {
                    lstInv.add(newMapInv.get(ids));
                }
            }
        }
        if(!lstInv.isEmpty()) {
            shootMailForInvUpate(lstInv);
        }
    }
    
    public static void createCustomerBoatValidation(List<Inventory__c> lstNewInventory, Map<Id, Inventory__c> mapOldInventory){
        Set<String> setHin = new Set<String>();
        for(BOATBUILDING__Inventory__c objInv: lstNewInventory) {
          if(lstNewInventory.isEmpty() && mapOldInventory.isEmpty()){
            if(objInv.BOATBUILDING__HIN_Number__c != null) {
                setHin.add(objInv.BOATBUILDING__HIN_Number__c);
               }
            }
             if(lstNewInventory.isEmpty() && mapOldInventory.isEmpty()){
            if(objInv.BOATBUILDING__Display_On_Web__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Display_On_Web__c &&
               objInv.BOATBUILDING__Display_On_Web__c == 'Website'){
                   objInv.BOATBUILDING__Refresh_Images_on_Website__c = True;
               }
             }
        }
        Id recordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
        Id recordTypeUBId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Used Boats').getRecordTypeId();
        List<Item__c> lstItm = [Select Id, BOATBUILDING__Boat_HIN_No__c From Item__c Where BOATBUILDING__Boat_HIN_No__c IN: setHin];
        System.debug('debug log for: lstItm: '+lstItm);
        for(BOATBUILDING__Inventory__c objInv: lstNewInventory) {
            if(objInv.Stage__c == 'Sold' && objInv.RecordTypeId == recordTypeId) {
                if(!lstItm.isEmpty()) {
                    for(Item__c objIt: lstItm) {
                        if(!setHin.contains(objIt.BOATBUILDING__Boat_HIN_No__c)) {
                            objInv.addError('Please create customer boat first.');
                        }
                    }
                } else {
                    objInv.addError('Please create customer boat first.');
                }	
            }
            if((objInv.RecordTypeId == recordTypeId || objInv.RecordTypeId == recordTypeUBId) && (objInv.BOATBUILDING__Costline_Dollar__c != null && objInv.BOATBUILDING__Costline_Dollar__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline_Dollar__c)) {
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                System.debug('Debug log for BOATBUILDING__Total_Dealer_Price__c: '+objInv.BOATBUILDING__Total_Dealer_Price__c);
                Decimal MinSP = dc + objInv.BOATBUILDING__Costline_Dollar__c;
                Decimal costLine =  0.00;
                costLine = dc/MinSP;
                System.debug('Debug log for costLine: '+costLine);
                objInv.BOATBUILDING__Costline__c = 100 - (costLine *100);
                System.debug('Debug log for objInv.BOATBUILDING__Costline__c: '+objInv.BOATBUILDING__Costline__c);
            } else if((objInv.RecordTypeId == recordTypeId || objInv.RecordTypeId == recordTypeUBId) && (objInv.BOATBUILDING__Costline__c != null && objInv.BOATBUILDING__Costline__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline__c)) {
                
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;	
                Decimal costLine = (100 - objInv.BOATBUILDING__Costline__c)/100;
                Decimal MinSP = dc / costLine;
                objInv.BOATBUILDING__Costline_Dollar__c = MinSP - dc;
            }
        }
    }    
    
    public static void updateInventoryQuantityFromParts(List<Inventory__c> listNewInventory){
        Set<String> setPartId = new Set<String>();
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        for(Inventory__c objInv: listNewInventory) {
            if(objInv.Part__c != null && objInv.RecordTypeId == partInvRecordTypeId) {
                setPartId.add(objInv.Part__c);
            }
        }
        
        List<Part__c> lstPrt = [Select Id, BOATBUILDING__Quantity__c, (Select Id, BOATBUILDING__Quantity__c From BOATBUILDING__Inventory__r) From BOATBUILDING__Part__c Where Id IN: setPartId];
        
        if(!lstPrt.isEmpty()){
            for(Part__c objPart: lstPrt) {
                Decimal count = 0.00;
                if(!objPart.BOATBUILDING__Inventory__r.isEmpty()) {
                    for(Inventory__c obInv: objPart.BOATBUILDING__Inventory__r) {
                        if(obInv.Quantity__c != null) {
                            count += obInv.Quantity__c;
                        }
                    }
                }
                objPart.Quantity__c = count;
            }
            
            //Comment for Update quantity on part
            update lstPrt;
        }
    }
    
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}