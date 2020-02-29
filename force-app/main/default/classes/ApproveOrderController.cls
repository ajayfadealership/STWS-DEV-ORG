/** 
* Author                : Akshay Kumar
* Organization          : CloudCodiots LLP. 
* Created Date          : 29/11/2016
* Last Modified Date    : 18/10/2017
*/
public with sharing class ApproveOrderController {
    
    public BOATBUILDING__Order__c objOrder { get; set; }
    public BOATBUILDING__Manufacturer__c objManufacturer { get; set; }
    public String prtNum { get; set; }
    public Integer totalQuantity { get; set; }
    public Decimal totalOfTotal { get; set; }
    public Integer totalOfReceived { get; set; }
    public Decimal totalOfAmount { get; set; } 
    public Integer totalOfBackOrder { get; set; }
    public Decimal totalOfBackOrderAmount { get; set; } 
    public Decimal decDiscount { get; set; }
    public Decimal decShippingCharge { get; set; }
    public Decimal decGrandTotal { get; set; }
    public Boolean boolPDStatus { get; set; }
    public List<OrderLineItemsWrapper> lstOrderLineItemsWrapper { get; set; }
    public String btnStatus;
    String oneValue = '';
    
    public List<StoreLocationWrapper>  lstSlocationWrapper { get; set; }
    public Integer sCount = 0;
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    Set<String> setPicklistSL;
    //Constructor
    public ApproveOrderController(ApexPages.StandardController controller) {
    	boolPDStatus = true;
        setPicklistSL = new Set<String>();
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Order__c.Store_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        //Set<String> setPicklistSL = new Set<String>();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            setPicklistSL.add(pickListVal.getLabel());
        }  
        
        System.debug('pickListValuesList: ' + pickListValuesList);
        sCount = pickListValuesList.size(); 
        if(sCount == 1) {
            oneValue = pickListValuesList[0];
            boolPDStatus = false;
        } else if(sCount == 2 && (setPicklistSL.contains('Other') || setPicklistSL.contains('other'))) {
        	List<String> lstAll2 = new List<String>();
        	lstAll2.addAll(setPicklistSL); 
        	if(lstAll2[0] == 'Other' || lstAll2[0] == 'other') {
        		oneValue = lstAll2[1];
        		boolPDStatus = false;
        	} else if(lstAll2[1] == 'Other' || lstAll2[1] == 'other') {
        		oneValue = lstAll2[0];
        		boolPDStatus = false;
        	}
        }
        prtNum = '';
        totalQuantity = 0;
        totalOfTotal = 0.00; 
        totalOfReceived = 0;
        totalOfAmount = 0.00;
        totalOfBackOrder = 0;
        totalOfBackOrderAmount = 0.00;
        decShippingCharge = 0.00;
        decDiscount = 0.00;
        decGrandTotal = 0.00;
        lstOrderLineItemsWrapper = new List<OrderLineItemsWrapper>();
        
        lstSlocationWrapper = new List<StoreLocationWrapper>();
        
        objOrder = [SELECT 
                    AcocuntName__c,
                    Vendor_Name__c, 
                    Total_Amount__c, 
                    ContactName__c,
                    PO_Date__c, 
                    Name, 
                    Id, 
                    Amount_On_Order__c,
                    Remarks__c, 
                    BOATBUILDING__Order_Status__c,
                    (SELECT 
                     Id, 
                     Name,
                     Name__c,
                     Cost__c,
                     Order__c,
                     Amount__c, 
                     Dealer_Price__c, 
                     Retail_Price__c, 
                     Vendor_Name__c,
                     Unit_Price__c,
                     Part_Number_del__c, 
                     Quantity__c,
                     Category__c,
                     Bin__c,
                     Family__c,
                     Color__c,
                     Discount__c,
                     Location__c,
                     Map_Price__c,
                     Minimum_Amount__c,
                     Size__c,
                     Taxable__c,
                     Weight__c
                     FROM 
                     BOATBUILDING__LineItems__r) 
                    FROM 
                    BOATBUILDING__Order__c 
                    WHERE
                    Id =: ApexPages.currentPage().getParameters().get('Id')
                    LIMIT
                    1];
        if(objOrder.Vendor_Name__c != null) {
            objManufacturer = [SELECT
                               Zip__c, 
                               Terms__c, 
                               Street__c, 
                               State__c, 
                               Phone__c, 
                               Name, 
                               Manufacturer_name__c, 
                               Id, 
                               Email__c, 
                               Description__c, 
                               Contact_Person__c,
                               Contact_Person__r.Name,  
                               City__c 
                               FROM
                               BOATBUILDING__Manufacturer__c
                               WHERE 
                               Id =: objOrder.Vendor_Name__c];
        }
        if(objOrder.BOATBUILDING__LineItems__r.size() > 0) {
            for(BOATBUILDING__Line_Items__c objOLI : objOrder.BOATBUILDING__LineItems__r) {
                totalQuantity += Integer.valueOf(objOLI.Quantity__c);
                totalOfTotal += (objOLI.Cost__c * Integer.valueOf(objOLI.Quantity__c));
                totalOfBackOrder = totalQuantity;
                totalOfBackOrderAmount = totalOfTotal;
                lstOrderLineItemsWrapper.add(new OrderLineItemsWrapper(objOLI, 0));
            }
        }
        decGrandTotal = totalOfAmount; 
        System.debug('Debug log For lstOrderLineItemsWrapper : '+lstOrderLineItemsWrapper);
    }
    
    //Calculates all the related value with received
    public PageReference calculateAllValues() {
        //if(prtNum != null && prtNum != '') {
        System.debug('Called Successfuly : '+prtNum);
        totalOfReceived = 0;
        totalOfAmount = 0.00;
        totalOfBackOrder = 0; 
        totalOfBackOrderAmount = 0.00;
        for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
            if(objOLIW.objOrderLineItem.Part_Number_del__c == prtNum) {
                objOLIW.ammount = objOLIW.received * objOLIW.objOrderLineItem.Cost__c;
            }
            objOLIW.backOrderQuantity = Integer.valueOf(objOLIW.objOrderLineItem.Quantity__c - objOLIW.received);
            objOLIW.backOrderAmount = objOLIW.backOrderQuantity * objOLIW.objOrderLineItem.Cost__c ;
            totalOfBackOrder += objOLIW.backOrderQuantity;
            totalOfReceived += objOLIW.received;
            totalOfAmount += objOLIW.ammount;
            totalOfBackOrderAmount += objOLIW.backOrderAmount ;
            
        }
        decGrandTotal = totalOfAmount + decShippingCharge - decDiscount;
        return null;
    }
    
    public PageReference addToInventory() {
        try {
            Boolean isError = false;
            
            
            List<BOATBUILDING__Inventory__c> lstInventory = new List<BOATBUILDING__Inventory__c>();
            Set<String> setPartNumbers =  new Set<String>();
            Map<String,BOATBUILDING__Inventory__c> mapInventory = new Map<String,BOATBUILDING__Inventory__c>();
            for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                setPartNumbers.add(objOLIW.objOrderLineItem.Part_Number_del__c);
                System.debug('Debug Log for strPartNumbers'+setPartNumbers);
                
            }
            List<Parts_Availability__c> lstPA = new List<Parts_Availability__c>();
            List<RecordType> lstRecTypeInventory = [SELECT
                                                    Id
                                                    FROM
                                                    RecordType
                                                    WHERE
                                                    SobjectType = 'BOATBUILDING__Inventory__c'
                                                    AND
                                                    DeveloperName = 'Inventory_for_Parts'
                                                    LIMIT
                                                    1];
            
            if(lstRecTypeInventory.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstExistingInventory = [SELECT 
                                                                         Id,
                                                                         Vendor__c,
                                                                         Cost__c,
                                                                         Part_Number__c,
                                                                         Part_MSRP_Price__c,
                                                                         Description__c,
                                                                         Quantity__c,
                                                                         Taxable__c,
                                                                         Weight__c,
                                                                         (Select Id, IsDeleted, Name, BOATBUILDING__Inventory__c, 
                                                                          BOATBUILDING__Quantity__c, BOATBUILDING__Store_Location__c 
                                                                          From BOATBUILDING__Parts_Availability__r
                                                                         )
                                                                         FROM
                                                                         BOATBUILDING__Inventory__c
                                                                         WHERE 
                                                                         Part_Number__c IN: setPartNumbers
                                                                         AND
                                                                         RecordTypeID =:lstRecTypeInventory[0].Id
                                                                        ];
                if(lstExistingInventory.size()>0) {
                    System.debug('lstExistingInventory---'+lstExistingInventory);
                    System.debug('lstOrderLineItemsWrapper---'+lstOrderLineItemsWrapper);
                    for(BOATBUILDING__Inventory__c objInventory : lstExistingInventory) {
                        for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                            if(objOLIW.objOrderLineItem.Part_Number_del__c == objInventory.Part_Number__c) {
                                if(objOLIW.received > 0) {
                                    //objInventory.Quantity__c += objOLIW.received;
                                    objInventory.Cost__c = objOLIW.objOrderLineItem.Cost__c;
                                    objInventory.Part_Name__c = objOLIW.objOrderLineItem.Name__c;
                                    objInventory.Taxable__c = objOLIW.objOrderLineItem.Taxable__c;
                                    objInventory.Weight__c = objOLIW.objOrderLineItem.Weight__c;
                                    objInventory.Part_MSRP_Price__c = objOLIW.objOrderLineItem.Retail_Price__c;
                                    System.debug('objInventory.BOATBUILDING__Parts_Availability__r---'+objInventory.BOATBUILDING__Parts_Availability__r);
                                    System.debug('objInventory.objOLIW.lstSlocationD---'+objOLIW.lstSlocationD);
                                    
                                    Map<String, Parts_Availability__c> mapStoreLocToPA = new Map<String, Parts_Availability__c>();
                                    for(Parts_Availability__c objPA : objInventory.BOATBUILDING__Parts_Availability__r) {
                                        mapStoreLocToPA.put(objPA.Store_Location__c, objPA);
                                    }
                                    System.debug('>>>>>>>>>sCount: '+sCount);
                                    if(objOLIW.lstSlocationD.size() > 0 ) {
                                        for(StoreLocationWrapper objSLW: objOLIW.lstSlocationD) {
                                            System.debug('mapStoreLocToPA---'+mapStoreLocToPA);
                                            if(mapStoreLocToPA.containsKey(objSLW.objPA.Store_Location__c)){
                                                Parts_Availability__c pa = mapStoreLocToPA.get(objSLW.objPA.Store_Location__c);
                                                if(pa.BOATBUILDING__Quantity__c != null) {
                                                    pa.BOATBUILDING__Quantity__c += objSLW.objPA.BOATBUILDING__Quantity__c;
                                                } else {
                                                    pa.BOATBUILDING__Quantity__c = objSLW.objPA.BOATBUILDING__Quantity__c;
                                                }
                                                //System.debug('pa---'+pa);
                                                lstPA.add(pa);
                                            } else {
                                                Parts_Availability__c objPA = new Parts_Availability__c();
                                                objPA.Store_Location__c = objSLW.objPA.Store_Location__c;
                                                objPA.Inventory__c = objInventory.Id;
                                                objPA.BOATBUILDING__Quantity__c = objSLW.objPA.BOATBUILDING__Quantity__c;
                                                //System.debug('objPA---'+objPA);
                                                lstPA.add(objPA);
                                            }
                                        }
                                    } else if(sCount == 1) {
                                    	System.debug('>>>>: '+oneValue);
                                        Parts_Availability__c objPA = new Parts_Availability__c();
                                        objPA.Store_Location__c = oneValue;
                                        objPA.Inventory__c = objInventory.Id;
                                        objPA.BOATBUILDING__Quantity__c = objOLIW.received;
                                        lstPA.add(objPA);
                                        
                                    } else if(sCount == 2 && (setPicklistSL.contains('Other') || setPicklistSL.contains('other'))) {
                                    	System.debug('>>>>: '+oneValue);
                                    	
                                    	if(mapStoreLocToPA.containsKey(oneValue)){
                                    		Parts_Availability__c objPA = mapStoreLocToPA.get(oneValue);
                                    		objPA.Store_Location__c = oneValue;
	                                        //objPA.Inventory__c = objInventory.Id;
	                                        //objPA.BOATBUILDING__Quantity__c = objOLIW.received;
	                                        if(objPA.BOATBUILDING__Quantity__c != null) {
                                                objPA.BOATBUILDING__Quantity__c += objOLIW.received;
                                            } else { 
                                                objPA.BOATBUILDING__Quantity__c = objOLIW.received;
                                            } 
	                                        lstPA.add(objPA); 
                                    	} else {
                                    		Parts_Availability__c objPA = new Parts_Availability__c();
                                    		objPA.Store_Location__c = oneValue;
	                                        objPA.Inventory__c = objInventory.Id;
	                                        objPA.BOATBUILDING__Quantity__c = objOLIW.received;
	                                        lstPA.add(objPA);
                                    	}
                                        
                                       
                                    }else {
                                        if(objOLIW.lstSlocationD.size() > 0) {
                                            for(StoreLocationWrapper objSLW: objOLIW.lstSlocationD) {
                                                Parts_Availability__c objPA = new Parts_Availability__c();
                                                objPA.Store_Location__c = objSLW.objPA.Store_Location__c;
                                                objPA.Inventory__c = objInventory.Id;
                                                objPA.BOATBUILDING__Quantity__c = objSLW.objPA.BOATBUILDING__Quantity__c;
                                                lstPA.add(objPA);	
                                            }
                                        }	 
                                    }
                                }
                            }
                            mapInventory.put(objInventory.Part_Number__c,objInventory);
                        }
                    }
                    System.debug('Debug log for mapInventory'+mapInventory);
                    try {
                        update lstExistingInventory;
                    }
                    catch(Exception ex) {
                        isError = true;
                        SendEmailUtility.sendQuickEmail('Email For Add to inentory: '+ex.getMessage() +  '  :  ' + ex.getLineNumber());
                        System.debug('Debug Log For Exception : '+ex);
                    }
                    
                }
                Map<String, List<Parts_Availability__c>> mapPA = new Map<String, List<Parts_Availability__c>>();
                
                for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                    if(!mapInventory.containsKey(objOLIW.objOrderLineItem.Part_Number_del__c)) {
                        if(objOLIW.received > 0) {
                            BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
                            objInventory1.Part_Name__c = objOLIW.objOrderLineItem.Name__c;
                            objInventory1.Size__c = objOLIW.objOrderLineItem.Size__c;
                            objInventory1.Vendor__c = objOLIW.objOrderLineItem.Vendor_Name__c;
                            objInventory1.Part_Number__c = objOLIW.objOrderLineItem.Part_Number_del__c;
                            //objInventory1.Quantity__c = objOLIW.received;
                            objInventory1.Description__c = objOLIW.objOrderLineItem.Name__c;
                            objInventory1.Cost__c = objOLIW.objOrderLineItem.Cost__c;
                            objInventory1.Category__c = objOLIW.objOrderLineItem.Category__c;
                            objInventory1.Bin__c = objOLIW.objOrderLineItem.Bin__c;
                            objInventory1.Color__c = objOLIW.objOrderLineItem.Color__c;
                            objInventory1.Discount__c = objOLIW.objOrderLineItem.Discount__c;
                            objInventory1.Part_Location__c = objOLIW.objOrderLineItem.Location__c;
                            objInventory1.Map_Price__c = objOLIW.objOrderLineItem.Map_Price__c;
                            objInventory1.Minimum_Amount__c = objOLIW.objOrderLineItem.Minimum_Amount__c;
                            objInventory1.RecordTypeID = lstRecTypeInventory[0].Id;
                            objInventory1.Taxable__c= objOLIW.objOrderLineItem.Taxable__c;
                            objInventory1.Weight__c = objOLIW.objOrderLineItem.Weight__c;
                            objInventory1.Part_MSRP_Price__c = objOLIW.objOrderLineItem.Retail_Price__c;
                            lstInventory.add(objInventory1);
                            if(objOLIW.lstSlocationD.size() > 0) {
                                for(StoreLocationWrapper objSL: objOLIW.lstSlocationD) {
                                    if(!mapPA.containsKey(objInventory1.Part_Name__c)) {
                                        mapPA.put(objInventory1.Part_Name__c, new List<Parts_Availability__c>());	
                                    } 
                                    if(mapPA.containsKey(objInventory1.Part_Name__c)) {
                                        mapPA.get(objInventory1.Part_Name__c).add(objSL.objPA); 
                                    }
                                }
                            } else if(sCount == 1) {
                            	System.debug('>>>>: '+oneValue);
                                Parts_Availability__c objPA = new Parts_Availability__c();
                                objPA.Store_Location__c = oneValue;
                                objPA.Inventory__c = objInventory1.Id;
                                objPA.BOATBUILDING__Quantity__c = objOLIW.received;
                                
                                if(!mapPA.containsKey(objInventory1.Part_Name__c)) {
                                    mapPA.put(objInventory1.Part_Name__c, new List<Parts_Availability__c>());	
                                } 
                                if(mapPA.containsKey(objInventory1.Part_Name__c)) {
                                    mapPA.get(objInventory1.Part_Name__c).add(objPA); 
                                }
                            } else if(sCount == 2 && (setPicklistSL.contains('Other') || setPicklistSL.contains('other'))) {
                            	System.debug('>>>>: '+oneValue);
                        		Parts_Availability__c objPA = new Parts_Availability__c();
                        		objPA.Store_Location__c = oneValue; 
                                objPA.Inventory__c = objInventory1.Id;
                                objPA.BOATBUILDING__Quantity__c = objOLIW.received;
                                //lstPA.add(objPA);
                                if(!mapPA.containsKey(objInventory1.Part_Name__c)) {
                                    mapPA.put(objInventory1.Part_Name__c, new List<Parts_Availability__c>());	
                                }
                                if(mapPA.containsKey(objInventory1.Part_Name__c)) {
                                    mapPA.get(objInventory1.Part_Name__c).add(objPA); 
                                }
                            }
                        }
                        System.debug('Debug Log For lstInventory'+lstInventory);
                    }
                    
                }
                
                try {
                    insert lstInventory;
                    for(Inventory__c objInv: lstInventory) {	
                        if(mapPA.containsKey(objInv.Part_Name__c)) {
                            List<Parts_Availability__c> lstPAA = mapPA.get(objInv.Part_Name__c);
                            for(Parts_Availability__c objPA: lstPAA) {
                                objPA.Inventory__c = objInv.Id;
                                lstPA.add(objPA);
                            }	
                        } 
                        
                    }
                    System.debug('lstPA---'+lstPA);
                    upsert lstPA;
                }
                catch(Exception ex) {
                    isError = true;
                    SendEmailUtility.sendQuickEmail('Email For Add to inentory: '+ex.getStackTraceString() +  '  :  ' + ex.getLineNumber());
                    System.debug('Debug Log For Exception : '+ex.getStackTraceString());
                }
                if(!isError) {
                    System.debug('New Inventory created');
                    List<RecordType> lstRecTypeOrder = [SELECT
                                                        Id
                                                        FROM
                                                        RecordType
                                                        WHERE
                                                        SobjectType = 'BOATBUILDING__Order__c'
                                                        AND
                                                        DeveloperName = 'Purchase_Order_Approved'
                                                        LIMIT
                                                        1];
                    if(lstRecTypeOrder.size() > 0) {
                        objOrder.RecordTypeId = lstRecTypeOrder[0].Id;
                        objOrder.Is_Approved__c = true;
                        objOrder.Shipping_Charges__c = decShippingCharge;
                        objOrder.Discount_Price__c = decDiscount;
                    } 
                    
                    try {
                        
                        update objOrder;
                    }
                    
                    catch(Exception ex) {
                        SendEmailUtility.sendQuickEmail('Email For Add to inentory: '+ex.getMessage() +  '  :  ' + ex.getLineNumber());
                        System.debug('Debug Log for excp1'+ex);
                    }
                    
                    
                    
                    return new PageReference('/apex/ServicePage?subTabName=tab-default-5');
                }
                else {
                    SendEmailUtility.sendQuickEmail('Email For Add to inentory366: ');
                    return null;
                }
                
            }
            else {
                SendEmailUtility.sendQuickEmail('Email For Add to inentory372');
                return null;
            }
        } catch(Exception ex) {
            SendEmailUtility.sendQuickEmail('Email For Add to inentory: '+ex.getMessage() +  '  :  ' + ex.getLineNumber());
            return null;
        }
    }

    public PageReference updateStatus() {
        update objOrder;
        return null;
    }
    
    public PageReference createBackOrder() {
        Boolean isError = false;
        Map<String, BOATBUILDING__Line_Items__c> mapPOLI = new Map<String, BOATBUILDING__Line_Items__c>();
        Map<String, BOATBUILDING__Inventory__c> mapInventory = new Map<String,BOATBUILDING__Inventory__c>();
        List<BOATBUILDING__Order__c> lstbackPurchaseOrder = new List<BOATBUILDING__Order__c>();
        List<BOATBUILDING__Inventory__c> lstInventory = new List<BOATBUILDING__Inventory__c>();
        
        BOATBUILDING__Order__c objBackPurchaseOrder = new BOATBUILDING__Order__c();
        List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPurchaseOrderLineItem = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
        
        if(objOrder.BOATBUILDING__LineItems__r.size() > 0) {
            for(BOATBUILDING__Line_Items__c objOLI : objOrder.BOATBUILDING__LineItems__r) {
                mapPOLI.put(objOLI.Part_Number_del__c, objOLI);
            }
            Integer rec = 0;
            Decimal recAmt = 0.00;
            Integer bckOrdr = 0;
            Decimal bckOrdrAmt = 0.00;
            for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                if(mapPOLI.containsKey(objOLIW.objOrderLineItem.Part_Number_del__c)) {
                    rec += objOLIW.received;
                    recAmt += objOLIW.ammount;
                    bckOrdr += objOLIW.backOrderQuantity;
                    bckOrdrAmt += objOLIW.backOrderAmount;
                }
            }
            
            
            List<RecordType> lstRecTypeInventory = [SELECT
                                                    Id
                                                    FROM
                                                    RecordType
                                                    WHERE
                                                    SobjectType = 'BOATBUILDING__Inventory__c'
                                                    AND
                                                    DeveloperName = 'Inventory_for_Parts'
                                                    LIMIT
                                                    1];
            if(lstRecTypeInventory.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstExistingInventory = [SELECT 
                                                                         Id,
                                                                         Vendor__c,
                                                                         Cost__c,
                                                                         Part_Number__c,
                                                                         Part_MSRP_Price__c,
                                                                         Description__c,
                                                                         Quantity__c,
                                                                         Taxable__c,
                                                                         Weight__c
                                                                         
                                                                         FROM
                                                                         BOATBUILDING__Inventory__c
                                                                         WHERE 
                                                                         Part_Number__c IN: mapPOLI.keySet()
                                                                         AND
                                                                         RecordTypeID =:lstRecTypeInventory[0].Id
                                                                        ];
                if(lstExistingInventory.size()>0) {
                    for(BOATBUILDING__Inventory__c objInventory : lstExistingInventory) {
                        for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                            if(objOLIW.objOrderLineItem.Part_Number_del__c == objInventory.Part_Number__c) {
                                if(objOLIW.received > 0){
                                    objInventory.Quantity__c += objOLIW.received;
                                    objInventory.Cost__c = objOLIW.objOrderLineItem.Cost__c;
                                    objInventory.Part_Name__c = objOLIW.objOrderLineItem.Name__c;
                                    objInventory.Taxable__c = objOLIW.objOrderLineItem.Taxable__c;
                                    objInventory.Weight__c = objOLIW.objOrderLineItem.Weight__c;
                                    objInventory.Part_MSRP_Price__c = objOLIW.objOrderLineItem.Retail_Price__c;
                                }
                            }
                            
                            System.debug('Existing Inventory Updated');
                            mapInventory.put(objInventory.Part_Number__c,objInventory);
                            System.debug('Debug log for mapInventory'+mapInventory);
                        }
                    }
                    
                    update lstExistingInventory;
                    
                }
                
                List<RecordType> lstRecTypeBackOrder = [SELECT
                                                        Id
                                                        FROM
                                                        RecordType
                                                        WHERE
                                                        SobjectType = 'BOATBUILDING__Order__c'
                                                        AND
                                                        DeveloperName = 'Purchase_Order'
                                                        LIMIT
                                                        1];
                
                if(lstRecTypeBackOrder.size() > 0) {
                    objBackPurchaseOrder.RecordTypeId = lstRecTypeBackOrder[0].Id;
                }
                objBackPurchaseOrder.Vendor_Name__c = objOrder.Vendor_Name__c;
                objBackPurchaseOrder.PO_Date__c = System.Today();
                
                try {
                    
                    insert objBackPurchaseOrder;
                }
                
                catch(Exception ExbackPurchaseOrder) {
                    isError = true;
                    System.debug('Debug Log For Exception while inserting lstbackPurchaseOrder : '+ExbackPurchaseOrder);
                }
                Decimal purchaseOrderAmountTotal = 0.00;
                for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
                    if(!mapInventory.containsKey(objOLIW.objOrderLineItem.Part_Number_del__c)) {
                        if(objOLIW.received > 0) {
                            BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
                            objInventory1.Part_Name__c = objOLIW.objOrderLineItem.Name__c;
                            objInventory1.Size__c = objOLIW.objOrderLineItem.Size__c;
                            objInventory1.Vendor__c = objOLIW.objOrderLineItem.Vendor_Name__c;
                            objInventory1.Part_Number__c = objOLIW.objOrderLineItem.Part_Number_del__c;
                            objInventory1.Quantity__c = objOLIW.received;
                            objInventory1.Description__c = objOLIW.objOrderLineItem.Name__c;
                            objInventory1.Cost__c = objOLIW.objOrderLineItem.Cost__c;
                            objInventory1.Category__c = objOLIW.objOrderLineItem.Category__c;
                            objInventory1.Bin__c = objOLIW.objOrderLineItem.Bin__c;
                            objInventory1.Color__c = objOLIW.objOrderLineItem.Color__c;
                            objInventory1.Discount__c = objOLIW.objOrderLineItem.Discount__c;
                            objInventory1.Part_Location__c = objOLIW.objOrderLineItem.Location__c;
                            objInventory1.Map_Price__c = objOLIW.objOrderLineItem.Map_Price__c;
                            objInventory1.Minimum_Amount__c = objOLIW.objOrderLineItem.Minimum_Amount__c;
                            objInventory1.RecordTypeID = lstRecTypeInventory[0].Id;
                            objInventory1.Taxable__c = objOLIW.objOrderLineItem.Taxable__c;
                            objInventory1.Weight__c = objOLIW.objOrderLineItem.Weight__c;
                            objInventory1.Part_MSRP_Price__c = objOLIW.objOrderLineItem.Retail_Price__c;
                            lstInventory.add(objInventory1);
                        }
                    }
                    
                    
                    if(objOLIW.backOrderQuantity > 0) {
                        System.debug('Debug Log for lstbackPurchaseOrder' +lstbackPurchaseOrder);
                        BOATBUILDING__Purchase_Order_Line_Item__c objPurchaseOrderLineItem = new BOATBUILDING__Purchase_Order_Line_Item__c();
                        objPurchaseOrderLineItem.Name = objOLIW.objOrderLineItem.Name__c;
                        objPurchaseOrderLineItem.Purchase_Order__c = objBackPurchaseOrder.Id;
                        objPurchaseOrderLineItem.Retail_Price__c = objOLIW.objOrderLineItem.Retail_Price__c;
                        objPurchaseOrderLineItem.Dealer_Price__c = objOLIW.objOrderLineItem.Dealer_Price__c;
                        objPurchaseOrderLineItem.Vendor_Name__c = objOLIW.objOrderLineItem.Vendor_Name__c;
                        objPurchaseOrderLineItem.Quantity__c = objOLIW.backOrderQuantity;
                        objPurchaseOrderLineItem.Part_Number__c = objOLIW.objOrderLineItem.Part_Number_del__c;
                        objPurchaseOrderLineItem.Cost__c = objOLIW.objOrderLineItem.Cost__c;
                        objPurchaseOrderLineItem.Bin__c = objOLIW.objOrderLineItem.Bin__c;
                        objPurchaseOrderLineItem.Category__c = objOLIW.objOrderLineItem.Category__c;
                        objPurchaseOrderLineItem.Discount__c = objOLIW.objOrderLineItem.Discount__c;
                        objPurchaseOrderLineItem.Family__c = objOLIW.objOrderLineItem.Family__c;
                        objPurchaseOrderLineItem.Location__c = objOLIW.objOrderLineItem.Location__c;
                        objPurchaseOrderLineItem.Map_Price__c = objOLIW.objOrderLineItem.Map_Price__c;
                        objPurchaseOrderLineItem.Minimum_Amount__c = objOLIW.objOrderLineItem.Minimum_Amount__c;
                        objPurchaseOrderLineItem.Color__c = objOLIW.objOrderLineItem.Color__c;
                        objPurchaseOrderLineItem.Size__c = objOLIW.objOrderLineItem.Size__c;
                        objPurchaseOrderLineItem.Taxable__c = objOLIW.objOrderLineItem.Taxable__c;
                        /*if(objOLIW.objOrderLineItem.Shipping_Charge__c != null) {
objPurchaseOrderLineItem.Shipping_Charge__c = objOLIW.objOrderLineItem.Shipping_Charge__c;
}*/
                        objPurchaseOrderLineItem.Weight__c = objOLIW.objOrderLineItem.Weight__c;
                        purchaseOrderAmountTotal += (objPurchaseOrderLineItem.Cost__c * objPurchaseOrderLineItem.Quantity__c) ;
                        /*if(objPurchaseOrderLineItem.Shipping_Charge__c != null) {
purchaseOrderAmountTotal += objPurchaseOrderLineItem.Shipping_Charge__c;
}*/
                        lstPurchaseOrderLineItem.add(objPurchaseOrderLineItem);
                    }
                    
                }
                
                try {
                    insert lstInventory;
                    
                }
                catch(Exception exc) {
                    isError = true;
                    System.debug('Debug Log For Exception while inserting lstInventory : '+exc);
                }
                
                
                
                if(!isError) {
                    List<RecordType> lstRecTypeOrder = [SELECT
                                                        Id
                                                        FROM
                                                        RecordType
                                                        WHERE
                                                        SobjectType = 'BOATBUILDING__Order__c'
                                                        AND
                                                        DeveloperName = 'Purchase_Order_Approved'
                                                        LIMIT
                                                        1];
                    if(lstRecTypeOrder.size() > 0) {
                        objOrder.RecordTypeId = lstRecTypeOrder[0].Id;
                        objOrder.Is_Approved__c = true;
                        objOrder.Shipping_Charges__c = decShippingCharge;
                        objOrder.Discount_Price__c = decDiscount;
                    }
                    
                    try {
                        insert lstPurchaseOrderLineItem;
                        update objOrder;
                    }
                    
                    catch(Exception excp1) {
                        
                        System.debug('Debug Log for excp1'+excp1);
                    }
                    
                    objBackPurchaseOrder.Amount_On_Order__c = purchaseOrderAmountTotal;
                    
                    try {
                        update objBackPurchaseOrder;
                    }
                    
                    catch(Exception exceptionUpdatePO) {
                        isError=true;
                        System.debug('Debug Log For Exception while updating PurchaseBackOrder' +exceptionUpdatePO);
                    }
                    return new PageReference('/apex/ServicePage?subTabName=tab-default-5');
                }
                else {
                    return null;
                }
                
                
            }
            
            
            List<RecordType> lstRecType2 = [SELECT
                                            Id
                                            FROM
                                            RecordType
                                            WHERE
                                            SobjectType = 'BOATBUILDING__Order__c'
                                            AND
                                            DeveloperName = 'Purchase_Order_Approved'
                                            LIMIT
                                            1];
            if(lstRecType2.size() > 0) {
                objOrder.RecordTypeId = lstRecType2[0].Id;
                objOrder.Is_Approved__c = true;
                objOrder.Shipping_Charges__c = decShippingCharge;
                objOrder.Discount_Price__c = decDiscount;
            }
            try {
                update objOrder;
                update mapPOLI.values();
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            if(!isError) {
                return new PageReference('/'+objOrder.Id);
            }
            else {
                return null;
            }
            
        }
        else {
            return null;
        }
    }
    
    public PageReference printOrder() {
        btnStatus = 'Print';
        objOrder.Shipping_Charges__c = decShippingCharge;
        objOrder.Discount_Price__c = decDiscount;
        try {
            update objOrder;
            
            BOATBUILDING__PrintPageConfig__c objPPC = BOATBUILDING__PrintPageConfig__c.getOrgDefaults();
            if(objPPC != null) { 
                if(objPPC.BOATBUILDING__Sales_Page_Skip__c) {
                    return new PageReference('/apex/Order_As_PDF_Exampleskp?scontrolCaching=1&id='+ApexPages.currentPage().getParameters().get('Id')+'&btnStatus='+btnStatus);
                } else {
                    return new PageReference('/apex/Order_As_PDF_Example?scontrolCaching=1&id='+ApexPages.currentPage().getParameters().get('Id')+'&btnStatus='+btnStatus);
                }
            } else {
                return new PageReference('/apex/Order_As_PDF_Example?scontrolCaching=1&id='+ApexPages.currentPage().getParameters().get('Id')+'&btnStatus='+btnStatus);	
            }
            
        }
        catch(Exception ex) {
            System.debug('Debug Log For Exception : '+ex);
            return null;
        }
        
    }
    
    public PageReference sendOrder() {
        
        objOrder.Shipping_Charges__c = decShippingCharge;
        objOrder.Discount_Price__c = decDiscount;
        try {
            update objOrder;
            
            
            return new PageReference('/apex/SendOrderDetailPage?id='+ApexPages.currentPage().getParameters().get('Id'));
        }
        catch(Exception ex) {
            System.debug('Debug Log For Exception : '+ex);
            return null;
        }
    }
    
    public class OrderLineItemsWrapper {
        public BOATBUILDING__Line_Items__c objOrderLineItem { get; set; }
        public Decimal total { get; set; }
        public Integer received { get; set; }
        public Decimal ammount { get; set; }
        public Integer backOrderQuantity { get; set; }
        public Decimal backOrderAmount { get; set; }
        public List<StoreLocationWrapper>  lstSlocationD { get; set; } 
        public OrderLineItemsWrapper(BOATBUILDING__Line_Items__c objOrderLineItem, Integer received) {
            System.debug('Debug Log For objOrderLineItem : '+objOrderLineItem);
            this.objOrderLineItem = objOrderLineItem;
            if(objOrderLineItem.Quantity__c != null && objOrderLineItem.Cost__c != null) {
                this.total = objOrderLineItem.Quantity__c * objOrderLineItem.Cost__c ;
                this.backOrderAmount = objOrderLineItem.Cost__c * objOrderLineItem.Quantity__c ;
                System.debug('Debug Log For backOrderAmount : '+this.backOrderAmount);
            }
            else {
                this.total = 0.00;   
                this.backOrderAmount = 0.00;
            }
            this.received = received;
            this.ammount = 0.00;  
            if(objOrderLineItem.Quantity__c != null) {
                this.backOrderQuantity = Integer.valueOf(objOrderLineItem.Quantity__c);
            }
            else {
                this.backOrderQuantity = 0;
            }
            lstSlocationD = new List<StoreLocationWrapper>();
        }
    }
    
    public class StoreLocationWrapper {
        public BOATBUILDING__Parts_Availability__c objPA { get; set; }
        public StoreLocationWrapper(BOATBUILDING__Parts_Availability__c objPA) {
            this.objPA = objPA;	
        }
    }
    
    public PageReference SaveLocationsToInv() {
        for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
            if(objOLIW.objOrderLineItem.Part_Number_del__c == prtNum) {
                //lstSlocationD = new List<StoreLocationWrapper>();
                for(StoreLocationWrapper objSLW:  lstSlocationWrapper) {
                    //objOLIW.lstSlocationD = new List<StoreLocationWrapper>();
                    objOLIW.lstSlocationD.add(objSLW);
                } 
                break;
            }
        }
        lstSlocationWrapper = new List<StoreLocationWrapper>();
        return null;
    }
    
    public PageReference addSlocation() {
        if(sCount > lstSlocationWrapper.size()) {
            lstSlocationWrapper.add(new StoreLocationWrapper(new BOATBUILDING__Parts_Availability__c()));
        }
        return null;
    }
    
    public PageReference distributeTheParts() {
        lstSlocationWrapper = new List<StoreLocationWrapper>();
        for(OrderLineItemsWrapper objOLIW : lstOrderLineItemsWrapper) {
            if(objOLIW.objOrderLineItem.Part_Number_del__c == prtNum) {
                //lstSlocationWrapper = objOLIW.lstSlocationD;
                lstSlocationWrapper.addAll(objOLIW.lstSlocationD);
                /*for(StoreLocationWrapper objSLW: objOLIW.lstSlocationD) {
                    lstSlocationWrapper.add(objSLW);
                } */
            }
        }
        return null;
    }
    
}