//objPart.BOATBUILDING__Category1__c
global with sharing class WooCommerce_Connect_Process_2 implements Queueable, Database.AllowsCallouts {
    Map<String, Map<String,Set<String>>> mapAttOption = new Map<String, Map<String,Set<String>>>();
    Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
    String strPartId = '';
    List<BOATBUILDING__Woocommerce_Attribute__c> lstWA = new List<BOATBUILDING__Woocommerce_Attribute__c>();
    BOATBUILDING__WooCmmerce_Config__c objWC;
    Part__c objPart;
    Map<String, String> mapCollectionNameId = new Map<String, String>();
    Map<String, String> mapAttNameId = new Map<String, String>();
    global WooCommerce_Connect_Process_2(Map<String, Map<String,Set<String>>> mapAttOption, Map<String, Set<String>> mapAttNameOptionForPro, String strPartId, List<BOATBUILDING__Woocommerce_Attribute__c> lstWA, 
                                                BOATBUILDING__WooCmmerce_Config__c objWC, Part__c objPart, Map<String, String> mapCollectionNameId, Map<String, String> mapAttNameId) {
        
        this.mapAttOption = mapAttOption;
        this.mapAttNameOptionForPro = mapAttNameOptionForPro;
        this.strPartId = strPartId;
        this.lstWA = lstWA;  
        this.objWC = objWC;
        this.objPart = objPart;
        this.mapCollectionNameId = mapCollectionNameId;
        this.mapAttNameId = mapAttNameId;
    }
    global void execute(QueueableContext context) {
        String customLog = '';
        try {
            Set<String> setAttNameToCreate = new Set<String>();
            if(!lstWA.isEmpty()) {
                for(Woocommerce_Attribute__c objWA: lstWA) {
                    //System.debug('Debug Log for mapAttNameId in: '+mapAttNameId);
                    if(mapAttNameId.containsKey(objWA.Name.toUpperCase()) && String.isBlank(objWA.BOATBUILDING__WooCom_Attribute_Id__c)) {
                        objWA.BOATBUILDING__WooCom_Attribute_Id__c = mapAttNameId.get(objWA.Name.toUpperCase());
                    } 
                    if(!mapAttNameId.containsKey(objWA.Name.toUpperCase())){
                        //setAttNameToCreate.add(objWA.BOATBUILDING__Attribute_Name__c);
                        Map<String, String>mapAttNameIdTemp = WooCommerce_Connect.createAttributeToWoocommerce(objWA.Name, objWC);
                        mapAttNameId.putAll(mapAttNameIdTemp);
                        objWA.BOATBUILDING__WooCom_Attribute_Id__c = mapAttNameIdTemp.values()[0];
                    }
                }
            }
            List<Attachment> lstAttachment = [SELECT Id, Name, Body
                                            FROM Attachment
                                            WHERE ParentId =: strPartId];
                                            
            System.debug('Debug Log For lstAttachment: '+lstAttachment);
            List<ContentDocumentLink> lstContentDocLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:strPartId];
            System.debug('Debug Log For lstContentDocLink: '+lstContentDocLink);
            Set<String> setCDLId = new Set<String>();
            for(ContentDocumentLink cdl: lstContentDocLink){
                setCDLId.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> lstContentVersion = [select id,FileType, Title,FileExtension, Versiondata from ContentVersion where islatest=true AND ContentDocumentId IN : setCDLId];
            
            Map<String, String> mapAttBase64 = new Map<String, String>(); 
            if(!lstAttachment.isEmpty()) {
                for(Attachment objAtt: lstAttachment) {
                    if(objAtt.Body != null) {
                        String strBase64 = EncodingUtil.base64Encode(objAtt.Body);
                        System.debug('Debug Log for ATT strBase64: '+strBase64);
                        mapAttBase64.put(objAtt.Name, strBase64);
                    }
                }
            }   
            
            if(!lstContentVersion.isEmpty()) {
                for(ContentVersion objAtt: lstContentVersion) {
                    if(objAtt.Versiondata != null) {
                        String strBase64 = EncodingUtil.base64Encode(objAtt.Versiondata);
                        System.debug('Debug Log for strBase64: '+strBase64);
                        System.debug('Debug Log for objAtt.Title: '+objAtt.Title);
                        System.debug('Debug Log for objAtt.Title: '+objAtt.FileType);
                        mapAttBase64.put(objAtt.Title+'.'+objAtt.FileExtension, strBase64);
                    }
                }
            }   
            //System.debug('lstAttBase64---'+lstAttBase64); 
            String prntId = '0';
            
            if(String.isNotBlank(objPart.BOATBUILDING__Category1__c)) {
                //Callout Method
                WooCommerce_Connect.catagoryResponse += '\nbefore Callout\n';
                mapCollectionNameId = WooCommerce_Connect.getWooCommerceCategories(objWC, objPart.BOATBUILDING__Category1__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                WooCommerce_Connect.catagoryResponse += '\nafter Callout\n';
                System.debug('Debug Log for mapCollectionNameId C: '+mapCollectionNameId);
                String Category = objPart.BOATBUILDING__Category1__c.toUpperCase(); 
                WooCommerce_Connect.catagoryResponse += '   '+Category+'\n';
                if(!mapCollectionNameId.containsKey(Category)) {
                    //Callout Method
                    Map<String, String> mapNewCollection = WooCommerce_Connect.createCustomCategoryToWoocommerce(objPart.BOATBUILDING__Category1__c, objWC, prntId);
                    if(!mapNewCollection.isEmpty()){
                        mapCollectionNameId.putAll(mapNewCollection);
                        prntId = mapCollectionNameId.get(Category);
                    }
                } else {
                    prntId = mapCollectionNameId.get(Category);
                }
                
                //Calling Queueable
                WooCommerce_Connect_Process_3 objWooCommerce_Connect_Process_3 = new WooCommerce_Connect_Process_3(mapAttOption, mapAttNameOptionForPro, strPartId, lstWA, objWC, objPart, mapCollectionNameId, mapAttNameId, prntId, mapAttBase64);
                System.enqueueJob(objWooCommerce_Connect_Process_3);
            }
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