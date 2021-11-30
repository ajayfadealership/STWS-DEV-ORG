/** 
    * Author:             Akshay Kumar 
    * Organization:       CloudCodiots LLP. 
    * Created Date:       23/02/2016 
    * Last Modified Date: 01/05/2019 
    */


public with sharing class SendWODetailPageController {
    public Case objCase { get; set; }
    public BOATBUILDING__Work_Order__c objWO { get; set; }
    public String strCC { get; set; }
    public String strSubject { get; set; }
    public String strBody { get; set; }
    public String btnStatus;
    
    //Access Check
    public PageReference checkAccess() { 
        String strAccessKey;
        if(!Test.isRunningTest()){
            strAccessKey = AccessControllCheck.ckeckAccess();
        } else {
            strAccessKey = 'Test String';
        }
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public SendWODetailPageController() {
        strCC = '';
        strSubject = '';
        strBody = '';
        btnStatus = 'SendWO';
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            /*objCase = [SELECT Id,CaseNumber,Contact.Name, ContactID, Contact.Email, Contact.Phone,
                            (Select Id From Attachments) 
                                FROM Case WHERE Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];*/
            objWO = [SELECT Id, Name, Contact__c, Contact__r.Name, Contact__r.Id, Contact__r.Email, Contact__r.Phone,Total_Payment_job__c,
                            (Select Id From Attachments)
                                FROM  BOATBUILDING__Work_Order__c Where Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1]; 
                                
        }
        else {
            objCase = new Case();
            objWO = new BOATBUILDING__Work_Order__c();
        }
    }
    public PageReference sendWO() {
        if(objWO.Contact__c != null) {
            try {
                //Contact objCon = [Select Id, Name, Email, Phone From Contact Where Id =: objWO.Contact__c];
                //objCon.Email = objWO.Contact__r.Email;
                //objCon.Phone = objWO.Contact__r.Phone;
                //System.debug('Email: '+objCon.Email);
                //update objCon; 
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception : '+ex);
                return new PageReference('/'+objWO.Id);
            }
            
                return new PageReference('/apex/BOATBUILDING__CasePDFPageClone2?scontrolCaching=1&id='+objWO.Id+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject+'&btnStatus='+btnStatus+'&woemail='+objWO.Contact__r.Email);
            
        }
        return null;
    }
}