public with sharing class WorkOrderControllerClone {
    //public Case objCase { get; set; }
    public BOATBUILDING__Work_Order__c objCase{get;set;}
    public BOATBUILDING__Work_Order_Job__c objJob { get; set; }
    public transient List<SelectOption> lstJobs { get; set; }
    public String selectedJob { get; set; }
    public BOATBUILDING__Payments__c objPayment {get; set;}
    public String boatBuildingBalance {get; set;}
    public String baseUrl{get;set;}
    
    public Decimal countCF { get; set; }
    
    public String PrintSkip { get; set; }
    public String selectedTech { get; set; }
    public List<SelectOption> techList { get; set; }
    
    
    public WorkOrderControllerClone() {
        
        PrintSkip = '0';
        techList = new List<SelectOption>();
        BOATBUILDING__PrintPageConfig__c objPPC = BOATBUILDING__PrintPageConfig__c.getOrgDefaults();
        if(objPPC != null) {  
            if(objPPC.BOATBUILDING__Service_Page_Skip__c) {
                PrintSkip = '1';
            }
        }
        
        baseUrl = '';
        BOATBUILDING__EndPointURL__c objEndPointUrl = BOATBUILDING__EndPointURL__c.getInstance('BaseUrlWPay');
        if(objEndPointUrl != null){
            if(String.isNotBlank(objEndPointUrl.BOATBUILDING__URL__c)){
                baseUrl = objEndPointUrl.BOATBUILDING__URL__c;
            }
        }
        countCF = 0.00;
        if(BOATBUILDING__Trigger_Configuration__c.getOrgDefaults().BOATBUILDING__Customer_Notification_Frequency__c != null) {
            countCF = BOATBUILDING__Trigger_Configuration__c.getOrgDefaults().BOATBUILDING__Customer_Notification_Frequency__c;
        } 
        
        //To hold the list of customer notes to show in timeline.
        //mapTimeToCustomerNotes = new Map<String,String>();
        
        //objCase = new Case(); 
        objCase = new BOATBUILDING__Work_Order__c();
        objJob = new BOATBUILDING__Work_Order_Job__c();
        lstJobs = new List<SelectOption>();
        lstJobs.add(new SelectOption('', '--None--'));
        boatBuildingBalance = '';
        objPayment = new BOATBUILDING__Payments__c();
        
        Id workOrderRecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId(); 
        objCase.RecordTypeId = workOrderRecordTypeId;
        
        objPayment.BOATBUILDING__Work_Warranty_Order__c = objCase.Id;
        Id wojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Canned Job').getRecordTypeId(); 
        List<BOATBUILDING__Work_Order_Job__c> listWOJob = [SELECT Id, Name, Job_Name__c FROM BOATBUILDING__Work_Order_Job__c Where RecordTypeId =: wojId ORDER By CreatedDate DESC LIMIT 999];
        for(BOATBUILDING__Work_Order_Job__c objJob :listWOJob){
            if(objJob.Job_Name__c != null) {
                lstJobs.add(new SelectOption(objJob.id, objJob.Job_Name__c));
            }
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
    public static User getUserInfo(String strUserId) {
        return [Select Id, Name From User Where Id =: strUserId]; 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__WorkTypePricing__c> fetchWorkTypePricingDetails() {
        return [SELECT Id, Name, Price__c, Active__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]; 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Work_Order__c> getWOWholeList() {
        List<RecordType> lstRecordType = [SELECT
                                          Id
                                          FROM
                                          RecordType
                                          WHERE
                                          SobjectType = 'BOATBUILDING__Work_Order__c'
                                          AND
                                          DeveloperName = 'Work_Order'];
        
        
        if(lstRecordType.size() > 0) {
            return [Select 
                    BOATBUILDING__Backend_Customer_Flag_Count__c, Id, BOATBUILDING__Customer_Boat_Status__c, Name, Case_Age__c, BOATBUILDING__Contact__c, Status__c , BOATBUILDING__Customer_Notification_Flag__c ,BOATBUILDING__Contact__r.Name, BOATBUILDING__Boat__r.Boat_HIN_No__c, 
                    BOATBUILDING__Hours__c, BOATBUILDING__Drive__c, BOATBUILDING__Balance__c, BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__CreatedDate__c, BOATBUILDING__Boat__c, BOATBUILDING__Boat__r.Name, 
                    BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c 
                    From 
                    BOATBUILDING__Work_Order__c 
                    Where
                    RecordTypeId =: lstRecordType[0].Id AND ((NOT Status__c LIKE '%Closed%') AND LastModifiedDate = last_n_days:90) Order By CreatedDate DESC Limit 9999];
        } 
        return new List<BOATBUILDING__Work_Order__c>();                                     
    }
    
    public List<BOATBUILDING__Work_Order__c> getWorkOrderList() {
        List<RecordType> lstRecordType = [SELECT
                                          Id
                                          FROM
                                          RecordType
                                          WHERE
                                          SobjectType = 'BOATBUILDING__Work_Order__c'
                                          AND
                                          DeveloperName = 'Work_Order'];
        if(lstRecordType.size() > 0) {
            //return [Select Id, CaseNumber, Boat__r.Boat_HIN_No__c, Contact.Name, Hours__c, Drive__c From Case Where RecordTypeId =: lstRecordType[0].Id];
            return [Select Id, Name, Case_Age__c, Status__c , BOATBUILDING__Customer_Notification_Flag__c ,BOATBUILDING__Contact__r.Name, BOATBUILDING__Boat__r.Boat_HIN_No__c, BOATBUILDING__Hours__c, BOATBUILDING__Drive__c, BOATBUILDING__Balance__c, BOATBUILDING__Total_Amount_Due__c,BOATBUILDING__CreatedDate__c, BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c From BOATBUILDING__Work_Order__c Where RecordTypeId =: lstRecordType[0].Id
                    Order By CreatedDate DESC limit 999];  
            
        } 
        else { 
            // return new List<Case>(); 
            return new List<BOATBUILDING__Work_Order__c>();   
        }
    } 
    
    @RemoteAction
    public static List<Object> getContact(String Conid, String sLocation){
        List<Object> contactlist = new List<Object>();
        List <Contact> conlist= [Select MailingState, Account.BOATBUILDING__Account_Customer_Type__c, Account.BOATBUILDING__Customer_Balance__c,BOATBUILDING__Customer_Type__c,MailingStreet,Email,MailingPostalCode,MailingCity,Phone From Contact where Id =: Conid];
        if(conlist.size() > 0){
            contactlist.add(conlist);
            Decimal RegularSalestax = 0.00;
            if(sLocation != null) {
                BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(sLocation);
                RegularSalestax = objBoatBuilderUtil.getRegularSalestax(); 
                //contactlist.add(RegularSalestax);
                contactlist.add(new STDetails(RegularSalestax, objBoatBuilderUtil.getLaborTax(), objBoatBuilderUtil.getPartsTax(), objBoatBuilderUtil.getSSTax(), objBoatBuilderUtil.getMISCTax()));
                
            } else { 
                //contactlist.add(new List<BOATBUILDING__Service_Module_Tax_Rates__c>().add(new BOATBUILDING__Service_Module_Tax_Rates__c(Name = '---', Tax__c = 0.00)));
                contactlist.add(new STDetails(0.00, false, false, false, false)); 
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
    public static STDetails getSalesTax(String strSL) {
        Decimal st = 0.00;
        BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(strSL);
        st = objBoatBuilderUtil.getRegularSalestax();
        
        return new STDetails(st, objBoatBuilderUtil.getLaborTax(), objBoatBuilderUtil.getPartsTax(), objBoatBuilderUtil.getSSTax(), objBoatBuilderUtil.getMISCTax()); 
    }
    
    public class STDetails {
        public Decimal tax { get; set; }
        public Integer STonParts { get; set; }
        public Integer STonLabor { get; set; }
        public Integer STonSS { get; set; }
        public Integer STonMISC { get; set; }
        public STDetails(Decimal tax, Boolean laborBools, Boolean partsBools, Boolean ssBools, Boolean miscBools) {
            this.tax = tax;
            if(laborBools) {
                STonLabor = 1;
            } else {
                STonLabor = 0;
            }
            
            if(partsBools) {
                STonParts = 1;
            } else {
                STonParts = 0;
            }
            
            if(ssBools) {
                STonSS = 1;
            } else {
                STonSS = 0;
            }
            
            if(miscBools) {
                STonMISC = 1;
            } else {
                STonMISC = 0;
            }
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
    public static List<PartWrapper> PopulatePartNumber(){
        List<PartWrapper> lstPrtWrpr = new List<PartWrapper>();
        /*Set<String> setPartNumber = new Set<String>(); 
List<RecordType> lstRecTypeInv = [SELECT
Id,
Name
FROM
RecordType
WHERE
DeveloperName = 'Inventory_for_Parts'
AND
SobjectType = 'BOATBUILDING__Inventory__c'
LIMIT
1];
if(lstRecTypeInv.size() > 0) {                                            
List<BOATBUILDING__Inventory__c> PartList = [SELECT  
Part_Number__c, 
Part_MSRP_Price__c,
Quantity__c , 
Id,
Part_Name__c

FROM
BOATBUILDING__Inventory__c 
WHERE
RecordTypeId =: lstRecTypeInv[0].Id
ORDER BY CreatedDate DESC LIMIT 49999];
System.debug('Debug Log For PartList: '+PartList);
if(PartList.size() > 0) {
for(BOATBUILDING__Inventory__c objInv: PartList) {
lstPrtWrpr.add(new PartWrapper(String.valueOf(objInv.Id), String.valueOf(objInv.Part_Name__c), objInv.Part_Number__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
setPartNumber.add(objInv.Part_Number__c);
}
}                                       
}
List<BOATBUILDING__Part__c> lstPrt = [SELECT Id, Name, Part_Number__c, Retail_Price__c From BOATBUILDING__Part__c WHERE Part_Number__c NOT IN: setPartNumber ORDER BY CreatedDate DESC LIMIT 49999];
//System.debug('Debug Log For lstPrt:'+lstPrt); 
if(lstPrt.size() > 0) {
for(BOATBUILDING__Part__c objPart: lstPrt) {
lstPrtWrpr.add(new PartWrapper(String.valueOf(objPart.Id), objPart.Name, objPart.Part_Number__c, 0, objPart.Retail_Price__c));  
}
}           
System.debug('Debug log for lstPrtWrpr: '+lstPrtWrpr);*/                            
        return lstPrtWrpr; 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Work_Order_Job__c> getDetailsOfJob(String JobId) {  
        List<BOATBUILDING__Work_Order_Job__c> joblist = [SELECT Id, Name, BOATBUILDING__Misc_Charge__c,
                                                         BOATBUILDING__Misc_Description_3__c, 
                                                         BOATBUILDING__Misc_Description_2__c, 
                                                         BOATBUILDING__Misc_Description_1__c, 
                                                         BOATBUILDING__Misc_Charge_3__c, 
                                                         BOATBUILDING__Taxable__c,
                                                         BOATBUILDING__Technician__c,
                                                         BOATBUILDING__Technician__r.Name,
                                                         BOATBUILDING__Misc_Charge_2__c, Job_Name__c, Comments__c, Work_Requested__c, 
                                                         Customer_Pay__c, Total_Hours_Job__c, No_of_Labors__c, Price_per_Labor__c, 
                                                         Shop_Supplies_Total__c, Total_Amount_Job__c, Total_Amount_on_Parts_del__c, 
                                                         Total_Cost_Labor__c, Type__c, Worked_Hours__c,  Work_Type__c, 
                                                         (SELECT Id, Name, Quantity__c, Related_to_Job__c, Part_Name__c, Part_Number__c, Total__c,Price__c FROM BOATBUILDING__Work_Order_Job_Line_Items__r)
                                                         FROM BOATBUILDING__Work_Order_Job__c where Id =: JobId];
        if(joblist.size() > 0){ 
            return joblist;
        } 
        else{
            return null;
        }
        
    }
    
    @RemoteAction
    public static String createWorkOrder(String Strjson) {
        Set<String> setLstJobId = new Set<String>(); 
        try {
            
            Id wojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Work Order Job').getRecordTypeId();
            List<BOATBUILDING__Shop_Supplies__c> lstSPS = BOATBUILDING__Shop_Supplies__c.getAll().values();
            Decimal decSSPer = 0.00;  
            Decimal decSSCap = 0.00; 
            if(lstSPS.size() > 0) {
                decSSPer = lstSPS[0].Percentage__c;
                decSSCap = lstSPS[0].Cap_Amount_for_percent__c;
            }   
            Map<String, Integer> mapPartNumberQuantity = new Map<String, Integer>();
            List<BOATBUILDING__Work_Order_Job__c> lstJob = new List<BOATBUILDING__Work_Order_Job__c>();
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> Total_existing_job_line_items = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
            List<String> JobIdlst = new List<String>();
            List<String> UniqueJobIdlst = new List<String>();
            Map<String,String> MapOfExistingId = new Map<String,String>();
            Map<String,List<String>> MapOfExistingValues = new Map<String,List<String>>();
            Set<String> setInventoryPrtNum = new Set<String>();
            Boolean isError = false;
            Map<String,Object> job ;
            Map<String,Object> map_job_line_item ;
            List<Object> Job_items ; 
            List<Object> Total_job_line_items = new list<Object>();
            List<Object> Job_line_items; 
            BOATBUILDING__Work_Order_Job__c objjob; BOATBUILDING__Work_Order_Job__c objjob2 ;
            String Contact_Id = '', boatId = '', Drive = '', Hours = '', Status = '', CaseId = '', WOCreatedDate ='', WOStoreLocation = '', CustomerBoatStatus = '', PromoCode = '';
            Decimal SalesTax_percent  = 0.0, DiscountOnWO = 0.00; String SalesTax = '0.00';
            List<Object> Jsonlist = (List<Object>)JSON.deserializeUntyped(Strjson);
            
            for(Object fld : Jsonlist){    
                Map<String,Object> data = (Map<String,Object>)fld;
                Contact_Id = (String)data.get('Contact_Id');
                boatId = (String)data.get('boatId');
                if((String)data.get('CaseId') != 'null'){
                    CaseId = (String)data.get('CaseId');
                }
                if((String)data.get('Drive') != 'null'){
                    Drive = (String)data.get('Drive');
                }
                if((String)data.get('Hours') != 'null'){
                    Hours = (String)data.get('Hours');
                }
                if((String)data.get('Status') != 'null'){
                    Status = (String)data.get('Status');
                }
                if((String)data.get('DiscountOnWO') != 'null'){
                    DiscountOnWO = Decimal.valueOf((String)data.get('DiscountOnWO'));
                }
                if((String)data.get('WOCreatedDate') != 'null'){
                    WOCreatedDate = (String)data.get('WOCreatedDate');
                }
                if((String)data.get('CustomerBoatStatus') != 'null'){
                    CustomerBoatStatus = (String)data.get('CustomerBoatStatus');
                }
                if((String)data.get('PromoCode') != 'null'){
                    PromoCode = (String)data.get('PromoCode');
                }
                WOStoreLocation = (String)data.get('StoreLocation'); 
                SalesTax = (String)data.get('SalesTax');
                SalesTax_percent = Decimal.valueOf(SalesTax);
                Job_items = (List<Object>)data.get('Job_item');
                System.debug('log for Job_items'+Job_items);
            }
            
            if(CaseId == '') {        
                Id woRTId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
                //objCase.RecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work_Order').getRecordTypeId();
                BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
                //if(lstRecTypeCase.size() > 0) {
                objCase.RecordTypeId = woRTId;
                //}
                objCase.Contact__c = Contact_Id;
                Contact objCon = [Select Id, MailingState, AccountId,Email, Phone From Contact Where Id =: Contact_Id Limit 1];
                String MailingState = '---';
                if(objCon.MailingState != null) {
                    MailingState = objCon.MailingState; 
                }
                
                if(objCon.AccountId != null) {
                    objCase.BOATBUILDING__Account__c = objCon.AccountId; 
                }
                if(objCon.Email != null) {
                    objCase.BOATBUILDING__ContactEmail__c = objCon.Email; 
                }
                if(objCon.Phone != null) {
                    objCase.BOATBUILDING__ContactPhone__c = objCon.Phone; 
                } 
                
                BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(WOStoreLocation);
                Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();   
                System.debug('Debug log For RegularSalestax: '+RegularSalestax);
                objCase.Boat__c = boatId;
                objCase.BOATBUILDING__Customer_Boat_Status__c = CustomerBoatStatus;
                objCase.Drive__c = Drive;
                objCase.Hours__c = Hours;
                objCase.Status__c = Status;
                objCase.Discount__c = DiscountOnWO;
                objCase.Sales_Tax_Percent__c = RegularSalestax; 
                objCase.Store_Location__c = WOStoreLocation;
                if(String.isNotBlank(PromoCode)) {
                    objCase.Promo_Code__c = PromoCode;
                } else {
                    objCase.Promo_Code__c = null;
                } 
                
                system.debug('Debug log for CreatedDate :' + WOCreatedDate);
                if(String.isNotBlank(WOCreatedDate)) {
                    List<String> strDate = String.valueOf(WOCreatedDate).split('-');
                    Integer year = Integer.valueOf(strDate[0]);
                    Integer month = Integer.valueOf(strDate[1]);
                    Integer day = Integer.valueOf(strDate[2]);
                    objCase.CreatedDate__c = Datetime.newInstance(year, month, day);
                }
                //try {
                insert objCase;
                //}
                //catch(Exception ex) {
                //  isError = true;
                // System.debug('Debug Log For Exception : '+ex);
                //}
                
                
                String unique_existing_jobid = '';
                if(objCase.Id != null) { 
                    if(Job_items.size() > 0){
                        for(Object strJobitems : Job_items) {
                            System.debug('log for strJobitems'+strJobitems);
                            job = (Map<String,Object>)strJobitems;
                            String ExistingJobId = (String)job.get('ExistingJobId');
                            System.debug('log for ExistingJobId'+(String)job.get('ExistingJobId'));
                            if(ExistingJobId != ''){
                                List<String> Jobvalues = new List<String>();
                                String Id = (String)job.get('Id');
                                String JobName = (String)job.get('JobName');
                                String ApprovedByCustomer = String.valueOf((String)job.get('ApprovedByCustomer') == '1' ? true : false);
                                String Discount = String.valueOf(job.get('DiscountOnJob') != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00);
                                String WorkType = String.valueOf(job.get('WorkType'));
                                String Labour_Quantity = String.valueOf(job.get('Labour_Quantity'));
                                String Labour_Price = String.valueOf(job.get('Labour_Price'));
                                String ShippingCharge = '0.00';
                                String TechId = '';
                                if(String.valueOf(job.get('ShippingCharge')) != '') {
                                    ShippingCharge = String.valueOf(job.get('ShippingCharge'));
                                }
                                if(String.valueOf(job.get('TechId')) != '') {
                                    TechId = String.valueOf(job.get('TechId'));
                                }
                                String comments = '';
                                if(String.valueOf(job.get('Comments')) != '') {
                                    comments = String.valueOf(job.get('Comments'));
                                }
                                
                                String Custcomments = ''; 
                                if(String.valueOf(job.get('CustComments')) != '') {
                                    Custcomments = String.valueOf(job.get('CustComments'));
                                }
                                
                                String miscShrge = '0.00';
                                if(String.valueOf(job.get('MiscCharge')) != '') {
                                    miscShrge = String.valueOf(job.get('MiscCharge'));
                                }
                                String miscShrge2 = '0.00';
                                if(String.valueOf(job.get('MiscCharge2')) != '') {
                                    miscShrge2 = String.valueOf(job.get('MiscCharge2'));
                                }
                                String miscShrge3 = '0.00';
                                if(String.valueOf(job.get('MiscCharge3')) != '') {
                                    miscShrge3 = String.valueOf(job.get('MiscCharge3'));
                                }
                                
                                String MiscDesc1 = '';
                                if(String.valueOf(job.get('MiscDesc1')) != '') {
                                    MiscDesc1 = String.valueOf(job.get('MiscDesc1'));
                                }
                                String MiscDesc2 = '';
                                if(String.valueOf(job.get('MiscDesc2')) != '') {
                                    MiscDesc2 = String.valueOf(job.get('MiscDesc2'));
                                }
                                String MiscDesc3 = '';
                                if(String.valueOf(job.get('MiscDesc3')) != '') {
                                    MiscDesc3 = String.valueOf(job.get('MiscDesc3'));
                                }
                                String taxBool =  String.valueOf(job.get('taxBool'));
                                
                                JobIdlst.add(ExistingJobId);
                                Jobvalues.add(Id);
                                Jobvalues.add(JobName);
                                Jobvalues.add(ApprovedByCustomer);
                                Jobvalues.add(Discount);
                                Jobvalues.add(WorkType);
                                Jobvalues.add(Labour_Quantity);
                                Jobvalues.add(ShippingCharge);
                                Jobvalues.add(comments);
                                Jobvalues.add(miscShrge);
                                Jobvalues.add(miscShrge2); 
                                Jobvalues.add(miscShrge3);
                                
                                Jobvalues.add(MiscDesc1);
                                Jobvalues.add(MiscDesc2);
                                Jobvalues.add(MiscDesc3);
                                Jobvalues.add(Custcomments);
                                Jobvalues.add(taxBool);
                                Jobvalues.add(TechId);
                                
                                MapOfExistingValues.put(ExistingJobId, Jobvalues);
                                MapOfExistingId.put(Id,ExistingJobId);
                                System.debug('log for MapOfExistingValues'+MapOfExistingValues); 
                                System.debug('log for map'+MapOfExistingId);    
                            }
                            else{
                                Decimal Customer_Pay = 0;
                                objjob = new BOATBUILDING__Work_Order_Job__c();
                                String Id = (String)job.get('Id');  
                                String strJobName = (String)job.get('JobName');
                                String WorkRequested = (String)job.get('WorkRequested');
                                String WorkType = (String)job.get('WorkType');
                                String Type = (String)job.get('Type');
                                String Line_item_count = (String)job.get('Line_item_count');
                                Decimal Labour_Quantity = Decimal.valueOf((String)job.get('Labour_Quantity'));
                                Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                                //Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                                Decimal Shop_Price = 0.00;
                                Decimal Shipping = 0.00;
                                if(String.valueOf(job.get('ShippingCharge')) != '') {
                                    Shipping = Decimal.valueOf(String.valueOf(job.get('ShippingCharge')));
                                }                 
                                
                                objjob.Taxable__c = String.valueOf(job.get('taxBool')) == '1'? true: false;
                                
                                if(String.valueOf(job.get('Comments')) != '') {
                                    objjob.Comments__c = String.valueOf(job.get('Comments'));
                                }
                                
                                if(String.valueOf(job.get('CustComments')) != '') {
                                    objjob.Customer_Comments__c = String.valueOf(job.get('CustComments'));
                                }
                                
                                if(String.valueOf(job.get('MiscCharge')) != '') {
                                    objjob.Misc_Charge__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge')));
                                }
                                if(String.valueOf(job.get('MiscCharge2')) != '') {
                                    objjob.Misc_Charge_2__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge2')));
                                }
                                if(String.valueOf(job.get('MiscCharge3')) != '') {
                                    objjob.Misc_Charge_3__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge3')));
                                } 
                                
                                if(String.valueOf(job.get('MiscDesc1')) != '') {
                                    objjob.Misc_Description_1__c = String.valueOf(job.get('MiscDesc1'));
                                }
                                if(String.valueOf(job.get('MiscDesc2')) != '') {
                                    objjob.Misc_Description_2__c = String.valueOf(job.get('MiscDesc2'));
                                } 
                                if(String.valueOf(job.get('MiscDesc3')) != '') {
                                    objjob.Misc_Description_3__c = String.valueOf(job.get('MiscDesc3'));
                                }
                                if(String.valueOf(job.get('TechId')) != '') {
                                    objjob.BOATBUILDING__Technician__c = String.valueOf(job.get('TechId'));
                                }
                                
                                System.debug('Debug Log for Misc_Charge__c: '+objjob.Misc_Charge__c);
                                /*if(String.valueOf(job.get('Customer_Pay')) != null && String.valueOf(job.get('Customer_Pay')) != ''){
Customer_Pay = Decimal.valueOf((String)job.get('Customer_Pay'));
}*/
                                objjob.RecordTypeId = wojId;
                                objjob.Approved_By_Customer__c = String.valueOf(job.get('ApprovedByCustomer')) == '1' ? true : false; 
                                objJob.Discount__c  = String.valueOf(job.get('DiscountOnJob')) != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00;
                                objjob.Job_Name__c = strJobName;
                                //objjob.Work_Requested__c = WorkRequested;
                                objjob.Work_Type__c = WorkType;
                                objjob.Type__c = Type;
                                objjob.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                objjob.Shipping_Charge__c = Shipping;
                                objjob.No_of_Labors__c = Labour_Quantity;
                                objjob.Price_per_Labor__c = Labour_Price;
                                //objjob.Shop_Supplies_Total__c = 0.00;
                                Shop_Price = (Labour_Price * decSSPer)/100; 
                                System.debug('Debug log For Shop SHupplies: '+Shop_Price+' : ' + Labour_Price +' : '+decSSPer+ ' : ' +decSSCap);
                                if(Shop_Price <= decSSCap && decSSCap > 0) {
                                    objjob.Shop_Supplies_Total__c = Shop_Price;    
                                } else if(Shop_Price <= decSSCap) {
                                    objjob.Shop_Supplies_Total__c = Shop_Price;
                                } else {
                                    objjob.Shop_Supplies_Total__c = decSSCap;
                                } 
                                
                                //objjob.Customer_Pay__c = Customer_Pay;
                                objjob.Unique_Job_id__c = Id;
                                lstJob.add(objjob);
                                UniqueJobIdlst.add(Id);
                                Job_line_items = (List<Object>)job.get('line_items');
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
                    List<String> existingJobvalueslst = new List<String>(MapOfExistingValues.keySet());
                    List<BOATBUILDING__Work_Order_Job__c> Existinglstjob = [Select id, Job_Name__c, Work_Type__c,Type__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c, Part_Name__c, Part_Number__c, Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where id in : JobIdlst];
                    System.debug('log for Existinglstjob'+Existinglstjob);
                    if(Existinglstjob.size() > 0){
                        for(BOATBUILDING__Work_Order_Job__c listId: Existinglstjob){
                            for (String key : MapOfExistingValues.keySet()) {
                                String keyvalue = key;
                                if(keyvalue.equals(listId.id)){
                                    List<String> listValue = MapOfExistingValues.get(key);
                                    
                                    objjob2 = new BOATBUILDING__Work_Order_Job__c(); 
                                    objjob2.Unique_Job_id__c = listValue[0]; 
                                    objjob2.Job_Name__c = listValue[1];
                                    objjob2.Approved_By_Customer__c = Boolean.valueOf(listValue[2]);
                                    objJob2.Discount__c = Decimal.valueOf(listValue[3]);
                                    objjob2.RecordTypeId = wojId;
                                    //objjob2.Work_Requested__c = listId.Work_Requested__c;
                                    objjob2.Work_Type__c = listValue[4];
                                    objjob2.Type__c =  listId.Type__c;
                                    objjob2.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                    objjob2.No_of_Labors__c =  Decimal.valueOf(listValue[5]);
                                    objjob2.Shipping_Charge__c =  Decimal.valueOf(listValue[6]);
                                    
                                    objjob2.Comments__c = String.valueOf(listValue[7]);
                                    objjob2.Misc_Charge__c = Decimal.valueOf(listValue[8]);
                                    objjob2.Misc_Charge_2__c = Decimal.valueOf(listValue[9]);
                                    objjob2.Misc_Charge_3__c = Decimal.valueOf(listValue[10]);
                                    
                                    objjob2.Misc_Description_1__c = listValue[11];
                                    objjob2.Misc_Description_2__c = listValue[12];
                                    objjob2.Misc_Description_3__c = listValue[13]; 
                                    objjob2.Customer_Comments__c = listValue[14];
                                    objjob2.Taxable__c = listValue[15] == '1'? true: false;
                                    objjob2.BOATBUILDING__Technician__c = String.isNotBlank(listValue[16])? listValue[16]: objjob2.BOATBUILDING__Technician__c; 
                                    objjob2.Price_per_Labor__c = [Select Price__c, Name From WorkTypePricing__c Where Name =: listValue[4] Limit 1].Price__c;
                                    //objjob2.Shop_Supplies_Total__c =  listId.Shop_Supplies_Total__c;
                                    
                                    //objjob2.Customer_Pay__c =  listId.Customer_Pay__c;
                                    lstJob.add(objjob2);
                                    if(listId.BOATBUILDING__Work_Order_Job_Line_Items__r.size() > 0){
                                        for(BOATBUILDING__Work_Order_Job_Line_Item__c objlinitem : listId.BOATBUILDING__Work_Order_Job_Line_Items__r){
                                            Total_existing_job_line_items.add(objlinitem);  
                                            
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
                
                System.debug('log for JobIdlst'+JobIdlst);
                
                //try {
                insert lstJob;
                for(BOATBUILDING__Work_Order_Job__c objJb: lstJob) {
                    setLstJobId.add(objJb.Id);
                }
                //}
                //catch(Exception ex) {
                //  isError = true;
                // System.debug('Debug Log For Exception : '+ex);
                //}
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
                        //obj_job_line_item.Select_Part__c = ;
                        obj_job_line_item.Part_Number__c = PartId;
                        obj_job_line_item.Price__c = PartPrice;
                        String strPrtNameNumber = (String)map_job_line_item.get('PartName');
                        if(strPrtNameNumber != null) {
                            obj_job_line_item.Part_Name__c = strPrtNameNumber;
                        } 
                        for(BOATBUILDING__Work_Order_Job__c uniqueid : newlstjob){
                            if(Id == uniqueid.Unique_Job_id__c){
                                obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                            }
                        } 
                        lstJoblineitem.add(obj_job_line_item);
                        mapPartNumberQuantity.put(obj_job_line_item.Part_Number__c, Integer.valueOf(obj_job_line_item.Quantity__c));
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
                        obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                        obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                        obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
                        obj_job_line_item2.Price__c = joblineitemlist2.Price__c;
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
                        lstJoblineitem.add(obj_job_line_item2);
                        mapPartNumberQuantity.put(obj_job_line_item2.Part_Number__c, Integer.valueOf(obj_job_line_item2.Quantity__c));
                    }
                }
                //try {
                insert lstJoblineitem;
                //}
                //catch(Exception ex) {
                //  isError = true;
                // System.debug('Debug Log For Exception : '+ex);
                //} 
                
                if(mapPartNumberQuantity.keySet().size() > 0){
                    List<RecordType> lstRecTypeForInv = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Inventory__c' AND DeveloperName = 'Inventory_for_Parts' LIMIT 1];
                    
                    if(lstRecTypeForInv.size() > 0) {
                        List<Parts_Availability__c> lstPA = new List<Parts_Availability__c>();
                        List<BOATBUILDING__Inventory__c> lstInventory = [SELECT Id, Quantity__c, Name, Part_Number__c, Part_Name__c, (Select Id, IsDeleted, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c From BOATBUILDING__Parts_Availability__r) From BOATBUILDING__Inventory__c Where RecordTypeId =: lstRecTypeForInv[0].Id AND Part_Number__c IN: mapPartNumberQuantity.keySet()];
                        if(lstInventory.size() > 0) {
                            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                                
                                if(objInv.BOATBUILDING__Parts_Availability__r.size() > 0) {
                                    for(BOATBUILDING__Parts_Availability__c objPA: objInv.BOATBUILDING__Parts_Availability__r) {
                                        if(objPA.BOATBUILDING__Store_Location__c == WOStoreLocation) {
                                            objPA.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                                            lstPA.add(objPA);
                                        } 
                                    }
                                } else {
                                    if(objInv.Quantity__c != null) {
                                        objInv.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                                    }else {
                                        objInv.Quantity__c = mapPartNumberQuantity.get(objInv.Part_Number__c); 
                                    }
                                }
                                setInventoryPrtNum.add(objInv.Part_Number__c); 
                            }
                        }
                        List<BOATBUILDING__Part__c> lstPrt = [Select p.Weight__c, p.Taxable__c, p.Vendor_Name__c, p.Retail_Price__c, p.Part_Size__c, p.Part_Number__c, p.Part_Cost__c, p.Part_Color__c, p.Name, p.Minimum_Amount__c, p.Map_Price__c, p.Location__c, p.Id, p.Family1__c, p.Discount__c, p.Dealer_Price__c, p.Category1__c, p.Bin__c From BOATBUILDING__Part__c p Where Part_Number__c IN: mapPartNumberQuantity.keySet() AND Part_Number__c NOT IN: setInventoryPrtNum];
                        for(BOATBUILDING__Part__c objOLIW: lstPrt) {
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
                                objInventory1.RecordTypeID = lstRecTypeForInv[0].Id;
                                objInventory1.Taxable__c= objOLIW.Taxable__c;
                                objInventory1.Weight__c = objOLIW.Weight__c;
                                objInventory1.Part_MSRP_Price__c = objOLIW.Retail_Price__c;
                                lstInventory.add(objInventory1); 
                            }
                        }
                        //try {
                        upsert lstInventory;
                        upsert lstPA;
                        //}catch(Exception ex) {
                        //   System.debug('Debug Log For Exception: '+ex);
                        //} 
                    }
                }
            }
            else if(!String.isBlank(CaseId)){
                Integer jobCount = 0;
                BOATBUILDING__Work_Order__c objCase = [SELECT
                                                       Contact__c,
                                                       Boat__c,
                                                       Drive__c,
                                                       Hours__c,
                                                       Status__c,
                                                       ID,
                                                       Discount__c,
                                                       BOATBUILDING__Customer_Boat_Status__c,
                                                       BOATBUILDING__Account__c,
                                                       BOATBUILDING__Balance__c,
                                                       BOATBUILDING__ContactEmail__c,
                                                       BOATBUILDING__ContactPhone__c,
                                                       BOATBUILDING__Total_Amount_Due__c,
                                                       BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c,
                                                       BOATBUILDING__Account__r.BOATBUILDING__Customer_Balance__c,
                                                       (Select Id From BOATBUILDING__Work_Order_Jobs__r)  
                                                       
                                                       FROM 
                                                       BOATBUILDING__Work_Order__c
                                                       WHERE 
                                                       Id =: CaseId 
                                                       LIMIT 
                                                       1];
                Set<String> jobIdSet = new Set<String>();
                if(!objCase.BOATBUILDING__Work_Order_Jobs__r.isEmpty()) { 
                    for(BOATBUILDING__Work_Order_Job__c objJb: objCase.BOATBUILDING__Work_Order_Jobs__r) {
                        jobIdSet.add(objJb.Id); 
                    }
                }
                //try {
                objCase.Contact__c = Contact_Id;
                Contact objCon = [Select Id, MailingState, AccountId, Email, Phone From Contact Where Id =: Contact_Id Limit 1];
                String MailingState = '---';
                if(objCon.MailingState != null) {
                    MailingState = objCon.MailingState; 
                }
                
                if(objCon.AccountId != null) {
                    objCase.BOATBUILDING__Account__c = objCon.AccountId; 
                }
                if(objCon.Email != null) {
                    objCase.BOATBUILDING__ContactEmail__c = objCon.Email; 
                } 
                if(objCon.Phone != null) {
                    objCase.BOATBUILDING__ContactPhone__c = objCon.Phone; 
                } 
                
                BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(WOStoreLocation);
                Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                System.debug('Debug log For RegularSalestax: '+RegularSalestax);
                objCase.Boat__c = boatId;
                objCase.Drive__c = Drive;
                objCase.BOATBUILDING__Customer_Boat_Status__c = CustomerBoatStatus;
                if(String.isNotBlank(PromoCode)) {
                    objCase.Promo_Code__c = PromoCode;
                } else {
                    objCase.Promo_Code__c = null;
                }
                objCase.Hours__c = Hours;
                objCase.Status__c = Status;
                objCase.Discount__c = DiscountOnWO;
                objCase.Store_Location__c = WOStoreLocation; 
                objCase.Sales_Tax_Percent__c = RegularSalestax;
                
                system.debug('vivekobjCase.CreatedDate__c'+objCase.CreatedDate__c);
                system.debug('vivekWOCreatedDate'+WOCreatedDate);
                if(String.isNotBlank(WOCreatedDate) && objCase.CreatedDate__c==null) {
                    List<String> strDate = new List<String>();
                    if(WOCreatedDate.contains('-')){
                        strDate = String.valueOf(WOCreatedDate).split('-');
                        Integer year = Integer.valueOf(strDate[0]);
                        Integer month = Integer.valueOf(strDate[1]);
                        Integer day = Integer.valueOf(strDate[2]);
                        if(objCase.CreatedDate__c == null) { 
                            objCase.CreatedDate__c = Datetime.newInstance(year, month, day);
                        }
                    } 
                    else if(WOCreatedDate.contains('/')){
                        strDate = String.valueOf(WOCreatedDate).split('/');
                        Integer day = Integer.valueOf(strDate[0]);
                        Integer month = Integer.valueOf(strDate[1]);
                        Integer year = Integer.valueOf(strDate[2]); 
                        //objCase.CreatedDate__c = Datetime.newInstance(year, month, day);
                        if(objCase.CreatedDate__c == null) { 
                            //objCase.CreatedDate__c = Datetime.newInstance(year, month, day);
                        }
                    }
                } 
                update objCase;
                //} 
                //catch(Exception ex) {
                //  System.debug('Debug Log For Exception: '+ex);
                //}
                
                
                if(objCase.Id != null) {
                    if(Job_items.size() > 0){
                        for(Object strJobitems : Job_items) {
                            System.debug('log for strJobitems'+strJobitems);
                            job = (Map<String,Object>)strJobitems;
                            String ExistingJobId = (String)job.get('ExistingJobId');
                            System.debug('log for ExistingJobId'+(String)job.get('ExistingJobId'));
                            if(ExistingJobId != ''){
                                List<String> Jobvalues = new List<String>();
                                String Id = (String)job.get('Id');
                                String JobName = (String)job.get('JobName');
                                String ApprovedByCustomer = String.valueOf((String)job.get('ApprovedByCustomer') == '1' ? true : false);
                                String Discount = String.valueOf(job.get('DiscountOnJob') != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00);
                                String WorkType = String.valueOf(job.get('WorkType'));
                                String Labour_Quantity = String.valueOf(job.get('Labour_Quantity'));
                                String Labour_Price = String.valueOf(job.get('Labour_Price'));
                                String ShippingCharge = '0.00';
                                String TechId = '';
                                if(String.valueOf(job.get('TechId')) != '') {
                                    TechId = String.valueOf(job.get('TechId'));
                                }
                                if(String.valueOf(job.get('ShippingCharge')) != '') {
                                    ShippingCharge = String.valueOf(job.get('ShippingCharge'));
                                }
                                String comments = '';
                                if(String.valueOf(job.get('Comments')) != '') {
                                    comments = String.valueOf(job.get('Comments'));
                                }
                                
                                String Custcomments = '';
                                if(String.valueOf(job.get('CustComments')) != '') {
                                    Custcomments = String.valueOf(job.get('CustComments'));
                                }
                                
                                String miscShrge = '0.00';
                                if(String.valueOf(job.get('MiscCharge')) != '') {
                                    miscShrge = String.valueOf(job.get('MiscCharge'));
                                }
                                String miscShrge2 = '0.00';
                                if(String.valueOf(job.get('MiscCharge2')) != '') {
                                    miscShrge2 = String.valueOf(job.get('MiscCharge2'));
                                }
                                String miscShrge3 = '0.00';
                                if(String.valueOf(job.get('MiscCharge3')) != '') {
                                    miscShrge3 = String.valueOf(job.get('MiscCharge3'));
                                }
                                
                                String MiscDesc1 = '';
                                if(String.valueOf(job.get('MiscDesc1')) != '') {
                                    MiscDesc1 = String.valueOf(job.get('MiscDesc1'));
                                }
                                String MiscDesc2 = '';
                                if(String.valueOf(job.get('MiscDesc2')) != '') {
                                    MiscDesc2 = String.valueOf(job.get('MiscDesc2'));
                                }
                                String MiscDesc3 = '';
                                if(String.valueOf(job.get('MiscDesc3')) != '') {
                                    MiscDesc3 = String.valueOf(job.get('MiscDesc3'));
                                }
                                String taxBool = String.valueOf(job.get('taxBool'));
                                JobIdlst.add(ExistingJobId);
                                Jobvalues.add(Id);
                                Jobvalues.add(JobName);
                                Jobvalues.add(ApprovedByCustomer);
                                Jobvalues.add(Discount);
                                Jobvalues.add(WorkType);
                                Jobvalues.add(Labour_Quantity);
                                Jobvalues.add(ShippingCharge);
                                Jobvalues.add(comments);
                                
                                Jobvalues.add(miscShrge);
                                Jobvalues.add(miscShrge2);
                                Jobvalues.add(miscShrge3);
                                
                                Jobvalues.add(MiscDesc1);
                                Jobvalues.add(MiscDesc2);
                                Jobvalues.add(MiscDesc3);
                                Jobvalues.add(Custcomments);
                                Jobvalues.add(taxBool);
                                Jobvalues.add(TechId);
                                
                                MapOfExistingValues.put(ExistingJobId, Jobvalues);
                                MapOfExistingId.put(Id,ExistingJobId);
                                System.debug('log for MapOfExistingValues'+MapOfExistingValues); 
                                System.debug('log for map'+MapOfExistingId);    
                            }
                            else{
                                Decimal Customer_Pay = 0;
                                objjob = new BOATBUILDING__Work_Order_Job__c();
                                String Id = (String)job.get('Id');  
                                String strJobName = (String)job.get('JobName');
                                String WorkRequested = (String)job.get('WorkRequested');
                                String WorkType = (String)job.get('WorkType');
                                String Type = (String)job.get('Type');
                                String Line_item_count = (String)job.get('Line_item_count');
                                Decimal Labour_Quantity = Decimal.valueOf((String)job.get('Labour_Quantity'));
                                Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                                Decimal Shop_Price = 0.00;
                                if(!String.isBlank(String.valueOf(job.get('ShippingCharge')))) {
                                    objjob.Shipping_Charge__c = Decimal.valueOf(String.valueOf(job.get('ShippingCharge'))); 
                                }
                                if(String.valueOf(job.get('Comments')) != '') {
                                    objjob.Comments__c = String.valueOf(job.get('Comments'));
                                }
                                if(String.valueOf(job.get('CustComments')) != '') {
                                    objjob.Customer_Comments__c = String.valueOf(job.get('CustComments'));
                                }
                                
                                if(String.valueOf(job.get('TechId')) != '') {
                                    objjob.BOATBUILDING__Technician__c = String.valueOf(job.get('TechId'));
                                }
                                objjob.Approved_By_Customer__c = String.valueOf(job.get('ApprovedByCustomer')) == '1' ? true : false;
                                objjob.Taxable__c = String.valueOf(job.get('taxBool')) == '1' ? true : false; 
                                objJob.Discount__c  = String.valueOf(job.get('DiscountOnJob')) != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00;
                                objjob.Job_Name__c = strJobName;
                                objjob.Work_Type__c = WorkType;
                                objjob.Type__c = Type;
                                objjob.No_of_Labors__c = Labour_Quantity;
                                objjob.Price_per_Labor__c = Labour_Price;
                                //objjob.Shop_Supplies_Total__c = 0.00;
                                objjob.RecordTypeId = wojId; 
                                Shop_Price = (Labour_Price * decSSPer)/100;
                                if(Shop_Price <= decSSCap && decSSCap > 0) {
                                    objjob.Shop_Supplies_Total__c = Shop_Price;    
                                } else if(Shop_Price <= decSSCap) {
                                    objjob.Shop_Supplies_Total__c = Shop_Price;
                                } else {
                                    objjob.Shop_Supplies_Total__c = decSSCap;
                                }
                                if(String.valueOf(job.get('MiscCharge')) != '') {
                                    objjob.Misc_Charge__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge')));
                                }
                                
                                if(String.valueOf(job.get('MiscCharge2')) != '') {
                                    objjob.Misc_Charge_2__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge2')));
                                }
                                if(String.valueOf(job.get('MiscCharge3')) != '') {
                                    objjob.Misc_Charge_3__c = Decimal.valueOf(String.valueOf(job.get('MiscCharge3')));
                                } 
                                
                                if(String.valueOf(job.get('MiscDesc1')) != '') {
                                    objjob.Misc_Description_1__c = String.valueOf(job.get('MiscDesc1'));
                                }
                                if(String.valueOf(job.get('MiscDesc2')) != '') {
                                    objjob.Misc_Description_2__c = String.valueOf(job.get('MiscDesc2'));
                                } 
                                if(String.valueOf(job.get('MiscDesc3')) != '') {
                                    objjob.Misc_Description_3__c = String.valueOf(job.get('MiscDesc3'));
                                }
                                
                                
                                objjob.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                objjob.Unique_Job_id__c = Id;
                                lstJob.add(objjob); 
                                UniqueJobIdlst.add(Id);
                                Job_line_items = (List<Object>)job.get('line_items');
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
                Set<String> jobIdSet2 = new Set<String>();
                if(JobIdlst.size() > 0){
                    List<String> existingJobvalueslst = new List<String>(MapOfExistingValues.keySet());
                    List<BOATBUILDING__Work_Order_Job__c> Existinglstjob = [Select id, RecordTypeId, Job_Name__c, Work_Type__c,Type__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c, Part_Name__c, Part_Number__c, Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where id in : JobIdlst];
                    System.debug('log for Existinglstjob'+Existinglstjob);
                    if(Existinglstjob.size() > 0){
                        for(BOATBUILDING__Work_Order_Job__c listId: Existinglstjob){
                            for (String key : MapOfExistingValues.keySet()) {
                                String keyvalue = key;
                                if(keyvalue.equals(listId.id)){
                                    List<String> listValue = MapOfExistingValues.get(key);
                                    
                                    if(wojId == listId.RecordTypeId) {
                                        
                                        listId.Unique_Job_id__c = listValue[0]; 
                                        listId.Job_Name__c = listValue[1];
                                        listId.Approved_By_Customer__c = Boolean.valueOf(listValue[2]);
                                        listId.Discount__c = Decimal.valueOf(listValue[3]);
                                        listId.RecordTypeId = wojId;
                                        
                                        listId.Work_Type__c = listValue[4];
                                        
                                        listId.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                        listId.No_of_Labors__c =  Decimal.valueOf(listValue[5]); 
                                        
                                        if(listValue[6] != null)
                                            listId.Shipping_Charge__c =  Decimal.valueOf(listValue[6]);  
                                        listId.Comments__c =  String.valueof(listValue[7]);  
                                        listId.Misc_Charge__c = Decimal.valueOf(listValue[8]);
                                        
                                        listId.Misc_Charge_2__c = Decimal.valueOf(listValue[9]);
                                        listId.Misc_Charge_3__c = Decimal.valueOf(listValue[10]);
                                        
                                        listId.Misc_Description_1__c = listValue[11];
                                        listId.Misc_Description_2__c = listValue[12];
                                        listId.Misc_Description_3__c = listValue[13];
                                        listId.Customer_Comments__c = listValue[14];
                                        listId.Taxable__c = listValue[15] == '1'? true: false; 
                                        listId.BOATBUILDING__Technician__c = String.isNotBlank(listValue[16])? listValue[16]: listId.BOATBUILDING__Technician__c;
                                        List<WorkTypePricing__c> lstWTP = [Select Price__c, Name From WorkTypePricing__c Where Name =: listValue[4] Limit 1];
                                        if(!lstWTP.isEmpty()) {
                                            listId.Price_per_Labor__c = lstWTP[0].Price__c;
                                        }
                                        
                                        Decimal Labour_Price = Decimal.valueOf(listValue[5]) * listId.Price_per_Labor__c;  
                                        //listId.Shop_Supplies_Total__c = 0.00;
                                        Decimal Shop_Price = (Labour_Price * decSSPer)/100;
                                        System.debug('>>>>>>: '+Labour_Price + ' >>>>>: '+decSSPer+ ' >>>>>: '+Shop_Price+ ' >>>>>: '+decSSCap); 
                                        if(Shop_Price <= decSSCap && decSSCap > 0) {
                                            listId.Shop_Supplies_Total__c = Shop_Price;    
                                        } else if(Shop_Price <= decSSCap) {
                                            listId.Shop_Supplies_Total__c = Shop_Price;
                                        } else {
                                            listId.Shop_Supplies_Total__c = decSSCap;
                                        }
                                        lstJob.add(listId); 
                                    } else {
                                        BOATBUILDING__Work_Order_Job__c objJB = new BOATBUILDING__Work_Order_Job__c();
                                        objJB.Unique_Job_id__c = listValue[0]; 
                                        objJB.Job_Name__c = listValue[1];
                                        objJB.Approved_By_Customer__c = Boolean.valueOf(listValue[2]);
                                        objJB.Discount__c = Decimal.valueOf(listValue[3]);
                                        objJB.RecordTypeId = wojId;
                                        
                                        objJB.Work_Type__c = listValue[4];
                                        
                                        objJB.Work_Order_Warranty_Work_Order__c = objCase.Id;
                                        objJB.No_of_Labors__c =  Decimal.valueOf(listValue[5]); 
                                        
                                        if(listValue[6] != null)
                                            objJB.Shipping_Charge__c =  Decimal.valueOf(listValue[6]);  
                                        objJB.Comments__c =  String.valueof(listValue[7]);  
                                        objJB.Misc_Charge__c = Decimal.valueOf(listValue[8]);
                                        
                                        objJB.Misc_Charge_2__c = Decimal.valueOf(listValue[9]);
                                        objJB.Misc_Charge_3__c = Decimal.valueOf(listValue[10]);
                                        
                                        objJB.Misc_Description_1__c = listValue[11];
                                        objJB.Misc_Description_2__c = listValue[12];
                                        objJB.Misc_Description_3__c = listValue[13]; 
                                        objJB.Customer_Comments__c = listValue[14];
                                        objJB.Taxable__c = listValue[15] == '1'? true: false; 
                                        objJB.BOATBUILDING__Technician__c = String.isNotBlank(listValue[16])? listValue[16]: objJB.BOATBUILDING__Technician__c;
                                        List<WorkTypePricing__c> lstWTP = [Select Price__c, Name From WorkTypePricing__c Where Name =: listValue[4] Limit 1];
                                        if(!lstWTP.isEmpty()) {
                                            objJB.Price_per_Labor__c = lstWTP[0].Price__c;
                                        }
                                        
                                        Decimal Labour_Price = Decimal.valueOf(listValue[5]) * listId.Price_per_Labor__c; 
                                        //objJB.Shop_Supplies_Total__c = 0.00;
                                        Decimal Shop_Price = (Labour_Price * decSSPer)/100; 
                                        if(Shop_Price <= decSSCap && decSSCap > 0) {
                                            objJB.Shop_Supplies_Total__c = Shop_Price;    
                                        } else if(Shop_Price <= decSSCap) {
                                            objJB.Shop_Supplies_Total__c = Shop_Price; 
                                        } else { 
                                            objJB.Shop_Supplies_Total__c = decSSCap;
                                        }
                                        lstJob.add(objJB);  
                                    }
                                    
                                    
                                    //System.debug('Debug log For Shop SHupplies: '+Shop_Price+' : ' + Labour_Price +' : '+decSSPer+ ' : ' +decSSCap);
                                    
                                    
                                    jobIdSet2.add(listId.Id);
                                    if(listId.BOATBUILDING__Work_Order_Job_Line_Items__r.size() > 0){
                                        for(BOATBUILDING__Work_Order_Job_Line_Item__c objlinitem : listId.BOATBUILDING__Work_Order_Job_Line_Items__r){
                                            Total_existing_job_line_items.add(objlinitem);  
                                            
                                        }
                                    }
                                    
                                }
                            }
                        } 
                    }
                }
                
                
                
                System.debug('log for JobIdlst'+JobIdlst);
                
                //try {
                upsert lstJob; 
                for(BOATBUILDING__Work_Order_Job__c objJb: lstJob) {
                    setLstJobId.add(objJb.Id);
                }
                if(jobIdSet.size() > 0 && jobIdSet2.size() > 0) {
                    //System.debug('List job for delete : '+[Select Id from BOATBUILDING__Work_Order_Job__c where Id In: jobIdSet AND Id NOT In: jobIdSet2]);
                }  
                //}
                //catch(Exception ex) {
                //  isError = true;
                
                // System.debug('Debug Log For Exception : '+ex);
                // }
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
                        obj_job_line_item.Price__c = PartPrice;
                        String strPrtNameNumber = (String)map_job_line_item.get('PartName');
                        if(strPrtNameNumber != null ) {
                            obj_job_line_item.Part_Name__c = strPrtNameNumber;
                            
                        }
                        for(BOATBUILDING__Work_Order_Job__c uniqueid : newlstjob){ 
                            if(Id == uniqueid.Unique_Job_id__c){
                                obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                            }
                        }
                        System.debug('log for obj_job_line_item'+obj_job_line_item);
                        lstJoblineitem.add(obj_job_line_item);
                        mapPartNumberQuantity.put(obj_job_line_item.Part_Number__c, Integer.valueOf(obj_job_line_item.Quantity__c));
                    }
                    
                }   
                System.debug('log for Total_existing_job_line_items Update'+Total_existing_job_line_items);
                List<String> uniqueexistingJobIdlst ;
                if(Total_existing_job_line_items.size() > 0){
                    uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
                    System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
                    List<BOATBUILDING__Work_Order_Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Work_Order_Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
                    for(BOATBUILDING__Work_Order_Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                        BOATBUILDING__Work_Order_Job_Line_Item__c obj_job_line_item2 = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                        if(joblineitemlist2.Id != null) {
                            obj_job_line_item2.Id = joblineitemlist2.Id;
                        }
                        obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                        obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                        obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
                        obj_job_line_item2.Price__c = joblineitemlist2.Price__c;
                        for (String key : MapOfExistingId.keySet()) {
                            String value = MapOfExistingId.get(key);
                            if(value.equals(joblineitemlist2.Related_to_Job__c)){
                                String keyvalue = key;
                                for(BOATBUILDING__Work_Order_Job__c Jobid : newlstjob){
                                    if(key.equals(Jobid.Unique_Job_id__c)){
                                        if(obj_job_line_item2.Id == null) {
                                            obj_job_line_item2.Related_to_Job__c = Jobid.id;
                                        }
                                        System.debug('log for Related_to_Job__c'+Jobid.id);
                                    }   
                                }
                            }
                        }
                        lstJoblineitem.add(obj_job_line_item2);
                        //mapPartNumberQuantity.put(obj_job_line_item2.Part_Number__c, Integer.valueOf(obj_job_line_item2.Quantity__c));
                    }
                }
                //try { 
                upsert lstJoblineitem;
                /*}
catch(Exception ex) {
isError = true;
System.debug('Debug Log For Exception : '+ex);
}*/
                
            }  
            System.debug('>>>>>>>>>setLstJobId: '+setLstJobId);
            if(!setLstJobId.isEmpty()) {
                List<Event> lstEvent = new List<Event>();
                List<BOATBUILDING__Work_Order_Job__c> lstJb = [Select Id, Name, Job_Name__c, BOATBUILDING__Work_Order_Warranty_Work_Order__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c,
                                                                        BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, BOATBUILDING__Comments__c, BOATBUILDING__Customer_Comments__c From BOATBUILDING__Work_Order_Job__c WHERE Id IN: setLstJobId];
                for(BOATBUILDING__Work_Order_Job__c objJb: lstJb) {
                    if(objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null 
                        && objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c != null 
                            && objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null) {
                                if(String.isNotBlank(objJb.BOATBUILDING__Comments__c)) {
                                    List<Event> lst = addCustomerComment('Service Writer Comment @ '+objJb.Job_Name__c,
                                                            objJb.BOATBUILDING__Comments__c, 
                                                                objJb.Id, 
                                                                    objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, 
                                                                        objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c, 'Service Writer Comment');
                                    lstEvent.addAll(lst);                                   
                                }
                                if(String.isNotBlank(objJb.BOATBUILDING__Customer_Comments__c)) {
                                    List<Event> lst = addCustomerComment('Service Writer Comment @ '+objJb.Job_Name__c,
                                                            objJb.BOATBUILDING__Customer_Comments__c, 
                                                                objJb.Id, 
                                                                    objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, 
                                                                        objJb.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c, 'Customer Comment');
                                    lstEvent.addAll(lst);
                                }
                    }
                }                                                       
                if(!lstEvent.isEmpty()) {
                    insert lstEvent;
                }
            }
            return 'Success';
        } catch(Exception ex) {
            //SendEmailUtility.sendQuickEmail('Exception Work Order Job : '+ex.getMessage()+' : '+ex.getLineNumber());
            System.debug('Exception Work Order Job : '+ex.getStackTraceString()+' : '+ex.getLineNumber() + ' : ' +ex.getMessage());
            return 'Exception Work Order Job : '+ex.getMessage()+' : '+ex.getLineNumber();
        }
    }
    
    public static List<Event> addCustomerComment(String subject, String customerComment, String whatId, String whoId, String accountId, String sectionName){
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
          if(sectionName == 'Work Order Section'){
            objWO   = [Select Id,BOATBUILDING__Boat__c,Name from BOATBUILDING__Work_Order__c where id =: whatId];
          }else{
            objWOJ   = [Select Id,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c,BOATBUILDING__Technician__c,Name,BOATBUILDING__Work_Order_Warranty_Work_Order__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name from BOATBUILDING__Work_Order_Job__c where id =: whatId];
          }
          
          List<Event> lstEvent = new List<Event>();
          Event e = new Event();
          e.whatId = whatId;
          e.whoId = whoId;
          e.Subject = subject;
          e.Description = customerComment;
          e.StartDateTime = System.Now();
          e.EndDateTime = System.Now()+1;
          if(sectionName == 'Customer Comment'){
            e.Type = 'Comment for Customer';
          }
          if(sectionName == 'Service Writer Comment'){
            e.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
          }
          if(sectionName == 'Tech Comment'){
            e.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
          }
          
          lstEvent.add(e);
    
          Event e2 = new Event();
          e2.whatId = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
         
          e2.Subject = subject+' (Comment on '+objWOJ.Name+')';
          e2.Description = customerComment;
          e2.StartDateTime = System.Now();
          e2.EndDateTime = System.Now()+1;
          
          if(sectionName == 'Customer Comment'){
            e2.Type = 'Comment for Customer';
          }
          if(sectionName == 'Service Writer Comment'){
            e2.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e2.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
          }
          if(sectionName == 'Tech Comment'){
            e2.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e2.OwnerId = objWOJ.BOATBUILDING__Technician__c;
              e2.Subject = subject+' (Comment from Tech on '+objWOJ.Name+')';
            }
          }
          lstEvent.add(e2);
    
          Event e3 = new Event();
          e3.whatId = accountId;
          if(sectionName == 'Work Order Section'){
           
            e3.Subject = 'Comment on '+objWO.Name;
          }else{
         
            e3.Subject = 'Comment on '+objWO.Name +'---Job:'+objWOJ.Name;
          }
          
        
          e3.Description = customerComment;
          e3.StartDateTime = System.Now();
          e3.EndDateTime = System.Now()+1;
          if(sectionName == 'Customer Comment'){
            e3.Type = 'Comment for Customer';
          }
          if(sectionName == 'Service Writer Comment'){
            e3.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e3.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
          }
          if(sectionName == 'Tech Comment'){
            e3.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
              e3.OwnerId = objWOJ.BOATBUILDING__Technician__c;
              e3.Subject = subject+' (Comment from Tech on '+objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'--'+objWOJ.Name+')';
            }
          }
          lstEvent.add(e3);
          if(String.isNotBlank(String.valueOf(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c)) || String.isNotBlank(String.valueOf(objWO.BOATBUILDING__Boat__c))){
            Event e4 = new Event();
            if(sectionName == 'Work Order Section'){
              e4.whatId = objWO.BOATBUILDING__Boat__c;
              e4.Subject = 'Comment on '+objWO.Name;
            }else{
              e4.whatId = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c;
              e4.Subject = 'Comment on '+objWO.Name +'---Job:'+objWOJ.Name;
            }
           
            
           
            e4.Description = customerComment;
            e4.StartDateTime = System.Now();
            e4.EndDateTime = System.Now()+1;
            if(sectionName == 'Customer Comment'){
              e4.Type = 'Comment for Customer';
            }
            if(sectionName == 'Service Writer Comment'){
              e4.Type = 'Comment for Technician';
              if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e4.OwnerId = objWOJ.BOATBUILDING__Technician__c;
              }
            }
            if(sectionName == 'Tech Comment'){
              e4.Type = 'Comment from Technician';
              if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e4.OwnerId = objWOJ.BOATBUILDING__Technician__c;
                e4.Subject = subject+' (Comment from Tech on '+objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'--'+objWOJ.Name+')';
              }
            }
            lstEvent.add(e4);
          }
          
    
          return lstEvent;
      }
    
    @RemoteAction
    public static BOATBUILDING__Promo_Code__c getPromocodeDetail(String strPCId) {
        if(strPCId != null) {
            return [Select Id, BOATBUILDING__Discount_Amount__c, BOATBUILDING__Discount_In__c, BOATBUILDING__Discount_Percentage__c, BOATBUILDING__IsActive__c, BOATBUILDING__Promo_Code_Name__c 
                    From Promo_Code__c Where Id =: strPCId];
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static List<Object> fetchWorkOrder(String objCaseId) {
        
        List<Object> lstObj = new List<Object>();
        BOATBUILDING__Work_Order__c objCase = [SELECT 
                                               Account__c,
                                               Contact__c,
                                               BOATBUILDING__Customer_Boat_Status__c,
                                               ContactEmail__c,
                                               Contact__r.FirstName,
                                               Contact__r.Phone,
                                               Contact__r.LastName,
                                               Contact__r.MailingStreet,
                                               Contact__r.Email,
                                               Contact__r.MailingPostalCode,
                                               Contact__r.MailingCity,
                                               RecordType.Name,
                                               Boat__c,
                                               Boat__r.Name, 
                                               Boat__r.Boat_Model__c,
                                               Boat__r.BOATBUILDING__Boat_Registration_Number__c,
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
                                               Store_Location__c,
                                               Name,
                                               Drive__c,
                                               Hours__c,
                                               Discount__c,
                                               Status__c,
                                               Promo_Code__c,
                                               Priority__c,
                                               ContactPhone__c,
                                               Total_Parts__c,
                                               Sales_Tax_Percent__c,
                                               Total_Labor__c,
                                               Total_Shop_Supplies__c,
                                               BOATBUILDING__Account__r.BOATBUILDING__Account_Customer_Type__c,
                                               BOATBUILDING__Account__r.BOATBUILDING__Customer_Balance__c,
                                               Total__c,
                                               Sales_Tax__c,
                                               Total_Amount_Due__c,
                                               Total_Payment_job__c,
                                               BOATBUILDING__Total_Payment_payment__c,
                                               BOATBUILDING__Balance__c,
                                               BOATBUILDING__CreatedDate__c,
                                               ID,
                                               Created_Date_Formula__c,
                                               BOATBUILDING__Customer_Notes__c
                                               
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
                                                         Customer_Comments__c,  
                                                         Shop_Supplies_Total__c, 
                                                         Shipping_Charge__c,
                                                         BOATBUILDING__Technician__c,
                                                         BOATBUILDING__Technician__r.Name,
                                                         Total_Amount_Job__c, 
                                                         Total_Amount_on_Parts_del__c,
                                                         Customer_Pay__c,
                                                         Total_Hours_Job__c,
                                                         Worked_Hours__c,
                                                         Discount__c,
                                                         BOATBUILDING__Taxable__c,
                                                         Id,
                                                         BOATBUILDING__Misc_Charge__c,
                                                         BOATBUILDING__Misc_Description_3__c, 
                                                         BOATBUILDING__Misc_Description_2__c, 
                                                         BOATBUILDING__Misc_Description_1__c, 
                                                         BOATBUILDING__Misc_Charge_3__c,  
                                                         BOATBUILDING__Misc_Charge_2__c, 
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
                                                         BOATBUILDING__Work_Order_Job__c where Work_Order_Warranty_Work_Order__c =: objCase.Id
                                                         Order By CreatedDate ASC];
        
        lstObj.add(objCase);
        
        if(!joblist.isEmpty()) {
            lstObj.add(joblist);
        }
        
        return lstObj;
    }
    
    @RemoteAction
    public static string addPayment(Map<String, String> mapPaymentData, String workOrderId){
        
        BOATBUILDING__Payments__c objPayment = new BOATBUILDING__Payments__c();
        objPayment.BOATBUILDING__Work_Warranty_Order__c = workOrderId;        
        objPayment.BOATBUILDING__Amount__c = Decimal.valueOf(mapPaymentData.get('Amount'));
        objPayment.BOATBUILDING__Payment_Type__c = mapPaymentData.get('PaymentType');
        objPayment.BOATBUILDING__Credit_Card_Type__c = mapPaymentData.get('CreditCardType');
        objPayment.BOATBUILDING__Check_Number__c = mapPaymentData.get('CheckNumber');
        objPayment.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
                                    
        System.debug('objPayment----'+objPayment);
        try{
            insert objPayment;
        }catch(Exception ex) {
            System.debug('Debug log for Exception: '+ex);
            return null;
        }
        BOATBUILDING__Work_Order__c objPaymentToShow = [SELECT Id,BOATBUILDING__Total_Payment_payment__c FROM BOATBUILDING__Work_Order__c WHERE Id=: workOrderId LIMIT 1];
        if(objPaymentToShow.BOATBUILDING__Total_Payment_payment__c!= null){
            return ''+objPaymentToShow.BOATBUILDING__Total_Payment_payment__c;
        } 
        return '';
    }
    
    @RemoteAction
    public static string addPaymentCN(Map<String, String> mapPaymentData, String workOrderId){
        try{
            BOATBUILDING__Work_Order__c objWO = [SELECT Id, BOATBUILDING__Contact__r.AccountId,BOATBUILDING__Total_Payment_payment__c FROM BOATBUILDING__Work_Order__c WHERE Id=: workOrderId LIMIT 1];
            BOATBUILDING__Credit_Note__c objCN = new BOATBUILDING__Credit_Note__c();
            objCN.BOATBUILDING__Amount__c = (-Decimal.valueOf(mapPaymentData.get('Amount')));
            objCN.BOATBUILDING__Account__c = objWO.BOATBUILDING__Contact__r.AccountId;
            objCN.BOATBUILDING__Work_Order__c = objWO.Id;
            insert objCN;
            
            BOATBUILDING__Payments__c objPayment = new BOATBUILDING__Payments__c();
            objPayment.BOATBUILDING__Credit_Note__c = objCN.Id;  
            objPayment.BOATBUILDING__Work_Warranty_Order__c = workOrderId;        
            objPayment.BOATBUILDING__Amount__c = Decimal.valueOf(mapPaymentData.get('Amount'));
            objPayment.BOATBUILDING__Payment_Type__c = mapPaymentData.get('PaymentType');
            System.debug('objPayment----'+objPayment);
            
            insert objPayment;
            
            BOATBUILDING__Work_Order__c objPaymentToShow = [SELECT Id,BOATBUILDING__Total_Payment_payment__c FROM BOATBUILDING__Work_Order__c WHERE Id=: workOrderId LIMIT 1];
            if(objPaymentToShow.BOATBUILDING__Total_Payment_payment__c!= null){
                return ''+objPaymentToShow.BOATBUILDING__Total_Payment_payment__c;
            }
        }catch(Exception ex) {
            System.debug('Debug log for Exception: '+ex);
            return null;
        } 
        return '';
    } 
    
    //--Updates for Akshay Start
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
    //--Updates for Akshay End
    
    public class PartWrapper {
        public String Id;
        public String PartName;
        public String PartNumber;
        public Integer Quantity;
        public Decimal MSRP;
        public PartWrapper(String Id, String PartName, String PartNumber, Integer Quantity, Decimal MSRP) {
            this.Id = Id;
            this.PartName = PartName;
            this.PartNumber = PartNumber;
            this.Quantity = Quantity;
            this.MSRP = MSRP;
        }
    }
    
    @RemoteAction
    public static List<PartResultDiv> searchParts(String strPrtDetail, String sLocation) {
        
        
        if(sLocation == '' || sLocation == null) {
        
            List<RecordType> lstInventoryRT = [SELECT           
                                               Id
                                               FROM    
                                               RecordType
                                               WHERE       
                                               DeveloperName = 'Inventory_for_Parts'
                                               AND
                                               SobjectType = 'BOATBUILDING__Inventory__c'
                                               LIMIT 
                                               1];
            
            List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
            Set<String> setPrtNum = new Set<String>();
            String prtDetail = '%'+strPrtDetail+'%';  
            if(lstInventoryRT.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                                 Id, 
                                                                 Quantity__c, 
                                                                 Part_Number__c, 
                                                                 Part_Name__c, 
                                                                 Part_MSRP_Price__c ,
                                                                 (
                                                                    Select Id, Name, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                    From BOATBUILDING__Parts_Availability__r
                                                                 )
                                                                 From 
                                                                 BOATBUILDING__Inventory__c 
                                                                 Where 
                                                                 (Part_Number__c LIKE: prtDetail OR Part_Name__c LIKE: prtDetail) AND RecordTypeId =: lstInventoryRT[0].Id];
                
                if(lstInventory.size() > 0) {
                    for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                        PartResultDiv objPRD = new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c);
                        objPRD.StoreLocation = '-None-';
                        lstPartResultDiv.add(objPRD); 
                        setPrtNum.add(objInv.Part_Number__c);
                    }
                }
            }
            List<BOATBUILDING__Part__c> lstPrt = [Select 
                                                  Part_Number__c, 
                                                  Name, 
                                                  Retail_Price__c, 
                                                  Id 
                                                  From 
                                                  BOATBUILDING__Part__c 
                                                  Where 
                                                  (Part_Number__c LIKE: prtDetail OR Name LIKE: prtDetail) AND Part_Number__c NOT IN: setPrtNum];
            if(lstPrt.size() > 0) {                                     
                for(BOATBUILDING__Part__c objPrt: lstPrt) {
                    PartResultDiv objPRD = new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c);
                    objPRD.StoreLocation = '-None-'; 
                    lstPartResultDiv.add(objPRD); 
                }                       
            }   
            if(lstPartResultDiv.size() > 0) {
                return lstPartResultDiv;
            } 
        } else {
            List<RecordType> lstInventoryRT = [SELECT           
                                               Id
                                               FROM    
                                               RecordType
                                               WHERE       
                                               DeveloperName = 'Inventory_for_Parts'
                                               AND
                                               SobjectType = 'BOATBUILDING__Inventory__c'
                                               LIMIT 
                                               1];
            
            List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
            Set<String> setPrtNum = new Set<String>();
            String prtDetail = '%'+strPrtDetail+'%';  
            if(lstInventoryRT.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                                 Id, 
                                                                 Quantity__c, 
                                                                 Part_Number__c, 
                                                                 Part_Name__c, 
                                                                 Part_MSRP_Price__c ,
                                                                 (
                                                                    Select Id, Name, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                    From BOATBUILDING__Parts_Availability__r
                                                                 )
                                                                 From 
                                                                 BOATBUILDING__Inventory__c 
                                                                 Where 
                                                                 (Part_Number__c LIKE: prtDetail OR Part_Name__c LIKE: prtDetail) AND RecordTypeId =: lstInventoryRT[0].Id];
                
                if(lstInventory.size() > 0) {
                    for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                        for(BOATBUILDING__Parts_Availability__c objPA: objInv.BOATBUILDING__Parts_Availability__r) {
                            if(objPA.BOATBUILDING__Store_Location__c != null &&  sLocation == objPA.BOATBUILDING__Store_Location__c) {
                                PartResultDiv objPRD = new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objPA.Quantity__c), objInv.Part_MSRP_Price__c);
                                objPRD.StoreLocation = sLocation;
                                lstPartResultDiv.add(objPRD);
                                setPrtNum.add(objInv.Part_Number__c);
                            }
                        }
                    }
                }
            }
            List<BOATBUILDING__Part__c> lstPrt = [Select 
                                                  Part_Number__c, 
                                                  Name, 
                                                  Retail_Price__c, 
                                                  Id 
                                                  From 
                                                  BOATBUILDING__Part__c 
                                                  Where 
                                                  (Part_Number__c LIKE: prtDetail OR Name LIKE: prtDetail) AND Part_Number__c NOT IN: setPrtNum];
            if(lstPrt.size() > 0) {                                     
                for(BOATBUILDING__Part__c objPrt: lstPrt) {
                    PartResultDiv objPRD = new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c);
                    objPRD.StoreLocation = '-None-';
                    lstPartResultDiv.add(objPRD); 
                }                       
            }   
            if(lstPartResultDiv.size() > 0) {
                return lstPartResultDiv;
            } 
        }
        return null;
    }
    
    @RemoteAction
    public static List<PartResultDiv> getFinalList2(List<String> lstPartNum, Map<String, String> objMapForResutData, String sLoc) {
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        System.debug('Debug Log For List: '+lstPartNum);
        Set<String> setPrtNum = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                         Id, 
                                                         Quantity__c, 
                                                         Part_Number__c, 
                                                         Part_Name__c, 
                                                         Part_MSRP_Price__c  
                                                         From 
                                                         BOATBUILDING__Inventory__c 
                                                         Where 
                                                         Part_Number__c IN: lstPartNum];
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                setPrtNum.add(objInv.Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                              Part_Number__c, 
                                              Name, 
                                              Retail_Price__c, 
                                              Id 
                                              From 
                                              BOATBUILDING__Part__c 
                                              Where 
                                              Part_Number__c IN: lstPartNum AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c)); 
            }                       
        } 
        
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    } 
    
    @RemoteAction
    public static List<PartResultDiv> getFinalList(List<String> lstPartNum, Map<String, String> objMapForResutData, String jobIdForCart, String sloc) {
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        System.debug('Debug Log For List: '+lstPartNum);
        Set<String> setPrtNum = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                         Id, 
                                                         Quantity__c, 
                                                         Part_Number__c, 
                                                         Part_Name__c, 
                                                         Part_MSRP_Price__c 
                                                         From 
                                                         BOATBUILDING__Inventory__c 
                                                         Where 
                                                         Part_Number__c IN: lstPartNum];
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Id, objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                setPrtNum.add(objInv.Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                              Part_Number__c, 
                                              Name, 
                                              Retail_Price__c, 
                                              Id 
                                              From 
                                              BOATBUILDING__Part__c 
                                              Where 
                                              Part_Number__c IN: lstPartNum AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Id, objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c)); 
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
            List<BOATBUILDING__Parts_Availability__c> lstPA = new List<BOATBUILDING__Parts_Availability__c>();    
            if(mapPartNumberQuantity.keySet().size() > 0){
                List<RecordType> lstRecTypeForInv1 = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Inventory__c' AND DeveloperName = 'Inventory_for_Parts' LIMIT 1];
                
                if(lstRecTypeForInv1.size() > 0) {
                    List<BOATBUILDING__Inventory__c> lstInventory1 = [SELECT (Select Id, IsDeleted, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c From BOATBUILDING__Parts_Availability__r), Id, Quantity__c, Name, Part_Number__c, Part_Name__c From BOATBUILDING__Inventory__c Where RecordTypeId =: lstRecTypeForInv1[0].Id AND Part_Number__c IN: mapPartNumberQuantity.keySet()];
                    if(lstInventory1.size() > 0) {
                        for(BOATBUILDING__Inventory__c objInv: lstInventory1) {
                            
                            if(objInv.BOATBUILDING__Parts_Availability__r.size() > 0) {
                                
                                BOATBUILDING__Parts_Availability__c obj = objInv.BOATBUILDING__Parts_Availability__r[0];
                                obj.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                                lstPA.add(obj);
                                    
                            } else {
                                if(objInv.Quantity__c != null) { 
                                    objInv.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                                }else {
                                    objInv.Quantity__c = mapPartNumberQuantity.get(objInv.Part_Number__c); 
                                }   
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
                        upsert lstPA;
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
                                                                  FROM 
                                                                  BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                  WHERE 
                                                                  Id =: strJLIId
                                                                  LIMIT 
                                                                  1];
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
                                                                           FROM 
                                                                           BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                           WHERE 
                                                                           Related_to_Job__c =: strJobId];
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
    public static List<PartResultDiv> removeExistingElement(String strJLIID, String strLocation) {
        List<PartResultDiv> lstPRD = new List<PartResultDiv>();  
        String strJobId = '';
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI = [SELECT 
                                                                  Id,
                                                                  Quantity__c,
                                                                  Related_to_Job__c,
                                                                  Part_Number__c
                                                                  FROM 
                                                                  BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                  WHERE 
                                                                  Id =: strJLIId
                                                                  LIMIT 
                                                                  1];
        List<Inventory__c> lstInv = new List<Inventory__c>();
        if(lstJLI[0].Part_Number__c != null) {
            lstInv = [Select Id, (Select Id, Store_location__c, Quantity__c From BOATBUILDING__Parts_Availability__r) From Inventory__c Where Part_Number__c =: lstJLI[0].Part_Number__c];   
        } 
        System.debug('>>>>>>lstInv: '+lstInv);
        strJobId = lstJLI[0].Related_to_Job__c; 
        delete lstJLI;
        
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLIFinal = [SELECT 
                                                                       Id,
                                                                       Part_Name__c,
                                                                       Part_Number__c,
                                                                       Quantity__c,
                                                                       Related_to_Job__c,
                                                                       Price__c
                                                                       FROM 
                                                                       BOATBUILDING__Work_Order_Job_Line_Item__c
                                                                       WHERE 
                                                                       Related_to_Job__c =: strJobId];
        System.debug('>>>>>>lstJLIFinal: '+lstJLIFinal);                                                               
        if(!lstJLIFinal.isEmpty()) {
            for(BOATBUILDING__Work_Order_Job_Line_Item__c objWOJLI: lstJLIFinal) {
                lstPRD.add(new PartResultDiv(objWOJLI.Id, objWOJLI.Part_Number__c, objWOJLI.Part_Name__c, Integer.valueOf(objWOJLI.Quantity__c), objWOJLI.Price__c));
            }
        }
        
        List<BOATBUILDING__Parts_Availability__c> lstPA = new List<BOATBUILDING__Parts_Availability__c>();
        if(!lstInv.isEmpty()) {
            for(Inventory__c objInv: lstInv) {
                if(!objInv.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                    for(BOATBUILDING__Parts_Availability__c obj: objInv.BOATBUILDING__Parts_Availability__r) {
                        if(strLocation != null && obj.Store_location__c == strLocation) {
                            if(obj.Quantity__c != null) {
                                obj.Quantity__c += lstJLI[0].Quantity__c;
                            }
                            else {
                                obj.Quantity__c = lstJLI[0].Quantity__c;
                            }
                            lstPA.add(obj);
                        }
                    }
                }
            }
            System.debug('>>>>>>lstPA: '+lstPA);
            //update lstPA; 
        }
        return lstPRD; 
    }
    
    @RemoteAction
    public static String getSalestaxF(String WOName) {
        List<Work_Order__c> obj = [Select Sales_Tax__c From Work_Order__c Where Name =: WOName Limit 1];
        if(obj.isEmpty()) {
            return 'none';
        } else {
            return String.valueOf(obj[0].Sales_Tax__c);
        }
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
    public static List<BOATBUILDING__Promo_Code__c> getPromocodes() {
        List<BOATBUILDING__Promo_Code__c> lstPC = new List<BOATBUILDING__Promo_Code__c>();
        lstPC = [Select Id, BOATBUILDING__Discount_Amount__c, BOATBUILDING__Discount_In__c, BOATBUILDING__Discount_Percentage__c, BOATBUILDING__IsActive__c, BOATBUILDING__Promo_Code_Name__c 
                 From Promo_Code__c Where BOATBUILDING__IsActive__c = true];
        
        return lstPC;
    }
    
    public class PartResultDiv {
        public String Id;
        public String PartNumber;
        public String PartName;
        public String StoreLocation;
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
    
    @RemoteAction
    public static Item__c getBoat(String strBtId) {
        Item__c objIt = new Item__c();
        objIt = [Select Id, BOATBUILDING__Boat_HIN_No__c From Item__c Where Id =: strBtId];
        return objIt;
    }
    
    public static void createTask(String subject, String description, Id parentId){
                
        Task objTask = new Task();
        objTask.Subject = subject;
        objTask.Description = description;
        objTask.WhatId = parentId;
        objTask.Status = 'Completed';
        insert objTask;
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
}