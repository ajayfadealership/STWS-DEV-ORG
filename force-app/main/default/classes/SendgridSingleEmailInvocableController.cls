global class SendgridSingleEmailInvocableController {
   
    
    @InvocableMethod(label='Sendgrid Single Email Action')
    global static void getEmailSendInput(List<SendgridEmailWrapper> sendgridEmail) {
       
       
        for(SendgridEmailWrapper objSendgridEmail : sendgridEmail){
            sendSingleSendGridEmail(objSendgridEmail);
        }   
        
    }
   

    
    global static  void sendSingleSendGridEmail(SendgridEmailWrapper notificationRequest){
        try {
            
           /* BOATBUILDING__FADAppConfig__c objConfig = BOATBUILDING__FADAppConfig__c.getOrgDefaults();
            
            notificationRequest.salesforce_org_id = objConfig.BOATBUILDING__AppOrgId__c;
            HttpRequest req = new HttpRequest();
            req.setHeader('Accept', 'application/json');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
            req.setEndpoint(objConfig.BOATBUILDING__AppEndpoint__c+'/api/notification/send');
            req.setMethod('POST'); 
            String body = JSON.serialize(notificationRequest);
            req.setBody(body);
            System.debug('APP req---'+req);
            System.debug('APP body---'+body);
            Http http = new Http();
            if(!Test.isRunningTest()){
                HttpResponse res = http.send(req);
                System.debug('APP res---'+res);
            }   */
            
         } catch (Exception e) {
            //System.debug('error in sending sms '+e.getCause() +'----'+e.getStackTraceString()+'--'+e.getMessage());
        }
    } 
   
    global class SendgridEmailWrapper {
       
        @Invocablevariable(label='From Email' required=true)
        public String fromEmail;
     
        @InvocableVariable(label='To Email' description='' required=true)
        global String toEmail;
     
        @InvocableVariable(label='Subject' description='Subject' required=true)
        global String subject;

        @InvocableVariable(label='Template Id' description='' required=true)
        global String htmlTemplateID;

      
        
      }

      global class to{
        global String email;
      }
      global class from_x{
          global String email;
      }
      /*
      POST https://api.sendgrid.com/v3/mail/send
      {"personalizations": [{"to": [{"email": "ajay@fadealership.com"}]}],"from": {"email": "test@example.com"},"subject": "Sending with SendGrid is Fun","content": [{"type": "text/html", "value": "<b>dsfsdfsdf</b>"}]}
      
      */

}