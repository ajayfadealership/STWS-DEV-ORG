global class RefreshDashboardController implements Schedulable {
    
    global static void refreshDashboard(String dashboardID){
        
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        String host = System.Url.getSalesforceBaseURL().toExternalForm();
        String url = host + '/services/data/v53.0/analytics/dashboards/'+dashboardID;
        // set the end point
        request.setEndpoint(url);
        // set GET/POST method
        request.setMethod('PUT'); 
        String sessionId = UserInfo.getSessionId();
        system.debug('Session Id = '+sessionId);
        
        // set authorization header
        request.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        system.debug('User Id = '+UserInfo.getUserId());
        system.debug('Profile Id = '+UserInfo.getProfileId());
        system.debug('Username = '+UserInfo.getUserName()+'. '+UserInfo.getUserType());
        
        system.debug('request = '+request);
        try {
            response = http.send(request);
        } catch(System.Exception e) {
            System.debug('ERROR: '+e);
            throw e;
        }
        
        System.debug(response);
        
    }
    
    global void execute(SchedulableContext sc) {
        
        String strDashboardId = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__TechEfficiencyDashboardId__c;
        if(String.isNotBlank(strDashboardId)){
            refreshDashboard(strDashboardId);
        }
    }
    
    
    /*
System.schedule('RefreshDashboardController 0', '0 0 * * * ? *' , new RefreshDashboardController());
System.schedule('RefreshDashboardController 15', '0 15 * * * ? *' , new RefreshDashboardController());
System.schedule('RefreshDashboardController 30', '0 30 * * * ? *' , new RefreshDashboardController());
System.schedule('RefreshDashboardController 45', '0 45 * * * ? *' , new RefreshDashboardController());
     */
}