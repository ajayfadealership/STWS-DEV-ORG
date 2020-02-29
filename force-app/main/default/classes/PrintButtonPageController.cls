/** 
* Author : Shobhit Saxena 360 
* Created Date : 21/10/2016
*/
public with sharing class PrintButtonPageController {
    List<BOATBUILDING__Quote__c> lstQuote;
     public String btnStatus;
     
     public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        
        
        return null;
    }
    
    public PrintButtonPageController(ApexPages.StandardController controller) {
        lstQuote = new List<BOATBUILDING__Quote__c>();
        btnStatus = 'Print';
    }
    public PageReference directTo(){
        //            System.debug('Debug_Log for quoteId : '+quoteId);
        lstQuote = [Select Id,Email__c,(Select Id, IsDeleted, ParentId,IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
                                        From Attachments ORDER BY CreatedDate DESC) from BOATBUILDING__Quote__c where Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];
        
        /*else{
            return new PageReference('/apex/Quote_As_PDF_Example?scontrolCaching=1&id='+lstQuote[0].Id);
        }*/
        
        return new PageReference('/apex/Quote_As_PDF_Example?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);
    }
}