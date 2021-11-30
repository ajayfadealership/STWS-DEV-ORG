public class PartTriggerHandler {
    public static void onAfterUpdate(Map<Id, Part__c> newMapPrt, Map<Id, Part__c> oldMapPrt) {
        if(runOnce()){
            updateInventoryFromPart(newMapPrt, oldMapPrt);
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                Set<String> setPartId = new Set<String>();
                Set<String> setPartIdShopify = new Set<String>();
                for(Part__c objPart: newMapPrt.values()) {
                    if(String.isNotBlank(objPart.Woocommerce_Id__c) && objPart.Quantity__c != null  && objPart.Quantity__c != oldMapPrt.get(objPart.Id).Quantity__c) {
                        if(objPart.Part__c != null) {
                            setPartId.add(objPart.Part__c);
                        } else { 
                            setPartId.add(objPart.Id); 
                        } 
                    } 
                    if(String.isNotBlank(objPart.BOATBUILDING__Shopify_Product_Id__c) && objPart.Quantity__c != null  && objPart.Quantity__c != oldMapPrt.get(objPart.Id).Quantity__c) {
                        if(objPart.Part__c != null) {
                            setPartIdShopify.add(objPart.Part__c);
                        } else { 
                            setPartIdShopify.add(objPart.Id); 
                        } 
                    } 
                } 
                if(!setPartId.isEmpty() && setPartId.size() < 10) { 
                    for(String str: setPartId) {  
                        WooCommerce_Connect.savePartsToWooCommerce(str);
                    }
                }
                if(!setPartIdShopify.isEmpty() && setPartIdShopify.size() <=2) { 
                    for(String str: setPartIdShopify) {  
                        Shopify_Connect.savePartsToShopifyFuture(str); 
                    }
                }
            } 
        }
    } 
     public static void onAfterInsert(List<Part__c> lstPart){
      	addInventoryByPart(lstPart);   
     } 
    public static void updateInventoryFromPart(Map<Id, Part__c> newMapPrt, Map<Id, Part__c> oldMapPrt) {
        
        List<Inventory__c> listInv = [SELECT Id, Part_Number__c, BOATBUILDING__Family__c, 
                                      BOATBUILDING__Category__c, BOATBUILDING__Part__c 
                                      FROM Inventory__c WHERE BOATBUILDING__Part__c IN: newMapPrt.keySet()];        
        
        if(!listInv.isEmpty()){
            List<Inventory__c> lstInvUpdate = new List<Inventory__c>();
            for(Inventory__c inv: listInv){
                Boolean flag = true;
                if(oldMapPrt.containsKey(inv.Id) && newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Category1__c != oldMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Category1__c) {
                    inv.BOATBUILDING__Category__c = newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Category1__c; 
                    flag = false;
                }
                if(oldMapPrt.containsKey(inv.Id) && newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Family1__c != oldMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Family1__c) {
                    inv.BOATBUILDING__Family__c = newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Family1__c;
                    flag = false;
                }
                if(!flag) {
                    lstInvUpdate.add(inv);
                }
            }
            System.debug('>>>>>>>lstInvUpdate: '+lstInvUpdate);
            
            if(!lstInvUpdate.isEmpty()) {
                update lstInvUpdate;
            }
            
        }
    }
       
    public static void addInventoryByPart( list<Part__c> lstPart){
        List<BOATBUILDING__Inventory__c> lstLst = new List<BOATBUILDING__Inventory__c>();
        for (Part__c objPrt : lstPart) {
            if(objPrt.Add_Inventory__c == true){
                BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
                objInv.BOATBUILDING__Part__c = objPrt.Id;
                objInv.RecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
                if (objPrt.BOATBUILDING__Vendor_Name__c != null) { 
                    objInv.Part_Name__c = objPrt.Name;
                    objInv.BOATBUILDING__Part_MSRP_Price__c = objPrt.Retail_Price__c;
                    objInv.Part_Number__c = objPrt.Part_Number__c;
                    objInv.BOATBUILDING__Vendor__c = objPrt.Vendor_Name__c;
                    objInv.Cost__c = objPrt.Part_Cost__c;
                    objInv.Bin__c = objPrt.Bin__c;
                    objInv.BOATBUILDING__Category__c = objPrt.Category1__c;
                    objInv.Discount__c = objPrt.Discount__c;
                    objInv.Family__c = objPrt.Family1__c;
                    objInv.Location__c = objPrt.Location__c;
                    objInv.Map_Price__c = objPrt.Map_Price__c;
                    objInv.Minimum_Amount__c = objPrt.Minimum_Amount__c;
                    objInv.Color__c = objPrt.Part_Color__c;
                    objInv.Size__c = objPrt.Part_Size__c;
                    objInv.Taxable__c = objPrt.Taxable__c;
                    if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                        objInv.Weight__c = objPrt.Weight__c; 
                    }
                }
                //insert objInv;
                lstLst.add(objInv);
            }
        }
        insert lstLst;
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Order__c.Store_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }  
        List<BOATBUILDING__Parts_Availability__c> lstPA = new List<BOATBUILDING__Parts_Availability__c>();
        for(BOATBUILDING__Inventory__c objInv: lstLst) {
            for(String str: pickListValuesList) {
                BOATBUILDING__Parts_Availability__c objPAIN = new BOATBUILDING__Parts_Availability__c();
                objPAIN.BOATBUILDING__Store_Location__c = str;
                objPAIN.BOATBUILDING__Inventory__c = objInv.Id;
                objPAIN.BOATBUILDING__Quantity__c = 0;
                lstPA.add(objPAIN);
            } 
        }
        insert lstPA;
    }
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}