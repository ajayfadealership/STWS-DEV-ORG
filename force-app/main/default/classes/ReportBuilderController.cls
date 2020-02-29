public class ReportBuilderController
{    
    public List<SelectOption> reportsList{get; set;}
    public String selectedReport{get; set;}
    public ReportBuilderController()
    {
        reportsList = new List<SelectOption>();
        for(Report rep : [Select Id, developername from report]){
            reportsList.add(new SelectOption(rep.Id, rep.DeveloperName));
        }
    
    }
    public static String getSFAPIVersion(){
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + '/services/data/'; 
        HttpRequest httpRequest = new HttpRequest();  
        httpRequest.setMethod('GET');   
        httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        httpRequest.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        httpRequest.setEndpoint(restAPIURL);  
        String response = '';
        try {  
                 Http http = new Http();   
                 HttpResponse httpResponse = http.send(httpRequest);  
                 if (httpResponse.getStatusCode() == 200 ) {  
                       response =  JSON.Serialize(JSON.deserializeUntyped(httpResponse.getBody() )); 
                       System.debug(response);
                       return response;
                 } else {  
                       System.debug(' httpResponse ' + httpResponse.getBody() );  
                       return response;
                       //throw new CalloutException( httpResponse.getBody() ); 
                        
                   }
        } catch( System.Exception e) {  
                 System.debug('ERROR: '+ e);  
                 //throw e;  
                 return e.getStackTraceString() +' '+e.getmessage();
        }  
        
        
    }
    @RemoteAction
    public static String getReportType(String reportId)
    {  
        System.JSONParser objJP = JSON.createParser(getSFAPIVersion());
        System.debug(objJP);
        return null;
        
    }
}