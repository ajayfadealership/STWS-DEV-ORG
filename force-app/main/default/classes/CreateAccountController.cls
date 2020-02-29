public with sharing class CreateAccountController {
    public Account objAccount { get; set; }
    public BOATBUILDING__Work_Order__c objWO { get; set; }
    public BOATBUILDING__Item__c objItm { get; set; }
    public BOATBUILDING__Manufacturer__c objManuf {get; set;}
    public Boolean isManufacturerSaved {get; set;}
    
    public CreateAccountController() {
        objAccount = new Account();
        objItm = new BOATBUILDING__Item__c();
        objWO = new BOATBUILDING__Work_Order__c();
        objManuf = new BOATBUILDING__Manufacturer__c();
        isManufacturerSaved = False;
    }
    
    @RemoteAction
    public static List<Contact> fetchContact(String conId) {
        return [Select 
                Id, 
                FirstName, 
                LastName, 
                Email, 
                Phone, 
                Account.Lead_Source__c, 
                AccountId, 
                Customer_Type__c,
                Account.BillingStreet, 
                Account.BillingPostalCode, 
                Account.BillingState,
                Account.BillingCity,
                Account.ShippingStreet, 
                Account.ShippingPostalCode, 
                Account.ShippingState,
                Account.ShippingCity
                From 
                Contact Where Id =: conId Limit 1];
    }
    
    @RemoteAction
    public static String SaveAccount(Map<String, String> mapAccountDetails) {
        Contact objContact = new Contact(); 
        if(String.isNotBlank(mapAccountDetails.get('AccountName'))) { 
            objContact = [Select 
                          Id, 
                          FirstName, 
                          LastName, 
                          Email, 
                          Phone, 
                          Account.Lead_Source__c, 
                          AccountId, 
                          Account.BillingStreet, 
                          Account.BillingPostalCode, 
                          Account.BillingState, 
                          Account.BillingCity,
                          Account.ShippingStreet, 
                          Account.ShippingPostalCode, 
                          Account.ShippingState,
                          Account.ShippingCity
                          From 
                          Contact Where Id =: mapAccountDetails.get('AccountName') Limit 1];
            objContact.FirstName = mapAccountDetails.get('FirstName');
            objContact.LastName = mapAccountDetails.get('LastName');
            objContact.Email = mapAccountDetails.get('Email');
            objContact.Phone = mapAccountDetails.get('Phone');
            objContact.MailingStreet = mapAccountDetails.get('BillingStreet');
            objContact.MailingPostalCode = mapAccountDetails.get('BillingPostalCode');
            objContact.MailingState = mapAccountDetails.get('BillingState');
            objContact.MailingCity = mapAccountDetails.get('BillingCity');
            objContact.OtherStreet = mapAccountDetails.get('ShippingStreet');
            objContact.OtherPostalCode = mapAccountDetails.get('ShippingZip');
            objContact.OtherState = mapAccountDetails.get('ShippingState'); 
            try {
                update objContact;
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex+'-error-'+ex.getStackTraceString());
                return ''+ex+'--'+ex.getStackTraceString();
            }
        } else {
            System.debug('Debug Log For Check:');
            Account objAccount = new Account();
            List<RecordType> lstRecType = [Select Id From RecordType Where SobjectType = 'Account' AND DeveloperName = 'Prospect' Limit 1];
            if(lstRecType.size() > 0) {
                objAccount.RecordTypeId = lstRecType[0].Id;
            }
            
            objAccount.OwnerId = UserInfo.getUserId();
            objAccount.Name = mapAccountDetails.get('FirstName') + ' ' + mapAccountDetails.get('LastName'); 
            objAccount.BOATBUILDING__Prospect_First_Name__c = mapAccountDetails.get('FirstName');
            objAccount.BOATBUILDING__Prospect_Last_Name__c = mapAccountDetails.get('LastName');
            objAccount.Email__c = mapAccountDetails.get('Email');
            objAccount.Phone = mapAccountDetails.get('Phone');
            objAccount.Lead_Source__c = mapAccountDetails.get('LeadSource');
            objAccount.Account_Customer_Type__c = mapAccountDetails.get('CustmerType');
            objAccount.BOATBUILDING__Store_Location__c = mapAccountDetails.get('storeLocation');
            objAccount.BillingStreet = mapAccountDetails.get('BillingStreet');
            objAccount.BillingPostalCode = mapAccountDetails.get('BillingPostalCode');
            objAccount.BillingState = mapAccountDetails.get('BillingState');
            objAccount.BillingCity = mapAccountDetails.get('BillingCity');
            objAccount.ShippingStreet = mapAccountDetails.get('ShippingStreet');
            objAccount.ShippingPostalCode = mapAccountDetails.get('ShippingZip');
            objAccount.ShippingState = mapAccountDetails.get('ShippingState');
            objAccount.ShippingCity = mapAccountDetails.get('ShippingCity');
            
            try {
                insert objAccount;
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex+'-error-'+ex.getStackTraceString());
                return ''+ex+'---'+ex.getStackTraceString();
            }
            if(objAccount.Id != null) {
                List<Contact> lstcon = [Select FirstName, LastName, Email, Phone, MailingStreet, MailingPostalCode, MailingState, OtherStreet, OtherPostalCode, OtherState From Contact Where AccountId =: objAccount.Id LIMIT 1];
                if(lstcon.size() > 0){
                    objContact =lstcon[0];
                    objContact.FirstName = mapAccountDetails.get('FirstName');
                    objContact.LastName = mapAccountDetails.get('LastName');
                    objContact.Email = mapAccountDetails.get('Email');
                    objContact.Phone = mapAccountDetails.get('Phone');
                    objContact.MailingStreet = mapAccountDetails.get('BillingStreet');
                    objContact.MailingPostalCode = mapAccountDetails.get('BillingPostalCode');
                    objContact.MailingState = mapAccountDetails.get('BillingState');
                    objContact.MailingCity = mapAccountDetails.get('BillingCity');
                    objContact.OtherStreet = mapAccountDetails.get('ShippingStreet');
                    objContact.OtherPostalCode = mapAccountDetails.get('ShippingZip');
                    objContact.OtherState = mapAccountDetails.get('ShippingState');
                    try {
                        update objContact;
                    }
                    catch(Exception ex) {
                        System.debug('Debug Log For Exception: '+ex+'-error-'+ex.getStackTraceString());
                        return ''+ex+'--'+ex.getStackTraceString();
                    }
                }
            }
        }
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c(); 
        if(mapAccountDetails.get('ItemStatus') != 'NO') {
          
            objItem.Name = mapAccountDetails.get('BoatName');
            System.debug('objItem.Name---'+objItem.Name);
            if(mapAccountDetails.get('engName') != null && mapAccountDetails.get('engName') != '' && mapAccountDetails.get('EngineSN') != ''){
                 objItem.Name = mapAccountDetails.get('engName');
            }
             System.debug('objItem.Name---2'+objItem.Name);
            objItem.Boat_HIN_No__c =  mapAccountDetails.get('BoatHIN');
            objItem.Engine_SN__c =  mapAccountDetails.get('EngineSN');
            objItem.Engine_SN__c =  mapAccountDetails.get('EngSN');
            objItem.BOATBUILDING__Engine_Model__c =  mapAccountDetails.get('Engmodle');
            objItem.BOATBUILDING__Engine_Year__c =  mapAccountDetails.get('EngYear');
            String engDateValue = mapAccountDetails.get('EngManuDate');
            if(String.isNotBlank(engDateValue)){
               date mydate = date.parse(engDateValue);
            	objItem.BOATBUILDING__Engine_Manufacture_Date__c = mydate;
            }
            
			
            if(mapAccountDetails.containsKey('BoatMake') && mapAccountDetails.get('BoatMake').trim() != '') {
                objItem.Boat_Manufacturer__c =  mapAccountDetails.get('BoatMake');
            }
            if(mapAccountDetails.containsKey('EngMake') && mapAccountDetails.get('EngMake').trim() != '') {
                objItem.BOATBUILDING__Engine_Manufacturer__c =  mapAccountDetails.get('EngMake');
            }
            if(mapAccountDetails.containsKey('BoatModel') )
            {
                objItem.Boat_Model__c =  mapAccountDetails.get('BoatModel');
            }
            if(mapAccountDetails.containsKey('BoatYear'))
            {
                objItem.M_Boat_Year__c =  mapAccountDetails.get('BoatYear');
            }
            if(mapAccountDetails.containsKey('BoatRegistrationNumber') && mapAccountDetails.get('BoatRegistrationNumber') != null)
            {
                objItem.Boat_Registration_Number__c = mapAccountDetails.get('BoatRegistrationNumber');
            }
            if(objContact.Id != null) {
                objItem.Contact__c = objContact.Id; 
            }
            try {
                 System.debug('objItem.Name--- before insert'+objItem.Name);
                insert objItem;
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex+'-error-'+ex.getStackTraceString());
                return ''+ex+'----'+ex.getStackTraceString();
            }
        }
        return objContact.Id+':'+objContact.FirstName+ ' ' + objContact.LastName+ ' '+objItem.Id; 
    }
    
    @RemoteAction
    public static BOATBUILDING__Manufacturer__c createManufacturer(Map<String, String> mapManufacturerDetails) {
        BOATBUILDING__Manufacturer__c objManuf = new BOATBUILDING__Manufacturer__c();
        objManuf.Name = mapManufacturerDetails.get('ManufName');
        objManuf.BOATBUILDING__Manufacturer_name__c = mapManufacturerDetails.get('ManufId');
        objManuf.BOATBUILDING__Terms__c  = mapManufacturerDetails.get('manufTerms');
        objManuf.BOATBUILDING__Email__c = mapManufacturerDetails.get('manufEmail');
        objManuf.BOATBUILDING__Phone__c = mapManufacturerDetails.get('manufPhone');
        objManuf.BOATBUILDING__Model_Variant__c = Boolean.valueOf(mapManufacturerDetails.get('manufMV'));
        objManuf.BOATBUILDING__Street__c = mapManufacturerDetails.get('manufStreet');
        objManuf.BOATBUILDING__City__c = mapManufacturerDetails.get('manufCity');
        objManuf.BOATBUILDING__State__c = mapManufacturerDetails.get('manufState');
        objManuf.BOATBUILDING__Zip__c = mapManufacturerDetails.get('manufZip');
        
        try {
            insert objManuf;
        }
        catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex);
            return null;
        }
        return objManuf;
    }
}