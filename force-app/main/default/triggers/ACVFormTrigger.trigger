trigger ACVFormTrigger on BOATBUILDING__ACV_Form__c (before insert , before update) {
    
    if(trigger.isBefore) {
        if(trigger.isInsert || trigger.isUpdate) {

        }
    }

    Set<String>setConId = new Set<String>();
    for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
        
        if(objAcv.BOATBUILDING__Contact_Name__c != null) { 
            setConId.add(objAcv.BOATBUILDING__Contact_Name__c);
        }
    } 
    
    Map<Id, Contact> mapCon = new Map<Id, Contact>([Select Id, AccountId From Contact Where Id IN: setConId]);
    Set<String> setAccId = new Set<String>();
    for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
        
        if(objAcv.BOATBUILDING__Contact_Name__c != null && mapCon.containsKey(objAcv.BOATBUILDING__Contact_Name__c) 
            && mapCon.get(objAcv.BOATBUILDING__Contact_Name__c).AccountId != null) { 
            objAcv.BOATBUILDING__Account__c =  mapCon.get(objAcv.BOATBUILDING__Contact_Name__c).AccountId;
            
        }
    }
    if(trigger.isBefore) {
        if(trigger.isInsert || trigger.isUpdate) {
            for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
                if(objAcv.BOATBUILDING__Account__c != null) {
                    setAccId.add(objAcv.BOATBUILDING__Account__c); 
                }
            }
            Map<Id, Account> mapAcc = new Map<Id, Account>();
            if(!setAccId.isEmpty()) {
                mapAcc = new Map<Id, Account>([Select Id, Name From Account Where Id IN: setAccId]);
            }
            for(BOATBUILDING__ACV_Form__c objAcv :Trigger.new) {
                String strACVName = '';
                if(objAcv.BOATBUILDING__BoatYear__c != null) {
                    strACVName += objAcv.BOATBUILDING__BoatYear__c;
                }
                if(objAcv.BOATBUILDING__BoatMake__c != null) {
                    strACVName += ' '+objAcv.BOATBUILDING__BoatMake__c;
                }
                if(objAcv.BOATBUILDING__BoatModel__c != null) {
                    strACVName += ' '+objAcv.BOATBUILDING__BoatModel__c;
                }
                if(objAcv.BOATBUILDING__Account__c != null) {
                    strACVName +=  ' - '+mapAcc.get(objAcv.BOATBUILDING__Account__c).Name;
                }
                objAcv.BOATBUILDING__ACV_Form_Name__c = strACVName; 
                if(strACVName.length() > 77) {
                    objAcv.Name = strACVName.substring(0, 77) + '...';
                } else { 
                    objAcv.Name = strACVName;
                }
            }
        }
    }
}