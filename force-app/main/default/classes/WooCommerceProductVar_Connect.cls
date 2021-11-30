global class WooCommerceProductVar_Connect implements Queueable, Database.AllowsCallouts {
    global List<Part__c> lstPart;
    global String strQuery = '';
    global String strPrntProductId = '';
    //global List<String> lstImgUrl;
    global Map<String, List<String>> mapSrtListForImage;
    global BOATBUILDING__WooCmmerce_Config__c objWC;
    global Map<String, Map<String, Set<String>>> mapAttOption;
    global Map<String, String> mapAttNameId;
    global Part__c objPart;
    global WooCommerceProductVar_Connect(List<Part__c> part,
                                            String prntProductId, 
                                                Map<String, List<String>> srtListForImage, 
                                                    BOATBUILDING__WooCmmerce_Config__c WC, 
                                                        Map<String, Map<String, Set<String>>> AttOption, 
                                                            Map<String, String> AttNameId) {
        lstPart = part;
        strPrntProductId = prntProductId;
        mapSrtListForImage = srtListForImage;
        objWC = WC;
        mapAttOption = AttOption;
        mapAttNameId = AttNameId;
    }


    global void execute(QueueableContext context) {
        //Part__c objPart = new Part__c();(Part__c)scope[0];
        String debugString = '';
        Set<String> setPartNumber = new Set<String>();
        for(Part__c objPartVar : lstPart) {
            setPartNumber.add(objPartVar.BOATBUILDING__Part_Number__c);
        }
        List<BOATBUILDING__Inventory__c> lstInventory = [SELECT Id, BOATBUILDING__Part_Number__c, Quantity__c FROM BOATBUILDING__Inventory__c 
                                                        WHERE BOATBUILDING__Part_Number__c IN :setPartNumber];
        Map<String, Integer> mapInvQt = new Map<String, Integer>();
        for(BOATBUILDING__Inventory__c objInventory : lstInventory) {
            mapInvQt.put(objInventory.BOATBUILDING__Part_Number__c, objInventory.Quantity__c != null ? Integer.valueOf(objInventory.Quantity__c) : 0);
        }
        for(Part__c objPart: lstPart) {
            String strAttJSON = '';
            Map<String, Set<String>> mapAttNameOptionForPro = new Map<String, Set<String>>();
            if(mapAttOption.containsKey(objPart.Id)) {
                mapAttNameOptionForPro = mapAttOption.get(objPart.Id);
            }
            List<String> lstImgUrl = new List<String>();
            if(!mapSrtListForImage.isEmpty() && mapSrtListForImage.containsKey(objPart.Id)) {  
                lstImgUrl = mapSrtListForImage.get(objPart.Id); 
            } 
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
            String metaData = '"meta_data" : [';
	        if(objPart.BOATBUILDING__Barcode__c != null) {
	            metaData += '{ "key": "_wpm_gtin_code", "value" : "'+objPart.BOATBUILDING__Barcode__c.replaceAll('"','\\\\"')+'"}';
	            //barCodeJSON 
	        }
	        
	        if(objPart.BOATBUILDING__Part_Color__c != null) { 
	        	if(String.isNotBlank(objPart.BOATBUILDING__Barcode__c)) { 
	        		metaData += ',';
	        	} 
	            metaData += '{ "key": "part_color", "value" : "'+objPart.BOATBUILDING__Part_Color__c.replaceAll('"','\\\\"')+'"}';
	            //barCodeJSON
	        }
	        if(objPart.BOATBUILDING__Part_Size__c != null) { 
	        	if(String.isNotBlank(objPart.BOATBUILDING__Part_Color__c) || String.isNotBlank(objPart.BOATBUILDING__Barcode__c)) {
	        		metaData += ','; 
	        	}
	            metaData += '{ "key": "part_size", "value" : "'+objPart.BOATBUILDING__Part_Size__c.replaceAll('"','\\\\"')+'"}';
	            //barCodeJSON
	        }
	        
	        if(objPart.BOATBUILDING__Part_Gender__c != null) {
	        	if(String.isNotBlank(objPart.BOATBUILDING__Part_Size__c) || String.isNotBlank(objPart.BOATBUILDING__Part_Color__c) || String.isNotBlank(objPart.BOATBUILDING__Barcode__c)) {
	        		metaData += ',';
	        	}
	            metaData += '{ "key": "part_gender", "value" : "'+objPart.BOATBUILDING__Part_Gender__c.replaceAll('"','\\\\"')+'"}';
	            //barCodeJSON
	        }
	        metaData += ']';
            
            if(objPart.Weight__c != null && objPart.Weight__c.containsIgnoreCase('lbs')) {
                Weight = objPart.Weight__c.toLowerCase().replace('lbs','');
            } else {
                Weight = objPart.Weight__c; 
            }
            
            Quantity = String.valueOf(mapInvQt.get(objPart.Part_Number__c));
            // if(objPart.Quantity__c != null) {
            //     Quantity = String.valueOf(objPart.Quantity__c);
            // }
            if(objPart.BOATBUILDING__Push_Description__c && objPart.BOATBUILDING__Web_Description_long__c != null) {
                Description = String.valueOf(objPart.BOATBUILDING__Web_Description_long__c).replaceAll('\r\n', ' ');
            } 
            
            if(objPart.BOATBUILDING__Part_Cost__c != null) {  
                partCost = String.valueOf(objPart.BOATBUILDING__Part_Cost__c);
            }
            
            
            String Attachment = '';
            System.debug('lstImgUrl>>>: '+lstImgUrl);
            if(!lstImgUrl.isEmpty()) {
                Attachment = '"image": ';
                Attachment += '{';
                Attachment +=   '"id": ' + lstImgUrl[0] ;
                Attachment += '}';   
                //Attachment = Attachment.subString(0, Attachment.length()-1);
                Attachment += '';
            }
            
            String str_Product_JSON =   '{';
            
            str_Product_JSON +=                     '"name": "' + Title.replaceAll('"','\\\\"') + '",';
            
            if(Description != '')
                str_Product_JSON +=                     '"description": "' + Description.replaceAll('"','\\\\"').replaceAll('\n', ' ') + '",';
            if(SKU != '') 
                str_Product_JSON +=                     '"sku": "' + SKU.replaceAll('"','\\\\"') + '",';
            str_Product_JSON +=                     '"weight": "' + Weight + '",'; 
            str_Product_JSON +=                     '"regular_price": "' + Pricing + '",'; 
            if(String.isNotBlank(DlrPricing))
            	str_Product_JSON +=                     '"sale_price": "' + DlrPricing + '",';
            
            str_Product_JSON +=                     '"stock_quantity": "' + Quantity + '",';
            str_Product_JSON +=                     '"manage_stock": true,';
             
            if(Integer.valueOf(Quantity) > 0) {
                str_Product_JSON +=                     '"stock_status": "instock",';   
            } else { 
                str_Product_JSON +=                     '"stock_status": "outofstock",'; 
            }
            
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
            if(String.isNotBlank(metaData)) {
	        	str_Product_JSON += ',' + metaData;
	        }
            str_Product_JSON +=         '}'; 
            
            System.debug('str_Product_JSON Var: '+str_Product_JSON);
            
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
            System.debug('req.setEndPoint Var: '+req.getEndPoint());
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