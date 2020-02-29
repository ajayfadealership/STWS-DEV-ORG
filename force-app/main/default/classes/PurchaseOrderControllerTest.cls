@isTest
public class PurchaseOrderControllerTest{
    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;  
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
        insert objOrder;
                
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Bin__c = 'test';
        objPart.Part_Number__c = '12541254';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        objPart.Dealer_Price__c = 458;
        objPart.Part_Cost__c = 698;
        objPart.Category1__c = 'Parts';
        objPart.Discount__c = 54;
        objPart.Family1__c = 'Canvas';
        objPart.Location__c = 'test';
        objPart.Map_Price__c = 25;
        objPart.Minimum_Amount__c = 36;
        objPart.Part_Color__c = 'red';
        objPart.Part_Size__c = 'red';
        objPart.Taxable__c = false;
        objPart.Weight__c = 'red';
        insert objPart;
      
            
        Map<String,String> objMap = new Map<String,String>();
        objMap.put('12541254','100');
        PurchaseOrderController objPurchaseOrderController = new PurchaseOrderController();
        objPurchaseOrderController.getlstOfPurchaseOrder();
        PurchaseOrderController.fetchManufacturer(objManuFacturer1.Id);
        PurchaseOrderController.getLstOfPart('Test');
        PurchaseOrderController.getLstOfPart2('Test');
        //PurchaseOrderController.createPurchaseOrder(objMap,objManuFacturer1.Id, 'STWS');
                
    }
}