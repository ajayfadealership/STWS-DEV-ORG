public with sharing class SendEmailPageController {
    public BOATBUILDING__Dealership_Form__c objDealer { get; set; }
    public String strCC { get; set; }
    public String strTo { get; set; }
    public String strSubject { get; set; }
    public String strBody { get; set; }
    public String btnStatus;
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    public SendEmailPageController() {
        String siteURL = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c;
        strCC = '';
        strSubject = '';
        strBody = '';
        strTo = '';
        btnStatus = 'SendEmail';
        User u = [Select Id, Signature From User Where Id =: UserInfo.getUserId()];
        if(u.Signature != null) {
            strBody = '\n\n\n_____________\n'+u.Signature; 
        }
        
        
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            objDealer = [SELECT Id,  Name, BOATBUILDING__Email__c, BOATBUILDING__Phone__c, BOATBUILDING__Work_Order__r.Name,BOATBUILDING__Customer__r.Name
                         FROM BOATBUILDING__Dealership_Form__c WHERE Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
            strTo = objDealer.Email__c;
            strBody = 'Hello,\n Please find the following inspection form URL:\n'+siteURL+'/apex/BOATBUILDING__ServiceIFPDF?Id='+objDealer.Id;
        }
        else {
            objDealer = new BOATBUILDING__Dealership_Form__c();
        }
    }
    
    public PageReference sendEmail() {
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new  List<String>();
        if(strTo.contains(',')){
            for( String emailId:strTo.split(',')){
                if(emailId != null && emailId !=''){
                    toAddresses.add(emailId.trim());
                }
            }
        }
        else{
            if(strTo != null && strTo !=''){
                toAddresses.add(strTo);
            }  
        }
        email.setToAddresses(toAddresses);
        List<String> CcAddresses = new  List<String>();
        if(strCC.contains(',')){
            for( String emailId:strCC.split(',')){
                if(emailId != null && emailId !=''){
                    CcAddresses.add(emailId.trim());
                }
            }
        }
        else{
            if(strCC != null && strCC !=''){
                CcAddresses.add(strCC);
            }  
        }
        email.setCcAddresses(CcAddresses);
        email.setSubject(strSubject);
        email.setHtmlBody(strBody);
        allMails.add(email);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
        return new PageReference('/'+objDealer.Id);
    }
    
    
    
}