public with sharing class PrintButtonPageControllerInvoice {
    List<Invoice__c> lstInvoice;
    public String btnStatus;
    
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public PrintButtonPageControllerInvoice(ApexPages.StandardController controller) {
        lstInvoice = new List<Invoice__c>();
        btnStatus = 'Print';
    }
    public PageReference directToInvoice(){
        String PrintSkip = ApexPages.currentPage().getParameters().get('PrintSkip');
        lstInvoice = [Select Id,Email__c from Invoice__c where Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];
        /* if(lstInvoice[0].Attachments.size() > 0){
try{
delete lstInvoice[0].Attachments;
}
catch(Exception e){
System.debug('ERROR in Deletion' +e);
}

}          */
        /* return new PageReference('/servlet/servlet.FileDownload?file='+lstInvoice[0].Attachments[0].Id); */
        /* else{ */
        if(PrintSkip == '0') { 
            return new PageReference('/apex/BOATBUILDING__Invoice_As_PDF_Example?scontrolCaching=1&id='+lstInvoice[0].Id+'&btnStatus='+btnStatus);
        } else {
            return new PageReference('/apex/BOATBUILDING__Invoice_As_PDF_Exampleskp?scontrolCaching=1&id='+lstInvoice[0].Id+'&btnStatus='+btnStatus);
        }
    }
}