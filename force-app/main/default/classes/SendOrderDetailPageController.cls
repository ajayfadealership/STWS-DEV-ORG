public with sharing class SendOrderDetailPageController {
    public Order__c objOrder { get; set; }
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
    public SendOrderDetailPageController() {
        strCC = '';
        strSubject = '';
        strBody = '';
        btnStatus = 'SendOrder';
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            
            objOrder = [Select 
                                Id, 
                                Name,
                                Vendor_Name__r.Name, 
                                Vendor_Name__r.Street__c, 
                                Vendor_Name__r.City__c, 
                                Vendor_Name__r.State__c, 
                                Vendor_Name__r.Zip__c, 
                                Vendor_Name__r.Phone__c, 
                                Vendor_Name__r.Email__c, 
                                Vendor_Name__r.Contact_Person__r.Name,
                                
                                (SELECT 
                                        Id 
                                From 
                                        Attachments)
                                
                        From 
                                Order__c 
                        Where 
                                Id =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
        }
        else {
            objOrder = new Order__c();
        }
    }
    public PageReference sendOrder() {
        if(objOrder.Vendor_Name__r.Phone__c != null && objOrder.Vendor_Name__r.Email__c!= null) {
            
            try {
                update objOrder.Vendor_Name__r;
               
            }
            catch(Exception ex) {
                System.debug('Debug Log For Exception : '+ex);
                return new PageReference('/apex/ServicePage?subTabName=tab-default-3');
            }
            if(objOrder.Attachments.size() > 0) {
                try{
                    delete objOrder.Attachments;
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
        return new PageReference('/apex/Order_As_PDF_Example?scontrolCaching=1&id='+objOrder.Id+'&strCC='+strCC+'&strBody='+strBody+'&strSubject='+strSubject+'&btnStatus='+btnStatus);
    }
}