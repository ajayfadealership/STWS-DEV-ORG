trigger WorkOrderPaymentTrigger on Work_Order_Payment__c (after insert, after update, after delete) {
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__WorkOrderPaymentTriggerCheckBox__c;
    if(isOff==true){
    if(trigger.isInsert || trigger.isUpdate || trigger.isUnDelete){
         
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Amount__c', 'BOATBUILDING__Total_Payment_payment__c')
        };
          RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.new,'BOATBUILDING__Work_Order_Payment__c','BOATBUILDING__Related_to_Warranty_Work_Work_Order__c','BOATBUILDING__Work_Order__c','');
    }   
    
    if(trigger.isDelete){
         
        list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions = new list<RollUpSummaryUtility.fieldDefinition> {
            new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Amount__c', 'BOATBUILDING__Total_Payment_payment__c')
        };
         
        RollUpSummaryUtility.rollUpTrigger(fieldDefinitions, trigger.old,'BOATBUILDING__Work_Order_Payment__c','BOATBUILDING__Related_to_Warranty_Work_Work_Order__c','BOATBUILDING__Work_Order__c','');
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
       WorkOrderPaymentHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
    
    /*
    if(Trigger.isInsert && Trigger.isAfter){
       ServicePaymentTriggerHandler.afterInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
       ServicePaymentTriggerHandler.afterUpdate(Trigger.old,Trigger.new);
    }
    
    if(Trigger.isDelete){
        ServicePaymentTriggerHandler.afterDelete(Trigger.old);
    }

    
    /*
    Set<id> workOrderIDs = new Set<id>();
    List<Work_Order__c> workOrderToUpdate = new List<Work_Order__c>();

    for (BOATBUILDING__Work_Order_Payment__c pay : Trigger.new){
           workOrderIDs.add(pay.BOATBUILDING__Related_to_Warranty_Work_Work_Order__c );
      }
    if(Trigger.isUpdate || Trigger.isDelete) {
        for (BOATBUILDING__Work_Order_Payment__c pay : Trigger.old){
           workOrderIDs.add(pay.BOATBUILDING__Related_to_Warranty_Work_Work_Order__c);
      }
    }
    
    Map<id,Work_Order__c> workOrderMap = new Map<id,Work_Order__c>([Select id, BOATBUILDING__Total_Payment_payment__c from Work_Order__c where id IN :workOrderIDs]);
    
    for(Work_Order__c WO: [Select id from Work_Order__c where id IN: workOrderIDs]){
        
    }
    
}
   */
    }
}