@isTest
public class ApproveOrderControllerTest{
    static testMethod void unitTest(){
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        BOATBUILDING__Parts_Availability__c objPartAvailability = new BOATBUILDING__Parts_Availability__c();
        objPartAvailability.BOATBUILDING__Inventory__c = objInventory.ID;
        objPartAvailability.BOATBUILDING__Quantity__c = 123;
        objPartAvailability.BOATBUILDING__Store_location__c = 'Other';
        insert objPartAvailability;
        ApproveOrderController.StoreLocationWrapper objLocation = new ApproveOrderController.StoreLocationWrapper(objPartAvailability); 
        
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order Approved').getRecordTypeId();
        objOrder.Received__c = 3 ;
        insert objOrder;
        
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c = 2;
        objLI.Part_Number_del__c = '1';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        insert objLI ;
        
        Map<String,BOATBUILDING__Inventory__c> mapInventory = new Map<String,BOATBUILDING__Inventory__c>();
        
        ApexPages.currentPage().getParameters().put('Id',objOrder.Id) ;
        ApexPages.StandardController sc = new ApexPages.standardController(objOrder);   
        ApproveOrderController objApproveOrderController = new ApproveOrderController(sc);
       
        objApproveOrderController.lstOrderLineItemsWrapper[0].received = 2;
        objApproveOrderController.lstOrderLineItemsWrapper[0].lstSlocationD.add(objLocation);
        objApproveOrderController.addToInventory();
        objApproveOrderController.calculateAllValues();
        
        objApproveOrderController.createBackOrder();
        
        
        
    }
    static testMethod void unitTest2(){
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order Approved').getRecordTypeId();
        objOrder.Received__c = 3 ;
        insert objOrder;
        
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c = 2;
        objLI.Part_Number_del__c = '2';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        insert objLI ;
        
        Map<String,BOATBUILDING__Inventory__c> mapInventory = new Map<String,BOATBUILDING__Inventory__c>();
        
        ApexPages.currentPage().getParameters().put('Id',objOrder.Id) ;
        ApexPages.StandardController sc = new ApexPages.standardController(objOrder);
        ApproveOrderController objApproveOrderController = new ApproveOrderController(sc);
        
        objApproveOrderController.calculateAllValues();
        objApproveOrderController.addToInventory();
        objApproveOrderController.lstOrderLineItemsWrapper[0].received = 3;
        objApproveOrderController.createBackOrder();
        objApproveOrderController.printOrder();
        objApproveOrderController.sendOrder();
        objApproveOrderController.SaveLocationsToInv();
        objApproveOrderController.addSlocation();
        objApproveOrderController.distributeTheParts();
        
        
        
    }
    static testMethod void unitTest3(){
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order Approved').getRecordTypeId();
        objOrder.Received__c = 3 ;
        objOrder.Is_Approved__c = true;
        insert objOrder;
        
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c = 2;
        objLI.Part_Number_del__c = '2';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        insert objLI ;
        
        
        Map<String,BOATBUILDING__Inventory__c> mapInventory = new Map<String,BOATBUILDING__Inventory__c>();
        
        ApexPages.currentPage().getParameters().put('Id',objOrder.Id) ;
        ApexPages.StandardController sc = new ApexPages.standardController(objOrder);
        ApproveOrderController objApproveOrderController = new ApproveOrderController(sc);
        objApproveOrderController.lstOrderLineItemsWrapper[0].received = 2;
        objApproveOrderController.calculateAllValues();
        objApproveOrderController.addToInventory();
        objApproveOrderController.createBackOrder();
        
        //objApproveOrderController.checkAccess();
        
    }
}