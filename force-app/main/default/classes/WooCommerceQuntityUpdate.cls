global class WooCommerceQuntityUpdate {
    private static String catagoryResponse = '';
    private static String catagoryCreationResponse = '';
    private static String tagResponse = '';
    private static String tagCreationResponse = '';
    private static String imageResponse = '';
    private static String productCreationResponse = '';
    
    
    @future(callout=true) 
    global static void savePartsToWooCommerce(String strPartId) {
        Map<String, String> mapCollectionNameId = new Map<String, String>();
        try {
            BOATBUILDING__WooCmmerce_Config__c objWC = BOATBUILDING__WooCmmerce_Config__c.getOrgDefaults();
            if(objWC != null) {
                Part__c objPart = [Select 
                                   b.RecordTypeId, b.OwnerId, b.Name, b.BOATBUILDING__Vendor_Name__r.Name, b.Quantity__c,
                                   b.BOATBUILDING__Weight__c, b.Id,BOATBUILDING__Part__c,
                                   b.BOATBUILDING__Web_Product_Name__c, b.BOATBUILDING__Web_Price__c, b.BOATBUILDING__Web_Part_Number__c, b.BOATBUILDING__WooCommerce_Id__c,
                                   b.BOATBUILDING__Web_Description__c, b.BOATBUILDING__Vendor_Name__c, b.BOATBUILDING__This_is_a_Physical_Product__c, BOATBUILDING__Web_Description_long__c, 
                                   b.BOATBUILDING__Taxable__c, b.BOATBUILDING__Store_Location__c, b.BOATBUILDING__SKU__c, b.BOATBUILDING__Retail_Price__c, b.Sub_Family__c,
                                   b.BOATBUILDING__Part_Size__c, b.BOATBUILDING__Part_Number__c, b.BOATBUILDING__Part_Cost__c, b.BOATBUILDING__Part_Color__c, 
                                   b.BOATBUILDING__Minimum_Amount__c, b.BOATBUILDING__Map_Price__c, b.BOATBUILDING__Location__c, b.BOATBUILDING__Family1__c, 
                                   b.BOATBUILDING__Discount__c, b.BOATBUILDING__Dealer_Price__c, b.BOATBUILDING__Category1__c, b.BOATBUILDING__Bin__c, b.BOATBUILDING__Barcode__c,
                                    (
                                       Select
                                               RecordTypeId, OwnerId, Name, BOATBUILDING__Vendor_Name__r.Name, Quantity__c,
                                               BOATBUILDING__Weight__c, Id,BOATBUILDING__Part__c,
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
                    String wooComProductId = pushPartToWooCommerce(objPart, objWC);
                    if(String.isNotBlank(wooComProductId)) {
                        objPart.BOATBUILDING__WooCommerce_Id__c = wooComProductId;
                        //Variaton Check 
                        List<Part__c> lstPart = pushPartVariation(objPart, objWC);
                        update objPart;     
                        if(!lstPart.isEmpty())
                            update lstPart;
                    }
                    
                    System_Configure__c objSC = System_Configure__c.getOrgDefaults();
                     if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                        BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                        objCL.Name = 'Woocommerce Log';
                        objCL.BOATBUILDING__Summary__c = '' + catagoryResponse + '  >>>  \n\n'+catagoryCreationResponse + '  >>>  \n\n '+tagResponse + '  >>>  \n\n '+tagCreationResponse + '  >>>  \n\n '+imageResponse + '  >>>  \n\n '+productCreationResponse+'\n\n\n\n\n Product Id: '+wooComProductId+'\n\n\n\n\n mapCollectionNameId:'+mapCollectionNameId;
                        insert objCL;
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
    
    public static List<Part__c> pushPartVariation(Part__c objPart, BOATBUILDING__WooCmmerce_Config__c objWC) {
        List<Part__c> lstPart = new List<Part__c>();
        
        
        
        if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
            if(!objPart.Part_Variation__r.isEmpty()) {
               
               if(!objPart.Part_Variation__r.isEmpty()) {
                        WooCommerceProductVar_ConnectQU objWooCommerceProductVar_Connect = new WooCommerceProductVar_ConnectQU(objPart.Part_Variation__r, 
                                                                                                                        objPart.BOATBUILDING__WooCommerce_Id__c, 
                                                                                                                                objWC);
                        System.enqueueJob(objWooCommerceProductVar_Connect);
               }
            }    
        }
        return lstPart;
    }
    
    private static String pushPartToWooCommerce(Part__c objPart, BOATBUILDING__WooCmmerce_Config__c objWC) {
        
        String strAttJSON = '';
        String Quantity = '0';
        String WooComId = '';
        
        if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
            WooComId = objPart.BOATBUILDING__WooCommerce_Id__c;
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
        
        String str_Product_JSON =   '{';
        str_Product_JSON +=                     '"stock_quantity": ' + Quantity + '';
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
    
}