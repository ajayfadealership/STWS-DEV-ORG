public class PurchaseOrderEditController {
    public PurchaseOrderEditController() { }

    @AuraEnabled
    public static List<PurchaseOrderLineItemWrapper> getLineItems(String strPOId) {
        List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
        List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = [Select 
                                                                            Id, BOATBUILDING__Quantity__c, BOATBUILDING__Part_Number__c, Name, BOATBUILDING__Cost__c 
                                                                    From 
                                                                            BOATBUILDING__Purchase_Order_Line_Item__c Where BOATBUILDING__Purchase_Order__c =: strPOId];

        for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI: lstPOLI) {
            PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
            objPOLIW.PartId = objPOLI.Id;
            objPOLIW.Quantity = Integer.valueOf(objPOLI.BOATBUILDING__Quantity__c);
            objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
            objPOLIW.PartName = objPOLI.Name;
            objPOLIW.Cost = objPOLI.BOATBUILDING__Cost__c;
            objPOLIW.showPill = true;
            lstPOLIW.add(objPOLIW); 
        }
        return lstPOLIW;
    }
}