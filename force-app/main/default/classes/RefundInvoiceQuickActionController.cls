public class RefundInvoiceQuickActionController {

@AuraEnabled
public static String refundInvoice(String strInvId){
    List<BOATBUILDING__Invoice_Line_Item__c> lstILI = [Select 
    Id,	BOATBUILDING__Quantity__c,BOATBUILDING__Inventory__c,BOATBUILDING__Store_Location__c From
    BOATBUILDING__Invoice_Line_Item__c Where BOATBUILDING__Related_To_Invoice__c =: strInvId];
   system.debug('%^%^%^%'+lstILI);
    List<PartInventoryManagerController.PartInventoryWrapper> lstpIW = new  List<PartInventoryManagerController.PartInventoryWrapper>();
    if(lstILI.size() > 0){   
    for(BOATBUILDING__Invoice_Line_Item__c objInv : lstILI ){
    PartInventoryManagerController.PartInventoryWrapper objPIW = new  PartInventoryManagerController.PartInventoryWrapper();
    objPIW.inventoryId = objInv.BOATBUILDING__Inventory__c;
    objPIW.quantity =  objInv.BOATBUILDING__Quantity__c;
    objPIW.storeLocation = objInv.BOATBUILDING__Store_Location__c;
    lstpIW.add(objPIW);
    }

if(strInvId != null && strInvId != ''){
    BOATBUILDING__Invoice__c  objIn = new BOATBUILDING__Invoice__c();
    objIn.Id = strInvId ;
    objIn.BOATBUILDING__Refunded__c = true;
    update objIn;
   
}
PartInventoryManagerController.updateInventoryQuantity(lstpIW);
    }
    return 'Succes';

}
}