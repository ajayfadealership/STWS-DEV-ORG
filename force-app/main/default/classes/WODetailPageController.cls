public class WODetailPageController {
    
    @AuraEnabled 
    public static List<LayoutSection> getPageLayoutFields() {
        
        List<LayoutSection> lstSections = new List<LayoutSection>();
        
        try {
            // Provide the page layout name here
            // You can give multiple page layout names here as well
            List<String> componentNameList = new List<String>{'BOATBUILDING__Work_Order__c-BOATBUILDING__Work Order Layout (FAD)'};
                // Retrieve page layout details 
                List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);
            Metadata.Layout contLayout = (Metadata.Layout) components.get(0);
            
            // We are going to find the fields names and will keep them according to columns so 
            // we can show them as per page layout 
            for( Metadata.LayoutSection ls : contLayout.layoutSections ) {
                
                LayoutSection section = new LayoutSection(ls.label, ls.layoutColumns.size());
                
                List<LayoutColumn> lstColumns = new List<LayoutColumn>();
                Integer maxFieldsInColumn = 0;
                for( Metadata.LayoutColumn lc : ls.layoutColumns ) { 
                    
                    LayoutColumn column = new LayoutColumn();
                    // check if there are fields available in that column
                    if( lc.layoutItems != null ) { 
                        // Get the max number of fields in a column to preserve the alignment 
                        if( maxFieldsInColumn < lc.layoutItems.size() ) {
                            maxFieldsInColumn = lc.layoutItems.size();
                        }
                        for( Metadata.LayoutItem li : lc.layoutItems ) {
                            
                            // Pass the LayoutItem object in the LayoutField consturctor        
                            column.lstFields.add( new LayoutField( li ) );
                        }
                    }
                    // No need to add a column in the section if there is no field available 
                    if( column.lstFields.size() > 0 ) {
                        lstColumns.add( column );
                    }
                }
                
                // Now, we need to arrange the fields in section so we can use them in the iteration 
                // on the component so we will have to arrange them in the order 
                if( maxFieldsInColumn > 0 ) {
                    for( Integer i = 0; i < maxFieldsInColumn; i++ ) {
                        for( Integer j = 0; j < lstColumns.size(); j++ ){
                            if( lstColumns[j].lstFields.size() > i ) {
                                section.lstFields.add( lstColumns[j].lstFields[i] );    
                            }    
                            else {
                                section.lstFields.add( new LayoutField() );
                            }
                        }    
                    }    
                }
                
                lstSections.add( section );
            }
        }
        catch( Exception e ){
            System.debug(e.getLineNumber() + ' : ' + e.getMessage() );
        }
        return lstSections; 
    }
    
    public class LayoutSection {   
        @AuraEnabled public String label;
        @AuraEnabled public List<LayoutField> lstFields;
        @AuraEnabled public Integer totalColumns;
        public LayoutSection( String label, Integer totalColumns ) {
            this.label = label;
            this.totalColumns = totalColumns;
            this.lstFields = new List<LayoutField>();
        }
    }
    
    private class LayoutColumn {
        private List<LayoutField> lstFields;    
        public LayoutColumn() {
            this.lstFields = new List<LayoutField>();
        }
    }
    
    public class LayoutField {
        @AuraEnabled public String fieldName;
        @AuraEnabled public Boolean isRequired;
        @AuraEnabled public Boolean isReadOnly;
        
        public LayoutField() {}
        
        public LayoutField( Metadata.LayoutItem li ) {
            
            this.fieldName = li.field;
            if(li.field.contains('__c')){
                if(!li.field.contains('BOATBUILDING__')){
                    this.fieldName = 'BOATBUILDING__'+li.field;
                }
                
                
            }
            if(li.behavior == Metadata.UiBehavior.Required ) {
                this.isRequired = true;
            }
            else if( li.behavior == Metadata.UiBehavior.ReadOnly ) {
                this.isReadOnly = true;
            }    
        }        
    }
    
    public static Decimal getShopSuppliesPer(){
        BOATBUILDING__Shop_Supplies__c myCS1 = BOATBUILDING__Shop_Supplies__c.getValues('ShopSupplies');
        Decimal ssPer = myCS1.BOATBUILDING__Percentage__c;
        if(ssPer != null){
            return ssPer;
        }else
        {
            return 0.00;
        }
      
    }
    
    public static Decimal getShopSuppliesCapping(){
        BOATBUILDING__Shop_Supplies__c myCS1 = BOATBUILDING__Shop_Supplies__c.getValues('ShopSupplies');
        Decimal ssCapAmount = myCS1.BOATBUILDING__Cap_Amount_for_percent__c;
        if(ssCapAmount != null)
            return ssCapAmount;
        else
            return 0.00;
    }
    public static List<String> getWOClaimStatusPickList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = BOATBUILDING__Work_Order_Job__c.BOATBUILDING__Claim_Status_New__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    @AuraEnabled
    public static List<BOATBUILDING.WODetailPageController.WOJobsWrapper> getWorkOrderJobs(String woId){
        List<BOATBUILDING.WODetailPageController.WOJobsWrapper> lstWOJobWrapper = new List<BOATBUILDING.WODetailPageController.WOJobsWrapper>();
        Map<String, String> lstSO = new Map<String, String>();
        
        for(BOATBUILDING__WorkTypePricing__c objWTP : BOATBUILDING__WorkTypePricing__c.getall().values()){
            if(objWTP.BOATBUILDING__Active__c){
                
                lstSO.put(objWTP.Name,String.valueOf(objWTP.BOATBUILDING__Price__c));
            }
        }
        Map<String, BOATBUILDING__Work_Order_Job__c> objMapCannedJob = new Map<String, BOATBUILDING__Work_Order_Job__c>();
        objMapCannedJob = getCannedJobMap();
        Decimal shopSupPer = getShopSuppliesPer();
        Decimal shopSupCap = getShopSuppliesCapping();
        for(BOATBUILDING__Work_Order_Job__c objWOJ : [Select Id,BOATBUILDING__Claim_Labor_Paid_Amount__c,BOATBUILDING__Claim_Status_New__c,BOATBUILDING__Claim_Date__c,BOATBUILDING__Claim_Approval_Date__c,BOATBUILDING__Claim_Paid_Date__c,BOATBUILDING__Misc_Charge_Paid__c,BOATBUILDING__Claim_Labor_Approved_Amount__c,BOATBUILDING__Return_Parts_Amount__c,BOATBUILDING__Total_Paid__c,BOATBUILDING__Parts_Paid_Amount__c,BOATBUILDING__Misc_Charge__c,BOATBUILDING__Misc_Charge_2__c,BOATBUILDING__Misc_Charge_3__c,BOATBUILDING__Misc_Description_1__c,BOATBUILDING__Misc_Description_2__c,BOATBUILDING__Misc_Description_3__c,BOATBUILDING__Total_Misc__c,BOATBUILDING__Work_Order_Warranty_Work_Order__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.Name,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c,BOATBUILDING__Technician__c,BOATBUILDING__Technician__r.Name,BOATBUILDING__Approved_By_Customer__c,BOATBUILDING__Taxable__c,BOATBUILDING__Discount__c,BOATBUILDING__Shipping_Charge__c, Name,BOATBUILDING__Job_Name__c,BOATBUILDING__Work_Type__c,BOATBUILDING__No_of_Labors__c,BOATBUILDING__Total_Amount_Job__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c,BOATBUILDING__Completed__c,BOATBUILDING__Shop_Supplies_Total__c, (Select Id,Name,BOATBUILDING__Quantity__c,BOATBUILDING__Price__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Part__r.BOATBUILDING__Part_Number__c,BOATBUILDING__Dealer_Price__c,BOATBUILDING__Part_Name__c from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where BOATBUILDING__Work_Order_Warranty_Work_Order__c =: woId]){
            BOATBUILDING.WODetailPageController.WOJobsWrapper objWJW = new BOATBUILDING.WODetailPageController.WOJobsWrapper(objWOJ, lstSO);
            objWJW.mapCannedJob = objMapCannedJob;
            objWJW.shopSuppliesPer = shopSupPer;
            objWJW.shopSuppliesCap = shopSupCap;
            lstWOJobWrapper.add(objWJW);
        }
        
        return lstWOJobWrapper;
    }
    
    @AuraEnabled
    public static BOATBUILDING.WODetailPageController.WOJobsWrapper getNewWOJobInstance(String woId){
        Map<String, String> lstSO = new Map<String, String>();
        // BOATBUILDING__Work_Order__c objWO = [Select Id,RecordTypeId,RecordType.developername,RecordType.Name,BOATBUILDING__Store_Location__c from BOATBUILDING__Work_Order__c where Id =: woId];
        for(BOATBUILDING__WorkTypePricing__c objWTP : BOATBUILDING__WorkTypePricing__c.getall().values()){
            if(objWTP.BOATBUILDING__Active__c){
                
                lstSO.put(objWTP.Name, String.valueOf(objWTP.BOATBUILDING__Price__c));
            }
        }
        
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
        objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c = woId;
        objWOJ.BOATBUILDING__Taxable__c = true;
        BOATBUILDING.WODetailPageController.WOJobsWrapper objWJW = new BOATBUILDING.WODetailPageController.WOJobsWrapper(objWOJ, lstSO);
        objWJW.mapCannedJob = getCannedJobMap();
        
        
        objWJW.shopSuppliesPer = getShopSuppliesPer();
        objWJW.shopSuppliesCap = getShopSuppliesCapping();
        return objWJW;
    }
    
    public static Map<String, BOATBUILDING__Work_Order_Job__c> getCannedJobMap(){
        Map<String,BOATBUILDING__Work_Order_Job__c> cannedJobMap = new Map<String, BOATBUILDING__Work_Order_Job__c>();
        for(BOATBUILDING__Work_Order_Job__c objWOJobs : [Select Id,BOATBUILDING__Misc_Charge__c,BOATBUILDING__Misc_Charge_2__c,BOATBUILDING__Misc_Charge_3__c,BOATBUILDING__Misc_Charge_Paid__c,BOATBUILDING__Misc_Description_1__c,BOATBUILDING__Misc_Description_2__c,BOATBUILDING__Misc_Description_3__c,BOATBUILDING__Total_Misc__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.Name,BOATBUILDING__Technician__c,BOATBUILDING__Work_Order_Warranty_Work_Order__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Store_Location__c,BOATBUILDING__Comments__c,BOATBUILDING__Customer_Comments__c,BOATBUILDING__Technician__r.Name,BOATBUILDING__Shipping_Charge__c,BOATBUILDING__Discount__c,BOATBUILDING__Approved_By_Customer__c, Name,BOATBUILDING__Job_Name__c,BOATBUILDING__Work_Type__c,BOATBUILDING__No_of_Labors__c,BOATBUILDING__Total_Amount_Job__c,BOATBUILDING__Shop_Supplies_Total__c,BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Account__c,BOATBUILDING__Taxable__c, (Select Id,Name,BOATBUILDING__Quantity__c,BOATBUILDING__Price__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Part__r.BOATBUILDING__Part_Number__c,BOATBUILDING__Dealer_Price__c, BOATBUILDING__Part_Name__c,BOATBUILDING__Part__c,
                                            BOATBUILDING__Select_Part__r.BOATBUILDING__Part_MSRP_Price__c, BOATBUILDING__Select_Part__r.BOATBUILDING__Cost__c, BOATBUILDING__Part__r.BOATBUILDING__Part_Cost__c, 
                                            BOATBUILDING__Part__r.BOATBUILDING__Retail_Price__c    
                                            from BOATBUILDING__Work_Order_Job_Line_Items__r) from BOATBUILDING__Work_Order_Job__c where RecordType.Name = 'Canned Job']){
            
            cannedJobMap.put(objWOJobs.Id, objWOJobs);
        }
        return cannedJobMap;
    }
    
    public class WOJobsWrapper{
        @AuraEnabled
        public BOATBUILDING__Work_Order_Job__c objWOJ{get; set;}
        @AuraEnabled
        public Decimal shopSuppliesPer{get; set;}
        @AuraEnabled
        public Map<String,BOATBUILDING__SalesTaxConfiguration__c> salesTaxConfig{get; set;}
        @AuraEnabled
        public Decimal shopSuppliesCap{get; set;}
        @AuraEnabled 
        public Map<String, String> lstWorkType{get; set;}
        @AuraEnabled 
        public List<String> lstClaimStatus{get; set;}
        
        @AuraEnabled 
        public Map<String, BOATBUILDING__Work_Order_Job__c> mapCannedJob{get; set;}
        
        public WOJobsWrapper(BOATBUILDING__Work_Order_Job__c job, Map<String, String> lstSO){
            objWOJ = job;
            lstClaimStatus = getWOClaimStatusPickList();
            lstWorkType = lstSO;
            Map<String,BOATBUILDING__SalesTaxConfiguration__c> mapSalesTaxConfig = BOATBUILDING__SalesTaxConfiguration__c.getall();
            salesTaxConfig = mapSalesTaxConfig;
        }
    }
    
    @AuraEnabled
    public static List<User> searchUsersApex(String searchStr){
        String sql = 'Select Id, Name From User WHERE Name LIKE \'%' + searchStr + '%\'';
        List<User> lstUser = Database.query(sql);
        return lstUser;
    }
    @AuraEnabled
    public static List<User> loadSrviceUsers(){
        
        String[]  techRoles = new String []{'Service Tech','Service Technician'};
            
            Boolean first = true;
        String query = 'Select Id,Name,isActive FROM User';
        for(String vp : techRoles){
            if(!first){
                query = query + ' OR';
            } else {
                query = query + ' WHERE';
            }
            query = query + ' UserRole.Name LIKE \'%' + vp + '%\'';
            first = false;
        }
        List<user> lstUser = new List<User>();
        for(User u : Database.query(query)){
            if(u.isActive){
                lstUser.add(u);
            }
        }
        
        return lstUser;
    }
    public static string generateGUID(){
        try{
            Blob b = Crypto.GenerateAESKey(128);
            String h = EncodingUtil.ConvertTohex(b);
            String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
            return guid;
        }
        catch(Exception e){
            return 'Failed';
            
        }
    }
    @AuraEnabled
    public static string deleteJobFromWO(String woId){
        try{
            delete [Select Id from BOATBUILDING__Work_Order_Job__c where Id =: woId];
            return 'SUCCESS';
        }
        catch(Exception e){
            return 'FAILED';
        }
    }
    @AuraEnabled
    public static string deleteJobLineItem(String jliId){
        try{
            delete [Select Id from BOATBUILDING__Work_Order_Job_Line_Item__c where id =: jliId];
            return 'SUCCESS';
        }
        catch(Exception e){
            return 'FAILED';
        }
    }

    @AuraEnabled
    public static string deleteJobLineItemsfromJob(String jobId){
        try{
            delete [Select Id from BOATBUILDING__Work_Order_Job_Line_Item__c where BOATBUILDING__Related_to_Job__c =: jobId];
            return 'SUCCESS';
        }
        catch(Exception e){  
            return 'FAILED';
        }
    }
    @AuraEnabled
    public static List<BOATBUILDING.WODetailPageController.WOJobsWrapper> saveWOJob(String woDataJSON){
        List<WorkOrderData> lstWOData = WorkOrderData.parse(woDataJSON);
        String workOrderId;
        Id devRecordTypeId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Work Order Job').getRecordTypeId();
        Map<String, List<WOrkOrderData.LstJobLineItems>> mapJobTOJLI = new Map<String, List<WOrkOrderData.LstJobLineItems>>();
        
        List<BOATBUILDING__Work_Order_Job__c> lstJobsTOProcess = new List<BOATBUILDING__Work_Order_Job__c>();
        for(WorkOrderData wod : lstWOData){
            System.debug('-----------_@@@@wod'+wod);
            BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
            if(String.isNotBlank(wod.workOrderId) && String.isBlank(workOrderId)){
                workOrderId = wod.workOrderId;
            }
            if(String.isNotBlank(wod.Id) && wod.Id != 'CJ'){
                
                objWOJ.Id = wod.Id;
            }
            if(String.isNotBlank(wod.workOrderId)){
                objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c = wod.workOrderId;
            }
            if(String.isNotBlank(wod.technicianId)){
                objWOJ.BOATBUILDING__Technician__c = wod.technicianId;
            }else{
                objWOJ.BOATBUILDING__Technician__c = null;
            }
            if(wod.isApprovedByCustomer != null){
                objWOJ.BOATBUILDING__Approved_By_Customer__c = wod.isApprovedByCustomer;
            }else{
                objWOJ.BOATBUILDING__Approved_By_Customer__c = false;
            }
            if(wod.isJobTaxable != null){
                objWOJ.BOATBUILDING__Taxable__c = wod.isJobTaxable;
            }else{
                objWOJ.BOATBUILDING__Taxable__c = false;
            }
            if(String.isNotBlank(wod.discontOnJob)){
                objWOJ.BOATBUILDING__Discount__c = Decimal.valueOf(wod.discontOnJob);
            }else{
                objWOJ.BOATBUILDING__Discount__c = 0.00;
            }
            if(String.isNotBlank(wod.ShippingCharges)){
                objWOJ.BOATBUILDING__Shipping_Charge__c = Decimal.valueOf(wod.ShippingCharges);
            }else{
                objWOJ.BOATBUILDING__Shipping_Charge__c = 0.00;
            }
            if(String.isNotBlank(wod.jobName)){
                objWOJ.BOATBUILDING__Job_Name__c = wod.jobName;
            }else{
                objWOJ.BOATBUILDING__Job_Name__c = '';
            }
            if(String.isNotBlank(wod.WorkType)){
                objWOJ.BOATBUILDING__Work_Type__c = wod.WorkType;
            }else{
                objWOJ.BOATBUILDING__Work_Type__c = null;
            }
            if(String.isNotBlank(wod.numberOfLabor)){
                objWOJ.BOATBUILDING__No_of_Labors__c = Decimal.valueOf(wod.numberOfLabor);
            }else{
                objWOJ.BOATBUILDING__No_of_Labors__c  = 0;
            }
            if(String.isNotBlank(wod.totalAmountOnJob)){
                //objWOJ.BOATBUILDING__Total_Amount_Job__c = Decimal.valueOf(wod.totalAmountOnJob);
            }
            if(String.isNotBlank(wod.laborMuliplier)){
                objWOJ.BOATBUILDING__Price_per_Labor__c = Decimal.valueOf(wod.laborMuliplier);
            }else{
                objWOJ.BOATBUILDING__Price_per_Labor__c = 0.00;
            }
            if(String.isNotBlank(String.valueOf(devRecordTypeId))){
                objWOJ.RecordTypeId = devRecordTypeId;
            }
            
            if(String.isNotBlank(wod.claimStatus)){
                objWOJ.BOATBUILDING__Claim_Status_New__c = wod.claimStatus;
            }else{
                objWOJ.BOATBUILDING__Claim_Status_New__c = null;
            }
            if(String.isNotBlank(wod.claimApprovalDate)){
                objWOJ.BOATBUILDING__Claim_Approval_Date__c = Date.valueOf(wod.claimApprovalDate);
            }else{
                objWOJ.BOATBUILDING__Claim_Approval_Date__c = null;
            }
            if(String.isNotBlank(wod.claimDate)){
                objWOJ.BOATBUILDING__Claim_Date__c = Date.valueOf(wod.claimDate);
            }else{
                objWOJ.BOATBUILDING__Claim_Date__c  = null;
            }
            if(String.isNotBlank(wod.claimPaidDate)){
                objWOJ.BOATBUILDING__Claim_Paid_Date__c = Date.valueOf(wod.claimPaidDate);
            }else{
                objWOJ.BOATBUILDING__Claim_Paid_Date__c = null;
            }
            if(String.isNotBlank(wod.claimLaborPaidAmount)){
                objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c = Decimal.valueOf(wod.claimLaborPaidAmount);
            }else{
                objWOJ.BOATBUILDING__Claim_Labor_Paid_Amount__c = 0.00 ;
            }
            if(String.isNotBlank(wod.claimPartsPaidAmount)){
                objWOJ.BOATBUILDING__Parts_Paid_Amount__c =  Decimal.valueOf(wod.claimPartsPaidAmount);
            }else{
                objWOJ.BOATBUILDING__Parts_Paid_Amount__c = 0.00 ;
            }
            if(String.isNotBlank(wod.claimMiscChargesPaid)){
                objWOJ.BOATBUILDING__Misc_Charge_Paid__c = Decimal.valueOf(wod.claimMiscChargesPaid);
            }else{
                objWOJ.BOATBUILDING__Misc_Charge_Paid__c = 0.00 ;
            }
            if(String.isNotBlank(wod.claimLaborApprovedAmount)){
                
                objWOJ.BOATBUILDING__Claim_Labor_Approved_Amount__c = Decimal.valueOf(wod.claimLaborApprovedAmount);
            }else{
                objWOJ.BOATBUILDING__Claim_Labor_Approved_Amount__c = 0.00 ; 
            }
            if(String.isNotBlank(wod.claimReturnPartsAmount)){
                objWOJ.BOATBUILDING__Return_Parts_Amount__c = Decimal.valueOf(wod.claimReturnPartsAmount);
            }else{
                objWOJ.BOATBUILDING__Return_Parts_Amount__c = 0.00 ; 
            }
            if(wod.claimTotalPaidAmount != null){
                objWOJ.BOATBUILDING__Total_Paid__c = Decimal.valueOf(wod.claimTotalPaidAmount);
            }else{
                objWOJ.BOATBUILDING__Total_Paid__c = 0.00;
            }
            if(String.isNotBlank(wod.miscDesc1)){
                objWOJ.BOATBUILDING__Misc_Description_1__c = wod.miscDesc1;
            }else{
                objWOJ.BOATBUILDING__Misc_Description_1__c = '';
            }
            if(String.isNotBlank(wod.miscDesc2)){
                objWOJ.BOATBUILDING__Misc_Description_2__c =  wod.miscDesc2;
            }else{
                objWOJ.BOATBUILDING__Misc_Description_2__c  = '';
            }
            if(String.isNotBlank(wod.miscDesc3)){
                objWOJ.BOATBUILDING__Misc_Description_3__c = wod.miscDesc3;
            }else{
                objWOJ.BOATBUILDING__Misc_Description_3__c = '';
            }
            if(String.isNotBlank(wod.miscCharge1)){
                objWOJ.BOATBUILDING__Misc_Charge__c = Decimal.valueOf(wod.miscCharge1);
            }else{
                objWOJ.BOATBUILDING__Misc_Charge__c = 0.00;
            }
            if(String.isNotBlank(wod.miscCharge2)){
                objWOJ.BOATBUILDING__Misc_Charge_2__c = Decimal.valueOf(wod.miscCharge2);
            }else{
                objWOJ.BOATBUILDING__Misc_Charge_2__c = 0.00;
            }
            if(String.isNotBlank(wod.miscCharge3)){
                objWOJ.BOATBUILDING__Misc_Charge_3__c = Decimal.valueOf(wod.miscCharge3);
            }else{
                objWOJ.BOATBUILDING__Misc_Charge_3__c = 0.00;
            }
            if(String.isNotBlank(wod.customerComment)){
                objWOJ.BOATBUILDING__Customer_Comments__c = wod.customerComment;
            }
            else{
                objWOJ.BOATBUILDING__Customer_Comments__c = '';
            }
            if(String.isNotBlank(wod.serviceWriterComment)){
                objWOJ.BOATBUILDING__Comments__c = wod.serviceWriterComment;
            }else{
                objWOJ.BOATBUILDING__Comments__c = '';
            }
            if(String.isNotBlank(wod.shopSupplies)){
                objWOJ.BOATBUILDING__Shop_Supplies_Total__c =  Decimal.valueOf(wod.shopSupplies);
            }
            else{
                objWOJ.BOATBUILDING__Shop_Supplies_Total__c = 0.00;
            }
            if(String.isNotBlank(wod.ShippingCharges)){
                objWOJ.BOATBUILDING__Shipping_Charge__c = Decimal.valueOf(wod.ShippingCharges);
            }else{
                objWOJ.BOATBUILDING__Shipping_Charge__c = 0.00;
            }
            
            String uniqueGUID = generateGUID();
            objWOJ.BOATBUILDING__Unique_Job_id__c = uniqueGUID;
            if(wod.lstJobLineItems != null && !wod.lstJobLineItems.isEmpty()){
                
                mapJobTOJLI.put(uniqueGUID, wod.lstJobLineItems);
            }
            lstJobsTOProcess.add(objWOJ);
        }
        
        if(!lstJobsTOProcess.isEmpty()){
            upsert lstJobsTOProcess;
            System.debug('-----------_@@@@'+lstJobsTOProcess);
            BOATBUILDING__Work_Order__c objWO = [Select Id, RecordType.Name from BOATBUILDING__Work_Order__c where id =: lstJobsTOProcess[0].BOATBUILDING__Work_Order_Warranty_Work_Order__c];
            
            if(objWO.RecordType.Name == 'Warranty Work Order'){
                Set<String> setJobId = new Set<String>();
                for(BOATBUILDING__Work_Order_Job__c objJobForClaim : lstJobsTOProcess){
                    setJobId.add(objJobForClaim.Id);
                }   
                List<BOATBUILDING__Payments__c> lstPatmentTOUpsert = new List<BOATBUILDING__Payments__c>();
                List<BOATBUILDING__Work_Order_Job__c> lstJobWithPayment = [Select Id,BOATBUILDING__Claim_Labor_Paid_Amount__c,BOATBUILDING__Misc_Charge_Paid__c,BOATBUILDING__Parts_Paid_Amount__c,(Select Id from BOATBUILDING__Payments__r ) from BOATBUILDING__Work_Order_Job__c where Id IN : setJobId];
                for(BOATBUILDING__Work_Order_Job__c objJobForClaim : lstJobWithPayment){
                    BOATBUILDING__Payments__c objClaimPayment = new BOATBUILDING__Payments__c();
                    
                    if(objJobForClaim.BOATBUILDING__Payments__r.size() > 0){
                        objClaimPayment.Id = objJobForClaim.BOATBUILDING__Payments__r[0].Id;
                    }
                    Id workOrderPaymentRTID = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
                    objClaimPayment.RecordTypeId = workOrderPaymentRTID;
                    objClaimPayment.BOATBUILDING__Work_Warranty_Order__c = objWO.Id;  
                    objClaimPayment.BOATBUILDING__Claim_Labor_Paid_Amount__c = objJobForClaim.BOATBUILDING__Claim_Labor_Paid_Amount__c;
                    objClaimPayment.BOATBUILDING__Misc_Charge_Paid__c = objJobForClaim.BOATBUILDING__Misc_Charge_Paid__c;
                    objClaimPayment.BOATBUILDING__Parts_Paid_Amount__c = objJobForClaim.BOATBUILDING__Parts_Paid_Amount__c;
                    objClaimPayment.BOATBUILDING__Work_Order_Job__c = objJobForClaim.Id;
                    if((objJobForClaim.BOATBUILDING__Claim_Labor_Paid_Amount__c != null && objJobForClaim.BOATBUILDING__Claim_Labor_Paid_Amount__c != 0.00) || (objJobForClaim.BOATBUILDING__Misc_Charge_Paid__c != null && objJobForClaim.BOATBUILDING__Misc_Charge_Paid__c != 0.00) || (objJobForClaim.BOATBUILDING__Parts_Paid_Amount__c != null && objJobForClaim.BOATBUILDING__Parts_Paid_Amount__c != 0.00) ){
                        lstPatmentTOUpsert.add(objClaimPayment);
                    }
                }  
                
                if(lstPatmentTOUpsert.size()  > 0){
                    upsert lstPatmentTOUpsert;
                }
            }
            
        }
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLIToProcess = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
        String customerId = '';
        if(!lstJobsTOProcess.isEmpty()){
            List<BOATBUILDING__Work_Order__c> objWO = [Select Id, RecordType.Name,BOATBUILDING__Account__c,BOATBUILDING__Contact__c from BOATBUILDING__Work_Order__c where id =: lstJobsTOProcess[0].BOATBUILDING__Work_Order_Warranty_Work_Order__c];
            if(objWO.size() > 0){
                if(String.isNotBlank(objWO[0].BOATBUILDING__Contact__c)){
                    customerId = objWO[0].BOATBUILDING__Contact__c;
                }
            }
        }
        for(BOATBUILDING__Work_Order_Job__c objWorkOrderJOb : lstJobsTOProcess)
        {

            if(mapJobTOJLI.containsKey(objWorkOrderJOb.BOATBUILDING__Unique_Job_id__c))
            {
                List<WOrkOrderData.LstJobLineItems> lstWOJLI = mapJobTOJLI.get(objWorkOrderJOb.BOATBUILDING__Unique_Job_id__c);
                System.debug('size of li'+ lstWOJLi);
                for(WorkOrderData.LstJobLineItems wodJli : lstWOJLI)
                {
                    BOATBUILDING__Work_Order_Job_Line_Item__c jli = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                    if(String.isNotBlank(wodJli.lineItemId)){
                        jli.Id = wodJli.lineItemId;
                    }
                    else{
                        jli.BOATBUILDING__Related_to_Job__c = objWorkOrderJOb.Id;
                    }
                    if(String.isNotBlank(String.valueOf(wodJli.retailPrice))){
                        jli.BOATBUILDING__Price__c = Decimal.valueOf(wodJli.retailPrice);
                    }
                    System.debug('dfasdfsadfasdfs'+wodJli.cost);
                    if(String.isNotBlank(String.valueOf(wodJli.cost))){
                        System.debug('---cost on the work order------'+wodJli.cost);
                        jli.BOATBUILDING__Dealer_Price__c = Decimal.valueOf(wodJli.cost);
                    }
                    if(String.isNotBlank(wodJli.quantity)){
                        jli.BOATBUILDING__Quantity__c = Decimal.valueOf(wodJli.quantity); 
                    }else{
                        jli.BOATBUILDING__Quantity__c = 0.00;
                    }
                    if(String.isNotBlank(wodJli.partId)){
                        jli.BOATBUILDING__Part__c = wodJli.partId;
                    }
                    if(String.isNotBlank(wodJli.inventoryId)){
                        jli.BOATBUILDING__Select_Part__c = wodJli.inventoryId;       
                    }
                    if(String.isNotBlank(wodJli.partName)){
                        jli.BOATBUILDING__Part_Name__c = wodJli.partName;
                    }
                    if(String.isNotBlank(wodJli.partNumber)){
                        jli.BOATBUILDING__Part_Number__c = wodJli.partNumber;
                    }
                    System.debug('jli.BOATBUILDING__Dealer_Price__c'+jli.BOATBUILDING__Dealer_Price__c);
                    System.debug('jli'+jli);
                    lstJLIToProcess.add(jli);
                    
                }
            }
            List<Event> lstevent = new List<Event>();
            
            if(String.isNotBlank(objWorkOrderJOb.BOATBUILDING__Customer_Comments__c)){
                Event e = new Event();
                e.whatId = objWorkOrderJOb.Id;
                if(String.isNotBlank(customerId)){
                    e.whoId = customerId;
                }
                e.Subject = 'Comment from Service writer';
                e.Description = objWorkOrderJOb.BOATBUILDING__Comments__c;
                e.StartDateTime = System.Now();
                e.EndDateTime = System.Now()+1;
                
                e.Type = 'Comment for Technician';
                if(String.isNotBlank(objWorkOrderJOb.BOATBUILDING__Technician__c)){
                    e.OwnerId = objWorkOrderJOb.BOATBUILDING__Technician__c;
                }
                lstevent.add(e);
            }
            if(String.isNotBlank(objWorkOrderJOb.BOATBUILDING__Comments__c)){
                Event e = new Event();
                e.whatId = objWorkOrderJOb.Id;
                if(String.isNotBlank(customerId)){
                    e.whoId = customerId;
                }
                
                
                e.Description = objWorkOrderJOb.BOATBUILDING__Customer_Comments__c;
                e.StartDateTime = System.Now();
                e.EndDateTime = System.Now()+1;
                e.Subject = 'Comment for Customer';
                e.Type = 'Comment for Customer';
                if(String.isNotBlank(objWorkOrderJOb.BOATBUILDING__Technician__c)){
                    e.OwnerId = objWorkOrderJOb.BOATBUILDING__Technician__c;
                }
                lstevent.add(e);
            }
            if(lstevent.size() > 0){
                
                insert lstevent;
            }
           
        }
        if(!lstJLIToProcess.isEmpty()){
            System.debug('lstJLIToProcess'+lstJLIToProcess);
            upsert lstJLIToProcess;
            System.debug('lstJLIToProcessafter'+lstJLIToProcess);
            
        }
        System.debug('workOrderIdworkOrderIdworkOrderId'+workOrderId);
        List<BOATBUILDING.WODetailPageController.WOJobsWrapper> lstWrapper2 = WODetailPageController.getWorkOrderJobs(workOrderId);
        System.debug('lstWrapper2'+lstWrapper2);
        return lstWrapper2;
        
    }
}