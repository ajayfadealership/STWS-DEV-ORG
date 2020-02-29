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
		    ShopifyWebhookInvoiceParser objShopifyWebhookInvoiceParser = ShopifyWebhookInvoiceParser.parse(req.requestBody.toString());
		    System.debug('objShopifyWebhookInvoiceParser: '+objShopifyWebhookInvoiceParser.customer.email);
		    
		    List<Account> lstAcc =[Select Id, Name From Account where Email__c =: objShopifyWebhookInvoiceParser.customer.email AND RecordType.DeveloperName = 'Prospect'];
		    Account objAcc= new Account();
		    if(lstAcc.isEmpty()) {
		         objAcc.Name= objShopifyWebhookInvoiceParser.customer.first_name + ' ' + objShopifyWebhookInvoiceParser.customer.last_name ;
		         objAcc.Email__c=objShopifyWebhookInvoiceParser.customer.email;
		         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		         objAcc.RecordTypeId= recordTypeId;
		         objAcc.Phone = String.valueOf(objShopifyWebhookInvoiceParser.customer.phone);
		         
		         objAcc.BillingStreet = objShopifyWebhookInvoiceParser.billing_address.address1;
		         objAcc.BillingCity = objShopifyWebhookInvoiceParser.billing_address.city;
		         objAcc.BillingState = objShopifyWebhookInvoiceParser.billing_address.province;
		         objAcc.BillingCountry = objShopifyWebhookInvoiceParser.billing_address.country;
		         objAcc.BillingPostalCode = objShopifyWebhookInvoiceParser.billing_address.zip;
		         
		         objAcc.ShippingStreet = objShopifyWebhookInvoiceParser.shipping_address.address1;
		         objAcc.ShippingCity = objShopifyWebhookInvoiceParser.shipping_address.city;
		         objAcc.ShippingState = objShopifyWebhookInvoiceParser.shipping_address.province;
		         objAcc.ShippingCountry = objShopifyWebhookInvoiceParser.shipping_address.country;
		         objAcc.ShippingPostalCode = objShopifyWebhookInvoiceParser.shipping_address.zip;
		         
		         
		         
		         
		    } else {
	    		objAcc = lstAcc[0];
	    		objAcc.ShippingStreet = objShopifyWebhookInvoiceParser.shipping_address.address1;
		        objAcc.ShippingCity = objShopifyWebhookInvoiceParser.shipping_address.city;
		        objAcc.ShippingState = objShopifyWebhookInvoiceParser.shipping_address.province;
		        objAcc.ShippingCountry = objShopifyWebhookInvoiceParser.shipping_address.country;
		        objAcc.ShippingPostalCode = objShopifyWebhookInvoiceParser.shipping_address.zip;	
		    } 
		    upsert objAcc;
		    System.debug('Debug Log For objAcc.Id: '+objAcc.Id);
		    List<Contact> lstContact = [Select Id, Name, Phone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode From Contact Where AccountId =: objAcc.Id];
		    Invoice__c objInvoice = new Invoice__c();
		    objInvoice.Name = 'Invoice for '+objAcc.Name;
	        objInvoice.Related_to_Contact__c = lstContact[0].Id;    
	        objInvoice.Customer_Name__c = lstContact[0].Name;
	        objInvoice.Phone_Number__c = lstContact[0].Phone;
	        objInvoice.Customer_Address__c = lstContact[0].MailingStreet;    
	        objInvoice.City__c = lstContact[0].MailingCity;
	        objInvoice.Email__c = lstContact[0].Email;
	        objInvoice.BOATBUILDING__Web_Source__c = 'Shopify'; 
	        objInvoice.State__c = lstContact[0].MailingState;
	        objInvoice.Zip_Code__c = lstContact[0].MailingPostalCode;
	        objInvoice.RecordTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Web Invoices').getRecordTypeId();
	        objInvoice.BOATBUILDING__Shopify_Id__c = String.valueOf(objShopifyWebhookInvoiceParser.id); 
		    insert objInvoice;
		    
		    List<ShopifyWebhookInvoiceParser.Line_items> lstLI = objShopifyWebhookInvoiceParser.line_items;
		    Set<String> setSFProductIds = new Set<String>();
		    Map<String, ShopifyWebhookInvoiceParser.Line_items> mapSPIdQt = new Map<String, ShopifyWebhookInvoiceParser.Line_items>();
		     
		    if(!lstLI.isEmpty()) {
			    for(ShopifyWebhookInvoiceParser.Line_items objLI: lstLI) {
			    		setSFProductIds.add(String.valueOf(objLI.product_id));
			    		mapSPIdQt.put(String.valueOf(objLI.product_id), objLI); 
			    		
			    }
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
                
                List<Parts_Availability__c> LstPA = new List<Parts_Availability__c>();
                List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
        		if(objInvoice.Id != null) {
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
		                    }
		                }
		            }
		        }	
		        insert lstILI;
        		update LstPA;	
        		update lstLineItem;   
        		
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
	    } catch(Exception ex) {
	    		System.debug('Debug Log For Exception: '+ex.getStackTraceString() + ' : ' +ex.getLineNumber());
	    		SendEmailUtility.sendQuickEmail('Email For Invoice Error Sh0pify: '+ex.getStackTraceString() + ' : ' +ex.getLineNumber());
	    }   
	}
}