public class GoogleAnalyticsIntegration {
    
    //Declare variables
    public String authCode {get;set;}   
    public String accessToken {get;set;}
    public Boolean isInsertionSuccesfull {get;set;}
    public BOATBUILDING__GooglAnalyticsConfig__c objConfig;
    
    String accessKey = ''; 
    String redirect_uri = '';    
    String endPointToken = '';
    String secret = '';
    String aToken = '';
    String refreshTokenUrl = '';
    String userId = '';

    List<BOATBUILDING__Custom_Log__c> listCustomLog;
    
    
    public GoogleAnalyticsIntegration(){
        listCustomLog = new List<BOATBUILDING__Custom_Log__c>();
    }
    
    //Get Access Token with the help of Auth code
    public void getAccessToken() {
        //Get Google Analytics configuration from custom setting  
        objConfig = BOATBUILDING__GooglAnalyticsConfig__c.getOrgDefaults();              
        accessKey = String.isNotBlank(objConfig.BOATBUILDING__Access_Key__c) ? objConfig.BOATBUILDING__Access_Key__c : ''; 
        redirect_uri = String.isNotBlank(objConfig.BOATBUILDING__Redirect_Uri__c) ? objConfig.BOATBUILDING__Redirect_Uri__c : '';    
        endPointToken = String.isNotBlank(objConfig.BOATBUILDING__Token_End_Point__c) ? objConfig.BOATBUILDING__Token_End_Point__c : '';
        secret = String.isNotBlank(objConfig.BOATBUILDING__Secret_Key__c) ? objConfig.BOATBUILDING__Secret_Key__c : '';
        
        authCode = ApexPages.currentPage().getParameters().get('code');
        System.debug('======authCode======= '+authCode);       
        if(String.isNotBlank(authCode)){        
            //Getting access token from google
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endPointToken);
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody = 'code=' + authCode + '&client_id=' + accessKey + '&client_secret=' + secret + '&redirect_uri=' + redirect_uri + '&grant_type=authorization_code'; 
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60 * 1000);
            
            Http h = new Http();
            String resp;
            HttpResponse res = h.send(req);
            resp = res.getBody();
            //SendEmailUtility.sendEmail('======res========= '+resp);
            System.debug('===GoogleAnalyticsIntegration===res========= '+resp);
            
            ParseToken objTokenPayload = new ParseToken();
            objTokenPayload = (ParseToken)JSON.deserialize(resp,ParseToken.Class);
            
