global class EmailServiceSupraMumba implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        /*String strForPlainText = email.PlainTextBody;
        System.debug('strForPlainText---'+strForPlainText);
        String url = '';
        
        if(strForPlainText.contains('View Lead <')){
            url = strForPlainText.substringBetween('View Lead <','>');
        } else if(strForPlainText.contains('VIEW LEAD<')){
            url = strForPlainText.substringBetween('VIEW LEAD<','>');
        }
        
        System.debug('----------'+url);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        Http h = new Http();
        HttpResponse httpResponse = h.send(req);
        String sourceEmail = email.fromAddress;
        System.debug(httpResponse.getBody());
        String response = httpResponse.getBody();
        String newURL = EncodingUtil.urlDecode(response.substringbetween('target URL: <a href="','">').replaceAll('amp;',''), 'UTF-8');
        
        HttpRequest reqNew = new HttpRequest();
        reqNew.setMethod('GET');
        reqNew.setEndpoint(newURL);
        Http hNew = new Http();
        HttpResponse httpResponseNew = hNew.send(reqNew);
        //System.debug('----New'+httpResponseNew.getBody());
        String json = httpResponseNew.getBody().substringbetween('var model = ',';');
        System.debug('----json'+json);
        SupraMoombaEmailJSON2Apex obj = SupraMoombaEmailJSON2Apex.parse(json);
        System.debug('---obj---'+obj.RecordData);
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account Trade').getRecordTypeId();
        acc.Name = obj.RecordData.FirstName+' '+obj.RecordData.LastName;
        acc.BOATBUILDING__Prospect_First_Name__c = obj.RecordData.FirstName;
        acc.BOATBUILDING__Prospect_Last_Name__c = obj.RecordData.LastName; 
        acc.BOATBUILDING__Contact_Email__c = obj.RecordData.Email;
        acc.BOATBUILDING__Email__c = obj.RecordData.Email;
        acc.BOATBUILDING__Prospect_Address_Line_1__c = obj.RecordData.Address1;
        acc.BOATBUILDING__Prospect_Address_Line_2__c = obj.RecordData.Address2;
        acc.BOATBUILDING__Prospect_City__c = obj.RecordData.City;
        acc.BOATBUILDING__Prospect_State__c = obj.RecordData.State;
        acc.BOATBUILDING__County__c = obj.RecordData.County;
        acc.BOATBUILDING__Country__c = obj.RecordData.Country;
        acc.BOATBUILDING__Prospect_Zip_Code__c = obj.RecordData.PostalCode;
        acc.BOATBUILDING__BrandId__c = obj.RecordData.BrandId;
        acc.BOATBUILDING__DealerDistance__c = obj.RecordData.DealerDistance;
        acc.BOATBUILDING__DealerDistance__c = obj.RecordData.DealerDistanceMiles;
        acc.BOATBUILDING__DealerDistanceMilesText__c = obj.RecordData.DealerDistanceMilesText;
        acc.BOATBUILDING__FollowUpStatus__c = obj.RecordData.FollowUpStatusName;
        acc.BOATBUILDING__Telephone__c = obj.RecordData.HomePhone;
        acc.BOATBUILDING__Lead_Source__c  = 'Skiers Choice';
        acc.BOATBUILDING__Prospect_Mobile_Phone_Number__c = obj.RecordData.MobilePhone;
        acc.BOATBUILDING__Desire_boat_model__c = obj.RecordData.ProductName+'('+obj.RecordData.Model+')';
        acc.BOATBUILDING__Year__c = obj.RecordData.ModelYear;
        acc.BOATBUILDING__Desired_Boat_Manufacturer__c = 'Skiers Choice('+obj.RecordData.BrandName+')';
        acc.BOATBUILDING__Work_Phone__c = obj.RecordData.WorkPhone;
        acc.BOATBUILDING__SkiersChoiceLeadUid__c = obj.RecordData.LeadUid;
        
        insert acc;*/
        return result;
    }
}