public class QbConnectUtil {
    
    public String outputString { get; set; }
    public static OAuthService__c serviceObject;
    public static BOATBUILDING__EndPointURL__c endPointURL;
    public String respTodisplay {get;set;}
    public String realImID;
    
    public QbConnectUtil(){
        
    }
    
    /***Code Added on 19thAug 2017 by Pradeep****/
    //This method is used to fetch the QuickBook Customer and validate in Salesforce
    //@future(callout=true)
    public Static Contact FetchQBCustomer(Id conId){
        
        Map<String, String> mapQbNametoID = new Map<String, String>();
        
        String conName = [Select name from Contact where id =: conId].name;
        List<Contact> lstConToSendQB = [Select id,Name,Firstname,LastName,Phone,Email,Salutation, Description,BOATBUILDING__QBCustomerID__c, BOATBUILDING__QBCustomerStatus__c,MailingStreet,MailingCity,MailingCountry,MailingPostalCode FROM Contact where id =: conId];
        
        String query = 'select DisplayName from Customer Where DisplayName=\''+conName.normalizeSpace()+'\'';
        String finalQuery = EncodingUtil.URLENCODE(query,'UTF-8').replace('+', '%20');
        System.debug('===fetchContact==query===' +finalQuery);
        
        serviceObject = BOATBUILDING__OAuthService__c.getValues('Intuit');
        String companyId = serviceObject.BOATBUILDING__Company_ID__c;
        endPointURL = BOATBUILDING__EndPointURL__c.getValues('QBCreateCustomerEndPoint');
        
        String endpoint = endPointURL.BOATBUILDING__URL__c + companyId + '/query?query='+finalQuery+'&minorversion=4'; 
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');  
        req = signRequest(req);
        //req = signRequestToFetchQBData(req);
        System.debug('==pradeep req==='+req);
        HttpResponse res;
        res = http.send(req);
        
        String resParams = res.getBody();
        System.debug('====fetchCustomerresParams===' +resParams);
        Map<String,String> mapIdToName = new Map<String,String>();
        List<String> listDisplayNames = new List<String>();
        List<String> listIds = new List<String>();
        
        if(res.getStatusCode()==200){
            XPath xp = new XPath(resParams);
            String strPath = '/IntuitResponse/QueryResponse/Customer';
            Dom.XmlNode root = xp.doc.getRootElement();
            Dom.XmlNode[] actualNodes = xp.find(xp.root, strPath);
            
            for(Dom.XmlNode xmlInstance : actualNodes){
                mapIdToName.put(xp.getText(xmlInstance,'DisplayName'), xp.getText(xmlInstance,'DisplayName'));
                mapQbNametoID.put(xp.getText(xmlInstance,'DisplayName'),xp.getText(xmlInstance,'Id'));
            }
            System.debug(mapQbNametoID+'==mapIdToName== '+mapIdToName);
            //SendEmailUtility.sendEmail('ContactFetch200'+mapQbNametoID);
        }
        else{
            //SendEmailUtility.sendEmail('ContactFetch200Else'+res.getStatusCode());
        }
        
        if(mapIdToName.containsKey(conName.normalizeSpace())){
            system.debug('Enter if Contact is there in QB'+mapQbNametoID.get(conName));
            Contact objCon = new Contact(Id=conId);
            objCon.BOATBUILDING__QBCustomerID__c = mapQbNametoID.get(conName.normalizeSpace());
            objCon.BOATBUILDING__QBCustomerStatus__c = true;
            update objCon;
            System.debug('update contact');
            return objCon;
        }else{
            System.debug('Not present in QB');
            String payload;
            payload = generateContactJson(lstConToSendQB[0]);
            System.debug('====payload===='+payload);
            Contact conresponse =QbConnectUtil.CreateQBCustomer(payload, lstConToSendQB[0].id);
            //SendEmailUtility.sendEmail('ContactFetchNot present in QB'+conresponse);
            return conresponse;
        }
    }
    
    /**Code Ended by Pradeep****/
    /*****Create Customer*****/
    
