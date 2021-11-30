global class InvocableNotificationController {
   
    
    @InvocableMethod(label='Send Mobile Notifications')
    global static void getNotificationInput(List<NotificationRequest> notificationRequest) {
       
       
        for(NotificationRequest objNotificationRequest : notificationRequest){
            BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
            
            objNotificationRequest.salesforce_org_id = objConfig.BOATBUILDING__AppOrgId__c;
            sendMobileNotifications(JSON.serialize(objNotificationRequest));
        }   
        
    }
   

    @future(Callout = true)
    global static  void sendMobileNotifications(String bodyJSON){
        try {
            
            BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
            HttpRequest req = new HttpRequest();
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
            req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/notification/send');
            req.setMethod('POST'); 
            String body = bodyJSON;
            req.setBody(body);
            System.debug('APP req---'+req);
            System.debug('APP body---'+body);
            Http http = new Http();
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                System.debug('APP res---'+res);
            }  
            
         } catch (Exception e) {
            System.debug('error in sending sms '+e.getCause() +'----'+e.getStackTraceString()+'--'+e.getMessage());
        }
    } 
   
    global class NotificationRequest {
       
       
        public String salesforce_org_id;
     
        @InvocableVariable(label='Salesforce Account Id' description='' required=true)
        global String salesforce_account_id;
     
        @InvocableVariable(label='Notification Title ' description='SMS body' required=true)
        global String title;

        @InvocableVariable(label='Notification Body' description='' required=true)
        global String body;

        @InvocableVariable(label='Notification Type' description='WORK_ORDER, WORK_ORDER_EVENT, WORK_ORDER_JOB' required=true)
        global String notification_type;

        @InvocableVariable(label='Salesforce ref Id' description='Id of the work Order/Invoice or any other object' required=true)
        global String salesforce_ref_id;
     
        
      }

}