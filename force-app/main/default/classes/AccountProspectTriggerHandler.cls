/** 
* CLOUDCODIOTS LLP
* Author : Akshay Kumar  Created Date : 07/11/2016
* Modified By: Sajal Bansal on: 05/04/2018
* Round Robin Logic Modified
*/
public class AccountProspectTriggerHandler {
    
    public static void onBeforeInsert(List<Account> newLstAccount){
        
        List<Account> listAccountToProcessRR = new List<Account>();
        for(Account acc: newLstAccount){
            if(acc.BOATBUILDING__IsCreatedFromWeb__c){
                listAccountToProcessRR.add(acc);
            }
        }
        
        updateRecordTypeFromLeadSource(listAccountToProcessRR);
        
        Id referralRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Referral Program').getRecordTypeId();
        List<Account> listAccountToProcess = new List<Account>();
        for(Account acc: newLstAccount){
            if(acc.RecordTypeId == referralRecordTypeId){
                listAccountToProcess.add(acc);
            }
            
            if(String.isBlank(acc.BOATBUILDING__Store_Location__c)){
                acc.BOATBUILDING__Store_Location__c = getDefaultStoreLocation();
            }
        }
        
        try{
            updateReferralForm(listAccountToProcess);
        } catch(Exception ex){
            SendEmailUtility.sendQuickEmail(ex.getLineNumber()+'---'+ex.getStackTraceString()+'---'+ex.getCause());
        }        
    }
    
    public static void onAfterInsert(List<Account> newLstAccount){
        Id creditAppRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Credit App').getRecordTypeId();
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id referralRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Referral Program').getRecordTypeId();
        contactCreation(newLstAccount, prospectRecordTypeId);     
        List<Account> listAccountToProcess = new List<Account>();
        
        if(runOnce()){
            for(Account acc: newLstAccount){
                if(acc.RecordTypeId != prospectRecordTypeId && acc.RecordTypeId != creditAppRecordTypeId && acc.RecordTypeId != referralRecordTypeId && acc.BOATBUILDING__IsCreatedFromWeb__c){
                    listAccountToProcess.add(acc);
                }
            }
            filterRoundRobin(listAccountToProcess);
        }
    }
    
    public static void onAfterUpdate(List<Account> newLstAccount, Map<Id, Account> oldMapAccount){
        updateContactOnAccountChange(newLstAccount, oldMapAccount);
        cobuyerFirstLast(newLstAccount, oldMapAccount);
    } 
    
    //Assign Record Type based on Lead Source
    public static void updateRecordTypeFromLeadSource(List<Account> listAccount){
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<BOATBUILDING__RoundRobin_Config__c> listRoundRobinConfig = BOATBUILDING__RoundRobin_Config__c.getAll().values();
        Map<string,string> mapAccountSourceToRecordType = new Map<string,string>();
        
        for(BOATBUILDING__RoundRobin_Config__c objRRConfig : listRoundRobinConfig){
            mapAccountSourceToRecordType.put(objRRConfig.BOATBUILDING__Lead_Source__c, objRRConfig.BOATBUILDING__Record_Type_Id__c);
        }
        
        for(Account objacc :listAccount){
            if(mapAccountSourceToRecordType.get(objacc.BOATBUILDING__Lead_Source__c) != Null &&
               mapAccountSourceToRecordType.containsKey(objacc.BOATBUILDING__Lead_Source__c)){
                   objacc.RecordTypeId = mapAccountSourceToRecordType.get(objacc.BOATBUILDING__Lead_Source__c);
               } else {
                   objacc.RecordTypeId = prospectRecordTypeId;
               }
            
            if(String.isNotBlank(objacc.Contact_Email__c)){
                objacc.Email__c = objacc.Contact_Email__c; //This is required for further logic.
            }
        }
    }
    
