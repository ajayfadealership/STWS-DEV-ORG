public class AccountDetailExtensionController {
    public BOATBUILDING__Customer_Inquiry__c objCI {get; set;}
    //public Account acct {get; set;}
    //String myAttchId;
    private Boolean isError;
    public String blankSet { get; set; }
    public AccountDetailExtensionController(ApexPages.StandardController stdController) {
        this.objCI = (BOATBUILDING__Customer_Inquiry__c)stdController.getRecord();
        //acct = [SELECT Id, Lead_Account_History__r.Name,Email__c, BOATBUILDING__Source_URL__c, Lead_Account_History__r.Contact_Phone__c,BOATBUILDING__Lead_Account_History__r.BOATBUILDING__Work_Phone__c FROM Account limit 1]; // WHERE Id =: acct.Id
    	blankSet = '';
    }
    public pagereference printaccount()
    {
        /*Attachment myAttach = new Attachment();
if(acct.Id != null){
myAttach.ParentId = acct.Id;//Id of the object to which the page is attached
myAttach.name = 'Account.pdf';
PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
if(!Test.isRunningTest()){
myAttach.body = myPdf.getContentAsPDF();
}
try{
insert myAttach;
myAttchId = myAttach.Id;
}catch(Exception ex){
isError = true;
// Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
}
}*/
        return new PageReference('/apex/Accountpdf?id='+objCI.Id);
        
    }
}