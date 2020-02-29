/**
 * Author:              Akshay Kumar
 * Organization:        360 Degree Cloud Technologies Pvt. Ltd.
 * Created Date:        01/02/2017
 * Last Modified Date:  13/02/2017
 */
public with sharing class WarrantyWorkOrderController {
    /*public Case objCase { get; set; }
    public BOATBUILDING__Job__c objJob { get; set; } 
    public List<SelectOption> lstJobs { get; set; }
    public String selectedJob { get; set; }
    
    public WarrantyWorkOrderController() {
        objCase = new Case();
        objJob = new BOATBUILDING__Job__c();
        lstJobs = new List<SelectOption>();
        lstJobs.add(new SelectOption('', '--None--'));
        for(BOATBUILDING__Job__c objJob : [Select Id, Job_Name__c, Name from BOATBUILDING__Job__c limit 999]){
                lstJobs.add(new SelectOption(objJob.id, objJob.Job_Name__c ));
        
      }
    }
    
    @RemoteAction
    public static List<BOATBUILDING__WorkTypePricing__c> fetchWorkTypePricingDetails() {
        return [SELECT Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]; 
    }
    
    public List<Case> getWarrantyWorkOrderList() {
        List<RecordType> lstRecordType = [SELECT
                                                    Id
                                          FROM
                                                    RecordType
                                          WHERE
                                                    SobjectType = 'Case'
                                          AND
                                                    DeveloperName = 'Warranty_Work_Order'];
        if(lstRecordType.size() > 0) {
            return [Select Id, CaseNumber, Contact.Name, Boat__r.Boat_HIN_No__c, Hours__c, Drive__c From Case Where RecordTypeId =: lstRecordType[0].Id];
        } 
        else { 
            return new List<Case>();    
        }
    }
    
    @RemoteAction
    public static List<Object> getContact(String Conid){
        List<Object> contactlist = new List<Object>();
        List <Contact> conlist= [Select MailingState,MailingStreet,Email,MailingPostalCode,MailingCity,Phone From Contact where Id =: Conid];
        if(conlist.size() > 0){
             contactlist.add(conlist);
             List<BOATBUILDING__Service_Module_Tax_Rates__c> lstSMTR = [SELECT
                                                            Id,
                                                            Name,
                                                            Tax__c
                                                     FROM
                                                            BOATBUILDING__Service_Module_Tax_Rates__c
                                                    where
                                                          Name =: conlist[0].MailingState
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
        List <BOATBUILDING__Item__c> itemlist= [SELECT Id, Boat_HIN_No__c, Engine_SN__c, Boat_Manufacture_Date__c, Trailer_VIN__c, Boat_Manufacturer__c, Boat_Manufacturer__r.Name, Boat_Model__c, M_Boat_Year__c FROM BOATBUILDING__Item__c where Id =: id];
        if(itemlist.size() > 0){
            return itemlist;
        }
        else{
            return null;
        }
           
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Inventory__c> PopulatePartNumber(){
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
                                                RecordTypeId =: lstRecTypeInv[0].Id];
                                                
                    return PartList;
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Job__c> getDetailsOfJob(String JobId){
      List<BOATBUILDING__Job__c> joblist = [SELECT Id, Name, Job_Name__c, Customer_Pay__c, Total_Hours_Job__c, No_of_Labors__c, Price_per_Labor__c, Shop_Supplies_Total__c, Total_Amount_Job__c, Total_Amount_on_Parts_del__c, Total_Cost_Labor__c, Type__c, Worked_Hours__c, Work_Request__c, Work_Requested__c,  Work_Type__c, (SELECT Id, Name, Quantity__c, Related_to_Job__c, Select_Part__c, Total__c,Price__c FROM Job_Line_Items__r) FROM BOATBUILDING__Job__c where Id =: JobId];
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
    public static String createWarrantyWorkOrder(String Strjson){
    Boolean isError = false;
    Map<String,Object> job ;
    Map<String,Object> map_job_line_item ;
    List<Object> Job_items ; 
    List<Object> Total_job_line_items = new list<Object>();
    List<Object> Job_line_items; 
    BOATBUILDING__Job__c objjob ;BOATBUILDING__Job__c objjob2 ;
    String Contact_Id = '', boatId = '', Drive = '', Hours = '';
        Decimal SalesTax_percent  = 0.0; String SalesTax = '0.00';
        List<Object> Jsonlist = (List<Object>)JSON.deserializeUntyped(Strjson);
        for(Object fld : Jsonlist){    
            Map<String,Object> data = (Map<String,Object>)fld;
            Contact_Id = (String)data.get('Contact_Id');
            boatId = (String)data.get('boatId');
            Drive = (String)data.get('Drive');
            Hours = (String)data.get('Hours');
            SalesTax = (String)data.get('SalesTax');
            SalesTax_percent = Decimal.valueOf(SalesTax);
            Job_items = (List<Object>)data.get('Job_item');
            System.debug('log for Job_items'+Job_items);
        }
         List<RecordType> lstRecTypeCase = [SELECT
                                                    Id,
                                                    Name
                                            FROM
                                                    RecordType
                                            WHERE
                                                    SobjectType =: 'Case'
                                            AND
                                                    DeveloperName =: 'Warranty_Work_Order'
                                            LIMIT
                                                    1]; 
        System.debug('Debug Log For RecordType List : '+lstRecTypeCase);

        Case objCase = new Case();
        if(lstRecTypeCase.size() > 0) {
            objCase.RecordTypeId = lstRecTypeCase[0].Id;
        }
        objCase.ContactId = Contact_Id;        
        objCase.Boat__c = boatId;
        if(Drive != null) {
            objCase.Drive__c = Drive;
        }
        if(Hours != null) {
            objCase.Hours__c = Hours;
        }
        if(SalesTax_percent != null) {
            objCase.Sales_Tax_Percent__c = SalesTax_percent;
        } 
        try {
            insert objCase;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        List<BOATBUILDING__Job__c> lstJob = new List<BOATBUILDING__Job__c>();
        List<BOATBUILDING__Job_Line_Item__c> Total_existing_job_line_items = new List<BOATBUILDING__Job_Line_Item__c>();
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
                        objjob2 = new BOATBUILDING__Job__c(); 
                        objjob2.Unique_Job_id__c = Id; 
                        System.debug('log for objjob2'+objjob2.Unique_Job_id__c);
                        objjob2.Claim_Status__c = String.valueOf(job.get('Claim_Status'));
                        objjob2.Claim_Labor_Approved_Amount__c =  Decimal.valueOf((String)job.get('Claim_Approved_Amo'));
                        objjob2.Return_Parts_Amount__c =  Decimal.valueOf((String)job.get('Return_Part_Amount'));
                        objjob2.Claim_Labor_Paid_Amount__c =  Decimal.valueOf((String)job.get('Claim_Labor_Paid_Amount'));
                        objjob2.Parts_Paid_Amount__c =  Decimal.valueOf((String)job.get('Parts_Paid_Amount'));
                        objjob2.Total_Paid__c =  Decimal.valueOf((String)job.get('Total_Paid'));
                        objjob2.Balance_Due__c =  Decimal.valueOf((String)job.get('WWOBalance_Due'));
                        objjob2.Claim_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Date')));
                        objjob2.Claim_Approval_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Approval_Date')));
                        objjob2.Claim_Paid_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Paid_Date')));
                        JobIdlst.add(ExistingJobId);
                        MapOfExistingId.put(Id,ExistingJobId);   
                    }
                    else{
                        Decimal Customer_Pay = 0;
                        objjob = new BOATBUILDING__Job__c();
                        String Id = (String)job.get('Id');  
                        String WorkRequested = (String)job.get('WorkRequested');
                        String WorkType = (String)job.get('WorkType');
                        String Type = (String)job.get('Type');
                        String Line_item_count = (String)job.get('Line_item_count');
                        Integer Labour_Quantity = Integer.valueOf(job.get('Labour_Quantity'));
                        Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                        Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                        if(String.valueOf(job.get('Customer_Pay')) != null && String.valueOf(job.get('Customer_Pay')) != '') {
                            Customer_Pay = Decimal.valueOf((String)job.get('Customer_Pay'));
                        }
                        //objjob.Work_Requested__c = WorkRequested;
                        objjob.Work_Type__c = WorkType;
                        objjob.Type__c = Type;
                        objjob.Work_Request__c = objCase.Id;
                        objjob.No_of_Labors__c = Labour_Quantity;
                        objjob.Price_per_Labor__c = Labour_Price;
                        objjob.Shop_Supplies_Total__c = Shop_Price;
                        objjob.Customer_Pay__c = Customer_Pay;
                        objjob.Unique_Job_id__c = Id;
                        objJob.Claim_Status__c = String.valueOf(job.get('Claim_Status'));
                        objJob.Claim_Labor_Approved_Amount__c =  Decimal.valueOf((String)job.get('Claim_Approved_Amo'));
                        objJob.Return_Parts_Amount__c =  Decimal.valueOf((String)job.get('Return_Part_Amount'));
                        objJob.Claim_Labor_Paid_Amount__c =  Decimal.valueOf((String)job.get('Claim_Labor_Paid_Amount'));
                        objJob.Parts_Paid_Amount__c =  Decimal.valueOf((String)job.get('Parts_Paid_Amount'));
                        objJob.Total_Paid__c =  Decimal.valueOf((String)job.get('Total_Paid'));
                        objJob.Balance_Due__c =  Decimal.valueOf((String)job.get('WWOBalance_Due'));
                        objJob.Claim_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Date')));
                        objJob.Claim_Approval_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Approval_Date')));
                        objJob.Claim_Paid_Date__c = convertStringIntoDate(String.valueOf(job.get('Claim_Paid_Date')));
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
        
        
        
        List<BOATBUILDING__Job_Line_Item__c> lstJoblineitem = new List<BOATBUILDING__Job_Line_Item__c>();
        if(JobIdlst.size() > 0){
            List<BOATBUILDING__Job__c> Existinglstjob = [Select id, Job_Name__c, Work_Type__c,Type__c,Work_Request__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c,Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from Job_Line_Items__r) from BOATBUILDING__Job__c where id in : JobIdlst];
            
            if(Existinglstjob.size() > 0){
                for(BOATBUILDING__Job__c listId: Existinglstjob){
                    //objjob2.Work_Requested__c = listId.Work_Requested__c;
                    objJob2.Job_Name__c = listId.Job_Name__c;
                    objjob2.Work_Type__c = listId.Work_Type__c;
                    objjob2.Type__c =  listId.Type__c;
                    objjob2.Work_Request__c = objCase.Id;
                    objjob2.No_of_Labors__c =  listId.No_of_Labors__c;
                    objjob2.Price_per_Labor__c = listId.Price_per_Labor__c;
                    objjob2.Shop_Supplies_Total__c =  listId.Shop_Supplies_Total__c;
                    objjob2.Customer_Pay__c =  listId.Customer_Pay__c;
                    lstJob.add(objjob2);
                    if(listId.Job_Line_Items__r.size() > 0){
                        for(BOATBUILDING__Job_Line_Item__c objlinitem : listId.Job_Line_Items__r){
                            Total_existing_job_line_items.add(objlinitem);  
                        }
                    }
                }
            }
        }
        
        
        try {
            insert lstJob;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        System.debug('log for Total_job_line_items'+Total_job_line_items);
        if(Total_job_line_items.size() > 0){
            List<BOATBUILDING__Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Job__c where Unique_Job_id__c in : UniqueJobIdlst];   
            for(Object joblineitemlist : Total_job_line_items) {
                map_job_line_item = (Map<String,Object>)joblineitemlist;
                String Id = (String)map_job_line_item.get('Id');
                System.debug('log for Id'+Id);
                    BOATBUILDING__Job_Line_Item__c obj_job_line_item = new BOATBUILDING__Job_Line_Item__c();
                    Integer PartQuantity = Integer.valueOf(map_job_line_item.get('PartQuantity'));
                    Decimal PartPrice = Decimal.valueOf((String)map_job_line_item.get('PartPrice'));
                    String PartId = (String)map_job_line_item.get('PartId');
                    obj_job_line_item.Quantity__c = PartQuantity;
                    obj_job_line_item.Select_Part__c = PartId;
                    obj_job_line_item.Price__c = PartPrice;
                    for(BOATBUILDING__Job__c uniqueid : newlstjob){
                        if(Id == uniqueid.Unique_Job_id__c){
                            obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                        }
                    }
                System.debug('log for obj_job_line_item'+obj_job_line_item);
                    lstJoblineitem.add(obj_job_line_item);

            }
        }
        /*Set<String> setJobIds = new Set<String>();
        for(BOATBUILDING__Job_Line_Item__c objJob3 : Total_existing_job_line_items) {
            setJobIds.add(objJob3.Related_to_Job__c);
        }
        System.debug('log for Total_existing_job_line_items'+Total_existing_job_line_items);
        List<String> uniqueexistingJobIdlst ;
        if(Total_existing_job_line_items.size() > 0){
            uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
            System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
            List<BOATBUILDING__Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
            for(BOATBUILDING__Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                        BOATBUILDING__Job_Line_Item__c obj_job_line_item2 = new BOATBUILDING__Job_Line_Item__c();
                        obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
                        obj_job_line_item2.Select_Part__c = joblineitemlist2.Select_Part__c;
                        obj_job_line_item2.Price__c = joblineitemlist2.Price__c;
                        for (String key : MapOfExistingId.keySet()) {
                            String value = MapOfExistingId.get(key);
                            if(value.equals(joblineitemlist2.Related_to_Job__c)){
                                String keyvalue = key;
                                for(BOATBUILDING__Job__c Jobid : newlstjob){
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
        
     
     return 'Success';
           
    }*/
}