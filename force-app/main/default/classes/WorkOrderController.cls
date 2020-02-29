public with sharing class WorkOrderController {
    /*public Case objCase { get; set; }
    public BOATBUILDING__Job__c objJob { get; set; }
    public List<SelectOption> lstJobs { get; set; }
    public String selectedJob { get; set; }
    public WorkOrderController() {
        
        objCase = new Case();
        objJob = new BOATBUILDING__Job__c();
        lstJobs = new List<SelectOption>();
        lstJobs.add(new SelectOption('', '--None--'));
        for(BOATBUILDING__Job__c objJob : [Select Id, Name, Job_Name__c  from BOATBUILDING__Job__c]){
                lstJobs.add(new SelectOption(objJob.id, objJob.Job_Name__c ));
        
      } 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__WorkTypePricing__c> fetchWorkTypePricingDetails() {
        return [SELECT Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]; 
    }
    
    public List<Case> getWorkOrderList() {
        List<RecordType> lstRecordType = [SELECT
                                                    Id
                                          FROM
                                                    RecordType
                                          WHERE
                                                    SobjectType = 'Case'
                                          AND
                                                    DeveloperName = 'Work_Order'];
        if(lstRecordType.size() > 0) {
            return [Select Id, CaseNumber, Boat__r.Boat_HIN_No__c, Contact.Name, Hours__c, Drive__c From Case Where RecordTypeId =: lstRecordType[0].Id];
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
    public static List<PartWrapper> PopulatePartNumber(){
        List<PartWrapper> lstPrtWrpr = new List<PartWrapper>();
        Set<String> setPartNumber = new Set<String>();
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
                                                                RecordTypeId =: lstRecTypeInv[0].Id];
            System.debug('Debug Log For PartList: '+PartList);
            if(PartList.size() > 0) {
                for(BOATBUILDING__Inventory__c objInv: PartList) {
                    lstPrtWrpr.add(new PartWrapper(String.valueOf(objInv.Id), String.valueOf(objInv.Part_Name__c), objInv.Part_Number__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                    setPartNumber.add(objInv.Part_Number__c); 
                }
            }                                       
        }
        List<BOATBUILDING__Part__c> lstPrt = [SELECT Id, Name, Part_Number__c, Retail_Price__c From BOATBUILDING__Part__c WHERE Part_Number__c NOT IN: setPartNumber];
        System.debug('Debug Log For lstPrt:'+lstPrt); 
        if(lstPrt.size() > 0) {
            for(BOATBUILDING__Part__c objPart: lstPrt) {
                lstPrtWrpr.add(new PartWrapper(String.valueOf(objPart.Id), objPart.Name, objPart.Part_Number__c, 0, objPart.Retail_Price__c));  
            }
        }           
        System.debug('Debug log for lstPrtWrpr: '+lstPrtWrpr);                            
        return lstPrtWrpr; 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Job__c> getDetailsOfJob(String JobId){
      List<BOATBUILDING__Job__c> joblist = [SELECT Id, Name, Job_Name__c, Work_Requested__c, Customer_Pay__c, Total_Hours_Job__c, No_of_Labors__c, Price_per_Labor__c, Shop_Supplies_Total__c, Total_Amount_Job__c, Total_Amount_on_Parts_del__c, Total_Cost_Labor__c, Type__c, Worked_Hours__c, Work_Request__c,  Work_Type__c, (SELECT Id, Name, Quantity__c, Related_to_Job__c, Part_Name__c, Part_Number__c, Total__c,Price__c FROM BOATBUILDING__Job_Line_Items__r) FROM BOATBUILDING__Job__c where Id =: JobId];
        if(joblist.size() > 0){
            return joblist;
        }
        else{
            return null;
        }
           
    }
    
    @RemoteAction
    public static String createWorkOrder(String Strjson){
        Map<String, Integer> mapPartNumberQuantity = new Map<String, Integer>();
        List<BOATBUILDING__Job__c> lstJob = new List<BOATBUILDING__Job__c>();
        List<BOATBUILDING__Job_Line_Item__c> Total_existing_job_line_items = new List<BOATBUILDING__Job_Line_Item__c>();
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
        BOATBUILDING__Job__c objjob ;BOATBUILDING__Job__c objjob2 ;
        String Contact_Id = '', boatId = '', Drive = '', Hours = '', Status = '', CaseId = '';
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
                SalesTax = (String)data.get('SalesTax');
                SalesTax_percent = Decimal.valueOf(SalesTax);
                Job_items = (List<Object>)data.get('Job_item');
                System.debug('log for Job_items'+Job_items);
            }
            
        if(CaseId == '') {          
             List<RecordType> lstRecTypeCase = [SELECT
                                                        Id,
                                                        Name
                                                FROM
                                                        RecordType
                                                WHERE
                                                        SobjectType =: 'Case'
                                                AND
                                                        DeveloperName =: 'Work_Order'
                                                LIMIT
                                                        1];
    
            Case objCase = new Case();
            if(lstRecTypeCase.size() > 0) {
                objCase.RecordTypeId = lstRecTypeCase[0].Id;
            }
            objCase.ContactId = Contact_Id;        
            objCase.Boat__c = boatId;
            objCase.Drive__c = Drive;
            objCase.Hours__c = Hours;
            objCase.Status = Status;
            objCase.Discount__c = DiscountOnWO;
            objCase.Sales_Tax_Percent__c = SalesTax_percent;
            try {
                insert objCase;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            
            
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
                            if(String.valueOf(job.get('ShippingCharge')) != '') {
                                ShippingCharge = String.valueOf(job.get('ShippingCharge'));
                            }
                            JobIdlst.add(ExistingJobId);
                            Jobvalues.add(Id);
                            Jobvalues.add(JobName);
                            Jobvalues.add(ApprovedByCustomer);
                            Jobvalues.add(Discount);
                            Jobvalues.add(WorkType);
                            Jobvalues.add(Labour_Quantity);
                            Jobvalues.add(ShippingCharge);
                            MapOfExistingValues.put(ExistingJobId, Jobvalues);
                            MapOfExistingId.put(Id,ExistingJobId);
                            System.debug('log for MapOfExistingValues'+MapOfExistingValues); 
                            System.debug('log for map'+MapOfExistingId);    
                        }
                        else{
                            Decimal Customer_Pay = 0;
                            objjob = new BOATBUILDING__Job__c();
                            String Id = (String)job.get('Id');  
                            String strJobName = (String)job.get('JobName');
                            String WorkRequested = (String)job.get('WorkRequested');
                            String WorkType = (String)job.get('WorkType');
                            String Type = (String)job.get('Type');
                            String Line_item_count = (String)job.get('Line_item_count');
                            Decimal Labour_Quantity = Decimal.valueOf((String)job.get('Labour_Quantity'));
                            Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                            Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                            Decimal Shipping = 0.00;
                            if(String.valueOf(job.get('ShippingCharge')) != '') {
                                Shipping = Decimal.valueOf(String.valueOf(job.get('ShippingCharge')));
                            }
                            objjob.Approved_By_Customer__c = String.valueOf(job.get('ApprovedByCustomer')) == '1' ? true : false; 
                            objJob.Discount__c  = String.valueOf(job.get('DiscountOnJob')) != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00;
                            objjob.Job_Name__c = strJobName;
                            //objjob.Work_Requested__c = WorkRequested;
                            objjob.Work_Type__c = WorkType;
                            objjob.Type__c = Type;
                            objjob.Work_Request__c = objCase.Id;
                            objjob.Shipping_Charge__c = Shipping;
                            objjob.No_of_Labors__c = Labour_Quantity;
                            objjob.Price_per_Labor__c = Labour_Price;
                            objjob.Shop_Supplies_Total__c = Shop_Price;
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
            
            
            
            List<BOATBUILDING__Job_Line_Item__c> lstJoblineitem = new List<BOATBUILDING__Job_Line_Item__c>();
            if(JobIdlst.size() > 0){
                List<String> existingJobvalueslst = new List<String>(MapOfExistingValues.keySet());
                List<BOATBUILDING__Job__c> Existinglstjob = [Select id, Job_Name__c, Work_Type__c,Type__c,Work_Request__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c, Part_Name__c, Part_Number__c, Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Job_Line_Items__r) from BOATBUILDING__Job__c where id in : JobIdlst];
                System.debug('log for Existinglstjob'+Existinglstjob);
                if(Existinglstjob.size() > 0){
                    for(BOATBUILDING__Job__c listId: Existinglstjob){
                    for (String key : MapOfExistingValues.keySet()) {
                            String keyvalue = key;
                            if(keyvalue.equals(listId.id)){
                                List<String> listValue = MapOfExistingValues.get(key);
                                
                                objjob2 = new BOATBUILDING__Job__c(); 
                                objjob2.Unique_Job_id__c = listValue[0]; 
                                objjob2.Job_Name__c = listValue[1];
                                objjob2.Approved_By_Customer__c = Boolean.valueOf(listValue[2]);
                                objJob2.Discount__c = Decimal.valueOf(listValue[3]);
                                
                                //objjob2.Work_Requested__c = listId.Work_Requested__c;
                                objjob2.Work_Type__c = listValue[4];
                                objjob2.Type__c =  listId.Type__c;
                                objjob2.Work_Request__c = objCase.Id;
                                objjob2.No_of_Labors__c =  Decimal.valueOf(listValue[5]);
                                objjob2.Shipping_Charge__c =  Decimal.valueOf(listValue[6]);
                                objjob2.Price_per_Labor__c = [Select Price__c, Name From WorkTypePricing__c Where Name =: listValue[4] Limit 1].Price__c;
                                objjob2.Shop_Supplies_Total__c =  listId.Shop_Supplies_Total__c;
                                //objjob2.Customer_Pay__c =  listId.Customer_Pay__c;
                                lstJob.add(objjob2);
                                if(listId.BOATBUILDING__Job_Line_Items__r.size() > 0){
                                    for(BOATBUILDING__Job_Line_Item__c objlinitem : listId.BOATBUILDING__Job_Line_Items__r){
                                        Total_existing_job_line_items.add(objlinitem);  
    
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
            System.debug('log for JobIdlst'+JobIdlst);
            
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
                        //obj_job_line_item.Select_Part__c = PartId;
                        obj_job_line_item.Price__c = PartPrice;
                        String strPrtNameNumber = (String)map_job_line_item.get('PartName');
                        if(strPrtNameNumber != null && strPrtNameNumber.containsIgnoreCase(':')) {
                            String []strSplited = strPrtNameNumber.split(':');
                            if(strSplited.size() > 1) {
                                obj_job_line_item.Part_Name__c = strSplited[1];
                                obj_job_line_item.Part_Number__c = strSplited[0];
                            }
                        }
                        for(Job__c uniqueid : newlstjob){
                            if(Id == uniqueid.Unique_Job_id__c){
                                obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                            }
                        }
                    System.debug('log for obj_job_line_item'+obj_job_line_item);
                        lstJoblineitem.add(obj_job_line_item);
                        mapPartNumberQuantity.put(obj_job_line_item.Part_Number__c, Integer.valueOf(obj_job_line_item.Quantity__c));
                }
                
            }
            System.debug('log for Total_existing_job_line_items'+Total_existing_job_line_items);
            List<String> uniqueexistingJobIdlst ;
            if(Total_existing_job_line_items.size() > 0){
                uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
                System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
                List<BOATBUILDING__Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
                for(BOATBUILDING__Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                            Job_Line_Item__c obj_job_line_item2 = new Job_Line_Item__c();
                            obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                            obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                            obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
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
                            mapPartNumberQuantity.put(obj_job_line_item2.Part_Number__c, Integer.valueOf(obj_job_line_item2.Quantity__c));
                        }
            }
            try {
                insert lstJoblineitem;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
         
         if(mapPartNumberQuantity.keySet().size() > 0){
             List<RecordType> lstRecTypeForInv = [SELECT Id FROM RecordType WHERE SobjectType = 'BOATBUILDING__Inventory__c' AND DeveloperName = 'Inventory_for_Parts' LIMIT 1];
             
             if(lstRecTypeForInv.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstInventory = [SELECT Id, Quantity__c, Name, Part_Number__c, Part_Name__c From BOATBUILDING__Inventory__c Where RecordTypeId =: lstRecTypeForInv[0].Id AND Part_Number__c IN: mapPartNumberQuantity.keySet()];
                if(lstInventory.size() > 0) {
                    for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                        if(objInv.Quantity__c != null) {
                            objInv.Quantity__c -= mapPartNumberQuantity.get(objInv.Part_Number__c);
                        }else {
                            objInv.Quantity__c = mapPartNumberQuantity.get(objInv.Part_Number__c); 
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
                 try {
                    upsert lstInventory;
                 }catch(Exception ex) {
                    System.debug('Debug Log For Exception: '+ex);
                 }   
             }
         }
        }
        else if(CaseId.contains('500')){
            Integer jobCount = 0;
            Case objCase = [SELECT
                                ContactID,
                                Boat__c,
                                Drive__c,
                                Hours__c,
                                Status,
                                ID,
                                (Select Id From BOATBUILDING__Jobs__r)
                                
                        FROM 
                                Case
                        WHERE 
                                Id =: CaseId 
                        LIMIT 
                                1];
            
            try {
                objCase.ContactID = Contact_Id;
                objCase.Boat__c = boatId;
                objCase.Drive__c = Drive;
                objCase.Hours__c = Hours;
                objCase.Status = Status;
                update objCase;
            } 
            catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex);
            }
            
            
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
                            if(String.valueOf(job.get('ShippingCharge')) != '') {
                                ShippingCharge = String.valueOf(job.get('ShippingCharge'));
                            }
                            JobIdlst.add(ExistingJobId);
                            Jobvalues.add(Id);
                            Jobvalues.add(JobName);
                            Jobvalues.add(ApprovedByCustomer);
                            Jobvalues.add(Discount);
                            Jobvalues.add(WorkType);
                            Jobvalues.add(Labour_Quantity);
                            Jobvalues.add(ShippingCharge);
                            MapOfExistingValues.put(ExistingJobId, Jobvalues);
                            MapOfExistingId.put(Id,ExistingJobId);
                            System.debug('log for MapOfExistingValues'+MapOfExistingValues); 
                            System.debug('log for map'+MapOfExistingId);    
                        }
                        else{
                            Decimal Customer_Pay = 0;
                            objjob = new BOATBUILDING__Job__c();
                            String Id = (String)job.get('Id');  
                            String strJobName = (String)job.get('JobName');
                            String WorkRequested = (String)job.get('WorkRequested');
                            String WorkType = (String)job.get('WorkType');
                            String Type = (String)job.get('Type');
                            String Line_item_count = (String)job.get('Line_item_count');
                            Decimal Labour_Quantity = Decimal.valueOf((String)job.get('Labour_Quantity'));
                            Decimal Labour_Price = Decimal.valueOf((String)job.get('Labour_Price'));
                            Decimal Shop_Price = Decimal.valueOf((String)job.get('Shop_Price'));
                            
                            if(String.valueOf(job.get('ShippingCharge')) != '') {
                                objjob.Shipping_Charge__c = Decimal.valueOf(String.valueOf(job.get('ShippingCharge'))); 
                            }
                            objjob.Approved_By_Customer__c = String.valueOf(job.get('ApprovedByCustomer')) == '1' ? true : false; 
                            objJob.Discount__c  = String.valueOf(job.get('DiscountOnJob')) != null && String.valueOf(job.get('DiscountOnJob')) != '' ? Decimal.valueOf(String.valueOf(job.get('DiscountOnJob'))) : 0.00;
                            objjob.Job_Name__c = strJobName;
                            //objjob.Work_Requested__c = WorkRequested;
                            objjob.Work_Type__c = WorkType;
                            objjob.Type__c = Type;
                            objjob.Work_Request__c = objCase.Id;
                            objjob.No_of_Labors__c = Labour_Quantity;
                            objjob.Price_per_Labor__c = Labour_Price;
                            objjob.Shop_Supplies_Total__c = Shop_Price;
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
            
            
            
            List<BOATBUILDING__Job_Line_Item__c> lstJoblineitem = new List<BOATBUILDING__Job_Line_Item__c>();
            if(JobIdlst.size() > 0){
                List<String> existingJobvalueslst = new List<String>(MapOfExistingValues.keySet());
                List<BOATBUILDING__Job__c> Existinglstjob = [Select id, Job_Name__c, Work_Type__c,Type__c,Work_Request__c,No_of_Labors__c,Price_per_Labor__c,Shop_Supplies_Total__c,Customer_Pay__c,Unique_Job_id__c,(SELECT id,Price__c, Part_Name__c, Part_Number__c, Related_to_Job__c,Select_Part__c,Quantity__c,Total__c from BOATBUILDING__Job_Line_Items__r) from BOATBUILDING__Job__c where id in : JobIdlst];
                System.debug('log for Existinglstjob'+Existinglstjob);
                if(Existinglstjob.size() > 0){
                    for(BOATBUILDING__Job__c listId: Existinglstjob){
                    for (String key : MapOfExistingValues.keySet()) {
                            String keyvalue = key;
                            if(keyvalue.equals(listId.id)){
                                List<String> listValue = MapOfExistingValues.get(key);
                                
                                objjob2 = new BOATBUILDING__Job__c(); 
                                objjob2.Unique_Job_id__c = listValue[0]; 
                                objjob2.Job_Name__c = listValue[1];
                                objjob2.Approved_By_Customer__c = Boolean.valueOf(listValue[2]);
                                objJob2.Discount__c = Decimal.valueOf(listValue[3]);
                                
                                //objjob2.Work_Requested__c = listId.Work_Requested__c;
                                objjob2.Work_Type__c = listValue[4];
                                objjob2.Type__c =  listId.Type__c;
                                objjob2.Work_Request__c = objCase.Id;
                                objjob2.No_of_Labors__c =  Decimal.valueOf(listValue[5]);
                                objjob2.Shipping_Charge__c =  Decimal.valueOf(listValue[6]);  
                                objjob2.Price_per_Labor__c = [Select Price__c, Name From WorkTypePricing__c Where Name =: listValue[4] Limit 1].Price__c;
                                objjob2.Shop_Supplies_Total__c =  listId.Shop_Supplies_Total__c;
                                //objjob2.Customer_Pay__c =  listId.Customer_Pay__c;
                                lstJob.add(objjob2);
                                if(listId.BOATBUILDING__Job_Line_Items__r.size() > 0){
                                    for(BOATBUILDING__Job_Line_Item__c objlinitem : listId.BOATBUILDING__Job_Line_Items__r){
                                        Total_existing_job_line_items.add(objlinitem);  
    
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
            System.debug('log for JobIdlst'+JobIdlst);
            
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
                        //obj_job_line_item.Select_Part__c = PartId;
                        obj_job_line_item.Price__c = PartPrice;
                        String strPrtNameNumber = (String)map_job_line_item.get('PartName');
                        if(strPrtNameNumber != null && strPrtNameNumber.containsIgnoreCase(':')) {
                            String []strSplited = strPrtNameNumber.split(':');
                            if(strSplited.size() > 1) {
                                obj_job_line_item.Part_Name__c = strSplited[1];
                                obj_job_line_item.Part_Number__c = strSplited[0];
                            }
                        }
                        for(Job__c uniqueid : newlstjob){ 
                            if(Id == uniqueid.Unique_Job_id__c){
                                obj_job_line_item.Related_to_Job__c = uniqueid.Id;
                            }
                        }
                    System.debug('log for obj_job_line_item'+obj_job_line_item);
                        lstJoblineitem.add(obj_job_line_item);
                        mapPartNumberQuantity.put(obj_job_line_item.Part_Number__c, Integer.valueOf(obj_job_line_item.Quantity__c));
                }
                
            }
            System.debug('log for Total_existing_job_line_items'+Total_existing_job_line_items);
            List<String> uniqueexistingJobIdlst ;
            if(Total_existing_job_line_items.size() > 0){
                uniqueexistingJobIdlst = new List<String>(MapOfExistingId.keySet());
                System.debug('log for uniqueexistingJobIdlst'+uniqueexistingJobIdlst);
                List<BOATBUILDING__Job__c> newlstjob = [Select id,Unique_Job_id__c from BOATBUILDING__Job__c where Unique_Job_id__c in : uniqueexistingJobIdlst];    
                for(BOATBUILDING__Job_Line_Item__c joblineitemlist2 : Total_existing_job_line_items) {
                            Job_Line_Item__c obj_job_line_item2 = new Job_Line_Item__c();
                            obj_job_line_item2.Part_Name__c = joblineitemlist2.Part_Name__c;
                            obj_job_line_item2.Part_Number__c = joblineitemlist2.Part_Number__c;
                            obj_job_line_item2.Quantity__c = joblineitemlist2.Quantity__c;
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
                            mapPartNumberQuantity.put(obj_job_line_item2.Part_Number__c, Integer.valueOf(obj_job_line_item2.Quantity__c));
                        }
            }
            try {
                insert lstJoblineitem;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            if(objCase.BOATBUILDING__Jobs__r.size() > 0) {
                try {
                    delete objCase.BOATBUILDING__Jobs__r;
                }
                catch(Exception ex) {
                    System.debug('Debug Log For Exception: '+ex);
                }
            }
            
        }
         return 'Success';
           
    }
    
    @RemoteAction
    public static List<Object> fetchWorkOrder(String objCaseId) {
        
        List<Object> lstObj = new List<Object>();
        Case objCase = [SELECT 
                                AccountID,
                                ContactID,
                                ContactEmail,
                                Contact.FirstName,
                                Contact.Phone,
                                Contact.LastName,
                                Contact.MailingStreet,
                                Contact.Email,
                                Contact.MailingPostalCode,
                                Contact.MailingCity,
                                RecordType.Name,
                                Boat__c,
                                Boat__r.Name, 
                                Boat__r.Boat_Model__c,
                                Boat__r.Boat_HIN_No__c,
                                Boat__r.Engine_SN__c, 
                                Boat__r.Trailer_VIN__c,
                                Boat__r.Boat_Manufacturer__c,
                                Boat__r.Boat_Manufacturer__r.Name,
                                Boat__r.M_Boat_Year__c,
                                Boat__r.CreatedDateCustom__c,
                                CaseNumber,
                                Drive__c,
                                Hours__c,
                                Status,
                                Priority,
                                ContactPhone,
                                Total_Parts__c,
                                Total_Labor__c,
                                Total_Shop_Supplies__c,
                                Total__c,
                                Sales_Tax__c,
                                Total_Amount_Due__c,
                                Total_Payment__c,
                                Balance__c,
                                ID
                        FROM 
                                Case
                        WHERE 
                                Id =: objCaseId 
                        LIMIT 
                                1];
        List<BOATBUILDING__Job__c> joblist = [Select 
                                                        Work_Type__c, 
                                                        Type__c, 
                                                        Name, 
                                                        Job_Name__c,
                                                        No_of_Labors__c, 
                                                        Price_per_Labor__c, 
                                                        Total_Cost_Labor__c, 
                                                        Shop_Supplies_Total__c, 
                                                        Total_Amount_Job__c, 
                                                        Total_Amount_on_Parts_del__c,
                                                        Customer_Pay__c,
                                                        Total_Hours_Job__c,
                                                        Worked_Hours__c,
                                                        Id,
                                                        Work_Request__r.Description,
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
                                                                    BOATBUILDING__Job_Line_Items__r
                                                            )
                                            From 
                                                        BOATBUILDING__Job__c where Work_Request__c =: objCase.Id];
       
        lstObj.add(objCase);
        
        if(!joblist.isEmpty()) {
            lstObj.add(joblist);
        }
        
        return lstObj;
    }
    
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
    } */
}