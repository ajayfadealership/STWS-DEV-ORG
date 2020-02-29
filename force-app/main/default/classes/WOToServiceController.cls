public with sharing class WOToServiceController {
    public PageReference redirectTo() {
        String woId = ApexPages.currentPage().getParameters().get('Id');
        Work_Order__c objWO = [Select Id, Name,  RecordType.Name From Work_Order__c Where Id =: woId Limit 1];
        
        if(objWO.RecordType.Name == 'Warranty Work Order') {

            /*PageReference pageref = new PageReference('/apex/BOATBUILDING__ServicePage');
            pageRef.setRedirect(true);
            pageref.getParameters().put('type','WWO');
            pageref.getParameters().put('WWOId',objWO.Name);
            
            return pageref;*/
            return new PageReference('/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objWO.Name);
        
        } else if(objWO.RecordType.Name == 'Work Order') {
        
            return new PageReference('/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objWO.Name);
            
            /*PageReference pageref = new PageReference('/apex/BOATBUILDING__ServicePage');
            pageRef.setRedirect(true);
            pageref.getParameters().put('type','WO');
            pageref.getParameters().put('WOId',objWO.Name);
            
            return pageref;*/
        
        }
        return null;
    }
}