@RestResource(urlMapping = '/GetInstantQuote')
global class GetInstantQuote {
    
    @HttpGet
    global static String doGetInstantQuote() {
        String strInventoryName = RestContext.request.params.get('InventoryId');
        String strZipCode = RestContext.request.params.get('ZipCode');
        String strCustomerEmail = RestContext.request.params.get('CustomerEmail');
        String strFirstName = RestContext.request.params.get('FirstName');
        String strLastName = RestContext.request.params.get('LastName');
        String isTrade = RestContext.request.params.get('BOATBUILDING__Do_they_have_a_Trade2__c');
        String tradeMake = RestContext.request.params.get('BOATBUILDING__Trade_Make__c');
        String tradeModel = RestContext.request.params.get('BOATBUILDING__Trade_Model__c');
        String tradeYear = RestContext.request.params.get('BOATBUILDING__Trade_Year__c');
        String tradeHrs = RestContext.request.params.get('BOATBUILDING__Trade_Boat_Hrs__c');
        String strIPAddress = RestContext.request.params.get('IpAddress');
        String strStoreLocation = RestContext.request.params.get('StoreLocation');
        
        String BuyingTimeFrame = RestContext.request.params.get('BuyingTimeFrame');
        String OtherBrands = RestContext.request.params.get('OtherBrands');
        String PurchasePlan = RestContext.request.params.get('PurchasePlan');
        
        GetAQuoteWrapper objWrap = new GetAQuoteWrapper(null, false, null);
        if(String.isBlank(strInventoryName)) {
            objWrap = new GetAQuoteWrapper('No Inventory Found.', false, null);
            return JSON.serialize(objWrap);
        } else if(String.isBlank(strCustomerEmail)){
            objWrap = new GetAQuoteWrapper('No Customer Email Found.', false, null);
            return JSON.serialize(objWrap);
        } else {
            Id getAQuoteRecordTypeId = Schema.SObjectType.BOATBUILDING__Customer_Inquiry__c.getRecordTypeInfosByName().get('Get A Quote').getRecordTypeId();
            
            BOATBUILDING__Customer_Inquiry__c objCI = new BOATBUILDING__Customer_Inquiry__c();
            objCI.BOATBUILDING__Email__c = strCustomerEmail;
            objCI.BOATBUILDING__First_Name__c = strFirstName;
            objCI.BOATBUILDING__Last_Name__c = strLastName;
            objCI.BOATBUILDING__Zip_Code__c = strZipCode;
            objCI.Do_they_have_a_Trade__c = Boolean.valueOf(isTrade);
            objCI.Trade_Make__c = tradeMake;
            objCI.Trade_Model__c = tradeModel;
            objCI.Trade_Year__c = tradeYear;
            objCI.Trade_Boat_Hours__c = tradeHrs;
            objCI.IP_Address__c = strIPAddress;
            objCI.BOATBUILDING__Lead_Source__c = 'Instant Quote';
            objCI.BOATBUILDING__Product_Id__c = strInventoryName;
            objCI.BOATBUILDING__IsCreatedFromWeb__c = True;
            objCI.BOATBUILDING__Buying_Time_Frame__c = BuyingTimeFrame;
            objCI.BOATBUILDING__Other_Brands__c = OtherBrands;
            objCI.BOATBUILDING__Purchase_Plan__c = PurchasePlan;
            insert objCI;
            
            BOATBUILDING__Customer_Inquiry__c objCIInserted = [SELECT Id, Name, BOATBUILDING__Account__c 
                                                               FROM BOATBUILDING__Customer_Inquiry__c 
                                                               WHERE Id =: objCI.Id];
            System.debug('objCIInserted---'+objCIInserted);
            
            List<BOATBUILDING__Inventory__c> listInvToFetch = [SELECT Id, Name, BOATBUILDING__Manufacturer__c 
                                                               FROM BOATBUILDING__Inventory__c 
                                                               WHERE Name =: strInventoryName LIMIT 1];
            if(listInvToFetch.isEmpty()){
                objWrap = new GetAQuoteWrapper('Inventory does not Exist.', false, null);
                return JSON.serialize(objWrap);
            }
            
            Boolean zipCodeExist = False;
            String strState = '';    
            Decimal docFee = 0.00, regFee = 0.00, trailerFee = 0.00;
            if(String.isNotBlank(strZipCode)){
                List<BOATBUILDING__HomeZipCode__c> listMDT = [SELECT Id,Name, BOATBUILDING__Manufacturer__c, BOATBUILDING__Trailer_Registration_Fee__c, 
                                                              BOATBUILDING__Zip_Code__c, BOATBUILDING__State__c, BOATBUILDING__Doc_Fee__c, BOATBUILDING__Registration_Fee__c  
                                                              FROM BOATBUILDING__HomeZipCode__c 
                                                              WHERE BOATBUILDING__Zip_Code__c =: strZipCode AND 
                                                              BOATBUILDING__Manufacturer__c =: listInvToFetch[0].BOATBUILDING__Manufacturer__c];
                if(!listMDT.isEmpty()){
                    zipCodeExist = True;
                    strState = listMDT[0].BOATBUILDING__State__c != null ? listMDT[0].BOATBUILDING__State__c : '';
                    docFee = listMDT[0].BOATBUILDING__Doc_Fee__c != null ? listMDT[0].BOATBUILDING__Doc_Fee__c : 0.00;
                    regFee = listMDT[0].BOATBUILDING__Registration_Fee__c != null ? listMDT[0].BOATBUILDING__Registration_Fee__c : 0.00;
                    trailerFee = listMDT[0].BOATBUILDING__Trailer_Registration_Fee__c != null ? listMDT[0].BOATBUILDING__Trailer_Registration_Fee__c : 0.00;
                }
            }
            
            
            
            BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
            objQuote = GetAQuoteUtility.generateQuote(String.valueOf(objCIInserted.BOATBUILDING__Account__c),
                                                      listInvToFetch[0].Id, null, null, objQuote, zipCodeExist, strState, strStoreLocation);
            BOATBUILDING__ACV_Form__c objAVC = new BOATBUILDING__ACV_Form__c();
            if(Boolean.valueOf(isTrade)) {
                List<Contact> lstContact = [SELECT Id FROM Contact Where AccountId =: objCIInserted.BOATBUILDING__Account__c];
                objAVC.Name = strFirstName +' '+strLastName;
                objAVC.BOATBUILDING__ACV_Form_Name__c = strFirstName +' '+strLastName;
                objAVC.BOATBUILDING__Account__c = objCIInserted.BOATBUILDING__Account__c ;
                if(!lstContact.isEmpty()) {
                    objAVC.BOATBUILDING__Contact_Name__c = lstContact[0].Id;
                }
                objAVC.BOATBUILDING__BoatMake__c = tradeMake;
                objAVC.BOATBUILDING__BoatModel__c = tradeModel;
                objAVC.BOATBUILDING__BoatYear__c = tradeYear;
                objAVC.BOATBUILDING__High_Comp_1_Amount__c = 0;
                objAVC.BOATBUILDING__High_Comp_2_Amount__c = 0;
                objAVC.BOATBUILDING__High_Comp_3_Amount__c = 0;
                objAVC.BOATBUILDING__Low_Comp_1_Amount__c = 0;
                objAVC.BOATBUILDING__Low_Comp_2_Amount__c = 0;
                insert objAVC; 
                objQuote.BOATBUILDING__ACV_FORM__c = objAVC.Id;
            }      
            objQuote.BOATBUILDING__Customer_Inquiry__c = objCI.Id;
            objQuote.BOATBUILDING__Quote_Doc_Fee__c = docFee;
            objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c = regFee;
            objQuote.BOATBUILDING__Quote_Trailer_Reg_Fee__c = trailerFee;
            update objQuote;
            
            if(objQuote != null){
                String siteBaseURL = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c;
                String quotePDFURL = siteBaseURL+'/apex/BOATBUILDING__QuotePDFPreviewskp?id='+objQuote.Id;
                objWrap = new GetAQuoteWrapper('SUCCESS', zipCodeExist, objQuote, quotePDFURL);
            } else {
                objWrap = new GetAQuoteWrapper('FAILED', zipCodeExist, objQuote);
            }
            return JSON.serialize(objWrap);
        }
    } 
    
    global Class GetAQuoteWrapper {
        global String message; 
        global Boolean zipCodeExist;
        global BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        global String attachmentURL;
        
        global GetAQuoteWrapper(String message, Boolean zipCodeExist, BOATBUILDING__Quote__c objQuote){
            this.message = message;
            this.zipCodeExist = zipCodeExist;
            this.objQuote = objQuote;
        }
        
        global GetAQuoteWrapper(String message, Boolean zipCodeExist, BOATBUILDING__Quote__c objQuote, String attachmentURL){
            this.message = message;
            this.zipCodeExist = zipCodeExist;
            this.objQuote = objQuote;
            this.attachmentURL = attachmentURL;
        }
    }
}