/**                                     
* @File Name          : CreateCaseController.cls
* @Description        : 
* @Author             : phUser@phDomain.com
* @Group              : 
* @Last Modified By   : phUser@phDomain.com
* @Last Modified On   : 2/11/2019, 4:10:41 AM
* @Modification Log   : 
*==============================================================================
* Ver         Date                     Author                 Modification
*==============================================================================
* 1.0    2/11/2019, 3:49:56 AM   phUser@phDomain.com     Initial Version
**/
public class CreateCaseController {
    
    public Case objCase {get; set;}
    public Attachment objAttach1{get; set;}
    public Attachment objAttach2{get; set;}
    public Attachment objAttach3{get; set;}
    public static String clientId = '';
    public static String clientSecret = '';
    public static String username = '';
    public static String password = '';
    public static String endpointURL = '';
    
    public CreateCaseController(){
        
        objAttach1 = new Attachment();
        objAttach2 = new Attachment();
        objAttach3 = new Attachment();        
    }
    @RemoteAction
    public static String doUploadAttachment(String caseId, String attBody, String attName)
    {
        FADSupportConfig__c objConfig = FADSupportConfig__c.getOrgDefaults();
        clientId = objConfig.ConsumerKey__c;
        clientSecret = objConfig.ClientSecret__c;
        username = objConfig.Username__c;
        password = objConfig.Password__c+objConfig.SecurityToken__c;
        endpointURL = objConfig.EndpointURL__c;
        String userId = UserInfo.getUserId();
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(endpointURL+'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance
        System.debug('req---'+req);
        HttpResponse res = h.send(req);
        
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
        
        System.debug('caseId---'+caseId);
        System.debug('attBody---'+attBody);
        System.debug('attName---'+attName);
        
        String strJSON = '{"attributes":{"type":"Attachment"},"ParentId":"'+caseId+'","Body":"'+attBody+'","Name":"'+attName+'"}';
        
        if(String.isNotBlank(objAuthenticationInfo.access_token)){            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setBody(strJSON);//Send JSON body
            req1.setMethod('POST');
            req1.setEndpoint(endpointURL+'/services/data/v39.0/sobjects/Attachment');
            HttpResponse res1 = h1.send(req1);
            system.debug('RESPONSE_BODY'+res1 .getbody());
            objAuthenticationInfo = (OAuth2)JSON.deserialize(res1.getbody(), OAuth2.class);
            String createdAttId = String.isNotBlank(objAuthenticationInfo.id)?objAuthenticationInfo.id:'';
            System.debug('resp---'+createdAttId);
            
            return createdAttId;
        }
        
        
        return 'ERROR';
    }
    
    @RemoteAction
    public static String createCasefromJS(String subject, String description, String type, String priority){
        
        FADSupportConfig__c objConfig = FADSupportConfig__c.getOrgDefaults();
        clientId = objConfig.ConsumerKey__c;
        clientSecret = objConfig.ClientSecret__c;
        username = objConfig.Username__c;
        password = objConfig.Password__c+objConfig.SecurityToken__c;
        endpointURL = objConfig.EndpointURL__c;
                
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        req.setEndpoint(endpointURL+'/services/oauth2/token');//Note if my domain is set up use the proper domain name else use login.salesforce.com for prod or developer or test.salesforce.com for sandbox instance
        System.debug('reqbody---'+reqbody);
        System.debug('req---'+req);
        HttpResponse res = h.send(req);
        
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(res.getbody(), OAuth2.class);
        
        if(String.isNotBlank(objAuthenticationInfo.access_token)){
        
            String username = UserInfo.getUserName();
            Case c = new Case(Subject = subject, Description = description, Type = type, Priority = priority, SuppliedEmail = username);
            String strJSON = JSON.serialize(c);
            
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('accept','application/json');
            req1.setBody(strJSON);//Send JSON body
            req1.setMethod('POST');
            req1.setEndpoint(endpointURL+'/services/data/v39.0/sobjects/Case');
            HttpResponse res1 = h1.send(req1);
            system.debug('RESPONSE_BODY'+res1 .getbody());
            objAuthenticationInfo = (OAuth2)JSON.deserialize(res1.getbody(), OAuth2.class);
            String createdCaseId = String.isNotBlank(objAuthenticationInfo.id)?objAuthenticationInfo.id:'';
            System.debug('resp---'+createdCaseId);
            
            return createdCaseId;
        }
        return null;
    }
    
    public class OAuth2{
        public String id{get;set;}
        public String issued_at{get;set;}
        public String instance_url{get;set;}
        public String signature{get;set;}
        public String access_token{get;set;}    
    }
}