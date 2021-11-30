@RestResource(urlMapping = '/GetQuoteAttachments')
global class GetQuoteAttachments {
    @HttpGet
    global static String doGet() {
        String strQuoteId = RestContext.request.params.get('quoteId');
        String siteBaseURL = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c;
        String strToReturn = siteBaseURL+'apex/BOATBUILDING__QuotePDFPreviewskp?id='+strQuoteId;
        GetAQuoteAttachmentWrapper objWrap = new GetAQuoteAttachmentWrapper(strToReturn, True);
        return JSON.serialize(objWrap);
    }
    
    global Class GetAQuoteAttachmentWrapper {
        global String attachURL;
        global Boolean success;
        
        global GetAQuoteAttachmentWrapper(String attachURL, Boolean success){
            this.attachURL = attachURL;
            this.success = success;
        }
    }
}