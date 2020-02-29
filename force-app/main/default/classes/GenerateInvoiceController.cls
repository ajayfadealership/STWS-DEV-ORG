public with sharing class GenerateInvoiceController {
    
     public Invoice__c objInvoice { get; set; }
     public String strDocId { get; set; }
     String myAttchId;
     private Boolean isError;
     List<Invoice__c> lstInvoice;
     public Decimal totalUnitPrice { get; set; }
      
     
    public GenerateInvoiceController(){
    		System.debug('>>>>>>>>>>>> Cycle check Constructor');
        myAttchId = '';
        isError = false;
        totalUnitPrice = 0.00;
        if(ApexPages.currentPage().getParameters().get('id') != null) {
        	
           objInvoice = [SELECT BOATBUILDING__Promo_Code__r.Promo_Code_Name__c, BOATBUILDING__Discount_With_Promocode__c, BOATBUILDING__Total_Due_After_Promo__c,BOATBUILDING__Shipping_Charge__c,Comments_Notes__c, 
           					Invoice_Number__c, BOATBUILDING__Discount_Price_ILI__c, BOATBUILDING__Grand_Total_ILI__c, BOATBUILDING__Total_Parts_MSRP_ILI__c, BOATBUILDING__Total_Price_ILI__c, 
           					BOATBUILDING__Total_Quantity_ILI__c, Name, Store_Location__c, City__c,Customer_Address__c,Customer_Name__c, BOATBUILDING__Total_Payment_Formula__c ,Email__c,Id,
           					Phone_Number__c,State__c,Zip_Code__c,Sales_Tax_Percent__c,Sum_Price_Line_Items__c, BOATBUILDING__Sales_TaxPer__c ,Total_Parts_del1__c,
           					Sum_Discount_Availed_on_Line_Items__c,Payment__c,Billing_State_Province__c,Sales_Tax_Formula__c,Total_Amount_on_Invoice__c,Total_Payment__c,Balance__c,
           					Created_Date__c, (SELECT Description__c,Id,Name,Part_Cost__c,Part_Number__c,Part_Vendor__r.Name,Discount_Price__c,Grand_Total__c,Quantity__c,Total_Price__c FROM Invoice_Line_Items__r) FROM Invoice__c Where Id =: ApexPages.currentPage().getParameters().get('id') LIMIT 1];
           if(objInvoice.BOATBUILDING__Shipping_Charge__c == null) {
           		objInvoice.BOATBUILDING__Shipping_Charge__c = 0.00;
           }
           System.debug('log for invoice' +objInvoice); 
           
           	String DocName = 'Standard_Invoice_Banner';
           	if(objInvoice.Store_Location__c != null) {
           		DocName += '_'+objInvoice.Store_Location__c.replaceAll(' ','');
           	}
           	List<Document> lstDoc = [SELECT Id FROM Document Where DeveloperName =: DocName LIMIT 1];
	        if(lstDoc.size() > 0) {
	              strDocId = String.valueOf(lstDoc[0].Id);
	        }
	        else
	        {
	        		List<Document> lstDoc2 = [SELECT Id FROM Document Where DeveloperName = 'Standard_Invoice_Banner' LIMIT 1];
		        if(lstDoc2.size() > 0) {
		              strDocId = String.valueOf(lstDoc2[0].Id);
		        } else {
		        		DocName = 'Company_Logo';
		        		if(objInvoice.Store_Location__c != null) {
		           		DocName += '_'+objInvoice.Store_Location__c.replaceAll(' ','');
		           	}
		            List<Document> lstDoc3 = [SELECT Id FROM Document Where DeveloperName =: DocName LIMIT 1];
		            if(lstDoc3.size() > 0) {
		          		strDocId = String.valueOf(lstDoc3[0].Id);
		            } else {
		            		lstDoc3 = [SELECT Id FROM Document Where DeveloperName = 'Company_Logo' LIMIT 1];
			            if(lstDoc3.size() > 0) {
			          		strDocId = String.valueOf(lstDoc3[0].Id);
			            }
		            }
		        }
	        }
           
           
           
           if(String.isBlank(objInvoice.Customer_Address__c)){
               objInvoice.Customer_Address__c = ' -- ';
               
           }if(String.isBlank(objInvoice.Customer_Name__c)){
               objInvoice.Customer_Name__c = ' -- ';
               
           }if(String.isBlank(objInvoice.City__c)){
               objInvoice.City__c = ' -- ';
               
           }if(String.isBlank(objInvoice.Email__c)){
               objInvoice.Email__c = ' -- ';
               
           }if(String.isBlank(objInvoice.Phone_Number__c)){
               objInvoice.Phone_Number__c = ' -- ';
               
           }if(String.isBlank(objInvoice.Billing_State_Province__c)){
               objInvoice.State__c = ' -- ';
               
           }if(String.isBlank(objInvoice.Zip_Code__c)){
               objInvoice.Zip_Code__c = ' -- ';
               
           }
        }
        else {
            objInvoice =  new Invoice__c();
        } 
    }
    
    public PageReference saveQuoteasPDF() {
    		System.debug('>>>>>>>>>>>> Cycle check saveQuoteasPDF');
        lstInvoice = [Select Id,Email__c,(Select Id, IsDeleted, ParentId,IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp From Attachments) from Invoice__c where Id =: ApexPages.currentPage().getParameters().get('id') limit 1];
        if(lstInvoice[0].Attachments.size() > 0){
            try{ 
                delete lstInvoice[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
             
        }         
        Attachment myAttach = new Attachment();
        if(objInvoice.Id != null){
            myAttach.ParentId = objInvoice.Id;//Id of the object to which the page is attached
            myAttach.name = 'Invoice.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
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
    
    
    public PageReference saveAndSendInvoice(){
        lstInvoice = [Select Id,Email__c,Billing_State_Province__c,(Select Id, IsDeleted, ParentId,IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp From Attachments) from Invoice__c where Id =: ApexPages.currentPage().getParameters().get('id') limit 1];
        if(lstInvoice[0].Attachments.size() > 0){
            try{
                delete lstInvoice[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
              
        }
        Attachment myAttach = new Attachment();
        if(objInvoice.Id != null){
            myAttach.ParentId = objInvoice.Id;//Id of the object to which the page is attached
            myAttach.name = 'Invoice.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
            }
                try{
                    insert myAttach;
                    System.debug('DebugLog For myAttach: '+myAttach + ' ' +objInvoice.Id);
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
            mail.setSubject('** Invoice **');
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
        if(objInvoice.Email__c != null && objInvoice.Email__c != ''){
            mail.setToAddresses(new String[]{objInvoice.Email__c});
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
        return new PageReference('/'+objInvoice.Id);  
    }
    

}