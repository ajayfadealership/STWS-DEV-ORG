public with sharing class SendInvoiceDetailPageController {
    public Invoice__c objInvoice { get; set; }
    public String strCC { get; set; }
    public String strSubject { get; set; }
    public String strBody { get; set; }
    public String btnStatus;
    
	//Access Check
    public PageReference checkAccess() {
    	String strAccessKey = AccessControllCheck.ckeckAccess();
    	
    	if(!strAccessKey.containsIgnoreCase('Service')) {
    		return new PageReference('/apex/ContactToYourAdministrator');
    	}
    	return null;
    } 
    
    public SendInvoiceDetailPageController() {
        strCC = '';
        strSubject = '';
        strBody = '';
        btnStatus = 'SendInvoice';
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            objInvoice = [SELECT Id,Name, Customer_Name__c, Email__c, Phone_Number__c,
                            (Select Id From Attachments) 
                                FROM Invoice__c WHERE Id =: ApexPages.currentPage().getParameters().get('Id') LIMIT 1];
        }
        else {
            objInvoice = new Invoice__c();
        }
    }
    public PageReference sendInvoice() {
        if(objInvoice.Id != null) {
            try {
                update objInvoice;
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception : '+ex);
                return new PageReference('/'+objInvoice.Id);
            }
            /* if(objInvoice.Attachments.size() > 0) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(strSubject != '') {
                    mail.setSubject(strSubject );
                }
                else {
                    mail.setSubject('** Invoice **');
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
                mail.setToAddresses(new String[]{objInvoice.Email__c});
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                Set<Id> setAttId = new Set<Id>();
                for (Attachment objAtt : objInvoice.Attachments) {
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
                
                return new PageReference('/'+objInvoice.Id);
            }
            else {*/
                return new PageReference('/apex/Invoice_As_PDF_Example?scontrolCaching=1&id='+objInvoice.Id+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject+'&btnStatus='+btnStatus);
            /* } */
        }
        return null;
    }
}