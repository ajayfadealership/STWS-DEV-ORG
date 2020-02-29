public with sharing class NewQuickbooksConnector {

    public String outputString { get; set; }
    public String authToken { get; set; }
    private static OAuthService__c serviceObject;
    public map<string, string> mapResponse {get; set;}
    public NewQuickbooksConnector(){
        mapResponse = apexpages.currentpage().getparameters();
        System.debug('===realIMID===' +mapResponse);
        
    }

/* =============================================================================
//
//    Function: OAuth_Step1_getTempTokenAndRedirectToIntuit    
//
/*=============================================================================*/
    public pagereference OAuth_Step1_getTempTokenAndRedirectToIntuit() {
        
        serviceObject = getServiceSettings();
        System.debug('====ServiceObject111===' +serviceObject);
        
        String nonce = string.valueof(dateTime.now().getTime()/1000);
        String timestamp = string.valueof(dateTime.now().getTime()/1000);
        
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_callback', EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnect2', 'UTF-8'));
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_version', '1.0');

        HttpRequest req = new HttpRequest();
        HttpResponse res;
        if(!test.isRunningTest()){
            req.setEndpoint(serviceObject.Request_Token_URL__c);
          }else{
            req.setEndpoint('https://sandbox-quickbooks.api.intuit.com/authorization');
           }
        req.setMethod('POST');   
                 
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, '', parameters);
        
        String body = 'oauth_callback=' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnect2' + '&';
        body += 'oauth_consumer_key=' + serviceObject.Consumer_Key__c + '&';
        body += 'oauth_nonce=' + nonce + '&';
        body += 'oauth_signature_method=HMAC-SHA1&';
        body += 'oauth_timestamp=' + timestamp + '&';
        body += 'oauth_version=1.0&';
        body += 'oauth_signature=' + signature;
        req.setBody(body);
        
        String authToken = '';
        
        try {
            
            Map<String,String> responseItems = getResponseNVP( req );
            System.debug('==responseItems==' +responseItems);
            serviceObject.BOATBUILDING__Temporary_Token_Secret__c= responseItems.get('oauth_token_secret');
            serviceObject.BOATBUILDING__OAuth_Token_Secret__c = responseItems.get('oauth_token_secret');
            System.debug('==responseItems.getAuth Token==' +responseItems.get('oauth_token_secret'));
            update serviceObject;
        
            authToken = responseItems.get('oauth_token');
        
        } catch(Exception e) {
            System.debug(e.getMessage());        
        }
        
        String redirectUrl = 'https://appcenter.intuit.com/Connect/Begin?oauth_token=' + authToken;
        pagereference redirect = new PageReference( redirectUrl );
        return redirect.setRedirect(true);
    }

/*=============================================================================
//
//    Function: OAuth_Step2_getFinalToken    
//
/*=============================================================================*/
    public pagereference OAuth_Step2_getFinalToken() {
        
        serviceObject = getServiceSettings();
        Map<String,String> responseItems;
        
        String nonce = string.valueof(dateTime.now().getTime()/1000);
        String timestamp = string.valueof(dateTime.now().getTime()/1000);
        
        String tokenParm       = apexpages.currentpage().getparameters().get('oauth_token');
        System.debug('==tokenParm=='+tokenParm);
        String tokenVerifier   = apexpages.currentpage().getparameters().get('oauth_verifier');
        String CompanyID = apexpages.currentpage().getparameters().get('realmId');
        System.debug('===ComapnyID==='+CompanyID);
        
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_callback', EncodingUtil.urlEncode(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnect2', 'UTF-8'));
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_token', tokenParm);
        parameters.put('oauth_verifier', tokenVerifier);
        parameters.put('oauth_version', '1.0');
    
        Http http       = new Http();
        HttpRequest req = new HttpRequest();
         
        req.setEndpoint(serviceObject.Access_Token_URL__c);
        req.setMethod('POST');   
                 
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, serviceObject.Temporary_Token_Secret__c, parameters);
        
        String body = 'oauth_callback=' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnect2' + '&';
        body += 'oauth_consumer_key=' + serviceObject.Consumer_Key__c + '&';
        body += 'oauth_nonce=' + nonce + '&';
        body += 'oauth_signature_method=HMAC-SHA1&';
        body += 'oauth_timestamp=' + timestamp + '&';
        body += 'oauth_version=1.0&';
        body += 'oauth_token=' + tokenParm + '&';
        body += 'oauth_verifier=' + tokenVerifier + '&';
        body += 'oauth_signature=' + signature;     
        req.setBody(body);

        try {
            if(!test.isRunningTest()){
                 responseItems = getResponseNVP( req );
               }

            outputString += JSON.serialize( responseItems );
        
            serviceObject.OAuth_Token__c = responseItems.get('oauth_token');
            serviceObject.OAuth_Token_Secret__c = responseItems.get('oauth_token_secret');
            System.debug('ComanyID' +companyID);
            serviceObject.BOATBUILDING__Company_ID__c = CompanyID;
            update serviceObject;
        
        } catch(Exception e) {
            System.debug(e.getMessage());        
        }
        
        String redirectUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuickbooksConnectTest';
        pagereference redirect = new PageReference( redirectUrl );
        redirect.setRedirect(true);
        
        return redirect;
    }

   
    
