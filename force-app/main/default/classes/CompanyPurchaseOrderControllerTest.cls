@isTest
public class CompanyPurchaseOrderControllerTest {
    Public static  testMethod void myUnitTest(){
        CompanyPurchaseOrderController ObjC= new CompanyPurchaseOrderController();
        BOATBUILDING__Manufacturer__c objManu = new BOATBUILDING__Manufacturer__c();
        objManu.Name = 'test';
        objManu.BOATBUILDING__Manufacturer_name__c = 'testt';
        //objManu.BOATBUILDING__Vendor_Name__c = 'tejnd';
        insert objManu;
        BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
        Id RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Company Purchase Requests').getRecordTypeId();
       objOrder.RecordTypeId = RecordTypeId;
      //     objOrder.BOATBUILDING__Vendor_Name__c = objManu.Id;
      //   objOrder.BOATBUILDING__Store_Location__c = 'Other';
       // insert objOrder;
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.BOATBUILDING__Part_Number__c = 'testno';
        objPart.BOATBUILDING__Vendor_Name__c = objManu.Id;
        CompanyPurchaseOrderController.fetchManufacturer(objManu.Id);
        CompanyPurchaseOrderController.saveVendDetails('test',objManu.Id);
        CompanyPurchaseOrderController.getLstOfPart('testno');
        ObjC.getlstOfPurchaseOrder();
        CompanyPurchaseOrderController.createPurchaseOrder(objManu.Id,'Other');
        CompanyPurchaseOrderController.getLstOfPart2('testno');
        
        
        
        
    }
    
}