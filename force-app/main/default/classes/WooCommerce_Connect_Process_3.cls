//objPart.Family1__c
global with sharing class WooCommerce_Connect_Process_3 implements Queueable, Database.AllowsCallouts {
    Map<String, Map<String,Set<String>>> mapAttOption = new Map<String, Map<String,Set<String>>>();
    Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
    String strPartId = '';
    List<BOATBUILDING__Woocommerce_Attribute__c> lstWA = new List<BOATBUILDING__Woocommerce_Attribute__c>();
    BOATBUILDING__WooCmmerce_Config__c objWC;
    Part__c objPart;
    Map<String, String> mapCollectionNameId = new Map<String, String>();
    Map<String, String> mapAttNameId = new Map<String, String>();
    String prntId;
    Map<String, String> mapAttBase64 = new Map<String, String>(); 

    global WooCommerce_Connect_Process_3(Map<String, Map<String,Set<String>>> mapAttOption, Map<String, Set<String>> mapAttNameOptionForPro, String strPartId, List<BOATBUILDING__Woocommerce_Attribute__c> lstWA, 
                                            BOATBUILDING__WooCmmerce_Config__c objWC, Part__c objPart, Map<String, String> mapCollectionNameId, Map<String, String> mapAttNameId, String prntId, 
                                                Map<String, String> mapAttBase64) {

        this.mapAttOption = mapAttOption;
        this.mapAttNameOptionForPro = mapAttNameOptionForPro;
        this.strPartId = strPartId;
        this.lstWA = lstWA;  
        this.objWC = objWC;
        this.objPart = objPart;
        this.mapCollectionNameId = mapCollectionNameId;
        this.mapAttNameId = mapAttNameId;
        this.prntId = prntId;
        this.mapAttBase64 = mapAttBase64;
    }
    global void execute(QueueableContext context) {
        String customLog = '';
        try {
            if(objPart.Family1__c != null) {
                //Callout Method
                Map<String, String> mapCollectionNameIdFam = WooCommerce_Connect.getWooCommerceCategories(objWC, objPart.Family1__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                mapCollectionNameId.putAll(mapCollectionNameIdFam);
                System.debug('Debug Log for mapCollectionNameId F: '+mapCollectionNameId);
                String Family = objPart.Family1__c.toUpperCase(); 
                if(!mapCollectionNameId.containsKey(Family)) {
                    //Callout Method
                    Map<String, String> mapNewCollection = WooCommerce_Connect.createCustomCategoryToWoocommerce(objPart.Family1__c, objWC, prntId);
                    if(!mapNewCollection.isEmpty()){
                        mapCollectionNameId.putAll(mapNewCollection);
                        prntId = mapCollectionNameId.get(Family);
                    }
                } else {
                    prntId = mapCollectionNameId.get(Family);
                }
            }    
            if(objPart.Family1__c != null &&  objPart.Sub_Family__c != null) {
                //Callout Method
                Map<String, String> mapCollectionNameIdSBFam = WooCommerce_Connect.getWooCommerceCategories(objWC, objPart.Sub_Family__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                mapCollectionNameId.putAll(mapCollectionNameIdSBFam);
                System.debug('Debug Log for mapCollectionNameId SF: '+mapCollectionNameIdSBFam);
                String SubFamily = objPart.Sub_Family__c.toUpperCase(); 
                if(!mapCollectionNameId.containsKey(SubFamily)) {
                    //Callout Method
                    Map<String, String> mapNewCollection = WooCommerce_Connect.createCustomCategoryToWoocommerce(objPart.Sub_Family__c, objWC, prntId);
                    if(!mapNewCollection.isEmpty()){
                        mapCollectionNameId.putAll(mapNewCollection);
                    }
                }
            }
            System.debug('Debug Log for After Add mapCollectionNameId: '+mapCollectionNameId);
            //Calling Queueable
            WooCommerce_Connect_Process_4 objWooCommerce_Connect_Process_4 = new WooCommerce_Connect_Process_4(mapAttOption, mapAttNameOptionForPro, strPartId, lstWA, objWC, objPart, mapCollectionNameId, mapAttNameId, prntId, mapAttBase64);
            System.enqueueJob(objWooCommerce_Connect_Process_4);
        }
        catch(Exception ex) {
            System.debug(ex);
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log process 3';
                customLog += WooCommerce_Connect.catagoryResponse; 
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog;  
                }
                insert objCL;
            }
        }
    }
}