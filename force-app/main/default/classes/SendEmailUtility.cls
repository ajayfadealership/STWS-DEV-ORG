/**
* Author:              Pradeep Kumar
* Organization:        CloudCodiots LLP.
* Created Date:        02/09/2017
* Last Modified Date:  02/09/2017
* Description:         This is CommonUtility class to send Email to QuickBook Gmail account if any error 
is there in QBIntegration
*/
public with sharing class SendEmailUtility{
    
    public static BOATBUILDING__System_Configure__c objConfig = BOATBUILDING__System_Configure__c.getOrgDefaults();
    public Static void sendEmail(String recordIds, String res){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(Label.QuickBookErrorHandlingwithGmail);
        mail.setToAddresses(sendTo);
        //mail.setReplyTo('pkpundir401@gmail.com');
        mail.setSenderDisplayName('QuickBook Error handling Department');
        List<String> ccTo = new List<String>();
        mail.setSubject('Error from QuickBook WorkOrder Paymeent Id:'+recordIds);
        String body = res;
        mail.setHtmlBody(body);
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    
    public Static void sendEmail(String res){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(Label.QuickBookErrorHandlingwithGmail);
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('QuickBook Error handling Department');
        List<String> ccTo = new List<String>();
        mail.setSubject('QuickBook WorkOrder status');
        String body = res;
        mail.setHtmlBody(body);
        mails.add(mail);
        if(!test.isRunningTest())
            Messaging.sendEmail(mails);
    }
    
    public Static void sendQuickEmail(String res){
        
        if(objConfig.BOATBUILDING__Enable_Debug_Mails__c){
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add('akshay@fadealership.com');
            sendTo.add('sajal@fadealership.com');
            sendTo.add('ajay@fadealership.com');
            mail.setToAddresses(sendTo);
            mail.setSenderDisplayName('Exception');
            List<String> ccTo = new List<String>();
            mail.setSubject('BB Issue');
            String body = res;
            mail.setHtmlBody(body);
            mails.add(mail);
            if(!test.isRunningTest())
                Messaging.sendEmail(mails); 
        }
    }
    
    public Static void sendEmailUtil(List<String> toAddress, List<String> ccAddress, String htmlBody, String subject){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        if(!toAddress.isEmpty()){
            mail.setToAddresses(toAddress);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mails.add(mail);
            System.debug(mail);
            if(!test.isRunningTest())
                Messaging.sendEmail(mails);
        }
    }
    
    public Static void sendEmailwithAttachment(List<String> toAddress, List<String> ccAddress, String htmlBody, String subject, List<Messaging.Emailfileattachment> fileAttachments){
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
        
        if(!toAddress.isEmpty()){
            
            mail.setToAddresses(toAddress);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mail.setFileAttachments(fileAttachments);
            mails.add(mail);
            System.debug(mail);
            if(!test.isRunningTest())
                Messaging.sendEmail(mails);
        }
    }
}