    //Create Contact for every new account
    private static void contactCreation(List<Account> lstAccount, Id prospectRecTypeId){
        system.debug('testcontactcreation');
        List<Contact> lstContact = new List<Contact>();
        
        for(Account objAccount : lstAccount){
            if(objAccount.RecordTypeId != null && objAccount.RecordTypeId == prospectRecTypeId){
                Contact objContact = new Contact();
                
                String accName = objAccount.Name;
                if(accName.containsIgnoreCase(' ')){
                    String[] strNameSplit = accName.split(' ');
                    objContact.FirstName = strNameSplit[0];
                    if(String.isNotBlank(strNameSplit[1].replaceAll( '\\s+', ''))) {
                        objContact.LastName = strNameSplit[1];
                    } else {
                        objContact.LastName = '|';
                    }  
                }else{
                    objContact.LastName = accName;
                }
                if(objAccount.Email__c != null){
                    objContact.Email = objAccount.Email__c;
                }
                if(objAccount.Contact_Email__c != null){
                    objContact.Email = objAccount.Contact_Email__c;
                }
                if(objAccount.Phone != null){
                    objContact.Phone = objAccount.Phone;
                }
                objContact.AccountId = objAccount.Id;
                if(objAccount.BillingStreet != null){
                    objContact.MailingStreet = objAccount.BillingStreet;
                }
                if(objAccount.BillingCity != null){
                    objContact.MailingCity = objAccount.BillingCity;
                }
                if(objAccount.BillingState != null){
                    objContact.MailingState = objAccount.BillingState;
                }
                if(objAccount.BillingCountry != null){
                    objContact.MailingCountry = objAccount.BillingCountry;
                }
                if(objAccount.BOATBUILDING__Lead_Source__c != null){
                    objContact.BOATBUILDING__lead_Source__c = objAccount.BOATBUILDING__Lead_Source__c;
                }
                
                lstContact.add(objContact);
            }
        } 
        
        if(lstContact.size() > 0){
            try{
                insert lstContact;
            }catch(Exception ex){
                System.debug('Debug Log For Exception : '+ex);
            }
        }
    }
    
    public static void updateContactOnAccountChange(List<Account> newLstAccount, Map<Id, Account> oldMapAccount){
        Map<Id, Account> mapAccToProcess = new Map<Id, Account>();
        System.debug('==After Update===');
        for(Account acc: newLstAccount){
            if(oldMapAccount.containsKey(acc.Id)){
                if(oldMapAccount.get(acc.Id).BOATBUILDING__Account_Customer_Type__c != acc.BOATBUILDING__Account_Customer_Type__c ||
                   oldMapAccount.get(acc.Id).BOATBUILDING__Lead_Status__c != acc.BOATBUILDING__Lead_Status__c ||
                   oldMapAccount.get(acc.Id).BOATBUILDING__Lead_Source__c != acc.BOATBUILDING__Lead_Source__c ||
                   oldMapAccount.get(acc.Id).Phone != acc.Phone){
                       
                       mapAccToProcess.put(acc.Id,acc);
                   }
            }
        }
        
        List<Contact> lstContactToUpdate = new List<Contact>();
        if(!mapAccToProcess.isEmpty()){
            List<Contact> lstContactToProcess = [SELECT Id, BOATBUILDING__lead_Source__c, BOATBUILDING__Status__c, AccountId,
                                                 BOATBUILDING__Customer_Type__c FROM Contact WHERE AccountId =:mapAccToProcess.keySet()];
            
            for(Contact objcon :lstContactToProcess)
            {
                if(mapAccToProcess.containsKey(objcon.AccountId)){
                    objcon.BOATBUILDING__lead_Source__c = mapAccToProcess.get(objcon.AccountId).BOATBUILDING__Lead_Source__c;
                    objcon.BOATBUILDING__Status__c = mapAccToProcess.get(objcon.AccountId).BOATBUILDING__Lead_Status__c;
                    objcon.BOATBUILDING__Customer_Type__c = mapAccToProcess.get(objcon.AccountId).BOATBUILDING__Account_Customer_Type__c;
                    objcon.phone = mapAccToProcess.get(objcon.AccountId).Phone;
                    lstContactToUpdate.add(objCon);
                }
            }
            
            if(!lstContactToUpdate.isEmpty()){
                update lstContactToUpdate;
            }
        }
    }
    
