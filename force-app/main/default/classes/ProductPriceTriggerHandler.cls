public class ProductPriceTriggerHandler {
    public static void onAfterInsert(List<BOATBUILDING__ProductPrice__c> lstProductPrice) {
        Set<String> setManufacturerName = new Set<String>();
        for(BOATBUILDING__ProductPrice__c objProPrc: lstProductPrice) {
            if(String.isNotBlank(objProPrc.Model_Variant__c)) {
                setManufacturerName.add(objProPrc.ProductManufacturer__c);        
            }
        }
        if(setManufacturerName.size() > 0) {
            ProductPriceTriggerHelper.updateManufacturer(setManufacturerName);
        }
    }
    
    public static void onAfterUpdate(List<BOATBUILDING__ProductPrice__c> lstProductPrice) {
        Set<String> setManufacturerName = new Set<String>();
        for(BOATBUILDING__ProductPrice__c objProPrc: lstProductPrice) {
            if(String.isNotBlank(objProPrc.Model_Variant__c)) {
                setManufacturerName.add(objProPrc.ProductManufacturer__c);        
            }
        }
        if(setManufacturerName.size() > 0) {
            ProductPriceTriggerHelper.updateManufacturer(setManufacturerName);
        }

    }
}