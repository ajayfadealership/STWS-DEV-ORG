public class ProductPriceTriggerHelper {
    public static void updateManufacturer(set<String> setManuName) {
        List<BOATBUILDING__Manufacturer__c> lstManufacturer = new List<BOATBUILDING__Manufacturer__c>();
        try {
            for(BOATBUILDING__Manufacturer__c objManufacturer : [SELECT Id, Name, Model_Variant__c FROM BOATBUILDING__Manufacturer__c WHERE Name IN: setManuName]) {
                if(objManufacturer.Model_Variant__c == false) {
                    objManufacturer.Model_Variant__c = true;
                    lstManufacturer.add(objManufacturer);
                }                                                                     
            }
            
            update lstManufacturer;
                                                                                   
        }
        catch(Exception ex) {
            System.debug('Debug Log For Exception : '+ex);
        }
    }   
}