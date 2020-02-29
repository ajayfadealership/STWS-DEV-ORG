public with sharing class RedirectToServiceController {
    BOATBUILDING__Work_Order__c objWO;
    public RedirectToServiceController(ApexPages.StandardController controller) {
        objWO = (BOATBUILDING__Work_Order__c)controller.getRecord();
    }
    
    public PageReference redirectToService() {
        BOATBUILDING__Work_Order__c objWO2 = [Select Id, Name, RecordType.DeveloperName From BOATBUILDING__Work_Order__c Where Id =: objWO.Id];
        if(objWO2.RecordType.DeveloperName.equals('Work_Order')) {
        	
            return new PageReference('/apex/ServicePage?type=WO&WOId='+objWO2.Name);  
        } else if(objWO2.RecordType.DeveloperName.equals('Warranty_Work_Order')) {
        	
            return new PageReference('/apex/ServicePage?type=WWO&WWOId='+objWO2.Name);  
        }
        return new PageReference('/apex/ServicePage');
    }
    
    public PageReference inLightning() {
    	 	return new PageReference('/one/one.app?source=aloha#/sObject/'+objWO.Id+'/view'); 
    } 
}