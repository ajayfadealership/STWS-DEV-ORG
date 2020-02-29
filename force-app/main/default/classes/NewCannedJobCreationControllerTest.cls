@isTest
private class NewCannedJobCreationControllerTest {

    static testMethod void myUnitTest() {
       BOATBUILDING__WorkTypePricing__c objWorkTypePricing = new BOATBUILDING__WorkTypePricing__c();
        objWorkTypePricing.Name = 'Internal';
        objWorkTypePricing.Price__c = 95.5;
        insert objWorkTypePricing;
        
        BOATBUILDING__Canned_Job__c objCJ = new BOATBUILDING__Canned_Job__c();
        objCJ.Name = 'My Job';
        insert objCJ;
        
        Case objCase = new Case();
        objCase.RecordTypeId = [Select Id From RecordType Where SobjectType='Case' AND DeveloperName='Work_Order'].Id;
        insert objCase;
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Part_Number__c = 'avsfd';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        insert objPart;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory for Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = 'dfvdsgsgv';
        objInventory.Part_Name__c = 'dfvdsgsgv';
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        List<String> lstStr = new List<String>();
        lstStr.add('dfvdsgsgv');
        lstStr.add('avsfd');
        ApexPages.StandardController sc = new ApexPages.StandardController(objCJ);
        NewCannedJobCreationController objNewJobCreationController = new NewCannedJobCreationController(sc);
        objNewJobCreationController.getLstWorkType();
        NewCannedJobCreationController.searchParts('dfvdsgsgv');
        NewCannedJobCreationController.searchParts('test'); 
        NewCannedJobCreationController.getFinalList(lstStr);       
        Map<String, String> mapCJ = new Map<String, String>();
        mapCJ.put('jobName', 'dsfsadf');
        mapCJ.put('isApproved', 'true');
        mapCJ.put('wrkRequested', 'dsafa');
        mapCJ.put('wrkType', objWorkTypePricing.Id);
        mapCJ.put('type', 'sdf');
        mapCJ.put('laborNo', '3');
        mapCJ.put('discount', '3');
        mapCJ.put('claimStatus', 'sdf');
        mapCJ.put('claimDate', '02/02/2010');
        mapCJ.put('claimApprovalDate', '02/02/2010');
        mapCJ.put('claimLaborPaidAmount', '200');
        mapCJ.put('claimLaborApprovedAmount', '200');
        mapCJ.put('returnPartAmount', '200');
        mapCJ.put('claimPaidDate', '02/02/2010');
        mapCJ.put('partPaidAmt', '200');
        
        Map<String, String> mapQuantity = new Map<String, String>();
        mapQuantity.put('avsfd','5');
        mapQuantity.put('dfvdsgsgv','5');
        
        NewCannedJobCreationController.createJob(mapCJ, mapQuantity);
        //NewCannedJobCreationController.findCannedJob(objCJ.Id);
    }
}