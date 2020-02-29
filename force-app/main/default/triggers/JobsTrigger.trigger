trigger JobsTrigger on BOATBUILDING__Job__c(after insert, after update, after delete) {
    /*
    if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
    
        // for BOATBUILDING__Total_Amount_on_Parts_del__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Amount_on_Parts_del__c', 'BOATBUILDING__Total_Parts__c')};
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions1, trigger.new,'BOATBUILDING__Job__c', 'BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
        
        // for BOATBUILDING__Total_Cost_Labor__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions2 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Cost_Labor__c', 'BOATBUILDING__Total_Labor__c')};
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions2, trigger.new,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c', 'BOATBUILDING__Work_Order__c','');
        
        // for BOATBUILDING__Discount__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions3 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Discount__c', 'BOATBUILDING__Discount_on_Jobs__c')};
          RollUpSummaryUtility.rollUpTrigger(fieldDefinitions3, trigger.new,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
                                                                          
        // for BOATBUILDING__Shop_Supplies_Total__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions4 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Shop_Supplies_Total__c', 'BOATBUILDING__Total_Shop_Supplies__c')};
          RollUpSummaryUtility.rollUpTrigger(fieldDefinitions4, trigger.new,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
                                                                          
        // for BOATBUILDING__Customer_Pay__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions5 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Amount_Job__c', 'BOATBUILDING__Total_Payment_job__c')};
          RollUpSummaryUtility.rollUpTrigger(fieldDefinitions5, trigger.new,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
    }   
    
    if(trigger.isDelete){
         
        // for BOATBUILDING__Total_Amount_on_Parts_del__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Amount_on_Parts_del__c', 'BOATBUILDING__Total_Parts__c')};
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions1, trigger.old,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
        
        // for BOATBUILDING__Total_Cost_Labor__c Rollup                                                  
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions2 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Cost_Labor__c', 'BOATBUILDING__Total_Labor__c')};
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions2, trigger.old,'BOATBUILDING__Job__c','BOATBUILDING__Work_Order_Warranty_Work_Order__c','BOATBUILDING__Work_Order__c','');
        
        // for BOATBUILDING__Discount__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions3 = new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Discount__c', 'BOATBUILDING__Discount_on_Jobs__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions3, trigger.old,'BOATBUILDING__Job__c',
                                                                            'BOATBUILDING__Work_Order_Warranty_Work_Order__c',
                                                                            'BOATBUILDING__Work_Order__c','');
                                                                            
        // for BOATBUILDING__Shop_Supplies_Total__c Rollup
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions4 = new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Shop_Supplies_Total__c', 'BOATBUILDING__Total_Shop_Supplies__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions4, trigger.old,'BOATBUILDING__Job__c',
                                                                            'BOATBUILDING__Work_Order_Warranty_Work_Order__c',
                                                                            'BOATBUILDING__Work_Order__c','');
                                                                            
        // for BOATBUILDING__Customer_Pay__c Rollup
         list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions5 = new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Total_Amount_Job__c', 'BOATBUILDING__Total_Payment_job__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions5, trigger.old,'BOATBUILDING__Job__c',
                                                                            'BOATBUILDING__Work_Order_Warranty_Work_Order__c',
                                                                            'BOATBUILDING__Work_Order__c','');
    }*/
}