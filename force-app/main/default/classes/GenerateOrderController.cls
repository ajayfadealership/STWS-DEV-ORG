public with sharing class GenerateOrderController {
    
    private String myAttchId;
    public String strDocId { get; set; }
    public Order__c objOrder { get; set; }
    public Decimal grandTotal { get; set; }
    public Decimal shippingTotal {get;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 set; }
    List<Order__c> lstOrder;
    private Boolean isError;
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    public GenerateOrderController() {
        isError = false;
        grandTotal = 0.00;
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {
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
                                Vendor_Name__r.Contact_Person__r.Name ,
                                CreatedDate,
                                Shipping_Charges__c,
                                Discount_Price__c,
                                Grand_Total__c,
                                Store_Location__c,
                                (
                                    Select
                                            Id,
                                            Name,
                                            Name__c,
                                            Part_Number_del__c,
                                            Cost__c,
                                            Quantity__c,
                                            Total_Cost__c
                                    From
                                            LineItems__r
                                )
                        From 
                                Order__c 
                        Where 
                                Id =: ApexPages.currentPage().getParameters().get('id')];
            
            for(Line_Items__c objLI: objOrder.LineItems__r) {
                grandTotal += objLI.Total_Cost__c;
                
                
            }
            String DocName = 'Company_Logo';
            if(objOrder.Store_Location__c != null) {
            		DocName = DocName + '_' + objOrder.Store_Location__c.replaceAll(' ','');
            }
            List<Document> lstDoc = [SELECT Id FROM Document Where DeveloperName =: DocName LIMIT 1];
	        if(lstDoc.size() > 0) {
	          strDocId = String.valueOf(lstDoc[0].Id);
	        } else {
	        		List<Document> lstDoc2 = [SELECT Id FROM Document Where DeveloperName = 'Company_Logo' LIMIT 1];
	        		if(lstDoc2.size() > 0) {
	        			strDocId = String.valueOf(lstDoc2[0].Id);
	        		}
	        }
            
        }
    }
    public PageReference saveOrderasPDF() {
       
        lstOrder = [Select 
                                            Id, 
                                            Name,
                                            Vendor_Name__r.Name, 
                                            Vendor_Name__r.Street__c, 
                                            Vendor_Name__r.City__c, 
                                            Vendor_Name__r.State__c, 
                                            Vendor_Name__r.Zip__c, 
                                            Vendor_Name__r.Phone__c, 
                                            Vendor_Name__r.Email__c, 
                                            Vendor_Name__r.Contact_Person__r.Name ,
                                            (
                                                Select 
                                                        Id, 
                                                        IsDeleted, 
                                                        ParentId
                                                From 
                                                        Attachments
                                             ) 
                                                 from 
                                                         Order__c
                                                 Where 
                                                         Id =: ApexPages.currentPage().getParameters().get('id') limit 1];
        if(lstOrder[0].Attachments.size() > 0){
            try{
                delete lstOrder[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
             
        }         
        Attachment myAttach = new Attachment();
        system.debug('objorder'+objorder);
        if(objOrder.Id != null){
            myAttach.ParentId = objOrder.Id; //Id of the object to which the page is attached
            myAttach.name = 'Order.pdf';
            PageReference myPdf = ApexPages.currentPage(); //myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
            }
                try{
                    insert myAttach;
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    // Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }

            
        }
        return new PageReference('/servlet/servlet.FileDownload?file='+myAttchId);
    }
    
    public PageReference saveAndSendOrder() {
        
        lstOrder = [Select Id,Vendor_Name__r.Email__c,(Select Id, IsDeleted, ParentId,IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp From Attachments) from Order__c where Id =: ApexPages.currentPage().getParameters().get('id') limit 1];
        if(lstOrder[0].Attachments.size() > 0){
            try{
                delete lstOrder[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
             
        }
        Attachment myAttach = new Attachment();
        if(objOrder.Id != null){
            myAttach.ParentId = objOrder.Id;//Id of the object to which the page is attached
            myAttach.name = 'Order.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
            }
                try{
                    insert myAttach;
                    System.debug('DebugLog For myAttach: '+myAttach + ' ' +objOrder.Id);
                    myAttchId = myAttach.Id;
                }catch(Exception ex){
                    isError = true;
                    Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL,ex.getMessage()));
                }
            
            
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(ApexPages.currentPage().getParameters().get('strSubject') != null && ApexPages.currentPage().getParameters().get('strSubject') != '') {
            mail.setSubject(ApexPages.currentPage().getParameters().get('strSubject'));
        }
        else {
            mail.setSubject('** Order **');
        }
        if(ApexPages.currentPage().getParameters().get('strBody') != null && ApexPages.currentPage().getParameters().get('strBody') != '') {
            mail.setPlainTextBody(ApexPages.currentPage().getParameters().get('strBody'));
        }
        else {
            mail.setPlainTextBody('Please Find The Attachment.');
        }
        if(ApexPages.currentPage().getParameters().get('strCC') != null && ApexPages.currentPage().getParameters().get('strCC') != '') {
            mail.setCcAddresses(new String[]{ApexPages.currentPage().getParameters().get('strCC')});
        }
        if(objOrder.Vendor_Name__r.Email__c != null && objOrder.Vendor_Name__r.Email__c != ''){
            mail.setToAddresses(new String[]{objOrder.Vendor_Name__r.Email__c});
        }
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment where Id = :myAttach.Id limit 1])
        {
            // Add to attachment file list
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
        }
        mail.setFileAttachments(fileAttachments);
        
        mail.setSenderDisplayName(UserInfo.getOrganizationName());
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        return new PageReference('/'+lstOrder[0].Id);
    }
}