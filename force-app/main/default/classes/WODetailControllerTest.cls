@isTest
public class WODetailControllerTest {
    static testMethod void testmethod1(){
        WODetailPageController.getPageLayoutFields();
        WODetailPageController.searchUsersApex('Test');
        
        BOATBUILDING__Shop_Supplies__c objShopSupplySetting = new BOATBUILDING__Shop_Supplies__c();
        objShopSupplySetting.Name = 'ShopSupplies';
        objShopSupplySetting.BOATBUILDING__Percentage__c = 10;
        objShopSupplySetting.BOATBUILDING__Cap_Amount_for_percent__c = 30;
        insert objShopSupplySetting;
        
        BOATBUILDING__WorkTypePricing__c objWorkTypePriceSetting  = new BOATBUILDING__WorkTypePricing__c();
        objWorkTypePriceSetting.Name = 'Shristi Testing';
        objWorkTypePriceSetting.BOATBUILDING__Active__c = true;
        objWorkTypePriceSetting.BOATBUILDING__Price__c = 2500.00;
        insert objWorkTypePriceSetting;
        
        
        
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        
        objWO.BOATBUILDING__Store_Location__c='Other';
        insert objWO;
        
        BOATBUILDING__Work_Order_Job__c objWOJob = new BOATBUILDING__Work_Order_Job__c();
//objWOJob.Name = 'testing';
        insert objWOJob;
        
        BOATBUILDING__Work_Order_Job_Line_Item__c objWOJobLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
        objWOJobLI.BOATBUILDING__Related_to_Job__c = objWOJob.Id;
        insert objWOJobLI;
        
        WorkOrderData objWOData = new WorkOrderData();
        objWOData.Id = objWOJob.Id; 
        objWOData.isDelete= false;
        objWOData.tempUniqueId =objWOJob.Id;
        objWOData.workOrderId =objWO.Id;
       //technicianId ='Shristi Testing';
        objWOData.isApprovedByCustomer = true;
        objWOData.isJobTaxable = true;
        objWOData.discontOnJob ='20.00';
        objWOData.ShippingCharges ='5.00';
        objWOData.jobName =objWOJob.Name;
        objWOData.WorkType ='test';
        objWOData.numberOfLabor ='5';
        objWOData.totalAmountOnJob ='500.00';
        objWOData.laborMuliplier ='2';
        //objWOData.RecordTypeName ='Shristi Testing';
        objWOData.claimStatus ='test';
        objWOData.claimApprovalDate =String.valueOf(System.today());
        objWOData.claimDate =String.valueOf(System.today());
        objWOData.claimPaidDate =String.valueOf(System.today());
        objWOData.claimLaborPaidAmount ='400.00';
        objWOData.claimPartsPaidAmount ='200.00';
        objWOData.claimMiscChargesPaid ='30.00';
        objWOData.claimLaborApprovedAmount ='50.00';
        objWOData.claimReturnPartsAmount ='10.00';
        objWOData.claimTotalPaidAmount = '400';
        objWOData.PartsTotal = '700.00';
        objWOData.miscDesc1 ='test1';
        objWOData.miscCharge1 = '25.00';
        objWOData.miscDesc2 = 'Test2';
        objWOData.miscCharge2 = '22.00';
        objWOData.miscDesc3 ='Test3';
        objWOData.miscCharge3 = '20.00';
        objWOData.customerComment ='Shristi Testing';
        objWOData.serviceWriterComment ='Shristi Testing';
        //objWOData.lstJobLineItems.add(objWOJobLI);
       objWOData.shopSupplies ='30.00';
        objWOData.taxOnJob ='30.00';
        objWOData.jobTotalwTax ='60.00';
        
        System.debug('>>>>>>>objWOData : ' + objWOData);
        String strJsonWOData = '['+json.serialize(objWOData)+']';
        System.debug('>>>>>>>objWOData : ' + strJsonWOData);
        /*   lstJobLineItems objLstJobLI = new lstJobLineItems();
objLstJobLI.tempUniqueIdFromJob;
objLstJobLI.partNumber = '12345';
objLstJobLI.partName = 'test';
objLstJobLI.isDelete = false;
//objLstJobLI.lineItemId;
//retailPrice = 30.0;
objLstJobLI.qunatity = 3;
objLstJobLI.cost =20.0;
//objLstJobLI.inventoryId;
//objLstJobLI.partId;
*/
        Map<String, BOATBUILDING__Work_Order_Job__c> mapCannedJob = WODetailPageController.getCannedJobMap();
        WODetailPageController.getNewWOJobInstance(objWO.Id);
        WODetailPageController.getWOClaimStatusPickList();
        Decimal objShopSupplyPer = WODetailPageController.getShopSuppliesPer();
        Decimal objShopSuppyCapping = WODetailPageController.getShopSuppliesCapping();
        WODetailPageController.getWorkOrderJobs(objWO.Id);
        WODetailPageController.loadSrviceUsers();
        WODetailPageController.generateGUID();
        WODetailPageController.deleteJobFromWO(objWO.Id);
        WODetailPageController.deleteJobLineItem(objWOJobLI.Id);
        WODetailPageController.saveWOJob(strJsonWOData);
        
    }
      static testMethod void testmethod2(){
        WODetailPageController.getPageLayoutFields();
        WODetailPageController.searchUsersApex('Test');
        
        BOATBUILDING__Shop_Supplies__c objShopSupplySetting = new BOATBUILDING__Shop_Supplies__c();
        objShopSupplySetting.Name = 'ShopSupplies';
        objShopSupplySetting.BOATBUILDING__Percentage__c = 10;
        objShopSupplySetting.BOATBUILDING__Cap_Amount_for_percent__c = 30;
        insert objShopSupplySetting;
        
        BOATBUILDING__WorkTypePricing__c objWorkTypePriceSetting  = new BOATBUILDING__WorkTypePricing__c();
        objWorkTypePriceSetting.Name = 'Shristi Testing';
        objWorkTypePriceSetting.BOATBUILDING__Active__c = true;
        objWorkTypePriceSetting.BOATBUILDING__Price__c = 2500.00;
        insert objWorkTypePriceSetting;
        
        
        
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        
        objWO.BOATBUILDING__Store_Location__c='Other';
        insert objWO;
        
        BOATBUILDING__Work_Order_Job__c objWOJob = new BOATBUILDING__Work_Order_Job__c();
//objWOJob.Name = 'testing';
        insert objWOJob;
        
        BOATBUILDING__Work_Order_Job_Line_Item__c objWOJobLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
        objWOJobLI.BOATBUILDING__Related_to_Job__c = objWOJob.Id;
        insert objWOJobLI;
        
        WorkOrderData objWOData = new WorkOrderData();
        objWOData.Id = objWOJob.Id; 
        objWOData.isDelete= false;
        objWOData.tempUniqueId =objWOJob.Id;
        objWOData.workOrderId =objWO.Id;
       objWOData.technicianId =null;
        objWOData.isApprovedByCustomer = null;
        objWOData.isJobTaxable = null;
        objWOData.discontOnJob =null;
        objWOData.ShippingCharges =null;
        objWOData.jobName =null;
        objWOData.WorkType =null;
        objWOData.numberOfLabor =null;
        objWOData.totalAmountOnJob =null;
        objWOData.laborMuliplier =null;
        objWOData.RecordTypeName ='Testing';
        objWOData.claimStatus =null;
        objWOData.claimApprovalDate =null;
        objWOData.claimDate =null;
        objWOData.claimPaidDate =null;
        objWOData.claimLaborPaidAmount =null;
        objWOData.claimPartsPaidAmount =null;
        objWOData.claimMiscChargesPaid =null;
        objWOData.claimLaborApprovedAmount =null;
        objWOData.claimReturnPartsAmount =null;
        objWOData.claimTotalPaidAmount = null;
        objWOData.PartsTotal = null;
        objWOData.miscDesc1 =null;
        objWOData.miscCharge1 = null;
        objWOData.miscDesc2 = null;
        objWOData.miscCharge2 = null;
        objWOData.miscDesc3 =null;
        objWOData.miscCharge3 = null;
        objWOData.customerComment ='Shristi Testing';
        objWOData.serviceWriterComment ='Shristi Testing';
        //objWOData.lstJobLineItems.add(objWOJobLI);
       objWOData.shopSupplies =null;
        objWOData.taxOnJob =null;
        objWOData.jobTotalwTax =null;
        
        System.debug('>>>>>>>objWOData : ' + objWOData);
        String strJsonWOData = '['+json.serialize(objWOData)+']';
        System.debug('>>>>>>>objWOData : ' + strJsonWOData);
        /*   lstJobLineItems objLstJobLI = new lstJobLineItems();
objLstJobLI.tempUniqueIdFromJob;
objLstJobLI.partNumber = '12345';
objLstJobLI.partName = 'test';
objLstJobLI.isDelete = false;
//objLstJobLI.lineItemId;
//retailPrice = 30.0;
objLstJobLI.qunatity = 3;
objLstJobLI.cost =20.0;
//objLstJobLI.inventoryId;
//objLstJobLI.partId;
*/
        Map<String, BOATBUILDING__Work_Order_Job__c> mapCannedJob = WODetailPageController.getCannedJobMap();
        WODetailPageController.getNewWOJobInstance(objWO.Id);
        WODetailPageController.getWOClaimStatusPickList();
        Decimal objShopSupplyPer = WODetailPageController.getShopSuppliesPer();
        Decimal objShopSuppyCapping = WODetailPageController.getShopSuppliesCapping();
        WODetailPageController.getWorkOrderJobs(objWO.Id);
        WODetailPageController.loadSrviceUsers();
        WODetailPageController.generateGUID();
        WODetailPageController.deleteJobFromWO(objWO.Id);
        WODetailPageController.deleteJobLineItem(objWOJobLI.Id);
        WODetailPageController.saveWOJob(strJsonWOData);
        
    }
    
}