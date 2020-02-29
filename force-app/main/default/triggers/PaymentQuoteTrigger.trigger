trigger PaymentQuoteTrigger on All_Payment__c (after insert, after update) {
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate) {
            Set<String> setQuoteId = new Set<String>();
            for(All_Payment__c objAllPay: trigger.new) { 
                if(objAllPay.Quote__c != null) {
                    setQuoteId.add(objAllPay.Quote__c);
                }
            }
            System.debug('Debug setQuoteId: '+setQuoteId);
            String strRecordTypeId = Schema.SObjectType.BOATBUILDING__All_Payment__c.getRecordTypeInfosByName().get('Quote Payment').getRecordTypeId();
            List<Quote__c> lstQT = [Select b.Id, b.BOATBUILDING__Quote_Down_Payment__c, (Select BOATBUILDING__Amount__c From BOATBUILDING__Payment__r Where RecordTypeId =: strRecordTypeId) From BOATBUILDING__Quote__c b Where Id IN: setQuoteId];
            System.debug('Debug lstQT: '+lstQT);
            for(Quote__c objQt: lstQT) {
                System.debug('Debug objQt: '+objQt);
                Decimal AmountCount = 0.00;
                if(objQt.BOATBUILDING__Payment__r.size() > 0) {
                System.debug('Debug objQt.BOATBUILDING__Payment__r: '+objQt.BOATBUILDING__Payment__r);
                    for(BOATBUILDING__All_Payment__c objPt: objQt.BOATBUILDING__Payment__r) {
                        System.debug('Debug objPt: '+objPt);
                        if(objPt.Amount__c != null) {
                            AmountCount += objPt.Amount__c;
                        }
                    }
                    System.debug('Debug AmountCount: '+AmountCount);
                    objQt.BOATBUILDING__Quote_Down_Payment__c = AmountCount; 
                }
            } 
            
            update lstQT;
                       
        }
    }
}