    public static void filterRoundRobin(List<Account> listAccount){
        
        //Find if existing Account vs New Account
        Map<String, Account> mapAccountEmail = new Map<String, Account>();
        Map<String, Account> MapNewAccountToProcess = new Map<String, Account>();
        
        List<Account> listEmailAccountToProcess = new List<Account>();
        System.debug('listAccount---Before For---'+listAccount);
        for(Account objacc :listAccount){
            if(objacc.Name.containsIgnoreCase('(Email-Lead)')){
                Account acc = new Account();
                acc = objAcc.clone(true, false, false, false);
                acc.Name = acc.Name.replaceAll('(Email-Lead)', '');
                listEmailAccountToProcess.add(acc);
            } else {
                listEmailAccountToProcess.add(objacc);
            }
            
            System.debug('listAccount---In For---'+objacc.Name);
        }
        
        System.debug('listAccount- After For--'+listAccount);
        for(Account objacc :listEmailAccountToProcess){
            if(objacc.BOATBUILDING__Email__c != null && objacc.IsCreatedFromWeb__c){
                mapAccountEmail.put(objacc.BOATBUILDING__Email__c, objacc);
            }
        }
        System.debug('mapAccountEmail.keySet()----'+mapAccountEmail.keySet());
        List<Account> listParentAccount = [SELECT Id, Name, BOATBUILDING__Lead_Account_History__c, BOATBUILDING__Email__c,BOATBUILDING__Store_Location__c,
                                           OwnerId,BOATBUILDING__Owner_IsActive__c,CreatedDate,BOATBUILDING__lead_Source__c, BOATBUILDING__Contact_Phone__c
                                           FROM Account WHERE BOATBUILDING__Contact_Email__c IN: mapAccountEmail.keySet() AND
                                           BOATBUILDING__Lead_Account_History__c = Null AND RecordType.Name ='Prospect' AND CreatedDate < :Datetime.now().addMinutes(-1)];
        
        Map<String, Account> mapofParentAcc = new Map<String, Account>();
        for(Account acc: listParentAccount){
            
            mapofParentAcc.put(acc.BOATBUILDING__Email__c, acc);
        }
        
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Account> listAccountToUpsert = new List<Account>();
        Id salesManagerId = fetchSalesManagerId();
        for(Account objacc :listEmailAccountToProcess){
            System.debug('mapofParentAcc---'+mapofParentAcc);
            if(mapofParentAcc.containsKey(objacc.BOATBUILDING__Email__c)){  //Repeated customer, Assign it to an existing Account
                Account a = new Account(Id=objAcc.Id);
                a.Name = mapofParentAcc.get(objacc.BOATBUILDING__Email__c).Name + '('+objacc.BOATBUILDING__lead_Source__c+')';
                a.BOATBUILDING__Lead_Account_History__c = mapofParentAcc.get(objacc.BOATBUILDING__Email__c).Id;
                a.BOATBUILDING__Store_Location__c = mapofParentAcc.get(objacc.BOATBUILDING__Email__c).BOATBUILDING__Store_Location__c;
                
                if(mapofParentAcc.get(objacc.BOATBUILDING__Email__c).BOATBUILDING__Owner_IsActive__c){
                    a.OwnerId = mapofParentAcc.get(objacc.BOATBUILDING__Email__c).OwnerId;
                } else {
                    a.OwnerId = salesManagerId;
                }
                
                System.debug('Here In If'+ objAcc);
                System.debug('Here In If'+ a);
                listAccountToUpsert.add(a);
            } else {      //New customer, Create Master Record and Do Round Robin for Child
                Account a = new Account();
                a.Name = objacc.BOATBUILDING__Prospect_Last_Name__c+', '+objacc.BOATBUILDING__Prospect_First_Name__c;
                a.Email__c = objacc.BOATBUILDING__Email__c;
                a.Contact_Email__c = objacc.BOATBUILDING__Email__c;
                a.BOATBUILDING__Contact_Phone__c = objAcc.BOATBUILDING__Contact_Phone__c;
                a.RecordTypeId = prospectRecordTypeId;
                System.debug('Here In else' + a);
                System.debug('Here In else'+ objAcc);
                listAccountToUpsert.add(a); // Parent Record for New Account
                MapNewAccountToProcess.put(objacc.BOATBUILDING__Email__c,objAcc); // Child Record which is New Account and input for Round Robin method
            }
        }
        
        System.debug('listAccountToUpsert--'+listAccountToUpsert);
        if(!listAccountToUpsert.isEmpty()){
            upsert listAccountToUpsert;
        }
        
        // Get Lead Source to User Role mapping to process Round Robin based on BOATBUILDING__RoundRobin_Config__c Custom Setting
        List<BOATBUILDING__RoundRobin_Config__c> listRoundRobinConfig = BOATBUILDING__RoundRobin_Config__c.getAll().values();
        
        Map<string,string> mapLeadSourceToUserRole = new Map<string,string>();
        for(BOATBUILDING__RoundRobin_Config__c objRRConfig :listRoundRobinConfig){
            mapLeadSourceToUserRole.put(objRRConfig.BOATBUILDING__Lead_Source__c, objRRConfig.BOATBUILDING__User_Role_Name__c);
        }
        

        String storeLocToUserRole = '';
        List<Account> listChildAccountToRoundRobin = new List<Account>();
        for(Account acc: listAccountToUpsert){
            System.debug('-------------225'+MapNewAccountToProcess.containsKey(acc.BOATBUILDING__Email__c));
            if(MapNewAccountToProcess.containsKey(acc.BOATBUILDING__Email__c)){
                System.debug('MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c)--'+MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c));
                Account a = new Account(Id = MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c).Id);
                
                a.BOATBUILDING__Lead_Account_History__c = acc.Id;
                a.BOATBUILDING__Store_Location__c = acc.BOATBUILDING__Store_Location__c;
                a.BOATBUILDING__lead_Source__c = MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c).BOATBUILDING__lead_Source__c;
                //a.Name = MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c).Name + '('+a.BOATBUILDING__lead_Source__c+')';
                a.Name = acc.Name + '('+a.BOATBUILDING__lead_Source__c+')';
                String storeLoc = '';
                if(String.isNOTBlank(MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c).BOATBUILDING__Store_Location__c)){
                    storeLoc = MapNewAccountToProcess.get(acc.BOATBUILDING__Email__c).BOATBUILDING__Store_Location__c;
                } else {
                    storeLoc = getDefaultStoreLocation();
                }
                
                String userRole = '';
                if(mapLeadSourceToUserRole.containsKey(a.BOATBUILDING__lead_Source__c)){
                    userRole = mapLeadSourceToUserRole.get(a.BOATBUILDING__lead_Source__c);
                }
                storeLocToUserRole = storeLoc+userRole;
                System.debug('leadSourceAccountHistory'+a.BOATBUILDING__Lead_Account_History__c);
                listChildAccountToRoundRobin.add(a);
            }
        }
        
        System.debug('listChildAccountToRoundRobin--198'+listChildAccountToRoundRobin);
        System.debug('setStoreLocToRole--198'+storeLocToUserRole);
        if(!listChildAccountToRoundRobin.isEmpty()){
            doRoundRobin(listChildAccountToRoundRobin, storeLocToUserRole);
        }
    }
    
    public static void doRoundRobin(List<Account> newListAccounts, String strStoreLocationwithUserRole){
        Map<Id,Account> mapAccountToUpdate = new Map<Id,Account>();
        List<User> listUserToUpdate = new List<User>();
        System.debug('newListAccounts--'+newListAccounts);
        List<User> listAvailableReps = [SELECT Id, Name, Next_Available_for_Assingment__c, 
                                        Assignment_order__c FROM User
                                        WHERE BOATBUILDING__StoreLocationWithRole__c =: strStoreLocationwithUserRole 
                                        AND isActive = True
                                        ORDER BY Assignment_order__c DESC];
        
        Integer intAssignmentOrder = 0;
        //String currentUserId = '';
        for(Account acc: newListAccounts){
            System.debug('acc--'+acc);
            Account objParentAccount = new Account(Id = acc.BOATBUILDING__Lead_Account_History__c);
            Account objAccount = new Account(Id = acc.Id);
            objAccount.BOATBUILDING__lead_Source__c = acc.BOATBUILDING__lead_Source__c;
            objAccount.Name = acc.Name;
            objAccount.BOATBUILDING__Notify_Account_Owner__c = true;
            // below two lines weren't added. 
            objAccount.BOATBUILDING__Lead_Account_History__c = acc.BOATBUILDING__Lead_Account_History__c;
            objAccount.BOATBUILDING__Store_Location__c = acc.BOATBUILDING__Store_Location__c;
            for(User objUser: listAvailableReps){
                if(objUser.Next_Available_for_Assingment__c){
                    objAccount.OwnerId = objUser.Id;
                    objParentAccount.OwnerId = objUser.Id;
                    System.debug('objUser.Next_Available_for_Assingment__c--'+objUser.Next_Available_for_Assingment__c);
                    intAssignmentOrder = Integer.valueOf(objUser.Assignment_order__c);
                    objUser.Next_Available_for_Assingment__c = False;
                    //currentUserId = objUser.Id;
                    listUserToUpdate.add(objUser);
                    System.debug('objAccount--'+objAccount);
                    
                }
            }
            mapAccountToUpdate.put(objParentAccount.Id, objParentAccount);
            mapAccountToUpdate.put(objAccount.Id, objAccount);
        }
        if(!mapAccountToUpdate.Values().isEmpty()){
            Update mapAccountToUpdate.Values();
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
    
    public static void updateReferralForm(List<Account> newLstAccount){
        
        Id referralRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Referral Program').getRecordTypeId();
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Map<String, Account> mapEmailToAcc = new Map<String, Account>();
        Set<String> setAccEmail = new Set<String>();
        for(Account acc: newLstAccount){
            if(acc.BOATBUILDING__Lead_Source__c == 'Referral Program' && String.isNotBlank(acc.BOATBUILDING__Email__c)){
                setAccEmail.add(acc.BOATBUILDING__Email__c);
            }
        }
        
        List<Account> listAccountToProcess = [SELECT Id, Name, OwnerId, BOATBUILDING__Owner_IsActive__c , BOATBUILDING__Email__c FROM Account WHERE BOATBUILDING__Email__c IN: setAccEmail];
        
        for(Account acc: listAccountToProcess){
            mapEmailToAcc.put(acc.BOATBUILDING__Email__c, acc);
        }
        
        Map<String, Account> mapEmailToParentAcc = new Map<String, Account>();
        List<Account> lstAccountParent = new List<Account>();
        Id salesManagerId = fetchSalesManagerId();
        
        for(Account a: newLstAccount){
            //if(!listAccountToProcess.isEmpty()){
            System.debug('mapEmailToAcc.keySet()---'+mapEmailToAcc.containsKey(a.BOATBUILDING__Email__c));
            //System.debug('mapEmailToAcc.keySet()---'+mapEmailToAcc.get(a.BOATBUILDING__Email__c).Id);
            if(mapEmailToAcc.containsKey(a.BOATBUILDING__Email__c) && mapEmailToAcc.get(a.BOATBUILDING__Email__c).Id != null){
                Id accId = mapEmailToAcc.get(a.BOATBUILDING__Email__c).Id;
                Id accOwnerId;
                if(mapEmailToAcc.get(a.BOATBUILDING__Email__c).BOATBUILDING__Owner_IsActive__c){
                    accOwnerId = mapEmailToAcc.get(a.BOATBUILDING__Email__c).OwnerId; 
                } else {
                    accOwnerId = salesManagerId;
                }
                
                a.BOATBUILDING__Prospect_First_Name__c = a.BOATBUILDING__Friends_First_Name__c;
                a.BOATBUILDING__Prospect_Last_Name__c = a.BOATBUILDING__Friends_Last_Name__c;
                a.BOATBUILDING__Prospect_Mobile_Phone_Number__c = a.BOATBUILDING__Friends_Phone__c;
                a.BOATBUILDING__Email__c = a.BOATBUILDING__Friends_Email__c;
                a.BOATBUILDING__Contact_Email__c = a.BOATBUILDING__Friends_Email__c;
                a.BOATBUILDING__Prospect_City__c = a.BOATBUILDING__Friends_City__c;
                a.BOATBUILDING__Referral__c = accId;
                a.RecordTypeId = referralRecordTypeId;
                a.OwnerId = accOwnerId;
                a.Name = a.BOATBUILDING__Friends_First_Name__c+' '+a.BOATBUILDING__Friends_Last_Name__c;
                System.debug('After Update'+a);
            } else {
                Account accParent = new Account();
                accParent.Name = a.BOATBUILDING__Prospect_First_Name__c+' '+a.BOATBUILDING__Prospect_Last_Name__c;
                accParent.BOATBUILDING__Prospect_First_Name__c = a.BOATBUILDING__Prospect_First_Name__c;
                accParent.BOATBUILDING__Prospect_Last_Name__c = a.BOATBUILDING__Prospect_Last_Name__c;
                accParent.BOATBUILDING__Prospect_Mobile_Phone_Number__c = a.BOATBUILDING__Prospect_Mobile_Phone_Number__c;
                accParent.BOATBUILDING__Email__c = a.BOATBUILDING__Email__c;
                accParent.BOATBUILDING__Contact_Email__c = a.BOATBUILDING__Email__c;
                accParent.RecordTypeId = prospectRecordTypeId;
                accParent.OwnerId = salesManagerId;
                lstAccountParent.add(accParent);
            }
            /*} else {
                Account accParent = new Account();
                accParent.Name = a.BOATBUILDING__Prospect_First_Name__c+' '+a.BOATBUILDING__Prospect_Last_Name__c;
                accParent.BOATBUILDING__Prospect_First_Name__c = a.BOATBUILDING__Prospect_First_Name__c;
                accParent.BOATBUILDING__Prospect_Last_Name__c = a.BOATBUILDING__Prospect_Last_Name__c;
                accParent.BOATBUILDING__Prospect_Mobile_Phone_Number__c = a.BOATBUILDING__Prospect_Mobile_Phone_Number__c;
                accParent.BOATBUILDING__Email__c = a.BOATBUILDING__Email__c;
                accParent.BOATBUILDING__Contact_Email__c = a.BOATBUILDING__Email__c;
                accParent.RecordTypeId = prospectRecordTypeId;
                accParent.OwnerId = salesManagerId;
                lstAccountParent.add(accParent);
            }*/
        }
        
        if(!lstAccountParent.isEmpty()){
            insert lstAccountParent;
            for(Account acc: lstAccountParent){
                mapEmailToParentAcc.put(acc.BOATBUILDING__Email__c, acc);
            }
        }
        
        for(Account a: newLstAccount){
            if(mapEmailToParentAcc.containsKey(a.BOATBUILDING__Email__c)){
                System.debug('mapEmailToAcc-000---'+mapEmailToAcc);
                Id accId = mapEmailToParentAcc.get(a.BOATBUILDING__Email__c).Id;
                System.debug('accId00---'+accId);
                Id accOwnerId;
                if(mapEmailToAcc.get(a.BOATBUILDING__Email__c).BOATBUILDING__Owner_IsActive__c){
                    accOwnerId = mapEmailToAcc.get(a.BOATBUILDING__Email__c).OwnerId; 
                } else {
                    accOwnerId = salesManagerId; 
                }
                a.BOATBUILDING__Prospect_First_Name__c = a.BOATBUILDING__Friends_First_Name__c;
                a.BOATBUILDING__Prospect_Last_Name__c = a.BOATBUILDING__Friends_Last_Name__c;
                a.BOATBUILDING__Prospect_Mobile_Phone_Number__c = a.BOATBUILDING__Friends_Phone__c;
                a.BOATBUILDING__Email__c = a.BOATBUILDING__Friends_Email__c;
                a.BOATBUILDING__Contact_Email__c = a.BOATBUILDING__Friends_Email__c;
                a.BOATBUILDING__Prospect_City__c = a.BOATBUILDING__Friends_City__c;
                a.BOATBUILDING__Referral__c = accId;
                a.RecordTypeId = referralRecordTypeId;
                a.OwnerId = accOwnerId;
            }
        }
    }
    
    public static void cobuyerFirstLast(List<Account> lstAccount, Map<Id, Account> oldMapAccount){
        Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        List<Contact> lstContact = new List<Contact>();
        for(Account objAccount : lstAccount){
            if(objAccount.RecordTypeId != null && objAccount.RecordTypeId == prospectRecordTypeId){
                
                Contact objContact = new Contact();
                
                if(oldMapAccount.get(objAccount.Id).BOATBUILDING__Contact_First_Name__c != objAccount.BOATBUILDING__Contact_First_Name__c && 
                   oldMapAccount.get(objAccount.Id).BOATBUILDING__Contact_Last_Name__c != objAccount.BOATBUILDING__Contact_Last_Name__c&&objAccount.BOATBUILDING__Contact_First_Name__c != null && objAccount.BOATBUILDING__Contact_Last_Name__c != null){
                       objContact.FirstName = objAccount.BOATBUILDING__Contact_First_Name__c;
                       objContact.AccountId = objAccount.Id;
                       objContact.LastName = objAccount.BOATBUILDING__Contact_Last_Name__c;
                       lstContact.add(objContact);
                       
                   } 
            }
            
        }
        if(!lstContact.isEmpty()){
            insert lstContact;      
        } 
        
    }
    
    public static Id fetchSalesManagerId(){
        
        Id salesManagerId = null;
        List<User> listSalesManager = [SELECT Id, Name FROM User WHERE UserRole.DeveloperName = 'Sales_Manager' AND isActive = True LIMIT 1];
        
        if(!listSalesManager.isEmpty()){
            salesManagerId = listSalesManager[0].Id;
        }
        return salesManagerId;
    }
    
    public static String getDefaultStoreLocation(){
        
        //Default Store Location
        String defaultVal;
        Schema.DescribeFieldResult F = Account.BOATBUILDING__Store_Location__c.getDescribe();
        List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
        for (Schema.PicklistEntry pv: pickVals) {
            if (pv.isDefaultValue()) {
                defaultVal = pv.getValue();
            }    
        }
        
        return defaultVal;
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