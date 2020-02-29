/**
  * Author       : Akshay Kumar
  * Organization : 360 Degree Cloud Techonologies Pvt. Ltd.
  * Date         : 18/01/2017   
*/
public with sharing class RefundProcessController {
    public Invoice__c objInvoice { get; set; }
    public Decimal totalPrice { get; set; }
    public Decimal discountPrice { get; set; }
    public Decimal GrandTotalPrice { get; set; }
    
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }    
    
    public RefundProcessController() {
        totalPrice = 0.00;
        discountPrice = 0.00;
        GrandTotalPrice = 0.00;
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            objInvoice = [SELECT 
                                    Id,
                                    Name,
                                    Customer_Name__c,
                                    Phone_Number__c,
                                    Email__c,
                                    Customer_Address__c,
                                    Billing_State_Province__c ,
                                    City__c,
                                    State__c,
                                    Zip_Code__c,
                                    Payment__c,
                                    Sum_Discount_Availed_on_Line_Items__c,
                                    Sum_Price_Line_Items__c
                                    
                          FROM
                                    Invoice__c
                          WHERE
                                    Id =: ApexPages.currentPage().getParameters().get('Id')];
        }
        else {
            objInvoice = new Invoice__c();
        }
    }
    
    public List<Invoice_Line_Item__c> getLstInvoiceLineItems() {
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            List<Invoice_Line_Item__c> lstILI = [SELECT 
                                                        Name,
                                                        Description__c,
                                                        Discount_Price__c,
                                                        Grand_Total__c,
                                                        MSRP__c,
                                                        Part_Cost__c,
                                                        Part_Number__c,
                                                        Part_Vendor__c,
                                                        Quantity__c,
                                                        Related_To_Invoice__c,
                                                        Taxable__c,
                                                        Total_Price__c,
                                                        Weight__c
                                                FROM
                                                        Invoice_Line_Item__c
                                                WHERE
                                                        Related_To_Invoice__c = : ApexPages.currentPage().getParameters().get('Id')
                                                AND
                                                        Refunded__c = false];
                            
            if(lstILI.size() > 0) {
                for(Invoice_Line_Item__c objILI: lstILI) {
                    if(objILI.Total_Price__c!= null) {
                        totalPrice += objILI.Total_Price__c;
                    }
                    if(objILI.Discount_Price__c != null) {
                        discountPrice += objILI.Discount_Price__c;
                    }
                    if(objILI.Grand_Total__c != null) {
                        GrandTotalPrice += objILI.Grand_Total__c;
                    }
                }
                return lstILI;                      
            }
            else {
                return null;
            }
        }
        else {
            return null;
        }
    }
    
    @RemoteAction
    public static String refundInvoice(String strInvoiceId, String strRefundedAmount) {
        List<Invoice__c> lstInvoice = [SELECT Id, Refunded__c, Refunded_Amount__c, (SELECT Id, Part_Number__c, Quantity__c, Refunded__c From Invoice_Line_Items__r Where Refunded__c = false) From Invoice__c WHERE id =: strInvoiceId LIMIT 1];
        Boolean isError = false;
        if(lstInvoice.size() > 0) {
            lstInvoice[0].Refunded__c = true;
            lstInvoice[0].Refunded_Amount__c = Decimal.valueOf(strRefundedAmount);
            Map<String, Integer> mapILIPnameQntity = new Map<String, Integer>();
            if(lstInvoice[0].Invoice_Line_Items__r != null && lstInvoice[0].Invoice_Line_Items__r.size() > 0) {
                for(Invoice_Line_Item__c objILI: lstInvoice[0].Invoice_Line_Items__r) {
                    objILI.Refunded__c = true;
                    if(objILI.Quantity__c != null && objILI.Quantity__c > 0) {
                        if(mapILIPnameQntity.containsKey(objILI.Part_Number__c)) {
                            mapILIPnameQntity.put(objILI.Part_Number__c, Integer.valueOf(mapILIPnameQntity.get(objILI.Part_Number__c)+objILI.Quantity__c));
                        }else {
                            mapILIPnameQntity.put(objILI.Part_Number__c, Integer.valueOf(objILI.Quantity__c));
                        }
                    }
                }
                List<Inventory__c> lstInventory = [Select Part_Number__c, Quantity__c From Inventory__c Where Part_Number__c IN: mapILIPnameQntity.keySet()];
                for(Inventory__c objInventory: lstInventory) {
                    if(objInventory.Quantity__c != null) {
                        objInventory.Quantity__c += mapILIPnameQntity.get(objInventory.Part_Number__c);
                    }
                }
                
                try {
                    update lstInvoice[0].Invoice_Line_Items__r;
                }catch(Exception ex) {
                    isError = true;
                    System.debug('Debug Log For Eception: '+ex);
                }
                
                try {
                    update lstInventory;
                }catch(Exception ex) {
                    isError = true;
                    System.debug('Debug Log For Eception: '+ex);
                }
            } 
            try {
                update lstInvoice;
            }catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Eception: '+ex);
            }           
        }
        if(isError) {
            return null;
        }
        else {
            return 'SUCCESS';
        }
    }
}