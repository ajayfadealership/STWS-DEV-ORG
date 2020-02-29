public class InvoiceLightningController {
@AuraEnabled
public static List<PurchaseOrderLineItemWrapper> getLineItems(String strPOId) { 
    List<PurchaseOrderLineItemWrapper> lstPOLIW = new List<PurchaseOrderLineItemWrapper>();
    List<BOATBUILDING__Invoice_Line_Item__c> lstPOLI = [Select 
                                                                Id,BOATBUILDING__Dealer_Price__c, BOATBUILDING__Quantity__c,BOATBUILDING__Part__c, BOATBUILDING__Part_Number__c, Name, BOATBUILDING__Part_Cost__c,BOATBUILDING__Discount_Price__c,BOATBUILDING__Discount_in_Percent__c
                                                                From 
                                                                BOATBUILDING__Invoice_Line_Item__c Where BOATBUILDING__Related_To_Invoice__c =: strPOId];
    
    for(BOATBUILDING__Invoice_Line_Item__c objPOLI: lstPOLI) {
        PurchaseOrderLineItemWrapper objPOLIW = new PurchaseOrderLineItemWrapper();
        objPOLIW.Id = objPOLI.Id;
        objPOLIW.PartId = objPOLI.BOATBUILDING__Part__c;
        objPOLIW.Quantity = Integer.valueOf(objPOLI.BOATBUILDING__Quantity__c);
        objPOLIW.PartNumber = objPOLI.BOATBUILDING__Part_Number__c;
        objPOLIW.PartName = objPOLI.Name;
        objPOLIW.partMSRP = objPOLI.BOATBUILDING__Part_Cost__c != null ? objPOLI.BOATBUILDING__Part_Cost__c : 0.00;
        objPOLIW.Cost = objPOLI.BOATBUILDING__Dealer_Price__c != null ? objPOLI.BOATBUILDING__Part_Cost__c: 0.0;
        objPOLIW.discount = objPOLI.BOATBUILDING__Discount_Price__c != null ? objPOLI.BOATBUILDING__Discount_Price__c: 0.0;
        objPOLIW.discountPer = objPOLI.BOATBUILDING__Discount_in_Percent__c != null ? objPOLI.BOATBUILDING__Discount_in_Percent__c: 0.0;
        objPOLIW.Total = (objPOLIW.Cost * objPOLIW.Quantity) -  objPOLIW.discount;
        objPOLIW.TotalWithoutDisc = objPOLIW.Cost * objPOLIW.Quantity;
        objPOLIW.showPill = true;
        lstPOLIW.add(objPOLIW); 
    }
    return lstPOLIW;
    
}
@AuraEnabled
public static String deleteInvoiceLineItem(String invoiceLineItemId){
    try{
        delete [Select Id from BOATBUILDING__Invoice_Line_Item__c where Id =: invoiceLineItemId ];
        return 'SUCCESS';
    }
    catch(Exception e){
        return 'FAILURE';
    }

}
@AuraEnabled
public static String searchPartsfromInvoiceAndParts(String searchStr){
    return PurchaseOrderLightningController.searchPartsfromInventoryAndParts(searchStr);       
}
@AuraEnabled
public static String getSalesTaxCustomSetting(){
  Map<String,BOATBUILDING__SalesTaxConfiguration__c> mapSalesTaxConfig = BOATBUILDING__SalesTaxConfiguration__c.getall();
    return  JSON.serialize(mapSalesTaxConfig); 

}
@AuraEnabled
public static String searchPartsfromInventoryAndParts(String searchStr){
    //return PurchaseOrderLightningController.searchPartsfromInventoryAndParts(searchStr);
    List<PartSearchResult> lstPartSearchResult = new List<PartSearchResult>();
    String strName = searchStr;
    if(searchStr == 'recentlyViewed'){
         strName = '';
         List<RecentlyViewed> lstrv = [Select Id,Name from RecentlyViewed where Type = 'BOATBUILDING__Part__c'];
         
         for(RecentlyViewed rv : lstrv){
            
              strName = strName+'(\"' + String.escapeSingleQuotes(rv.Name) + '\")';
              strName =  strName + ' OR ';


         }
       
         strName  = strName+'(\"' + 'test1234dummyString' + '\")';
    }
    System.debug(strName);
    

    String searchQuery = 'FIND \'' + strName + '\' IN ALL FIELDS RETURNING BOATBUILDING__Part__c(Id,Name,BOATBUILDING__Part_Cost__c,BOATBUILDING__Quantity__c,BOATBUILDING__Retail_Price__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Vendor_Name__r.Name,BOATBUILDING__Discount__c)';
    
    List<List <sObject>> searchList = search.query(searchQuery);
    System.debug(searchList);
    Set<String> setPartNumber = new Set<String>();
    for(Object o : searchList[0]){
        BOATBUILDING__Part__c objInv = (BOATBUILDING__Part__c)o;
         if(!setPartNumber.contains(objInv.BOATBUILDING__Part_Number__c)){

            PartSearchResult objPSR = new PartSearchResult();
             objPSR.PartId = objInv.Id;
             objPSR.partName =   objInv.Name;
             objPSR.partNumber = objInv.BOATBUILDING__Part_Number__c;
             objPSR.isInventoryPart = false;
             objPSR.partNumber = objInv.BOATBUILDING__Part_Number__c;
             
             objPSR.partMSRP = objInv.BOATBUILDING__Retail_Price__c;
             objPSR.Cost = objInv.BOATBUILDING__Part_Cost__c;
             if(objInv.BOATBUILDING__Quantity__c < 1){
                 objPSR.isInventoryLow = true;
             } 
             else{
                 objPSR.isInventoryLow = false;
             }
             objPSR.quantity = objInv.BOATBUILDING__Quantity__c != null ? Integer.ValueOf(objInv.BOATBUILDING__Quantity__c) : 0;
             lstPartSearchResult.add(objPSR);
             setPartNumber.add(objInv.BOATBUILDING__Part_Number__c);
         }
    }

    return JSON.serialize(lstPartSearchResult);
    
}
@AuraEnabled
public static string InvRecordTypeId(){
    String InvRecTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId(); 
    return InvRecTypeId;
}

@AuraEnabled
public static String UpdateInvoicewithLineItems(String strInvId, String strLineItems) {
    try{
    System.debug('CALL CHECK');
    System.debug('>>>>@#@#@#: '+JSON.serializePretty(JSON.deserializeUntyped(strLineItems)));
    BOATBUILDING__Invoice__c objInv = [SELECT Id, (Select Id, BOATBUILDING__Quantity__c From BOATBUILDING__Invoice_Line_Items__r) FROM BOATBUILDING__Invoice__c WHERE Id =: strInvId LIMIT 1];
    List<Object> lstObj = (List<Object>)JSON.deserializeUntyped(strLineItems);
    List<BOATBUILDING__Invoice_Line_Item__c> lstInLi = new List<BOATBUILDING__Invoice_Line_Item__c> ();
    
            for(Object o : lstObj){
                
                
                BOATBUILDING__Invoice_Line_Item__c objInLI = new BOATBUILDING__Invoice_Line_Item__c();
                Map<String, Object> dataNode = (Map<String, Object>)o;

                objInLI.BOATBUILDING__Related_To_Invoice__c = strInvId;
                if(dataNode.containsKey('PartId')){
                objInLI.BOATBUILDING__Part__c = String.valueOf(dataNode.get('PartId'));
            }
            if(dataNode.containsKey('PartNumber')){
                objInLI.BOATBUILDING__Part_Number__c = String.valueOf(dataNode.get('PartNumber'));
            }
            if(dataNode.containsKey('Quantity')){
                objInLI.BOATBUILDING__Quantity__c = Integer.valueOf(dataNode.get('Quantity'));
            }
            if(dataNode.containsKey('partMSRP')){
                objInLI.BOATBUILDING__Part_Cost__c = Integer.valueOf(dataNode.get('partMSRP'));
            }
            if(dataNode.containsKey('Cost')){
                objInLI.BOATBUILDING__Dealer_Price__c = Integer.valueOf(dataNode.get('Cost'));
            }
            if(dataNode.containsKey('discountPer')){
                objInLI.BOATBUILDING__Discount_in_Percent__c = Integer.valueOf(dataNode.get('discountPer'));
            }
            if(dataNode.containsKey('discount')){
                objInLI.BOATBUILDING__Discount_Price__c =  Integer.valueOf(dataNode.get('discount'));
            }

            lstInLi.add(objInLI);
                
                System.debug(dataNode);
                System.debug('lineItemObect-------'+dataNode.get('Cost') );
                System.debug('name-------'+dataNode.get('PartName') );
                System.debug('discount-------'+dataNode.get('discount') );
                System.debug('number-------'+dataNode.get('PartNumber') );
                System.debug('MSRP-----'+dataNode.get('partMSRP') );
               /* objInLI.Name = obj.part;   
                objInLI.BOATBUILDING__Discount_Price__c = Integer.valueOf(mapObj1.get('discount')); 
                objInLI.BOATBUILDING__Discount_in_Percent__c = Integer.valueOf(mapObj1.get('discountPer'));
                objInLI.Quantity__c = Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c));
                objInLI.Description__c = objPrt.Part_Number__c;
                objInLI.Dealer_Price__c = objPrt.Retail_Price__c;
                objInLI.Part_Cost__c =  objPrt.Part_Cost__c;
                objInLI.Part_Number__c = objPrt.Part_Number__c;
                objInLI.Taxable__c = objPrt.Taxable__c;
                if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                    objInLI.Weight__c = objPrt.Weight__c; 
                }
                lstPOLI.add(objInLI); */
            }
            
       /* for(BOATBUILDING__Part__c objPrt : lstPart) { 
            for(Object obj1: lstObj) {
                BOATBUILDING__Invoice_Line_Item__c objInLI = new BOATBUILDING__Invoice_Line_Item__c();
                Map<String, Object> mapObj1 = (Map<String, Object>)obj1;
                if(String.valueOf(mapObj1.get('PartNumber')) == objPrt.Part_Number__c) {
                    if(String.isNotBlank(String.valueOf(mapObj1.get('PartId')))) {
                        objInLI.Id = String.valueOf(mapObj1.get('PartId'));
                    } else {
                        objInLI.Related_To_Invoice__c = objInv.Id;
                    }
                    objInLI.Name = objPrt.Name;   
                    objInLI.BOATBUILDING__Discount_Price__c = Integer.valueOf(mapObj1.get('discount')); 
                    objInLI.BOATBUILDING__Discount_in_Percent__c = Integer.valueOf(mapObj1.get('discountPer'));
                    objInLI.Quantity__c = Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c));
                    objInLI.Description__c = objPrt.Part_Number__c;
                    objInLI.Dealer_Price__c = objPrt.Retail_Price__c;
                    objInLI.Part_Cost__c =  objPrt.Part_Cost__c;
                    objInLI.Part_Number__c = objPrt.Part_Number__c;
                    objInLI.Taxable__c = objPrt.Taxable__c;
                    if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                        objInLI.Weight__c = objPrt.Weight__c; 
                    }
                    lstPOLI.add(objInLI);   
                 


                } 

            }  */      
        
                                               
       
     upsert lstInLi ;   
    return 'SUCCESS';
}catch(Exception err) { 
    System.debug(err);
    String error = 'Error: '+err.getMessage()+' : '+err.getLineNumber()+' : '+err.getStackTraceString();
    return error;
}

    
}
public class PartSearchResult{
    @AuraEnabled
    public String Id{get; set;}
    @AuraEnabled
    public String PartId{get; set;}
    @AuraEnabled
    public String partName{get; set;}
    @AuraEnabled
    public String partNumber{get; set;}
    @AuraEnabled
    public String partDescription{get; set;}
    @AuraEnabled
    public Boolean isInventoryPart{get; set;}
    @AuraEnabled
    public Decimal partMSRP{get; set;}
    @AuraEnabled
    public Boolean isInventoryLow{get; set;}
    @AuraEnabled
    public Integer quantity{get; set;}
    @AuraEnabled
    public Decimal Cost{get; set;}
    
}



}