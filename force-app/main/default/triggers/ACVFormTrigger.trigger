trigger ACVFormTrigger on BOATBUILDING__ACV_Form__c (before insert , before update) {
    
    Set<String>setConId = new Set<String>();
    for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
        
        if(objAcv.BOATBUILDING__Contact_Name__c != null) { 
            setConId.add(objAcv.BOATBUILDING__Contact_Name__c);
        }
    } 
    
    Map<Id, Contact> mapCon = new Map<Id, Contact>([Select Id, AccountId From Contact Where Id IN: setConId]);
    for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
        
        if(objAcv.BOATBUILDING__Contact_Name__c != null && mapCon.containsKey(objAcv.BOATBUILDING__Contact_Name__c) 
            && mapCon.get(objAcv.BOATBUILDING__Contact_Name__c).AccountId != null) { 
            objAcv.BOATBUILDING__Account__c =  mapCon.get(objAcv.BOATBUILDING__Contact_Name__c).AccountId;
        }
    }
}