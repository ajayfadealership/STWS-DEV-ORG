@RestResource(urlMapping = '/woocom/*')
global class GetInvJsonWoocommerce {
	@HttpGet
	global static String doGet() {
	    return 'Hey There Woocommerce';
	}
	
	@HttpPost
	global static void doPost() {
		try {
			RestRequest req = RestContext.request;
		    RestResponse res = RestContext.response;
		    
		    System.debug('>>>>req: '+req.requestBody.toString());
		    System.debug('>>>>res: '+res);
		    if(String.isNotBlank(req.requestBody.toString())) {
		    	
		    	WoocommerceWebhook_Invoice objWOCOM = WoocommerceWebhook_Invoice.parse(req.requestBody.toString());
		    	System.debug('>>>>>>>objWOCOM: '+objWOCOM);
		    	System.debug('>>>>>>>line_items: '+objWOCOM.line_items);
		    	if(String.isNotBlank(objWOCOM.billing.email) && String.isNotBlank(objWOCOM.status) 
	    			&& (objWOCOM.status.equalsIgnoreCase('processing'))) { 
		    		String strCustEmail = objWOCOM.billing.email;	
		    		List<Account> lstAcc =[Select Id, Name From Account where Email__c =: strCustEmail AND RecordType.DeveloperName = 'Prospect'];
		    		Account objAcc= new Account();
		    		if(lstAcc.isEmpty()) {
				         objAcc.Name = objWOCOM.billing.first_name + ' ' + objWOCOM.billing.last_name ;
				         objAcc.Email__c = objWOCOM.billing.email;
				         Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
				         objAcc.RecordTypeId= recordTypeId;
				         objAcc.Phone = String.valueOf(objWOCOM.billing.phone);
				         
				         objAcc.BillingStreet = objWOCOM.billing.address_1 + ' ' + objWOCOM.billing.address_2;
				         objAcc.BillingCity = objWOCOM.billing.city;
				         objAcc.BillingState = objWOCOM.billing.state;
				         objAcc.BillingCountry = objWOCOM.billing.country;
				         objAcc.BillingPostalCode = objWOCOM.billing.postcode;
				         
				         objAcc.ShippingStreet = objWOCOM.shipping.address_1 + ' ' + objWOCOM.shipping.address_2;
				         objAcc.ShippingCity = objWOCOM.shipping.city;
				         objAcc.ShippingState = objWOCOM.shipping.state;
				         objAcc.ShippingCountry = objWOCOM.shipping.country;
				         objAcc.ShippingPostalCode = objWOCOM.shipping.postcode;
				         
				         System.debug('Debug Log For objAcc: '+objAcc);
				         
				         //insert objAcc;
				         
				    } else {
			    		objAcc = lstAcc[0];	
			    		objAcc.ShippingStreet = objWOCOM.shipping.address_1 + ' ' + objWOCOM.shipping.address_2;
				        objAcc.ShippingCity = objWOCOM.shipping.city;
				        objAcc.ShippingState = objWOCOM.shipping.state;
				        objAcc.ShippingCountry = objWOCOM.shipping.country;
				        objAcc.ShippingPostalCode = objWOCOM.shipping.postcode;
				    }
				    upsert objAcc;
				    System.debug('Debug Log For objAcc: '+objAcc.Id);
				    List<Contact> lstContact = [Select Id, Name, Phone, Email, MailingStreet, MailingCity, MailingState, MailingPostalCode From Contact Where AccountId =: objAcc.Id];
				    Integer invCount = [Select count() From Invoice__c Where BOATBUILDING__Woocommerce_Id__c =: String.valueOf(objWOCOM.id)];
				    if(invCount == 0) {
					    Invoice__c objInvoice = new Invoice__c();
					    objInvoice.Name = 'Invoice for '+objAcc.Name;
				        objInvoice.Related_to_Contact__c = lstContact[0].Id;    
				        objInvoice.Customer_Name__c = lstContact[0].Name;
				        objInvoice.Phone_Number__c = lstContact[0].Phone;
				        objInvoice.Customer_Address__c = lstContact[0].MailingStreet;    
				        objInvoice.City__c = lstContact[0].MailingCity;
				        //objInvoice.Email__c = lstContact[0].Email;
				        objInvoice.Email__c = objWOCOM.billing.email;
				        objInvoice.Phone_Number__c = objWOCOM.billing.phone;
				        if(objWOCOM.customer_note != null )
				        	objInvoice.BOATBUILDING__Woocommerce_Customer_Notes__c = String.valueOf(objWOCOM.customer_note);
			        	if(objWOCOM.shipping_lines != null && objWOCOM.shipping_lines[0].method_title != null ) 
				        	objInvoice.BOATBUILDING__Shipping_Method__c = String.valueOf(objWOCOM.shipping_lines[0].method_title);
				        if(objWOCOM.shipping_total != null )
				        	objInvoice.BOATBUILDING__Shipping_Charge__c = Decimal.valueOf(String.valueOf(objWOCOM.shipping_total));
				        if(objWOCOM.discount_total != null )
				        	objInvoice.BOATBUILDING__Discount_on_Invoice__c = Decimal.valueOf(String.valueOf(objWOCOM.discount_total));	
				        		
				        objInvoice.BOATBUILDING__Woocommerce_Status__c = String.valueOf(objWOCOM.status);
				        objInvoice.BOATBUILDING__Web_Source__c = 'Woocommerce';
				        objInvoice.State__c = lstContact[0].MailingState;
				        objInvoice.Zip_Code__c = lstContact[0].MailingPostalCode;
				        objInvoice.RecordTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Web Invoices').getRecordTypeId();
				        objInvoice.BOATBUILDING__Woocommerce_Id__c = String.valueOf(objWOCOM.id);
				        
				        objInvoice.Customer_Address__c = objWOCOM.shipping.address_1 + ' ' + objWOCOM.shipping.address_2;
				        objInvoice.City__c = objWOCOM.shipping.city;
				        objInvoice.State__c = objWOCOM.shipping.state;
				        objInvoice.Zip_Code__c = objWOCOM.shipping.postcode;
				         
					    insert objInvoice;
					    
					    List<WoocommerceWebhook_Invoice.Line_items> lstLI = objWOCOM.line_items;
					    Set<String> setSFProductIds = new Set<String>();
			    		Map<String, WoocommerceWebhook_Invoice.Line_items> mapSPIdQt = new Map<String, WoocommerceWebhook_Invoice.Line_items>();
			    		System.debug('>>>>>>>lstLI: '+lstLI);
			    		if(!lstLI.isEmpty()) {
			    			for(WoocommerceWebhook_Invoice.Line_items objLI: lstLI) {
			    				if(objLI.variation_id != null) {
			    					setSFProductIds.add(String.valueOf(objLI.variation_id));
						    		mapSPIdQt.put(String.valueOf(objLI.variation_id), objLI); 
			    				} else {
						    		setSFProductIds.add(String.valueOf(objLI.product_id));
						    		mapSPIdQt.put(String.valueOf(objLI.product_id), objLI);
			    				} 	
						    }
						    System.debug('Debug Log For mapSPIdQt: '+mapSPIdQt);
						    List<BOATBUILDING__Part__c> lstOfParts = [SELECT 
					                                                        	Id, Name, Dealer_Price__c, Part_Number__c, Part_Cost__c, Retail_Price__c, 
					                                                        	Category1__c, Family1__c, Vendor_Name__c, Map_Price__c, Weight__c, Quantity__c,
					                                                        	BOATBUILDING__Woocommerce_Id__c
					                                                	FROM  
					                                                        	BOATBUILDING__Part__c 
				                                               		Where 
					                                               			BOATBUILDING__Woocommerce_Id__c IN: setSFProductIds];
					    	Map<String, WoocommerceWebhook_Invoice.Line_items> mapPCQt = new Map<String, WoocommerceWebhook_Invoice.Line_items>();
							
							for(BOATBUILDING__Part__c objPrt: lstOfParts) {
								mapSPIdQt.put(objPrt.Part_Number__c, mapSPIdQt.get(objPrt.BOATBUILDING__Woocommerce_Id__c));
								if(objPrt.Quantity__c != null) {
									objPrt.Quantity__c -= Decimal.valueOf(mapSPIdQt.get(objPrt.BOATBUILDING__Woocommerce_Id__c).quantity);
								} else {
									objPrt.Quantity__c = Decimal.valueOf(0 - mapSPIdQt.get(objPrt.BOATBUILDING__Woocommerce_Id__c).quantity);
								}
							}
							
							List<BOATBUILDING__Inventory__c> lstLineItem = [SELECT  
							                                                        Vendor__c, Size__c, Part_Number__c, Part_MSRP_Price__c, Part_Location__c, Minimum_Amount__c, 
							                                                        Map_Price__c, Quantity__c , Family__c, Discount__c, Description__c, Cost__c, Color__c, 
							                                                        Category__c, Part_Name__c, Taxable__c, Weight__c,
							                                                        (
							                                                        		Select Id, Name, BOATBUILDING__Inventory__c, BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
							                                                        		From BOATBUILDING__Parts_Availability__r
							                                                		   )
							                                            FROM
							                                                        BOATBUILDING__Inventory__c 
							                                            WHERE
							                                                        Part_Number__c IN: mapSPIdQt.keySet()];
							
			    			List<Parts_Availability__c> LstPA = new List<Parts_Availability__c>();
			    			List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
			                List<BOATBUILDING__Invoice_Line_Item__c> lstILI = new List<BOATBUILDING__Invoice_Line_Item__c>();
		            		if(objInvoice.Id != null) {
		            			if(!lstLineItem.isEmpty()) {
						            for(BOATBUILDING__Inventory__c objLI : lstLineItem) {
						                BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
						                if(mapSPIdQt.containsKey(objLI.Part_Number__c)) {
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
		            			}
								if(!lstOfParts.isEmpty()) {
		            				for(BOATBUILDING__Part__c objLI : lstOfParts) {
						                BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
						                if(mapSPIdQt.containsKey(objLI.Part_Number__c)) {
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
						                    lstILI.add(objILI);
						                } else { 
						                	
						                	objILI.Name = mapSPIdQt.get(objLI.Part_Number__c).variation_id != null ? String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).variation_id) : String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).product_id);
						                    objILI.Quantity__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).quantity);
						                    //objILI.Discount_Price__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).total_discount);
						                    objILI.Part_Cost__c = Decimal.valueOf(mapSPIdQt.get(objLI.Part_Number__c).price);
						                    //objILI.Dealer_Price__c = objLI.Cost__c;
						                    objILI.Part_Number__c = mapSPIdQt.get(objLI.Part_Number__c).variation_id != null ? String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).variation_id) : String.valueOf(mapSPIdQt.get(objLI.Part_Number__c).product_id);
						                    objILI.Related_To_Invoice__c = objInvoice.Id; 
						                    
						                    //objILI.Weight__c = objLI.Weight__c;
						                    //objILI.Taxable__c = objLI.Taxable__c; 
						                    //objILI.Category__c = objLI.Category__c;
						                    //objILI.Family__c = objLI.Family__c;
						                    lstILI.add(objILI);
						                }
		            				}
		            			} else {
		            				for(WoocommerceWebhook_Invoice.Line_items objLI: lstLI) {
							    		BOATBUILDING__Invoice_Line_Item__c objILI = new BOATBUILDING__Invoice_Line_Item__c();
							    		objILI.Name = objLI.variation_id != null ? String.valueOf(objLI.variation_id) : String.valueOf(objLI.product_id);
					                    objILI.Quantity__c = Decimal.valueOf(objLI.quantity);
					                    objILI.Part_Cost__c = Decimal.valueOf(objLI.price);
					                    objILI.Part_Number__c = objLI.variation_id != null ? String.valueOf(objLI.variation_id) : String.valueOf(objLI.product_id);
					                    objILI.Related_To_Invoice__c = objInvoice.Id;
					                    lstILI.add(objILI); 	 
								    }
		            			}
					        }
					        insert lstILI;
			        		
			        		if(!lstInv.isEmpty())	
			        			update lstInv;
			        		if(!LstPA.isEmpty()) 
			        			update LstPA;
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
		} catch(Exception ex) {
			System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Woocommerce Rest Log';
                objCL.BOATBUILDING__Summary__c = '' + ex.getMessage() + ' : ' + ex.getLineNumber()+'\n--\n'+ex.getStackTraceString(); 
                insert objCL;
             }
		}
	}
   
}