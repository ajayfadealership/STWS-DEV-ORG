public with sharing class CalculatePriceOnInvoiceTriggerHandler {
    public static void onInsert(List<Invoice_Line_Item__c> lstILItems){
        String strRecTypeInvoice;
        String mailingState;
        Set<Id> setInvoiceId = new Set<Id>();
        
        List<Invoice_Line_Item__c> lstCriteriaILI = [SELECT
                                                        
                                                        Related_To_Invoice__r.Id
                                                FROM    
                                                        Invoice_Line_Item__c
                                                WHERE   
                                                        Id IN : lstILItems
                                            ];
        
        for(Invoice_Line_Item__c objILItem : lstCriteriaILI) {
            setInvoiceId.add(objILItem.Related_To_Invoice__r.Id);
        }
        
        System.debug('Debug Log for setInvoiceId size'+setInvoiceId.size());
        System.debug('Debug Log for setInvoiceId'+setInvoiceId);
        
        
        
        List<RecordType> lstRecTypeInventory = [SELECT
                                                            Id
                                                    FROM
                                                            RecordType
                                                    WHERE
                                                            SobjectType = 'Invoice__c'
                                                    AND
                                                            DeveloperName = 'Standard_Invoice'
                                                    LIMIT
                                                            1];
                                                            
        if(lstRecTypeInventory.size()>0) {
            strRecTypeInvoice = lstRecTypeInventory[0].Id;
        }
                           
        List<Invoice__c> lstCriteriaInvoice = [SELECT
                                                        Id,
                                                        Name,
                                                        Related_to_Contact__r.MailingState,
                                                        Total_Amount_on_Invoice__c,
                                                        Sales_Tax_Formula__c,
                                                        Sales_Tax_Percent__c,
                                                        Refunded__c,
                                                        Refunded_Amount__c,
                                                                    (SELECT
                                                                            Id,
                                                                            Name,
                                                                            Related_To_Invoice__c,
                                                                            Grand_Total__c,
                                                                            Taxable__c,
                                                                            Quantity__c,
                                                                            Refunded__c,
                                                                            Refunded_Amount__c
                                                                    FROM
                                                                            Invoice_Line_Items__r
                                                                    )
                                                FROM
                                                        Invoice__c
                                                WHERE
                                                       RecordTypeId =: strRecTypeInvoice
                                                AND
                                                        Id IN : setInvoiceId
                                                ];
        System.debug('Debug log for lstCriteriaInvoice'+lstCriteriaInvoice.size());
        
        for(Invoice__c objInv : lstCriteriaInvoice) {
            Decimal paramforPrice = 0.00;
            Decimal countRefundedItems = 0.00;
            Decimal refundedAmount = 0.00;
            Decimal stateTaxPercent = objInv.Sales_Tax_Percent__c;
            
            System.debug('Debug Log for InvoiceLineItems size' +objInv.Invoice_Line_Items__r.size());
            if(objInv.Invoice_Line_Items__r.size()>0) {
                for(Invoice_Line_Item__c objILI : objInv.Invoice_Line_Items__r) {
                   
                    if(objILI.Refunded__c ==true)
                    {
                        countRefundedItems += 1;
                        if(objILI.Refunded_Amount__c !=null) {
                            refundedAmount += objILI.Refunded_Amount__c;
                        }
                        
                        
                    }
               }
               if(countRefundedItems == objInv.Invoice_Line_Items__r.size()) {
                    objInv.Refunded__c = true;
                    objInv.Refunded_Amount__c = refundedAmount;
               }
               else if(countRefundedItems != objInv.Invoice_Line_Items__r.size() || objInv.Invoice_Line_Items__r.size() == 0){
                    objInv.Refunded__c = false;
                    objInv.Refunded_Amount__c = 0.00;
               }
            }
        }
        update lstCriteriaInvoice;
    }


    public static void onUpdate(List<Invoice_Line_Item__c> lstILItems){
            String strRecTypeInvoice;
            String mailingState;
            Set<Id> setInvoiceId = new Set<Id>();
        
            List<Invoice_Line_Item__c> lstCriteriaILI = [SELECT
                                                            
                                                            Related_To_Invoice__r.Id
                                                    FROM    
                                                            Invoice_Line_Item__c
                                                    WHERE   
                                                            Id IN : lstILItems
                                                ];
            
            for(Invoice_Line_Item__c objILItem : lstCriteriaILI) {
                setInvoiceId.add(objILItem.Related_To_Invoice__r.Id);
            }
            
            System.debug('Debug Log for setInvoiceId size'+setInvoiceId.size());
            System.debug('Debug Log for setInvoiceId'+setInvoiceId);
            
            List<RecordType> lstRecTypeInventory = [SELECT
                                                                Id
                                                        FROM
                                                                RecordType
                                                        WHERE
                                                                SobjectType = 'Invoice__c'
                                                        AND
                                                                DeveloperName = 'Standard_Invoice'
                                                        LIMIT
                                                                1];
                                                                
            if(lstRecTypeInventory.size()>0) {
                strRecTypeInvoice = lstRecTypeInventory[0].Id;
            }
            

                                                
            List<Invoice__c> lstCriteriaInvoice = [SELECT
                                                            Id,
                                                            Name,
                                                            Related_to_Contact__r.MailingState,
                                                            Total_Amount_on_Invoice__c,
                                                            Sales_Tax_Formula__c,
                                                            Sales_Tax_Percent__c,
                                                            Refunded__c,
                                                            Refunded_Amount__c,
                                                            
                                                                        (SELECT
                                                                                Id,
                                                                                Name,
                                                                                Related_To_Invoice__c,
                                                                                Grand_Total__c,
                                                                                Taxable__c,
                                                                                Quantity__c,
                                                                                Refunded__c,
                                                                                Refunded_Amount__c
                                                                                
                                                                        FROM
                                                                                Invoice_Line_Items__r
                                                                        )
                                                    FROM
                                                            Invoice__c
                                                    WHERE
                                                           RecordTypeId =: strRecTypeInvoice
                                                    AND
                                                            Id IN : setInvoiceId
                                                    ];
            System.debug('Debug log for lstCriteriaInvoice'+lstCriteriaInvoice.size());
            
            for(Invoice__c objInv : lstCriteriaInvoice) {
                Decimal paramforPrice = 0.00;
                Decimal countRefundedItems = 0.00;
                Decimal refundedAmount = 0.00;
                Decimal stateTaxPercent = objInv.Sales_Tax_Percent__c;
                
                
                System.debug('Debug Log for InvoiceLineItems size' +objInv.Invoice_Line_Items__r.size());
                if(objInv.Invoice_Line_Items__r.size()>0) {
                    for(Invoice_Line_Item__c objILI : objInv.Invoice_Line_Items__r) {
                       
                       if(objILI.Refunded__c ==true) {
                            countRefundedItems += 1;
                            if(objILI.Refunded_Amount__c !=null) {
                                refundedAmount += objILI.Refunded_Amount__c;
                            }
                        }
                        
                   }
                   if(countRefundedItems == objInv.Invoice_Line_Items__r.size()) {
                        objInv.Refunded__c = true;
                        objInv.Refunded_Amount__c = refundedAmount;
                    }
                    else if(countRefundedItems != objInv.Invoice_Line_Items__r.size() || objInv.Invoice_Line_Items__r.size() == 0){
                        objInv.Refunded__c = false;
                        objInv.Refunded_Amount__c = 0.00;
                    }
                }
            }
            update lstCriteriaInvoice;
        }
        
        public static void onDelete(List<Invoice_Line_Item__c> lstILItems){
            String strRecTypeInvoice;
            String mailingState;
            Set<Id> setInvoiceId = new Set<Id>();
            
           
            List<Invoice_Line_Item__c> lstLeftOverLineItems = [SELECT
                                                            
                                                                        Id
                                                                FROM    
                                                                        Invoice_Line_Item__c
                                                                WHERE   
                                                                        Id != null
                                                                
                                                            
                                                               ];
            System.debug('Debug Log for Trigger.old size'+lstILItems.size());
            System.debug('Debug Log for Trigger.new size'+lstLeftOverLineItems.size());
            System.debug('Debug Log for Trigger.old'+lstILItems);
            System.debug('Debug Log for Trigger.new'+lstLeftOverLineItems);
            List<Invoice_Line_Item__c> lstCriteriaILI = [SELECT
                                                                    Id,
                                                                    Related_To_Invoice__r.Id
                                                        FROM    
                                                                    Invoice_Line_Item__c
                                                        WHERE   
                                                                    Id IN : lstILItems
                                                        AND
                                                                    Id NOT IN : lstLeftOverLineItems
                                                        ALL ROWS
                                                               
                                                        ];
            
            for(Invoice_Line_Item__c objILItem : lstCriteriaILI) {
                setInvoiceId.add(objILItem.Related_To_Invoice__r.Id);
            }
            
            System.debug('Debug Log for setInvoiceId size'+setInvoiceId.size());
            System.debug('Debug Log for setInvoiceId'+setInvoiceId);
            
            List<RecordType> lstRecTypeInventory = [SELECT
                                                                Id
                                                        FROM
                                                                RecordType
                                                        WHERE
                                                                SobjectType = 'Invoice__c'
                                                        AND
                                                                DeveloperName = 'Standard_Invoice'
                                                        LIMIT
                                                                1];
                                                                
            if(lstRecTypeInventory.size()>0) {
                strRecTypeInvoice = lstRecTypeInventory[0].Id;
            }
                                                            
            List<Invoice__c> lstCriteriaInvoice = [SELECT
                                                            Id,
                                                            Name,
                                                            Related_to_Contact__r.MailingState,
                                                            Total_Amount_on_Invoice__c,
                                                            Sales_Tax_Formula__c,
                                                            Sales_Tax_Percent__c,
                                                            Refunded__c,
                                                            Refunded_Amount__c,
                                                                        (SELECT
                                                                                Id,
                                                                                Name,
                                                                                Related_To_Invoice__c,
                                                                                Grand_Total__c,
                                                                                Taxable__c,
                                                                                Quantity__c,
                                                                                Refunded__c,
                                                                                Refunded_Amount__c
                                                                        FROM
                                                                                Invoice_Line_Items__r
                                                                        )
                                                    FROM
                                                            Invoice__c
                                                    WHERE
                                                           RecordTypeId =: strRecTypeInvoice
                                                    AND
                                                            Id IN : setInvoiceId
                                                    ];
            System.debug('Debug log for lstCriteriaInvoice'+lstCriteriaInvoice.size());
            
            for(Invoice__c objInv : lstCriteriaInvoice) {
                Decimal paramforPrice = 0.00;
                Decimal countRefundedItems = 0.00;
                Decimal refundedAmount = 0.00;
                Decimal stateTaxPercent = objInv.Sales_Tax_Percent__c;
                
               
                System.debug('Debug Log for InvoiceLineItems size' +objInv.Invoice_Line_Items__r.size());
                if(objInv.Invoice_Line_Items__r.size()>0) {
                    for(Invoice_Line_Item__c objILI : objInv.Invoice_Line_Items__r) {
                       
                       if(objILI.Refunded__c ==true) {
                            countRefundedItems += 1;
                            if(objILI.Refunded_Amount__c !=null) {
                                refundedAmount += objILI.Refunded_Amount__c;
                            }
                        }
                   }
                   if(countRefundedItems == objInv.Invoice_Line_Items__r.size() && objInv.Invoice_Line_Items__r.size() != 0) {
                        objInv.Refunded__c = true;
                        objInv.Refunded_Amount__c = refundedAmount;
                    }
                    else if(countRefundedItems != objInv.Invoice_Line_Items__r.size() || objInv.Invoice_Line_Items__r.size() == 0){
                        objInv.Refunded__c = false;
                        objInv.Refunded_Amount__c = 0.00;
                    }
                }
                else {
                    objInv.Refunded__c = false;
                    objInv.Refunded_Amount__c = 0.00;
                }
            }
            update lstCriteriaInvoice;
        }
}