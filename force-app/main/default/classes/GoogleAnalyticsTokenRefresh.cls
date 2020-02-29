public class GoogleAnalyticsTokenRefresh implements Database.Batchable<BOATBUILDING__GooglAnalyticsConfig__c>,Database.AllowsCallouts,Database.Stateful{

    BOATBUILDING__GooglAnalyticsConfig__c objConfig = BOATBUILDING__GooglAnalyticsConfig__c.getOrgDefaults();
    
    String accessKey    = String.isNotBlank(objConfig.BOATBUILDING__Access_Key__c)?objConfig.BOATBUILDING__Access_Key__c:''; 
    String redirect_uri = String.isNotBlank(objConfig.BOATBUILDING__Redirect_Uri__c)?objConfig.BOATBUILDING__Redirect_Uri__c:'';     
    String secret       = String.isNotBlank(objConfig.BOATBUILDING__Secret_Key__c)?objConfig.BOATBUILDING__Secret_Key__c:'';
    String refreshToken = String.isNotBlank(objConfig.BOATBUILDING__Refresh_Token__c)?objConfig.BOATBUILDING__Refresh_Token__c:'';
    String accessToken  = String.isNotBlank(objConfig.BOATBUILDING__Access_Token__c)?objConfig.BOATBUILDING__Access_Token__c:'';
    String endPointURL  = String.isNotBlank(objConfig.BOATBUILDING__Token_End_Point__c)?objConfig.BOATBUILDING__Token_End_Point__c:'';
    List<String> lstErrorMessage;
    
    
    public Iterable<BOATBUILDING__GooglAnalyticsConfig__c> start(Database.BatchableContext BC) {
        
        List<BOATBUILDING__GooglAnalyticsConfig__c> listGDConfig = new List<BOATBUILDING__GooglAnalyticsConfig__c>();
        listGDConfig.add(objConfig);
        return listGDConfig;
    }
    
     public void execute(Database.BatchableContext BC, List<BOATBUILDING__GooglAnalyticsConfig__c> lstDriveConfig) {
        
        if(Test.isRunningTest()){   
            endPointURL = 'www.tokenendPoint.com';
        }
        
        Http http = new Http();
        HttpResponse httpResponse;
        lstErrorMessage = new List<String>();
        if(String.isNotBlank(endPointURL)){
           
            //Getting access token from google
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setEndpoint(endPointURL);
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            String messageBody = frameRequestString();
            req.setHeader('Content-length', String.valueOf(messageBody.length()));
            req.setBody(messageBody);
            req.setTimeout(60 * 1000);
            
            
            
            if(!Test.isRunningTest()){
                httpResponse = http.send(req);
            } else {
                
               // MockServiceClass mockService = new MockServiceClass();
               // httpResponse = mockService.Respond(req);
            }
            System.debug('==httpResponse=='+httpResponse);
            ParseResponse objParseResponse= new ParseResponse();
            objParseResponse = (ParseResponse)JSON.deserialize( httpResponse.getBody(),ParseResponse.Class);
            
            System.debug('======objParseResponse.access_Token========= '+objParseResponse.access_Token);
            if(String.isNotBlank(objParseResponse.access_Token)){
                
                objConfig.BOATBUILDING__Access_Token__c  = objParseResponse.access_Token;
                objConfig.BOATBUILDING__Refresh_Token__c = String.isNotBlank(objParseResponse.refresh_token)?objParseResponse.refresh_token:objConfig.BOATBUILDING__Refresh_Token__c;
            }
        }
        if(objConfig!=null){
            Database.UpsertResult result = Database.upsert(objConfig, False);
            System.debug('result---'+result);
        }
        if(httpResponse.getStatusCode()!=200){
            lstErrorMessage.add(httpResponse.getBody());
        }
    }
    
    public void finish(Database.BatchableContext BC) {
           for(String str : lstErrorMessage){
               SendEmailUtility.sendEmail(str);
           }
    }
    
    public String frameRequestString(){
        
        //which are mandatory, place conditions of not blank according to that
        return 'client_id=' + accessKey + '&client_secret=' + secret + '&grant_type=refresh_token&refresh_token='+refreshToken;
    }
    public class ParseResponse{
        public String access_token;
        public String token_type;
        public Decimal expires_in;
        public String refresh_token;
    }

}