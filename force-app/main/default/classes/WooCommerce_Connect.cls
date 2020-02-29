global with sharing class WooCommerce_Connect {
    private static String catagoryResponse = '';
    private static String catagoryCreationResponse = '';
    private static String tagResponse = '';
    private static String tagCreationResponse = '';
    private static String imageResponse = '';
    private static String productCreationResponse = '';
    @AuraEnabled 
    global static String savePartsToWooComLightning(String strPartId) {
        Part__c objPart = [Select Id, BOATBUILDING__Part__c From Part__c Where Id =: strPartId];
        if(objPart.BOATBUILDING__Part__c == null) {
            savePartsToWooCommerce(strPartId);
            return 'SUCCESS';
        } else {
            return 'You cannot push part variant directly. Please go to parent part and try to push.';
        }
    }
     
    @future(callout=true) 
    webservice static void savePartsToWooCommerce(String strPartId) {
        Map<String, String> mapCollectionNameId = new Map<String, String>();
        try {
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                Part__c objPart = [Select 
                                   b.RecordTypeId, b.OwnerId, b.Name, b.BOATBUILDING__Vendor_Name__r.Name, b.Quantity__c,
                                   b.BOATBUILDING__Weight__c, b.Id,BOATBUILDING__Part__c, BOATBUILDING__Push_Image__c,
                                   b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__WooCommerce_Id__c,
                                   b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Vendor_Name__c, b.BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                   b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__SKU__c, b.BOATBUILDING__Retail_Price__c, b.Sub_Family__c,
                                   b.BOATBUILDING__Part_Size__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Cost__c, b.BOATBUILDING__Part_Color__c, 
                                   b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Location__c, b.BOATBUILDING__Family1__c, 
                                   b.BOATBUILDING__Discount__c, b.BOATBUILDING__Dealer_Price__c, b.BOATBUILDING__Category1__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Barcode__c,
                                    (
                                       Select
                                               RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
                                               BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,BOATBUILDING__Push_Image__c,
                                               BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c, BOATBUILDING__WooCommerce_Id__c,
                                               BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                               BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
                                               BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
                                               BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, 
                                               BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c
                                       From 
                                               Part_Variation__r
                                    )
                                   From 
                                   BOATBUILDING__Part__c b
                                   Where    
                                   Id =: strPartId];
                System.debug('Debug Log For objPart: '+objPart);
                Set<String> setPVId = new Set<String>(); 
                if(!objPart.Part_Variation__r.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        setPVId.add(objPrt.Id); 
                    }
                }
                Map<String, Map<String,Set<String>>> mapAttOption = new Map<String, Map<String,Set<String>>>();
                Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
                List<BOATBUILDING__Woocom_Variant_Option__c> lstWVO = [Select 
                                                                                Id, Name, BOATBUILDING__Option__c, BOATBUILDING__Part__c, BOATBUILDING__Woocommerce_Attribute__c
                                                                        From 
                                                                                BOATBUILDING__Woocom_Variant_Option__c 
                                                                        Where 
                                                                                BOATBUILDING__Part__c IN: setPVId];
                System.debug('Debug Log For lstWVO: '+lstWVO);
                
                Map<String, String> MapWVO_PId = new Map<String, String>(); 
                if(!lstWVO.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        for(BOATBUILDING__Woocom_Variant_Option__c objWVO: lstWVO) {
                            if(objWVO.BOATBUILDING__Part__c == objPrt.Id) {
                                MapWVO_PId.put(objWVO.BOATBUILDING__Woocommerce_Attribute__c, objWVO.BOATBUILDING__Part__c);
                            }
                        }
                    }
                }
                
                List<BOATBUILDING__Woocommerce_Attribute__c> lstWA = [Select 
                                                                                Id, Name, BOATBUILDING__WooCom_Attribute_Id__c 
                                                                        From 
                                                                                BOATBUILDING__Woocommerce_Attribute__c 
                                                                        Where 
                                                                                Id IN: MapWVO_PId.keySet()];
                
                
                System.debug('Debug Log For lstWA: '+lstWA);
                
                if(!lstWA.isEmpty()) {
                    for(Part__c objPrt: objPart.Part_Variation__r) {
                        if(!mapAttOption.containsKey(objPart.Id)) {
                            mapAttOption.put(objPrt.Id, new Map<String, Set<String>>());
                        }
                        if(mapAttOption.containsKey(objPrt.Id)) {
                            for(Woocommerce_Attribute__c objWA: lstWA) {
                                for(BOATBUILDING__Woocom_Variant_Option__c objWVO: lstWVO) {
                                    if(objWVO.BOATBUILDING__Woocommerce_Attribute__c == objWA.Id && objWVO.Part__c == objPrt.Id) {          
                                        if(!mapAttOption.get(objPrt.Id).containsKey(objWA.Name)) {
                                            mapAttOption.get(objPrt.Id).put(objWA.Name, new Set<String>());
                                            if(!mapAttNameOptionForPro.containsKey(objWA.Name))
                                                mapAttNameOptionForPro.put(objWA.Name, new Set<String>());
                                        }
                                        if(mapAttOption.get(objPrt.Id).containsKey(objWA.Name)) {
                                            mapAttOption.get(objPrt.Id).get(objWA.Name).add(objWVO.Option__c);
                                            if(mapAttNameOptionForPro.containsKey(objWA.Name))
                                                mapAttNameOptionForPro.get(objWA.Name).add(objWVO.Option__c);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                System.debug('Debug Log For mapAttOption: '+mapAttOption);
                System.debug('Debug Log For mapAttNameOptionForPro: '+mapAttNameOptionForPro);
                 
                
                Map<String, String> mapAttNameId = getAllAttribute(objWC);
                Set<String> setAttNameToCreate = new Set<String>();
                if(!lstWA.isEmpty()) {
                    for(Woocommerce_Attribute__c objWA: lstWA) {
                        //System.debug('Debug Log for mapAttNameId in: '+mapAttNameId);
                        if(mapAttNameId.containsKey(objWA.Name.toUpperCase()) && String.isBlank(objWA.BOATBUILDING__WooCom_Attribute_Id__c)) {
                            objWA.BOATBUILDING__WooCom_Attribute_Id__c = mapAttNameId.get(objWA.Name.toUpperCase());
                        } 
                        if(!mapAttNameId.containsKey(objWA.Name.toUpperCase())){
                            //setAttNameToCreate.add(objWA.BOATBUILDING__Attribute_Name__c);
                            Map<String, String>mapAttNameIdTemp = createAttributeToWoocommerce(objWA.Name, objWC);
                            mapAttNameId.putAll(mapAttNameIdTemp);
                            objWA.BOATBUILDING__WooCom_Attribute_Id__c = mapAttNameIdTemp.values()[0];
                        }
                    }
                } 
                
                System.debug('Debug Log For mapAttNameId: '+mapAttNameId);
                
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
                    mapCollectionNameId = getWooCommerceCategories(objWC, objPart.BOATBUILDING__Category1__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                    System.debug('Debug Log for mapCollectionNameId C: '+mapCollectionNameId);
                    String Category = objPart.BOATBUILDING__Category1__c.toUpperCase(); 
                    if(!mapCollectionNameId.containsKey(Category)) {
                        Map<String, String> mapNewCollection = createCustomCategoryToWoocommerce(objPart.BOATBUILDING__Category1__c, objWC, prntId);
                        if(!mapNewCollection.isEmpty()){
                            mapCollectionNameId.putAll(mapNewCollection);
                            prntId = mapCollectionNameId.get(Category);
                        }
                    } else {
                        prntId = mapCollectionNameId.get(Category);
                    }
                    
                    //String tag = '';
                    //String tag1 = '';
                    
                    Map<String, String> mapTagNameId = new Map<String, String>();
                    if(objPart.Family1__c != null) {
                        Map<String, String> mapCollectionNameIdFam = getWooCommerceCategories(objWC, objPart.Family1__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                        mapCollectionNameId.putAll(mapCollectionNameIdFam);
                        System.debug('Debug Log for mapCollectionNameId F: '+mapCollectionNameId);
                        String Family = objPart.Family1__c.toUpperCase(); 
                        if(!mapCollectionNameId.containsKey(Family)) {
                            Map<String, String> mapNewCollection = createCustomCategoryToWoocommerce(objPart.Family1__c, objWC, prntId);
                            if(!mapNewCollection.isEmpty()){
                                mapCollectionNameId.putAll(mapNewCollection);
                                prntId = mapCollectionNameId.get(Family);
                            }
                        } else {
                            prntId = mapCollectionNameId.get(Family);
                        }
                         
                        if(objPart.Sub_Family__c != null) {
                            Map<String, String> mapCollectionNameIdSBFam = getWooCommerceCategories(objWC, objPart.Sub_Family__c, prntId);// objPart.BOATBUILDING__Category1__c.toUpperCase()
                            mapCollectionNameId.putAll(mapCollectionNameIdSBFam);
                            System.debug('Debug Log for mapCollectionNameId SF: '+mapCollectionNameIdSBFam);
                            String SubFamily = objPart.Sub_Family__c.toUpperCase(); 
                            if(!mapCollectionNameId.containsKey(SubFamily)) {
                                Map<String, String> mapNewCollection = createCustomCategoryToWoocommerce(objPart.Sub_Family__c, objWC, prntId);
                                if(!mapNewCollection.isEmpty()){
                                    mapCollectionNameId.putAll(mapNewCollection);
                                }
                            }
                        }
                        
                    }
                     System.debug('Debug Log for After Add mapCollectionNameId: '+mapCollectionNameId);
                    
                    //System.debug('Debug Log for After Add mapTagNameId: '+mapTagNameId);
                    List<String> lstURL = new List<String>();
                    if(objPart.BOATBUILDING__Push_Image__c)
                    	lstURL = uploadImage(mapAttBase64, objWC);
                    	        
                    System.debug('Debug Log for lstURL: '+lstURL);
                    String wooComProductId = pushPartToWooCommerce(objPart, objWC, mapCollectionNameId, mapTagNameId, lstURL, mapAttNameOptionForPro, mapAttNameId);
                     
                    if(String.isNotBlank(wooComProductId)) {
                        objPart.BOATBUILDING__WooCommerce_Id__c = wooComProductId;
                        
                        //Variaton Check
                        List<Part__c> lstPart = pushPartVariation(objPart, objWC, mapAttOption, mapAttNameId);
                        objPart.BOATBUILDING__Push_Image__c = false;
                        update objPart;
                        
                        if(!lstPart.isEmpty())
                            update lstPart;
                    }
                    update lstWA;
                    System_Configure__c objSC = System_Configure__c.getOrgDefaults();
                     if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                        BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                        objCL.Name = 'Woocommerce Log';
                        objCL.BOATBUILDING__Summary__c = '' + catagoryResponse + '  >>>  \n\n'+catagoryCreationResponse + '  >>>  \n\n '+tagResponse + '  >>>  \n\n '+tagCreationResponse + '  >>>  \n\n '+imageResponse + '  >>>  \n\n '+productCreationResponse+'\n\n\n\n\n Product Id: '+wooComProductId+'\n\n\n\n\n mapCollectionNameId:'+mapCollectionNameId;
                        insert objCL;
                     }
                }
            }
            
        } catch(Exception ex) {
            System.debug('Email For Woocom: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            //SendEmailUtility.sendQuickEmail('Email For Woocom: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString());
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log';
                objCL.BOATBUILDING__Summary__c = '' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()+'\n\n\n------'+'' + catagoryResponse + '  >>>  \n\n'+catagoryCreationResponse + '  >>>  \n\n '+tagResponse + '  >>>  \n\n '+tagCreationResponse + '  >>>  \n\n '+imageResponse + '  >>>  \n\n '+productCreationResponse; 
                insert objCL;
             }
            //return 'Email For Woocom: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString();
        }
    }
    
    public static Map<String, String> getAllAttribute(BOATBUILDING__WooCmmerce_Config__c objWC) {
        Map<String, String> mapAttNameId = new Map<String, String>();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET'); 
        req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/attributes?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
        req.setTimeout(120000);
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        System.debug('Debug Log For res: '+res.getBody());
        List<WoocommerceAttributes> lstWoocommerceAttributes = WoocommerceAttributes.parse(res.getBody());
        for(WoocommerceAttributes objWoocommerceAttributes: lstWoocommerceAttributes) {
            mapAttNameId.put(objWoocommerceAttributes.name.toUpperCase(), String.valueOf(objWoocommerceAttributes.Id));
        }
        return mapAttNameId;
    }
    
    public static Map<String, String> createAttributeToWoocommerce(String strAttTitle, BOATBUILDING__WooCmmerce_Config__c objWC) {
        try {
            Map<String, String> mapCollectionNameId = new Map<String, String>();
            String  str_Att_JSON = '{';
            str_Att_JSON += '"name":"'+strAttTitle+'",';
            str_Att_JSON += '"type": "select",';
            str_Att_JSON += '"order_by": "menu_order",';
            str_Att_JSON += '"has_archives": false';
            str_Att_JSON += '}';
            System.debug('Log str_Att_JSON: '+str_Att_JSON);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setheader('Content-Type', 'application/json');
            req.setBody(str_Att_JSON);
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/attributes?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
            req.setTimeout(120000);
            Http h = new Http(); 
            HttpResponse res = h.send(req); 
            System.debug('>>>Product Att: '+res.getBody()); 
            Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());    
            String strId = String.valueOf(mapRepdata.get('id'));
            String strName = String.valueOf(mapRepdata.get('name'));
            mapCollectionNameId.put(strName.toUpperCase(), strId);
            
            return mapCollectionNameId;
        } catch(Exception ex) {
            System.debug('Exception: '+ex);
            return null;
        }
    }
    
    public static List<Part__c> pushPartVariation(Part__c objPart, BOATBUILDING__WooCmmerce_Config__c objWC, Map<String, Map<String, Set<String>>> mapAttOption, Map<String, String> mapAttNameId) {
        List<Part__c> lstPart = new List<Part__c>();
        
        
        
        if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
            if(!objPart.Part_Variation__r.isEmpty()) {
                
                Map<String, Map<String, String>> mapLstData = new Map<String, Map<String, String>>(); 
                for(Part__c objPartVar: objPart.Part_Variation__r) {
                    mapLstData.put(objPartVar.Id, new Map<String, String>());
                }
                List<Attachment> lstAttachment = [SELECT Id, Name, Body, ParentId
                                                  FROM Attachment
                                                  WHERE ParentId IN: mapLstData.keySet()];
                
                List<ContentDocumentLink> lstContentDocLink = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: mapLstData.keySet()];
                //Set<String> setCDLId = new Set<String>();
                Map<String, String> mapCDID_LEID = new Map<String, String>(); 
                for(ContentDocumentLink cdl: lstContentDocLink){
                    //setCDLId.add(cdl.ContentDocumentId);
                    mapCDID_LEID.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                }
                
                List<ContentVersion> lstContentVersion = [select id,FileType, Title,FileExtension, Versiondata, ContentDocumentId from ContentVersion where islatest = true AND ContentDocumentId IN : mapCDID_LEID.keySet()];
                
                Map<String, String> mapAttBase64 = new Map<String, String>(); 
                if(!lstAttachment.isEmpty()) {
                    for(Attachment objAtt: lstAttachment) {
                        if(objAtt.Body != null) {
                            String strBase64 = EncodingUtil.base64Encode(objAtt.Body);
                            System.debug('Debug Log for ATT strBase64: '+strBase64);
                            //mapAttBase64.put(objAtt.Name, strBase64);
                            mapLstData.get(objAtt.ParentId).put(objAtt.Name, strBase64);
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
                            //mapAttBase64.put(objAtt.Title+'.'+objAtt.FileExtension, strBase64);
                            mapLstData.get(mapCDID_LEID.get(objAtt.ContentDocumentId)).put(objAtt.Title+'.'+objAtt.FileExtension, strBase64);
                        }
                    }
               }
               Map<String, List<String>> mapSrtListForImage = new Map<String, List<String>>();
               if(objPart.BOATBUILDING__Push_Image__c) {
	               for(String strkey: mapLstData.keySet()) {
	                    List<String> lstURL = uploadImage(mapLstData.get(strkey), objWC);
	                    mapSrtListForImage.put(strkey, lstURL);
	               }
               }
                
                
                if(!objPart.Part_Variation__r.isEmpty()) {
                        WooCommerceProductVar_Connect objWooCommerceProductVar_Connect = new WooCommerceProductVar_Connect(objPart.Part_Variation__r, 
                                                                                                                        objPart.BOATBUILDING__WooCommerce_Id__c, 
                                                                                                                            mapSrtListForImage, 
                                                                                                                                objWC, 
                                                                                                                                    mapAttOption, 
                                                                                                                                        mapAttNameId);
                        System.enqueueJob(objWooCommerceProductVar_Connect);
                }
            }    
        }
        return lstPart;
    }
    
    /*private static String pushPartVariantToWooCommerce(Part__c objPart, String strPrntProductId, BOATBUILDING__WooCmmerce_Config__c objWC, List<String> lstImgUrl, 
                                                                        Map<String, Set<String>> mapAttNameOptionForPro, Map<String, String> mapAttNameId) {
        
        String strAttJSON = '';
        System.debug('Debug log for mapAttNameOptionForPro in pro cre: '+mapAttNameOptionForPro);
        System.debug('Debug log for mapAttNameId in pro cre: '+mapAttNameId);
        if(!mapAttNameOptionForPro.isEmpty()) {
            strAttJSON = '"attributes": [';
            Integer count = 0;
            for(String strAttName: mapAttNameOptionForPro.keySet()) {
                strAttJSON += '{';
                strAttJSON +=   '"id": ' + mapAttNameId.get(strAttName.toUpperCase()) + ',';
                strAttJSON +=   '"option": ';
                if(mapAttNameOptionForPro.get(strAttName).size() > 0 ) {
                    for(String strOption: mapAttNameOptionForPro.get(strAttName)) {
                        strAttJSON +=   '"'+strOption.replaceAll('"','\\\\"').replaceAll('\n', ' ')+'"';
                    }
                }
                strAttJSON +=   '';
                strAttJSON += '},';
                count++;
            }
            
            strAttJSON = strAttJSON.subString(0, strAttJSON.length()-1);
            strAttJSON += ']';
        }
        
        String Title = objPart.Name;
        String Product_Type = objPart.BOATBUILDING__Category1__c;
        String Vendor = '';
        String Pricing = '0.00';
        String Compare_Price = '0.00';
        String SKU = '';
        String Barcode = '';
        Boolean This_is_a_Physical_Product = objPart.BOATBUILDING__This_is_a_Physical_Product__c;
        String Weight = '0';
        String Images = '';
        String Quantity = '0';
        String Description = '';
        String partCost = '0.00';
        String partNumber = '';
        String DlrPricing = '';
        String WooComId = '';
        
        if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
            WooComId = objPart.BOATBUILDING__WooCommerce_Id__c;
        }
        
        if(objPart.Vendor_Name__c != null) {
            Vendor = objPart.Vendor_Name__r.Name;
        }
        
        if(objPart.BOATBUILDING__Web_Price__c != null) {
            Pricing = String.valueOf(objPart.BOATBUILDING__Web_Price__c);
        }
        if(objPart.BOATBUILDING__Dealer_Price__c != null) {
            DlrPricing = String.valueOf(objPart.BOATBUILDING__Dealer_Price__c);
        }
        
        if(objPart.SKU__c != null) {
            SKU = objPart.SKU__c;
        }
        if(objPart.BOATBUILDING__Part_Number__c != null) {
            Barcode = objPart.BOATBUILDING__Part_Number__c;
        }
        
        if(objPart.Weight__c != null && objPart.Weight__c.containsIgnoreCase('lbs')) {
            Weight = objPart.Weight__c.toLowerCase().replace('lbs','');
        } else {
            Weight = objPart.Weight__c; 
        }
        
        if(objPart.Quantity__c != null) {
            Quantity = String.valueOf(objPart.Quantity__c);
        }
        if(objPart.BOATBUILDING__Web_Description_long__c != null) {
            Description = String.valueOf(objPart.BOATBUILDING__Web_Description_long__c).replaceAll('\r\n', ' ');
        }
        
        if(objPart.BOATBUILDING__Part_Cost__c != null) {  
            partCost = String.valueOf(objPart.BOATBUILDING__Part_Cost__c);
        }
        
        String Attachment = '';
        
        if(!lstImgUrl.isEmpty()) {
            Attachment = '"images": [';
            for(String strUrl: lstImgUrl) {
                Attachment += '{';
                Attachment +=   '"src": "' + strUrl + '"';
                Attachment += '},';
            }
            
            Attachment = Attachment.subString(0, Attachment.length()-1);
            Attachment += ']';
        }
        
        String str_Product_JSON =   '{';
        
        str_Product_JSON +=                     '"name": "' + Title.replaceAll('"','\\\\"') + '",';
        
        if(Description != '')
            str_Product_JSON +=                     '"description": "' + Description.replaceAll('"','\\\\"').replaceAll('\n', ' ') + '",';
        if(SKU != '') 
            str_Product_JSON +=                     '"sku": "' + SKU.replaceAll('"','\\\\"') + '",';
        str_Product_JSON +=                     '"regular_price": "' + Pricing + '",';
        
        str_Product_JSON +=                     '"stock_quantity": "' + Quantity + '",';
        
        str_Product_JSON +=                     '"manage_stock": true,';
        
        if(Integer.valueOf(Quantity) > 0) {
            str_Product_JSON +=                     '"stock_status": "instock",';   
        } else {
            str_Product_JSON +=                     '"stock_status": "outofstock",'; 
        }
        
        
        str_Product_JSON +=                     '"sale_price": "' + DlrPricing + '",';
        str_Product_JSON +=                     '"price": "' + partCost + '"';
        
        if(Description != '')
            str_Product_JSON +=                     ', "short_description": "' + Description.replaceAll('"','\\\\"').replaceAll('\n', ' ') + '"';
        
        if(Attachment != '') { 
            str_Product_JSON +=                             ',';
            str_Product_JSON += Attachment;
        } 
        if(strAttJSON != '') { 
            str_Product_JSON +=                             ',';
            str_Product_JSON += strAttJSON;
        }
        str_Product_JSON +=         '}';
        
        System.debug('str_Product_JSON: '+str_Product_JSON);
        
        HttpRequest req = new HttpRequest();
        if(String.isNotBlank(WooComId)) {
            req.setMethod('PUT');
        } else {
            req.setMethod('POST');
        }
        
        req.setheader('Content-Type', 'application/json');
        req.setBody(str_Product_JSON);
        if(String.isNotBlank(WooComId)) {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/'+strPrntProductId+'/variations/'+WooComId+'?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
        } else {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/'+strPrntProductId+'/variations?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
        }
        req.setTimeout(120000);
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        System.debug('>>>Product Creation: '+res.getBody());
        productCreationResponse = 'Product Var Creation Response: '+res.getBody();
        productCreationResponse += '          Product Var str_Product_JSON: '+str_Product_JSON;
        Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());    
        return String.valueOf(mapRepdata.get('id'));
        
    }*/
    
    public static Map<String, String> getWooCommerceCategories(BOATBUILDING__WooCmmerce_Config__c objWC, String searchCat, String strPrntId) {
        Map<String, String> mapCategoriesNameId = new Map<String, String>();
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        //searchCat = String.escapeSingleQuotes(searchCat);
        searchCat = searchCat.toLowerCase();
        searchCat = searchCat.replaceAll(' ', '+').replaceAll('\'', '%27');//.toLowerCase().remove('\'').replaceAll('[^a-zA-Z0-9\\s+]', ' ').normalizeSpace().replaceAll(' ', '-'); %27
        System.debug('>>>>: '+searchCat); 
        if(String.isBlank(strPrntId)) {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/categories?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c+'&search='+searchCat+'&per_page=100');//engine-parts
        } else {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/categories?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c+'&search='+searchCat+'&parent='+strPrntId+'&per_page=100');//engine-parts
        }
        System.debug('>>>>>>req.setEndPoint: '+req.getEndPoint());
        req.setTimeout(120000);
        Http h = new Http(); 
        HttpResponse res = h.send(req); 
        System.debug('>>>Product Categories: '+res);
        System.debug('>>>Product Categories: '+res.getBody());
        catagoryResponse += 'Product Categories Response: '+res.getBody();
        List<AllWooComCategories> lstAllWooComCategories = AllWooComCategories.parse(res.getBody());
        System.debug('lstAllWooComCategories---'+lstAllWooComCategories);
        for(AllWooComCategories objAllWooComCategories: lstAllWooComCategories) { 
            mapCategoriesNameId.put(objAllWooComCategories.name.replace('&amp;', '&').toUpperCase(), String.valueOf(objAllWooComCategories.Id));
        }
        System.debug('mapCategoriesNameId---'+mapCategoriesNameId);
        catagoryResponse += 'Product Categories Response: '+res.getBody()+'\n\n\n\n\nMap: '+mapCategoriesNameId;
        return mapCategoriesNameId;
    }
    
    public static Map<String, String> createCustomCategoryToWoocommerce(String strCategoryTitle, BOATBUILDING__WooCmmerce_Config__c objWC, String prntId) {
        try {
            Map<String, String> mapCollectionNameId = new Map<String, String>();
            String  str_Collection_JSON = '{'; 
            str_Collection_JSON += '"name":"'+strCategoryTitle+'"';
            if(String.isNotBlank(prntId)) {
                str_Collection_JSON += ',"parent":"'+prntId+'"';
            }
            str_Collection_JSON += '}';
            System.debug('Log str_Collection_JSON: '+str_Collection_JSON);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setheader('Content-Type', 'application/json');
            req.setBody(str_Collection_JSON);
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/categories?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
            req.setTimeout(120000);
            Http h = new Http(); 
            HttpResponse res = h.send(req); 
            System.debug('>>>Product Categories: '+res.getBody()); 
            catagoryCreationResponse = 'str_Collection_JSON ' + str_Collection_JSON + 'Product Categories Creation Response: '+res.getBody();
            Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());    
            String strId = String.valueOf(mapRepdata.get('id'));
            String strName = String.valueOf(mapRepdata.get('name'));
            mapCollectionNameId.put(strName.toUpperCase(), strId);
            
            return mapCollectionNameId;
        } catch(Exception ex) {
            System.debug('Exception: '+ex);
            return null;
        }
    }
    
    public static Map<String, String> getWooCommerceTags(BOATBUILDING__WooCmmerce_Config__c objWC, String searchTag) {
        Map<String, String> mapTagNameId = new Map<String, String>();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        searchTag = searchTag.toLowerCase().remove('\'').replaceAll('[^a-zA-Z0-9\\s+]', ' ').normalizeSpace().replaceAll(' ', '-');
        System.debug('>>>Product searchTag: '+searchTag);
        req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/tags?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c+'&search='+searchTag);
        req.setTimeout(120000);
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        System.debug('>>>Product Tags: '+res.getBody());
        tagResponse = 'Product Tag Response: '+res.getBody();
        List<AllWooComTags> lstAllWooComTags = AllWooComTags.parse(res.getBody());
        for(AllWooComTags objAllWooComTags: lstAllWooComTags) {
            if(objAllWooComTags.name.toUpperCase().containsIgnoreCase('&AMP;')) {
                mapTagNameId.put(objAllWooComTags.name.toUpperCase().replace('&AMP;', '&'), String.valueOf(objAllWooComTags.Id));
            } else {
                mapTagNameId.put(objAllWooComTags.name.toUpperCase(), String.valueOf(objAllWooComTags.Id));
            }
        }
        return mapTagNameId;
    }
    
    public static Map<String, String> createCustomTagToWoocommerce(String strFamilyTitle, BOATBUILDING__WooCmmerce_Config__c objWC) {
        try {
            Map<String, String> mapTagNameId = new Map<String, String>();
            String  str_Tag_JSON = '{';
            str_Tag_JSON += '"name":"'+strFamilyTitle+'"';
            str_Tag_JSON += '}';
            System.debug('Log str_Tag_JSON: '+str_Tag_JSON);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setheader('Content-Type', 'application/json');
            req.setBody(str_Tag_JSON);
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/tags?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
            req.setTimeout(120000);
            Http h = new Http(); 
            HttpResponse res = h.send(req); 
            System.debug('>>>Product Tag: '+res.getBody()); 
            tagCreationResponse = 'Product Tag Creation Response: '+res.getBody();
            Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());    
            String strId = String.valueOf(mapRepdata.get('id'));
            String strName = String.valueOf(mapRepdata.get('name'));
            mapTagNameId.put(strName.toUpperCase(), strId);
            
            return mapTagNameId;
        } catch(Exception ex) {
            System.debug('Exception: '+ex);
            return null;
        }
    }
    
    private static List<String> uploadImage(Map<String, String> mapAttBase64, BOATBUILDING__WooCmmerce_Config__c objWC) {
        List<String> lstURL = new List<String>();
        
        for(String strImg: mapAttBase64.keySet()) {
            
            String boundary = '----------------------------741e90d31eff';
            String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+strImg+'";\nContent-Type: application/octet-stream';
            // GW: Do not prepend footer with \r\n, you'll see why in a moment
            // String footer = '\r\n--'+boundary+'--'; 
            String footer = '--'+boundary+'--';             
            String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
            while(headerEncoded.endsWith('=')){
                header+=' ';
                headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
            }
            String bodyEncoded = mapAttBase64.get(strImg);
            // GW: Do not encode footer yet
            // String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            
            Blob bodyBlob = null;
            String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
            // GW: replacement section to get rid of padding without corrupting data
            if(last4Bytes.endsWith('==')) {
                last4Bytes = last4Bytes.substring(0,2) + '0K';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                // We have appended the \r\n to the Blob, so leave footer as it is.
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            } else if(last4Bytes.endsWith('=')) {
                last4Bytes = last4Bytes.substring(0,3) + 'N';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                // We have appended the CR e.g. \r, still need to prepend the line feed to the footer
                footer = '\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
            } else {
                // Prepend the CR LF to the footer
                footer = '\r\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
            }
            System.debug('bodyBlob: '+bodyBlob);
            System.debug('multipart/form-data; boundary='+boundary);
            System.debug('Content-Length: '+String.valueof(bodyBlob.size()));
            
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            String authStr = objWC.BOATBUILDING__User_Name__c+':'+objWC.BOATBUILDING__Password__c;
            String covStr = EncodingUtil.base64Encode(Blob.valueOf(authStr));
            req.setHeader('Authorization', 'Basic '+covStr);
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wp/v2/media');
            req.setTimeout(120000);
            req.setBodyAsBlob(bodyBlob);
            req.setHeader('Content-Length',String.valueof(req.getBodyAsBlob().size()));
            
            Http h = new Http(); 
            HttpResponse res = h.send(req);
            System.debug('Response: '+res.getBody());
            imageResponse = 'Image Response: '+res.getBody();
            FileUploadJsonToApex objFileUploadJsonToApex = FileUploadJsonToApex.parse(res.getBody());
            System.debug('objFileUploadJsonToApex.guid.rendered: '+objFileUploadJsonToApex.guid.rendered);
            lstURL.add(objFileUploadJsonToApex.guid.rendered);
        }
        return lstURL;
    }
    
    
    @AuraEnabled
    global static String uploadImage(String strPartId) {
        try {
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                Part__c objPart = [Select 
                                   BOATBUILDING__WooCommerce_Id__c, Id 
                                   From 
                                   BOATBUILDING__Part__c b
                                   Where    
                                   Id =: strPartId];
                
                List<Attachment> lstAttachment = [SELECT 
                                                  Id,
                                                  Name,
                                                  Body
                                                  FROM
                                                  Attachment
                                                  WHERE
                                                  ParentId =: strPartId];
                
                List<ContentDocumentLink> lstContentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:strPartId];
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
                if(String.isNotBlank(objPart.BOATBUILDING__WooCommerce_Id__c) && !mapAttBase64.isEmpty()) {
                    //uploadImages(objPart.BOATBUILDING__WooCommerce_Id__c, mapAttBase64);
                } else {
                    if(String.isBlank(objPart.BOATBUILDING__WooCommerce_Id__c)) {
                        return 'Please push part to woocoomerce first.';
                    } else if(mapAttBase64.isEmpty()) {
                        return 'This part doesn\'t has image.';
                    }
                }
            }
            return 'SUCCESS';
        } 
        catch(Exception ex) {
            System.debug('Exception: '+ex);
            return ex.getLineNumber()+'\n--\n'+ex.getStackTraceString();
        }
    } 
    
    
        
    @AuraEnabled 
    global static String savePartsToWooComLightning() {
        //savePartsToWooCommerce(strPartId);
        return 'SUCCESS';
    }
    
    private static String pushPartToWooCommerce(Part__c objPart, BOATBUILDING__WooCmmerce_Config__c objWC, Map<String, String> mapCollectionNameId, 
                                                        Map<String, String> mapTagNameId, List<String> lstImgUrl, Map<String, Set<String>> mapAttNameOptionForPro, Map<String, String> mapAttNameId) {
        
        String strAttJSON = '';
        System.debug('Debug log for mapAttNameOptionForPro in pro cre: '+mapAttNameOptionForPro);
        System.debug('Debug log for mapAttNameId in pro cre: '+mapAttNameId);
        if(!mapAttNameOptionForPro.isEmpty()) {
            strAttJSON = '"attributes": [';
            Integer count = 0;
            for(String strAttName: mapAttNameOptionForPro.keySet()) {
                strAttJSON += '{';
                strAttJSON +=   '"id": ' + mapAttNameId.get(strAttName.toUpperCase()) + ',';
                strAttJSON +=   '"position": "' + count + '",';
                strAttJSON +=   '"visible": true,';
                strAttJSON +=   '"variation": true,';
                strAttJSON +=   '"options": [';
                if(mapAttNameOptionForPro.get(strAttName).size() > 0 ) {
                    for(String strOption: mapAttNameOptionForPro.get(strAttName)) {
                        strAttJSON +=   '"'+strOption.replaceAll('"','\\\\"').replaceAll('\n', ' ')+'",';
                    }
                    strAttJSON  = strAttJSON.subString(0, strAttJSON.length()-1);
                }
                strAttJSON +=   ']';
                strAttJSON += '},';
                count++;
            }
            
            strAttJSON = strAttJSON.subString(0, strAttJSON.length()-1);
            strAttJSON += ']';
        }
        
        
        
        String Attachment = '';
        
        if(!lstImgUrl.isEmpty()) {
            Attachment = '"images": [';
            for(String strUrl: lstImgUrl) {
                Attachment += '{';
                Attachment +=   '"src": "' + strUrl + '"';
                Attachment += '},';
            }
            
            Attachment = Attachment.subString(0, Attachment.length()-1);
            Attachment += ']';
        }
        
        String Title = objPart.Name;
        String Product_Type = objPart.BOATBUILDING__Category1__c;
        String Vendor = '';
        String Tags = '';
        String Pricing = '0.00';
        String Compare_Price = '0.00';
        String SKU = '';
        String Barcode = '';
        Boolean This_is_a_Physical_Product = objPart.BOATBUILDING__This_is_a_Physical_Product__c;
        String Weight = '0';
        String Images = '';
        String Quantity = '0';
        String Description = '';
        String partCost = '0.00';
        String partNumber = '';
        String Category = '';
        String DlrPricing = '';
        String WooComId = '';
        String proType = '';
        
        if(!objPart.Part_Variation__r.isEmpty()) {
            proType = 'variable';
        } else {
            proType = 'simple';
        }
        
        if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
            WooComId = objPart.BOATBUILDING__WooCommerce_Id__c;
        }
        
        if(objPart.Vendor_Name__c != null) {
            Vendor = objPart.Vendor_Name__r.Name;
        }
        
        if(objPart.BOATBUILDING__Web_Price__c != null) {
            Pricing = String.valueOf(objPart.BOATBUILDING__Web_Price__c);
        }
        if(objPart.BOATBUILDING__Dealer_Price__c != null) {
            DlrPricing = String.valueOf(objPart.BOATBUILDING__Dealer_Price__c);
        }
        
        if(objPart.SKU__c != null) {
            SKU = objPart.SKU__c;
        }
        if(objPart.BOATBUILDING__Part_Number__c != null) {
            Barcode = objPart.BOATBUILDING__Part_Number__c;
        }
        
        if(objPart.Weight__c != null && objPart.Weight__c.containsIgnoreCase('lbs')) {
            Weight = objPart.Weight__c.toLowerCase().replace('lbs','');
        } else {
            Weight = objPart.Weight__c; 
        }
        if(objPart.Part_Variation__r.isEmpty()) {
            if(objPart.Quantity__c != null) {
                Quantity = String.valueOf(objPart.Quantity__c);
            }
            System.debug('>>>QuantitySSS: '+Quantity);
        } else {
            Integer Quant = 0;
            for(Part__c objPrt: objPart.Part_Variation__r) {
                if(objPrt.Quantity__c != null) {
                    Quant += Integer.valueOf(objPrt.Quantity__c); 
                    System.debug('>>>Quant: '+Quant);
                }
            }
            Quantity = String.valueOf(Quant);
            System.debug('>>>Quantity: '+Quantity);
        }
        System.debug('>>>Quantity: '+Quantity);
        if(objPart.BOATBUILDING__Web_Description_long__c != null) {
            Description = String.valueOf(objPart.BOATBUILDING__Web_Description_long__c).replaceAll('\r\n', '\\\\n');
        }
        
        if(objPart.BOATBUILDING__Part_Cost__c != null) {  
            partCost = String.valueOf(objPart.BOATBUILDING__Part_Cost__c);
        }
        
        
        if(mapCollectionNameId != null && !mapCollectionNameId.keySet().isEmpty() && mapCollectionNameId.containsKey(objPart.BOATBUILDING__Category1__c.toUpperCase())) {
            Category = '"categories": [';
            for(String strName: mapCollectionNameId.keySet()) {
                if(objPart.BOATBUILDING__Category1__c.toUpperCase() == strName) {
                    Category += '{';
                    Category +=     '"id": "' + mapCollectionNameId.get(strName) + '"';
                    Category += '},';
                }
                if(objPart.BOATBUILDING__Family1__c != null
                    && mapCollectionNameId.containsKey(objPart.BOATBUILDING__Family1__c.toUpperCase()) 
                        && objPart.BOATBUILDING__Family1__c.toUpperCase() == strName) {
                    Category += '{';
                    Category +=     '"id": "' + mapCollectionNameId.get(strName) + '"';
                    Category += '},';
                }
                if(objPart.BOATBUILDING__Sub_Family__c != null 
                    && mapCollectionNameId.containsKey(objPart.BOATBUILDING__Sub_Family__c.toUpperCase()) 
                        && objPart.BOATBUILDING__Sub_Family__c.toUpperCase() == strName) {
                    Category += '{';
                    Category +=     '"id": "' + mapCollectionNameId.get(strName) + '"';
                    Category += '},';
                }
            } 
            
            Category = Category.subString(0, Category.length()-1);
            Category += ']';
        }
        
        if(!mapTagNameId.isEmpty()) {
            Tags = '"tags": [';
            for(String strName: mapTagNameId.keySet()) {
                System.debug('Log in loop strName: '+strName);
                System.debug('Log in loop objPart.Family1__c: '+objPart.Family1__c);
                System.debug('Log in loop objPart.Sub_Family__c: '+objPart.Sub_Family__c);
                if(objPart.Family1__c != null && objPart.Family1__c.toUpperCase() == strName) {
                    Tags += '{';
                    Tags +=     '"id": "' + mapTagNameId.get(strName) + '"';
                    Tags += '},';
                } 
                if(objPart.Sub_Family__c != null && objPart.Sub_Family__c.toUpperCase() == strName) {
                    Tags += '{';
                    Tags +=     '"id": "' + mapTagNameId.get(strName) + '"';
                    Tags += '},';
                }
            }
            System.debug('>>>>> Tags1: '+Tags);
            Tags = Tags.subString(0, Tags.length()-1);
            Tags += ']';
        }
        System.debug('>>>>> Tags2: '+Tags);
        String str_Product_JSON =   '{';
         
        str_Product_JSON +=                     '"name": "' + Title.replaceAll('"','\\\\"') + '",';
        
        if(Description != '')
            str_Product_JSON +=                     '"description": "' + Description.replaceAll('"','\\\\"').replaceAll('\n', ' ') + '",';
        if(SKU != '') 
            str_Product_JSON +=                     '"sku": "' + SKU.replaceAll('"','\\\\"') + '",';
        str_Product_JSON +=                     '"regular_price": "' + Pricing + '",';
        if(String.isNotBlank(DlrPricing))
        	str_Product_JSON +=                     '"sale_price": "' + DlrPricing + '",';
        str_Product_JSON +=                     '"price": "' + partCost + '",';
        str_Product_JSON +=                     '"weight": "' + Weight + '",';
        str_Product_JSON +=                     '"manage_stock": true,';
        str_Product_JSON +=                     '"stock_status": "instock",';
        
        str_Product_JSON +=                     '"stock_quantity": ' + Quantity + ',';
         
        
        str_Product_JSON +=                     '"type": "' + proType + '",';
        
        if(Description != '')
            str_Product_JSON +=                     '"short_description": "' + Description.replaceAll('"','\\\\"').replaceAll('\n', ' ') + '",';
        
        if(Category != '') {
            str_Product_JSON += Category;
        }
        
        if(Tags != '') {
            str_Product_JSON += ',';
            str_Product_JSON += Tags;
            //str_Product_JSON += ']';
        }
        if(Attachment != '') { 
            str_Product_JSON +=                             ',';
            str_Product_JSON += Attachment;
        }
        if(strAttJSON != '') { 
            str_Product_JSON +=                             ',';
            str_Product_JSON += strAttJSON;
        } 
        
        str_Product_JSON +=         '}';
        
        System.debug('str_Product_JSON: '+str_Product_JSON);
        
        HttpRequest req = new HttpRequest();
        if(String.isNotBlank(WooComId)) {
            req.setMethod('PUT');
        } else {
            req.setMethod('POST');
        }
        
        req.setheader('Content-Type', 'application/json');
        req.setBody(str_Product_JSON);
        if(String.isNotBlank(WooComId)) {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/'+WooComId+'?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
        } else {
            req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
        }
        req.setTimeout(120000);
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        System.debug('>>>Product Creation: '+res.getBody());
        productCreationResponse = 'Product Creation JSON: '+str_Product_JSON +'\n\n\nProduct Creation Response: '+res.getBody();
        Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());    
        return String.valueOf(mapRepdata.get('id'));
        
    }
    
    @future(callout=true) 
    public static void updateInvoice(String strInvoiceId) {
        try {
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                
                Invoice__c objInvoice = [Select Id, BOATBUILDING__Woocommerce_Id__c, BOATBUILDING__Woocommerce_Status__c From Invoice__c Where Id =: strInvoiceId];
                
                String  str_Tag_JSON = '{';
                str_Tag_JSON += '"status":"'+objInvoice.BOATBUILDING__Woocommerce_Status__c+'"';
                str_Tag_JSON += '}';
                
                System.debug('Log str_Tag_JSON: '+str_Tag_JSON);
                HttpRequest req = new HttpRequest();
                req.setMethod('PUT');
                req.setheader('Content-Type', 'application/json');
                req.setBody(str_Tag_JSON);
                req.setEndPoint(objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/orders/'+objInvoice.BOATBUILDING__Woocommerce_Id__c+'?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c);
                Http h = new Http(); 
                HttpResponse res = h.send(req);
                System.debug('>>>>>>>: '+res.getBody());
            }
        } catch(Exception ex) {
            System.debug('Exception: '+ex.getStackTraceString());
        }
    }
    @Future(callout=true) 
    global static void uploadImages(String strWooComId, Map<String, String> mapAttBase64) {
        BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
        List<String> lstURL = uploadImage(mapAttBase64, objWC); 
    }
}