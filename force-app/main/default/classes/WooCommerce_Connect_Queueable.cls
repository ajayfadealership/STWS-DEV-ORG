global with sharing class WooCommerce_Connect_Queueable implements Queueable, Database.AllowsCallouts {
    private static String strStack = '';
    private static String catagoryResponse = '';
    private static String catagoryCreationResponse = '';
    private static String tagResponse = '';
    private static String tagCreationResponse = '';
    private static String imageResponse = '';
    private static String productCreationResponse = '';
    String strPartId = '';
    global WooCommerce_Connect_Queueable(String strPartId) {
        this.strPartId = strPartId;
    }
    global void execute(QueueableContext context) {
        Map<String, String> mapCollectionNameId = new Map<String, String>();
        try {
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                Part__c objPart = [Select 
                                   b.RecordTypeId, b.OwnerId, b.Name, b.BOATBUILDING__Vendor_Name__r.Name, b.Quantity__c,
                                   b.BOATBUILDING__Weight__c, b.Id,BOATBUILDING__Part__c, BOATBUILDING__Push_Image__c,BOATBUILDING__Part_Gender__c,
                                   b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__WooCommerce_Id__c,
                                   b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Vendor_Name__c, b.BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                   b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__SKU__c, b.BOATBUILDING__Retail_Price__c, b.Sub_Family__c,
                                   b.BOATBUILDING__Part_Size__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Cost__c, b.BOATBUILDING__Part_Color__c, 
                                   b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Location__c, b.BOATBUILDING__Family1__c, b.BOATBUILDING__Push_Description__c, 
                                   b.BOATBUILDING__Discount__c, b.BOATBUILDING__Dealer_Price__c, b.BOATBUILDING__Category1__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Barcode__c,
                                    (
                                       Select
                                               RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
                                               BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,BOATBUILDING__Push_Image__c,BOATBUILDING__Part_Gender__c,
                                               BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Web_Price__c, BOATBUILDING__Web_Part_Number__c, BOATBUILDING__WooCommerce_Id__c,
                                               BOATBUILDING__Web_Description__c, BOATBUILDING__Vendor_Name__c, BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                               BOATBUILDING__Taxable__c, BOATBUILDING__Store_Location__c, BOATBUILDING__SKU__c, BOATBUILDING__Retail_Price__c, Sub_Family__c,
                                               BOATBUILDING__Part_Size__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Part_Cost__c, BOATBUILDING__Part_Color__c, 
                                               BOATBUILDING__Minimum_Amount__c, BOATBUILDING__Map_Price__c, BOATBUILDING__Location__c, BOATBUILDING__Family1__c, BOATBUILDING__Push_Description__c,
                                               BOATBUILDING__Discount__c, BOATBUILDING__Dealer_Price__c, BOATBUILDING__Category1__c, BOATBUILDING__Bin__c, BOATBUILDING__Barcode__c
                                       From 
                                               Part_Variation__r
                                    )
                                   From 
                                   BOATBUILDING__Part__c b
                                   Where    
                                   Id =: strPartId];
                Boolean pushToWoocom = true;
                if(String.isNotBlank(objPart.BOATBUILDING__WooCommerce_Id__c)) {
                    HttpRequest req = new HttpRequest(); 
                    req.setMethod('GET');
                    req.setheader('Content-Type', 'application/json');
                    String URL = objWC.BOATBUILDING__API_URL__c+'/wp-json/wc/v3/products/'+objPart.BOATBUILDING__WooCommerce_Id__c+'?consumer_key='+objWC.BOATBUILDING__Consumer_key__c+'&consumer_secret='+objWC.BOATBUILDING__Consumer_secret__c;
                    req.setEndPoint(URL);
                    req.setTimeout(120000);
                    Http h = new Http(); 
                    HttpResponse res = h.send(req);
                    System.debug('>>>Product Reso: '+res.getBody());
                    strStack += '1:63getPartDetail '+res.getBody()+'\n\n';
                    if(res.getBody().containsIgnoreCase('woocommerce_rest_product_invalid_id')) {
                        pushToWoocom = false;
                    }
                }
                if(pushToWoocom) {
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
                    
                    //Calling Queueable
                    WooCommerce_Connect_Process_1 objWooCommerce_Connect_Process_1 = new WooCommerce_Connect_Process_1(mapAttOption, mapAttNameOptionForPro, strPartId, lstWA, objWC, objPart, mapCollectionNameId);
                    System.enqueueJob(objWooCommerce_Connect_Process_1);
                    
                } else {
                    List<Part__c> lstP = new List<Part__c>(); 
                    objPart.BOATBUILDING__WooCommerce_Id__c = '';
                    lstP.add(objPart);
                    if(!objPart.Part_Variation__r.isEmpty()) {
                        for(Part__c objP: objPart.Part_Variation__r) {
                            objP.BOATBUILDING__WooCommerce_Id__c = '';
                            lstP.add(objP);
                        }
                    }
                    update lstP;
                }
            }
            
        } catch(Exception ex) {
            System.debug('Email For Woocom: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()); 
            //SendEmailUtility.sendQuickEmail('Email For Woocom: ' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString());
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Log';
                
                String customLog = '' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString()+'\n\n\n------'+strStack+'\n\n\n' + catagoryResponse + '  >>>  \n\n'+catagoryCreationResponse + '  >>>  \n\n '+tagResponse + '  >>>  \n\n '+tagCreationResponse + '  >>>  \n\n '+imageResponse + '  >>>  \n\n '+productCreationResponse; 
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