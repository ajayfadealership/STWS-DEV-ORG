/** 
* Author                : Akshay Kumar
* Organization          : CloudCodiots LLP. 
* Created Date          : 29/11/2016
* Last Modified Date    : 03/10/2018
*/
public without sharing class InvoiceDetailController {
    //private BOATBUILDING__Invoice__c objInvoice;
    public String paymentDate {get;set;}
    public BOATBUILDING__Invoice__c objInvoice { get; set; }
    public BOATBUILDING__Manufacturer__c objManufacturer { get; set; }
    public String prtNum { get; set; }
    public Integer totalQuantity { get; set; }
    public Decimal totalOfTotal { get; set; }
    public Integer totalOfReceived { get; set; }
    public Decimal totalOfAmount { get; set; } 
    public Integer totalOfBackOrder { get; set; }
    public Decimal totalOfBackOrderAmount { get; set; } 
    public Decimal decDiscount { get; set; }
    public Decimal decShippingCharge { get; set; }
    public Decimal decGrandTotal { get; set; }
    public List<InvoiceLineItemsWrapper> lstInvoiceLineItemsWrapper { get; set; }
    public String btnStatus;
    public list<BOATBUILDING__Invoice_Line_Item__c> lstinvoicelineitem{get;set;}
    public String InvoiceId {get; set;}
    public boolean editMode{get;set;}
    public String lineItemIdToBeUpdated { get; set; }
    public Decimal discountForLineItem { get; set; }
    public Decimal QuantityForLineItem { get; set; }
    public Decimal ShippingCharge { get; set; }
    public Decimal FinalAmount { get; set; }
    public String ILIdelete { get; set; }
    public BOATBUILDING__Payments__c objPayment {get; set;}
    public String baseUrlINV { get; set; }
    public String dicType { get; set; }
    public String printStatus { get; set; }
    
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        System.debug('======strAccessKey ========');
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    } 
    
    //Constructor
    public InvoiceDetailController(ApexPages.StandardController controller) { 
        baseUrlINV = '';
        dicType = '';
        BOATBUILDING__EndPointURL__c objEndPointUrl = BOATBUILDING__EndPointURL__c.getInstance('BaseUrlWPayINV');
        if(objEndPointUrl != null){
            if(String.isNotBlank(objEndPointUrl.BOATBUILDING__URL__c)){
                baseUrlINV = objEndPointUrl.BOATBUILDING__URL__c;
            }
        }
        BOATBUILDING__PrintPageConfig__c objPPC = BOATBUILDING__PrintPageConfig__c.getOrgDefaults();
        printStatus = '0';
        
        if(objPPC != null) { 
            if(objPPC.BOATBUILDING__Sales_Page_Skip__c) {
                printStatus = '1';
            }
        }
        
        ILIdelete = '';
        prtNum = '';
        totalQuantity = 0;
        totalOfTotal = 0.00; 
        totalOfReceived = 0;
        totalOfAmount = 0.00;
        totalOfBackOrder = 0;
        totalOfBackOrderAmount = 0.00;
        decShippingCharge = 0.00;
        decDiscount = 0.00;
        decGrandTotal = 0.00;
        QuantityForLineItem = 0.00;
        ShippingCharge = 0.00;
        FinalAmount = 0.00;
        editMode = false;
        InvoiceId = ApexPages.currentPage().getParameters().get('id');
        lstInvoiceLineItemsWrapper = new List<InvoiceLineItemsWrapper>();
        objInvoice = new BOATBUILDING__Invoice__c();
        //objInvoice = (BOATBUILDING__Invoice__c)controller.getRecord();
        lineItemIdToBeUpdated = '';
        discountForLineItem = 0.00;
        
        objInvoice = [SELECT 
                      Name, 
                      Id, 
                      Sold_By_Ref__c,
                      Sold_By_Ref__r.Name,
                      BOATBUILDING__Account_Name__c,
                      BOATBUILDING__ACV_Form__c,
                      BOATBUILDING__Billing_State_Province__c,
                      BOATBUILDING__Boat_Costline__c,
                      BOATBUILDING__Boat_Length__c,
                      BOATBUILDING__Boat_Reg_Fee__c,
                      BOATBUILDING__Contact_Name__c,
                      BOATBUILDING__Cost__c,
                      BOATBUILDING__Created_Date__c,
                      BOATBUILDING__Customer_Address__c,
                      BOATBUILDING__Customer_Name__c,
                      BOATBUILDING__Deal_Margin__c,
                      BOATBUILDING__Description__c,
                      BOATBUILDING__Email__c,
                      BOATBUILDING__Engine_SN__c,
                      BOATBUILDING__HIN_No__c,
                      BOATBUILDING__Inventory__r.Name,
                      BOATBUILDING__Inventory__c,
                      BOATBUILDING__Invoice_Number__c,
                      BOATBUILDING__Invoice_Status__c,
                      BOATBUILDING__Related_to_Contact__c,
                      BOATBUILDING__Related_to_Contact__r.Name,
                      BOATBUILDING__Related_to_Contact__r.Account.BOATBUILDING__Customer_Balance__c,
                      BOATBUILDING__Related_to_Order__c,
                      BOATBUILDING__Related_to_Product__c,
                      BOATBUILDING__Phone_Number__c,
                      BOATBUILDING__Promo_Code__r.Promo_Code_Name__c,
                      BOATBUILDING__Discount_With_Promocode__c,
                      BOATBUILDING__Non_Taxable__c,
                      BOATBUILDING__Sum_Price_Line_Items__c,
                      BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c ,
                      BOATBUILDING__City__c,
                      BOATBUILDING__Payment__c,
                      BOATBUILDING__Trade_ACV__c,
                      BOATBUILDING__State__c,
                      BOATBUILDING__Zip_Code__c,
                      BOATBUILDING__Total_Labor__c,
                      Owner.name,
                      BOATBUILDING__Sales_Tax_Formula__c ,
                      BOATBUILDING__Total_Payment_Formula__c,
                      BOATBUILDING__Sales_TaxPer__c,
                      BOATBUILDING__Total_Amount_on_Invoice__c,
                      BOATBUILDING__Sales_Tax__c,
                      BOATBUILDING__Total_Payment__c,BOATBUILDING__Total_Shop_Supplies__c,
                      BOATBUILDING__Balance__c,
                      BOATBUILDING__Total_Parts__c,
                      BOATBUILDING__Shipping_Charge__c,
                      BOATBUILDING__Comments_Notes__c
                      
                      FROM 
                      BOATBUILDING__Invoice__c 
                      WHERE
                      Id =: ApexPages.currentPage().getParameters().get('Id')
                      LIMIT
                      1];
        if(objInvoice.BOATBUILDING__Invoice_Status__c != null && objInvoice.BOATBUILDING__Invoice_Status__c == 'Final') {
            editMode = true;
        } else {
            editMode = false;
        }
        
        if(objInvoice.BOATBUILDING__Shipping_Charge__c != null) {
            ShippingCharge = objInvoice.BOATBUILDING__Shipping_Charge__c;
        } 
        System.debug('%%%%%'+objInvoice.Payment__c);
        FinalAmount = ShippingCharge + objInvoice.Payment__c;

        System.debug('%%%%%'+FinalAmount);
        try{
            DateTime dT = [Select id, createdDate from Payment__c where BOATBUILDING__Related_to_Invoice__c =: ApexPages.currentPage().getParameters().get('Id') ORDER BY CreatedDate DESC limit 1].createdDate;
            List<String> lstDate =  String.ValueofGmt(date.newinstance(dT.year(), dT.month(), dT.day())).Split('-'); 
            paymentDate = lstDate[1]+'-'+lstDate[2].left(2)+'-'+lstDate[0];
        }catch(Exception ex){
            System.debug('Debug Log For Exception:'+ex);
        }
        
    }
    
    //Calculates all the related value with received
    public PageReference calculateAllValues() {
        
        System.debug('Called Successfuly : '+prtNum);
        totalOfReceived = 0;
        totalOfAmount = 0.00;
        totalOfBackOrder = 0; 
        totalOfBackOrderAmount = 0.00;
        
        return null;
    }
    
    public PageReference createBackInvoice() {
        
        return null;
    }  
    
    public PageReference addToInventory() {
        
        pageReference pgprint = new pagereference('/apex/Invoice_As_PDF_Example');
        return pgprint;
    }
    
    public void editInovice(){
        system.debug('=====Edit Invoice====');
        editMode = false;
    }
    
    public PageReference CancelInvoice(){
        System.debug('=======Called======= ');
        list<BOATBUILDING__Invoice__c> lstInvoiceToUpdate = new list<BOATBUILDING__Invoice__c>();
        List<BOATBUILDING__Invoice__c> lstInvoice = [Select Id,BOATBUILDING__Total_Parts__c, Sold_By_Ref__c, Sold_By_Ref__r.Name, BOATBUILDING__Inventory__c,BOATBUILDING__Invoice_Status__c from BOATBUILDING__Invoice__c where id =: InvoiceId];
        for(BOATBUILDING__Invoice__c obj : lstInvoice){
            obj.BOATBUILDING__Invoice_Status__c = 'Cancelled';
            lstInvoiceToUpdate.add(obj);
        }
        update lstInvoiceToUpdate;
        /*
        Map<String, Decimal> MapofPartandQuantity = new Map<String, Decimal>();
        List<BOATBUILDING__Invoice_Line_Item__c> lstInvoiceLineItemToUpdate = new list<BOATBUILDING__Invoice_Line_Item__c>();
        
        list<BOATBUILDING__Invoice_Line_Item__c> lstInvoiceLineItem =[Select id, BOATBUILDING__Part_Number__c, BOATBUILDING__Quantity__c from BOATBUILDING__Invoice_Line_Item__c where BOATBUILDING__Related_To_Invoice__c  =:InvoiceId];
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        if(lstInvoice[0].BOATBUILDING__Inventory__c != null) {
            objInventory = [select id, BOATBUILDING__Quantity__c from BOATBUILDING__Inventory__c where id =:lstInvoice[0].BOATBUILDING__Inventory__c];
            objInventory.BOATBUILDING__Quantity__c += lstInvoice[0].BOATBUILDING__Total_Parts__c;
            //update objInventory;
        }
        for(BOATBUILDING__Invoice_Line_Item__c obj : lstInvoiceLineItem){          
            //obj.BOATBUILDING__Quantity__c = 0;
            lstInvoiceLineItemToUpdate.add(obj); 
            MapofPartandQuantity.put(obj.BOATBUILDING__Part_Number__c,obj.BOATBUILDING__Quantity__c);
        }
        System.debug('==MapofPartandQuantity===' +MapofPartandQuantity);
        update lstInvoiceLineItemToUpdate;
        */
        return new PageReference('/apex/ServicePage?subTabName=tab-default-6');
        
        
    }
    
    @RemoteAction
    public static String finalInvoiceApex(String InvoiceId) {
        list<BOATBUILDING__Invoice__c> lstInvoiceToUpdate = new list<BOATBUILDING__Invoice__c>();
        List<BOATBUILDING__Invoice__c> lstInvoice = [Select Id,BOATBUILDING__Total_Parts__c, Sold_By_Ref__c, Sold_By_Ref__r.Name, BOATBUILDING__Inventory__c,BOATBUILDING__Invoice_Status__c from BOATBUILDING__Invoice__c where id =: InvoiceId];
        for(BOATBUILDING__Invoice__c obj : lstInvoice){
            obj.BOATBUILDING__Invoice_Status__c = 'Final';
            lstInvoiceToUpdate.add(obj);
        }
        update lstInvoiceToUpdate;
        //editMode = true;
        return InvoiceId;
    }
    
    @RemoteAction
    public static String updateInvoice(Map<String, String> mapInvoiceDetail, Boolean NonTax) {
        BOATBUILDING__Invoice__c objInvoice = [SELECT 
                                               Name, 
                                               Id, 
                                               BOATBUILDING__Promo_Code__r.Promo_Code_Name__c,
                                               BOATBUILDING__Discount_With_Promocode__c,
                                               BOATBUILDING__Account_Name__c,
                                               BOATBUILDING__ACV_Form__c,
                                               BOATBUILDING__Billing_State_Province__c,
                                               BOATBUILDING__Boat_Costline__c,
                                               BOATBUILDING__Boat_Length__c,
                                               BOATBUILDING__Boat_Reg_Fee__c,
                                               BOATBUILDING__Contact_Name__c,
                                               BOATBUILDING__Cost__c,
                                               BOATBUILDING__Created_Date__c,
                                               BOATBUILDING__Customer_Address__c,
                                               BOATBUILDING__Customer_Name__c,
                                               BOATBUILDING__Deal_Margin__c,
                                               BOATBUILDING__Description__c,
                                               BOATBUILDING__Email__c,
                                               BOATBUILDING__Engine_SN__c,
                                               BOATBUILDING__HIN_No__c,
                                               BOATBUILDING__Inventory__r.Name,
                                               BOATBUILDING__Inventory__c,
                                               BOATBUILDING__Invoice_Number__c,
                                               BOATBUILDING__Sales_Tax_Formula__c,
                                               BOATBUILDING__Invoice_Status__c,
                                               BOATBUILDING__Related_to_Contact__c,
                                               BOATBUILDING__Total_Payment_Formula__c,
                                               BOATBUILDING__Related_to_Contact__r.Name,
                                               BOATBUILDING__Related_to_Order__c,
                                               BOATBUILDING__Related_to_Product__c,
                                               BOATBUILDING__Phone_Number__c,
                                               BOATBUILDING__Non_Taxable__c,
                                               BOATBUILDING__Sum_Price_Line_Items__c,
                                               BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c ,
                                               BOATBUILDING__City__c,
                                               BOATBUILDING__Payment__c,
                                               BOATBUILDING__Trade_ACV__c,
                                               BOATBUILDING__State__c,
                                               BOATBUILDING__Zip_Code__c,
                                               BOATBUILDING__Total_Labor__c,
                                               BOATBUILDING__Shipping_Charge__c,
                                               Owner.name,BOATBUILDING__Sales_TaxPer__c,
                                               BOATBUILDING__Total_Amount_on_Invoice__c,
                                               BOATBUILDING__Sold_By_Ref__c,
                                               Sold_By_Ref__r.Name,
                                               BOATBUILDING__Sales_Tax__c,
                                               BOATBUILDING__Total_Payment__c,
                                               BOATBUILDING__Total_Shop_Supplies__c,
                                               BOATBUILDING__Balance__c,
                                               BOATBUILDING__Total_Parts__c,
                                               BOATBUILDING__Comments_Notes__c
                                               
                                               FROM 
                                               BOATBUILDING__Invoice__c 
                                               WHERE
                                               Id =: String.valueOf(mapInvoiceDetail.get('Id'))
                                               LIMIT
                                               1]; 
        objInvoice.BOATBUILDING__Non_Taxable__c = NonTax;
        objInvoice.Name = String.valueOf(mapInvoiceDetail.get('InvoiceName'));
        if(String.isNotBlank(mapInvoiceDetail.get('InvoiceStatus'))) {
            objInvoice.Invoice_Status__c = mapInvoiceDetail.get('InvoiceStatus');
        }
        if(String.isNotBlank(mapInvoiceDetail.get('RelatedToContact'))) {
            objInvoice.Related_to_Contact__c = mapInvoiceDetail.get('RelatedToContact');
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('NotesComments'))) {
            objInvoice.BOATBUILDING__Comments_Notes__c = mapInvoiceDetail.get('NotesComments');
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('ShopShupplies'))) {
            objInvoice.Total_Shop_Supplies__c = Decimal.valueOf(mapInvoiceDetail.get('ShopShupplies'));
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('City'))) {
            objInvoice.City__c = mapInvoiceDetail.get('City');
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('Email'))) {
            objInvoice.Email__c = mapInvoiceDetail.get('Email');
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('State'))) {
            objInvoice.State__c = mapInvoiceDetail.get('State');
        }                      
        
        if(String.isNotBlank(mapInvoiceDetail.get('Zip'))) {
            objInvoice.Zip_Code__c = mapInvoiceDetail.get('Zip'); 
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('BillingState'))) {
            objInvoice.Billing_State_Province__c = mapInvoiceDetail.get('BillingState'); 
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('Labor'))) {
            objInvoice.Total_Labor__c = Decimal.valueof(mapInvoiceDetail.get('Labor')); 
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('RTO'))) {
            objInvoice.Related_to_Order__c = mapInvoiceDetail.get('RTO');  
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('PhoneNumber'))) {
            objInvoice.Phone_Number__c = mapInvoiceDetail.get('PhoneNumber');  
        }
        
        if(String.isNotBlank(mapInvoiceDetail.get('CustomerAddress'))) {
            objInvoice.Customer_Address__c = mapInvoiceDetail.get('CustomerAddress');  
            
        } 
        
        if(String.isNotBlank(mapInvoiceDetail.get('SoldBy'))) {
            objInvoice.Sold_By_Ref__c = mapInvoiceDetail.get('SoldBy');  
        } 
        
        try {
            update objInvoice;
        } catch(Exception ex) {
            System.debug('Debug Log For Exception:'+ex);
            return null; 
        }                                                       
        return 'SUCCESS';
    }
    //Fetching all line items**********************
    public List<InvoiceLineItemsWrapper> getAllLineItem() {
        List<InvoiceLineItemsWrapper> lstInvoiceLineItemsWrapper = new List<InvoiceLineItemsWrapper>();
        List<BOATBUILDING__Invoice_Line_Item__c> lstILI = [select Id,name,BOATBUILDING__Discount_in_Percent__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Related_To_Invoice__r.name, BOATBUILDING__Description__c,
                                                           BOATBUILDING__Quantity__c,BOATBUILDING__MSRP__c, BOATBUILDING__Total_Price__c,BOATBUILDING__Discount_Price__c, BOATBUILDING__Grand_Total__c,BOATBUILDING__Dealer_Price__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Taxable__c from BOATBUILDING__Invoice_Line_Item__c where BOATBUILDING__Related_To_Invoice__c= :ApexPages.currentPage().getParameters().get('Id')];          
        
        for(BOATBUILDING__Invoice_Line_Item__c objinvoiceline : lstILI) {
            lstInvoiceLineItemsWrapper.add(new InvoiceLineItemsWrapper(objinvoiceline)); 
        }
        return lstInvoiceLineItemsWrapper;
    }
    
    
    //Updating Discount****************************
    public PageReference updateDiscount() {
        System.debug(lineItemIdToBeUpdated + '________________' + discountForLineItem+'---------------'+dicType);
        if(String.isNotBlank(lineItemIdToBeUpdated)) {
            BOATBUILDING__Invoice_Line_Item__c objILI = [Select Id, Discount_Price__c, BOATBUILDING__Discount_in_Percent__c, Total_Price__c From BOATBUILDING__Invoice_Line_Item__c where Id =: lineItemIdToBeUpdated limit 1];
            if(dicType != null && dicType == 'PER') {
                objILI.BOATBUILDING__Discount_in_Percent__c = discountForLineItem;
                
                objILI.Discount_Price__c = (discountForLineItem * objILI.Total_Price__c)/100;
                System.debug(objILI.Total_Price__c + '________________' + objILI.Discount_Price__c+'---------------'+discountForLineItem);
            } else {
                objILI.BOATBUILDING__Discount_in_Percent__c = (discountForLineItem * 100)/objILI.Total_Price__c;
                objILI.Discount_Price__c = discountForLineItem; //Decimal.valueOf(discountForLineItem * objILI.Total_Price__c)/100;
            }
            //objILI.Discount_Price__c = discountForLineItem;
            try {
                update objILI;
            } catch(Exception ex) {
                System.debug('Debug log For Exception: '+ex);
            }
        }
        updateAll();
        return null;
    }
    
    //Updating Quantity****************************
    public PageReference updateQuantity() {
        System.debug(lineItemIdToBeUpdated + '________________' + QuantityForLineItem);
        if(String.isNotBlank(lineItemIdToBeUpdated)) {
            BOATBUILDING__Invoice_Line_Item__c objILI = [Select Id, Quantity__c, Discount_Price__c, BOATBUILDING__Discount_in_Percent__c, Part_Cost__c From BOATBUILDING__Invoice_Line_Item__c where Id =: lineItemIdToBeUpdated limit 1];
            objILI.Quantity__c = QuantityForLineItem;
            Decimal partTotal = objILI.Quantity__c * objILI.Part_Cost__c;
            if(objILI.BOATBUILDING__Discount_in_Percent__c != null ) 
                objILI.Discount_Price__c = (objILI.BOATBUILDING__Discount_in_Percent__c * partTotal)/100;
            try {
                update objILI;
            } catch(Exception ex) {
                System.debug('Debug log For Exception: '+ex);
            }
        }
        updateAll();
        return null;
    }
    
    public PageReference ShippingUpdate() {
        try {
            //objInvoice.Shipping_Charge__c = ShippingCharge;
            update objInvoice;
            FinalAmount = objInvoice.Shipping_Charge__c + objInvoice.Payment__c;
        } catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex); 
        }
        updateAll();
        return null;
    }
    
    @RemoteAction
    public static String updateShipping(String ShippingVal, String InvoiceId) {
        Invoice__c objInv = [Select Id, Shipping_Charge__c, Sold_By_Ref__c, Sold_By_Ref__r.Name From BOATBUILDING__Invoice__c Where Id =: InvoiceId];
        objInv.Shipping_Charge__c = Decimal.valueOf(ShippingVal);
        try {
            update objInv;
        } catch(Exception ex) {
            System.debug('Debug Log For Exception: '+ex);
            return null;
        }
        return 'SUCCESS';
    }
    
    public PageReference deleteLIL() {
        try{
            if(String.isNotBlank(ILIdelete)) {
                delete [Select Id From BOATBUILDING__Invoice_Line_Item__c where Id =: ILIdelete limit 1];
                updateAll();
            }
            return null;
        }catch(Exception e){
            System.debug('Debug Log For Exception: '+e.getStackTraceString());
            return null;
        }
        
    }
    
    @RemoteAction
    public static List<PartResultDiv> searchParts(String strPrtDetail) { 
        
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
                                                             Part_MSRP_Price__c 
                                                             From 
                                                             BOATBUILDING__Inventory__c 
                                                             Where 
                                                             (Part_Number__c LIKE: prtDetail OR Part_Name__c LIKE: prtDetail) AND RecordTypeId =: lstInventoryRT[0].Id];
            
            if(lstInventory.size() > 0) {
                for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                    lstPartResultDiv.add(new PartResultDiv(objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                }
            }
        }
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    }
    
    
    @RemoteAction
    public static String generateInvoice(List<String> lstprt,  Map<String, String> mapInventoryWithQuantity, String invoiceId) {
        Boolean isError = false;
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
                                                        Weight__c
                                                        FROM
                                                        BOATBUILDING__Inventory__c 
                                                        WHERE
                                                        Part_Number__c IN: lstprt];
        List<BOATBUILDING__Part__c> lstOfParts = [SELECT 
                                                  Id,
                                                  Name, 
                                                  Dealer_Price__c, 
                                                  Part_Number__c,
                                                  Part_Cost__c, 
                                                  Retail_Price__c, 
                                                  Vendor_Name__c,
                                                  Map_Price__c,
                                                  Weight__c
                                                  FROM  
                                                  BOATBUILDING__Part__c 
                                                  Where 
                                                  Part_Number__c IN: lstprt Limit 49999];       
        
        Map<String,String> mapPartNumberToVendorId = new Map<String,String>();
        
        for(BOATBUILDING__Part__c objPart : lstOfParts){
            mapPartNumberToVendorId.put(objPart.Part_Number__c,objPart.Vendor_Name__c);
        }
        
        List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        if(String.isNotBlank(invoiceId)) { 
            for(BOATBUILDING__Inventory__c objLI : lstLineItem) {
                BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                if(mapInventoryWithQuantity.containsKey(objLI.Part_Number__c)) {
                    objILI.Name = objLI.Part_Name__c;
                    objILI.Quantity__c = Decimal.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                    objILI.Part_Cost__c = objLI.Part_MSRP_Price__c;
                    objILI.Part_Number__c = objLI.Part_Number__c;
                    objILI.Discount_Price__c = 0.00;
                    objILI.Related_To_Invoice__c = invoiceId;
                    if(mapPartNumberToVendorId.containsKey(objLI.Part_Number__c) && mapPartNumberToVendorId.get(objLI.Part_Number__c) != null){
                        objILI.Part_Vendor__c = mapPartNumberToVendorId.get(objLI.Part_Number__c);
                    }
                    objILI.Weight__c = objLI.Weight__c;
                    objILI.Taxable__c = objLI.Taxable__c;
                    lstILI.add(objILI);
                    objLI.Quantity__c = Integer.valueOf(objLI.Quantity__c) - Integer.valueOf(mapInventoryWithQuantity.get(objLI.Part_Number__c));
                }
            }
        }
        try {
            insert lstILI;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        
        try {
            //update lstLineItem;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        
        if(!isError) {
            return 'SUCCESS';
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static string addPayment(Map<String, String> mapPaymentData, String InvoiceId){
        
        BOATBUILDING__Payments__c objPayment = new BOATBUILDING__Payments__c();
        objPayment.BOATBUILDING__Invoice__c = InvoiceId;
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
        
        try{
            System.debug('payment to be inserted');
            objPayment.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId();
            insert objPayment;
            System.debug('=====objPayment======'+objPayment.id);
        }catch(Exception ex) {
            System.debug('Debug log for Exception: '+ex);
            return null;
        }
        return 'SUCCESS';
    }
    
    //updating Page
    public PageReference updateAll() {
        
        objInvoice = [SELECT 
                      Name, 
                      Id, 
                      BOATBUILDING__Promo_Code__r.Promo_Code_Name__c,
                      BOATBUILDING__Discount_With_Promocode__c,
                      BOATBUILDING__Sold_By_Ref__c,
                      Sold_By_Ref__r.Name,
                      BOATBUILDING__Account_Name__c,
                      BOATBUILDING__ACV_Form__c,
                      BOATBUILDING__Billing_State_Province__c,
                      BOATBUILDING__Boat_Costline__c,
                      BOATBUILDING__Boat_Length__c,
                      BOATBUILDING__Boat_Reg_Fee__c,
                      BOATBUILDING__Contact_Name__c,
                      BOATBUILDING__Sales_Tax_Formula__c ,
                      BOATBUILDING__Cost__c,
                      BOATBUILDING__Created_Date__c,
                      BOATBUILDING__Customer_Address__c,
                      BOATBUILDING__Customer_Name__c,
                      BOATBUILDING__Deal_Margin__c,
                      BOATBUILDING__Description__c,
                      BOATBUILDING__Email__c,
                      BOATBUILDING__Engine_SN__c,
                      BOATBUILDING__HIN_No__c,
                      BOATBUILDING__Inventory__r.Name,
                      BOATBUILDING__Inventory__c,
                      BOATBUILDING__Invoice_Number__c,
                      BOATBUILDING__Invoice_Status__c,
                      BOATBUILDING__Related_to_Contact__c,
                      BOATBUILDING__Related_to_Contact__r.Name,
                      BOATBUILDING__Related_to_Order__c,
                      BOATBUILDING__Related_to_Product__c,
                      BOATBUILDING__Phone_Number__c,
                      BOATBUILDING__Non_Taxable__c,
                      BOATBUILDING__Sum_Price_Line_Items__c,
                      BOATBUILDING__Sum_Discount_Availed_on_Line_Items__c ,
                      BOATBUILDING__Shipping_Charge__c,
                      BOATBUILDING__City__c,
                      BOATBUILDING__Payment__c,
                      BOATBUILDING__Trade_ACV__c,
                      BOATBUILDING__State__c,
                      BOATBUILDING__Zip_Code__c,
                      BOATBUILDING__Total_Payment_Formula__c,
                      BOATBUILDING__Total_Labor__c,
                      Owner.name,BOATBUILDING__Sales_TaxPer__c,
                      BOATBUILDING__Total_Amount_on_Invoice__c,
                      BOATBUILDING__Sales_Tax__c,
                      BOATBUILDING__Total_Payment__c,BOATBUILDING__Total_Shop_Supplies__c,
                      BOATBUILDING__Balance__c,
                      BOATBUILDING__Total_Parts__c,
                      BOATBUILDING__Comments_Notes__c
                      
                      FROM 
                      BOATBUILDING__Invoice__c 
                      WHERE
                      Id =: ApexPages.currentPage().getParameters().get('Id')
                      LIMIT
                      1];
       // System.debug('&&&&&&'+FinalAmount);
        if(objInvoice.Shipping_Charge__c!=null)
            ShippingCharge = objInvoice.BOATBUILDING__Shipping_Charge__c;
        if(objInvoice.Payment__c!=null)
            FinalAmount = ShippingCharge+objInvoice.Payment__c;
        // System.debug('&&&&&&After'+FinalAmount);
        return null;
    }
    
    public class PartResultDiv {
        public String PartNumber;
        public String PartName;
        public Integer Quantity;
        public Decimal MSRP;
        
        public PartResultDiv(String PartNumber, String PartName, Integer Quantity, Decimal MSRP) {
            this.PartNumber = PartNumber;
            this.PartName = PartName;
            this.Quantity = Quantity;
            this.MSRP = MSRP;
        }
    }
    
    public class InvoiceLineItemsWrapper{
        public BOATBUILDING__Invoice_Line_Item__c objInvoiceLineItem { get; set; }
        public InvoiceLineItemsWrapper(BOATBUILDING__Invoice_Line_Item__c objInvoiceLineItem) {
            this.objInvoiceLineItem = objInvoiceLineItem;
        }
    }
}