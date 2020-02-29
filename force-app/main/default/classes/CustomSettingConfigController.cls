public with sharing class CustomSettingConfigController {
    public SalesTaxConfiguration__c objSTC { get; set; }
    public List<SalesTaxWrapper> lstSTW { get; set; }
    
    public Dealer_Option__c objDO { get; set; }
    public List<DealerOptionWrapper> lstDOW { get; set; }
    
    public FroceDotCom__c objFDC { get; set; }
    public Boolean forceDotComBool { get; set ;}
    
    public LeadSourceToAccountRecordType__c objLSTART { get; set; }
    public List<LeadSourceToAccountRecordTypeWrapper> lstwrLSTART { get; set; } 
    
    public RoundRobin_Config__c objRR { get; set; }
    public List<RoundRobinWrapper> lstRRW { get; set; }
    
    public Trigger_Configuration__c objTC { get; set; } 
    public TriggerSetting__c objTS { get; set; }
    public Boolean triggerBool { get; set; }
    
    public Shop_Supplies__c objSS { get; set; }
    public Boolean ShopSupliesBool { get; set; }
    
    public Store_Location__c objSL { get; set; }
    public Boolean storeLocationBool { get; set; }
    
    public Update_Customer_Notification__c objUCN { get; set; }
    public List<UpdateCustomerNotificationWrapper> lstUCNW { get; set; }
    
    public UserRolesData__c objUDR { get; set; }
    public List<UserRolesDataWrapper> lstUDRW { get; set; }
    
    public WorkTypePricing__c objWTP { get; set; }
    public List<WorkTypePricingWrapper> lstWTPW { get; set; }
    
    public Template_WhyBuyFromUS__c objTWBFU { get; set; }
    public List<TemplateWhyBuyFromUSWrapper> lstTWBFUW { get; set; }
    
    public QBProductServiceConfig__c objQBPSC { get; set; }
    public List<QBProductServiceConfigWrapper> lstQBPSCW { get; set; } 
    
    public OAuthService__c objQBAuth { get; set; }
    public List<QuickBook_OAuthServiceWrapper> lstQBAuthW { get; set; }
    
    public EndPointURL__c objENU { get; set; }
    public List<EndPointURLWrapper> lstENUW { get; set; }

	public ExternalDatabaseConfig__c objED { get; set; }
    public List<ExternalDatabaseWrapper> lstEDW { get; set; }
    
    public ExternalNotificationEmail__c objENE { get; set; }
    public List<ExternalNotificationEmailWrapper> lstENEW { get; set; }
    public String strENEAccountCustomerType { get; set; }
    public List<SelectOption> listENEAccountCustomerType { get; set; }
 	
 	public List<UserScheduleWrapper> lstUserW { get; set; }
 	
 	
    public CustomSettingConfigController() {
    		
    		
    		
    		objSTC = new SalesTaxConfiguration__c();
    		objDO = new Dealer_Option__c();
    		
    		lstSTW = new List<SalesTaxWrapper>();
    		lstDOW = new List<DealerOptionWrapper>();
    		
    		objFDC = FroceDotCom__c.getOrgDefaults();
    		if(objFDC.Id != null) {
    			forceDotComBool = true;
    		} else {
    			forceDotComBool = false;
    		}
    		
    		objLSTART = new LeadSourceToAccountRecordType__c();
    		lstwrLSTART = new List<LeadSourceToAccountRecordTypeWrapper>();
    		
    		objRR = new RoundRobin_Config__c();
    		lstRRW = new List<RoundRobinWrapper>();
    		
    		objTC = Trigger_Configuration__c.getOrgDefaults();
    		objTS = TriggerSetting__c.getOrgDefaults();
    		if(objTC.Id !=  null && objTS.Id != null) {
    			triggerBool = true;
    		} else {
    			triggerBool = false;
    		}
    		
    		objSS = new Shop_Supplies__c();
    		List<Shop_Supplies__c> lstSS = Shop_Supplies__c.getAll().values();
    		if(!lstSS.isEmpty()) {
    			objSS = lstSS[0];
    		}
    		if(objSS.Id != null) {
    			ShopSupliesBool = true; 
    		} else {
    			ShopSupliesBool = false; 
    		}
    		
    		objSL = Store_Location__c.getOrgDefaults();
    		if(objSL.Id != null) {
    			storeLocationBool = true;
    		} else {
    			storeLocationBool = false;
    		}
    		
    		objUCN = new Update_Customer_Notification__c();
    		lstUCNW = new List<UpdateCustomerNotificationWrapper>();
    		
    		objUDR = new UserRolesData__c();
    		lstUDRW = new List<UserRolesDataWrapper>();
    		
    		objWTP = new WorkTypePricing__c();
    		lstWTPW = new List<WorkTypePricingWrapper>();
    		
    		objTWBFU = new Template_WhyBuyFromUS__c();
    		lstTWBFUW = new List<TemplateWhyBuyFromUSWrapper>(); 
    		
    		objQBPSC = new QBProductServiceConfig__c();
    		lstQBPSCW = new List<QBProductServiceConfigWrapper>();
    		
    		objQBAuth = new OAuthService__c();
    		lstQBAuthW = new List<QuickBook_OAuthServiceWrapper>(); 
    		
    		objENU = new EndPointURL__c();
    		lstENUW = new List<EndPointURLWrapper>();
    		
    		objED = new ExternalDatabaseConfig__c();
    		lstEDW = new List<ExternalDatabaseWrapper>();
    		
    		objENE = new ExternalNotificationEmail__c();
    		lstENEW = new List<ExternalNotificationEmailWrapper>();
    		
    		List<User> lstUser = [Select Id, Name, Schedule_Color_Code__c, Schedule_Texted_Color_Code__c From User Limit 1000];
    		lstUserW = new List<UserScheduleWrapper>();
    		for(User objUser: lstUser) {
    			lstUserW.add(new UserScheduleWrapper(objUser));
    		} 
    }
    
    public PageReference refreshAccess() {
    	delete [select Id from BOATBUILDING__AccessController__c];
    	return null;
    }
    
    public PageReference editUserRecord() {
    		try {
    			for(UserScheduleWrapper obj: lstUserW) {
    				if(obj.isChecked) { 
    					obj.isEdited = true; 
    				}  
    			} 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference updateUser() {
    		try {
    			List<User> lstUser = new List<User>();
    			for(UserScheduleWrapper obj: lstUserW) {
    				obj.isEdited = false;
    				lstUser.add(obj.objUser);
    			}
    			update lstUser;
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<ExternalNotificationEmailWrapper> getLstENE() {
        
        listENEAccountCustomerType = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Account.BOATBUILDING__Account_Customer_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            listENEAccountCustomerType.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
    
    	List<ExternalNotificationEmail__c> lstENE = ExternalNotificationEmail__c.getAll().values(); 
    	lstENEW = new List<ExternalNotificationEmailWrapper>();
    	
    	for(ExternalNotificationEmail__c obj: lstENE) {
    		lstENEW.add(new ExternalNotificationEmailWrapper(obj));
    	} 
    	return lstENEW;
    }
    
    public PageReference deleteENERecord() {
    		try {
    			List<ExternalNotificationEmail__c> lstENE = new List<ExternalNotificationEmail__c>();
    			for(ExternalNotificationEmailWrapper obj: lstENEW) {
    				if(obj.isChecked) {
    					lstENE.add(obj.objENE); 
    				}  
    			}
    			if(!lstENE.isEmpty()) {
    				delete lstENE;  	
    			} 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveENE() {
    		try {
    			insert objENE;
    			objENE = new ExternalNotificationEmail__c();
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<ExternalDatabaseWrapper>  getLstED() {
    		List<ExternalDatabaseConfig__c> lstED = ExternalDatabaseConfig__c.getAll().values(); 
    		lstEDW = new List<ExternalDatabaseWrapper>();
    		for(ExternalDatabaseConfig__c obj: lstED) {
    			lstEDW.add(new ExternalDatabaseWrapper(obj));
    		} 
    		return lstEDW;
    }
    
    public PageReference deleteEDRecord() {
    		try {
    			List<ExternalDatabaseConfig__c> lstED = new List<ExternalDatabaseConfig__c>();
    			for(ExternalDatabaseWrapper obj: lstEDW) {
    				if(obj.isChecked) {
    					lstED.add(obj.objED); 
    				}  
    			}
    			if(!lstED.isEmpty()) {
    				delete lstED;  	
    			} 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveED() {
    		try {
    			insert objED;
    			objED = new ExternalDatabaseConfig__c();
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<EndPointURLWrapper>  getLstENU() {
    		List<EndPointURL__c> lstENU = EndPointURL__c.getAll().values(); 
    		lstENUW = new List<EndPointURLWrapper>();
    		for(EndPointURL__c obj: lstENU) {
    			lstENUW.add(new EndPointURLWrapper(obj));
    		} 
    		return lstENUW;
    } 
    
    public PageReference deleteENURecord() {
    		try {
    			List<EndPointURL__c> lstENU = new List<EndPointURL__c>();
    			for(EndPointURLWrapper obj: lstENUW) {
    				if(obj.isChecked) {
    					lstENU.add(obj.objENU); 
    				}  
    			}
    			if(!lstENU.isEmpty()) {
    				delete lstENU;  	
    			} 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    } 
    
    public PageReference saveENU() {
    		try {
    			insert objENU;
    			objENU = new EndPointURL__c();
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<QuickBook_OAuthServiceWrapper>  getLstQBAuth() {
    		List<OAuthService__c> lstQBAuth = OAuthService__c.getAll().values(); 
    		lstQBAuthW = new List<QuickBook_OAuthServiceWrapper>();
    		for(OAuthService__c obj: lstQBAuth) {
    			lstQBAuthW.add(new QuickBook_OAuthServiceWrapper(obj));
    		} 
    		return lstQBAuthW;
    }
    
    public PageReference deleteQBAuthRecord() {
    		try {
    			List<OAuthService__c> lstQBAuth = new List<OAuthService__c>();
    			for(QuickBook_OAuthServiceWrapper obj: lstQBAuthW) {
    				if(obj.isChecked) {
    					lstQBAuth.add(obj.objQBAuth); 
    				}  
    			}
    			if(!lstQBAuth.isEmpty()) {
    				delete lstQBAuth; 	
    			} 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    } 
    
    public PageReference saveQBAuth() {
    		try {
    			insert objQBAuth;
    			objQBAuth = new OAuthService__c();
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<QBProductServiceConfigWrapper>  getLstQBPSC() {
    		List<QBProductServiceConfig__c> lstQBPSC = QBProductServiceConfig__c.getAll().values(); 
    		lstQBPSCW = new List<QBProductServiceConfigWrapper>();
    		for(QBProductServiceConfig__c obj: lstQBPSC) {
    			lstQBPSCW.add(new QBProductServiceConfigWrapper(obj));
    		} 
    		return lstQBPSCW;
    }
    
    public PageReference deleteQBPSCRecord() {
    		try {
    			List<QBProductServiceConfig__c> lstQBPSC = new List<QBProductServiceConfig__c>();
    			for(QBProductServiceConfigWrapper obj: lstQBPSCW) {
    				if(obj.isChecked) {
    					lstQBPSC.add(obj.objQBPSC); 
    				}  
    			}
    			if(!lstQBPSC.isEmpty()) {
    				delete lstQBPSC; 	
    			}
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveQBPSC() {
    		try {
    			insert objQBPSC;
    			objQBPSC = new QBProductServiceConfig__c();
    		} catch(Exception ex) { 
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<TemplateWhyBuyFromUSWrapper>  getLstTWBFU() {
    		List<Template_WhyBuyFromUS__c> lstTWBFU = Template_WhyBuyFromUS__c.getAll().values(); 
    		lstTWBFUW = new List<TemplateWhyBuyFromUSWrapper>();
    		for(Template_WhyBuyFromUS__c obj: lstTWBFU) {
    			lstTWBFUW.add(new TemplateWhyBuyFromUSWrapper(obj));
    		} 
    		return lstTWBFUW;
    }
    
    public PageReference deleteTWBFURecord() {
    		try {
    			List<Template_WhyBuyFromUS__c> lstTWBFU = new List<Template_WhyBuyFromUS__c>();
    			for(TemplateWhyBuyFromUSWrapper obj: lstTWBFUW) {
    				if(obj.isChecked) {
    					lstTWBFU.add(obj.objTWBFU); 
    				} 
    			}
    			if(!lstTWBFU.isEmpty()) {
    				delete lstTWBFU; 	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveTWBFU() {
    		try {
    			insert objTWBFU;
    			objTWBFU = new Template_WhyBuyFromUS__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<WorkTypePricingWrapper>  getLstWTP() {
    		List<WorkTypePricing__c> lstWTP = WorkTypePricing__c.getAll().values(); 
    		lstWTPW = new List<WorkTypePricingWrapper>();
    		for(WorkTypePricing__c obj: lstWTP) {
    			lstWTPW.add(new WorkTypePricingWrapper(obj));
    		} 
    		return lstWTPW;
    }
    
    public PageReference deleteWTPRecord() {
    		try {
    			List<WorkTypePricing__c> lstWTP = new List<WorkTypePricing__c>();
    			for(WorkTypePricingWrapper obj: lstWTPW) {
    				if(obj.isChecked) {
    					lstWTP.add(obj.objWTP); 
    				}
    			}
    			if(!lstWTP.isEmpty()) {
    				delete lstWTP; 	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveWTP() {
    		try {
    			insert objWTP;
    			objWTP = new WorkTypePricing__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		} 
    		return null;
    }
    
    public List<UserRolesDataWrapper>  getLstUDR() {
    		List<UserRolesData__c> lstUDR = UserRolesData__c.getAll().values(); 
    		lstUDRW = new List<UserRolesDataWrapper>();
    		for(UserRolesData__c obj: lstUDR) {
    			lstUDRW.add(new UserRolesDataWrapper(obj));
    		} 
    		return lstUDRW;
    }
    
    public PageReference deleteUDRRecord() {
    		try {
    			List<UserRolesData__c> lstUDR = new List<UserRolesData__c>();
    			for(UserRolesDataWrapper obj: lstUDRW) {
    				if(obj.isChecked) {
    					lstUDR.add(obj.objURD); 
    				}
    			}
    			if(!lstUDR.isEmpty()) {
    				delete lstUDR;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveUDR() {
    		try {
    			insert objUDR;
    			objUDR = new UserRolesData__c(); 
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		}
    		return null;
    }
    
    public List<UpdateCustomerNotificationWrapper>  getLstUCN() {
    		List<Update_Customer_Notification__c> lstUCN = Update_Customer_Notification__c.getAll().values(); 
    		lstUCNW = new List<UpdateCustomerNotificationWrapper>();
    		for(Update_Customer_Notification__c obj: lstUCN) {
    			lstUCNW.add(new UpdateCustomerNotificationWrapper(obj));
    		} 
    		return lstUCNW;
    }
    
    public PageReference deleteUCNRecord() {
    		try {
    			List<Update_Customer_Notification__c> lstUCN = new List<Update_Customer_Notification__c>();
    			for(UpdateCustomerNotificationWrapper obj: lstUCNW) {
    				if(obj.isChecked) {
    					lstUCN.add(obj.objUCN);
    				}
    			}
    			if(!lstUCN.isEmpty()) {
    				delete lstUCN;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveUCN() {
    		try {
    			insert objUCN;
    			objUCN = new Update_Customer_Notification__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		}
    		return null;
    }
    
    public PageReference saveStoreLocation() {
    		try {
    			upsert objSL;
    			objSL = Store_Location__c.getOrgDefaults();
    			storeLocationBool = true;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference editStoreLocation() {
    		storeLocationBool = false;
    		return null;
    }
    
    public PageReference deleteStoreLocation() {
    		try {
    			delete objSL;
    			objSL = Store_Location__c.getOrgDefaults();
    			storeLocationBool = false;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveShopSupplies() {
    		try {
    			objSS.Name = 'ShopSupplies';
    			upsert objSS;
    			List<Shop_Supplies__c> lstSS = Shop_Supplies__c.getAll().values();
	    		if(!lstSS.isEmpty()) {
	    			objSS = lstSS[0];
	    		}
    			ShopSupliesBool = true;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference editShopSupplies() {
    		ShopSupliesBool = false; 
    		return null;
    }
    
    public PageReference deleteShopSupplies() {
    		try {
    			delete objSS;
    			List<Shop_Supplies__c> lstSS = Shop_Supplies__c.getAll().values();
	    		if(!lstSS.isEmpty()) {
	    			delete lstSS;
	    		}
	    		objSS = new Shop_Supplies__c();
    			ShopSupliesBool = false;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public List<SalesTaxWrapper>  getLstSTC() {
    		List<SalesTaxConfiguration__c> lstSTC = SalesTaxConfiguration__c.getAll().values(); 
    		lstSTW = new List<SalesTaxWrapper>();
    		for(SalesTaxConfiguration__c obj: lstSTC) {
    			lstSTW.add(new SalesTaxWrapper(obj));
    		}
    		return lstSTW;
    }
    
    public PageReference saveSalesTax() {
    		try {
    			insert objSTC;
    			objSTC = new SalesTaxConfiguration__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		}
    		return null;
    }
    
    public PageReference deleteSalesTaxRecord() {
    		try {
    			List<SalesTaxConfiguration__c> lstSTRD = new List<SalesTaxConfiguration__c>();
    			for(SalesTaxWrapper obj: lstSTW) {
    				if(obj.isChecked) {
    					lstSTRD.add(obj.objSTW);
    				}
    			}
    			if(!lstSTRD.isEmpty()) {
    				delete lstSTRD;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public List<DealerOptionWrapper> getLstDO() {
    		List<Dealer_Option__c> lstDO = Dealer_Option__c.getAll().values();
    		lstDOW = new List<DealerOptionWrapper>(); 
    		for(Dealer_Option__c obj: lstDO) {
    			lstDOW.add(new DealerOptionWrapper(obj));
    		}
    		return lstDOW; 
    }
    
    public PageReference deleteDORecord() {
    		try {
    			List<Dealer_Option__c> lstDOD = new List<Dealer_Option__c>();
    			for(DealerOptionWrapper obj: lstDOW) {
    				if(obj.isChecked) {
    					lstDOD.add(obj.objDO);
    				}
    			}
    			if(!lstDOD.isEmpty()) {
    				delete lstDOD;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveDealerOption() {
    		try {
    			insert objDO;
    			objDO = new Dealer_Option__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveCreditAppURLs() {
    		try {
    			upsert objFDC;
    			objFDC = FroceDotCom__c.getOrgDefaults();
    			forceDotComBool = true;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    public PageReference editCreditAppURLs() {
    		forceDotComBool = false;
    		return null;
    }
    public PageReference deleteCreditAppURLs() {
    		try {
    			delete objFDC;
    			objFDC = FroceDotCom__c.getOrgDefaults();
    			forceDotComBool = false;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public List<LeadSourceToAccountRecordTypeWrapper> getLstLSTART() {
    		List<LeadSourceToAccountRecordType__c> lstLSTART = LeadSourceToAccountRecordType__c.getAll().values();
    		lstwrLSTART = new List<LeadSourceToAccountRecordTypeWrapper>(); 
    		for(LeadSourceToAccountRecordType__c obj: lstLSTART) {
    			lstwrLSTART.add(new LeadSourceToAccountRecordTypeWrapper(obj));
    		}
    		return lstwrLSTART; 
    }
    
    public PageReference deleteLSTARTRecord() {
    		try {
    			List<LeadSourceToAccountRecordType__c> lstLSRT = new List<LeadSourceToAccountRecordType__c>();
    			for(LeadSourceToAccountRecordTypeWrapper obj: lstwrLSTART) {
    				if(obj.isChecked) {
    					lstLSRT.add(obj.objLSTART);
    				}
    			}
    			if(!lstLSRT.isEmpty()) { 
    				delete lstLSRT;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
     
    public PageReference saveLSTART() {
    		try {
    			insert objLSTART;
    			objLSTART = new LeadSourceToAccountRecordType__c();
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		}
    		return null;
    } 
    
    public List<RoundRobinWrapper> getLstRR() {
    		List<RoundRobin_Config__c> lstLSTART = RoundRobin_Config__c.getAll().values();
    		lstRRW = new List<RoundRobinWrapper>(); 
    		for(RoundRobin_Config__c obj: lstLSTART) {
    			lstRRW.add(new RoundRobinWrapper(obj));
    		}
    		return lstRRW; 
    }
    
    public PageReference deleteRRRecord() {
    		try {
    			List<RoundRobin_Config__c> lstRRD = new List<RoundRobin_Config__c>();
    			for(RoundRobinWrapper obj: lstRRW) {
    				if(obj.isChecked) {
    					lstRRD.add(obj.objRR);
    				} 
    			}
    			if(!lstRRD.isEmpty()) { 
    				delete lstRRD;	
    			}
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
    
    public PageReference saveRR() {
    		try {
    			insert objRR;
    			objRR = new RoundRobin_Config__c();
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage); 
    		}
    		return null;
    }
     
    public PageReference editTriggerConfiguration() {
    		triggerBool = false;
    		return null;
    }
     
    public PageReference saveTriggerConfig() {
    		try {
    			upsert objTS;
    			upsert objTC;
    			objTS = TriggerSetting__c.getOrgDefaults();
    			objTC = Trigger_Configuration__c.getOrgDefaults();
    			triggerBool = true;
    			
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex);
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    }
     
    public PageReference deleteTriggerConfig() { 
    		try {
    			delete objTS;
    			delete objTC;
    			objTS = TriggerSetting__c.getOrgDefaults();
    			objTC = Trigger_Configuration__c.getOrgDefaults();
    			triggerBool = false;
    		} catch(Exception ex) {
    			System.debug('Debug Log For Exception: '+ex); 
    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
    		}
    		return null;
    } 
     
    public class SalesTaxWrapper {
    		public Boolean isChecked { get; set; }
    		public SalesTaxConfiguration__c objSTW { get; set; }
    		public SalesTaxWrapper(SalesTaxConfiguration__c objSTW) {
    			isChecked = false;
    			this.objSTW = objSTW;
    		}
    } 
    
    public class DealerOptionWrapper {
    		public Boolean isChecked { get; set; }
    		public Dealer_Option__c objDO { get; set; }
    		public DealerOptionWrapper(Dealer_Option__c objDO) {
    			isChecked = false;
    			this.objDO = objDO;
    		}
    }
     
    public class LeadSourceToAccountRecordTypeWrapper {
    		public Boolean isChecked { get; set; }
    		public LeadSourceToAccountRecordType__c objLSTART { get; set; }
    		public LeadSourceToAccountRecordTypeWrapper(LeadSourceToAccountRecordType__c objLSTART) {
    			isChecked = false; 
    			this.objLSTART = objLSTART;
    		}
    }
    
    public class RoundRobinWrapper {
    		public Boolean isChecked { get; set; }
    		public RoundRobin_Config__c objRR { get; set; }
    		public RoundRobinWrapper(RoundRobin_Config__c objRR) {
    			isChecked = false; 
    			this.objRR = objRR;
    		}
    }
    
    public class UpdateCustomerNotificationWrapper {
    		public Boolean isChecked { get; set; }
    		public Update_Customer_Notification__c objUCN { get; set; }
    		public UpdateCustomerNotificationWrapper(Update_Customer_Notification__c objUCN) {
    			isChecked = false; 
    			this.objUCN = objUCN;
    		}
    }
    
    public class UserRolesDataWrapper {
    		public Boolean isChecked { get; set; }
    		public UserRolesData__c objURD { get; set; }
    		public UserRolesDataWrapper(UserRolesData__c objURD) {
    			isChecked = false; 
    			this.objURD = objURD;
    		}
    }
    
    public class WorkTypePricingWrapper {
    		public Boolean isChecked { get; set; }
    		public WorkTypePricing__c objWTP { get; set; }
    		public WorkTypePricingWrapper(WorkTypePricing__c objWTP) {
    			isChecked = false; 
    			this.objWTP = objWTP;
    		}
    }
    
    public class TemplateWhyBuyFromUSWrapper {
    		public Boolean isChecked { get; set; }
    		public Template_WhyBuyFromUS__c objTWBFU { get; set; }
    		public TemplateWhyBuyFromUSWrapper(Template_WhyBuyFromUS__c objTWBFU) {
    			isChecked = false; 
    			this.objTWBFU = objTWBFU;
    		}
    }
    
    public class QBProductServiceConfigWrapper {
    		public Boolean isChecked { get; set; }
    		public QBProductServiceConfig__c objQBPSC { get; set; }
    		public QBProductServiceConfigWrapper(QBProductServiceConfig__c objQBPSC) {
    			isChecked = false;
    			this.objQBPSC = objQBPSC; 
    		}
    }
    public class QuickBook_OAuthServiceWrapper {
    		public Boolean isChecked { get; set; }
    		public OAuthService__c objQBAuth { get; set; }
    		public QuickBook_OAuthServiceWrapper(OAuthService__c objQBAuth) {
    			isChecked = false;
    			this.objQBAuth = objQBAuth; 
    		}
    }
    
    public class EndPointURLWrapper { 
    		public Boolean isChecked { get; set; }
    		public EndPointURL__c objENU { get; set; }
    		public EndPointURLWrapper(EndPointURL__c objENU) {
    			isChecked = false;
    			this.objENU = objENU; 
    		}
    }
    
    public class ExternalDatabaseWrapper { 
    		public Boolean isChecked { get; set; }
    		public ExternalDatabaseConfig__c objED { get; set; }
    		public ExternalDatabaseWrapper(ExternalDatabaseConfig__c objED) {
    			isChecked = false;
    			this.objED = objED;  
    		}
    }
    
    public class ExternalNotificationEmailWrapper { 
    		public Boolean isChecked { get; set; }
    		public ExternalNotificationEmail__c objENE { get; set; }
    		public ExternalNotificationEmailWrapper(ExternalNotificationEmail__c objENE) {
    			isChecked = false;
    			this.objENE = objENE;  
    		}
    }
    public class UserScheduleWrapper {
    		public Boolean isChecked { get; set; }
    		public Boolean isEdited { get; set; }
    		public User objUser { get; set; }
    		public UserScheduleWrapper(User objUser) {
    			isChecked = false;
    			isEdited = false;
    			this.objUser = objUser;
    		}
    }
}