/** 
* Author : Akshay Kumar 360 
* Created Date : 29/11/2016
*/
public with sharing class ApproveFromOrderController_Clone {
    
    public BOATBUILDING__Order__c objPurchaseOrder { get; set; }
    public BOATBUILDING__Manufacturer__c objManufacturer { get; set; }
    public String prtNum { get; set; } 
    public Integer totalQuantity { get; set; } 
    public Decimal totalOfTotal { get; set; }
    public Integer totalOfReceived { get; set; }
    public Decimal totalOfAmount { get; set; } 
    public Integer totalOfBackOrder { get; set; }
    public Decimal totalOfBackOrderAmount { get; set; } 
    public List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPurchaseOrderLineItems { get; set; }
    public List<PurchaseOrderLineItemsWrapper> lstPurchaseOrderLineItemsWrapper { get; set; }
    public Boolean isEdit { get; set; }
    public String message { get; set; }
    public String param { get; set; }
    
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    //Constructor 
    public ApproveFromOrderController_Clone(ApexPages.StandardController controller) {  
        prtNum = '';
        totalQuantity = 0;
        totalOfTotal = 0.00;
        totalOfReceived = 0; 
        totalOfAmount = 0.00;
        totalOfBackOrder = 0;
        isEdit = false;
        totalOfBackOrderAmount = 0.00;
        lstPurchaseOrderLineItemsWrapper = new List<PurchaseOrderLineItemsWrapper>();
        objPurchaseOrder = [SELECT Vendor_Name__c, Total_Amount__c, PO_Date__c, Name, Id, Amount_On_Order__c, 
        							(SELECT Id, Cost__c, Name, Dealer_Price__c, Retail_Price__c, Vendor_Name__c, Quantity__c, Part_Number__c,
                             Weight__c 
                             FROM 
                             BOATBUILDING__Purchase_Order_Line_Items__r) 
                            FROM 
                            BOATBUILDING__Order__c 
                            WHERE
                            Id =: ApexPages.currentPage().getParameters().get('Id')
                            LIMIT
                            1];
        if(objPurchaseOrder.Vendor_Name__c != null) {
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
                               Id =: objPurchaseOrder.Vendor_Name__c];
        }
        if(objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r.size() > 0) {
            for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r) {
                if(objPOLI.Quantity__c!=null ) {
                    totalQuantity += Integer.valueOf(objPOLI.Quantity__c);
                    if(objPOLI.Cost__c!=null) {
                        totalOfTotal += (objPOLI.Cost__c * Integer.valueOf(objPOLI.Quantity__c));
                    }
                }
                
                
                
                totalOfBackOrder = totalQuantity;
                totalOfBackOrderAmount = totalOfTotal;
                lstPurchaseOrderLineItemsWrapper.add(new PurchaseOrderLineItemsWrapper(objPOLI, 0));
            }
        }
        System.debug('Debug log For lstPurchaseOrderLineItemsWrapper : '+lstPurchaseOrderLineItemsWrapper);
        message = '';
    }
    
    public void refreshLineItem() {
    	prtNum = '';
        totalQuantity = 0;
        totalOfTotal = 0.00;
        totalOfReceived = 0; 
        totalOfAmount = 0.00;
        totalOfBackOrder = 0;
        //isEdit = false; 
        totalOfBackOrderAmount = 0.00; 
    	lstPurchaseOrderLineItemsWrapper = new list<PurchaseOrderLineItemsWrapper>();
    	objPurchaseOrder = [SELECT Vendor_Name__c, Total_Amount__c, PO_Date__c, Name, Id, Amount_On_Order__c, 
        							(SELECT Id, Cost__c, Name, Dealer_Price__c, Retail_Price__c, Vendor_Name__c, Quantity__c, Part_Number__c,
                             Weight__c 
                             FROM 
                             BOATBUILDING__Purchase_Order_Line_Items__r) 
                            FROM 
                            BOATBUILDING__Order__c 
                            WHERE
                            Id =: ApexPages.currentPage().getParameters().get('Id')
                            LIMIT
                            1];
        if(objPurchaseOrder.Vendor_Name__c != null) {
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
                               Id =: objPurchaseOrder.Vendor_Name__c];
        }
        if(objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r.size() > 0) {
            for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r) {
                if(objPOLI.Quantity__c!=null ) {
                    totalQuantity += Integer.valueOf(objPOLI.Quantity__c);
                    if(objPOLI.Cost__c!=null) {
                        totalOfTotal += (objPOLI.Cost__c * Integer.valueOf(objPOLI.Quantity__c));
                    }
                }
                
                
                
                totalOfBackOrder = totalQuantity;
                totalOfBackOrderAmount = totalOfTotal;
                lstPurchaseOrderLineItemsWrapper.add(new PurchaseOrderLineItemsWrapper(objPOLI, 0));
            }
        }
    }
    
    //Edit
    public void editPOApex() {
    	isEdit = true;
    }
    
    //vendor info
    public void getVendorInfoApex() {
    	objManufacturer = [SELECT Zip__c, Terms__c, Street__c, State__c, Phone__c, Name, Manufacturer_name__c, Id, Email__c, Description__c, Contact_Person__c, Contact_Person__r.Name, City__c 
                               
                               FROM
                               			BOATBUILDING__Manufacturer__c
                               WHERE 
                               			Id =: objPurchaseOrder.Vendor_Name__c]; 
    }
    
    public void updatePOApex() {
    	try {
    		update objPurchaseOrder;
    		List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
    		for(PurchaseOrderLineItemsWrapper objPurchaseOrderLineItemsWrapper: lstPurchaseOrderLineItemsWrapper) {
    			lstPOLI.add(objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem); 
    		}
    		update lstPOLI;
    		isEdit = false;
    		totalQuantity = 0;
    		totalOfTotal = 0;
    		if(objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r.size() > 0) {
	            for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r) {
	                if(objPOLI.Quantity__c!=null ) {
	                    totalQuantity += Integer.valueOf(objPOLI.Quantity__c);
	                    if(objPOLI.Cost__c!=null) {
	                        totalOfTotal += (objPOLI.Cost__c * Integer.valueOf(objPOLI.Quantity__c));
	                    }
	                }
	                
	                
	                
	                totalOfBackOrder = totalQuantity;
	                totalOfBackOrderAmount = totalOfTotal;
	            }
	        }
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Record Updated Successfully'));
    	} catch(Exception ex) {
    		message = ex.getMessage()+' : '+ex.getStackTraceString()+' Line: '+ex.getLineNumber(); 
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,message));
    	}
    }
    
    
    
    public void updateQuantityApex(){
    	//param
    	for(PurchaseOrderLineItemsWrapper objPurchaseOrderLineItemsWrapper: lstPurchaseOrderLineItemsWrapper) {
    		if(param == objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem.Id) {
    			if(objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem.Quantity__c!=null ) {
                    
                    if(objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem.Cost__c!=null) {
                        objPurchaseOrderLineItemsWrapper.total = (objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem.Cost__c * Integer.valueOf(objPurchaseOrderLineItemsWrapper.objPurchaseOrderLineItem.Quantity__c));
                    }
                }
    		}
    	}
    	totalQuantity = 0;
		totalOfTotal = 0;
		if(objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r.size() > 0) {
            for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : objPurchaseOrder.BOATBUILDING__Purchase_Order_Line_Items__r) {
                if(objPOLI.Quantity__c!=null ) {
                    totalQuantity += Integer.valueOf(objPOLI.Quantity__c);
                    if(objPOLI.Cost__c!=null) {
                        totalOfTotal += (objPOLI.Cost__c * Integer.valueOf(objPOLI.Quantity__c));
                    }
                }
                
                
                
                totalOfBackOrder = totalQuantity;
                totalOfBackOrderAmount = totalOfTotal;
            }
        }
    	
    }  
    
    
    //Generates the new Order 
    public PageReference createOrder() {
        
        System.debug('Order Generation.');
        Boolean isError = false;
        BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
        List<BOATBUILDING__Line_Items__c> lstOrderLineItem = new List<BOATBUILDING__Line_Items__c>();
        List<RecordType> lstRecType = [SELECT
                                       Id
                                       FROM
                                       RecordType
                                       WHERE
                                       SobjectType = 'BOATBUILDING__Order__c'
                                       AND
                                       DeveloperName = 'Order'
                                       LIMIT
                                       1];
        if(lstRecType.size() > 0) {
            objOrder.RecordTypeId = lstRecType[0].Id;
        }
        if(objPurchaseOrder.Vendor_Name__c != null) {
            objOrder.Vendor_Name__c = objPurchaseOrder.Vendor_Name__c;
        }
        objOrder.PO_Date__c = System.today();
        System.debug('Debug Log for objOrder'+objOrder);
        
        try {
            insert objOrder;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug log For Exception : '+ex);
        }
        lstPurchaseOrderLineItems = [SELECT 
                                     Id,
                                     Vendor_Name__c,
                                     Quantity__c,
                                     Cost__c,
                                     Retail_Price__c,
                                     Dealer_Price__c,
                                     Part_Number__c,
                                     Purchase_Order__c,
                                     Name,
                                     Bin__c,
                                     Category__c,
                                     Color__c,
                                     Discount__c,
                                     Family__c,
                                     Location__c,
                                     Map_Price__c,
                                     Minimum_Amount__c,
                                     Size__c,
                                     Taxable__c,
                                     Weight__c 
                                     
                                     FROM 
                                     BOATBUILDING__Purchase_Order_Line_Item__c
                                     WHERE 
                                     Purchase_Order__r.Id =: objPurchaseOrder.ID];
        
        Decimal quantityBaseTotal = 0.00;
        for(BOATBUILDING__Purchase_Order_Line_Item__c objPOLI : lstPurchaseOrderLineItems) {
            BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
            if(objPOLI.Part_Number__c!=null && objPOLI.Part_Number__c!='') {
                objLI.Part_Number_del__c = objPOLI.Part_Number__c;                      
            }
            if(objPOLI.Weight__c!=null && objPOLI.Weight__c!='') {
                objLI.Weight__c = objPOLI.Weight__c;                      
            }
            if(objPOLI.Name!=null && objPOLI.Name!='') {
                objLI.Name__c = objPOLI.Name;
            }
            if(objPOLI.Retail_Price__c!=null) {
                objLI.Retail_Price__c = objPOLI.Retail_Price__c;
            }
            else {
                objLI.Retail_Price__c = 0.00;
            }
            if(objPOLI.Dealer_Price__c!=null) {
                objLI.Dealer_Price__c = objPOLI.Dealer_Price__c;
            }
            else {
                objLI.Dealer_Price__c = 0.00;
            }
            if(objPOLI.Cost__c!=null) {
                objLI.Cost__c = objPOLI.Cost__c;
            }
            else {
                objLI.Cost__c = 0.00;
            }
            if(objPOLI.Quantity__c!=null) {
                objLI.Quantity__c = objPOLI.Quantity__c;
            }
            objLI.Order__c = objOrder.Id;
            objLI.Bin__c = objPOLI.Bin__c;
            objLI.Category__c = objPOLI.Category__c;
            objLI.Color__c = objPOLI.Color__c;
            objLI.Discount__c = objPOLI.Discount__c;
            objLI.Family__c = objPOLI.Family__c;
            objLI.Location__c = objPOLI.Location__c;
            objLI.Map_Price__c = objPOLI.Map_Price__c;
            objLI.Minimum_Amount__c = objPOLI.Minimum_Amount__c;
            objLI.Size__c = objPOLI.Size__c;
            if(objPOLI.Vendor_Name__c != null) {
                objLI.Vendor_Name__c = objPOLI.Vendor_Name__c;
            }
            objLI.Taxable__c = objPOLI.Taxable__c;
            quantityBaseTotal += objLI.Cost__c * objLI.Quantity__c ;
            lstOrderLineItem.add(objLI);
            
        }
        
        try {
            insert lstOrderLineItem;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        
        objOrder.Amount_On_Order__c = quantityBaseTotal;
        
        try {
            update objOrder;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        
        if(objOrder.Id != null) {
            try {
                delete objPurchaseOrder;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
        }
        
        if(!isError) {
            return new PageReference('/apex/ServicePage?subTabName=tab-default-3');
        }
        else {
            return null;
        }
    }
   
    @RemoteAction
    public static List<PartResultDiv> searchParts(String strPrtDetail) { 
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>(); 
        strPrtDetail = '%'+strPrtDetail+'%';  
        List<Part__c> lstPrt = [SELECT Vendor_Name__c, Retail_Price__c, Part_Number__c, Name, Id, Dealer_Price__c,Part_Cost__c,Weight__c FROM BOATBUILDING__Part__c  
                                                         Where 
                                                         (Part_Number__c LIKE: strPrtDetail OR Name LIKE: strPrtDetail) ];
        
        if(lstPrt.size() > 0) {
            for(Part__c objprt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objprt.Part_Number__c, objprt.Name, 0, objprt.Retail_Price__c)); 
            }
        }
        
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }    
        return null;
    }
    
    @RemoteAction
    public static String updateLIonOrder(List<String> lstprt,  Map<String, String> mapInventoryWithQuantity, String strPOId) {
    	try {
    	List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>(); 
    	List<Part__c> lstPart = [SELECT Discount__c,Taxable__c,Part_Size__c,Part_Color__c,Minimum_Amount__c,Map_Price__c,Location__c,Family1__c,Vendor_Name__c,Bin__c, Category1__c,Retail_Price__c, Part_Number__c, Name, Id, Dealer_Price__c,Part_Cost__c,Weight__c FROM BOATBUILDING__Part__c  
                                                         Where 
                                                         Part_Number__c IN: lstprt];
    	for(BOATBUILDING__Part__c objPrt : lstPart) {
                BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
                objPOLI.Name = objPrt.Name;
                objPOLI.Retail_Price__c = objPrt.Retail_Price__c;
                objPOLI.Dealer_Price__c = objPrt.Dealer_Price__c;
                objPOLI.Purchase_Order__c = strPOId;
                objPOLI.Part_Number__c = objPrt.Part_Number__c;
                objPOLI.Vendor_Name__c = objPrt.Vendor_Name__c;
                objPOLI.Cost__c = objPrt.Part_Cost__c;
                objPOLI.Quantity__c = Integer.valueOf(mapInventoryWithQuantity.get(objPrt.Part_Number__c));
                objPOLI.Bin__c = objPrt.Bin__c;
                objPOLI.Category__c = objPrt.Category1__c;
                objPOLI.Discount__c = objPrt.Discount__c;
                objPOLI.Family__c = objPrt.Family1__c;
                objPOLI.Location__c = objPrt.Location__c;
                objPOLI.Map_Price__c = objPrt.Map_Price__c;
                objPOLI.Minimum_Amount__c = objPrt.Minimum_Amount__c;
                objPOLI.Color__c = objPrt.Part_Color__c;
                objPOLI.Size__c = objPrt.Part_Size__c;
                objPOLI.Taxable__c = objPrt.Taxable__c;
                if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                    objPOLI.Weight__c = objPrt.Weight__c; 
                }
                
                lstPOLI.add(objPOLI);   
            }
            insert lstPOLI;
    	return 'SUCCESS';
    	}
    	catch(Exception ex) {
    		return ex.getMessage()+' : '+ex.getStackTraceString()+' Line: '+ex.getLineNumber();
    	}
    }
    
    public class PartResultDiv {
        public String PartNumber;
        public String PartName;
        public Integer Quantity;
        public Decimal MSRP;
        
        public PartResultDiv(String PartNumber, String PartName, Integer Quantity, Decimal MSRP) {
            this.PartNumber = PartNumber;
            this.PartName = PartName;
            this.Quantity = Quantity;
            this.MSRP = MSRP;
        }
    }
    
    public class PurchaseOrderLineItemsWrapper {
        public BOATBUILDING__Purchase_Order_Line_Item__c objPurchaseOrderLineItem { get; set; }
        public Decimal total { get; set; }
        public Integer received { get; set; }
        public Decimal ammount { get; set; }
        public Integer backOrderQuantity { get; set; }
        public Decimal backOrderAmount { get; set; }
        public PurchaseOrderLineItemsWrapper(BOATBUILDING__Purchase_Order_Line_Item__c objPurchaseOrderLineItem, Integer received) {
            this.objPurchaseOrderLineItem = objPurchaseOrderLineItem;
            if(objPurchaseOrderLineItem.Quantity__c != null && objPurchaseOrderLineItem.Cost__c != null ) {
                this.total = objPurchaseOrderLineItem.Quantity__c * objPurchaseOrderLineItem.Cost__c;
                this.backOrderAmount = objPurchaseOrderLineItem.Cost__c * objPurchaseOrderLineItem.Quantity__c;    
            }
            else {
                this.total = 0.00;   
                this.backOrderAmount = 0.00;
            }
            /*if(objPurchaseOrderLineItem.Shipping_Charge__c != null) {
total += objPurchaseOrderLineItem.Shipping_Charge__c;
}*/
            this.received = received;
            this.ammount = 0.00;
            this.backOrderAmount = 0.00;   
            if(objPurchaseOrderLineItem.Quantity__c != null) {
                this.backOrderQuantity = Integer.valueOf(objPurchaseOrderLineItem.Quantity__c);
            }
            else {
                this.backOrderQuantity = 0;
            }
        }
    }
}