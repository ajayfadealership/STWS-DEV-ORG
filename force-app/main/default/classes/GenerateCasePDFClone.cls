public with sharing class GenerateCasePDFClone {
    
     public String strDocId { get; set; }
     String myAttchId;
     private Boolean isError;
     List<BOATBUILDING__Work_Order__c> lstCase;
     public List<BOATBUILDING__Work_Order_Job__c> joblist {get; set; }
     public List<Object> lstObject;
     public String WODisclaimer { get; set; }
     
     //Work Order
     public BOATBUILDING__Work_Order__c objWO { get; set; }
     Boolean checkCountry { get; set; }
    //Access Check
    public PageReference checkAccess() { 
        String strAccessKey;
        if(!Test.isRunningTest()){
            strAccessKey = AccessControllCheck.ckeckAccess();
        } else {
            strAccessKey = 'Test String';
        }
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public PageReference backToService() {
            String woType = ApexPages.currentPage().getParameters().get('WOType');
            String strWOName = objWO.Name;
            if(String.isNotBlank(woType)) {
	            if(woType.equalsIgnoreCase('wo')) {
	                return new PageReference('/apex/ServicePage?type=WO&WOId='+strWOName);
	            } else if(woType.equalsIgnoreCase('wwo')) {
	                return new PageReference('/apex/ServicePage?type=WWO&WWOId='+strWOName);
	            }
            }
            return new PageReference('/apex/ServicePage'); 
    }
     
    public GenerateCasePDFClone(){
    		
    		 
    		WODisclaimer = '';
        	BOATBUILDING__System_Configure__c objSCC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        	
        	if(objSCC != null) {
        		if(objSCC.BOATBUILDING__Quote_Disclaimer__c != null) 
        			WODisclaimer = objSCC.BOATBUILDING__WO_Disclaimer__c;
        	} 
    		
    		
        myAttchId = '';
        isError = false;
        
        if(ApexPages.currentPage().getParameters().get('id') != null) {
            //WorkOrder
            
            objWO = [SELECT 
                                Account__c,
                                Contact__c,
                                ContactEmail__c,
                                Contact__r.Name,
                                Contact__r.FirstName,
                                Contact__r.Phone,
                                Contact__r.LastName,
                                Contact__r.MailingStreet,
                                Contact__r.Email,
                                Contact__r.MailingPostalCode,
                                BOATBUILDING__QR_Code__c,
                                Contact__r.MailingCity,
                                Contact__r.MailingState,
                                Contact__r.MailingCountry,
                                RecordType.Name,
                                BOATBUILDING__Promo_Code__c,
                                BOATBUILDING__Promo_Code__r.BOATBUILDING__Promo_Code_Name__c,
                                Boat__c,
                                Boat__r.Name, 
                                Boat__r.Boat_Model__c,
                                 Boat__r.Boat_Registration_Number__c,
                                Boat__r.Boat_HIN_No__c,
                                Boat__r.Engine_SN__c, 
                                Boat__r.Trailer_VIN__c,
                                Boat__r.Boat_Manufacturer__c,
                                Boat__r.Boat_Manufacturer__r.Name,
                                Boat__r.M_Boat_Year__c,
                                Boat__r.CreatedDateCustom__c,
                                CreatedDate,
                                BOATBUILDING__Total_Misc__c,
                                Name,
                                Drive__c,
                                Hours__c,
                                BOATBUILDING__ClosedDate__c,
                                Status__c,
                                Total_Amt_No_Shipping__c,
                                Priority__c,
                                ContactPhone__c,
                                Total_Parts__c,
                                Total_Labor__c,
                                Total_Shop_Supplies__c,
                                Total__c,
                                Sales_Tax__c,
                                Total_Amount_Due__c,
                                Total_Payment_job__c,
                                BOATBUILDING__Total_Payment_payment__c,
                                Deducted_Total_Due_Amount__c,
                                Total_Discount__c,BOATBUILDING__Discount__c,
                                BOATBUILDING__Total_Shipping_Charges__c,
                                Balance__c,
                                Store_Location__c,
                                ID
                        FROM  
                                BOATBUILDING__Work_Order__c
                        WHERE  
                                Id =: ApexPages.currentPage().getParameters().get('id')
                        LIMIT 
                                1];
           
           	String DocName = 'Company_Logo';
            if(objWO.Store_Location__c != null) {
            		DocName = DocName + '_' + objWO.Store_Location__c.replaceAll(' ','');
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
           
           if(String.isBlank(objWO.Contact__r.MailingStreet)){
               objWO.Contact__r.MailingStreet = ' -- ';
               
           }if(String.isBlank(objWO.Contact__r.MailingCity)){
               objWO.Contact__r.MailingCity = ' -- ';
               
           }if(String.isBlank(objWO.Contact__r.MailingPostalCode)){
               objWO.Contact__r.MailingPostalCode = ' -- ';
               
           }if(String.isBlank(objWO.Contact__r.FirstName)){
               objWO.Contact__r.FirstName = ' -- ';
               
           }if(String.isBlank(objWO.Contact__r.Email)){
               objWO.Contact__r.Email = ' -- ';
               
           }
           if(String.isBlank(objWO.Contact__r.MailingCountry) || objWO.Contact__r.MailingCountry.equalsIgnoreCase('us')){
              objWO.Contact__r.MailingCountry = '       '; 
           }
           if(String.isBlank(objWO.Contact__r.MailingStreet)){
               objWO.Contact__r.MailingState = ' -- ';
               
           }
           
            
            
            joblist = [Select 
                                Work_Type__c, 
                                 
                                Type__c, 
                                Name,
                                Job_Name__c,
                                Discount__c,
                                No_of_Labors__c, 
                                Price_per_Labor__c, 
                                Total_Cost_Labor__c, 
                                Shop_Supplies_Total__c, 
                                Total_Amount_Job__c, 
                                Shipping_Charge__c,
                                Customer_Pay__c,
                                Total_Hours_Job__c,
                                Customer_Comments__c,
                                Worked_Hours__c,
                                BOATBUILDING__Misc_Description_3__c, BOATBUILDING__Misc_Description_2__c, BOATBUILDING__Misc_Description_1__c, BOATBUILDING__Misc_Charge__c, BOATBUILDING__Misc_Charge_3__c, BOATBUILDING__Misc_Charge_2__c ,
                                Technician__c, BOATBUILDING__Total_Misc__c,
                                Technician__r.Name, 
                                Work_Order_Warranty_Work_Order__r.Total_Payment_job__c,
                                Work_Order_Warranty_Work_Order__r.Total_Amount_Due__c,
                                Id,
                                    (Select 
                                            Id,
                                            Name,
                                            Select_Part__c,
                                            Part_Name__c,
                                            Part_Number__c,
                                            Quantity__c,
                                            Price__c,
                                            Total__c,
                                            Related_to_Job__c,
                                            Related_to_Job__r.Total_Cost_Labor__c
                                    From
                                            BOATBUILDING__Work_Order_Job_Line_Items__r
                                    )
                        From 
                                BOATBUILDING__Work_Order_Job__c where Work_Order_Warranty_Work_Order__c =: objWO.Id Order By CreatedDate ASC]; 
                                System.debug('Debug Log For objJob: '+joblist);
        }
        else {
            objWO = new BOATBUILDING__Work_Order__c(); 
        }
        
    }
    
   
    
    public PageReference saveCaseasPDF() {
        lstCase = [Select 
                            Id,
                            Contact__r.Email,
                                            (Select Id, 
                                                    IsDeleted, 
                                                    ParentId,
                                                    IsPrivate, 
                                                    OwnerId, 
                                                    CreatedDate, 
                                                    CreatedById, 
                                                    LastModifiedDate, 
                                                    LastModifiedById, 
                                                    SystemModstamp 
                                             From   
                                                    Attachments) 
                   from 
                            BOATBUILDING__Work_Order__c 
                   where 
                            Id =: ApexPages.currentPage().getParameters().get('id') 
                            limit 1];
        if(lstCase.size() > 0){
        
        if(lstCase[0].Attachments.size() > 0){
            try{
                delete lstCase[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
           }
              
        }         
        Attachment myAttach = new Attachment();
        if(objWO.Id != null){
            myAttach.ParentId = objWO.Id;//Id of the object to which the page is attached
            myAttach.name = 'WorkOrder.pdf';
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
    
    
    public PageReference saveAndSendCase(){
        lstCase = [Select 
                            Id,
                            Contact__r.Email,
                                                        (Select 
                                                                    Id, 
                                                                    IsDeleted, 
                                                                    ParentId,
                                                                    IsPrivate,  
                                                                    OwnerId, 
                                                                    CreatedDate, 
                                                                    CreatedById, 
                                                                    LastModifiedDate, 
                                                                    LastModifiedById, 
                                                                    SystemModstamp 
                                                         From 
                                                                    Attachments) 
                   from  
                            BOATBUILDING__Work_Order__c 
                   where 
                            Id =: ApexPages.currentPage().getParameters().get('id') 
                            limit 1];
        if(lstCase.size() > 0){
        if(lstCase[0].Attachments.size() > 0){
            try{
                delete lstCase[0].Attachments;
            }
            catch(Exception e){
                System.debug('ERROR in Deletion' +e);
            }
        }
             
        }
        Attachment myAttach = new Attachment();
        if(objWO.Id != null){
            myAttach.ParentId = objWO.Id;//Id of the object to which the page is attached
            myAttach.name = 'WorkOrder.pdf';
            PageReference myPdf = ApexPages.currentPage();//myPdfPage is the name of your pdf page
            if(!Test.isRunningTest()){
                myAttach.body = myPdf.getContentAsPdf();
            }
                try{
                    insert myAttach;
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
            mail.setSubject('** Work Order **');
        }
        if(ApexPages.currentPage().getParameters().get('strBody') != null && ApexPages.currentPage().getParameters().get('strBody') != '') {
            mail.setPlainTextBody(ApexPages.currentPage().getParameters().get('strBody'));
        }
        else {
            mail.setPlainTextBody('Please Find The Attachment.');
        }
        if(ApexPages.currentPage().getParameters().get('strCC') != null && ApexPages.currentPage().getParameters().get('strCC') != '') {
        		List<String> lst = new List<String>();
        		if(ApexPages.currentPage().getParameters().get('strCC').containsIgnoreCase(',')) {
        			lst = ApexPages.currentPage().getParameters().get('strCC').split(',');
        		} else {
        			lst.add(ApexPages.currentPage().getParameters().get('strCC'));
        		}
            //mail.setCcAddresses(new String[]{ApexPages.currentPage().getParameters().get('strCC')});
            mail.setCcAddresses(lst);
        }
        if(ApexPages.currentPage().getParameters().get('woemail') != null && ApexPages.currentPage().getParameters().get('woemail') != ''){
            mail.setToAddresses(new String[]{ApexPages.currentPage().getParameters().get('woemail')});
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
        return new PageReference('/apex/ServicePage');   
    }
    

}