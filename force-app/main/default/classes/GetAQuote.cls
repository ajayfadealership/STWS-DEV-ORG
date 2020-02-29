@RestResource(urlMapping = '/GetAQuote')
global class GetAQuote {
    @HttpGet
    global static GetAQuoteWrapper doGet() {
        String strInventoryName = RestContext.request.params.get('InventoryId');
        String strZipCode = RestContext.request.params.get('ZipCode');
        String strCustomerEmail = RestContext.request.params.get('CustomerEmail');
        String strFirstName = RestContext.request.params.get('FirstName');
        String strLastName = RestContext.request.params.get('LastName');
        
        GetAQuoteWrapper objWrap = new GetAQuoteWrapper(null, false, null);
        if(String.isBlank(strInventoryName)) {
            objWrap = new GetAQuoteWrapper('No Inventory Found.', false, null);
            return objWrap;
        } else if(String.isBlank(strCustomerEmail)){
            objWrap = new GetAQuoteWrapper('Customer Email does not Exist.', false, null);
            return objWrap;
        } else {
            List<Account> listAccToFetch = [SELECT Id, Name FROM Account WHERE 
                                            (BOATBUILDING__Email__c =: strCustomerEmail 
                                             OR BOATBUILDING__Contact_Email__c =: strCustomerEmail) 
                                            AND BOATBUILDING__Lead_Account_History__c = null];
            
            BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
            Account newAcc = new Account();
            if(!listAccToFetch.isEmpty()){
                newAcc = listAccToFetch[0];
            } else {
                
                newAcc.Name = strFirstName + ' ' + strLastName;
                newAcc.BOATBUILDING__Email__c = strCustomerEmail;
                newAcc.BOATBUILDING__Prospect_First_Name__c = strFirstName;
                newAcc.BOATBUILDING__Prospect_Last_Name__c = strLastName;
                if(newAcc.Name != null){
                    insert newAcc;
                }
                //firstnaME, LnAME ,Name*, AccEmail
                //
                
            }
            List<BOATBUILDING__Inventory__c> listInvToFetch = [SELECT Id, Name FROM BOATBUILDING__Inventory__c WHERE Name =: strInventoryName LIMIT 1];
            objQuote = BBWizardController.generateQuote(String.valueOf(newAcc.Id), listInvToFetch[0].Id, null, null, null, null, null, null, null, objQuote, null);
            
            System.debug('objQuote---'+objQuote);
            Boolean zipCodeExist = False;
            if(String.isNotBlank(strZipCode)){
                List<BOATBUILDING__OurPriceZipCode__mdt> listMDT = [SELECT Label FROM BOATBUILDING__OurPriceZipCode__mdt WHERE Label =: strZipCode];
                if(!listMDT.isEmpty()){
                    zipCodeExist = True;
                }
            }
            
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