            System.debug('===GoogleAnalyticsIntegration===objParseToken.access_Token========= '+objTokenPayload.access_Token);            
            if(objTokenPayload.access_Token!=null){
                accessToken = objTokenPayload.access_Token;
                objConfig.BOATBUILDING__Access_Token__c= objTokenPayload.access_Token;
                objConfig.BOATBUILDING__Refresh_Token__c= (objTokenPayload.refresh_token!=null?objTokenPayload.refresh_token:objConfig.BOATBUILDING__Refresh_Token__c);
                
                System.debug('===GoogleAnalyticsIntegration===objCstToken.Refresh_Token__c========= '+objTokenPayload.refresh_token);                
            } 
            upsert objConfig;
        }
    }
    
    //Method to retrieve authentication code from google
    public PageReference DriveAuth(){             
        String key = EncodingUtil.urlEncode(accessKey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = (objConfig.BOATBUILDING__Auth_End_Point__c !=null?objConfig.BOATBUILDING__Auth_End_Point__c:'')+'?client_id='+key+'&response_type=code'+
            '&scope='+(objConfig.BOATBUILDING__Scope__c!=null?objConfig.BOATBUILDING__Scope__c:'')+
            '&redirect_uri='+uri;
        
        if(objConfig.BOATBUILDING__FirstTimeAccess__c){
            authuri += '&access_type=offline';
        }
        
        PageReference pg = new PageReference(authuri) ;
        return pg ;
    }
    
    
    public List<List<String>> createRequest(String filterCriteria, String accessToken, String storeLocation) {
        
        List<String> dimensions = new List<String>{'ga:pagePathLevel1','ga:pagePath','ga:year','ga:month','ga:day'};
        List<String> metrics = new List<String>{'ga:pageviews'};
                
        String endPointCustomSetting = storeLocation+'-GoogleAnalyticsEndPoint';
        BOATBUILDING__EndPointURL__c objCS = BOATBUILDING__EndPointURL__c.getValues(endPointCustomSetting);
        String filter = 'ga:pagePath=='+filterCriteria;
        
        String sitePrefix = '';
        if(objCS != null){
            sitePrefix = objCS.BOATBUILDING__URL__c;
            if(String.isNotBlank(sitePrefix)){
                filter = 'ga:pagePath=='+sitePrefix+filterCriteria;
            }
        }        
        
        Date sd = System.Today().addDays(-30);
        Date ed = System.Today().addDays(1);
        objConfig = BOATBUILDING__GooglAnalyticsConfig__c.getOrgDefaults();
        userId = String.isNotBlank(objConfig.BOATBUILDING__Google_User_Id__c) ? objConfig.BOATBUILDING__Google_User_Id__c : '';
        
        HttpRequest req = new HttpRequest();
        string endpoint = 'https://www.googleapis.com/analytics/v3/data/ga'+
            '?start-date='+ EncodingUtil.urlEncode(formatDate(sd), 'UTF-8')+
            '&end-date=' +EncodingUtil.urlEncode(formatDate(ed), 'UTF-8')+
            '&dimensions=' + EncodingUtil.urlEncode(join(dimensions, ','), 'UTF-8') + 
            '&metrics=' + EncodingUtil.urlEncode(join(metrics, ','), 'UTF-8') + 
            '&filters=' + EncodingUtil.urlEncode(filter, 'UTF-8')+
            '&ids='+EncodingUtil.urlEncode('ga:'+userId, 'UTF-8');
        
        System.debug('---endpoint---'+endpoint);
        System.debug('accessToken--'+accessToken);
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setTimeout(60 * 1000);
        req.setHeader('Authorization', 'Bearer ' +accessToken);
        req.setHeader('Content-Type', 'application/json');
        System.debug('Request: ' + req);
        
        listCustomLog.addAll(CustomLogUtil.createLog('request- line 126--'+req, 'GoogleAnalyticsChartsController'));
        
        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        listCustomLog.addAll(CustomLogUtil.createLog('resp- line 132--'+resp, 'GoogleAnalyticsChartsController'));
       
        if(String.isNOTBlank(resp)){
            resp = resp.replaceAll('start-date', 'startdate');
            resp = resp.replaceAll('end-date', 'enddate');
            resp = resp.replaceAll('start-index', 'startindex');
            resp = resp.replaceAll('max-results', 'maxresults');
            resp = resp.replaceAll('ga:uniquePageviews', 'gauniquePageviews');
            resp = resp.replaceAll('ga:pageValue', 'gapageValue');
            
            System.debug('resp---'+resp);
            listCustomLog.addAll(CustomLogUtil.createLog('resp- line 142--'+resp, 'GoogleAnalyticsChartsController'));

            
            List<List<String>> rows = parseRequest(resp);
            listCustomLog.addAll(CustomLogUtil.createLog('rows- line 146--'+rows, 'GoogleAnalyticsChartsController'));
            
            if(!rows.isEmpty()){
                return rows;
            }
        }
        
        if(!listCustomLog.isEmpty()){
            insert listCustomLog;
        }
        return null;
    }
    
    public static List<List<String>> parseRequest(String resp){
        BOATBUILDING.GoogleAnalyticsJSON2Apex objResponse = BOATBUILDING.GoogleAnalyticsJSON2Apex.parse(resp);
        System.debug('objResponse----'+objResponse.rows);
        
        return objResponse.rows;
    }
    
    public static string formatDate(Date d) {
        Datetime dt = Datetime.newInstance(d, Time.newInstance(0,0,0,0));
        return dt.format('yyyy-MM-dd');
    }
    
    public static String join(List<string> items, string delimiter) {
        string s = '';
        integer i = 0;
        
        for (string item : items) {
            if (i++ > 0) { 
                s += delimiter; 
            }
            s += item;
        }
        return s;
    }
    
    public class ParseToken {
        public String access_token;
        public String expires_in;
        public String token_type;
        public String refresh_token;
        
    }
}