public with sharing class SitedmlApiUtil {
    public static String updateLeadRecord(String strBody, String LeadId){      
        String recordIdToReturn = null;
        System.debug('strBody---'+strBody);
        String endpoint = '/services/data/v50.0/sobjects/Lead/'+LeadId;
        HttpRequest httpRequest = SiteDmlApiUtil.httpRequestGenerator('PATCH', endpoint, strBody);
        HTTPResponse httpResponse = sendHttpRequest(httpRequest);
        System.debug('---m---'+httpResponse.getBody());
        if(httpResponse.getStatusCode() == 200 || httpResponse.getStatusCode() == 201){
            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
            System.debug('---m---'+m);
            recordIdToReturn = String.valueOf(m.get('id'));
        }
        return recordIdToReturn;
    }


    public static HttpRequest httpRequestGenerator(String reqMethod, String endpoint, String reqBody){
        
        String strAuthResponse = oauthLogin();
        System.debug('strAuthResponse----'+strAuthResponse);
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(strAuthResponse);
        String InstanceURL = String.valueOf(m.get('instance_url'));
        String accessToken = String.valueOf(m.get('access_token'));
        String authorizationHeader = 'Bearer ' +accessToken;
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod(reqMethod);
        httpRequest.setEndpoint(InstanceURL+endpoint);
        httpRequest.setHeader('Authorization', authorizationHeader);
        httpRequest.setHeader('Content-Type', 'application/json;charset=UTF-8');
        if(String.isNotBlank(reqBody)){
            httpRequest.setBody(reqBody);
        }
        
        return httpRequest;
    }

    public Static String oauthLogin(){        
       
        String clientId = ' ';
        String clientSecret = ' ';
        String username = ' ';
        String password = ' ';
        String loginUri = 'https://test.salesforce.com/';
       
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(loginUri+'services/oauth2/token?grant_type=password'+
                        '&client_id=' + clientId +
                        '&client_secret=' + clientSecret +
                        '&username=' + username +
                        '&password=' + password
                       );
        
        system.debug('--Auth--req.getBody---' + req);
        HTTPResponse res = sendHttpRequest(req);
        System.debug('BODY: '+res.getBody());
        return res.getBody();
    }

    public static HTTPResponse sendHttpRequest(HttpRequest req){
        
        Http http = new Http();
        HTTPResponse res = new HTTPResponse();
        res = http.send(req);
        return res;
    }
}