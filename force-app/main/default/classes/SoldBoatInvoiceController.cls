/** 
* Author : Akshay Kumar  
* Created Date : 23/11/2016
*/
public with sharing class SoldBoatInvoiceController {
    public List<BOATBUILDING__Quote__c> lstQuote { get; set; }
    public Boolean isQuantityNotUpdated { get; set; }
    public String status { get; set; }
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    public SoldBoatInvoiceController(ApexPages.StandardController controller) {
        isQuantityNotUpdated = false;
        status = '';
        lstQuote = [SELECT
                    Transmission_Gearbox_SN__c, 
                    Total_Price_Quote__c, 
                    Manufacturer_Invoice__c,
                    Test_2__c, 
                    Test_2__r.Quantity__c, 
                    Test_2__r.Manufacture_Invoice2__c,
                    Test_2__r.Manufacturer__c,
                    Test_2__r.Cost__c,
                    Tax__c, 
                    SystemModstamp, 
                    Syncing__c, 
                    Status__c, 
                    State__c, 
                    Shipping_And_Handling__c, 
                    Ship_To__c, 
                    Ship_To_Name__c, 
                    Related_to_Product__c, 
                    Related_to_Order__c, 
                    Related_To_Opportunity__c, 
                    Quote_Your_Price_Negotiation__c, 
                    Quote_Your_Price_Formula__c, 
                    Quote_Trailer_Sales_Tax__c, 
                    Quote_Trailer_Sales_Tax_Negotiation__c, 
                    Quote_Trailer_Reg_Fee__c, 
                    Quote_Trailer_Reg_Fee_Negotiation__c, 
                    Quote_Trailer_Allowance__c, 
                    Quote_Trailer_Allowance_Negotiation__c, 
                    Quote_Trailer_Allowance_Calculated__c, 
                    Quote_Trailer_ACV__c, 
                    Quote_Trailer_ACV_Negotiation__c, 
                    Quote_Trade_Payoff__c, 
                    Quote_Trade_Allowance__c, 
                    Quote_Trade_Allowance_Negotiation__c, 
                    Quote_Trade_ACV__c, 
                    Quote_Trade_ACV_Negotiation__c, 
                    Quote_Total_Price_Calculated__c, 
                    Quote_Total_Over_Allowance_Calculated__c, 
                    Quote_Total_MSRP__c, 
                    Quote_Total_Amount_Financed_Calculated__c, 
                    Quote_To_Name__c, 
                    Quote_To_Address__c, 
                    Quote_Term__c, 
                    Quote_Sale_Price__c, 
                    Quote_Rate__c, 
                    Quote_Payment__c, 
                    Quote_Payment_Negotiation__c, 
                    Quote_Number__c, 
                    Quote_Net_Selling_Price_Calculated__c, 
                    Quote_MSRP_Trailer_Price__c, 
                    Quote_MSRP_Trailer_Price_Negotiation__c, 
                    Quote_MSRP_Boat_Price__c, 
                    Quote_Down_Payment__c, 
                    Quote_Doc_Fee__c, 
                    Quote_Deal_Margin__c, 
                    Quote_Cost__c, 
                    Quote_Boat_Trade_Over_Allowance_Calculat__c, 
                    Quote_Boat_Sales_Tax_Negotiation__c, 
                    Quote_Boat_Sales_Tax_Calculated__c, 
                    Quote_Boat_Reg_Fee__c, 
                    QuoteHiddenBox__c, 
                    BOATBUILDING__Tyre_Tax__c,
                    Phone__c, 
                    OwnerId, 
                    NetSalesTax__c, 
                    Negotiation_Trailer_ACV__c, 
                    Negotiation_Trade_Payoff__c, 
                    Negotiation_MSRP_Boat_Price__c, 
                    Name, 
                    Mapped_Trailer_VIN__c, 
                    Mapped_HIN__c, 
                    Mapped_Engine_SN__c, 
                    Mapped_Boat_Length__c, 
                    MSRP_Boat_Price_Negotiation__c, 
                    Id, 
                    Grand_Total__c, 
                    Fax__c, 
                    Expiration_Date__c, 
                    Email__c, 
                    Discount__c, 
                    Discount_On_Quote__c, 
                    Description__c, 
                    CreatedDate, 
                    CreatedById, 
                    Contact_Name__c, 
                    Commission__c, 
                    Booked_Sale_Price__c, 
                    Booked_ACV__c, 
                    Boat_Sales_Tax2__c, 
                    Boat_Costline__c, 
                    Bill_To__c, 
                    Bill_To_Name__c, 
                    Additional_To__c, 
                    Additional_To_Name__c, 
                    Account_Name__c, 
                    APPROVED_ACV__c, 
                    Store_Location__c,
                    BOATBUILDING__ACV_FORM__c,
                    Boat_Sold_By__c,
                    Sold_Boat_Account__c,
                    (Select
                     Id, Name, CreatedDate, 
                     BOATBUILDING__Quote__c, BOATBUILDING__Amount__c, 
                     BOATBUILDING__Payment_Type__c, BOATBUILDING__Check_Number__c, 
                     BOATBUILDING__Credit_Card_Type__c, BOATBUILDING__MCSTransactionID__c, 
                     BOATBUILDING__ProcessorApprovalCode__c, BOATBUILDING__ProcessorTransactionID__c, 
                     BOATBUILDING__ResultCode__c, BOATBUILDING__ResultDetail__c, 
                     BOATBUILDING__Store_Location__c 
                     From 
                     BOATBUILDING__Payment__r
                     Where 
                     RecordTypeId =: Schema.SObjectType.BOATBUILDING__All_Payment__c.getRecordTypeInfosByName().get('Quote Payment').getRecordTypeId()) 
                    FROM  
                    BOATBUILDING__Quote__c 
                    WHERE 
                    Id =: ApexPages.currentPage().getParameters().get('Id')
                    LIMIT 
                    1];
        status = lstQuote[0].Status__c;
        //directTo();
    }
    
    public PageReference directTo() {
        try {
            if(lstQuote[0].Status__c == null || !lstQuote[0].Status__c.equalsIgnoreCase('Final')) {
                isQuantityNotUpdated = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Quote is not final.'));
                return null;
            } 
            
            if(lstQuote.size() > 0 ) { 
                BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
                if(lstQuote[0].Test_2__c != null) {
                    Boolean isError = false;
                    //***Invoice Edit***
                    List<RecordType> lstRecType = [SELECT
                                                   Id,  
                                                   Name
                                                   FROM 
                                                   RecordType
                                                   WHERE
                                                   DeveloperName = 'Sold_Boat_Invoice'
                                                   AND
                                                   SobjectType = 'BOATBUILDING__Invoice__c'
                                                   LIMIT 
                                                   1];
                    if(lstRecType.size() > 0) { 
                        objInvoice.RecordTypeId = lstRecType[0].Id;
                        System.debug('Debug Log For Record Type:'+lstRecType[0].Id);
                    }
                    objInvoice.Name = lstQuote[0].Name+' Invoice';
                    //new Fields****************   
                    if(lstQuote[0].Test_2__r.Manufacture_Invoice2__c != null) objInvoice.Manufacture_Invoice2__c = lstQuote[0].Test_2__r.Manufacture_Invoice2__c;
                    if(lstQuote[0].Quote_Down_Payment__c != null) objInvoice.Down_Payment__c = lstQuote[0].Quote_Down_Payment__c;
                    if(lstQuote[0].Boat_Sold_By__c != null) objInvoice.Boat_Sold_By__c = lstQuote[0].Boat_Sold_By__c;
                    if(lstQuote[0].Sold_Boat_Account__c != null) objInvoice.Sold_Boat_Account__c = lstQuote[0].Sold_Boat_Account__c;
                    if(lstQuote[0].Test_2__r.Cost__c != null) objInvoice.Cost__c = lstQuote[0].Test_2__r.Cost__c; 
                    
                    //Old Mapping*****************
                    if(lstQuote[0].Account_Name__c != null) objInvoice.Account_Name__c = lstQuote[0].Account_Name__c;
                    if(lstQuote[0].Contact_Name__c != null) objInvoice.Contact_Name__c = lstQuote[0].Contact_Name__c;
                    if(lstQuote[0].Description__c != null) objInvoice.Description__c = lstQuote[0].Description__c;
                    if(lstQuote[0].Email__c != null) objInvoice.Email__c = lstQuote[0].Email__c;
                    if(lstQuote[0].Expiration_Date__c != null) objInvoice.Expiration_Date__c = lstQuote[0].Expiration_Date__c;
                    if(lstQuote[0].Phone__c != null) objInvoice.Phone__c = lstQuote[0].Phone__c;
                    if(lstQuote[0].Quote_To_Name__c != null) objInvoice.Quote_To_Name__c = lstQuote[0].Quote_To_Name__c;
                    if(lstQuote[0].Ship_To__c != null) objInvoice.Ship_To__c = lstQuote[0].Ship_To__c;
                    if(lstQuote[0].Status__c != null) objInvoice.Status__c = lstQuote[0].Status__c;
                    if(lstQuote[0].ACV_Form__c != null) objInvoice.ACV_Form__c = lstQuote[0].ACV_Form__c;
                    objInvoice.Inventory__c = lstQuote[0].Test_2__c;
                    if(lstQuote[0].Related_to_Order__c != null) objInvoice.Related_to_Order__c = lstQuote[0].Related_to_Order__c;
                    if(lstQuote[0].Related_to_Product__c != null) objInvoice.Related_to_Product__c = lstQuote[0].Related_to_Product__c;
                    objInvoice.Syncing__c = lstQuote[0].Syncing__c;
                    if(lstQuote[0].Quote_Sale_Price__c != null) objInvoice.Sale_Price__c = lstQuote[0].Quote_Sale_Price__c;
                    if(lstQuote[0].Total_Price_Quote__c != null) objInvoice.Total_Price__c = lstQuote[0].Total_Price_Quote__c;
                    if(lstQuote[0].State__c != null) objInvoice.State_Province__c = lstQuote[0].State__c;
                    if(lstQuote[0].State__c != null) objInvoice.State__c = lstQuote[0].State__c;
                    //if(lstQuote[0].Boat_Sales_Tax__c != null) objInvoice.Boat_Sales_Tax__c = lstQuote[0].Boat_Sales_Tax__c;
                    
                    if(lstQuote[0].BOATBUILDING__Manufacturer_Invoice__c != null) objInvoice.BOATBUILDING__Manufacture_Invoice2__c = lstQuote[0].BOATBUILDING__Manufacturer_Invoice__c;
                    
                    //***Product Details***
                    if(lstQuote[0].Mapped_Engine_SN__c != null) objInvoice.Engine_SN__c = lstQuote[0].Mapped_Engine_SN__c;
                    if(lstQuote[0].Mapped_HIN__c != null) objInvoice.HIN_No__c = lstQuote[0].Mapped_HIN__c;
                    if(lstQuote[0].Mapped_Trailer_VIN__c != null) objInvoice.Trailer_VIN__c = lstQuote[0].Mapped_Trailer_VIN__c;
                    if(lstQuote[0].Transmission_Gearbox_SN__c != null) objInvoice.Transmission_Gearbox_SN__c = lstQuote[0].Transmission_Gearbox_SN__c;
                    if(lstQuote[0].Mapped_Boat_Length__c != null) objInvoice.Boat_Length__c = lstQuote[0].Mapped_Boat_Length__c;
                    if(lstQuote[0].BOATBUILDING__Tyre_Tax__c!= null) objInvoice.BOATBUILDING__Tyre_Tax__c = lstQuote[0].BOATBUILDING__Tyre_Tax__c;
                    
                    //***Related Details***
                    if(lstQuote[0].Quote_MSRP_Boat_Price__c != null) objInvoice.MSRP_Boat_Price__c = lstQuote[0].Quote_MSRP_Boat_Price__c;
                    if(lstQuote[0].Quote_Trade_Payoff__c != null) objInvoice.Quote_Trade_Payoff__c = lstQuote[0].Quote_Trade_Payoff__c;
                    if(lstQuote[0].Discount_On_Quote__c != null) objInvoice.Discount_on_Invoice__c = lstQuote[0].Discount_On_Quote__c;
                    if(lstQuote[0].Negotiation_MSRP_Boat_Price__c != null) objInvoice.Negotiated_MSRP_Price__c = lstQuote[0].Negotiation_MSRP_Boat_Price__c;
                    if(lstQuote[0].Quote_Total_MSRP__c != null) objInvoice.Total_MSRP__c = lstQuote[0].Quote_Total_MSRP__c;
                    if(lstQuote[0].Quote_MSRP_Trailer_Price__c != null) objInvoice.MSRP_Trailer_Price__c = lstQuote[0].Quote_MSRP_Trailer_Price__c;
                    if(lstQuote[0].Quote_Rate__c != null) objInvoice.Invoice_Rate__c = lstQuote[0].Quote_Rate__c;
                    if(lstQuote[0].Quote_Trade_Allowance__c != null) objInvoice.Trade_Allowance__c = lstQuote[0].Quote_Trade_Allowance__c;
                    if(lstQuote[0].Quote_Term__c != null) objInvoice.Term__c = lstQuote[0].Quote_Term__c;
                    if(lstQuote[0].Quote_Trailer_Allowance__c != null) objInvoice.Trailer_Allowance__c = lstQuote[0].Quote_Trailer_Allowance__c;
                    if(lstQuote[0].Quote_Trailer_ACV__c != null) objInvoice.Trailer_ACV__c = lstQuote[0].Quote_Trailer_ACV__c;
                    if(lstQuote[0].Quote_Trailer_Sales_Tax__c != null) objInvoice.Trailer_Sales_Tax__c = lstQuote[0].Quote_Trailer_Sales_Tax__c;
                    if(lstQuote[0].Quote_Boat_Reg_Fee__c != null) objInvoice.Boat_Reg_Fee__c = lstQuote[0].Quote_Boat_Reg_Fee__c;
                    if(lstQuote[0].Quote_Trailer_Reg_Fee__c != null) objInvoice.Trailer_Reg_Fee__c = lstQuote[0].Quote_Trailer_Reg_Fee__c;
                    if(lstQuote[0].Quote_Doc_Fee__c != null) objInvoice.Doc_Fee__c = lstQuote[0].Quote_Doc_Fee__c;
                    if(lstQuote[0].Quote_Payment__c != null) objInvoice.Sold_Boat_Payment__c = lstQuote[0].Quote_Payment__c;
                    if(lstQuote[0].Quote_Deal_Margin__c != null) objInvoice.Deal_Margin__c = lstQuote[0].Quote_Deal_Margin__c;
                    
                    objInvoice.Quote__c = lstQuote[0].Id; 
                    
                    if(lstQuote[0].Store_Location__c != null) objInvoice.Store_Location__c = lstQuote[0].Store_Location__c;
                    objInvoice.BOATBUILDING__Sold_Date__c = Date.today();
                    
                    List<BOATBUILDING__Inventory__c> lstInventory = [SELECT Id, Stage__c,  Quantity__c,
                                                                     Name, Model__c, Year__c, HIN_Number__c, BOATBUILDING__Serial_Number_2__c, BOATBUILDING__Manufacturer__c,
                                                                     BOATBUILDING__Beam__c, BOATBUILDING__Boat_Draft__c, BOATBUILDING__Boat_Length_in_feets__c, BOATBUILDING__Boat_Seating_Capacity__c,
                                                                     BOATBUILDING__Engine_Model__c, BOATBUILDING__Engine_SN__c, BOATBUILDING__Engine_Year__c,BOATBUILDING__Weight__c,
                                                                     BOATBUILDING__Model_Variant__c, Trailer_VIN__c, Trailer_Year__c, Trailer_Make__c, Trailer_Model__c, Trailer_Axles__c
                                                                     FROM BOATBUILDING__Inventory__c WHERE Id =: lstQuote[0].Test_2__c LIMIT 1];
                    
                    List<BOATBUILDING__Item__c> listItem = [SELECT Id, BOATBUILDING__Boat_HIN_No__c FROM BOATBUILDING__Item__c 
                                                            WHERE BOATBUILDING__Boat_HIN_No__c =: lstInventory[0].HIN_Number__c];
                                                            
                    if(lstInventory[0].Quantity__c != null && lstInventory[0].Quantity__c > 0) {    
                        lstInventory[0].Quantity__c = Integer.valueOf(lstInventory[0].Quantity__c) - 1;
                        if(lstInventory[0].Quantity__c  == 0) {
                            lstInventory[0].Stage__c = 'Sold';
                        }
                        //***Insert Invoice***
                        
                            
                            BOATBUILDING__System_Configure__c objSG = BOATBUILDING__System_Configure__c.getOrgDefaults();
                            Set<String> setStr = new Set<String>(); 
                            if(objSG != null) {
                                if(objSG.BOATBUILDING__Additional_Rolls_For_Sold_Boat_Invoice__c != null) {
                                    if(objSG.BOATBUILDING__Additional_Rolls_For_Sold_Boat_Invoice__c.contains(',')) {
                                        String [] strSplt = objSG.BOATBUILDING__Additional_Rolls_For_Sold_Boat_Invoice__c.split(',');
                                        for(String str: strSplt) {
                                            setStr.add(str);
                                        }
                                    } else {
                                        setStr.add(objSG.BOATBUILDING__Additional_Rolls_For_Sold_Boat_Invoice__c);
                                    }
                                }
                            }
                            User u = [Select u.UserRole.Name From User u Where Id =: UserInfo.getUserId()];
                            
                            if(u.UserRole != null && (u.UserRole.Name == 'GM' || u.UserRole.Name == 'Accounting' || setStr.contains(u.UserRole.Name))) {
                                insert objInvoice;
                                if( lstQuote[0].BOATBUILDING__Payment__r != null && !lstQuote[0].BOATBUILDING__Payment__r.isEmpty()) {
                                    List<BOATBUILDING__Payment__c> lstPayment = new List<BOATBUILDING__Payment__c>();
                                    for(BOATBUILDING__All_Payment__c objPayment: lstQuote[0].BOATBUILDING__Payment__r) {
                                        BOATBUILDING__Payment__c objPay = new BOATBUILDING__Payment__c();
                                        objPay.Name = objPayment.Name;
                                        objPay.Amount__c = objPayment.Amount__c;
                                        objPay.Check_Number__c = objPayment.Check_Number__c;
                                        objPay.Credit_Card_Type__c = objPayment.Credit_Card_Type__c;
                                        objPay.Payment_Type__c = objPayment.Payment_Type__c;
                                        objPay.Store_Location__c = objPayment.Store_Location__c;
                                        objPay.Related_to_Invoice__c = objInvoice.Id;
                                        lstPayment.add(objPay);
                                    }
                                    insert lstPayment;  
                                
                                }
                                
                                if(listItem.isEmpty()){
                                        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
                                        if(String.isNotBlank(lstInventory[0].BOATBUILDING__Manufacturer__c)){
                                            List<BOATBUILDING__Manufacturer__c> listManufacturer = [SELECT Id, Name FROM BOATBUILDING__Manufacturer__c WHERE Name =: lstInventory[0].BOATBUILDING__Manufacturer__c LIMIT 1];
                                            if(!listManufacturer.isEmpty()){
                                                objItem.BOATBUILDING__Boat_Manufacturer__c = listManufacturer[0].Id;
                                            }
                                        }
                                        objItem.BOATBUILDING__Boat_Model__c = lstInventory[0].Model__c;
                                        objItem.BOATBUILDING__M_Boat_Year__c = lstInventory[0].Year__c;
                                        objItem.BOATBUILDING__Boat_HIN_No__c = lstInventory[0].HIN_Number__c;
                                        objItem.BOATBUILDING__Boat_Serial_Number__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Serial_Number_2__c)?lstInventory[0].BOATBUILDING__Serial_Number_2__c:'';
                                        objItem.BOATBUILDING__Boat_Model_Variant__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Model_Variant__c)?lstInventory[0].BOATBUILDING__Model_Variant__c:'';
                                        objItem.BOATBUILDING__Boat_Weight_in_lbs__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Weight__c)?Decimal.valueOf(lstInventory[0].BOATBUILDING__Weight__c):0;
                                        objItem.BOATBUILDING__Boat_Beam_in_Feets__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Beam__c)?Decimal.valueOf(lstInventory[0].BOATBUILDING__Beam__c):0;
                                        objItem.BOATBUILDING__Boat_Draft_in_Feets__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Boat_Draft__c)?Decimal.valueOf(lstInventory[0].BOATBUILDING__Boat_Draft__c):0;
                                        objItem.BOATBUILDING__Boat_Person_Capacity__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Boat_Seating_Capacity__c)?Decimal.valueOf(lstInventory[0].BOATBUILDING__Boat_Seating_Capacity__c):0;
                                        objItem.BOATBUILDING__Boat_Length_in_Feets__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Boat_Length_in_feets__c)?lstInventory[0].BOATBUILDING__Boat_Length_in_feets__c:'';
                                        objItem.BOATBUILDING__Engine_Model__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Engine_Model__c)?lstInventory[0].BOATBUILDING__Engine_Model__c:'';
                                        objItem.BOATBUILDING__Engine_SN__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Engine_SN__c)?lstInventory[0].BOATBUILDING__Engine_SN__c:'';
                                        objItem.BOATBUILDING__Engine_Year__c = String.isNOTBlank(lstInventory[0].BOATBUILDING__Engine_Year__c)?lstInventory[0].BOATBUILDING__Engine_Year__c:'';
                                        objItem.Trailer_VIN__c = String.isNOTBlank(lstInventory[0].Trailer_VIN__c)?lstInventory[0].Trailer_VIN__c:'';
                                        objItem.Trailer_Year__c = String.isNOTBlank(lstInventory[0].Trailer_Year__c)?lstInventory[0].Trailer_Year__c:'';
                                        if(lstInventory[0].Trailer_Make__c != null) {
                                            List<BOATBUILDING__Manufacturer__c> lstManu = [Select Id, Name from BOATBUILDING__Manufacturer__c where Name =: lstInventory[0].Trailer_Make__c Limit 1];
                                            if(!lstManu.isEmpty()) {
                                                objItem.Trailer_Manufacturer__c = lstManu[0].Id;        
                                            }
                                            
                                        }
                                        objItem.Trailer_Model__c = String.isNOTBlank(lstInventory[0].Trailer_Model__c)?lstInventory[0].Trailer_Model__c:'';
                                        
                                        insert objItem;
                                        System.debug('--objItem--'+objItem);
                                    }
                                
                                update lstInventory;
                            } else {
                                //SendEmailUtility.sendQuickEmail('Not GM Or Accounting');
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Not GM Or Accounting.'));
                                return new PageReference('/'+lstQuote[0].Id);
                            }
                        
                        
                        
                        List<RecordType> lstNewRecTypeQuote = [SELECT
                                                                   Id,
                                                                   Name
                                                                   FROM
                                                                   RecordType
                                                                   WHERE
                                                                   SobjectType = 'BOATBUILDING__Quote__c'
                                                                   AND
                                                                   DeveloperName = 'Locked'
                                                                   LIMIT
                                                                   1];
                        
                        if(lstNewRecTypeQuote.size() > 0) {
                            lstQuote[0].RecordTypeId = lstNewRecTypeQuote[0].Id;
                            
                                update lstQuote;
                            
                        }
                        if(objInvoice.Id != null) {
                            return new PageReference('/'+objInvoice.Id);
                        }
                    } else {
                        isQuantityNotUpdated = true;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Inventory Quantity Is Not Updated. Please Update.'));
                        return null;
                    }
                } else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select inventory.'));
                        return null;
                } 
            } 
            return new PageReference('/'+lstQuote[0].Id); 
        } catch(Exception ex) {
            System.debug('Debug Log For Exception : '+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage() +'  :  '+ex.getLineNumber()));
            SendEmailUtility.sendQuickEmail(ex.getMessage() +'  :  '+ex.getLineNumber());
            return new PageReference('/'+lstQuote[0].Id);
        }
    }
}