@RestResource(urlMapping = '/GetAQuote')
global class GetAQuote {
    
    @HttpGet
    global static GetAQuoteWrapper doGet() {
        String strInventoryName = RestContext.request.params.get('InventoryId');
        String strZipCode = RestContext.request.params.get('ZipCode');
        String strCustomerEmail = RestContext.request.params.get('CustomerEmail');
        String strFirstName = RestContext.request.params.get('FirstName');
        String strLastName = RestContext.request.params.get('LastName');
        String strIPAddress = RestContext.request.params.get('IpAddress');
        
        GetAQuoteWrapper objWrap = new GetAQuoteWrapper(null, false, null);
        if(String.isBlank(strInventoryName)) {
            objWrap = new GetAQuoteWrapper('No Inventory Found.', false, null);
            return objWrap;
        } else if(String.isBlank(strCustomerEmail)){
            objWrap = new GetAQuoteWrapper('No Customer Email Found.', false, null);
            return objWrap;
        } else {
            List<Account> listAccToFetch = [SELECT Id, Name FROM Account WHERE 
                                            (BOATBUILDING__Email__c =: strCustomerEmail 
                                             OR BOATBUILDING__Contact_Email__c =: strCustomerEmail) 
                                            AND BOATBUILDING__Lead_Account_History__c = null];
            
            Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
            Account newAcc = new Account();
            if(!listAccToFetch.isEmpty()){
                newAcc = listAccToFetch[0];
            } else {
                newAcc.Name = strFirstName + ' ' + strLastName;
                newAcc.BOATBUILDING__Email__c = strCustomerEmail;
                newAcc.BOATBUILDING__Prospect_First_Name__c = strFirstName;
                newAcc.BOATBUILDING__Prospect_Last_Name__c = strLastName;
                newAcc.RecordTypeId = prospectRecordTypeId;
                newAcc.BOATBUILDING__Lead_Source__c = 'Get a Quote';
                if(!String.isBlank(strZipCode)){
                    newAcc.BOATBUILDING__Prospect_Zip_Code__c = strZipCode;
                } 
                if(newAcc.Name != null){
                    insert newAcc;
                }                
            }
            
            Boolean zipCodeExist = False;
            String strState = '';     
            if(String.isNotBlank(strZipCode)){
                List<BOATBUILDING__OurPriceZipCode__mdt> listMDT = [SELECT Label, BOATBUILDING__State__c FROM BOATBUILDING__OurPriceZipCode__mdt
                                                                    WHERE Label =: strZipCode];  
                                    
                if(!listMDT.isEmpty())
                {
                    zipCodeExist = true;
                    strState = listMDT[0].BOATBUILDING__State__c != null ? listMDT[0].BOATBUILDING__State__c : '' ;
                }
            }
            List<BOATBUILDING__Inventory__c> listInvToFetch = [SELECT Id, Name FROM BOATBUILDING__Inventory__c 
                                                               WHERE Name =: strInventoryName LIMIT 1]; 
            
            objQuote = GetAQuoteUtility.generateQuote(String.valueOf(newAcc.Id), listInvToFetch[0].Id, null, null, objQuote, zipCodeExist, strState, '');
            
            System.debug('objQuote---'+objQuote);
            
            objWrap = new GetAQuoteWrapper('SUCCESS', zipCodeExist, objQuote);
            return objWrap;
        }
    }
    
    global Class GetAQuoteWrapper {
        global String message;
        global Boolean zipCodeExist;
        global BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        
        global GetAQuoteWrapper(String message, Boolean zipCodeExist, BOATBUILDING__Quote__c objQuote){
            this.message = message;
            this.zipCodeExist = zipCodeExist;
            this.objQuote = objQuote;
        }
    }
}