public class SupremeSoftwareXMLGenerate {
    
    //@InvocableMethod
    //public string xmlstring { get; set; }
    @AuraEnabled
    public static String XMLgen(String recordId, String custRecordId) {
        try {
            BOATBUILDING__Quote__c objQuote = [Select Id, BOATBUILDING__Account_Name__r.Id , BOATBUILDING__Quote_Number__c , BOATBUILDING__Booked_Sale_Price__c,BOATBUILDING__Quote_Down_Payment__c, 
                                                BOATBUILDING__Quote_Trade_Allowance__c, BOATBUILDING__Negotiation_Trade_Payoff__c,BOATBUILDING__Quote_Rate__c,
                                                BOATBUILDING__Quote_Total_Amount_Financed_Calculated__c, BOATBUILDING__Quote_Trade_ACV__c, BOATBUILDING__Quote_Doc_Fee__c, BOATBUILDING__Account_Name__r.BillingState,
                                                BOATBUILDING__Quote_Trailer_Reg_Fee__c, BOATBUILDING__Quote_Boat_Reg_Fee__c, BOATBUILDING__Account_Name__r.BillingStreet, BOATBUILDING__Account_Name__r.BillingCity,
                                                BOATBUILDING__Boat_Sales_Tax2__c, BOATBUILDING__Account_Name__r.BillingPostalCode,
                                                BOATBUILDING__Commission__c, BOATBUILDING__Account_Name__r.Phone, BOATBUILDING__Account_Name__r.BOATBUILDING__Work_Phone__c, BOATBUILDING__Account_Name__r.BOATBUILDING__Prospect_Mobile_Phone_Number__c,
                                                BOATBUILDING__Email__c, OwnerId, BOATBUILDING__Test_2__r.Name, BOATBUILDING__Test_2__r.BOATBUILDING__Web_Condition__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__HIN_Number__c, BOATBUILDING__Test_2__r.BOATBUILDING__Year__c, BOATBUILDING__Test_2__r.BOATBUILDING__Manufacturer__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Model__c, BOATBUILDING__Test_2__r.BOATBUILDING__Boat_Weight__c, BOATBUILDING__Test_2__r.BOATBUILDING__Boat_Length_in_feets__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Year__c, BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Make__c,BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Model__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Web_Engine_HP__c,BOATBUILDING__Test_2__r.BOATBUILDING__Used_Boat_HRS__c, BOATBUILDING__Test_2__r.BOATBUILDING__Engine_SN__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Key_Number__c,BOATBUILDING__Test_2__r.BOATBUILDING__Engine_2_SN__c,BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Year__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Make__c,BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Model__c,BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_VIN__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Total_MSRP_Price__c,BOATBUILDING__Test_2__r.BOATBUILDING__Total_Dealer_Price__c,BOATBUILDING__Test_2__r.BOATBUILDING__Web_Fuel_Type__c,
                                                BOATBUILDING__Test_2__r.BOATBUILDING__Web_Hull_Material__c,BOATBUILDING__Test_2__r.BOATBUILDING__Main_color__c, BOATBUILDING__Test_2__r.BOATBUILDING__Accent_color__c,
                                                BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatYear__c,BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatMake__c,BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatModel__c,
                                                BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatHIN__c,BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerMake__c,BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerModel__c,
                                                BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerVin__c,BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatHrs__c
                                                From BOATBUILDING__Quote__c Where Id =: recordId Limit 1];
            
            
            BOATBUILDING__Customer_Inquiry__c objCusInq = [Select BOATBUILDING__Account__r.Id, BOATBUILDING__Social_Security_Number__c, BOATBUILDING__First_Name__c, BOATBUILDING__Last_Name__c, BOATBUILDING__CoApp_Social_Security_Number__c,
                                                            BOATBUILDING__CoApp_First_Name__c, BOATBUILDING__CoApp_Last_Name__c, BOATBUILDING__Date_of_Birth__c, BOATBUILDING__CoApp_Date_of_Birth__c, BOATBUILDING__Drivers_License_Number__c,
                                                            BOATBUILDING__State__c, BOATBUILDING__CoApp_Drivers_License_Number__c, BOATBUILDING__CoApp_State__c 
                                                            From BOATBUILDING__Customer_Inquiry__c Where Id =: custRecordId ORDER BY LastModifiedById DESC Limit 1];
            
            string xmlstring = '';
            DOM.Document doc = new DOM.Document();
            
            dom.XmlNode info = doc.createRootElement('info', null, null);
            dom.XmlNode quoteSSXML= info.addChildElement('', null, null);
            
            quoteSSXML.addChildElement('CustomerDealId', null, null).addTextNode(objQuote.Id);
            //quoteSSXML.addChildElement('CustomerId', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.Id);
            quoteSSXML.addChildElement('TransactionID', null, null).addTextNode(objQuote.BOATBUILDING__Quote_Number__c);
            // quoteSSXML.addChildElement('StatusDate', null, null).addTextNode('09/03/2014');
            quoteSSXML.addChildElement('Price', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Booked_Sale_Price__c));
            // quoteSSXML.addChildElement('Options', null, null).addTextNode('300.00');
            quoteSSXML.addChildElement('Cash', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Down_Payment__c));
            // quoteSSXML.addChildElement('Rebate', null, null).addTextNode('500.00');
            quoteSSXML.addChildElement('Trade', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Trade_Allowance__c));
            //quoteSSXML.addChildElement('Payoff', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Negotiation_Trade_Payoff__c));
            // quoteSSXML.addChildElement('ExtWarranty', null, null).addTextNode('400.00');
            // quoteSSXML.addChildElement('GAPRetail', null, null).addTextNode('400.00');
            // quoteSSXML.addChildElement('AfterMarketAdds', null, null).addTextNode(' ');
            // quoteSSXML.addChildElement('NoOfPays', null, null).addTextNode('60');
            quoteSSXML.addChildElement('IntRate', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Rate__c));
            quoteSSXML.addChildElement('Unpaid', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Total_Amount_Financed_Calculated__c));
            // quoteSSXML.addChildElement('DaysToFirst', null, null).addTextNode('30');
            // quoteSSXML.addChildElement('PaymentType', null, null).addTextNode('Monthly');
            // quoteSSXML.addChildElement('Taxable', null, null).addTextNode('Yes');
            quoteSSXML.addChildElement('ACVTrade', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Trade_ACV__c));
            quoteSSXML.addChildElement('DocFee', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Doc_Fee__c));
            // quoteSSXML.addChildElement('DealerPrep', null, null).addTextNode('280.99');
            quoteSSXML.addChildElement('DmvProcFee', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Trailer_Reg_Fee__c));
            quoteSSXML.addChildElement('OtherFee', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Quote_Boat_Reg_Fee__c));
            // quoteSSXML.addChildElement('FreightFee', null, null).addTextNode('357.14');
            // quoteSSXML.addChildElement('LicenseFee', null, null).addTextNode('3.00');
            //quoteSSXML.addChildElement('SalesTax', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Boat_Sales_Tax2__c));
            //quoteSSXML.addChildElement('DealState', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BillingState);
            //quoteSSXML.addChildElement('DealStateTax', null, null).addTextNode('.00');
            //quoteSSXML.addChildElement('DealStateTaxAmt', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('DealCityTax', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('DealCityTaxAmt', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('DealCountyTax', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('DealCountyTaxAmt', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('AddedTax', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('AddedTaxAmt', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('SalesmanCommAmt', null, null).addTextNode('400.00');
            //quoteSSXML.addChildElement('FIGross', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('SalesGross', null, null).addTextNode(' ');
            quoteSSXML.addChildElement('SalesmanCommAmt', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Commission__c));
            quoteSSXML.addChildElement('SocSecNo', null, null).addTextNode( objCusInq.BOATBUILDING__Social_Security_Number__c != null ? objCusInq.BOATBUILDING__Social_Security_Number__c : '' );
            quoteSSXML.addChildElement('FirstName', null, null).addTextNode( objCusInq.BOATBUILDING__First_Name__c != null ? objCusInq.BOATBUILDING__First_Name__c : '' );
            quoteSSXML.addChildElement('LastName', null, null).addTextNode( objCusInq.BOATBUILDING__Last_Name__c != null ? objCusInq.BOATBUILDING__Last_Name__c : '' );
            // quoteSSXML.addChildElement('MiddleName', null, null).addTextNode(' ');
            quoteSSXML.addChildElement('CoSocSecNo', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_Social_Security_Number__c != null ? objCusInq.BOATBUILDING__CoApp_Social_Security_Number__c : '' );
            quoteSSXML.addChildElement('CoFirstName', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_First_Name__c != null ? objCusInq.BOATBUILDING__CoApp_First_Name__c : '' );
            quoteSSXML.addChildElement('CoLastName', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_Last_Name__c != null ? objCusInq.BOATBUILDING__CoApp_Last_Name__c : '' );
            // quoteSSXML.addChildElement('CoMiddleName', null, null).addTextNode('B');
            // quoteSSXML.addChildElement('CompanyName', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Address1', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BillingStreet);
            //quoteSSXML.addChildElement('City', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BillingCity);
            //quoteSSXML.addChildElement('State', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BillingState);
            //quoteSSXML.addChildElement('Zip', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BillingPostalCode);
                //quoteSSXML.addChildElement('County', null, null).addTextNode('Knox County');
            //quoteSSXML.addChildElement('HomePhone', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.Phone);
            //quoteSSXML.addChildElement('WorkPhone', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BOATBUILDING__Work_Phone__c);
            //quoteSSXML.addChildElement('CellPhone', null, null).addTextNode(objQuote.BOATBUILDING__Account_Name__r.BOATBUILDING__Prospect_Mobile_Phone_Number__c);
            quoteSSXML.addChildElement('BirthDate', null, null).addTextNode(objCusInq.BOATBUILDING__Date_of_Birth__c != null ?  String.valueOf(objCusInq.BOATBUILDING__Date_of_Birth__c) : '' );
            quoteSSXML.addChildElement('CoBirthDate', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_Date_of_Birth__c != null ?  String.valueOf(objCusInq.BOATBUILDING__CoApp_Date_of_Birth__c) : '' );
            //quoteSSXML.addChildElement('SalespersonID', null, null).addTextNode(objQuote.OwnerId);
            //quoteSSXML.addChildElement('EMailAddress', null, null).addTextNode(objQuote.BOATBUILDING__Email__c);
            quoteSSXML.addChildElement('LicenseNo', null, null).addTextNode(objCusInq.BOATBUILDING__Drivers_License_Number__c != null ? objCusInq.BOATBUILDING__Drivers_License_Number__c : '');
            //  quoteSSXML.addChildElement('LicenseExp', null, null).addTextNode(' ');
            quoteSSXML.addChildElement('LicenseState', null, null).addTextNode(objCusInq.BOATBUILDING__State__c != null ? objCusInq.BOATBUILDING__State__c : '');
            quoteSSXML.addChildElement('CoLicenseNo', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_Drivers_License_Number__c != null ? objCusInq.BOATBUILDING__CoApp_Drivers_License_Number__c : '' );
            // quoteSSXML.addChildElement('CoLicenseExp', null, null).addTextNode(' ');
            quoteSSXML.addChildElement('CoLicenseState', null, null).addTextNode(objCusInq.BOATBUILDING__CoApp_State__c != null ? objCusInq.BOATBUILDING__CoApp_State__c : '' );
            quoteSSXML.addChildElement('StockNumber', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.Name);
            quoteSSXML.addChildElement('NewUsed', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Web_Condition__c); 
            quoteSSXML.addChildElement('HIN', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__HIN_Number__c);
            quoteSSXML.addChildElement('InventoryYear', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Year__c);
            quoteSSXML.addChildElement('InventoryMake', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Manufacturer__c);
            quoteSSXML.addChildElement('InventoryModel', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Model__c);
            //  quoteSSXML.addChildElement('KeyCode', null, null).addTextNode(' ');
            quoteSSXML.addChildElement('WeightDry', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Boat_Weight__c);
            quoteSSXML.addChildElement('Length', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Boat_Length_in_feets__c);
            // quoteSSXML.addChildElement('NumberOfEngines', null, null).addTextNode('1');
            quoteSSXML.addChildElement('Engine1Year', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Year__c);
            quoteSSXML.addChildElement('Engine1Manufacturer', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Make__c);
            quoteSSXML.addChildElement('Engine1Model', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Model__c);
            quoteSSXML.addChildElement('Engine1Horsepower', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Web_Engine_HP__c));
            //quoteSSXML.addChildElement('Engine1Hours', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Used_Boat_HRS__c);
            // quoteSSXML.addChildElement('Engine1Price', null, null).addTextNode('.00');
            quoteSSXML.addChildElement('Engine1SerialNo', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_SN__c);
            //quoteSSXML.addChildElement('Engine1KeyNumber', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_Key_Number__c);
            // quoteSSXML.addChildElement('Engine1Transmission', null, null).addTextNode(' ');
            // quoteSSXML.addChildElement('Engine1Drive', null, null).addTextNode(' ');
            // quoteSSXML.addChildElement('Engine2Year', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Manufacturer', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Model', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Horsepower', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Hours', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Price', null, null).addTextNode('.00');
            //quoteSSXML.addChildElement('Engine2SerialNo', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Engine_2_SN__c);
            //  quoteSSXML.addChildElement('Engine2KeyNumber', null, null).addTextNode(' ');
            // quoteSSXML.addChildElement('Engine2Transmission', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('Engine2Drive', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('TrailerYear', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Year__c);
            //quoteSSXML.addChildElement('TrailerManufacturer', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Make__c);
            //quoteSSXML.addChildElement('TrailerModel', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_Model__c);
            //quoteSSXML.addChildElement('TrailerSerialNo', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Trailer_VIN__c);
            //quoteSSXML.addChildElement('Engine2SerialNo', null, null).addTextNode(BOATBUILDING__Test_2__c.BOATBUILDING__Total_MSRP_Price__c);
            //quoteSSXML.addChildElement('BoatMSRP', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Total_MSRP_Price__c));
            // quoteSSXML.addChildElement('TrailerMSRP', null, null).addTextNode('499.98');
            quoteSSXML.addChildElement('Cost', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Total_Dealer_Price__c));
            quoteSSXML.addChildElement('FuelType', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Web_Fuel_Type__c);
            quoteSSXML.addChildElement('HullMaterial', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Web_Hull_Material__c);
            quoteSSXML.addChildElement('PrimaryColor', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Main_color__c);
            quoteSSXML.addChildElement('SecColor', null, null).addTextNode(objQuote.BOATBUILDING__Test_2__r.BOATBUILDING__Accent_color__c);
            //quoteSSXML.addChildElement('TradeInYear', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatYear__c);
            //quoteSSXML.addChildElement('TradeInMake', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatMake__c);
            //quoteSSXML.addChildElement('TradeInModel', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatModel__c);
            //quoteSSXML.addChildElement('TradeHIN', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatHIN__c);
            //   quoteSSXML.addChildElement('TradeTrlYear', null, null).addTextNode(' ');
            //quoteSSXML.addChildElement('TradeTrlMfg', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerMake__c);
            //quoteSSXML.addChildElement('TradeTrlModel', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerModel__c);
            //quoteSSXML.addChildElement('TradeTrlVIN', null, null).addTextNode(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__TrailerVin__c);
            //quoteSSXML.addChildElement('TradeHours', null, null).addTextNode(String.valueOf(objQuote.BOATBUILDING__ACV_FORM__r.BOATBUILDING__BoatHrs__c));
            //  quoteSSXML.addChildElement('TradeLength', null, null).addTextNode(' ');
            // quoteSSXML.addChildElement('TradeBowNum', null, null).addTextNode(' ');
            
            xmlstring = doc.toXmlString();
            System.debug('>>>: '+xmlstring);
            // String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
            // String URlDownload = fullFileURL+'/sfc/servlet.shepherd/version/download/'+objQuote.Id;
            //system.debug('Download URL:' +URlDownload);
            
            List<Attachment> lstAtt = [SELECT Id FROM Attachment WHERE Name LIKE '%SupremeSoftware%' AND ParentId =: objQuote.Id ORDER BY CreatedDate DESC LIMIT 1];
            Attachment attachment = new Attachment();
            if(!lstAtt.isEmpty()) {
                attachment.Id = lstAtt[0].Id;
            } else {
                attachment.ParentId = objQuote.Id;
            }
            attachment.Body = Blob.valueOf(xmlstring);
            attachment.Name = 'SupremeSoftware.xml';
            attachment.ContentType = 'application/octet-stream';
            upsert attachment;
            String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();
            String urlDownload = fullFileURL+'/servlet/servlet.FileDownload?file=' + attachment.Id + '&operationContext=S1';
            return urlDownload;
        } catch (Exception e) {
            throw new AuraHandledException( e.getMessage() + ' : ' + e.getStackTraceString() + ' : ' + e.getLineNumber() );
        }
    }
    
    @AuraEnabled
    public static List<CICombobox> getCustomerInq( String recordId){
        try {
            BOATBUILDING__Quote__c objQuote = [SELECT Id, BOATBUILDING__Account_Name__c FROM Quote__c WHERE Id =: recordId LIMIT 1];
            List<CICombobox> lstCICombobox = new List<CICombobox>();
            if( objQuote.BOATBUILDING__Account_Name__c != null ) {
                List<BOATBUILDING__Customer_Inquiry__c> lstCI = [   SELECT Id, Name, BOATBUILDING__Account__c, BOATBUILDING__Account__r.Name 
                                                                    FROM BOATBUILDING__Customer_Inquiry__c 
                                                                    WHERE BOATBUILDING__Account__c =: objQuote.BOATBUILDING__Account_Name__c AND RecordType.Name = 'Credit App' ORDER By CreatedDate DESC];
                for(BOATBUILDING__Customer_Inquiry__c objCI: lstCI) {
                    CICombobox objCICombobox = new CICombobox();
                    objCICombobox.label = objCI.Name + ' (' + objCI.BOATBUILDING__Account__r.Name + ')';
                    objCICombobox.value = objCI.Id;
                    lstCICombobox.add( objCICombobox );
                }
            }
            return lstCICombobox;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    public class CICombobox {
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String value { get; set; }
    }
}