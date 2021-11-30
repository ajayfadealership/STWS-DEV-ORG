/**
* Author:              Akshay Kumar
* Organization:        360 Degree Cloud Technologies Pvt. Ltd.
* Created Date:        01/02/2017
* Last Modified Date:  13/02/2017
*/
public with sharing class WarrantyWorkOrderControllerClone {
    //public Case objCase { get; set; } 
    public BOATBUILDING__Work_Order__c objCase{get;set;}
    public BOATBUILDING__Work_Order_Job__c objJob { get; set; }
    public List<SelectOption> lstJobs { get; set; }
    public String selectedJob { get; set; }
    public String PrintSkip { get; set; }
    
    public static Id invForPartsRecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByDeveloperName().get('Inventory_for_Parts').getRecordTypeId();
    public static Id warrantyWorkOrderRecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByDeveloperName().get('Warranty_Work_Order').getRecordTypeId();
    public String selectedTech { get; set; }
    public List<SelectOption> techList { get; set; }
    public WarrantyWorkOrderControllerClone() {
        //objCase = new Case();
        
        PrintSkip = '0';
        techList = new List<SelectOption>();
        BOATBUILDING__PrintPageConfig__c objPPC = BOATBUILDING__PrintPageConfig__c.getOrgDefaults();
        if(objPPC != null) { 
            if(objPPC.BOATBUILDING__Service_Page_Skip__c) {
                PrintSkip = '1';
            }
        }
        
        objCase = new BOATBUILDING__Work_Order__c();
        objJob = new BOATBUILDING__Work_Order_Job__c(); 
        lstJobs = new List<SelectOption>();
        lstJobs.add(new SelectOption('', '--None--'));
        Id wwojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Canned Job').getRecordTypeId();
        for(BOATBUILDING__Work_Order_Job__c objJob : [Select Id, Job_Name__c, Name from BOATBUILDING__Work_Order_Job__c Where RecordTypeId =: wwojId limit 999]){
            if(String.isNotBlank(objJob.Job_Name__c))
                lstJobs.add(new SelectOption(objJob.id, objJob.Job_Name__c ));
        }
        List<User> u = [Select Id, Name From User Where UserRole.Name =: 'Service Tech' AND IsActive = true];
        selectedTech = '0'; 
        techList.add(new SelectOption('0', '--None--'));
        for(User objU: u) {
            techList.add(new SelectOption(objU.Id, objU.Name));
        }
        Schema.DescribeFieldResult F = BOATBUILDING__Work_Order__c.BOATBUILDING__Store_Location__c.getDescribe();
        List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
        for (Schema.PicklistEntry pv: pickVals) {
            if (pv.isDefaultValue()) {
                objCase.Store_Location__c = pv.getValue();
            }
        }
    } 
    
    @RemoteAction
    public static BOATBUILDING__Promo_Code__c getPromocodeDetail(String strPCId) {
        return WorkOrderControllerClone.getPromocodeDetail(strPCId);
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Promo_Code__c> getPromocodes() {
        return WorkOrderControllerClone.getPromocodes();
    }
    
    
    @RemoteAction
    public static List<BOATBUILDING__WorkTypePricing__c> fetchWorkTypePricingDetails() {
        return [SELECT Id, Name, Price__c, Active__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]; 
    }
    
    public List<BOATBUILDING__Work_Order__c> getWarrantyWorkOrderList() {
        
        List<BOATBUILDING__Work_Order__c> listWarrantyWorkOrder = [Select Id, Name, Case_Age__c, Status__c ,BOATBUILDING__Contact__r.Name, BOATBUILDING__Boat__r.Boat_HIN_No__c, 
                                                                   BOATBUILDING__Boat__r.Name, BOATBUILDING__Hours__c, BOATBUILDING__Drive__c, BOATBUILDING__Balance__c, 
                                                                   BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__CreatedDate__c, BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c 
                                                                   From BOATBUILDING__Work_Order__c Where RecordTypeId =: warrantyWorkOrderRecordTypeId AND
                                                                   ((NOT Status__c LIKE '%Closed%') AND LastModifiedDate = last_n_days:90) Order By CreatedDate DESC limit 999];
        
        if(!listWarrantyWorkOrder.isEmpty()) {
            return listWarrantyWorkOrder;
        } 
        else { 
            return new List<BOATBUILDING__Work_Order__c>();  
        }
    }
    
    @RemoteAction
    public static List<Object> getContact(String Conid){
        List<Object> contactlist = new List<Object>();
        List <Contact> conlist= [Select BOATBUILDING__Customer_Type__c,MailingState,MailingStreet,Email,MailingPostalCode,MailingCity,Phone From Contact where Id =: Conid];
        if(conlist.size() > 0){
            contactlist.add(conlist);
            List<BOATBUILDING__Service_Module_Tax_Rates__c> lstSMTR = [SELECT
                                                                       Id,
                                                                       Name,
                                                                       Tax__c
                                                                       FROM
                                                                       BOATBUILDING__Service_Module_Tax_Rates__c
                                                                       LIMIT
                                                                       1
                                                                      ];
            if(lstSMTR.size() > 0){
                contactlist.add(lstSMTR);
            }
            List<BOATBUILDING__Shop_Supplies__c> lstSS = [SELECT 
                                                          Name,
                                                          Percentage__c,
                                                          Cap_Amount_for_percent__c
                                                          FROM
                                                          BOATBUILDING__Shop_Supplies__c
                                                         ];
            if(lstSS.size() > 0){
                contactlist.add(lstSS);
            }
            return contactlist;
        }
        else{
            return null;
        }
        
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Item__c> fetchItemsWo(String id ){
        List <BOATBUILDING__Item__c> itemlist= [SELECT Id, Boat_HIN_No__c, Engine_SN__c, BOATBUILDING__Engine_1_Serial_Number__c, BOATBUILDING__Engine_2_Serial_Number__c, BOATBUILDING__Engine_3_Serial_Number__c, BOATBUILDING__Engine_4_Serial_Number__c, Boat_Manufacture_Date__c, Trailer_VIN__c, Boat_Manufacturer__c, Boat_Manufacturer__r.Name, Boat_Model__c, M_Boat_Year__c FROM BOATBUILDING__Item__c where Id =: id];
        if(itemlist.size() > 0){
            return itemlist;
        }
        else{
            return null;
        }
        
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Inventory__c> PopulatePartNumber(){
        
        List<BOATBUILDING__Inventory__c> PartList = [SELECT  
                                                     Vendor__c, 
                                                     Size__c, 
                                                     Part_Number__c, 
                                                     Part_MSRP_Price__c, 
                                                     Part_Location__c, 
                                                     Minimum_Amount__c, 
                                                     Map_Price__c,
                                                     Quantity__c , 
                                                     Family__c, 
                                                     Discount__c, 
                                                     Description__c, 
                                                     Cost__c, 
                                                     Color__c, 
                                                     Category__c,
                                                     Part_Name__c,
                                                     Weight__c
                                                     FROM
                                                     BOATBUILDING__Inventory__c 
                                                     WHERE
                                                     RecordTypeId =: invForPartsRecordTypeId];
        
        return PartList;
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Work_Order_Job__c> getDetailsOfJob(String JobId){  
        List<BOATBUILDING__Work_Order_Job__c> joblist = [SELECT Id, Name, 
                                                         BOATBUILDING__Claim_Status_New__c,
                                                         BOATBUILDING__Claim_Date__c,
                                                         BOATBUILDING__Claim_Approval_Date__c,
                                                         BOATBUILDING__Claim_Labor_Approved_Amount__c,
                                                         BOATBUILDING__Return_Parts_Amount__c,
                                                         BOATBUILDING__Claim_Paid_Date__c,
                                                         BOATBUILDING__Claim_Labor_Paid_Amount__c,
                                                         BOATBUILDING__Parts_Paid_Amount__c,
                                                         BOATBUILDING__Misc_Charge__c,
                                                         BOATBUILDING__Misc_Description_3__c, 
                                                         BOATBUILDING__Misc_Description_2__c, 
                                                         BOATBUILDING__Misc_Description_1__c, 
                                                         BOATBUILDING__Misc_Charge_3__c,  
                                                         BOATBUILDING__Misc_Charge_2__c, 
                                                         Misc_Charge_Paid__c,
                                                         Job_Name__c, Customer_Pay__c, Total_Hours_Job__c, No_of_Labors__c, Price_per_Labor__c, Shop_Supplies_Total__c, 
                                                         Total_Amount_Job__c, Total_Amount_on_Parts_del__c, Total_Cost_Labor__c, Type__c, Worked_Hours__c, Work_Requested__c,  Work_Type__c, 
                                                         (SELECT Id, Name, Part_Name__c, Part_Number__c, Quantity__c, Related_to_Job__c, Select_Part__c, Total__c,Price__c FROM BOATBUILDING__Work_Order_Job_Line_Items__r)
                                                         FROM BOATBUILDING__Work_Order_Job__c where Id =: JobId];
        if(joblist.size() > 0){
            return joblist;
        }
        else{
            return null;
        }
        
    }
    
    public static Date convertStringIntoDate(String strDate) {
        Date objDate;
        String []strSplitedDate= strDate.split('-');
        Integer year = Integer.valueOf(strSplitedDate[0]);
        Integer month = Integer.valueOf(strSplitedDate[1]);
        Integer day = Integer.valueOf(strSplitedDate[2]);
        objDate = Date.newInstance(year, month, day);
        return objDate; 
    } 
    
    @RemoteAction
    public static String createWarrantyWorkOrder(String Strjson) {
        Boolean isError = false;
        Map<String,Object> job ;
        Map<String,Object> map_job_line_item ;
        List<Object> Job_items ; 
        List<Object> Total_job_line_items = new list<Object>();
        List<Object> Job_line_items; 
        BOATBUILDING__Work_Order_Job__c objjob ;
        BOATBUILDING__Work_Order_Job__c objjob2 ; 
        Id wwojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Work Order Job').getRecordTypeId();
        String Contact_Id = '', boatId = '', Drive = '', Hours = '', Status = '', ExistingCaseId = '', StoreLocation = '', CustomerBoatStatus = '', PromoCode = '';
        //Decimal SalesTax_percent  = 0.0; String SalesTax = '0.00';
        List<Object> Jsonlist = (List<Object>)JSON.deserializeUntyped(Strjson);
        for(Object fld : Jsonlist){    
            Map<String,Object> data = (Map<String,Object>)fld;
            Contact_Id = (String)data.get('Contact_Id');
            boatId = (String)data.get('boatId');
            Drive = (String)data.get('Drive');
            Hours = (String)data.get('Hours');
            Status = (String)data.get('Status');
            ExistingCaseId = (String)data.get('WOCaseId');
            if((String)data.get('WOCaseId') != 'null') {
                CustomerBoatStatus = (String)data.get('CustomerBoatStatus');
            }
            if((String)data.get('PromoCode') != 'null') {
                PromoCode = (String)data.get('PromoCode');
            } 
            //SalesTax = (String)data.get('SalesTax');
            //SalesTax_percent = Decimal.valueOf(SalesTax);
            Job_items = (List<Object>)data.get('Job_item');
            StoreLocation = (String)data.get('StoreLocation'); 
            System.debug('log for Job_items'+Job_items);
        }
        
        if(String.isNotBlank(ExistingCaseId)) {
            
            BOATBUILDING__Work_Order__c objCase = [SELECT
                                                   Contact__c,
                                                   Boat__c,
                                                   Drive__c,
                                                   Hours__c,
                                                   Status__c,
                                                   Id,
                                                   BOATBUILDING__Customer_Boat_Status__c,
                                                   Discount__c,
                                                   BOATBUILDING__Balance__c,
                                                   BOATBUILDING__Total_Amount_Due__c,
                                                   BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c,
                                                   (Select Id From BOATBUILDING__Work_Order_Jobs__r)  
                                                   FROM BOATBUILDING__Work_Order__c
                                                   WHERE Id =: ExistingCaseId 
                                                   LIMIT 1];
            
            //BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
            //if(lstRecTypeCase.size() > 0) {
            //  objCase.RecordTypeId = lstRecTypeCase[0].Id;
            //}
            objCase.BOATBUILDING__Customer_Boat_Status__c = CustomerBoatStatus;
            objCase.BOATBUILDING__Contact__c = Contact_Id;        
            objCase.BOATBUILDING__Boat__c = boatId;
            if(String.isNotBlank(PromoCode)) {
                objCase.Promo_Code__c = PromoCode;
            } else {
                objCase.Promo_Code__c = null;
            }
            if(Drive != null) {
                objCase.BOATBUILDING__Drive__c = Drive;
            }
            if(Hours != null) {
                objCase.BOATBUILDING__Hours__c = Hours;
            }
            if(String.isNotBlank(Status)) {
                objCase.BOATBUILDING__Status__c = Status; 
            }
            objCase.BOATBUILDING__Store_Location__c = StoreLocation; 
            try {
                update objCase;
            } 
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            List<BOATBUILDING__Work_Order_Job__c> lstJob = new List<BOATBUILDING__Work_Order_Job__c>();
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> Total_existing_job_line_items = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            List<String> JobIdlst = new List<String>();
            Map<String,String> MapOfExistingId = new Map<String,String>();
            Map<String,List<String>> MapOfExistingValues = new Map<String,List<String>>();
            List<String> UniqueJobIdlst = new List<String>();
            String unique_existing_jobid = '';
            if(objCase.Id != null) {
                if(Job_items.size() > 0){
                    for(Object strJobitems : Job_items) {
                        System.debug('log for strJobitems'+strJobitems);
                        job = (Map<String,Object>)strJobitems;
                        String ExistingJobId = (String)job.get('ExistingJobId');
                        
                        if(ExistingJobId != ''){
                            List<String> Jobvalues = new List<String>();
                            //updated part  
                            String Id = (String)job.get('Id');
                            Jobvalues.add(Id);
                            String JobName = String.valueOf(job.get('JobName'));
                            Jobvalues.add(JobName);
                            String Comments = String.isNotBlank(String.valueOf(job.get('WWOComments'))) ? String.valueOf(job.get('WWOComments')): ''; 
                            Jobvalues.add(Comments);
                            String ClaimStatus = String.isNotBlank(String.valueOf(job.get('Claim_Status'))) ? String.valueOf(job.get('Claim_Status')): ''; 
                            Jobvalues.add(ClaimStatus);
                            String ClaimApprovedAmo = String.isNotBlank(String.valueOf(job.get('Claim_Approved_Amo'))) ? String.valueOf(job.get('Claim_Approved_Amo')): '0.00'; 
                            Jobvalues.add(ClaimApprovedAmo);
                            String PartReturnAmount = String.isNotBlank(String.valueOf(job.get('Return_Part_Amount'))) ? String.valueOf(job.get('Return_Part_Amount')): '0.00'; 
                            Jobvalues.add(PartReturnAmount);
                            String ClaimLaborPaidAmount = String.isNotBlank(String.valueOf(job.get('Claim_Labor_Paid_Amount'))) ? String.valueOf(job.get('Claim_Labor_Paid_Amount')): '0.00';
                            Jobvalues.add(ClaimLaborPaidAmount);
                            String PartPaidAmount = String.isNotBlank(String.valueOf(job.get('Parts_Paid_Amount'))) ? String.valueOf(job.get('Parts_Paid_Amount')): '0.00';
                            Jobvalues.add(PartPaidAmount);
                            String TotalPaid = String.isNotBlank(String.valueOf(job.get('Total_Paid'))) ? String.valueOf(job.get('Total_Paid')): '0.00';
                            Jobvalues.add(TotalPaid);
                            String BalanceDue = String.isNotBlank(String.valueOf(job.get('WWOBalance_Due'))) ? String.valueOf(job.get('WWOBalance_Due')): '0.00';
                            Jobvalues.add(BalanceDue);
                            String ClaimDate = String.isNotBlank(String.valueOf(job.get('Claim_Date'))) ? String.valueOf(job.get('Claim_Date')): '';
                            Jobvalues.add(ClaimDate);
                            String ClaimApprovalDate = String.isNotBlank(String.valueOf(job.get('Claim_Approval_Date'))) ? String.valueOf(job.get('Claim_Approval_Date')): '';
                            Jobvalues.add(ClaimApprovalDate);
                            String ClaimPaidDate = String.isNotBlank(String.valueOf(job.get('Claim_Paid_Date'))) ? String.valueOf(job.get('Claim_Paid_Date')): '';
                            Jobvalues.add(ClaimPaidDate);
                            String WorkType = String.isNotBlank(String.valueOf(job.get('WorkType'))) ? String.valueOf(job.get('WorkType')): '';
                            Jobvalues.add(WorkType);
                            String LaborQuantity = String.isNotBlank(String.valueOf(job.get('Labour_Quantity'))) ? String.valueOf(job.get('Labour_Quantity')): '0.00';
                            Jobvalues.add(LaborQuantity);
                            String LaborPrice = String.isNotBlank(String.valueOf(job.get('Labour_Price'))) ? String.valueOf(job.get('Labour_Price')): '0.00';
                            Jobvalues.add(LaborPrice);
                            
                            
                            String MiscCharge = String.isNotBlank(String.valueOf(job.get('WWOMISCChrge'))) ? String.valueOf(job.get('WWOMISCChrge')): '0.00';
                            Jobvalues.add(MiscCharge);
                            String MiscCharge2 = String.isNotBlank(String.valueOf(job.get('WWOMISCChrge2'))) ? String.valueOf(job.get('WWOMISCChrge2')): '0.00';
                            Jobvalues.add(MiscCharge2);
                            String MiscCharge3 = String.isNotBlank(String.valueOf(job.get('WWOMISCChrge3'))) ? String.valueOf(job.get('WWOMISCChrge3')): '0.00';
                            Jobvalues.add(MiscCharge3);
                            String WWOMISCDesc1 = String.isNotBlank(String.valueOf(job.get('WWOMISCDesc1'))) ? String.valueOf(job.get('WWOMISCDesc1')): '0.00';
                            Jobvalues.add(WWOMISCDesc1);
                            String WWOMISCDesc2 = String.isNotBlank(String.valueOf(job.get('WWOMISCDesc2'))) ? String.valueOf(job.get('WWOMISCDesc2')): '0.00';
                            Jobvalues.add(WWOMISCDesc2);
                            String WWOMISCDesc3 = String.isNotBlank(String.valueOf(job.get('WWOMISCDesc3'))) ? String.valueOf(job.get('WWOMISCDesc3')): '0.00';
                            Jobvalues.add(WWOMISCDesc3);
                            
                            
                            String MiscChargep = String.isNotBlank(String.valueOf(job.get('WWOMISCChrgep'))) ? String.valueOf(job.get('WWOMISCChrgep')): '0.00';
                            Jobvalues.add(MiscChargep);
                            String Discount = String.valueOf(job.get('DiscountOnJob') != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00);
                            Jobvalues.add(Discount);
                            String WWOCUSTComments = String.isNotBlank(String.valueOf(job.get('WWOCUSTComments'))) ? String.valueOf(job.get('WWOCUSTComments')): ''; 
                            Jobvalues.add(WWOCUSTComments); 
                            String TechId = String.isNotBlank(String.valueOf(job.get('TechId'))) ? String.valueOf(job.get('TechId')): ''; 
                            Jobvalues.add(TechId);
                            JobIdlst.add(ExistingJobId);
                            
                            
                            MapOfExistingValues.put(ExistingJobId, Jobvalues); 
                            MapOfExistingId.put(Id,ExistingJobId);
                        }
                        else{
                            Decimal Customer_Pay = 0;
                            objjob = new BOATBUILDING__Work_Order_Job__c();
                            String Id = (String)job.get('Id');  
                            String WorkRequested = (String)job.get('WorkRequested');
                            String WorkType = (String)job.get('WorkType');
                            String Type = (String)job.get('Type');
                            String Line_item_count = (String)job.get('Line_item_count');
                            Decimal Labour_Quantity = Decimal.valueOf(String.valueOf(job.get('Labour_Quantity')));
                            Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                            //Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                            if(String.valueOf(job.get('Customer_Pay')) != null && String.valueOf(job.get('Customer_Pay')) != '') {
                                Customer_Pay = Decimal.valueOf((String)job.get('Customer_Pay'));
                            }
                            //objjob.Work_Requested__c = WorkRequested;
                            objjob.Job_Name__c = String.valueOf(job.get('JobName'));
                            objjob.Work_Type__c = WorkType;
                            objjob.Type__c = Type;
                            objjob.RecordTypeId = wwojId;
                            objjob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objCase.Id;
                            objjob.No_of_Labors__c = Labour_Quantity;
                            objjob.Price_per_Labor__c = Labour_Price;
                            //objjob.Shop_Supplies_Total__c = Shop_Price;
                            objjob.Customer_Pay__c = Customer_Pay;
                            objjob.Unique_Job_id__c = Id;
                            
                            
                            if(String.isNotBlank(String.valueOf(job.get('WWOComments'))))
                                objjob.Comments__c = String.valueOf(job.get('WWOComments'));
                            if(String.isNotBlank(String.valueOf(job.get('WWOCUSTComments'))))
                                objjob.Customer_Comments__c = String.valueOf(job.get('WWOCUSTComments'));
                            if(String.isNotBlank(String.valueOf(job.get('TechId'))))
                                objjob.Technician__c = String.valueOf(job.get('TechId'));
                            if(String.isNotBlank(String.valueOf(job.get('Claim_Status'))))
                                objjob.Claim_Status_New__c = String.valueOf(job.get('Claim_Status'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approved_Amo')))
                                objjob.Claim_Labor_Approved_Amount__c =  Decimal.valueOf((String)job.get('Claim_Approved_Amo'));
                            
                            if(String.isNotBlank((String)job.get('Return_Part_Amount')))
                                objjob.Return_Parts_Amount__c =  Decimal.valueOf((String)job.get('Return_Part_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Labor_Paid_Amount')))
                                objjob.Claim_Labor_Paid_Amount__c =  Decimal.valueOf((String)job.get('Claim_Labor_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Parts_Paid_Amount')))
                                objjob.Parts_Paid_Amount__c =  Decimal.valueOf((String)job.get('Parts_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Total_Paid')))
                                objjob.Total_Paid__c =  Decimal.valueOf((String)job.get('Total_Paid'));
                            
                            if(String.isNotBlank((String)job.get('WWOBalance_Due')))
                                objjob.Balance_Due__c =  Decimal.valueOf((String)job.get('WWOBalance_Due'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Date')))    
                                objjob.Claim_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approval_Date')))    
                                objjob.Claim_Approval_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Approval_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Paid_Date')))    
                                objjob.Claim_Paid_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Paid_Date')));
                            
                            objjob.Misc_Charge__c = Decimal.valueOf((String)job.get('WWOMISCChrge'));
                            objjob.Misc_Charge_2__c = Decimal.valueOf((String)job.get('WWOMISCChrge2'));
                            objjob.Misc_Charge_3__c = Decimal.valueOf((String)job.get('WWOMISCChrge3'));
                            objjob.Misc_Description_1__c = (String)job.get('WWOMISCDesc1');
                            objjob.Misc_Description_2__c = (String)job.get('WWOMISCDesc2');
                            objjob.Misc_Description_3__c = (String)job.get('WWOMISCDesc3');
                            
                            objjob.Misc_Charge_Paid__c = Decimal.valueOf((String)job.get('WWOMISCChrgep'));
                            objjob.Discount__c = String.valueOf(job.get('DiscountOnJob')) != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00;      
                            lstJob.add(objjob); 
                            UniqueJobIdlst.add(Id); 
                            Job_line_items = (List<Object>)job.get('line_items');
                            
                            System.debug('>>>>>>>>>>>line_items: '+Job_line_items);
                            
                            if(Job_line_items.size() >0){
                                for(Object joblineitem : Job_line_items){
                                    Total_job_line_items.add(joblineitem);
                                } 
                            }
                        }
                    }
                }
            } 
            
            
            System.debug('>>>>>>>>>>>JobIdlst: '+JobIdlst);
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJoblineitem = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            if(JobIdlst.size() > 0){ 
                List<BOATBUILDING__Work_Order_Job__c> Existinglstjob = [Select id,RecordTypeId,  Comments__c, Job_Name__c, Claim_Status_New__c, Claim_Labor_Approved_Amount__c, Return_Parts_Amount__c, Claim_Labor_Paid_Amount__c, Parts_Paid_Amount__c, Total_Paid__c,  Work_Type__c,Type__c, Balance_Due__c, Claim_Date__c, Claim_Approval_Date__c, Claim_Paid_Date__c, No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c, Part_Name__c, Part_Number__c, Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where id in : JobIdlst];
                System.debug('debug log for Existinglstjob: '+Existinglstjob);
                System.debug('debug log for MapOfExistingValues: '+MapOfExistingValues);
                
                if(Existinglstjob.size() > 0){
                    
                    for(BOATBUILDING__Work_Order_Job__c listId: Existinglstjob){
                        for (String key : MapOfExistingValues.keySet()) {
                            String keyvalue = key;
                            if(keyvalue.equals(listId.id)) {
                                List<String> listValue = MapOfExistingValues.get(key);
                                if(listId.RecordTypeId == wwojId) {
                                    listId.Unique_Job_id__c = listValue[0]; 
                                    listId.Job_Name__c = listValue[1];
                                    listId.Comments__c = listValue[2];
                                    listId.Claim_Status_New__c = listValue[3];
                                    listId.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                    listId.Claim_Labor_Approved_Amount__c = Decimal.valueOf(listValue[4]);
                                    listId.Return_Parts_Amount__c = Decimal.valueOf(listValue[5]);
                                    listId.Claim_Labor_Paid_Amount__c = Decimal.valueOf(listValue[6]);
                                    listId.Parts_Paid_Amount__c = Decimal.valueOf(listValue[7]);
                                    listId.Total_Paid__c = Decimal.valueOf(listValue[8]);
                                    listId.Balance_Due__c = Decimal.valueOf(listValue[9]);
                                    if(String.isNotBlank(listValue[10])) {
                                        listId.Claim_Date__c = convertStringIntoDate(listValue[10]);
                                    }
                                    
                                    
                                    
                                    if(String.isNotBlank(listValue[11])) {
                                        listId.Claim_Approval_Date__c = convertStringIntoDate(listValue[11]);
                                    } 
                                    
                                    if(String.isNotBlank(listValue[12])) {
                                        listId.Claim_Paid_Date__c = convertStringIntoDate(listValue[12]);
                                    } 
                                    listId.Work_Type__c = listValue[13];
                                    listId.No_of_Labors__c = Decimal.valueOf(listValue[14]);
                                    listId.Price_per_Labor__c = Decimal.valueOf(listValue[15]);
                                    listId.Misc_Charge__c = Decimal.valueOf(listValue[16]); 
                                    listId.Misc_Charge_2__c = Decimal.valueOf(listValue[17]);
                                    listId.Misc_Charge_3__c = Decimal.valueOf(listValue[18]);
                                    listId.Misc_Description_1__c = listValue[19];
                                    listId.Misc_Description_2__c = listValue[20];
                                    listId.Misc_Description_3__c = listValue[21];
                                    listId.RecordTypeId = wwojId;
                                    
                                    listId.Misc_Charge_Paid__c = Decimal.valueOf(listValue[22]);
                                    listId.Discount__c = Decimal.valueOf(listValue[23]);
                                    listId.Customer_Comments__c = String.valueOf(listValue[24]);
                                    if(String.isNotBlank(listValue[25])) {
                                        listId.Technician__c = String.valueOf(listValue[25]);
                                    } 
                                    lstJob.add(listId); 
                                } else {
                                    BOATBUILDING__Work_Order_Job__c objJB = new BOATBUILDING__Work_Order_Job__c();
                                    objJB.Unique_Job_id__c = listValue[0]; 
                                    objJB.Job_Name__c = listValue[1];
                                    objJB.Comments__c = listValue[2];
                                    objJB.Claim_Status_New__c = listValue[3];
                                    objJB.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                    objJB.Claim_Labor_Approved_Amount__c = Decimal.valueOf(listValue[4]);
                                    objJB.Return_Parts_Amount__c = Decimal.valueOf(listValue[5]);
                                    objJB.Claim_Labor_Paid_Amount__c = Decimal.valueOf(listValue[6]);
                                    objJB.Parts_Paid_Amount__c = Decimal.valueOf(listValue[7]);
                                    objJB.Total_Paid__c = Decimal.valueOf(listValue[8]);
                                    objJB.Balance_Due__c = Decimal.valueOf(listValue[9]);
                                    if(String.isNotBlank(listValue[10])) {
                                        objJB.Claim_Date__c = convertStringIntoDate(listValue[10]);
                                    }
                                    
                                    if(String.isNotBlank(listValue[11])) {
                                        objJB.Claim_Approval_Date__c = convertStringIntoDate(listValue[11]);
                                    } 
                                    
                                    if(String.isNotBlank(listValue[12])) {
                                        objJB.Claim_Paid_Date__c = convertStringIntoDate(listValue[12]);
                                    } 
                                    objJB.Work_Type__c = listValue[13];
                                    objJB.No_of_Labors__c = Decimal.valueOf(listValue[14]);
                                    objJB.Price_per_Labor__c = Decimal.valueOf(listValue[15]);
                                    objJB.Misc_Charge__c = Decimal.valueOf(listValue[16]); 
                                    objJB.Misc_Charge_2__c = Decimal.valueOf(listValue[17]);
                                    objJB.Misc_Charge_3__c = Decimal.valueOf(listValue[18]);
                                    objJB.Misc_Description_1__c = listValue[19];
                                    objJB.Misc_Description_2__c = listValue[20];
                                    objJB.Misc_Description_3__c = listValue[21];
                                    objJB.RecordTypeId = wwojId;
                                    
                                    objJB.Misc_Charge_Paid__c = Decimal.valueOf(listValue[22]);
                                    objJB.Discount__c = Decimal.valueOf(listValue[23]); 
                                    objJB.Customer_Comments__c = String.valueOf(listValue[24]);
                                    if(String.isNotBlank(listValue[25])) {
                                        objJB.Technician__c = String.valueOf(listValue[25]);
                                    } 
                                    lstJob.add(objJB);  
                                } 
                                
                                if(listId.BOATBUILDING__Work_Order_Job_Line_Items__r.size() > 0){
                                    for(BOATBUILDING__Work_Order_Job_Line_Item__c objlinitem : listId.BOATBUILDING__Work_Order_Job_Line_Items__r){
                                        //Total_existing_job_line_items.add(objlinitem);  
                                        
                                    }
                                }
                            }
                        }
                    }                    
                }
            }
            
            try { 
                System.debug('>>>>>>>>>>>>>>>>>>>> : '+lstJob);
                upsert lstJob;
                updatePayment(lstJob);
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            System.debug('log for Total_job_line_items'+Total_job_line_items);
            if(Total_job_line_items.size() > 0){
                List<BOATBUILDING__Work_Order_Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Work_Order_Job__c where Unique_Job_id__c in : UniqueJobIdlst];   
                for(Object joblineitemlist : Total_job_line_items) {
                    map_job_line_item = (Map<String,Object>)joblineitemlist;
                    String Id = (String)map_job_line_item.get('Id');
                    System.debug('log for Id'+Id);
                    BOATBUILDING__Work_Order_Job_Line_Item__c obj_job_line_item = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                    Integer PartQuantity = Integer.valueOf(map_job_line_item.get('PartQuantity'));
                    Decimal PartPrice = Decimal.valueOf((String)map_job_line_item.get('PartPrice'));
                    String PartId = (String)map_job_line_item.get('PartId');
                    obj_job_line_item.Quantity__c = PartQuantity;
                    //obj_job_line_item.Select_Part__c = PartId;
                    obj_job_line_item.Part_Number__c = PartId; 
                    obj_job_line_item.Part_Name__c = (String)map_job_line_item.get('PartNameNumber');
                    obj_job_line_item.Price__c = PartPrice;
                    for(BOATBUILDING__Work_Order_Job__c uniqueid : newlstjob){
                        if(Id == uniqueid.Unique_Job_id__c){
                            obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                        }
                    }
                    System.debug('log for obj_job_line_item'+obj_job_line_item);
                    lstJoblineitem.add(obj_job_line_item);
                }
            }
            
            System.debug('log for Total_existing_job_line_items'+Total_existing_job_line_items);
            List<String> uniqueexistingJobIdlst ;
            if(Total_existing_job_line_items.size() > 0){
                uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
                System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
                List<BOATBUILDING__Work_Order_Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Work_Order_Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
                for(BOATBUILDING__Work_Order_Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                    BOATBUILDING__Work_Order_Job_Line_Item__c obj_job_line_item2 = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                    obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
                    obj_job_line_item2.Select_Part__c = joblineitemlist2.Select_Part__c;
                    obj_job_line_item2.Price__c = joblineitemlist2.Price__c;
                    obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                    obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                    for (String key : MapOfExistingId.keySet()) { 
                        String value = MapOfExistingId.get(key);
                        if(value.equals(joblineitemlist2.Related_to_Job__c)){
                            String keyvalue = key;
                            for(BOATBUILDING__Work_Order_Job__c Jobid : newlstjob){
                                if(key.equals(Jobid.Unique_Job_id__c)){
                                    obj_job_line_item2.Related_to_Job__c = Jobid.id;
                                    System.debug('log for Related_to_Job__c'+Jobid.id);
                                }   
                            }
                        }
                    }
                    System.debug('log for obj_job_line_item2'+obj_job_line_item2);
                    lstJoblineitem.add(obj_job_line_item2);
                }
            }
            System.debug('log for lstJoblineitem'+lstJoblineitem);
            try {
                insert lstJoblineitem;
                /*if(objCase.BOATBUILDING__Work_Order_Jobs__r.size() > 0) { 
delete objCase.BOATBUILDING__Work_Order_Jobs__r; 
} */
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
        } else {
            
            BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
            objCase.RecordTypeId = warrantyWorkOrderRecordTypeId;
            objCase.BOATBUILDING__Customer_Boat_Status__c = CustomerBoatStatus;
            objCase.BOATBUILDING__Contact__c = Contact_Id;        
            objCase.BOATBUILDING__Boat__c = boatId;
            if(String.isNotBlank(PromoCode)) {
                objCase.Promo_Code__c = PromoCode;
            } else {
                objCase.Promo_Code__c = null;
            }
            if(Drive != null) {
                objCase.BOATBUILDING__Drive__c = Drive;
            }
            if(Hours != null) {
                objCase.BOATBUILDING__Hours__c = Hours;
            }
            if(String.isNotBlank(Status)) {
                objCase.BOATBUILDING__Status__c = Status; 
            }
            objCase.BOATBUILDING__Store_Location__c = StoreLocation;
            try {
                insert objCase;
            } 
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            List<BOATBUILDING__Work_Order_Job__c> lstJob = new List<BOATBUILDING__Work_Order_Job__c>();
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> Total_existing_job_line_items = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            List<String> JobIdlst = new List<String>();
            Map<String,String> MapOfExistingId = new Map<String,String>();
            List<String> UniqueJobIdlst = new List<String>();
            String unique_existing_jobid = '';
            if(objCase.Id != null) {
                if(Job_items.size() > 0){
                    for(Object strJobitems : Job_items) {
                        System.debug('log for strJobitems'+strJobitems);
                        job = (Map<String,Object>)strJobitems;
                        String ExistingJobId = (String)job.get('ExistingJobId');
                        System.debug('log for ExistingJobId'+(String)job.get('ExistingJobId'));
                        if(ExistingJobId != ''){
                            String Id = (String)job.get('Id');
                            objjob2 = new BOATBUILDING__Work_Order_Job__c(); 
                            objjob2.Unique_Job_id__c = Id; 
                            objjob2.RecordTypeId = wwojId;
                            System.debug('log for objjob2'+objjob2.Unique_Job_id__c);
                            objjob2.Job_Name__c = String.valueOf(job.get('JobName'));
                            
                            if(String.isNotBlank(String.valueOf(job.get('WWOComments'))))
                                objjob2.Comments__c = String.valueOf(job.get('WWOComments'));
                            if(String.isNotBlank(String.valueOf(job.get('WWOCUSTComments'))))
                                objjob2.Customer_Comments__c = String.valueOf(job.get('WWOCUSTComments'));
                            if(String.isNotBlank(String.valueOf(job.get('TechId'))))
                                objjob2.Technician__c = String.valueOf(job.get('TechId'));
                            if(String.isNotBlank(String.valueOf(job.get('Claim_Status'))))
                                objjob2.Claim_Status_New__c = String.valueOf(job.get('Claim_Status'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approved_Amo')))
                                objjob2.Claim_Labor_Approved_Amount__c =  Decimal.valueOf((String)job.get('Claim_Approved_Amo'));
                            
                            if(String.isNotBlank((String)job.get('Return_Part_Amount')))
                                objjob2.Return_Parts_Amount__c =  Decimal.valueOf((String)job.get('Return_Part_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Labor_Paid_Amount')))
                                objjob2.Claim_Labor_Paid_Amount__c =  Decimal.valueOf((String)job.get('Claim_Labor_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Parts_Paid_Amount')))
                                objjob2.Parts_Paid_Amount__c =  Decimal.valueOf((String)job.get('Parts_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Total_Paid')))
                                objjob2.Total_Paid__c =  Decimal.valueOf((String)job.get('Total_Paid'));
                            
                            if(String.isNotBlank((String)job.get('WWOBalance_Due')))
                                objjob2.Balance_Due__c =  Decimal.valueOf((String)job.get('WWOBalance_Due'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Date')))    
                                objjob2.Claim_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approval_Date')))    
                                objjob2.Claim_Approval_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Approval_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Paid_Date')))    
                                objjob2.Claim_Paid_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Paid_Date')));
                            if(String.isNotBlank((String)job.get('WorkType')))     
                                objjob2.Work_Type__c = (String)job.get('WorkType');
                            
                            Decimal Labour_Quantity = Decimal.valueOf(String.valueOf(job.get('Labour_Quantity')));
                            Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price')); 
                            objjob2.No_of_Labors__c = Labour_Quantity;
                            objjob2.Price_per_Labor__c = Labour_Price; 
                            
                            objjob2.Misc_Charge__c = Decimal.valueOf((String)job.get('WWOMISCChrge'));
                            objjob2.Misc_Charge_2__c = Decimal.valueOf((String)job.get('WWOMISCChrge2'));
                            objjob2.Misc_Charge_3__c = Decimal.valueOf((String)job.get('WWOMISCChrge3'));
                            objjob2.Misc_Description_1__c = (String)job.get('WWOMISCDesc1');
                            objjob2.Misc_Description_2__c = (String)job.get('WWOMISCDesc2');
                            objjob2.Misc_Description_3__c = (String)job.get('WWOMISCDesc3');
                            
                            objjob2.Misc_Charge_Paid__c = Decimal.valueOf((String)job.get('WWOMISCChrgep'));     
                            JobIdlst.add(ExistingJobId);
                            MapOfExistingId.put(Id,ExistingJobId);   
                        }
                        else{
                            Decimal Customer_Pay = 0; 
                            objjob = new BOATBUILDING__Work_Order_Job__c();
                            String Id = (String)job.get('Id');  
                            String WorkRequested = (String)job.get('WorkRequested');
                            String WorkType = (String)job.get('WorkType');
                            String Type = (String)job.get('Type');
                            String Line_item_count = (String)job.get('Line_item_count');
                            Decimal Labour_Quantity = Decimal.valueOf(String.valueOf(job.get('Labour_Quantity')));
                            Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                            //Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                            if(String.valueOf(job.get('Customer_Pay')) != null && String.valueOf(job.get('Customer_Pay')) != '') {
                                Customer_Pay = Decimal.valueOf((String)job.get('Customer_Pay'));
                            }
                            //objjob.Work_Requested__c = WorkRequested;
                            objjob.Job_Name__c = String.valueOf(job.get('JobName'));
                            System.debug('WorkType576--'+WorkType);
                            objjob.Work_Type__c = WorkType;
                            objjob.Type__c = Type;
                            objjob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objCase.Id;
                            objjob.No_of_Labors__c = Labour_Quantity;
                            objjob.Price_per_Labor__c = Labour_Price;
                            //objjob.Shop_Supplies_Total__c = Shop_Price;
                            objjob.Customer_Pay__c = Customer_Pay;
                            objjob.Unique_Job_id__c = Id;
                            objjob.RecordTypeId = wwojId;
                            objjob.Misc_Charge__c = Decimal.valueOf((String)job.get('WWOMISCChrge'));
                            objjob.Misc_Charge_2__c = Decimal.valueOf((String)job.get('WWOMISCChrge2'));
                            objjob.Misc_Charge_3__c = Decimal.valueOf((String)job.get('WWOMISCChrge3'));
                            objjob.Misc_Description_1__c = (String)job.get('WWOMISCDesc1');
                            objjob.Misc_Description_2__c = (String)job.get('WWOMISCDesc2');
                            objjob.Misc_Description_3__c = (String)job.get('WWOMISCDesc3');
                            
                            objjob.Misc_Charge_Paid__c = Decimal.valueOf((String)job.get('WWOMISCChrgep'));
                            if(String.isNotBlank(String.valueOf(job.get('WWOComments'))))
                                objjob.Comments__c = String.valueOf(job.get('WWOComments'));
                            if(String.isNotBlank(String.valueOf(job.get('WWOCUSTComments'))))
                                objjob.Customer_Comments__c = String.valueOf(job.get('WWOCUSTComments'));
                            if(String.isNotBlank(String.valueOf(job.get('TechId'))))
                                objjob.Technician__c = String.valueOf(job.get('TechId'));
                                 
                            if(String.isNotBlank(String.valueOf(job.get('Claim_Status'))))
                                objjob.Claim_Status_New__c = String.valueOf(job.get('Claim_Status'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approved_Amo')))
                                objjob.Claim_Labor_Approved_Amount__c =  Decimal.valueOf((String)job.get('Claim_Approved_Amo'));
                            
                            if(String.isNotBlank((String)job.get('Return_Part_Amount')))
                                objjob.Return_Parts_Amount__c =  Decimal.valueOf((String)job.get('Return_Part_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Labor_Paid_Amount')))
                                objjob.Claim_Labor_Paid_Amount__c =  Decimal.valueOf((String)job.get('Claim_Labor_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Parts_Paid_Amount')))
                                objjob.Parts_Paid_Amount__c =  Decimal.valueOf((String)job.get('Parts_Paid_Amount'));
                            
                            if(String.isNotBlank((String)job.get('Total_Paid')))
                                objjob.Total_Paid__c =  Decimal.valueOf((String)job.get('Total_Paid'));
                            
                            if(String.isNotBlank((String)job.get('WWOBalance_Due')))
                                objjob.Balance_Due__c =  Decimal.valueOf((String)job.get('WWOBalance_Due'));
                            
                            if(String.isNotBlank((String)job.get('Claim_Date')))    
                                objjob.Claim_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Approval_Date')))    
                                objjob.Claim_Approval_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Approval_Date')));
                            
                            if(String.isNotBlank((String)job.get('Claim_Paid_Date')))    
                                objjob.Claim_Paid_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Paid_Date')));
                            
                            lstJob.add(objjob);
                            UniqueJobIdlst.add(Id); 
                            Job_line_items = (List<Object>)job.get('line_items');
                            System.debug('>>>>>>>>>: '+Job_line_items);
                            if(Job_line_items.size() >0){
                                for(Object joblineitem : Job_line_items){
                                    Total_job_line_items.add(joblineitem); 
                                } 
                            }
                        }
                    }
                }
            }
            
            
            
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJoblineitem = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            if(JobIdlst.size() > 0){
                List<BOATBUILDING__Work_Order_Job__c> Existinglstjob = [Select id, Job_Name__c, Work_Type__c,Type__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id, Part_Name__c,  Part_Number__c, Price__c,Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where id in : JobIdlst];
                
                if(Existinglstjob.size() > 0){
                    for(BOATBUILDING__Work_Order_Job__c listId: Existinglstjob){
                        //objjob2.Work_Requested__c = listId.Work_Requested__c;
                        //objJob2.Job_Name__c = listId.Job_Name__c;
                        
                        //objjob2.Work_Type__c = listId.Work_Type__c;
                        objjob2.Type__c =  listId.Type__c;
                        objjob2.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objCase.Id; 
                        //objjob2.No_of_Labors__c =  listId.No_of_Labors__c;
                        //objjob2.Price_per_Labor__c = listId.Price_per_Labor__c;  
                        //objjob2.Shop_Supplies_Total__c =  listId.Shop_Supplies_Total__c;
                        objjob2.Customer_Pay__c =  listId.Customer_Pay__c;
                        lstJob.add(objjob2);
                        if(listId.BOATBUILDING__Work_Order_Job_Line_Items__r.size() > 0){
                            for(BOATBUILDING__Work_Order_Job_Line_Item__c objlinitem : listId.BOATBUILDING__Work_Order_Job_Line_Items__r){
                                Total_existing_job_line_items.add(objlinitem);  
                            }
                        }
                    }
                } 
            }
            
            
            try {
                insert lstJob;
                updatePayment(lstJob);
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            System.debug('log for Total_job_line_items'+Total_job_line_items);
            if(Total_job_line_items.size() > 0){
                List<BOATBUILDING__Work_Order_Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Work_Order_Job__c where Unique_Job_id__c in : UniqueJobIdlst];   
                for(Object joblineitemlist : Total_job_line_items) {
                    System.debug('Debug Log for Job Line Items: '+joblineitemlist); 
                    map_job_line_item = (Map<String,Object>)joblineitemlist;
                    String Id = (String)map_job_line_item.get('Id');
                    System.debug('log for Id'+Id);
                    BOATBUILDING__Work_Order_Job_Line_Item__c obj_job_line_item = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                    Integer PartQuantity = Integer.valueOf(map_job_line_item.get('PartQuantity'));
                    Decimal PartPrice = Decimal.valueOf((String)map_job_line_item.get('PartPrice'));
                    String PartId = (String)map_job_line_item.get('PartId');
                    obj_job_line_item.Quantity__c = PartQuantity;
                    //obj_job_line_item.Select_Part__c = PartId;
                    obj_job_line_item.Price__c = PartPrice;
                    obj_job_line_item.Part_Number__c = PartId; 
                    obj_job_line_item.Part_Name__c = (String)map_job_line_item.get('PartNameNumber');
                    
                    for(BOATBUILDING__Work_Order_Job__c uniqueid : newlstjob){
                        if(Id == uniqueid.Unique_Job_id__c){
                            obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                        }
                    }
                    System.debug('log for obj_job_line_item'+obj_job_line_item);
                    lstJoblineitem.add(obj_job_line_item);
                    
                }
            }
            
            System.debug('log for Total_existing_job_line_items'+Total_existing_job_line_items);
            List<String> uniqueexistingJobIdlst ;
            if(Total_existing_job_line_items.size() > 0){
                uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
                System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
                List<BOATBUILDING__Work_Order_Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Work_Order_Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
                for(BOATBUILDING__Work_Order_Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                    BOATBUILDING__Work_Order_Job_Line_Item__c obj_job_line_item2 = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                    obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
                    obj_job_line_item2.Select_Part__c = joblineitemlist2.Select_Part__c;
                    obj_job_line_item2.Price__c = joblineitemlist2.Price__c;
                    obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                    obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                    for (String key : MapOfExistingId.keySet()) {
                        String value = MapOfExistingId.get(key);
                        if(value.equals(joblineitemlist2.Related_to_Job__c)){
                            String keyvalue = key;
                            for(BOATBUILDING__Work_Order_Job__c Jobid : newlstjob){
                                if(key.equals(Jobid.Unique_Job_id__c)){
                                    obj_job_line_item2.Related_to_Job__c = Jobid.id;
                                    System.debug('log for Related_to_Job__c'+Jobid.id);
                                }   
                            }
                        }
                    }
                    System.debug('log for obj_job_line_item2'+obj_job_line_item2);
                    lstJoblineitem.add(obj_job_line_item2);
                }
            }
            System.debug('log for lstJoblineitem'+lstJoblineitem);
            try {
                insert lstJoblineitem;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            
        }
        return 'Success';
        
    }
    
    public static void updatePayment(List<BOATBUILDING__Work_Order_Job__c> lstJob) {
        System.debug('Debug Log For lstJob: '+lstJob);
        if(!lstJob.isEmpty()) {
            Map<String, BOATBUILDING__Work_Order_Job__c> mapWOJ = new Map<String, BOATBUILDING__Work_Order_Job__c>();
            for(BOATBUILDING__Work_Order_Job__c objWOJ: lstJob) {
                mapWOJ.put(objWOJ.Id, objWOJ);
            }
            List<BOATBUILDING__Payments__c> lstWOP = [Select
                                                                Id, Name, BOATBUILDING__Work_Order_Job__c, BOATBUILDING__Claim_Labor_Paid_Amount__c, BOATBUILDING__Misc_Charge_Paid__c, 
                                                                BOATBUILDING__Parts_Paid_Amount__c, BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                                                                BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Approval_Date__c, BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Date__c, 
                                                                BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Labor_Approved_Amount__c,
                                                                BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Labor_Paid_Amount__c, BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Paid_Date__c, 
                                                                BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Claim_Status_New__c, BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Misc_Charge_Paid__c, 
                                                                BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Parts_Paid_Amount__c, BOATBUILDING__Work_Order_Job__r.BOATBUILDING__Return_Parts_Amount__c
                                                                From 
                                                                BOATBUILDING__Payments__c Where BOATBUILDING__Work_Order_Job__c IN: mapWOJ.keySet()];
            Map<String, BOATBUILDING__Payments__c> mapWOJP = new Map<String, BOATBUILDING__Payments__c>();
            for(BOATBUILDING__Payments__c objWOP: lstWOP) {
                mapWOJP.put(objWOP.BOATBUILDING__Work_Order_Job__c, objWOP);
            }       
            List<BOATBUILDING__Payments__c> lstWOPupsrt = new List<BOATBUILDING__Payments__c>();
            for(BOATBUILDING__Work_Order_Job__c objWOJ: lstJob) { 
                if(mapWOJP.containsKey(objWOJ.Id)) { 
                    BOATBUILDING__Payments__c objWOP = mapWOJP.get(objWOJ.Id);
                    objWOP.BOATBUILDING__Work_Warranty_Order__c = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
                    objWOP.BOATBUILDING__Misc_Charge_Paid__c = objWOJ.BOATBUILDING__Misc_Charge_Paid__c;
                    objWOP.BOATBUILDING__Parts_Paid_Amount__c = objWOJ.BOATBUILDING__Parts_Paid_Amount__c;
                    objWOP.BOATBUILDING__Claim_Labor_Paid_Amount__c = objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c;
                    objWOP.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
                    lstWOPupsrt.add(objWOP); 
                } else {
                    if(objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c != null ||
                       objWOJ.BOATBUILDING__Misc_Charge_Paid__c != null || 
                       objWOJ.BOATBUILDING__Parts_Paid_Amount__c != null) {
                           BOATBUILDING__Payments__c objWOPIns = new BOATBUILDING__Payments__c();
                           objWOPIns.BOATBUILDING__Work_Order_Job__c = objWOJ.Id;
                           objWOPIns.BOATBUILDING__Work_Warranty_Order__c = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
                           objWOPIns.BOATBUILDING__Misc_Charge_Paid__c = objWOJ.BOATBUILDING__Misc_Charge_Paid__c;
                           objWOPIns.BOATBUILDING__Parts_Paid_Amount__c = objWOJ.BOATBUILDING__Parts_Paid_Amount__c;
                           objWOPIns.BOATBUILDING__Claim_Labor_Paid_Amount__c = objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c;
                           objWOPIns.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
                           
                           lstWOPupsrt.add(objWOPIns);
                       }
                }           
            }
            upsert lstWOPupsrt;
        }
    }
    
    @RemoteAction
    public static List<String> getClaimStatus() {
        List<String> lstString = new List<String>();
        Schema.DescribeFieldResult fieldResult = BOATBUILDING__Work_Order_Job__c.BOATBUILDING__Claim_Status_New__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple) {
            lstString.add(f.getValue());
        }
        if(!lstString.isEmpty()) {
            return lstString; 
        } else { 
            return null;
        }
    }
    
    
    @RemoteAction 
    public static List<Object> fetchWorkOrder(String objCaseId) {
        
        
        List<Object> lstObj = new List<Object>();
        BOATBUILDING__Work_Order__c objCase = [SELECT 
                                               Account__c,
                                               Contact__c,
                                               ContactEmail__c,
                                               Contact__r.FirstName,
                                               Contact__r.Phone,
                                               Contact__r.LastName,
                                               Contact__r.MailingStreet,
                                               Contact__r.Email,
                                               Customer_Boat_Status__c,
                                               Promo_Code__c,
                                               Contact__r.MailingPostalCode,
                                               Contact__r.MailingCity,
                                               RecordType.Name,
                                               Boat__c,
                                               Boat__r.Name, 
                                               Boat__r.Boat_Model__c,
                                               Boat__r.Boat_HIN_No__c,
                                               Boat__r.Engine_SN__c, 
                                               Boat__r.BOATBUILDING__Engine_1_Serial_Number__c, 
                                               Boat__r.BOATBUILDING__Engine_2_Serial_Number__c, 
                                               Boat__r.BOATBUILDING__Engine_3_Serial_Number__c, 
                                               Boat__r.BOATBUILDING__Engine_4_Serial_Number__c, 
                                               Boat__r.Trailer_VIN__c,
                                               Boat__r.Boat_Manufacturer__c,
                                               Boat__r.Boat_Manufacturer__r.Name,
                                               Boat__r.M_Boat_Year__c,
                                               Boat__r.CreatedDateCustom__c,
                                               Boat__r.BOATBUILDING__Boat_Registration_Number__c,
                                               Name,
                                               Drive__c,
                                               Store_Location__c,
                                               Hours__c,
                                               Discount__c,
                                               Status__c,
                                               Priority__c,
                                               ContactPhone__c,
                                               Total_Parts__c,
                                               Total_Labor__c,
                                               Total_Shop_Supplies__c,
                                               Total__c,
                                               Sales_Tax__c,
                                               Total_Amount_Due__c,
                                               Total_Payment_job__c,
                                               BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c,
                                               BOATBUILDING__Total_Payment_payment__c,
                                               BOATBUILDING__Balance__c,
                                               BOATBUILDING__CreatedDate__c,
                                               ID,
                                               Created_Date_Formula__c
                                               FROM 
                                               BOATBUILDING__Work_Order__c
                                               WHERE  
                                               Id =: objCaseId 
                                               LIMIT 
                                               1];
        List<BOATBUILDING__Work_Order_Job__c> joblist = [Select 
                                                         Work_Type__c, 
                                                         Type__c, 
                                                         Name, 
                                                         Job_Name__c,
                                                         No_of_Labors__c, 
                                                         Price_per_Labor__c, 
                                                         Total_Cost_Labor__c, 
                                                         Shop_Supplies_Total__c, 
                                                         Shipping_Charge__c,
                                                         Total_Amount_Job__c, 
                                                         Total_Amount_on_Parts_del__c,
                                                         Customer_Pay__c,
                                                         Total_Hours_Job__c,
                                                         Worked_Hours__c,
                                                         Discount__c,
                                                         BOATBUILDING__Misc_Charge__c,
                                                         BOATBUILDING__Misc_Description_3__c, 
                                                         BOATBUILDING__Misc_Description_2__c, 
                                                         BOATBUILDING__Misc_Description_1__c, 
                                                         BOATBUILDING__Misc_Charge_3__c,  
                                                         BOATBUILDING__Misc_Charge_2__c, 
                                                         Misc_Charge_Paid__c,
                                                         BOATBUILDING__Claim_Status_New__c,
                                                         BOATBUILDING__Claim_Date__c,
                                                         BOATBUILDING__Claim_Approval_Date__c,
                                                         BOATBUILDING__Claim_Labor_Approved_Amount__c,
                                                         BOATBUILDING__Return_Parts_Amount__c,
                                                         BOATBUILDING__Customer_Comments__c,
                                                         BOATBUILDING__Claim_Paid_Date__c,
                                                         BOATBUILDING__Claim_Labor_Paid_Amount__c,
                                                         BOATBUILDING__Parts_Paid_Amount__c,
                                                         Technician__c,
                                                         Technician__r.Name,
                                                         Id,
                                                         Work_Order_Warranty_Work_Order__r.Description__c,
                                                         Comments__c,
                                                         (Select
                                                          Id,
                                                          Name,
                                                          Part_Number__c,
                                                          Part_Name__c,
                                                          Quantity__c,
                                                          Price__c,
                                                          Total__c,
                                                          Related_to_Job__c
                                                          From
                                                          BOATBUILDING__Work_Order_Job_Line_Items__r
                                                         )
                                                         From 
                                                         BOATBUILDING__Work_Order_Job__c where Work_Order_Warranty_Work_Order__c =: objCase.Id Order By CreatedDate ASC];
        
        lstObj.add(objCase);
        
        if(!joblist.isEmpty()) {
            lstObj.add(joblist);
        }
        
        return lstObj;
    }
    
    @RemoteAction
    public static List<PartResultDiv> searchParts(String strPrtDetail) {       
        
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        Set<String> setPrtNum = new Set<String>();
        String prtDetail = '%'+strPrtDetail+'%';  
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                         Id, 
                                                         Quantity__c, 
                                                         Part_Number__c, 
                                                         Part_Name__c, 
                                                         Part_MSRP_Price__c,
                                                         Cost__c
                                                         From BOATBUILDING__Inventory__c 
                                                         Where (Part_Number__c LIKE: prtDetail OR Part_Name__c LIKE: prtDetail) 
                                                         AND RecordTypeId =: invForPartsRecordTypeId];
        
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Cost__c));
                setPrtNum.add(objInv.Part_Number__c); 
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                              Part_Number__c, 
                                              Name, 
                                              Retail_Price__c, 
                                              Id,
                                              Part_Cost__c 
                                              From BOATBUILDING__Part__c 
                                              Where (Part_Number__c LIKE: prtDetail OR Name LIKE: prtDetail) 
                                              AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Part_Cost__c));
            }                       
        }    
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    }
    
    @RemoteAction
    public static List<PartResultDiv> getFinalList2(List<String> lstPartNum, Map<String, String> objMapForResutData) {
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        System.debug('Debug Log For List: '+lstPartNum);
        Set<String> setPrtNum = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                         Id, 
                                                         Quantity__c, 
                                                         Part_Number__c, 
                                                         Part_Name__c, 
                                                         Part_MSRP_Price__c,
                                                         Cost__c 
                                                         From BOATBUILDING__Inventory__c 
                                                         Where Part_Number__c IN: lstPartNum];
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Cost__c));
                setPrtNum.add(objInv.Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                              Part_Number__c, 
                                              Name, 
                                              Retail_Price__c, 
                                              Part_Cost__c,
                                              Id 
                                              From BOATBUILDING__Part__c 
                                              Where Part_Number__c IN: lstPartNum AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Part_Cost__c));  
            }                       
        } 
        
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    } 
    
    @RemoteAction
    public static List<PartResultDiv> getFinalList(List<String> lstPartNum, Map<String, String> objMapForResutData, String jobIdForCart) {
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        System.debug('Debug Log For List: '+lstPartNum);
        Set<String> setPrtNum = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                         Id, 
                                                         Quantity__c, 
                                                         Part_Number__c, 
                                                         Part_Name__c, 
                                                         Part_MSRP_Price__c,
                                                         Cost__c
                                                         From BOATBUILDING__Inventory__c 
                                                         Where Part_Number__c IN: lstPartNum];
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Cost__c));
                setPrtNum.add(objInv.Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                              Part_Number__c, 
                                              Name, 
                                              Retail_Price__c, 
                                              Id,
                                              Part_Cost__c 
                                              From BOATBUILDING__Part__c 
                                              Where Part_Number__c IN: lstPartNum AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Part_Cost__c)); 
            }                       
        }
        
        if(lstPartResultDiv.size() > 0) {
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJBLI = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            for(PartResultDiv objPartResultDiv: lstPartResultDiv) {
                BOATBUILDING__Work_Order_Job_Line_Item__c objJobLineItem = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                objJobLineItem.Part_Name__c = objPartResultDiv.PartName;
                objJobLineItem.Part_Number__c = objPartResultDiv.PartNumber;
                objJobLineItem.Quantity__c = Decimal.valueOf(objMapForResutData.get(objPartResultDiv.PartNumber)); 
                objJobLineItem.Price__c = objPartResultDiv.MSRP;
                objJobLineItem.Related_to_Job__c = jobIdForCart;
                lstJBLI.add(objJobLineItem);
            } 
            try {
                insert lstJBLI; 
            } catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex);
            }
            Map<String, Integer> mapPartNumberQuantity = new Map<String, Integer>();
            List<PartResultDiv> lstPartResultDivFinal = new List<PartResultDiv>();
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objWOJLI: lstJBLI) {
                lstPartResultDivFinal.add(new PartResultDiv(objWOJLI.Id, objWOJLI.Part_Number__c, objWOJLI.Part_Name__c, Integer.valueOf(objWOJLI.Quantity__c), objWOJLI.Price__c));
                mapPartNumberQuantity.put(objWOJLI.Part_Number__c, Integer.valueOf(objWOJLI.Quantity__c));
            }
            
            
            Set<String> setInventoryPrtNum = new Set<String>();    
            if(mapPartNumberQuantity.keySet().size() > 0){
                List<RecordType> lstRecTypeForInv1 = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Inventory__c' AND DeveloperName = 'Inventory_for_Parts' LIMIT 1];
                
                if(lstRecTypeForInv1.size() > 0) {
                    List<BOATBUILDING__Inventory__c> lstInventory1 = [SELECT Id, Quantity__c, Name, Part_Number__c, Part_Name__c From BOATBUILDING__Inventory__c Where RecordTypeId =: lstRecTypeForInv1[0].Id AND Part_Number__c IN: mapPartNumberQuantity.keySet()];
                    if(lstInventory1.size() > 0) {
                        for(BOATBUILDING__Inventory__c objInv: lstInventory1) {
                            if(objInv.Quantity__c != null) { 
                                objInv.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                            }else {
                                objInv.Quantity__c = mapPartNumberQuantity.get(objInv.Part_Number__c); 
                            }
                            setInventoryPrtNum.add(objInv.Part_Number__c);
                        } 
                    }
                    List<BOATBUILDING__Part__c> lstPrt1 = [Select p.Weight__c, p.Taxable__c, p.Vendor_Name__c, p.Retail_Price__c, p.Part_Size__c, p.Part_Number__c, p.Part_Cost__c, p.Part_Color__c, p.Name, p.Minimum_Amount__c, p.Map_Price__c, p.Location__c, p.Id, p.Family1__c, p.Discount__c, p.Dealer_Price__c, p.Category1__c, p.Bin__c From BOATBUILDING__Part__c p Where Part_Number__c IN: mapPartNumberQuantity.keySet() AND Part_Number__c NOT IN: setInventoryPrtNum];
                    for(BOATBUILDING__Part__c objOLIW: lstPrt1) {
                        if(mapPartNumberQuantity.containsKey(objOLIW.Part_Number__c)){
                            BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
                            objInventory1.Part_Name__c = objOLIW.Name;
                            objInventory1.Size__c = objOLIW.Part_Size__c;
                            objInventory1.Vendor__c = objOLIW.Vendor_Name__c;
                            objInventory1.Part_Number__c = objOLIW.Part_Number__c;
                            objInventory1.Quantity__c = (0 - mapPartNumberQuantity.get(objOLIW.Part_Number__c)); 
                            objInventory1.Cost__c = objOLIW.Part_Cost__c;
                            objInventory1.Category__c = objOLIW.Category1__c;
                            objInventory1.Bin__c = objOLIW.Bin__c;
                            objInventory1.Color__c = objOLIW.Part_Color__c;
                            objInventory1.Discount__c = objOLIW.Discount__c;
                            objInventory1.Part_Location__c = objOLIW.Location__c;
                            objInventory1.Map_Price__c = objOLIW.Map_Price__c;
                            objInventory1.Minimum_Amount__c = objOLIW.Minimum_Amount__c;
                            objInventory1.RecordTypeID = lstRecTypeForInv1[0].Id;
                            objInventory1.Taxable__c= objOLIW.Taxable__c;
                            objInventory1.Weight__c = objOLIW.Weight__c;
                            objInventory1.Part_MSRP_Price__c = objOLIW.Retail_Price__c;
                            lstInventory1.add(objInventory1); 
                        }
                    }
                    try {
                        upsert lstInventory1;
                    }catch(Exception ex) {
                        System.debug('Debug Log For Exception: '+ex);
                    }   
                }
            }
            
            if(!lstPartResultDivFinal.isEmpty()) {
                return lstPartResultDivFinal;
            }
            
            return lstPartResultDiv;
        }   
        return null;
    } 
    
    
    @RemoteAction
    public static List<PartResultDiv> updatePartFromEditableMode(String strJLIId, String strQuantity) {
        List<PartResultDiv> lstPRD = new List<PartResultDiv>();
        String strJobId = ''; 
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI = [SELECT 
                                                                  Id,
                                                                  Quantity__c,
                                                                  Related_to_Job__c
                                                                  FROM BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                  WHERE Id =: strJLIId
                                                                  LIMIT 1];
        lstJLI[0].Quantity__c = Decimal.valueOf(strQuantity);
        try {
            update lstJLI;    
            strJobId = lstJLI[0].Related_to_Job__c;
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLIFinal = [SELECT 
                                                                           Id,
                                                                           Part_Name__c,
                                                                           Part_Number__c,
                                                                           Quantity__c,
                                                                           Related_to_Job__c,
                                                                           Price__c
                                                                           FROM BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                           WHERE Related_to_Job__c =: strJobId];
            if(!lstJLIFinal.isEmpty()) {
                for(BOATBUILDING__Work_Order_Job_Line_Item__c objWOJLI: lstJLIFinal) {
                    lstPRD.add(new PartResultDiv(objWOJLI.Id, objWOJLI.Part_Number__c, objWOJLI.Part_Name__c, Integer.valueOf(objWOJLI.Quantity__c), objWOJLI.Price__c));
                }
            }
            
            
        } catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex);
        }
        return lstPRD;
    }
    
    @RemoteAction
    public static List<PartResultDiv> removeExistingElement(String strJLIID) {
        List<PartResultDiv> lstPRD = new List<PartResultDiv>();
        String strJobId = '';
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI = [SELECT 
                                                                  Id,
                                                                  Quantity__c,
                                                                  Related_to_Job__c
                                                                  FROM BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                  WHERE Id =: strJLIId
                                                                  LIMIT 1];
        strJobId = lstJLI[0].Related_to_Job__c; 
        delete lstJLI;
        
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLIFinal = [SELECT 
                                                                       Id,
                                                                       Part_Name__c,
                                                                       Part_Number__c,
                                                                       Quantity__c,
                                                                       Related_to_Job__c,
                                                                       Price__c
                                                                       FROM BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                       WHERE Related_to_Job__c =: strJobId];
        if(!lstJLIFinal.isEmpty()) {
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objWOJLI: lstJLIFinal) {
                lstPRD.add(new PartResultDiv(objWOJLI.Id, objWOJLI.Part_Number__c, objWOJLI.Part_Name__c, Integer.valueOf(objWOJLI.Quantity__c), objWOJLI.Price__c));
            }
        }
        
        return lstPRD; 
    }
    
    
    @RemoteAction
    public static String removeFromExistingWO(String strJobId) {
        try {
            delete [Select Id From BOATBUILDING__Work_Order_Job__c Where Id =: strJobId Limit 1]; 
        } catch(Exception ex) { 
            return 'Error: '+ex;
        }
        return 'SUCCESS';
    }
    
    
    @RemoteAction
    public static List<List<String>> updatecusnotification(String woId1, String activityType, String lastUpdateDate, String customerNotes, String isCreate){
        system.debug('insideupdatecustomer'+woId1); 
        system.debug('lastUpdateDate'+lastUpdateDate);
        system.debug('customerNotes'+customerNotes); 
        system.debug('isCreate'+isCreate);
        
        Map<String,String>  mapTimeToCustomerNotes = new Map<String,String>();
        DateTime lastupdatedatecus;
        System.debug('>>>>lastUpdateDate: '+lastUpdateDate);
        if(String.isNotBlank(lastUpdateDate)){
            lastupdatedatecus = DateTime.valueOf(lastUpdateDate.replace('T',' ')+':'+'00');
        }
        System.debug('>>>>lastupdatedatecus: '+lastupdatedatecus);
         
        BOATBUILDING__Work_Order__c objWorkOrder = [SELECT Id, BOATBUILDING__Customer_Last_updated__c, Name,
                                                    BOATBUILDING__Customer_Notes__c, BOATBUILDING__Account__c,
                                                    (SELECT Id, BOATBUILDING__Comments__c, BOATBUILDING__Customer_Comments__c  FROM Work_Order_Jobs__r) FROM BOATBUILDING__Work_Order__c 
                                                    WHERE Id =:woId1];
        
        System.debug('Debug Log For objWorkOrder.BOATBUILDING__Customer_Notes__c'+objWorkOrder.BOATBUILDING__Customer_Notes__c);
        
        if(lastupdatedatecus != null) {
            objWorkOrder.BOATBUILDING__Customer_Last_updated__c = lastupdatedatecus;
        }        
        
        List<String> listStringToProcess = new List<String>();
        List<String> listStringToProcessReturn = new List<String>();
        List<String> listStrSWCommentToProcess = new List<String>();
        List<String> listStrCustCommentToProcess = new List<String>();
        List<String> listStrTechnicianCommentToProcess = new List<String>();
        
        List<List<String>> listStrToReturn = new List<List<String>>();
        
        
        Set<Id> setWOJIds = new Set<Id>(); // used in Technician Job Comments
        //Service Writer & Customer Job Comments
        if(objWorkOrder != null){
            if(!objWorkOrder.Work_Order_Jobs__r.isEmpty()){
                for(Work_Order_Job__c woj: objWorkOrder.Work_Order_Jobs__r){
                    setWOJIds.add(woj.Id);
                    if(String.isNotBlank(woj.BOATBUILDING__Customer_Comments__c)){
                        listStrCustCommentToProcess.add(woj.BOATBUILDING__Customer_Comments__c);
                    }
                    
                    if(String.isNotBlank(woj.BOATBUILDING__Comments__c)){
                        listStrSWCommentToProcess.add(woj.BOATBUILDING__Comments__c);
                    }                        
                }
            }
        }
        
        //Technician Job Comments
        List<BOATBUILDING__Time_Management__c> lstTM = [SELECT Id, Name, Service_writer_comment__c 
                                                        FROM BOATBUILDING__Time_Management__c 
                                                        WHERE Related_Work_Order_Job__c IN: setWOJIds 
                                                        AND RecordType.DeveloperName = 'Time_Management_for_Jobs'
                                                        ORDER By CreatedDate DESC];
        
        if(!lstTM.isEmpty()){
            for(BOATBUILDING__Time_Management__c tm: lstTM){
                if(String.isNotBlank(tm.Service_writer_comment__c)){
                    listStrTechnicianCommentToProcess.add(tm.Service_writer_comment__c);
                }
            }
        }
        update objWorkOrder;
        if(isCreate == '1'){
            listStringToProcessReturn.addAll(fetchCustUpdateTask(objWorkOrder.Id));
            /*
            if(String.isNotBlank(objWorkOrder.BOATBUILDING__Customer_Notes__c)){
                if(objWorkOrder.BOATBUILDING__Customer_Notes__c.containsIgnoreCase('~')){
                    listStringToProcess = String.valueOf(objWorkOrder.BOATBUILDING__Customer_Notes__c).split('~');
                } else {
                    listStringToProcess.add(objWorkOrder.BOATBUILDING__Customer_Notes__c);
                }
            }
            
             
            
            if(!listStringToProcess.isEmpty()){
                for(String str: listStringToProcess){
                    listStringToProcessReturn.add(str);
                    System.debug('Debug Log for listStringToProcess'+str); 
                    if(str.containsIgnoreCase('@-@')){
                        List<String> listCustNotesToProcess = new List<String>();
                        listCustNotesToProcess = str.split('@-@'); 
                        if(!listCustNotesToProcess.isEmpty()) {
                            if(listCustNotesToProcess.size()==2){
                                mapTimeToCustomerNotes.put(listCustNotesToProcess.get(0),listCustNotesToProcess.get(1));
                            }
                        }
                    }
                }
            }            
            
            system.debug(mapTimeToCustomerNotes);
*/
            listStrToReturn.add(listStringToProcessReturn);
            listStrToReturn.add(listStrCustCommentToProcess);
            listStrToReturn.add(listStrSWCommentToProcess);
            listStrToReturn.add(listStrTechnicianCommentToProcess);
            return listStrToReturn;
        } else {
            
            createTask(activityType, customerNotes, objWorkOrder.Id);
            createTask(activityType+' For '+objWorkOrder.Name, customerNotes, objWorkOrder.BOATBUILDING__Account__c);
            
            listStringToProcessReturn.addAll(fetchCustUpdateTask(objWorkOrder.Id));
            /*
            if(objWorkOrder.BOATBUILDING__Customer_Notes__c!=null)
                //objWorkOrder.BOATBUILDING__Customer_Notes__c = objWorkOrder.BOATBUILDING__Customer_Notes__c + '||' + lastupdatedatecus + ':'+customerNotes;
                objWorkOrder.BOATBUILDING__Customer_Notes__c = objWorkOrder.BOATBUILDING__Customer_Notes__c + '~' + lastupdatedatecus + '@-@'+customerNotes;
            else
                objWorkOrder.BOATBUILDING__Customer_Notes__c = lastupdatedatecus + '@-@'+customerNotes;
            
            try{
                update objWorkOrder;
            } catch(exception e){
                return null;
            }*/
        }
        listStrToReturn.add(listStringToProcessReturn);
        listStrToReturn.add(listStrCustCommentToProcess);
        listStrToReturn.add(listStrSWCommentToProcess);
        listStrToReturn.add(listStrTechnicianCommentToProcess);
        return listStrToReturn;
    } 
    
    public static List<String> fetchCustUpdateTask(Id parentId){
        
        List<Task> listTaskToProcess = [SELECT Id, Subject, Description, CreatedDate FROM Task WHERE WhatId =: parentId AND Status = 'Completed' ORDER BY CreatedDate Desc];
        List<String> listStrToReturn = new List<String>();
        for(Task t: listTaskToProcess){
            String str = String.valueOf(t.createdDate)+'@-@'+t.Description +' @-@'+t.Subject;
            listStrToReturn.add(str);
        }
        return listStrToReturn;
    }
    public static void createTask(String subject, String description, Id parentId){
                
        Task objTask = new Task();
        objTask.Subject = subject;
        objTask.Description = description;
        objTask.WhatId = parentId;
        objTask.Status = 'Completed';
        insert objTask;
    }
    
    public class PartResultDiv {
        public String Id;
        public String PartNumber;
        public String PartName;
        public Integer Quantity;
        public Decimal MSRP;
        
        public PartResultDiv(String Id, String PartNumber, String PartName, Integer Quantity, Decimal MSRP) {
            this.Id = Id;
            this.PartNumber = PartNumber;
            this.PartName = PartName;
            this.Quantity = Quantity;
            this.MSRP = MSRP;
        }
    }
}