public with sharing class InventoryTriggerHandler {

    public static void isBeforeInsert(List < BOATBUILDING__Inventory__c > lstNewInventory) {
        updatePartLookupOnInventory(lstNewInventory);
        updateInventoryPricingBasedOnMargin(lstNewInventory);
        SetQuantityDefaultValue(lstNewInventory);
    }

    public static void isBeforeUpdate(List < BOATBUILDING__Inventory__c > lstNewInventory, Map < Id, Inventory__c > mapOldInventory) {
        updateInventoryPricingBasedOnMargin(lstNewInventory);
        //createCustomerBoatValidation(lstNewInventory, mapOldInventory);

        /*if(lstNewInventory.isEmpty() && mapOldInventory.isEmpty()){
createCustomerBoatValidation(lstNewInventory, mapOldInventory);
}*/
        //00009783
        updateMarginCalculation(lstNewInventory, mapOldInventory);

    }

    public static void onAfterInsert(List < BOATBUILDING__Inventory__c > lstNewInventory) {
        if (runOnce()) {
            createItemForInventory(lstNewInventory);
            shootMailForInvUpate(lstNewInventory);
            updateInventoryQuantityFromParts(lstNewInventory, null);
        }
    }

    public static void isAfterUpdate(List < BOATBUILDING__Inventory__c > lstNewInventory, Map < Id, BOATBUILDING__Inventory__c > mapNewInventory, Map < Id, BOATBUILDING__Inventory__c > mapOldInventory) {
        if (runOnce()) {
            BOATBUILDING__System_Configure__c objConfig = BOATBUILDING__System_Configure__c.getOrgDefaults();
            if (objConfig.BOATBUILDING__DisableInventoryBoatNotifications__c) {
                sendBoatRiggingNotification(lstNewInventory, mapOldInventory);
            }

            shootMailForInvUpateAU(mapNewInventory, mapOldInventory);
            updateInventoryQuantityFromParts(lstNewInventory, mapOldInventory);
        }
    }
    public static void SetQuantityDefaultValue(List < BOATBUILDING__Inventory__c > lstNewInventory) {
        for (BOATBUILDING__Inventory__c objInv: lstNewInventory) {
            if (objInv.BOATBUILDING__Quantity__c == null) {
                objInv.BOATBUILDING__Quantity__c = 1;
            }

        }


    }

    public static void createItemForInventory(List < BOATBUILDING__Inventory__c > lstNewInventory) {
        List < BOATBUILDING__Item__c > lstItem = new List < BOATBUILDING__Item__c > ();
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        Set < String > setInvHIN = new Set < String > ();
        Map < String, BOATBUILDING__Inventory__c > mapInventory = new Map < String, BOATBUILDING__Inventory__c > ();
        for (BOATBUILDING__Inventory__c objInventory: lstNewInventory) {
            if (String.isNotBlank(objInventory.HIN_Number__c) && objInventory.RecordTypeId != partInvRecordTypeId) {
                mapInventory.put(objInventory.HIN_Number__c, objInventory);
            }
        }
        Set < String > setBoatHINItem = new Set < String > ();
        if (!mapInventory.keySet().isEmpty()) {
            for (BOATBUILDING__Item__c objItem: [Select Id, Boat_HIN_No__c From BOATBUILDING__Item__c Where Boat_HIN_No__c IN: mapInventory.keySet()]) {
                setBoatHINItem.add(objItem.Boat_HIN_No__c);
            }
            for (String strBoatHIN: mapInventory.keySet()) {
                if (!setBoatHINItem.contains(strBoatHIN)) {
                    BOATBUILDING__Item__c objItm = new BOATBUILDING__Item__c();
                    objItm.Name = 'Item For ' + mapInventory.get(strBoatHIN).Name;
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
        if (!lstItem.isEmpty()) {
            try {
                insert lstItem;
            } catch (Exception ex) {
                System.debug('Debug Log for Exception: ' + ex);
            }
        }
    }

    public static void updatePartLookupOnInventory(List < Inventory__c > listNewInventory) {
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        Set < String > setPrtNum = new Set < String > ();

        for (Inventory__c objInv: listNewInventory) {
            //Defaulting Refresh Image checkbox to True on creation of Inventory. 
            if (objInv.RecordTypeId != partInvRecordTypeId) {
                objInv.BOATBUILDING__Refresh_Images_on_Website__c = True;
            } else { // Update Part Lookup on Inventory from Part Number 
                if (objInv.Part_Number__c != null) {
                    setPrtNum.add(objInv.Part_Number__c);
                }
            }
        }

        List < Part__c > listPart = [Select Id, Part_Number__c From Part__c Where Part_Number__c IN: setPrtNum];

        if (!listPart.isEmpty()) {
            Map < String, String > mapPartNumberToId = new Map < String, String > ();
            for (Part__c objPrt: listPart) {
                mapPartNumberToId.put(objPrt.Part_Number__c, objPrt.Id);
            }

            for (Inventory__c objInv: listNewInventory) {
                if (objInv.RecordTypeId == partInvRecordTypeId && objInv.Part_Number__c != null && mapPartNumberToId.containsKey(objInv.Part_Number__c)) {
                    objInv.Part__c = mapPartNumberToId.get(objInv.Part_Number__c);
                }
            }
        }
    }

    public static void sendBoatRiggingNotification(List < BOATBUILDING__Inventory__c > lstNewInventory, Map < Id, BOATBUILDING__Inventory__c > mapOldInventory) {

        List < User > listUser = [SELECT Id, Email, UserRole.DeveloperName, BOATBUILDING__Store_Location__c FROM User WHERE isActive = True];

        Set < String > setServiceEmail = new Set < String > ();
        Set < String > setMarketingEmail = new Set < String > ();
        Set < String > setInStockEmail = new Set < String > ();

        Set < String > setServiceUserId = new Set < String > ();
        Set < String > setMarketingUserId = new Set < String > ();
        Set < String > setInStockUserId = new Set < String > ();

        List < String > toAddress = new List < String > ();
        Map < String, Set < String >> mapStoreLocationToUserEmails = new Map < String, Set < string >> ();

        for (User u: listUser) {
            if (u.UserRole.DeveloperName == 'Service_Manager' || u.UserRole.DeveloperName == 'Service_Writer') {
                setServiceEmail.add(u.Email);
                setServiceUserId.add(u.Id);
            } else if (u.UserRole.DeveloperName == 'Marketing_Manager') {
                setMarketingEmail.add(u.Email);
                setMarketingUserId.add(u.Id);
            } else if (u.UserRole.DeveloperName == 'Sales_Manager' || u.UserRole.DeveloperName == 'Salesperson') {
                if (mapStoreLocationToUserEmails.containsKey(u.BOATBUILDING__Store_Location__c)) {
                    mapStoreLocationToUserEmails.get(u.BOATBUILDING__Store_Location__c).add(u.Email);
                } else {
                    mapStoreLocationToUserEmails.put(u.BOATBUILDING__Store_Location__c, new Set < String > {
                        u.Email
                    });
                }

                setInStockUserId.add(u.Id);
            }
        }

        //Get All Additional Emails from Custom Setting
        Map < String, BOATBUILDING__ExternalNotificationEmail__c > mapRolesToExternalEmail = BOATBUILDING__ExternalNotificationEmail__c.getAll();
        List < String > ccAddress = new List < String > ();
        List < Messaging.SingleEmailMessage > lstOfInvMail = new List < Messaging.SingleEmailMessage > ();
        List <Task> lstOfTaskToinsert = new List <Task> ();
       

        for (BOATBUILDING__Inventory__c inv: lstNewInventory) {
            //Rigging
            if (inv.BOATBUILDING__Stage__c == 'Rigging' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'Rigging') {

                //Get Additional Service Writer Emails from Custom Setting
              
                String additionalServiceWritterEmail = '';
                if (mapRolesToExternalEmail.containsKey('Service Writer')) {
                    additionalServiceWritterEmail = mapRolesToExternalEmail.get('Service Writer').BOATBUILDING__Email__c;
                }

                if (String.isNotBlank(additionalServiceWritterEmail)) {
                    if (additionalServiceWritterEmail.containsIgnoreCase(',')) {
                        toAddress.addAll(additionalServiceWritterEmail.split(','));
                    } else {
                        toAddress.add(additionalServiceWritterEmail);
                    }
                }

                //Get Additional Service Manager Emails from Custom Setting
                String additionalServiceManagerEmail = '';
                if (mapRolesToExternalEmail.containsKey('Service Manager')) {
                    additionalServiceManagerEmail = mapRolesToExternalEmail.get('Service Manager').BOATBUILDING__Email__c;
                }

                if (String.isNotBlank(additionalServiceManagerEmail)) {
                    if (additionalServiceManagerEmail.containsIgnoreCase(',')) {
                        toAddress.addAll(additionalServiceManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalServiceManagerEmail);
                    }
                }
               
                toAddress.addAll(setServiceEmail);

                String inventorylink = System.URL.getSalesforceBaseUrl() + '/' + inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat needs to be rigged. <br/> <a target="_blank" href = "' + inventorylink + '">';
                htmlBody += inv.Name + '<a/> <br/>Kindly process accordingly';
                String subject = 'Boat needs to be rigged ' + inv.Name;
                //  SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                if(!toAddress.isEmpty()){
                mail1.setToAddresses(toAddress);
                mail1.setSubject(subject);
                mail1.setHtmlBody(htmlBody);
                lstOfInvMail.add(mail1);
                System.debug('>>>>>Rigging'+mail1);
                }


                lstOfTaskToinsert =  createTask('Boat needs to be rigged', inv.Id, setServiceUserId);
            }

            //Marketing
            if (inv.BOATBUILDING__Stage__c == 'Marketing Photos' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'Marketing Photos') {

                //Get Additional Marketing Manager Emails from Custom Setting
                System.debug('Inventory Status Changed---------');
                String additionalMarketingManagerEmail = '';
                if (mapRolesToExternalEmail.containsKey('Marketing Manager')) {
                    additionalMarketingManagerEmail = mapRolesToExternalEmail.get('Marketing Manager').BOATBUILDING__Email__c;
                }
                System.debug('Inventory .  emails' + additionalMarketingManagerEmail);
                if (String.isNotBlank(additionalMarketingManagerEmail)) {
                    if (additionalMarketingManagerEmail.containsIgnoreCase(',')) {
                        toAddress.addAll(additionalMarketingManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalMarketingManagerEmail);
                    }
                }

                toAddress.addAll(setMarketingEmail);

                String inventorylink = System.URL.getSalesforceBaseUrl() + '/' + inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat is ready for the Marketing. <br/> <a target="_blank" href = "' + inventorylink + '">';
                htmlBody += inv.Name + '<a/> <br/>Kindly process accordingly.';
                String subject = 'Boat ready for the Marketing ' + inv.Name;
                //  SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
                if(!toAddress.isEmpty()){
                 mail2.setToAddresses(toAddress);
                 mail2.setSubject(subject);
                 mail2.setHtmlBody(htmlBody);
                 lstOfInvMail.add(mail2);
                }
                lstOfTaskToinsert = createTask('Boat ready for the Marketing', inv.Id, setMarketingUserId);
            }

            //In Stock
            if (inv.BOATBUILDING__Stage__c == 'In Stock' && mapOldInventory.get(inv.Id).BOATBUILDING__Stage__c != 'In Stock') {

                //Get Additional Sales Manager Emails from Custom Setting
                String additionalSalesManagerEmail = '';
                if (mapRolesToExternalEmail.containsKey('Sales Manager')) {
                    additionalSalesManagerEmail = mapRolesToExternalEmail.get('Sales Manager').BOATBUILDING__Email__c;
                }


                if (String.isNotBlank(additionalSalesManagerEmail)) {
                    if (additionalSalesManagerEmail.containsIgnoreCase(',')) {
                        toAddress.addAll(additionalSalesManagerEmail.split(','));
                    } else {
                        toAddress.add(additionalSalesManagerEmail);
                    }
                }

                //Get Additional Salesperson Emails from Custom Setting
                String additionalSalesPersonEmail = '';
                if (mapRolesToExternalEmail.containsKey('Salesperson')) {
                    additionalSalesPersonEmail = mapRolesToExternalEmail.get('Salesperson').BOATBUILDING__Email__c;
                }

                if (String.isNotBlank(additionalSalesPersonEmail)) {
                    if (additionalSalesPersonEmail.containsIgnoreCase(',')) {
                        toAddress.addAll(additionalSalesPersonEmail.split(','));
                    } else {
                        toAddress.add(additionalSalesPersonEmail);
                    }
                }
                if (mapStoreLocationToUserEmails.containsKey(inv.BOATBUILDING__Store_Location__c)) {
                    toAddress.addAll(mapStoreLocationToUserEmails.get(inv.BOATBUILDING__Store_Location__c));
                }

                String inventorylink = System.URL.getSalesforceBaseUrl() + '/' + inv.Id;
                String htmlBody = 'Hi, <br/><br/> The below Boat is ready to Sell. <br/> <a target="_blank" href = "' + inventorylink + '">';
                htmlBody += inv.Name + '<a/> <br/>Kindly process accordingly';
                String subject = 'Boat is ready to Sell ' + inv.Name;
                //  SendEmailUtility.sendEmailUtil(toAddress,ccAddress,htmlBody,subject);
                Messaging.SingleEmailMessage mail3 = new Messaging.SingleEmailMessage();
                if(!toAddress.isEmpty()){
                        mail3.setToAddresses(toAddress);
                        mail3.setSubject(subject);     
                        mail3.setHtmlBody(htmlBody);
                        lstOfInvMail.add(mail3);
                }
                lstOfTaskToinsert = createTask('Boat is ready to Sell', inv.Id, setInStockUserId);
            }
        }
          System.debug('lstOfRiggingInvMail***'+lstOfInvMail);
        if (!lstOfInvMail.isEmpty() && !Test.isRunningTest()) {
            Messaging.sendEmail(lstOfInvMail);
        }
        if(!lstOfTaskToinsert.isEmpty()){

            insert lstOfTaskToinsert;
        }
      


    }

    public static   List < Task > createTask(String subject, Id parentId, Set < String > setOwnerIds) {

        List < Task > listTask = new List < Task > ();

        for (String uId: setOwnerIds) {
            Task objTask = new Task();
            objTask.Subject = subject;
            objTask.WhatId = parentId;
            objTask.OwnerId = uId;
            listTask.add(objTask);
        }
        System.debug('listTask---' + listTask);
      /*  if (!listTask.isEmpty()) {
            insert listTask;
        } */
        return listTask;
    }

    public static void shootMailForInvUpate(List < Inventory__c > lstInv) {
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        Set < String > setPartNum = new Set < String > ();

        for (Inventory__c objInv: lstInv) {
            if (objInv.Quantity__c != null && objInv.Quantity__c > 0 && objSC != null && !objSC.BOATBUILDING__Turn_Off_Inventory_Alerts__c) {
                setPartNum.add(objInv.Part_Number__c);
            } 
        }
        System.debug('setPartNum: ' + setPartNum);
        if (!setPartNum.isEmpty()) {
            List < BOATBUILDING__Work_Order_Job_Line_Item__c > lstLJI = [SELECT
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
                BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Status__c != 'Closed'
            ];

            System.debug('lstLJI: ' + lstLJI);
            if (!lstLJI.isEmpty()) {
                Map < String, Set < String >> mapOwnerWOName = new Map < String, Set < String >> ();
                Map < String, Set < String >> mapOwnerPartNum = new Map < String, Set < String >> ();
                Map < String, String > mapOwnerEmil = new Map < String, String > ();
                for (BOATBUILDING__Work_Order_Job_Line_Item__c objJLI: lstLJI) {
                    if (objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                        if (!mapOwnerWOName.containsKey(objJLI.CreatedById)) {
                            mapOwnerWOName.put(objJLI.CreatedById, new Set < String > ());
                            mapOwnerPartNum.put(objJLI.CreatedById, new Set < String > ());
                            mapOwnerEmil.put(objJLI.CreatedById, objJLI.CreatedBy.Email);
                        }

                        if (mapOwnerWOName.containsKey(objJLI.CreatedById)) {
                            mapOwnerWOName.get(objJLI.CreatedById).add(objJLI.BOATBUILDING__Related_to_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name);
                            mapOwnerPartNum.get(objJLI.CreatedById).add(objJLI.BOATBUILDING__Part_Number__c);
                        }
                    }
                }

                System.debug('mapOwnerWOName: ' + mapOwnerWOName);
                System.debug('mapOwnerPartNum: ' + mapOwnerPartNum);
                System.debug('mapOwnerEmil: ' + mapOwnerEmil);
                List < Messaging.SingleEmailMessage > masterListMails = new List < Messaging.SingleEmailMessage > ();
                for (String strKey: mapOwnerPartNum.keySet()) {
                    if (mapOwnerPartNum.get(strKey) != null && mapOwnerWOName.get(strKey) != null) {
                        String strBody = 'Hi,<br/>Following parts are available in stock now:<br/>';
                        for (String prt: mapOwnerPartNum.get(strKey)) {
                            strBody += '* ' + prt + '<br/>';
                        }
                        strBody += '<br/>Please process following work orders:<br/>';
                        for (String wo: mapOwnerWOName.get(strKey)) {
                            strBody += '* ' + wo + '<br/>';
                        }
                        strBody += '<br/>Thanks.';

                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        string[] to = new string[] {
                            mapOwnerEmil.get(strKey)
                        };
                        email.setToAddresses(to);
                        email.setSubject('Part Update');
                        email.setHtmlBody(strBody);
                        masterListMails.add(email);
                        
                    }

                }
                if(!masterListMails.isEmpty()){
                Messaging.sendEmail(masterListMails);
                }
            }
        }
    }

    public static void shootMailForInvUpateAU(Map < Id, Inventory__c > newMapInv, Map < Id, Inventory__c > oldMapInv) {
        List < Inventory__c > lstInv = new List < Inventory__c > ();
        for (Id ids: newMapInv.keySet()) {
            if (newMapInv.get(ids).Quantity__c != null) {
                if (oldMapInv.get(ids).Quantity__c <= 0 && newMapInv.get(ids).Quantity__c > 0) {
                    lstInv.add(newMapInv.get(ids));
                }
            }
        }
        if (!lstInv.isEmpty()) {
            shootMailForInvUpate(lstInv);
        }
    }

    public static void createCustomerBoatValidation(List < Inventory__c > lstNewInventory, Map < Id, Inventory__c > mapOldInventory) {
        Set < String > setHin = new Set < String > ();
        for (BOATBUILDING__Inventory__c objInv: lstNewInventory) {
            if (lstNewInventory.isEmpty() && mapOldInventory.isEmpty()) {
                if (objInv.BOATBUILDING__HIN_Number__c != null) {
                    setHin.add(objInv.BOATBUILDING__HIN_Number__c);
                }
            }
            if (lstNewInventory.isEmpty() && mapOldInventory.isEmpty()) {
                if (objInv.BOATBUILDING__Display_On_Web__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Display_On_Web__c &&
                    objInv.BOATBUILDING__Display_On_Web__c == 'Website') {
                    objInv.BOATBUILDING__Refresh_Images_on_Website__c = True;
                }
            }
        }
        Id recordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId();
        Id recordTypeUBId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Used Boats').getRecordTypeId();
        List < Item__c > lstItm = [Select Id, BOATBUILDING__Boat_HIN_No__c From Item__c Where BOATBUILDING__Boat_HIN_No__c IN: setHin];
        System.debug('debug log for: lstItm: ' + lstItm);
        for (BOATBUILDING__Inventory__c objInv: lstNewInventory) {
            if (objInv.Stage__c == 'Sold' && objInv.RecordTypeId == recordTypeId) {
                if (!lstItm.isEmpty()) {
                    for (Item__c objIt: lstItm) {
                        if (!setHin.contains(objIt.BOATBUILDING__Boat_HIN_No__c)) {
                            objInv.addError('Please create customer boat first.');
                        }
                    }
                } else {
                    objInv.addError('Please create customer boat first.');
                }
            }
            if ((objInv.RecordTypeId == recordTypeId || objInv.RecordTypeId == recordTypeUBId) && (objInv.BOATBUILDING__Costline_Dollar__c != null && objInv.BOATBUILDING__Costline_Dollar__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline_Dollar__c)) {
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                System.debug('Debug log for BOATBUILDING__Total_Dealer_Price__c: ' + objInv.BOATBUILDING__Total_Dealer_Price__c);
                Decimal MinSP = dc + objInv.BOATBUILDING__Costline_Dollar__c;
                Decimal costLine = 0.00;
                costLine = dc / MinSP;
                System.debug('Debug log for costLine: ' + costLine);
                objInv.BOATBUILDING__Costline__c = 100 - (costLine * 100);
                System.debug('Debug log for objInv.BOATBUILDING__Costline__c: ' + objInv.BOATBUILDING__Costline__c);
            } else if ((objInv.RecordTypeId == recordTypeId || objInv.RecordTypeId == recordTypeUBId) && (objInv.BOATBUILDING__Costline__c != null && objInv.BOATBUILDING__Costline__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline__c)) {

                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                Decimal costLine = (100 - objInv.BOATBUILDING__Costline__c) / 100;
                Decimal MinSP = dc / costLine;
                objInv.BOATBUILDING__Costline_Dollar__c = MinSP - dc;
            }
        }
    }

    public static void updateInventoryQuantityFromParts(List < Inventory__c > listNewInventory, Map < Id, BOATBUILDING__Inventory__c > mapOldInventory) {
        Set < String > setPartId = new Set < String > ();
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
        for (Inventory__c objInv: listNewInventory) {
            System.debug('updateInventoryQuantityFromParts objInv>>>: ' + objInv.Quantity__c);

            if (mapOldInventory == null || mapOldInventory.containsKey(objInv.Id)) {
                setPartId.add(objInv.Part__c);
            } else if (objInv.Part__c != null && objInv.RecordTypeId == partInvRecordTypeId &&
                mapOldInventory.get(objInv.Id).BOATBUILDING__Quantity__c != objInv.BOATBUILDING__Quantity__c) {
                setPartId.add(objInv.Part__c);
            }
        }

        List < Part__c > lstPrt = [SELECT Id, BOATBUILDING__Quantity__c,
            (SELECT Id, BOATBUILDING__Quantity__c FROM BOATBUILDING__Inventory__r)
            FROM BOATBUILDING__Part__c WHERE Id IN: setPartId
        ];

        if (!lstPrt.isEmpty()) {
            for (Part__c objPart: lstPrt) {
                Decimal count = 0.00;
                if (!objPart.BOATBUILDING__Inventory__r.isEmpty()) {
                    for (Inventory__c obInv: objPart.BOATBUILDING__Inventory__r) {
                        if (obInv.Quantity__c != null) {
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

    public static void updateInventoryPricingBasedOnMargin(List < BOATBUILDING__Inventory__c > listNewInventory) {
        Id partInvRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();

        for (BOATBUILDING__Inventory__c objInventory: listNewInventory) {
            if (objInventory.RecordTypeId != partInvRecordTypeId) {
                if (objInventory.BOATBUILDING__Instant_Quote_Margin__c != null) {
                    objInventory.BOATBUILDING__Our_Instant_Quote_Price__c = objInventory.BOATBUILDING__Total_Dealer_Price__c / (1 - Decimal.valueOf(objInventory.BOATBUILDING__Instant_Quote_Margin__c));
                }

                if (objInventory.BOATBUILDING__Web_Price_Margin__c != null) {
                    objInventory.BOATBUILDING__Web_Price__c = objInventory.BOATBUILDING__Total_Dealer_Price__c / (1 - Decimal.valueOf(objInventory.BOATBUILDING__Web_Price_Margin__c));
                }
            }
        }
    }

    private static boolean run = true;
    public static boolean runOnce() {
        if (run) {
            run = false;
            return true;
        } else {
            return run;
        }
    }
    //00009783 - Minimum sale price calculations
    public static void updateMarginCalculation(List < BOATBUILDING__Inventory__c > listNewInventory, Map < Id, Inventory__c > mapOldInventory) {
        for (BOATBUILDING__Inventory__c objInv: listNewInventory) {
            if (objInv.BOATBUILDING__Costline__c != null &&
                (mapOldInventory.get(objInv.Id).BOATBUILDING__Costline__c == null || objInv.BOATBUILDING__Costline__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline__c) &&
                objInv.BOATBUILDING__Total_Dealer_Price__c != null) {
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                Decimal costLine = (100 - objInv.BOATBUILDING__Costline__c) / 100;
                objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c = dc / costLine;
                objInv.BOATBUILDING__Costline_Dollar__c = objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c - dc;
            } else if (objInv.BOATBUILDING__Costline_Dollar__c != null &&
                (mapOldInventory.get(objInv.Id).BOATBUILDING__Costline_Dollar__c == null || objInv.BOATBUILDING__Costline_Dollar__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Costline_Dollar__c) &&
                objInv.BOATBUILDING__Total_Dealer_Price__c != null) {
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c = dc + objInv.BOATBUILDING__Costline_Dollar__c;
                Decimal costLine = 0.00;
                costLine = dc / objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c;
                objInv.BOATBUILDING__Costline__c = 100 - (costLine * 100);
            } else if (objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c != null &&
                (mapOldInventory.get(objInv.Id).BOATBUILDING__Minimum_Sales_Price_Manual__c == null || objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c != mapOldInventory.get(objInv.Id).BOATBUILDING__Minimum_Sales_Price_Manual__c) &&
                objInv.BOATBUILDING__Total_Dealer_Price__c != null) {
                Decimal dc = objInv.BOATBUILDING__Total_Dealer_Price__c;
                objInv.BOATBUILDING__Costline_Dollar__c = objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c - dc;
                Decimal costLine = 0.00;
                costLine = dc / objInv.BOATBUILDING__Minimum_Sales_Price_Manual__c;
                objInv.BOATBUILDING__Costline__c = 100 - (costLine * 100);
            }
        }
    }
}