trigger PartsAvailabilityTrigger on BOATBUILDING__Parts_Availability__c (after insert, after update, before delete) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)) {
        //list<RollUpSummaryUtility.fieldDefinition> fieldDefinitions1 = new list<RollUpSummaryUtility.fieldDefinition> {new RollUpSummaryUtility.fieldDefinition('SUM', 'BOATBUILDING__Quantity__c', 'BOATBUILDING__Quantity__c')};
        //RollUpSummaryUtility.rollUpTrigger(fieldDefinitions1, trigger.new,'Parts_Availability__c', 'BOATBUILDING__Inventory__c','BOATBUILDING__Inventory__c','');
        System.debug('Trigger.new: '+Trigger.new);
        Map<String, Integer> mapInvQut = new Map<String, Integer>();
        for(BOATBUILDING__Parts_Availability__c objPA: trigger.new) {
            if(!mapInvQut.containsKey(objPA.BOATBUILDING__Inventory__c)) {
                mapInvQut.put(objPA.BOATBUILDING__Inventory__c, 0);
            }
            
        }
        List<Inventory__c> lstInv = [SELECT Id, Quantity__c,
                                     (SELECT Id, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, 
                                      BOATBUILDING__Store_Location__c 
                                      FROM BOATBUILDING__Parts_Availability__r)
                                     FROM Inventory__c WHERE Id IN: mapInvQut.keySet()];
        for(Inventory__c objInv: lstInv) {
            
            Integer count = 0;
            for(BOATBUILDING__Parts_Availability__c objPA: objInv.BOATBUILDING__Parts_Availability__r) {
                if(objPA.BOATBUILDING__Quantity__c != null){
                    count += Integer.valueOf(objPA.BOATBUILDING__Quantity__c);
                }
            }
            objInv.Quantity__c = count;
        }
        update lstInv;
    }
}