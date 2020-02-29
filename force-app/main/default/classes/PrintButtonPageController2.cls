public with sharing class PrintButtonPageController2 {
    List<BOATBUILDING__Quote__c> lstQuote;
     public String btnStatus;
     public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    public PrintButtonPageController2(ApexPages.StandardController controller) {
        lstQuote = new List<BOATBUILDING__Quote__c>();
        btnStatus = 'Print';
    }
    public PageReference directTo(){
        //            System.debug('Debug_Log for quoteId : '+quoteId);
        lstQuote = [Select Id,Email__c, No_Trailer__c, (Select Id, IsDeleted, ParentId,IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
                                        From Attachments ORDER BY CreatedDate DESC) from BOATBUILDING__Quote__c where Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];
        
        BOATBUILDING__PrintPageConfig__c objPPC = BOATBUILDING__PrintPageConfig__c.getOrgDefaults();
        
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        
        
        if(lstQuote[0].No_Trailer__c) {
            if(objPPC != null) { 
                    if(objPPC.BOATBUILDING__Sales_Page_Skip__c) {
                        return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF_NT_skp__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);
                    } else {
                        return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF_NT__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);
                    }
            } else {
                    return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF_NT__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus); 
            }
            
        } else {
                if(objPPC != null) { 
                    if(objPPC.BOATBUILDING__Sales_Page_Skip__c) {
                        return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF_skp__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);
                    } else {
                        return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);
                    }
            } else {
                    return new PageReference('/apex/'+objSC.BOATBUILDING__Quote_PDF__c +'?scontrolCaching=1&id='+lstQuote[0].Id+'&btnStatus='+btnStatus);    
            }
        }
        
    }
}