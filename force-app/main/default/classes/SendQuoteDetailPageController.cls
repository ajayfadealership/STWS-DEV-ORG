public with sharing class SendQuoteDetailPageController {
    public BOATBUILDING__Quote__c objQuote { get; set; }
    public String strCC { get; set; }
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
    public SendQuoteDetailPageController() {
        strCC = '';
        strSubject = '';
        strBody = '';
        btnStatus = 'SendQuote';
        User u = [Select Id, Signature From User Where Id =: UserInfo.getUserId()];
        if(u.Signature != null) {
                strBody = '\n\n\n_____________\n'+u.Signature;  
        }
        
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            objQuote = [SELECT Id, No_Trailer__c, Name, Email__c, Contact_Name__r.Name, Phone__c, BOATBUILDING__Account_Name__c, 
            					BOATBUILDING__Account_Name__r.Email__c, BOATBUILDING__Account_Name__r.Contact_Email__c,
                            (Select Id From Attachments) 
                                FROM BOATBUILDING__Quote__c WHERE Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
            if(String.isBlank(objQuote.Email__c)) {
            		if(objQuote.BOATBUILDING__Account_Name__c != null) {
            			if(String.isNotBlank(objQuote.BOATBUILDING__Account_Name__r.Email__c)) {
            				objQuote.Email__c = objQuote.BOATBUILDING__Account_Name__r.Email__c;
            			} else if(String.isNotBlank(objQuote.BOATBUILDING__Account_Name__r.Contact_Email__c)) { 
            				objQuote.Email__c = objQuote.BOATBUILDING__Account_Name__r.Contact_Email__c;
            			}
            		}
            }
        }
        else {
            objQuote = new BOATBUILDING__Quote__c();
        }
    }
    public PageReference sendQuote() {
        if(objQuote.Id != null) {
            try {
                update objQuote;
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception : '+ex);
                return new PageReference('/'+objQuote.Id);
            }
            if(objQuote.Attachments.size() > 0) {
                try{
                    delete objQuote.Attachments;
                }
                catch(Exception exp){
                    System.debug('Debug Log for Exception while deleting Attachment records'+exp);
                }
                 
                /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(strSubject != '') {
                    mail.setSubject(strSubject );
                }
                else {
                    mail.setSubject('** Quote **');
                }
                if(strCC != '') {
                    mail.setCcAddresses(new String[]{strCC});
                }
                if(strBody != '') {
                    mail.setPlainTextBody(strBody);
                }
                else {
                    mail.setPlainTextBody('Please Find The Attachment.');
                }
                mail.setToAddresses(new String[]{objQuote.Email__c});
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                Set<Id> setAttId = new Set<Id>();
                for (Attachment objAtt : objQuote.Attachments) {
                        setAttId.add(objAtt.Id);
                }
                List<Attachment> lstAttachment = [Select Id, Name, Body from Attachment where Id IN: setAttId];
                for(Attachment objAttt : lstAttachment) {
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(objAttt.Name);
                    efa.setBody(objAttt.Body);
                    fileAttachments.add(efa);
                }
                mail.setFileAttachments(fileAttachments);
                mail.setSenderDisplayName('Southtown Watersports');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
                
                return new PageReference('/'+objQuote.Id);*/
            }
            /*else{
                return new PageReference('/apex/Quote_As_PDF_Example?scontrolCaching=1&id='+objQuote.Id+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject);
            }*/
        }
        //return null;
        //return new PageReference('/apex/Quote_As_PDF_Example?scontrolCaching=1&id='+objQuote.Id+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject+'&btnStatus='+btnStatus);
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        if(objQuote.No_Trailer__c) {
            return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF_NT__c +'?scontrolCaching=1&id='+objQuote.Id+'&btnStatus='+btnStatus+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject);
        } else { 
            return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF__c +'?scontrolCaching=1&id='+objQuote.Id+'&btnStatus='+btnStatus+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject);
        }
    }
}