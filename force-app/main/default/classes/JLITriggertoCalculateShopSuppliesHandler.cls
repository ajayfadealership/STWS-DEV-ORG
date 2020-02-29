public with sharing class JLITriggertoCalculateShopSuppliesHandler{
    public static void onAfterInsert(List<BOATBUILDING__Job_Line_Item__c> lstJLITriggerNew) {
        List<BOATBUILDING__Shop_Supplies__c> lstShopSupplies = new List<BOATBUILDING__Shop_Supplies__c>();
        Set<Id> setJobIDs = new Set<Id>();
        Decimal ShopSuppliesPercent = 0.00;
        Decimal CapAmount = 0.00;
        Map<Decimal,Decimal> mapPercenttoCapAmt = new Map<Decimal,Decimal>();
        lstShopSupplies = [SELECT 
                                    Percentage__c,
                                    Cap_Amount_for_percent__c
                           FROM
                                    BOATBUILDING__Shop_Supplies__c
                                    LIMIT 1
                          ];
        if(lstShopSupplies.size()>0) {
            ShopSuppliesPercent = lstShopSupplies[0].Percentage__c;
            CapAmount = lstShopSupplies[0].Cap_Amount_for_percent__c;
        }


        List<BOATBUILDING__Job_Line_Item__c> fetchCriteriaJLI = [SELECT 
                                                            Related_to_Job__r.Id
                                                   FROM
                                                            BOATBUILDING__Job_Line_Item__c
                                                   WHERE
                                                            Id IN : lstJLITriggerNew
                                                  ];
        if(fetchCriteriaJLI.size() > 0) {
            for(BOATBUILDING__Job_Line_Item__c objJLI : fetchCriteriaJLI){
                setJobIDs.add(objJLI.Related_to_Job__r.Id);
            }
        }

        List<BOATBUILDING__Job__c> lstFetchCriteriaJobs = [SELECT
                                                                Worked_Hours__c, 
                                                                Work_Type__c, 
                                                                Work_Requested__c, 
                                                                Work_Request__c, 
                                                                Unique_Job_id__c, 
                                                                Type__c, 
                                                                Total_Hours_Job__c, 
                                                                Total_Cost_Labor__c, 
                                                                Total_Amount_on_Parts_del__c, 
                                                                Total_Amount_Job__c, 
                                                                TotalPaid1__c, 
                                                                SystemModstamp, 
                                                                Shop_Supplies_Total__c, 
                                                                Return_Parts_Amount__c, 
                                                                RecordTypeId, 
                                                                Price_per_Labor__c, 
                                                                Parts_Paid_Amount__c, 
                                                                No_of_Parts__c, 
                                                                No_of_Labors__c, 
                                                                Name, 
                                                                LastModifiedDate, 
                                                                LastModifiedById, 
                                                                LastActivityDate, 
                                                                Job_Name__c, 
                                                                IsDeleted, 
                                                                Id, 
                                                                Discount__c, 
                                                                Customer_Pay__c, 
                                                                CreatedDate, 
                                                                CreatedById, 
                                                                Comments__c, 
                                                                Claim_Status__c, 
                                                                Claim_Paid_Date__c, 
                                                                Claim_Labor_Paid_Amount__c, 
                                                                Claim_Labor_Approved_Amount__c, 
                                                                Claim_Date__c, 
                                                                Claim_Approval_Date__c, 
                                                                BalanceDue1__c, 
                                                                Approved_By_Customer__c, 
                                                                                        (SELECT 
                                                                                                    Id, 
                                                                                                    IsDeleted, 
                                                                                                    Name, 
                                                                                                    CreatedDate, 
                                                                                                    CreatedById, 
                                                                                                    LastModifiedDate, 
                                                                                                    LastModifiedById, 
                                                                                                    SystemModstamp, 
                                                                                                    LastActivityDate, 
                                                                                                    Part_Name__c, 
                                                                                                    Part_Number__c, 
                                                                                                    Quantity__c, 
                                                                                                    Related_to_Job__c, 
                                                                                                    Price__c, 
                                                                                                    Total__c, 
                                                                                                    Select_Part__c 
                                                                                         From 
                                                                                                    BOATBUILDING__Job_Line_Items__r) 
                                                         FROM 
                                                                BOATBUILDING__Job__c 
                                                         WHERE
                                                                ID IN : setJobIDs
                                            ];
        if(lstFetchCriteriaJobs.size() > 0) {
            Decimal totalJLIPrice = 0.00;
            Decimal sumJLIPriceAndLabor = 0.00;
            Decimal calculatedShopSupplies = 0.00;
            for(BOATBUILDING__Job__c objJob : lstFetchCriteriaJobs) {
                if(objJob.Job_Line_Items__r.size() > 0) {
                    for(BOATBUILDING__Job_Line_Item__c objJLI : objJob.Job_Line_Items__r) {
                        totalJLIPrice += objJLI.Total__c;
                    }
                    System.debug('Debug Log for totalJLIPrice'+totalJLIPrice);
                }

                if(totalJLIPrice != null && objJob.Total_Cost_Labor__c != null) {
                    sumJLIPriceAndLabor += totalJLIPrice + objJob.Total_Cost_Labor__c;
                }
                
                calculatedShopSupplies = sumJLIPriceAndLabor * (ShopSuppliesPercent/100);
                //objJob.Shop_Supplies_Total__c = calculatedShopSupplies <= CapAmount ? calculatedShopSupplies : CapAmount;
                System.debug('Debug Log for sumJLIPriceAndLabor'+sumJLIPriceAndLabor);
            }
            update lstFetchCriteriaJobs;
        }
    }
    
    public static void onAfterDelete(List<BOATBUILDING__Job_Line_Item__c> lstJLITriggerOld) {
        List<BOATBUILDING__Shop_Supplies__c> lstShopSupplies = new List<BOATBUILDING__Shop_Supplies__c>();
        Set<Id> setJobIDs = new Set<Id>();
        Decimal ShopSuppliesPercent = 0.00;
        Decimal CapAmount = 0.00;
        
        lstShopSupplies = [SELECT 
                                    Percentage__c,
                                    Cap_Amount_for_percent__c
                           FROM
                                    BOATBUILDING__Shop_Supplies__c
                                    LIMIT 1
                          ];
        if(lstShopSupplies.size()>0) {
            ShopSuppliesPercent = lstShopSupplies[0].Percentage__c;
            CapAmount = lstShopSupplies[0].Cap_Amount_for_percent__c;
        }

          List<BOATBUILDING__Job_Line_Item__c> lstLeftOverLineItems = [SELECT
                                                            
                                                                        Id
                                                                FROM    
                                                                        BOATBUILDING__Job_Line_Item__c
                                                                WHERE   
                                                                        Id != null
                                                                
                                                               ];
            System.debug('Debug Log for Trigger.old size'+lstJLITriggerOld.size());
            System.debug('Debug Log for Trigger.new size'+lstLeftOverLineItems.size());
            System.debug('Debug Log for Trigger.old'+lstJLITriggerOld);
            System.debug('Debug Log for Trigger.new'+lstLeftOverLineItems);

        List<BOATBUILDING__Job_Line_Item__c> fetchCriteriaJLI = [SELECT 
                                                            Related_to_Job__r.Id
                                                   FROM
                                                            BOATBUILDING__Job_Line_Item__c
                                                   WHERE
                                                            Id IN : lstJLITriggerOld
                                                   AND
                                                            Id NOT IN : lstLeftOverLineItems
                                                            ALL ROWS
                                                  ];
        if(fetchCriteriaJLI.size() > 0) {
            for(BOATBUILDING__Job_Line_Item__c objJLI : fetchCriteriaJLI){
                setJobIDs.add(objJLI.Related_to_Job__r.Id);
            }
        }

        List<BOATBUILDING__Job__c> lstFetchCriteriaJobs = [SELECT
                                                                Worked_Hours__c, 
                                                                Work_Type__c, 
                                                                Work_Requested__c, 
                                                                Work_Request__c, 
                                                                Unique_Job_id__c, 
                                                                Type__c, 
                                                                Total_Hours_Job__c, 
                                                                Total_Cost_Labor__c, 
                                                                Total_Amount_on_Parts_del__c, 
                                                                Total_Amount_Job__c, 
                                                                TotalPaid1__c, 
                                                                SystemModstamp, 
                                                                Shop_Supplies_Total__c, 
                                                                Return_Parts_Amount__c, 
                                                                RecordTypeId, 
                                                                Price_per_Labor__c, 
                                                                Parts_Paid_Amount__c, 
                                                                No_of_Parts__c, 
                                                                No_of_Labors__c, 
                                                                Name, 
                                                                LastModifiedDate, 
                                                                LastModifiedById, 
                                                                LastActivityDate, 
                                                                Job_Name__c, 
                                                                IsDeleted, 
                                                                Id, 
                                                                Discount__c, 
                                                                Customer_Pay__c, 
                                                                CreatedDate, 
                                                                CreatedById, 
                                                                Comments__c, 
                                                                Claim_Status__c, 
                                                                Claim_Paid_Date__c, 
                                                                Claim_Labor_Paid_Amount__c, 
                                                                Claim_Labor_Approved_Amount__c, 
                                                                Claim_Date__c, 
                                                                Claim_Approval_Date__c, 
                                                                BalanceDue1__c, 
                                                                Approved_By_Customer__c, 
                                                                                        (SELECT 
                                                                                                    Id, 
                                                                                                    IsDeleted, 
                                                                                                    Name, 
                                                                                                    CreatedDate, 
                                                                                                    CreatedById, 
                                                                                                    LastModifiedDate, 
                                                                                                    LastModifiedById, 
                                                                                                    SystemModstamp, 
                                                                                                    LastActivityDate, 
                                                                                                    Part_Name__c, 
                                                                                                    Part_Number__c, 
                                                                                                    Quantity__c, 
                                                                                                    Related_to_Job__c, 
                                                                                                    Price__c, 
                                                                                                    Total__c, 
                                                                                                    Select_Part__c 
                                                                                         From 
                                                                                                    Job_Line_Items__r) 
                                                         FROM 
                                                                BOATBUILDING__Job__c 
                                                         WHERE
                                                                ID IN : setJobIDs
                                            ];
        if(lstFetchCriteriaJobs.size() > 0) {
            Decimal totalJLIPrice = 0.00;
            Decimal sumJLIPriceAndLabor = 0.00;
            Decimal calculatedShopSupplies = 0.00;
            for(BOATBUILDING__Job__c objJob : lstFetchCriteriaJobs) {
                if(objJob.Job_Line_Items__r.size() > 0) {
                    for(BOATBUILDING__Job_Line_Item__c objJLI : objJob.Job_Line_Items__r) {
                        totalJLIPrice += objJLI.Total__c;
                    }
                    System.debug('Debug Log for totalJLIPrice'+totalJLIPrice);
                }

                if(totalJLIPrice != null && objJob.Total_Cost_Labor__c != null) {
                    sumJLIPriceAndLabor += totalJLIPrice + objJob.Total_Cost_Labor__c;
                }
                
                calculatedShopSupplies = sumJLIPriceAndLabor * (ShopSuppliesPercent/100);
                //objJob.Shop_Supplies_Total__c = calculatedShopSupplies <= CapAmount ? calculatedShopSupplies : CapAmount;
                System.debug('Debug Log for sumJLIPriceAndLabor'+sumJLIPriceAndLabor);
            }
            update lstFetchCriteriaJobs;
        }
    }
    
}