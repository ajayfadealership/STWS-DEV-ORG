/** 
* Author : Akshay Kumar 360 
* Created Date : 25/11/2016
*/
public with sharing class ServicePageController {
    public String objDateTime{get; set;}
    public BOATBUILDING__Manufacturer__c objManufacturer { get; set; }
    public String strPartNumber { get; set; }
    public BOATBUILDING__Order__c objOrder { get; set; }
    public BOATBUILDING__Invoice__c objInvoice { get; set; }
    //public Case objCase { get; set; }
    public BOATBUILDING__Time_Management__c objTM{get; set;}
    public String dayInTime{get; set;}
    public String LunchOutTime{get; set;}
    public String LunchInTime{get; set;}
    public String DayOutTime{get; set;}
    public String TotalTimeWorked{get; set;}
    //public Job__c objJob { get; set; }
    public BOATBUILDING__Inventory__c objInventory { get;set; }
    public Decimal totalAmountDue {get;set;}
    
    public Boolean part { get; set; }
    public Boolean work { get; set; }
    public Boolean schedule { get; set; }
    public Boolean timeBool { get; set; }
    public BOATBUILDING__Payments__c objpayment{get;set;}
    public String UR { get; set; }
    public String UId { get; set; }
    public String pageURL { get; set; }
    //Access Check
    public PageReference checkAccess() {
        part = false;
        work = false;
        schedule = false;
        timeBool = false;
        pageURL = '';
        pageURL = Apexpages.currentPage().getUrl();
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(strAccessKey.containsIgnoreCase('Sales & Service with All')) {
            part = true;
            work = true;
            schedule = true;
            timeBool = true;
        }
        else if(strAccessKey.containsIgnoreCase('Service with Part')) {
            part = true;
            work = false;
            schedule = false;
            timeBool = false;
        }
        else if(strAccessKey.containsIgnoreCase('Service with Work')) {
            part = false;
            work = true;
            schedule = false; 
            timeBool = false;
        }
        else if(strAccessKey.containsIgnoreCase('Service with Schedule')) {
            part = false;
            work = false;
            schedule = true;
            timeBool = false;
        }
        else if(strAccessKey.containsIgnoreCase('Service with Time Management')) {
            part = false;
            work = false;
            schedule = false;
            timeBool = true;
        }
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public void blankMethod() {
        //to Refresh apex elements of vf page
    }
    
    
    
    @RemoteAction
    public static Boolean storeLocationStatus() {
        Store_Location__c objSL = Store_Location__c.getOrgDefaults();
        return objSL.Enable_Multiple_Org__c;
    }
    
    public String baseUrlINV { get; set; }
    public Boolean partRequest { get; set; }
    // Constructor
    public ServicePageController() { 
        partRequest = true;
        if(UserInfo.getOrganizationId().contains('00D46000000Y3Kl')) {
            partRequest = false;
        }
        UR = ''; 
        User u = [Select Id, UserRoleId, UserRole.Name From User Where Id =: UserInfo.getUserId()];
        if(u.UserRoleId != null) {
                UR = u.UserRole.Name;
                UId = u.Id;
        }
         
        baseUrlINV = '';
        BOATBUILDING__EndPointURL__c objEndPointUrl = BOATBUILDING__EndPointURL__c.getInstance('BaseUrlWPayINV');
        if(objEndPointUrl != null){
            if(String.isNotBlank(objEndPointUrl.BOATBUILDING__URL__c)){
                baseUrlINV = objEndPointUrl.BOATBUILDING__URL__c;
            }
        }
        
        objManufacturer = new BOATBUILDING__Manufacturer__c();
        objOrder = new BOATBUILDING__Order__c();
        objInvoice = new BOATBUILDING__Invoice__c();
        objInvoice.RecordTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId();
        objInvoice.Sold_By_Ref__c = UserInfo.getUserId();
        //objCase = new Case();
        objpayment = new BOATBUILDING__Payments__c();
        objDateTime = System.now().format();
        objTM = new BOATBUILDING__Time_Management__c();
        List<RecordType> lstRect = [SELECT          
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Standard_Time_Sheet'
                                        AND
                                                SobjectType = 'BOATBUILDING__Time_Management__c'
                                        LIMIT 
                                                1];
        if(lstRect.size() > 0) { 
            List <BOATBUILDING__Time_Management__c> recordlist= [Select t.Day_In__c,t.Id,t.Day_Out__c,t.Working_Hours__c,t.Lunch_Out__c,t.Lunch_In__c From BOATBUILDING__Time_Management__c t where createddate= today and RecordTypeId =: lstRect[0].Id and ownerid =: userinfo.getUserId() ORDER BY CreatedDate DESC Limit 1];
            if(recordlist.size() > 0){
                objTM = recordlist[0];
                if(objTM.Day_In__c != null)
                {
                        dayInTime = objTM.Day_In__c.format('hh:mm:ss a');
                }
                if(objTM.Lunch_Out__c != null)
                {
                        LunchOutTime = objTM.Lunch_Out__c.format('hh:mm:ss a');
                }
                if(objTM.Lunch_In__c != null)
                {
                        LunchInTime = objTM.Lunch_In__c.format('hh:mm:ss a');
                }
                if(objTM.Day_Out__c != null)
                {
                        dayOutTime = objTM.Day_Out__c.format('hh:mm:ss a');
                }
                if(objTM.Working_Hours__c != null)
                {
                        TotalTimeWorked = String.ValueOf(objTM.Working_Hours__c);
                }
                
            }
        }
        //objJob = new Job__c();
    }
    
    @RemoteAction
    public Static Map<String, String> getTimes()
    {   string din = '';
            String lin = '';
            String lout = '';
            String dout= '';
            Map<String, String> mapSTR = new Map<String, String>();
            List<RecordType> lstRect = [SELECT          
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Standard_Time_Sheet'
                                        AND
                                                SobjectType = 'BOATBUILDING__Time_Management__c'
                                        LIMIT 
                                                1];
        if(lstRect.size() > 0) { 
            List <BOATBUILDING__Time_Management__c> recordlist= [Select t.Day_In__c,t.Id,t.Working_Hours__c,t.Day_Out__c,t.Lunch_Out__c,t.Lunch_In__c From BOATBUILDING__Time_Management__c t where createddate= today and RecordTypeId =: lstRect[0].Id and ownerid =: userinfo.getUserId() ORDER BY CreatedDate DESC Limit 1 ];
            System.debug('Hi This method is being called');
            if(recordlist.size() > 0){
                
                if(recordlist[0].Day_In__c != null)
                {
                        din = recordlist[0].Day_In__c.format('hh:mm:ss a');
                }
                if(recordlist[0].Lunch_Out__c != null)
                {
                        lout = recordlist[0].Lunch_Out__c.format('hh:mm:ss a');
                }
                if(recordlist[0].Lunch_In__c != null)
                {
                        lin = recordlist[0].Lunch_In__c.format('hh:mm:ss a');
                }
                if(recordlist[0].Day_Out__c != null)
                {
                        dout = recordlist[0].Day_Out__c.format('hh:mm:ss a');
                }
                
                mapSTR.put('dayIn', din);
                mapSTR.put('LunchOut', lout);
                mapSTR.put('LunchIn', lin);
                mapSTR.put('dAYOUT', dout);
                mapSTR.put('totalWorkingHours', String.valueOf(recordlist[0].Working_Hours__c)); 
                
                
                
                
            }
        }
        
        return mapSTR;
    }
    //Returns the list of all the purchase orders
    public List<BOATBUILDING__Order__c> getlstOfPurchaseOrder(){
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Purchase_Order'
                                        AND
                                                SobjectType = 'BOATBUILDING__Order__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {                                      
            return [SELECT 
                            Id,
                            Name, 
                            Vendor_Name__c, 
                            Vendor_Name__r.Name, 
                            PO_Date__c, 
                            Amount_On_Order__c
                    FROM  
                            BOATBUILDING__Order__c 
                    WHERE 
                            RecordTypeId =: lstRecType[0].Id limit 1000];
        }
        else {
            return null;
        }
    }
    
    //Returns list of all orders
    public List<BOATBUILDING__Order__c> getlstOfOrder(){
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Order'
                                        AND
                                                SobjectType = 'BOATBUILDING__Order__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {                                      
            return [SELECT 
                            Id,
                            Name, 
                            Vendor_Name__c, 
                            Vendor_Name__r.Name, 
                            PO_Date__c, 
                            Amount_On_Order__c
                    FROM  
                            BOATBUILDING__Order__c 
                    WHERE 
                            RecordTypeId =: lstRecType[0].Id limit 1000];
        }
        else {
            return null;
        }
    }
    
    

    //Returns the list of selected contact
    @RemoteAction
    public static List<Contact> getContact(String strConId) {
        if(strConId != null) {
            return [SELECT Id, Name, Phone, MailingStreet, MailingCity, Email, MailingState, MailingPostalCode FROM Contact WHERE Id =: strConId LIMIT 1];
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Promo_Code__c> getPromocodes() { 
        
            List<BOATBUILDING__Promo_Code__c> lstPC = new List<BOATBUILDING__Promo_Code__c>();
            lstPC = [Select Id, BOATBUILDING__Discount_Amount__c, BOATBUILDING__Discount_In__c, BOATBUILDING__Discount_Percentage__c, BOATBUILDING__IsActive__c, BOATBUILDING__Promo_Code_Name__c 
                                From Promo_Code__c Where BOATBUILDING__IsActive__c = true];
            return lstPC;
        
    }
    
    
    
    //Returns list of all Inventory records
    public List<BOATBUILDING__Inventory__c> getlstOfInventory() {
        
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Inventory_for_Parts'
                                        AND
                                                SobjectType = 'BOATBUILDING__Inventory__c'
                                        LIMIT 
                                                1];
                                                
        System.debug('Debug log for Inventory lstRecType :'+lstRecType);
        if(lstRecType.size() > 0) {
            return [SELECT 
                                Name,
                                Vendor__c,
                                Part_Number__c,
                                Description__c,
                                Category__c,
                                Map_Price__c,
                                Discount__c,
                                Family__c,
                                Size__c,
                                Color__c,
                                Cost__c,
                                Minimum_Amount__c,
                                Part_Location__c,
                                Part_MSRP_Price__c,
                                Weight__c
                        
                    FROM 
                                BOATBUILDING__Inventory__c 
                    WHERE
                                RecordTypeId = :lstRecType[0].Id
                                limit 1000];
            
        }
        
        else{
            
            return null;
        }
        
    }
       
    
    public class InvoiceLineItemWrapper {
        public String PartNumber { get; set; }
        public String PartName { get; set; }
        public Decimal Quantity { get; set; }
        public Decimal MSRP { get; set; }
    }
       
        
    //Returns All the Inventory According To Entered Part Number Or Name
    @RemoteAction
    public static List<InvoiceLineItemWrapper> getListOfInventoryViaPart(String prtDetail, String searchCriteriaValue) {
        List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
        List<BOATBUILDING__Part__c> lstPrt = new List<BOATBUILDING__Part__c>();
        List<InvoiceLineItemWrapper> lstILIW = new List<InvoiceLineItemWrapper>();
        
        lstInv = lstinvRecs(prtDetail, searchCriteriaValue);
        lstPrt = lstPartRecs(prtDetail, searchCriteriaValue);
        Set<String> setPrtNum = new Set<String>();
        
        
        for(BOATBUILDING__Inventory__c objInv: lstInv) {
            setPrtNum.add(objInv.Part_Number__c);
            InvoiceLineItemWrapper objILIW = new InvoiceLineItemWrapper();
            objILIW.PartNumber = objInv.Part_Number__c;
            objILIW.PartName = objInv.Part_Name__c;
            if(objInv.Quantity__c != null) {
                objILIW.Quantity = objInv.Quantity__c;  
            } else {
                objILIW.Quantity = 0;
            }
            if(objInv.Quantity__c != null) {
                objILIW.MSRP = objInv.Part_MSRP_Price__c;
            } else {
                objILIW.MSRP = 0.00;
            }
            
            lstILIW.add(objILIW);
        }
        for(BOATBUILDING__Part__c obPrt: lstPrt) {
            if(!setPrtNum.contains(obPrt.Part_Number__c)) {
                setPrtNum.add(obPrt.Part_Number__c);
                InvoiceLineItemWrapper objILIW = new InvoiceLineItemWrapper();
                objILIW.PartNumber = obPrt.Part_Number__c;
                objILIW.PartName = obPrt.Name;
                if(obPrt.Quantity__c != null) {
                    objILIW.Quantity = obPrt.Quantity__c;
                } else {
                    objILIW.Quantity = 0;
                }
                if(obPrt.Retail_Price__c != null) { 
                    objILIW.MSRP = obPrt.Retail_Price__c;
                } else {
                    objILIW.MSRP = 0.00;
                }
                lstILIW.add(objILIW);
            }
        }
        return lstILIW;
    } 
    //Pending
    public static List<BOATBUILDING__Part__c> lstPartRecs(String prtDetail, String searchCriteriaValue) {
        
        if(searchCriteriaValue == '0') {
            return null;
        }
        else if(prtDetail != null && searchCriteriaValue == '1') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
                            Vendor_Name__c,
                            Part_Number__c, 
                            BOATBUILDING__Retail_Price__c, 
                            Quantity__c ,
                            Discount__c, 
                            Name
                FROM
                            BOATBUILDING__Part__c 
                WHERE
                            Vendor_Name__r.Name 
                LIKE
                            :str];  
        }
        else if(prtDetail != null && searchCriteriaValue == '2') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
                            Vendor_Name__c,
                            Part_Number__c, 
                            BOATBUILDING__Retail_Price__c, 
                            Quantity__c ,
                            Discount__c, 
                            Name
                FROM
                            BOATBUILDING__Part__c 
                WHERE
                            Part_Number__c 
                LIKE
                            :str]; 
        }
        else if(prtDetail != null && searchCriteriaValue == '3') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
                            Vendor_Name__c,
                            Part_Number__c, 
                            BOATBUILDING__Retail_Price__c, 
                            Quantity__c ,
                            Discount__c, 
                            Name
                FROM
                            BOATBUILDING__Part__c 
                WHERE
                            Name 
                LIKE
                            :str]; 
        }
        else if(prtDetail != null && searchCriteriaValue == '4') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
                            Vendor_Name__c,
                            Part_Number__c, 
                            BOATBUILDING__Retail_Price__c, 
                            Quantity__c ,
                            Discount__c, 
                            Name
                FROM
                            BOATBUILDING__Part__c 
                WHERE
                            Category1__c 
                LIKE
                            :str]; 
        } else {
            return new List<BOATBUILDING__Part__c>();
        }
    }
    public static List<BOATBUILDING__Inventory__c> lstinvRecs(String prtDetail, String searchCriteriaValue) {
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
        
        if(searchCriteriaValue == '0') {
            return null;
        }
        else if(lstRecTypeInv.size() > 0 && prtDetail != null && searchCriteriaValue == '1') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
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
                            RecordTypeId =: lstRecTypeInv[0].Id
                AND
                            Vendor__r.Name 
                LIKE
                            :str];
        }
        else if(lstRecTypeInv.size() > 0 && prtDetail != null && searchCriteriaValue == '2') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
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
                            RecordTypeId =: lstRecTypeInv[0].Id
                AND
                            Part_Number__c 
                LIKE
                            :str]; 
        }
        else if(lstRecTypeInv.size() > 0 && prtDetail != null && searchCriteriaValue == '3') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
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
                            RecordTypeId =: lstRecTypeInv[0].Id
                AND
                            Part_Name__c 
                LIKE
                            :str]; 
        }
        else if(lstRecTypeInv.size() > 0 && prtDetail != null && searchCriteriaValue == '4') {
            String str = '%'+prtDetail+'%';     
            return [SELECT  
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
                            RecordTypeId =: lstRecTypeInv[0].Id
                AND
                            Category__c 
                LIKE
                            :str]; 
        } else {
            return new List<BOATBUILDING__Inventory__c>();
        }
    }     
    
    //Returns all the Order Line Item related to selected order
    @RemoteAction
    public static List<Line_Items__c> getAllOrderLineItems(String orderId) {
        System.debug('Called getAllOrderLineItems');
        if(orderId != null) {
            return [SELECT Id, Name, Name__c, Part_Number_del__c, Quantity__c, Retail_Price__c, Vendor_Name__c,Weight__c FROM Line_Items__c WHERE BOATBUILDING__Order__c =: orderId limit 1000];
        }
        else {
            return null;
        }
    }

    //Returns all the standard Invoices
    public List<BOATBUILDING__Invoice__c> getListOrInvoice() {
        List<RecordType> lstRecType = [SELECT           
                                                        Id
                                                FROM    
                                                        RecordType
                                                WHERE       
                                                        DeveloperName = 'Standard_Invoice'
                                                AND
                                                        SobjectType = 'BOATBUILDING__Invoice__c'
                                                LIMIT 
                                                        1];
        if(lstRecType.size() > 0) {
            return [SELECT Id, Name, Customer_Name__c, BOATBUILDING__Invoice_Number__c , BOATBUILDING__Total_Payment__c, BOATBUILDING__Total_Amount_on_Invoice__c ,BOATBUILDING__Total_Amount_Due__c, BOATBUILDING__Balance__c, Created_Date__c, Sum_Price_Line_Items__c, Sum_Discount_Availed_on_Line_Items__c, Payment__c FROM BOATBUILDING__Invoice__c WHERE RecordTypeId =: lstRecType[0].Id ORDER BY createdDate DESC limit 999];//ORDER BY Invoice_Number__c
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static String checkPartAvailability(Map<String, String> mapInventoryWithQuantity, String strStoreLocation, Map<String, String> mapMiscPartQuantity) {
        
        Map<String, List<BOATBUILDING__Parts_Availability__c>> mapPA = new Map<String, List<BOATBUILDING__Parts_Availability__c>>(); 
        
        List<BOATBUILDING__Inventory__c> lstLineItem = [SELECT  
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
                                                                Taxable__c,
                                                                Weight__c,
                                                                (
                                                                    Select Id, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                    From BOATBUILDING__Parts_Availability__r
                                                                )
                                                    FROM
                                                                BOATBUILDING__Inventory__c 
                                                    WHERE
                                                                Part_Number__c IN: mapInventoryWithQuantity.keySet()];
                                                        
        for(BOATBUILDING__Inventory__c objLI : lstLineItem) {
            
        }
        return null;
    }

    //This method will generate invoice according to the changes in total price 
    @RemoteAction 
    public static String generateInvoice(String strPromocode, Map<String, String> mapInventoryWithDiscount, Map<String, String> mapInventoryWithQuantity, String contactId, String strStoreLocation,
                                            Map<String, String> mapMiscPartName, Map<String, String> mapMiscPartQuantity, Map<String, String> mapMiscPartMSRP, Map<String, 
                                                String> mapMiscPartDiscount, String soldById, Map<String, String> mapInventoryWithDiscountPER) {
        try {
        Boolean isError = false;
        String strException = '';
        List<BOATBUILDING__Inventory__c> lstLineItem = [SELECT  
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
                                                        Taxable__c,
                                                        Weight__c,
                                                        (
                                                                Select Id, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                From BOATBUILDING__Parts_Availability__r
                                                           )
                                            FROM
                                                        BOATBUILDING__Inventory__c 
                                            WHERE
                                                        Part_Number__c IN: mapInventoryWithDiscount.keySet()];
        
        Set<String> setInvPN = new Set<String>();                                                         
        for(BOATBUILDING__Inventory__c objI: lstLineItem) {
            setInvPN.add(objI.Part_Number__c);
        }
                                                        
        List<BOATBUILDING__Part__c> lstOfParts = [SELECT 
                                                        Id,
                                                        Name, 
                                                        Dealer_Price__c,  
                                                        Part_Number__c,
                                                        Part_Cost__c, 
                                                        Retail_Price__c, 
                                                        Category1__c,
                                                        Family1__c,
                                                        Vendor_Name__c,
                                                        Map_Price__c,
                                                        Weight__c
                                                FROM  
                                                        BOATBUILDING__Part__c 
                                               Where 
                                                        Part_Number__c IN: mapInventoryWithDiscount.keySet()];
                    
        Map<String,String> mapPartNumberToVendorId = new Map<String,String>();
        
        for(BOATBUILDING__Part__c objPart : lstOfParts){
            mapPartNumberToVendorId.put(objPart.Part_Number__c,objPart.Vendor_Name__c);
        }
        
        List<Contact> lstContact = [SELECT 
                                            Id, 
                                            Name, 
                                            Phone, 
                                            MailingStreet, 
                                            MailingCity, 
                                            Email, 
                                            MailingState, 
                                            MailingPostalCode 
                                    FROM 
                                            Contact 
                                    WHERE 
                                            Id =: contactId 
                                    LIMIT 
                                            1];
        List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        List<RecordType> lstRecType = [SELECT           
                                                        Id
                                                FROM    
                                                        RecordType
                                                WHERE       
                                                        DeveloperName = 'Standard_Invoice'
                                                AND
                                                        SobjectType = 'BOATBUILDING__Invoice__c'
                                                LIMIT 
                                                        1];

        if(lstRecType.size() > 0) {
            objInvoice.RecordTypeId = lstRecType[0].Id;
        }
        if(lstContact.size() > 0) {
            objInvoice.Name = 'Invoice for '+lstContact[0].Name;
            objInvoice.Related_to_Contact__c = lstContact[0].Id;    
            objInvoice.Customer_Name__c = lstContact[0].Name;
            objInvoice.Phone_Number__c = lstContact[0].Phone;
            objInvoice.Customer_Address__c = lstContact[0].MailingStreet;    
            objInvoice.City__c = lstContact[0].MailingCity;
            objInvoice.Email__c = lstContact[0].Email;
            objInvoice.State__c = lstContact[0].MailingState;
            objInvoice.Invoice_Status__c = 'Active';
            objInvoice.Zip_Code__c = lstContact[0].MailingPostalCode;
            objInvoice.Store_Location__c = strStoreLocation;
            objInvoice.Sold_By_Ref__c = soldById;
            if(strPromocode != '0') {
                objInvoice.Promo_Code__c = strPromocode;
                Promo_Code__c objPC = [Select Id, BOATBUILDING__Discount_Amount__c, BOATBUILDING__Discount_In__c, BOATBUILDING__Discount_Percentage__c, BOATBUILDING__IsActive__c, BOATBUILDING__Promo_Code_Name__c 
                                        From Promo_Code__c Where Id =: strPromocode];
                
            }
        }
        
        List<Parts_Availability__c> LstPA = new List<Parts_Availability__c>();
         List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
        //if(objInvoice.Id != null) {
            for(BOATBUILDING__Inventory__c objLI : lstLineItem) {
                BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                if(mapInventoryWithDiscount.containsKey(objLI.Part_Number__c)) {
                    objILI.Name = objLI.Part_Name__c;
                    objILI.Quantity__c = Decimal.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                    objILI.Discount_Price__c = Decimal.valueOf(mapInventoryWithDiscount.get(objLI.Part_Number__c));
                    objILI.BOATBUILDING__Discount_in_Percent__c = Decimal.valueOf(mapInventoryWithDiscountPER.get(objLI.Part_Number__c));
                    objILI.Part_Cost__c = objLI.Part_MSRP_Price__c;
                    objILI.Dealer_Price__c = objLI.Cost__c;
                    objILI.Part_Number__c = objLI.Part_Number__c;
                    //objILI.Related_To_Invoice__c = objInvoice.Id; 
                    if(mapPartNumberToVendorId.containsKey(objLI.Part_Number__c) && mapPartNumberToVendorId.get(objLI.Part_Number__c) != null){
                        objILI.Part_Vendor__c = mapPartNumberToVendorId.get(objLI.Part_Number__c);
                    }
                    objILI.Weight__c = objLI.Weight__c;
                    objILI.Taxable__c = objLI.Taxable__c; 
                    objILI.Category__c = objLI.Category__c; 
                    objILI.Family__c = objLI.Family__c;
                    lstILI.add(objILI);
                    
                    if(objLI.Parts_Availability__r.size() > 0) {
                            Boolean flag = true;
                            Integer count = 1;
                        for(Parts_Availability__c objPA: objLI.Parts_Availability__r) {
                                
                                if(objPA.Store_Location__c == strStoreLocation) {
                                    if(objPA.Quantity__c != null && objLI.Part_Number__c != null && mapInventoryWithQuantity.containsKey(objLI.Part_Number__c) )
                                        objPA.Quantity__c = Integer.valueOf(objPA.Quantity__c) - Integer.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                                    System.debug('objPA: '+objPA); 
                                    LstPA.add(objPA);
                                    count = 0;
                                    flag = true; 
                                } else if(objPA.Store_Location__c != strStoreLocation && count == 1){
                                    flag = false;
                                }
                        }
                        if(!flag && count == 1) {
                                //return 'Part: '+ objLI.Part_Number__c + ' is not available at '+ strStoreLocation + ' Location';
                                if(objLI.Parts_Availability__r[0].Quantity__c != null && objLI.Part_Number__c != null && mapInventoryWithQuantity.containsKey(objLI.Part_Number__c) ) {
                                    objLI.Parts_Availability__r[0].Quantity__c = objLI.Parts_Availability__r[0].Quantity__c - Integer.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                                } else if(objLI.Part_Number__c != null && mapInventoryWithQuantity.containsKey(objLI.Part_Number__c)) {
                                    objLI.Parts_Availability__r[0].Quantity__c = 0 - Integer.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                                }
                        }
                    } else { 
                            objLI.Quantity__c = Integer.valueOf(objLI.Quantity__c) - Integer.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                            lstInv.add(objLI);
                    }
                }
            }
            
            for(Part__c objPrt: lstOfParts) {
                if(!setInvPN.contains(objPrt.Part_Number__c) && mapPartNumberToVendorId.containsKey(objPrt.Part_Number__c)) {
                    BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                    objILI.Name = objPrt.Name;
                    objILI.Quantity__c = Decimal.valueOf(mapInventoryWithQuantity.get(objPrt.Part_Number__c));
                    objILI.Discount_Price__c = Decimal.valueOf(mapInventoryWithDiscount.get(objPrt.Part_Number__c));
                    objILI.BOATBUILDING__Discount_in_Percent__c = Decimal.valueOf(mapInventoryWithDiscountPER.get(objPrt.Part_Number__c));
                    objILI.Part_Cost__c = objPrt.Retail_Price__c;
                    objILI.Part_Number__c = objPrt.Part_Number__c;
                    lstILI.add(objILI);
                } 
            }
            if(mapMiscPartName != null && mapMiscPartName.keySet().size() > 0) {
                for(String strKey: mapMiscPartName.keySet()) {
                    BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                    objILI.Name = mapMiscPartName.get(strKey);
                    objILI.Quantity__c = Decimal.valueOf(mapMiscPartQuantity.get(strKey));
                    objILI.Discount_Price__c = Decimal.valueOf(mapMiscPartDiscount.get(strKey));
                    objILI.BOATBUILDING__Discount_in_Percent__c = Decimal.valueOf(mapInventoryWithDiscountPER.get(strKey));
                    objILI.Part_Cost__c = Decimal.valueOf(mapMiscPartMSRP.get(strKey));
                    objILI.Part_Number__c = strKey;
                    lstILI.add(objILI);
                }
            }
        
        
                insert objInvoice;
                for(BOATBUILDING__Invoice_Line_Item__c objILI: lstILI) {
                    objILI.Related_To_Invoice__c = objInvoice.Id;
                }
            insert lstILI;
            //update LstPA;
         //if(!lstInv.isEmpty()) {
            //update lstInv;
         //}

        

            if(!isError) {
                return objInvoice.Id;
            }
            else {
                return strException;
            }
        } catch(Exception ex) {
            SendEmailUtility.sendQuickEmail('Email For Invoice Part: '+ex.getMessage() +  '  :  ' + ex.getLineNumber());
            return ex+' Part: line num ex '+ex.getLineNumber();
        }
    }

    //Returns the record of selectedItem.
    @RemoteAction
    public static List<BOATBUILDING__Item__c> fetchItems(String strItemId) {
        if(strItemId != null) {
            return [SELECT Id, Boat_HIN_No__c, Engine_SN__c, Boat_Manufacture_Date__c, Trailer_VIN__c, Boat_Manufacturer__c, Boat_Manufacturer__r.Name, Boat_Model__c, M_Boat_Year__c FROM BOATBUILDING__Item__c where Id =: strItemId limit 1];
        }
        else {
            return null;
        }
    }
    
     @RemoteAction
    public static String saveInventory(Map<String,String> objInventoryMap) {
        BOATBUILDING__Inventory__c objInventory2 = new BOATBUILDING__Inventory__c();
        
        
            //objInventory2.Vendor__c = objInventoryMap.get('vendor');
                
            if(objInventoryMap.get('MSRP')!=null && objInventoryMap.get('MSRP')!='') {
                objInventory2.Part_MSRP_Price__c = Decimal.valueOf(objInventoryMap.get('MSRP'));
            }
            
            if(objInventoryMap.get('Description')!=null && objInventoryMap.get('Description')!='') {
                objInventory2.Description__c = objInventoryMap.get('Description');
            }
            
            if(objInventoryMap.get('PartNumber')!=null && objInventoryMap.get('PartNumber')!='') {
                objInventory2.Part_Number__c = objInventoryMap.get('PartNumber');
            }
            
            if(objInventoryMap.get('Category')!=null && objInventoryMap.get('Category')!='') {
                objInventory2.Category__c = objInventoryMap.get('Category');
            }
            
             if(objInventoryMap.get('MapPrice')!=null && objInventoryMap.get('MapPrice')!='') {
                objInventory2.Map_Price__c = Decimal.valueOf(objInventoryMap.get('MapPrice'));
            }
            
            if(objInventoryMap.get('Discount')!=null && objInventoryMap.get('Discount')!='') {
                objInventory2.Discount__c = Decimal.valueOf(objInventoryMap.get('Discount'));
            }
            
            if(objInventoryMap.get('Family')!=null && objInventoryMap.get('Family')!='') {
                objInventory2.Family__c = objInventoryMap.get('Family');
            }
            
            if(objInventoryMap.get('Size')!=null && objInventoryMap.get('Size')!='') {
                objInventory2.Size__c = objInventoryMap.get('Size');
            }
            
            if(objInventoryMap.get('Color')!=null && objInventoryMap.get('Color')!='') {
                objInventory2.Color__c = objInventoryMap.get('Color');
            }
            
            if(objInventoryMap.get('Cost')!=null && objInventoryMap.get('Cost')!='') {
                objInventory2.Cost__c = Decimal.valueOf(objInventoryMap.get('Cost'));
            }
            
            if(objInventoryMap.get('MinAmount')!=null && objInventoryMap.get('MinAmount')!='') {
                objInventory2.Minimum_Amount__c = Decimal.valueOf(objInventoryMap.get('MinAmount'));
            }
            
            if(objInventoryMap.get('inventoryLocation')!=null && objInventoryMap.get('inventoryLocation')!='') {
                objInventory2.Part_Location__c = objInventoryMap.get('inventoryLocation');
            }
            
            List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Inventory_for_Parts'
                                        AND
                                                SobjectType = 'BOATBUILDING__Inventory__c'
                                        LIMIT 
                                                1];
                                                
        System.debug('Debug log for Inventory lstRecType :'+lstRecType);
        if(lstRecType.size() > 0) {
            objInventory2.RecordTypeId = lstRecType[0].Id;
        }
        
        else{
            
            return null;
        }
            
        try {
            System.debug('Debug Log for objInventory2 :'+objInventory2);
            insert objInventory2;
            
            
        }catch(Exception ex) {
            
              System.debug('_________Catch___'+ex);
              System.debug('_________Catch___'+ex.getLineNumber());
             
        }
        if(objInventory2.id!=null) {
                
                return 'SUCCESS';
            }
            else {
                
                return null;
            }
        
        
    }
    /** 
    * Author : Prachi 
    * Created Date : 28/11/2016
    */
    //--------------------------------------Time Management---------------------------------------//
    
    @RemoteAction
    public static List<BOATBUILDING__Time_Management__c> checkrecordexists(){
        System.debug('Debug Log For System: '+ System.now());  
        System.debug('Debug Log For today: '+ System.today());
        System.debug('Debug Log For datetime: '+ datetime.now());
        List<RecordType> lstRect = [SELECT          
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Standard_Time_Sheet'
                                        AND
                                                SobjectType = 'BOATBUILDING__Time_Management__c'
                                        LIMIT 
                                                1];
        if(lstRect.size() > 0) { 
            List <BOATBUILDING__Time_Management__c> recordlist= [Select t.Day_In__c,t.Id,t.Day_Out__c,t.Lunch_Out__c,t.Lunch_In__c From BOATBUILDING__Time_Management__c t where createddate= today and RecordTypeId =: lstRect[0].Id and Ownerid =: userinfo.getUserId() ORDER BY Createddate DESC limit 1];
            if(recordlist.size() > 0){
                return recordlist;
            }
            else{
                return null;
            }
        }
        return null;
    }
    
    //inserting the record and tracking the time for day in.
    @RemoteAction
    public static String dayin(){
        List<RecordType> lstRect = [SELECT          
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Standard_Time_Sheet'
                                        AND
                                                SobjectType = 'BOATBUILDING__Time_Management__c'
                                        LIMIT 
                                                1];
        if(lstRect.size() > 0) { 
            BOATBUILDING__Time_Management__c insertdayin= new BOATBUILDING__Time_Management__c();
            insertdayin.BOATBUILDING__Technician__c = Userinfo.getUserId(); 
            insertdayin.Day_In__c= DateTime.now();
            insertdayin.Logged_In_User__c = UserInfo.getUserId();
            insertdayin.RecordTypeId = lstRect[0].Id;
            try{
                insert insertdayin;
                return insertdayin.id;
            }
            catch(Exception err){
                System.debug(err);
                return 'ERROR';
            }   
        }
        return null;
    }
    
    //updating the record and tracking the time for lunchin.
    @RemoteAction
    public static String lunchout(String tmid){
        BOATBUILDING__Time_Management__c updatelunchout= [Select t.Lunch_In__c, t.Lunch_Out__c,t.Id, t.Day_In__c, t.Day_Out__c From BOATBUILDING__Time_Management__c t where t.Id = : tmid limit 1];
        updatelunchout.Lunch_Out__c= DateTime.now();
        try{
            System.debug('Debug Log For Id: '+updatelunchout.Id);  
            update updatelunchout;
            return updatelunchout.id;
        }
        catch(Exception err){
            System.debug(err);
            return 'ERROR';
        }   
    }
    
    //inserting the record and tracking the time for lunchout.
    @RemoteAction
    public static String lunchin(String tmid){
        BOATBUILDING__Time_Management__c updatelunchin= [Select t.Lunch_In__c, t.Lunch_Out__c,t.Id, t.Day_In__c, t.Day_Out__c From BOATBUILDING__Time_Management__c t where t.Id = : tmid limit 1];
        updatelunchin.Lunch_In__c= DateTime.now();
        try{
            System.debug('Debug Log For Id: '+updatelunchin.Id);  
            update updatelunchin;
            return updatelunchin.id;
        }
        catch(Exception err){
            System.debug(err);
            return 'ERROR';
        }   
        
    }
    
    //inserting the record and tracking the time for dayout.
    @RemoteAction
    public static String dayout(String tmid){
        BOATBUILDING__Time_Management__c updatedayout= [Select t.Lunch_In__c, t.Lunch_Out__c,t.Id, t.Day_In__c, t.Day_Out__c ,t.Working_Hours__c From BOATBUILDING__Time_Management__c t where t.Id = : tmid limit 1];
        updatedayout.Day_Out__c= DateTime.now();
       
        if(updatedayout.Day_In__c != null)
        {   
            Decimal dTotalTime=0.0; Decimal lTotalTime=0.0; Decimal dTotalMin; 
            Decimal dOutHr=0.0, dInHr=0.0 , dOutMin=0.0, dInMin=0.0, lOutHr=0.0, lInHr=0.0, lOutMin=0.0, lInMin = 0.0;
            dOutHr = (updatedayout.Day_Out__c).hour();
            dInHr = (updatedayout.Day_In__c).hour();
            dOutMin = (dOutHr*60 +(updatedayout.Day_Out__c).minute());
            dInMin = (dInHr * 60 + (updatedayout.Day_In__c).minute());
            System.debug('Debug Log For dOutHr: '+dOutHr);  
            System.debug('Debug Log For dInHr: '+dInHr);  
            System.debug('Debug Log For dOutMin: '+dOutMin);  
            System.debug('Debug Log For dInMin: '+dInMin);  
           
            if(updatedayout.Lunch_Out__c !=null && updatedayout.Lunch_In__c !=null){
                System.debug('Log for block : All Conditions true');
                lOutHr = (updatedayout.Lunch_Out__c).hour();
                lInHr = (updatedayout.Lunch_In__c).hour();
                lOutMin = (lOutHr * 60 + (updatedayout.Lunch_Out__c).minute());
                lInMin = (lInHr*60 + (updatedayout.Lunch_In__c).minute());
                System.debug('Debug Log For lOutHr: '+lOutHr);  
                System.debug('Debug Log For lInHr: '+lInHr);  
                System.debug('Debug Log For lOutMin: '+lOutMin);  
                System.debug('Debug Log For lInMin: '+lInMin); 
                
                if(dOutMin >= dInMin){
                System.debug('Log for block : dout greater');
                    dTotalMin = dOutMin - dInMin;
                    //dTotalTime = (dTotalMin/60).setscale(2);
                }
                else if(dInMin >= dOutMin){ 
                System.debug('Log for block : din greater');
                    dTotalMin = dInMin - dOutMin;
                    //dTotalTime = (dTotalMin/60).setscale(2);
                }
                 Decimal lTotalMin = 0.00;
                if(lOutMin >= lInMin){
                System.debug('Log for block : lout greater');
                    lTotalMin = lOutMin - lInMin;
                    //lTotalTime = (lTotalMin/60).setscale(2);
                }
                else if(lInMin >= lOutMin){
                System.debug('Log for block : lin greater');
                    lTotalMin = lInMin - lOutMin;
                    //lTotalTime = (lTotalMin/60).setscale(2);
                }
                updatedayout.Working_Hours__c = ((dTotalMin - lTotalMin)/60).setscale(2);   
            }
            else if(updatedayout.Lunch_Out__c != null && updatedayout.Lunch_In__c == null){
                lOutHr = (updatedayout.Lunch_Out__c).hour();
                lOutMin = (dInHr * 60 + (updatedayout.Lunch_Out__c).minute());
                System.debug('Log for block : Lunch in true only');
                System.debug('Debug Log For lOutHr: '+lOutHr);  
                System.debug('Debug Log For lOutMin: '+lOutMin);  
                System.debug('Debug Log For dInMin: '+dInMin);  
                //lOutMin = 296;
                
                if(dInMin >= lOutMin){
                   System.debug('Log for block : dInMin greater');
                    dTotalTime = dInMin - lOutMin; 
                    updatedayout.Working_Hours__c = (dTotalTime/60).setscale(2);
                }
                else {
                   System.debug('Log for block : lout greater');
                   dTotalTime = lOutMin - dInMin; 
                   updatedayout.Working_Hours__c = (dTotalTime/60).setscale(2);
                }
            }
            else{ 
                if(dOutMin >= dInMin){
                    System.debug('Log for block : Else dout greater');
                    dTotalMin = dOutMin - dInMin;
                    dTotalTime = (dTotalMin/60).setscale(2);
                }
                else if(dInMin >= dOutMin){
                    System.debug('Log for block : Else din greater');
                    dTotalMin = dInMin - dOutMin;
                    dTotalTime = (dTotalMin/60).setscale(2);
                }
                updatedayout.Working_Hours__c = dTotalTime;           
            }
            
            System.debug('Debug Log For total time : '+updatedayout.Working_Hours__c); 
        }
        
          
        //updatedayout.Workinghours__c = updatedayout.Day_In__c + updatedayout.Day_Out__c;
        try{
            update updatedayout;
            Database.executeBatch(new CalculateBilledHourBatch(), 20);
            return 'SUCCESS';  
        }
        catch(Exception err){
            System.debug(err);
            return 'ERROR'; 
        }   
        
    }
    
    
    
    @RemoteAction
    public static string addPayment(Map<String, String> mapPaymentData, String InvoiceID){
        
        BOATBUILDING__Payments__c objPayment = new BOATBUILDING__Payments__c();
        objPayment.BOATBUILDING__Invoice__c = InvoiceID;        
        //objPayment.BOATBUILDING__Amount__c = Decimal.valueOf(mapPaymentData.get('Amount'));
        System.debug('>>>mapPaymentData: '+mapPaymentData);
        if(mapPaymentData.get('PaymentType') == 'Cash') {
            if(mapPaymentData.get('ChangeRTN') != null && decimal.valueOf(mapPaymentData.get('ChangeRTN')) > 0) {
                objPayment.BOATBUILDING__Amount__c = Decimal.valueOf(mapPaymentData.get('Amount')) - Decimal.valueOf(mapPaymentData.get('ChangeRTN'));
                objPayment.BOATBUILDING__Received_Cash__c = Decimal.valueOf(mapPaymentData.get('Amount'));
                objPayment.BOATBUILDING__Return_Change__c = Decimal.valueOf(mapPaymentData.get('ChangeRTN')); 
            }       
        } else {
            objPayment.BOATBUILDING__Amount__c = Decimal.valueOf(mapPaymentData.get('Amount'));
        }
        
        objPayment.BOATBUILDING__Payment_Type__c = mapPaymentData.get('PaymentType');
        objPayment.BOATBUILDING__Credit_Card_Type__c = mapPaymentData.get('CreditCardType');
        objPayment.BOATBUILDING__Check_Number__c = mapPaymentData.get('CheckNumber');
        objPayment.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId();
        System.debug('objPayment----'+objPayment);
         try{
            insert objPayment;
        }catch(Exception ex) {
            System.debug('Debug log for Exception: '+ex);
            return null;
        }
        return 'Payment Created';
    } 
    
    
    //--------------------------------------Time Management---------------------------------------//
    
    @RemoteAction
    public static List<BOATBUILDING__Work_Order__c> fetchWO(String WOId) { 
        return [Select Id, Name, Balance__c From BOATBUILDING__Work_Order__c Where Name =: WOId];
    }
    
}