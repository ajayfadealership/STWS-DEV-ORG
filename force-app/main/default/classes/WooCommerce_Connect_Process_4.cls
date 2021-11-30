//objPart.Sub_Family__c 
global with sharing class WooCommerce_Connect_Process_4 implements Queueable, Database.AllowsCallouts {
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

    global WooCommerce_Connect_Process_4(Map<String, Map<String,Set<String>>> mapAttOption, Map<String, Set<String>> mapAttNameOptionForPro, String strPartId, List<BOATBUILDING__Woocommerce_Attribute__c> lstWA, 
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
            Map<String, String> mapTagNameId = new Map<String, String>();
            System.debug('Debug Log for After Add mapCollectionNameId: '+mapCollectionNameId);
            
            //System.debug('Debug Log for After Add mapTagNameId: '+mapTagNameId);
            List<String> lstURL = new List<String>();
            //Callout Method
            if(objPart.BOATBUILDING__Push_Image__c) {
                lstURL = WooCommerce_Connect.uploadImage(mapAttBase64, objWC).values();
            }
                        
            System.debug('Debug Log for lstURL: '+lstURL);
            String wooComProductId = WooCommerce_Connect.pushPartToWooCommerce(objPart, objWC, mapCollectionNameId, mapTagNameId, lstURL, mapAttNameOptionForPro, mapAttNameId);
            
            if(String.isNotBlank(wooComProductId)) {
                objPart.BOATBUILDING__WooCommerce_Id__c = wooComProductId;
                
                //Variaton Check
                List<Part__c> lstPart = WooCommerce_Connect.pushPartVariation(objPart, objWC, mapAttOption, mapAttNameId);
                objPart.BOATBUILDING__Push_Image__c = false;
                update objPart;
                
                //if(!lstPart.isEmpty())
                    //update lstPart;
            }
            update lstWA;
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log 4 Success'; 
                customLog = WooCommerce_Connect.productCreationResponse + '\n';
                if(customLog.length() >= 131000) {
                    objCL.BOATBUILDING__Summary__c = customLog.substring(0,131000); 
                } else {
                    objCL.BOATBUILDING__Summary__c = customLog;  
                }
                insert objCL;
            }
        } catch(Exception ex) {
            System.debug(ex);
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log process 4 Catch';
                customLog += WooCommerce_Connect.productCreationResponse  +'\n';
                customLog += WooCommerce_Connect.imageResponse+'\n'; 
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