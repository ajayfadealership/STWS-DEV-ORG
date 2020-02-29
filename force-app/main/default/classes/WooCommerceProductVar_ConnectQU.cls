global with sharing class WooCommerceProductVar_ConnectQU implements Queueable, Database.AllowsCallouts {
    global List<Part__c> lstPart;
    global String strPrntProductId = '';
    global BOATBUILDING__WooCmmerce_Config__c objWC;
    global WooCommerceProductVar_ConnectQU(List<Part__c> part,
                                            String prntProductId,
                                                    BOATBUILDING__WooCmmerce_Config__c WC) {
        lstPart = part;
        strPrntProductId = prntProductId;
        objWC = WC;  
    }


    global void execute(QueueableContext context) {
        String debugString = '';
        for(Part__c objPart: lstPart) {
            String Quantity = '0';
            String WooComId = '';
            if(objPart.BOATBUILDING__WooCommerce_Id__c != null) {
                WooComId = objPart.BOATBUILDING__WooCommerce_Id__c;
            }
            if(objPart.Quantity__c != null) {
                Quantity = String.valueOf(objPart.Quantity__c);
            }
            String str_Product_JSON =   '{';
            str_Product_JSON +=                     '"stock_quantity": "' + Quantity + '"';
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
            Map<String, Object> mapRepdata = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            objPart.BOATBUILDING__WooCommerce_Id__c = String.valueOf(mapRepdata.get('id'));
            debugString += '>>>Product Creation: '+res.getBody()+'\n\n\n\nstr_Product_JSON: '+str_Product_JSON+'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\\n>>\n'; 
        } 
        update lstPart;
        
        System_Configure__c objSC = System_Configure__c.getOrgDefaults();
         if(objSC != null && objSC.Enable_Debug_Mails__c)  {
            BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
            objCL.Name = 'Woocommerce Log Part Var';
            objCL.BOATBUILDING__Summary__c = debugString;
            insert objCL;
         }
    }
}