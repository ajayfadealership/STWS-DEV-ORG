public class CustomerInquiryTriggerHandler {
    
    public Static void onBeforeInsert(List<BOATBUILDING__Customer_Inquiry__c> listNewCI)
    {
        updateRecordTypeFromLeadSource(listNewCI);
        attachInventoryFromName(listNewCI);
        filterRoundRobin(listNewCI);
    }
    
    public Static void onBeforeUpdate(List<BOATBUILDING__Customer_Inquiry__c> listNewCI, 
                                      Map<Id, BOATBUILDING__Customer_Inquiry__c> mapOldCI)
    {
        attachInventoryFromName(listNewCI);
    }
    
    public Static void onBeforeDelete(List<BOATBUILDING__Customer_Inquiry__c> listOldCI)
    {
    }
    
    public Static void onAfterInsert(List<BOATBUILDING__Customer_Inquiry__c> listNewCI)
    {
        List<BOATBUILDING__Customer_Inquiry__c> lstCIWorkReq = new List<BOATBUILDING__Customer_Inquiry__c>();
        List<BOATBUILDING__Customer_Inquiry__c> lstCIPartReq = new List<BOATBUILDING__Customer_Inquiry__c>();
        Id idCIRT = Schema.SObjectType.BOATBUILDING__Customer_Inquiry__c.getRecordTypeInfosByName().get('Service Request').getRecordTypeId();
        Id idCIPR = Schema.SObjectType.BOATBUILDING__Customer_Inquiry__c.getRecordTypeInfosByName().get('Parts Request').getRecordTypeId();
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI) {
            if(objCI.RecordTypeId == idCIRT) 
            {
                lstCIWorkReq.add(objCI);
            } 
            else if(objCI.RecordTypeId == idCIPR) 
            {
                lstCIPartReq.add(objCI);
            }
        }
        if(!lstCIWorkReq.isEmpty()) {
            createWorkRequest(lstCIWorkReq);
        }
        if(!lstCIPartReq.isEmpty()) {
            createPartRequest(lstCIWorkReq);
        }
    }
    
    public Static void onAfterUpdate(List<BOATBUILDING__Customer_Inquiry__c> listNewCI, 
                                     Map<Id, BOATBUILDING__Customer_Inquiry__c> mapOldCI)
    {
    }
    
    public Static void onAfterDelete(List<BOATBUILDING__Customer_Inquiry__c> listOldCI)
    {
    }

    //Generating part request from customer inquiry if record type if part request
    public static void createPartRequest(List<BOATBUILDING__Customer_Inquiry__c> listNewCI) 
    {
        List<BOATBUILDING__Order__c> lstWO = new List<BOATBUILDING__Order__c>();
        Id idWOWR = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Part Request').getRecordTypeId(); 
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI) {
            BOATBUILDING__Order__c objO = new BOATBUILDING__Order__c();
            objO.RecordTypeId = idWOWR;
            //objO.BOATBUILDING__Part_Number__c = objCI.BOATBUILDING__Required_Part_Number__c;
            //objO.BOATBUILDING__Part_Number__c = objCI.BOATBUILDING__Required_Part_Number__c;
        }
    }

    //Generating work request from customer inquiry if record type if service request
    public static void createWorkRequest(List<BOATBUILDING__Customer_Inquiry__c> listNewCI) 
    {
        List<BOATBUILDING__Work_Order__c> lstWO = new List<BOATBUILDING__Work_Order__c>();
        Id idWOWR = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId(); 
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI) {
            BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c(); 
            objWO.RecordTypeId = idWOWR;
            objWO.BOATBUILDING__Account__c = objCI.BOATBUILDING__Account__c;
            objWO.BOATBUILDING__ContactEmail__c = objCI.BOATBUILDING__Email__c;
            objWO.BOATBUILDING__ContactPhone__c = objCI.BOATBUILDING__Phone__c;
            objWO.BOATBUILDING__Boat_Make__c = objCI.BOATBUILDING__Boat_Manufacturer__c;
            objWO.BOATBUILDING__Boat_Model__c = objCI.BOATBUILDING__Boat_Model__c;
            objWO.BOATBUILDING__Boat_Year__c = objCI.BOATBUILDING__Boat_Year__c;
            objWO.BOATBUILDING__HIN_Number__c = objCI.BOATBUILDING__Boat_HIN__c;
            objWO.BOATBUILDING__Hours__c = objCI.BOATBUILDING__Boat_Engine_Hours__c;
            System.debug('>>>>objWO: '+objWO);
            lstWO.add(objWO);
        }
        System.debug('>>>>lstWO: '+lstWO);
        if(!lstWO.isEmpty()) 
        {
            insert lstWO;
        }
    }

    //Assign Record Type based on Lead Source
    public static void updateRecordTypeFromLeadSource(List<BOATBUILDING__Customer_Inquiry__c> listNewCI){
        
        List<BOATBUILDING__RoundRobin_Config__c> listRoundRobinConfig = BOATBUILDING__RoundRobin_Config__c.getAll().values();
        Map<String, String> mapCISourceToRecordType = new Map<String, String>();
        
        for(BOATBUILDING__RoundRobin_Config__c objRRConfig : listRoundRobinConfig){
            mapCISourceToRecordType.put(objRRConfig.BOATBUILDING__Lead_Source__c, objRRConfig.BOATBUILDING__Record_Type_Id__c);
        }
        System.debug('---mapCISourceToRecordType--'+mapCISourceToRecordType);
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI){
            System.debug('---objCI.BOATBUILDING__Lead_Source__c--'+objCI.BOATBUILDING__Lead_Source__c);
            if(String.isNotBlank(objCI.BOATBUILDING__Lead_Source__c)
               && mapCISourceToRecordType.containsKey(objCI.BOATBUILDING__Lead_Source__c)
               && mapCISourceToRecordType.get(objCI.BOATBUILDING__Lead_Source__c) != null){
                   System.debug('---objCI.RecordTypeIdIN--'+mapCISourceToRecordType.get(objCI.BOATBUILDING__Lead_Source__c));
                   objCI.RecordTypeId = mapCISourceToRecordType.get(objCI.BOATBUILDING__Lead_Source__c);
               }
            
            System.debug('---objCI.RecordTypeId--'+objCI.RecordTypeId);
        }
    }
    
    public static void attachInventoryFromName(List<BOATBUILDING__Customer_Inquiry__c> listNewCI){
        Set<String> setInvName = new Set<String>(); 
        for(BOATBUILDING__Customer_Inquiry__c objCI : listNewCI){
            setInvName.add(objCI.BOATBUILDING__Product_Id__c);
        }
        
        Map<String, String> mapNameToId = new Map<String, String>();
        for(BOATBUILDING__Inventory__c inv : [SELECT Id, Name FROM BOATBUILDING__Inventory__c WHERE Name IN : setInvName]){
            mapNameToId.put(inv.Name, inv.Id);
        }
        
        for(BOATBUILDING__Customer_Inquiry__c objCI : listNewCI){
            if(String.isNotBlank(objCI.BOATBUILDING__Product_Id__c) && mapNameToId.containsKey(objCI.BOATBUILDING__Product_Id__c)){
                objCI.BOATBUILDING__Inventory__c = mapNameToId.get(objCI.BOATBUILDING__Product_Id__c);
            }
        }
    }
    
    public Static void filterRoundRobin(List<BOATBUILDING__Customer_Inquiry__c> listNewCI)
    {
        Set<String> setEmailToSearch = new Set<String>();
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI){
            if(objCI.BOATBUILDING__IsCreatedFromWeb__c){
                if(String.isNotBlank(objCI.BOATBUILDING__lead_Source__c)){
                    setEmailToSearch.add(objCI.BOATBUILDING__Email__c);
                    if(String.isBlank(objCI.BOATBUILDING__Store_Location__c)){
                        objCI.BOATBUILDING__Store_Location__c = getDefaultStoreLocation();
                    }
                } else {
                    objCI.OwnerId = getDefaultInquiryOwnerId();
                }
            }
        }
        
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> listAccToProcess = [SELECT Id, OwnerId, BOATBUILDING__Email__c, Owner.UserType, Owner.isActive
                                          FROM Account WHERE BOATBUILDING__Email__c IN: setEmailToSearch
                                          AND RecordTypeId =: prospectRecordTypeId];
        
        Map<String, Account> mapEmailToAccount = new Map<String, Account>();
        for(Account acc: listAccToProcess){
            mapEmailToAccount.put(acc.BOATBUILDING__Email__c, acc);
        }
        
        List<BOATBUILDING__Customer_Inquiry__c> listCIToProcess = new List<BOATBUILDING__Customer_Inquiry__c>();
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI){
            if(objCI.BOATBUILDING__IsCreatedFromWeb__c){
                if(mapEmailToAccount.containsKey(objCI.BOATBUILDING__Email__c)){
                    if(mapEmailToAccount.get(objCI.BOATBUILDING__Email__c).Owner.UserType == 'Standard' 
                       && mapEmailToAccount.get(objCI.BOATBUILDING__Email__c).Owner.isActive){
                           objCI.OwnerId = mapEmailToAccount.get(objCI.BOATBUILDING__Email__c).OwnerId;
                       } else {
                           objCI.OwnerId = getDefaultInquiryOwnerId();
                       }
                    
                    objCI.BOATBUILDING__Account__c = mapEmailToAccount.get(objCI.BOATBUILDING__Email__c).Id;
                }
                else {
                    if(String.isNotBlank(objCI.BOATBUILDING__lead_Source__c)){
                        listCIToProcess.add(objCI);
                    }
                }
            }
        }
        
        if(!listCIToProcess.isEmpty()){
            System.debug('listCIToProcess---'+listCIToProcess);
            doRoundRobin(listCIToProcess);
        }
    }
    
    public static void doRoundRobin(List<BOATBUILDING__Customer_Inquiry__c> listNewCI){
        
        // Get Lead Source to User Role mapping to process Round Robin based on BOATBUILDING__RoundRobin_Config__c Custom Setting
        List<BOATBUILDING__RoundRobin_Config__c> listRoundRobinConfig = BOATBUILDING__RoundRobin_Config__c.getAll().values();
        
        Map<string,string> mapLeadSourceToUserRole = new Map<string,string>();
        for(BOATBUILDING__RoundRobin_Config__c objRRConfig :listRoundRobinConfig){
            mapLeadSourceToUserRole.put(objRRConfig.BOATBUILDING__Lead_Source__c, objRRConfig.BOATBUILDING__User_Role_Name__c);
        }
        
        String storeLocToUserRole = '';
        Map<String, BOATBUILDING__Customer_Inquiry__c> mapRoleToCI = new Map<String, BOATBUILDING__Customer_Inquiry__c>();
        for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI){
            storeLocToUserRole = objCI.BOATBUILDING__Store_Location__c;
            
            String userRole = '';
            if(mapLeadSourceToUserRole.containsKey(objCI.BOATBUILDING__lead_Source__c)){
                userRole = mapLeadSourceToUserRole.get(objCI.BOATBUILDING__lead_Source__c);
            }
            storeLocToUserRole = storeLocToUserRole+userRole;
            mapRoleToCI.put(storeLocToUserRole, objCI);
        }
        
        
        List<User> listAvailableReps = [SELECT Id, Name, Next_Available_for_Assingment__c, 
                                        Assignment_order__c, BOATBUILDING__StoreLocationWithRole__c FROM User
                                        WHERE BOATBUILDING__StoreLocationWithRole__c IN: mapRoleToCI.keySet() 
                                        AND isActive = True AND UserType = 'Standard'
                                        ORDER BY Assignment_order__c DESC];
        
        List<User> listUserToUpdate = new List<User>();
        List<Account> listAccountToCreate = new List<Account>();
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        
        Integer intAssignmentOrder = 0;
        for(String str: mapRoleToCI.keySet()){
            BOATBUILDING__Customer_Inquiry__c objCI = mapRoleToCI.get(str);
            Account acc = new Account();
            acc.Name = objCI.BOATBUILDING__First_Name__c +' '+objCI.BOATBUILDING__Last_Name__c;
            acc.Phone = objCI.BOATBUILDING__Phone__c;
            
            acc.BOATBUILDING__Email__c = objCI.BOATBUILDING__Email__c;
            acc.BOATBUILDING__Lead_Source__c = objCI.BOATBUILDING__Lead_Source__c;
            acc.RecordTypeId = prospectRecordTypeId;

            if( !listAvailableReps.isEmpty() ) {
                for(User u: listAvailableReps){
                    if(str == u.BOATBUILDING__StoreLocationWithRole__c && u.BOATBUILDING__Next_Available_for_Assingment__c){
                        mapRoleToCI.get(str).OwnerId = u.Id;
                        acc.OwnerId = u.Id;  
                        u.BOATBUILDING__Next_Available_for_Assingment__c = False;
                        intAssignmentOrder = Integer.valueOf(u.Assignment_order__c);
                        listUserToUpdate.add(u);
                    } else {
                        mapRoleToCI.get(str).OwnerId = getDefaultInquiryOwnerId();
                        acc.OwnerId = getDefaultInquiryOwnerId();
                    }
                }
            } else {
                mapRoleToCI.get(str).OwnerId = getDefaultInquiryOwnerId();
                acc.OwnerId = getDefaultInquiryOwnerId();
            }

            listAccountToCreate.add(acc);
        } 
         
        System.debug('listAccountToCreate---'+listAccountToCreate);
        if(!listAccountToCreate.isEmpty()){
            insert listAccountToCreate;
        }
        
        for(Account acc: listAccountToCreate){
            for(BOATBUILDING__Customer_Inquiry__c objCI: listNewCI){
                if(acc.BOATBUILDING__Email__c == objCI.BOATBUILDING__Email__c){
                    objCI.BOATBUILDING__Account__c = acc.Id;
                }
            }
        }
        
        updateRoundRobinRecord(listAvailableReps, listUserToUpdate, intAssignmentOrder);
    }
    
    
    public static void updateRoundRobinRecord(List<User> listAvailableReps, List<User> listUserToUpdate, Integer intAssignmentOrder){
        
        List<User> listRRToUpdate = new List<User>();
        Map<Id, User> mapUserToUpdate = new Map<Id, User>();
        listRRToUpdate.addAll(listUserToUpdate);
        for(Integer i=0; i< listAvailableReps.size(); i++){
            if(intAssignmentOrder < listAvailableReps[0].Assignment_order__c){
                if(listAvailableReps[i].Assignment_order__c == intAssignmentOrder+1){
                    listAvailableReps[i].Next_Available_for_Assingment__c = True;
                    listRRToUpdate.add(listAvailableReps[i]);
                }
            } else {
                if(listAvailableReps[i].Assignment_order__c == 1){
                    listAvailableReps[i].Next_Available_for_Assingment__c = True;
                    listRRToUpdate.add(listAvailableReps[i]);
                }
            }
        }
        
        if(!listRRToUpdate.isEmpty()){
            for(User u: listRRToUpdate){
                mapUserToUpdate.put(u.Id, u);
            }
            system.debug('listRRToUpdate---'+mapUserToUpdate.values());
            update mapUserToUpdate.values();
        }
    }
    
    public static String getDefaultInquiryOwnerId(){
        
        BOATBUILDING__System_Configure__c objConfig = BOATBUILDING__System_Configure__c.getOrgDefaults();
        String defaultUserId = objConfig.BOATBUILDING__DefaultCustomerInquiryOwnerId__c;
        return defaultUserId;
    }
    
    public static String getDefaultStoreLocation(){
        
        //Default Store Location
        String defaultVal;
        Schema.DescribeFieldResult F = BOATBUILDING__Customer_Inquiry__c.BOATBUILDING__Store_Location__c.getDescribe();
        List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
        for (Schema.PicklistEntry pv: pickVals) {
            if (pv.isDefaultValue()) {
                defaultVal = pv.getValue();
            }    
        }
        
        return defaultVal;
    }
}