    //@future(callout=true)
    public Static Contact CreateQBCustomer(String jsonpayload, String conID) {
        String resParams;
        Contact conToUpdate = new Contact();
        //validateCredentials();
        serviceObject = BOATBUILDING__OAuthService__c.getValues('Intuit');
        endPointURL = BOATBUILDING__EndPointURL__c.getValues('QBCreateCustomerEndPoint');
        System.debug('====Endpoint===' +endPointURL);
        String companyId = '';
        String endpoint = '';
        if(serviceObject!=null && String.isNOTBlank(serviceObject.BOATBUILDING__Company_ID__c)){
            System.debug('==serviceObject=='+serviceObject.BOATBUILDING__Company_ID__c);
            companyId = serviceObject.BOATBUILDING__Company_ID__c;
        }
        
        String payload = jsonpayload;
        //String endpoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/' + companyId + '/customer';
        if(endPointURL!=null && String.isNOTBlank(endPointURL.BOATBUILDING__URL__c)){
            endpoint = endPointURL.BOATBUILDING__URL__c + companyId + '/customer'; 
            System.debug('===endpoint==='+endpoint);
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(payload);    
        req = signRequest(req);
        
        HttpResponse res;
        if(!Test.isRunningTest()){
            res = http.send(req); 
            resParams = res.getBody();
            System.debug('===test Response===' +res.getBody());
            if(res.getStatusCode()==200){
                Dom.Document doc = res.getBodyDocument();
                System.debug('====doc===' +doc);
                
                String QBCustomerID = parseResponseDom(doc);
                System.debug('==QBCustomerID==='+QBCustomerID);
                
                conToUpdate = [Select id, BOATBUILDING__QBCustomerID__c,BOATBUILDING__QBCustomerStatus__c from Contact where id =: conID];
                conToUpdate.QBCustomerID__c = QBCustomerID;
                conToUpdate.QBCustomerStatus__c = true;
                //update conToUpdate;
            }else{
                //SendEmailUtility.sendEmail(conID,resParams); //Added by Pradeep 2nd Sept 2017
            }
        }
        return conToUpdate;
    }
    
    public Static String parseResponseDom(Dom.Document xml){
        
        //Retrieve the root element for this document.
        Dom.XMLNode IntuitResponse = xml.getRootElement();
        System.debug('===QBDtls= '+ IntuitResponse);
        
        String QBId ;
        for(Dom.XmlNode node1: IntuitResponse.getChildElements()){
            System.debug('===childname==== '+node1.getName());//Customer
            for(Dom.XmlNode node2: node1.getChildElements()){
                if(node2.getName() == 'Id'){
                    QBId = node2.getText();
                    System.debug('===QBId=='+QBId);
                }
            }
        }
        return QBId;
    }
    
    
    
    /***Create WorkOrder*****/

    //@future(callout=true)
    public Static void CreateQBWorkOrder(String jsonpayload, String WoId) {
        String resParams;
        serviceObject = BOATBUILDING__OAuthService__c.getValues('Intuit');
        endPointURL = BOATBUILDING__EndPointURL__c.getValues('QBCreateInvoiceEndPont');
        System.debug('==serviceObject=='+serviceObject.BOATBUILDING__Company_ID__c);
        System.debug('====Endpoint===' +endPointURL);
        String companyId = serviceObject.BOATBUILDING__Company_ID__c;
        String payload = jsonpayload;
        System.debug('====Payload=145==' +payload);
        String endpoint = endPointURL.BOATBUILDING__URL__c + companyId + '/invoice'; 
        System.debug('===endpoint==='+endpoint);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setBody(payload);    
        req = signRequest(req);
        
        HttpResponse res;
        res = http.send(req);
        resParams = res.getBody();
        System.debug('====resParams===' +resParams);
        //SendEmailUtility.sendEmail('====resParams===' +resParams);
        if(res.getStatusCode()==200){
            Dom.Document doc = res.getBodyDocument();
            System.debug('====doc===' +doc);
            //SendEmailUtility.sendEmail('====resParams===' +resParams);
            
            String QBInvoiceID = parseResponseDom(doc);
            System.debug('==QBInvoiceID==='+QBInvoiceID);
            //SendEmailUtility.sendEmail('====resParams===' +resParams);
            
            BOATBUILDING__Work_Order__c WoToUpdate = [Select id,Name, BOATBUILDING__QBInvoiceID__c,BOATBUILDING__QBInvoiceStatus__c from BOATBUILDING__Work_Order__c where id =: WoId];
            WoToUpdate.BOATBUILDING__QBInvoiceID__c = QBInvoiceID;
            WoToUpdate.BOATBUILDING__QBInvoiceStatus__c = true;
            //SendEmailUtility.sendEmail('====QBInvoiceID for Work Order ==='+WoToUpdate.Name +'----is---'+QBInvoiceID);
            update WoToUpdate;
        }else{
            if(!Test.isRunningTest())
            {
                //SendEmailUtility.sendEmail('====resParams===else' +resParams);
                
                //SendEmailUtility.sendEmail(WoId,resParams); 
            }//Added by Pradeep 2nd Sept 2017
        }
    }

    public static HttpRequest signRequest(HttpRequest req) {
        
        //serviceObject = getServiceSettings();
        serviceobject = BOATBUILDING__OAuthService__c.getValues('Intuit');
        
        if(serviceobject!=null){
            String nonce     = string.valueof(dateTime.now().getTime()/1000);
            String timestamp = string.valueof(dateTime.now().getTime()/1000);
            
            Map<String,String> parameters = new Map<String,String>();
            parameters.put('oauth_callback', EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnectTest', 'UTF-8'));
            parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
            parameters.put('oauth_nonce', nonce);
            parameters.put('oauth_signature_method', 'HMAC-SHA1');
            parameters.put('oauth_timestamp', timestamp);
            parameters.put('oauth_token', EncodingUtil.urlEncode(serviceObject.OAuth_Token__c, 'UTF-8'));
            parameters.put('oauth_version', '1.0');
            
            String signature = generateSignature(req, serviceObject.Consumer_Secret__c, serviceObject.OAuth_Token_Secret__c, parameters);
            String header = generateHeader(signature, parameters);
            req.setHeader('Authorization', header);
            req.setHeader('Content-Type', 'application/json');
        }
        
        return req;
    }
    
    
    private static String generateSignature(HttpRequest req, String consumerSecret, String tokenSecret, Map<String,String> parameters) {
        String s    = createBaseString(req, parameters);        
        String key  = EncodingUtil.urlEncode(consumerSecret, 'UTF-8') + '&' + EncodingUtil.urlEncode(tokenSecret, 'UTF-8');
        
        Blob sig = Crypto.generateMac(
            'HmacSHA1'
            , Blob.valueOf(s)
            , Blob.valueOf(key)
        );
        return EncodingUtil.urlEncode( EncodingUtil.base64encode(sig), 'UTF-8');
    }
    
    private static String createBaseString(HttpRequest req, Map<String,String> parameters) {
        Map<String,String> p = parameters.clone();
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
        
        return req.getMethod().toUpperCase()+ '&' +
            EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
            EncodingUtil.urlEncode(s, 'UTF-8');
    }
    
    private static String generateHeader(String signature, Map<String,String> parameters) {
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        System.debug('====final header==:' +header + 'oauth_signature="' + signature + '"');
        return header + 'oauth_signature="' + signature + '"';
    }
    
    private static Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
                System.debug('getUrlParams: -> '+kv[0]+','+kv[1]);
                res.put(kv[0],kv[1]);
            }
        }
        return res;
    }
    
    public Static String generateContactJson(Contact con){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('BillAddr');
        gen.writeStartObject();
        gen.writeObjectField('Line1', con.MailingStreet == null?'': con.MailingStreet);
        gen.writeObjectField('City', con.MailingCity == null?'': con.MailingCity);
        gen.writeObjectField('Country', con.MailingCountry == null?'' :con.MailingCountry);
        gen.writeObjectField('CountrySubDivisionCode', con.MailingCountry== null?'' : con.MailingCountry);
        gen.writeObjectField('PostalCode', con.MailingPostalCode == null?'' : con.MailingPostalCode);
        gen.writeEndObject();
        gen.writeObjectField('Notes', con.Description == null?'': con.Description);
        gen.writeObjectField('Title', con.Salutation== null?'': con.Salutation);
        gen.writeObjectField('GivenName', con.FirstName == null?'': con.FirstName);
        //gen.writeObjectField('MiddleName', con.Name== null?'': con.Name);
        gen.writeObjectField('FamilyName', con.LastName == null?'': con.LastName);
        gen.writeObjectField('FullyQualifiedName', con.Name == null?'': con.Name);
        gen.writeObjectField('CompanyName', con.Name== null?'': con.Name);
        gen.writeObjectField('DisplayName', con.Name== null?'': con.Name);
        gen.writeFieldName('PrimaryPhone');
        gen.writeStartObject();
        gen.writeObjectField('FreeFormNumber', con.Phone == null?'': con.Phone);
        gen.writeEndObject();
        gen.writeFieldName('PrimaryEmailAddr');
        gen.writeStartObject();
        gen.writeObjectField('Address', con.Email == null?'': con.Email);
        gen.writeEndObject();
        gen.writeEndObject();
        String strjson= gen.getAsString(); 
        System.debug('==strjson==' +strjson);
        return strjson;
    }
}