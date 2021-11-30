//Attributes
global class WooCommerce_Connect_Process_1 implements Queueable, Database.AllowsCallouts {
    
    Map<String, Map<String,Set<String>>> mapAttOption = new Map<String, Map<String,Set<String>>>();
    Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
    String strPartId = '';
    List<BOATBUILDING__Woocommerce_Attribute__c> lstWA = new List<BOATBUILDING__Woocommerce_Attribute__c>();
    BOATBUILDING__WooCmmerce_Config__c objWC;
    Part__c objPart;
    Map<String, String> mapCollectionNameId = new Map<String, String>();

    global WooCommerce_Connect_Process_1(Map<String, Map<String,Set<String>>> mapAttOption, Map<String, Set<String>> mapAttNameOptionForPro, String strPartId, List<BOATBUILDING__Woocommerce_Attribute__c> lstWA, 
                                                BOATBUILDING__WooCmmerce_Config__c objWC, Part__c objPart, Map<String, String> mapCollectionNameId) {
        
        this.mapAttOption = mapAttOption;
        this.mapAttNameOptionForPro = mapAttNameOptionForPro;
        this.strPartId = strPartId;
        this.lstWA = lstWA;  
        this.objWC = objWC;
        this.objPart = objPart;
        this.mapCollectionNameId = mapCollectionNameId;
    }
    global void execute(QueueableContext context) {
        try {
            Map<String, String> mapAttNameId = new Map<String, String>();
            //if(!objPart.Part_Variation__r.isEmpty()) {
                //Callout Method
                mapAttNameId = WooCommerce_Connect.getAllAttribute(objWC); 
            //}
            System.debug('Debug Log For mapAttNameId: '+mapAttNameId);
            //Calling Queueable
            WooCommerce_Connect_Process_2 objWooCommerce_Connect_Process_2 = new WooCommerce_Connect_Process_2(mapAttOption, mapAttNameOptionForPro, strPartId, lstWA, objWC, objPart, mapCollectionNameId, mapAttNameId);
            System.enqueueJob(objWooCommerce_Connect_Process_2);
        } catch(Exception ex) {
            System.debug('Debug Log For ex: '+ex.getMessage());
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log';
                String customLog = ex.getMessage();
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