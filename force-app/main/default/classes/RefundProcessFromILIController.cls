/**
  * Author       : Akshay Kumar
  * Organization : 360 Degree Cloud Techonologies Pvt. Ltd.
  * Date         : 19/01/2017   
*/
public with sharing class RefundProcessFromILIController {
    public Invoice_Line_Item__c objILI { get; set; }
    
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public RefundProcessFromILIController() {
         if(ApexPages.currentPage().getParameters().get('Id') != null) {
             objILI = [SELECT
                                Id,
                                Name,
                                Dealer_Price__c,
                                Description__c,
                                Discount_Price__c,
                                Grand_Total__c,
                                MSRP__c,
                                Part_Cost__c,
                                Part_Number__c,
                                Part_Vendor__c,
                                Part_Vendor__r.Name,
                                Quantity__c,
                                Refunded__c,
                                Refunded_Amount__c,
                                Taxable__c,
                                Total_Price__c,
                                Weight__c
                       FROM
                                Invoice_Line_Item__c
                       WHERE
                                Id =: ApexPages.currentPage().getParameters().get('Id')];
                                         }
         else {
             objILI = new Invoice_Line_Item__c();
         }
    }
    
    @RemoteAction
    public static String refundInvoiceLineItem(String strILIId, String strRefundAmount) {
        List<Invoice_Line_Item__c> lstILIChange = [SELECT  
                                                            Part_Number__c,
                                                            Quantity__c,
                                                            Refunded__c,
                                                            Refunded_Amount__c
                                                     FROM
                                                            Invoice_Line_Item__c
                                                     WHERE
                                                            Id =: strILIId 
                                                     LIMIT 
                                                             1];
        if(lstILIChange.size() > 0) {
            lstILIChange[0].Refunded__c = true;
            lstILIChange[0].Refunded_Amount__c = Decimal.valueOf(strRefundAmount);
            List<Inventory__c> lstInvPart = [Select 
                                                       Id,
                                                       Part_Number__c,
                                                       Quantity__c
                                              From
                                                       Inventory__c
                                              Where 
                                                       Part_Number__c =: lstILIChange[0].Part_Number__c
                                              LIMIT 
                                                       1];
           if(lstInvPart.size() > 0 && lstInvPart[0].Quantity__c != null && lstILIChange[0].Quantity__c != null) { 
               lstInvPart[0].Quantity__c += lstILIChange[0].Quantity__c;
               try {
                   update lstInvPart;
               }
               catch(Exception ex) {
                   System.debug('Debug Log For Exception: '+ex);
               }
           }
           try {
               update lstILIChange;
           }
           catch(Exception ex) {
               System.debug('Debug Log For Exception: '+ex);
           } 
           
           return 'SUCCESS';
        }
        else {
            return null;
        }
    }
}