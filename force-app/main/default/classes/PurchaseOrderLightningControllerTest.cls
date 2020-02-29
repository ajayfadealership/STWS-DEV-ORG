@isTest
public class PurchaseOrderLightningControllerTest {
    private static testmethod void MyTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;  
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
        insert objOrder;
         
        BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
        objPOLI.BOATBUILDING__Purchase_Order__c = objOrder.Id;
        objPOLI.BOATBUILDING__Part_Number__c = '12541254';
        insert objPOLI;
        
        
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
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
        objPOLIW.PartId = objPOLI.Id;
        objPOLIW.Quantity = Integer.valueOf(objPOLI.BOATBUILDING__Quantity__c);
        objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
        objPOLIW.PartName = objPOLI.Name;
        objPOLIW.Cost = objPOLI.BOATBUILDING__Cost__c;
        objPOLIW.showPill = true;
        lstPOLIW.add(objPOLIW); 
        string strLineItem = JSON.serialize(lstPOLIW);
        PurchaseOrderLightningController.fetchManuDetailsApex(objManuFacturer1.Id,objOrder.Id);
        PurchaseOrderLightningController.getLineItems(objOrder.Id);
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = objPart.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        PurchaseOrderLightningController.searchPartsfromInventoryAndParts(fixedSearchResults[0]);
        PurchaseOrderLightningController.getPORecordTypeId();
        PurchaseOrderLightningController.generateOrderApex(objOrder.Id);
        String str = PurchaseOrderLightningController.updatePOwithLineItems(objOrder.Id,strLineItem);
        System.debug('>>>>>str : '+str);
        PurchaseOrderLightningController.PartSearchResult objPartSearchResult = new PurchaseOrderLightningController.PartSearchResult();
        objPartSearchResult.partId = objPart.Id;
        objPartSearchResult.partName = objPart.Name;
        objPartSearchResult.partNumber = objPart.Part_Number__c;
        objPartSearchResult.partCost = objPart.Part_Cost__c;
    }
     private static testmethod void MyTest2(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;  
        
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Purchase Order').getRecordTypeId();
        insert objOrder;
         
        BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
        objPOLI.BOATBUILDING__Purchase_Order__c = objOrder.Id;
        objPOLI.BOATBUILDING__Part_Number__c = '12541254';
         objPOLI.Retail_Price__c = null;
        objPOLI.Dealer_Price__c = null;
        objPOLI.Cost__c = 0.00;
          objPOLI.Weight__c = '123';
         objPOLI.Quantity__c = 2;
         objPOLI.Vendor_Name__c =objManuFacturer1.Id;
        insert objPOLI;
        
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Bin__c = 'test';
        objPart.Part_Number__c = '12541254';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = null;
        objPart.Dealer_Price__c = null;
        objPart.Part_Cost__c = null;
        objPart.Category1__c = 'Parts';
        objPart.Discount__c = null;
        objPart.Family1__c = 'Canvas';
        objPart.Location__c = 'test';
        objPart.Map_Price__c = null;
        objPart.Minimum_Amount__c = null;
        objPart.Part_Color__c = 'red';
        objPart.Part_Size__c = 'red';
        objPart.Taxable__c = true;
        objPart.Weight__c = null;
        insert objPart;
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
        objPOLIW.PartId = objPOLI.Id;
        objPOLIW.Quantity = Integer.valueOf(objPOLI.BOATBUILDING__Quantity__c);
        objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
        objPOLIW.PartName = objPOLI.Name;
        objPOLIW.Cost = objPOLI.BOATBUILDING__Cost__c;
        objPOLIW.showPill = true;
        lstPOLIW.add(objPOLIW); 
        string strLineItem = JSON.serialize(lstPOLIW);
        PurchaseOrderLightningController.fetchManuDetailsApex(objManuFacturer1.Id,objOrder.Id);
        PurchaseOrderLightningController.getLineItems(objOrder.Id);
        
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = objPart.Id;
        Test.setFixedSearchResults(fixedSearchResults);
        
        PurchaseOrderLightningController.searchPartsfromInventoryAndParts(fixedSearchResults[0]);
        PurchaseOrderLightningController.getPORecordTypeId();
        PurchaseOrderLightningController.generateOrderApex(objOrder.Id);
        String str = PurchaseOrderLightningController.updatePOwithLineItems(objOrder.Id,strLineItem);
        System.debug('>>>>>str : '+str);
        PurchaseOrderLightningController.PartSearchResult objPartSearchResult = new PurchaseOrderLightningController.PartSearchResult();
        objPartSearchResult.partId = objPart.Id;
        objPartSearchResult.partName = objPart.Name;
        objPartSearchResult.partNumber = objPart.Part_Number__c;
        objPartSearchResult.partCost = objPart.Part_Cost__c;
    }


}