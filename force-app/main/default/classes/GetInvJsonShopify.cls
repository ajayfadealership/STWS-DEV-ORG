@RestResource(urlMapping = '/shopify/*')
global class GetInvJsonShopify {
    @HttpGet
    global static String doGet() {
        return 'Hey There';
    }
    
    @HttpPost
    global static void doPost() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            System.debug('>>>>req: '+req.requestBody.toString());
            System.debug('>>>>res: '+res);
            generateInvoice(req.requestBody.toString());
            
        } catch(Exception ex) {
                System.debug('Debug Log For Exception: '+ex.getStackTraceString() + ' : ' +ex.getLineNumber() + ' : '+ex.getMessage());
                //SendEmailUtility.sendQuickEmail('Email For Invoice Error Sh0pify: '+ex.getStackTraceString() + ' : ' +ex.getLineNumber());
        }   
    }
    
    global static void generateInvoice(String strJSON) {
        ShopifyWebhookInvoiceParser objShopifyWebhookInvoiceParser = ShopifyWebhookInvoiceParser.parse(strJSON);
        System.debug('objShopifyWebhookInvoiceParser: '+objShopifyWebhookInvoiceParser);
        if(objShopifyWebhookInvoiceParser.financial_status != null && objShopifyWebhookInvoiceParser.financial_status.equalsIgnoreCase('paid')) {
            List<Account> lstAcc =[Select Id, Name, BillingState From Account where Email__c =: objShopifyWebhookInvoiceParser.email AND RecordType.DeveloperName = 'Prospect'];
            Account objAcc= new Account();
            if(lstAcc.isEmpty()) {
                objAcc.Name= objShopifyWebhookInvoiceParser.customer.first_name + ' ' + objShopifyWebhookInvoiceParser.customer.last_name ;
                objAcc.Email__c=objShopifyWebhookInvoiceParser.customer.email;
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                objAcc.RecordTypeId= recordTypeId;
                objAcc.Phone = String.valueOf(objShopifyWebhookInvoiceParser.customer.phone);
                objAcc.Lead_Source__c = 'Parts Online';
                objAcc.BillingStreet = objShopifyWebhookInvoiceParser.billing_address.address1;
                objAcc.BillingCity = objShopifyWebhookInvoiceParser.billing_address.city;
                objAcc.BillingState = objShopifyWebhookInvoiceParser.billing_address.province;
                objAcc.BillingCountry = objShopifyWebhookInvoiceParser.billing_address.country;
                objAcc.BillingPostalCode = objShopifyWebhookInvoiceParser.billing_address.zip;
                if(objShopifyWebhookInvoiceParser.shipping_address != null) {
                    objAcc.ShippingStreet = objShopifyWebhookInvoiceParser.shipping_address.address1;
                    objAcc.ShippingCity = objShopifyWebhookInvoiceParser.shipping_address.city;
                    objAcc.ShippingState = objShopifyWebhookInvoiceParser.shipping_address.province;
                    objAcc.ShippingCountry = objShopifyWebhookInvoiceParser.shipping_address.country; 
                    objAcc.ShippingPostalCode = objShopifyWebhookInvoiceParser.shipping_address.zip;
                }
            } else {
                objAcc = lstAcc[0];
                if(objShopifyWebhookInvoiceParser.shipping_address != null) {
                    objAcc.ShippingStreet = objShopifyWebhookInvoiceParser.shipping_address.address1;
                    objAcc.ShippingCity = objShopifyWebhookInvoiceParser.shipping_address.city;
                    objAcc.ShippingState = objShopifyWebhookInvoiceParser.shipping_address.province;
                    objAcc.ShippingCountry = objShopifyWebhookInvoiceParser.shipping_address.country;
                    objAcc.ShippingPostalCode = objShopifyWebhookInvoiceParser.shipping_address.zip;    
                }
            }  
            
            upsert objAcc;
            System.debug('Debug Log For objAcc.Id: '+objAcc.Id);
            List<Contact> lstContact = [Select Id, Name, Phone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode From Contact Where AccountId =: objAcc.Id];
            Integer invCount = [Select count() From Invoice__c Where BOATBUILDING__Shopify_Id__c =: String.valueOf(objShopifyWebhookInvoiceParser.id)];
            if(invCount == 0) {
                Invoice__c objInvoice = new Invoice__c();
                objInvoice.Name = 'Invoice for '+objAcc.Name;
                objInvoice.Related_to_Contact__c = lstContact[0].Id;    
                objInvoice.Customer_Name__c = lstContact[0].Name;
                objInvoice.Phone_Number__c = lstContact[0].Phone;
                if(objShopifyWebhookInvoiceParser.shipping_address != null) {
                    objInvoice.Customer_Address__c = objShopifyWebhookInvoiceParser.shipping_address.address1;
                    objInvoice.City__c = objShopifyWebhookInvoiceParser.shipping_address.city;
                    objInvoice.State__c = objShopifyWebhookInvoiceParser.shipping_address.province;
                    objInvoice.Zip_Code__c = objShopifyWebhookInvoiceParser.shipping_address.zip;
                }
                objInvoice.BOATBUILDING__Billing_State_Province__c = objShopifyWebhookInvoiceParser.billing_address != null && objShopifyWebhookInvoiceParser.billing_address.province != null ? objShopifyWebhookInvoiceParser.billing_address.province : '';
                 
                objInvoice.Email__c = lstContact[0].Email;
                objInvoice.BOATBUILDING__Web_Source__c = 'Shopify'; 
                objInvoice.RecordTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Web Invoices').getRecordTypeId();
                objInvoice.BOATBUILDING__Shopify_Id__c = String.valueOf(objShopifyWebhookInvoiceParser.id); 
                objInvoice.BOATBUILDING__Woocommerce_Customer_Notes__c = objShopifyWebhookInvoiceParser.customer != null && objShopifyWebhookInvoiceParser.customer.note != null ? String.valueOf(objShopifyWebhookInvoiceParser.customer.note): '' ;
                objInvoice.BOATBUILDING__Comments_Notes__c = objShopifyWebhookInvoiceParser.note != null ? String.valueOf(objShopifyWebhookInvoiceParser.note): '' ;
                if(objShopifyWebhookInvoiceParser.total_discounts != null )
                    objInvoice.BOATBUILDING__Discount_on_Invoice__c = Decimal.valueOf(String.valueOf(objShopifyWebhookInvoiceParser.total_discounts));  
                
                if(objShopifyWebhookInvoiceParser.discount_codes != null && !objShopifyWebhookInvoiceParser.discount_codes.isEmpty()) {
                    BOATBUILDING__Promo_Code__c objPC = new BOATBUILDING__Promo_Code__c();
                    objPC.BOATBUILDING__Description__c = 'Discount From Shopify';
                    objPC.BOATBUILDING__Discount_Amount__c = Double.valueOf(objShopifyWebhookInvoiceParser.discount_codes[0].amount);
                    objPC.BOATBUILDING__Promo_Code_Name__c = objShopifyWebhookInvoiceParser.discount_codes[0].code;
                    objPC.BOATBUILDING__Discount_In__c = 'Amount';
                    insert objPC;
                    objInvoice.BOATBUILDING__Promo_Code__c = objPC.Id;
                }
                objInvoice.BOATBUILDING__Web_Invoice_Sales_Tax__c = objShopifyWebhookInvoiceParser.total_tax != null ? Double.valueOf(objShopifyWebhookInvoiceParser.total_tax) : 0.00;
                objInvoice.BOATBUILDING__Web_Invoice_Response__c = strJSON;
                insert objInvoice;

                BOATBUILDING__Payments__c obj = new BOATBUILDING__Payments__c();
                obj.BOATBUILDING__Source__c = 'Shopify';

                if(objShopifyWebhookInvoiceParser.gateway != null)
                    obj.BOATBUILDING__Payment_Type__c = objShopifyWebhookInvoiceParser.gateway; 
                    
                obj.BOATBUILDING__Amount__c = Decimal.valueOf(objShopifyWebhookInvoiceParser.total_price); 
                obj.BOATBUILDING__Invoice__c = objInvoice.Id;
                obj.RecordTypeId = Schema.SObjectType.BOATBUILDING__Payments__c.getRecordTypeInfosByName().get('Standard Invoice').getRecordTypeId();
                if(objShopifyWebhookInvoiceParser.payment_details != null) {
                    obj.BOATBUILDING__MCSTransactionID__c = objShopifyWebhookInvoiceParser.payment_details.credit_card_bin != null ? objShopifyWebhookInvoiceParser.payment_details.credit_card_bin : ''; 
                    if(objShopifyWebhookInvoiceParser.payment_details.credit_card_number != null)
                        obj.Card_Number__c = objShopifyWebhookInvoiceParser.payment_details.credit_card_number;
                    if(objShopifyWebhookInvoiceParser.payment_details.credit_card_company != null)
                        obj.BOATBUILDING__Credit_Card_Type__c = objShopifyWebhookInvoiceParser.payment_details.credit_card_company; 
                }
                if(objShopifyWebhookInvoiceParser.payment_gateway_names != null && !objShopifyWebhookInvoiceParser.payment_gateway_names.isEmpty()) {
                    for(String str: objShopifyWebhookInvoiceParser.payment_gateway_names) {
                        obj.Payment_Gateway_Names__c += str + ',';
                    }
                    obj.Payment_Gateway_Names__c = obj.Payment_Gateway_Names__c.subString(0, obj.Payment_Gateway_Names__c.length()-1);
                }
                insert obj;
                System.debug('Debug Log For objInvoice.Id: '+objInvoice.Id);
                List<ShopifyWebhookInvoiceParser.Line_items> lstLI = objShopifyWebhookInvoiceParser.line_items;
                Set<String> setSFProductIds = new Set<String>();
                Map<String, ShopifyWebhookInvoiceParser.Line_items> mapSPIdQt = new Map<String, ShopifyWebhookInvoiceParser.Line_items>();
                System.debug('>>>objShopifyWebhookInvoiceParser.line_items: '+objShopifyWebhookInvoiceParser.line_items);
                System.debug('>>>lstLI: '+lstLI);
                if(!lstLI.isEmpty()) {
                    for(ShopifyWebhookInvoiceParser.Line_items objLI: lstLI) {
                            setSFProductIds.add(String.valueOf(objLI.product_id));
                            mapSPIdQt.put(String.valueOf(objLI.product_id), objLI); 
                            
                    }
                    System.debug('>>>setSFProductIds: '+setSFProductIds);
                    System.debug('>>>mapSPIdQt: '+mapSPIdQt);
                    List<BOATBUILDING__Part__c> lstOfParts = [SELECT 
                                                                            Id,
                                                                            Name, 
                                                                            Dealer_Price__c,  
                                                                            Part_Number__c,
                                                                            Part_Cost__c, 
                                                                            Retail_Price__c, 
                                                                            Category1__c,
                                                                            Family1__c,
                                                                            Vendor_Name__c,
                                                                            Map_Price__c,
                                                                            Weight__c,
                                                                            BOATBUILDING__Shopify_Product_Id__c
                                                                    FROM  
                                                                            BOATBUILDING__Part__c 
                                                                Where 
                                                                        BOATBUILDING__Shopify_Product_Id__c IN: setSFProductIds];
                                                                        System.debug('>>>lstOfParts: '+lstOfParts);                                                 
                    Map<String, ShopifyWebhookInvoiceParser.Line_items> mapPCQt = new Map<String, ShopifyWebhookInvoiceParser.Line_items>();
                    
                    for(BOATBUILDING__Part__c objPrt: lstOfParts) {
                        mapSPIdQt.put(objPrt.Part_Number__c, mapSPIdQt.get(objPrt.BOATBUILDING__Shopify_Product_Id__c));
                    }
                    List<BOATBUILDING__Inventory__c> lstLineItem = [SELECT  
                                                            Vendor__c, 
                                                            Size__c, 
                                                            Part_Number__c, 
                                                            Part_MSRP_Price__c, 
                                                            Part_Location__c, 
                                                            Minimum_Amount__c, 
                                                            Map_Price__c,
                                                            Quantity__c , 
                                                            Family__c, 
                                                            Discount__c, 
                                                            Description__c, 
                                                            Cost__c, 
                                                            Color__c, 
                                                            Category__c,
                                                            Part_Name__c,
                                                            Taxable__c,
                                                            Weight__c,
                                                            (
                                                                    Select Id, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                    From BOATBUILDING__Parts_Availability__r
                                                            )
                                                FROM
                                                            BOATBUILDING__Inventory__c 
                                                WHERE
                                                            Part_Number__c IN: mapSPIdQt.keySet()];
                                                            System.debug('>>>lstLineItem: '+lstLineItem);
                    List<Parts_Availability__c> LstPA = new List<Parts_Availability__c>();
                    List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
                    List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
                    if(objInvoice.Id != null) {
                        Set<String> setStrId = new Set<String>();
                        for(BOATBUILDING__Inventory__c objLI : lstLineItem) {
                            BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                            if(mapSPIdQt.containsKey(objLI.Part_Number__c)) {
                                objILI.Name = objLI.Part_Name__c;
                                objILI.Quantity__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
                                objILI.Discount_Price__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).total_discount);
                                objILI.Part_Cost__c = objLI.Part_MSRP_Price__c;
                                objILI.Dealer_Price__c = objLI.Cost__c;
                                objILI.Part_Number__c = objLI.Part_Number__c;
                                objILI.Related_To_Invoice__c = objInvoice.Id; 
                                
                                objILI.Weight__c = objLI.Weight__c;
                                objILI.Taxable__c = objLI.Taxable__c; 
                                objILI.Category__c = objLI.Category__c;
                                objILI.Family__c = objLI.Family__c;
                                lstILI.add(objILI); 
                                setStrId.add(objLI.Part_Number__c);
                                if(objLI.Parts_Availability__r.size() > 0) {
                                    Parts_Availability__c objPA = objLI.Parts_Availability__r[0];
                                            
                                        objPA.Quantity__c = Integer.valueOf(objPA.Quantity__c) - Integer.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
                                        LstPA.add(objPA);
                                } else {  
                                        if(objLI.Quantity__c != null) {
                                            objLI.Quantity__c = Integer.valueOf(objLI.Quantity__c) - Integer.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
                                        } else {
                                            objLI.Quantity__c = - Integer.valueOf(mapSPIdQt.get(objLI.Part_Number__c));
                                        }
                                        lstInv.add(objLI);
                                }
                            }
                        }
                        System.debug('>>>setStrId: '+setStrId);
                        System.debug('>>>lstILI1: '+lstILI);
                        for(BOATBUILDING__Part__c objLI : lstOfParts) {
                            BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                            if(mapSPIdQt.containsKey(objLI.Part_Number__c) && !setStrId.contains(objLI.Part_Number__c)) {
                                objILI.Name = objLI.Name;
                                objILI.Quantity__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
                                //objILI.Discount_Price__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).total_discount);
                                objILI.Part_Cost__c = objLI.BOATBUILDING__Retail_Price__c;
                                objILI.Dealer_Price__c = objLI.BOATBUILDING__Part_Cost__c;
                                objILI.Part_Number__c = objLI.Part_Number__c;
                                objILI.Related_To_Invoice__c = objInvoice.Id;  
                                objILI.Weight__c = objLI.Weight__c;
                                objILI.Taxable__c = true; 
                                objILI.Category__c = objLI.BOATBUILDING__Category1__c;
                                objILI.Family__c = objLI.BOATBUILDING__Family1__c;
                                objLI.Quantity__c -= objILI.Quantity__c;
                                lstILI.add(objILI);
                                setStrId.add(objLI.Part_Number__c);
                            } else if(!setStrId.contains(objLI.Part_Number__c)){ 
                                
                                objILI.Name = mapSPIdQt.get(objLI.Part_Number__c).title != null ? String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).title) : String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).product_id);
                                objILI.Quantity__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
                                //objILI.Discount_Price__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).total_discount);
                                objILI.Part_Cost__c = Double.valueOf(mapSPIdQt.get(objLI.Part_Number__c).price);
                                //objILI.Dealer_Price__c = objLI.Cost__c;
                                objILI.Part_Number__c = mapSPIdQt.get(objLI.Part_Number__c).variant_id != null ? String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).variant_id) : String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).product_id);
                                objILI.Related_To_Invoice__c = objInvoice.Id; 
                                
                                //objILI.Weight__c = objLI.Weight__c;
                                //objILI.Taxable__c = objLI.Taxable__c; 
                                //objILI.Category__c = objLI.Category__c;
                                //objILI.Family__c = objLI.Family__c;
                                objLI.Quantity__c -= objILI.Quantity__c;
                                lstILI.add(objILI);
                                setStrId.add(objLI.Part_Number__c);
                            }
                        }
                        System.debug('>>>lstILI2: '+lstILI);
                        if(lstILI.isEmpty()) {
                            for(ShopifyWebhookInvoiceParser.Line_items objLI: lstLI) {
                                BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
                                objILI.Name = objLI.title != null ? String.valueOf(objLI.title) : String.valueOf(objLI.product_id);
                                objILI.Quantity__c = Decimal.valueOf(objLI.quantity);
                                //objILI.Discount_Price__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).total_discount);
                                objILI.Part_Cost__c = Double.valueOf(objLI.price);
                                //objILI.Dealer_Price__c = objLI.Cost__c;
                                objILI.Part_Number__c = objLI.variant_id != null ? String.valueOf(objLI.variant_id) : String.valueOf(objLI.product_id);
                                objILI.Related_To_Invoice__c = objInvoice.Id; 
                                
                                //objILI.Weight__c = objLI.Weight__c;
                                //objILI.Taxable__c = objLI.Taxable__c; 
                                //objILI.Category__c = objLI.Category__c;
                                //objILI.Family__c = objLI.Family__c;
                                lstILI.add(objILI);
                            }
                        }
                    }   
                    System.debug('>>>lstILI3: '+lstILI);
                    insert lstILI;
                    
                    if(!lstInv.isEmpty())
                        update lstInv;   
                    if(!LstPA.isEmpty())
                        update LstPA;
                    if(!lstOfParts.isEmpty())
                        update lstOfParts;
                    //Email Task     
                    BOATBUILDING__System_Configure__c objWeb =  BOATBUILDING__System_Configure__c.getOrgDefaults();
                    if(objWeb != null && String.isNotBlank(objWeb.BOATBUILDING__Web_invoice_role__c)){
                        String strRole = objWeb.BOATBUILDING__Web_invoice_role__c;
                        Set<String> setRole = new Set<String>();
                        if(objWeb.BOATBUILDING__Web_invoice_role__c.contains(',')) { 
                            List<String> lstRole = objWeb.BOATBUILDING__Web_invoice_role__c.split(',');
                            for(String str: lstRole) {
                                setRole.add(str);
                            }
                        } else {
                            setRole.add(objWeb.BOATBUILDING__Web_invoice_role__c);
                        }
                        
                        Map<Id, User> mapUser = new Map<Id, User>([Select Id, Name, Email From User Where UserRole.Name IN: setRole AND isActive = true]);
                        List<String> lstEmail = new List<String>(); 
                        for(User objUser: mapUser.values()) {
                            lstEmail.add(objUser.Email);
                        }
                        
                        if(!lstEmail.isEmpty()) { 
                            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                            Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();
                            
                            mail.setToAddresses(lstEmail);
                            mail.setSubject('Web Invoice Generated');
                            mail.setHtmlBody('Hi, <br/> A web invoice has been generated please check.<br/>Invoice Number: '+objInvoice.BOATBUILDING__Invoice_Number__c+'<br/>Thanks.');
                            mails.add(mail);
                            if(!test.isRunningTest())
                                    Messaging.sendEmail(mails);
                                    
                        } 
                    }
                                                                
                }
            }
        }
    }
}