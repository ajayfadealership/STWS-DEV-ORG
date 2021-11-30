global class WorkOrderDMLBatch implements Database.Batchable<sObject> {
    global WorkOrderDMLBatch() { }
    global Database.QueryLocator start( Database.BatchableContext BC ) {
        String strQuery = 'SELECT Id, Name, BOATBUILDING__Next_Schedule_Date__c, (SELECT Id, BOATBUILDING__Schedule_Date_Time__c FROM BOATBUILDING__Time_Management__r WHERE RecordType.DeveloperName = \'Schedule\' AND BOATBUILDING__Schedule_Date_Time__c >= TODAY ORDER BY BOATBUILDING__Schedule_Date_Time__c ASC) FROM BOATBUILDING__Work_Order__c ORDER BY CreatedDate DESC';
        return Database.getQueryLocator(strQuery);
    }
    global void execute( Database.BatchableContext BC, List<BOATBUILDING__Work_Order__c> scope ) { 
        System.debug('scope : '+scope);
        List< BOATBUILDING__Work_Order__c > lstWO = new List< BOATBUILDING__Work_Order__c >();
        for( BOATBUILDING__Work_Order__c objWO : scope ) {
            if( objWO.BOATBUILDING__Time_Management__r != null && !objWO.BOATBUILDING__Time_Management__r.isEmpty() && objWO.BOATBUILDING__Time_Management__r[0].BOATBUILDING__Schedule_Date_Time__c != null ) 
            {
                objWO.BOATBUILDING__Next_Schedule_Date__c = objWO.BOATBUILDING__Time_Management__r[0].BOATBUILDING__Schedule_Date_Time__c;
                lstWO.add(objWO);
            }
        }

        if( !lstWO.isEmpty() ) update lstWO;
    }
    global void finish(Database.BatchableContext BC) { }
}