/*=============================================================================
//
//    Function: signRequest    
//
/*=============================================================================*/
   /* public static HttpRequest signRequest(HttpRequest req) {

        serviceObject = getServiceSettings();

        String nonce     = string.valueof(dateTime.now().getTime()/1000);
        String timestamp = string.valueof(dateTime.now().getTime()/1000);
 
        Map<String,String> parameters = new Map<String,String>();
        parameters.put('oauth_consumer_key', serviceObject.Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_token', EncodingUtil.urlEncode(serviceObject.OAuth_Token__c, 'UTF-8'));
        parameters.put('oauth_version', '1.0');
 
        String signature = generateSignature(req, serviceObject.Consumer_Secret__c, serviceObject.OAuth_Token_Secret__c, parameters);
        String header = generateHeader(signature, parameters);
        req.setHeader('Authorization', header);
        req.setHeader('Accept', 'application/json');
 
        return req;
    }
    */
/*=============================================================================
//
//    Function: generateHeader    
//
/*=============================================================================*/
    private static String generateHeader(String signature, Map<String,String> parameters) {
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        return header + 'oauth_signature="' + signature + '"';
    }
 
/*=============================================================================
//
//    Function: generateSignature    
//
/*=============================================================================*/
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
 
/*=============================================================================
//
//    Function: createBaseString    
//
/*=============================================================================*/
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
 
/*=============================================================================
//
//    Function: getUrlParams    
//
/*=============================================================================*/
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
    
/*=============================================================================
//
//    Function: getResponseNVP()    
//
/*=============================================================================*/
    private static Map<String,String> getResponseNVP(HttpRequest req){
        
        Http http = new Http();
        HttpResponse res;
        res = http.send(req);
        
        String resParams = res.getBody();
        System.debug('==resParams=='+resParams);
            
        Map<String,String> rp = new Map<String,String>();
        
        for(String s : resParams.split('&')) {
            List<String> kv = s.split('=');
            rp.put(kv[0],kv[1]);
        }
        System.debug('===resp in NVP method===' +rp);
        return rp;
    }
            
/*=============================================================================
//
//    Function: getServiceSettings    
//
/*=============================================================================*/
    private static OAuthService__c getServiceSettings(){
        
        if (serviceObject != null)
        {
            return serviceObject;
        }
        
        try {
            serviceObject = [Select Name, OAuth_Token__c, OAuth_Token_Secret__c, Access_Token_URL__c, Application_Token__c, Authorization_URL__c, Consumer_Key__c, Consumer_Secret__c, Request_Token_URL__c, Temporary_Token_Secret__c From OAuthService__c Where   Name='Intuit' limit 1 ];
        } catch(Exception e) {
            System.debug(e.getMessage());        
        }
        
        return  serviceObject;                           
    }

/*=============================================================================
//
//    Function: validateCredentials    
//
/*=============================================================================*/
    /*private void validateCredentials(){
        
        String companyId = '12345678';      
        String endpoint  = 'https://sandbox-quickbooks.api.intuit.com/v3/company/' + companyId + '/companyinfo/' + companyId;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(endpoint);
        req.setMethod('GET');   
        req = signRequest(req);
        
        Map <String,Object> jsonResponse;
        String resParams;
        
        try {
            HttpResponse res;
            res = http.send(req); 
            resParams = res.getBody();
        
            jsonResponse = (Map<String,Object>) JSON.deserializeUntyped( resParams );
        
        } catch(Exception e) {
            System.debug(e.getMessage());        
        }
                
        if (jsonResponse.get('time') == null) {
        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
            String[] toAddresses = new String[] {'test@test.com'};
            mail.setToAddresses(toAddresses) ;
            mail.setSubject('Error Connecting To Quickbooks');
        
            String body = resParams;
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        }                
    }*/
}