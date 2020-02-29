public with sharing class PurchaseOrderController {
    
    public BOATBUILDING__Order__c objOrder { get; set; }

    //Constructor
    public PurchaseOrderController() {
        objOrder = new BOATBUILDING__Order__c();
    }

    //Returns the selected verndor.
    @RemoteAction
    public static List<BOATBUILDING__Manufacturer__c> fetchManufacturer(String strManuId) {
        if(strManuId != null) { 
            return [SELECT Id, Name, City__c, Contact_Person__c, Contact_Person__r.Name, Email__c, Phone__c, State__c, Street__c, Terms__c, Zip__c FROM BOATBUILDING__Manufacturer__c WHERE Id =: strManuId LIMIT 1];
        }
        else { 
            return null;
        }
    }

    // Returns the list of part according to passed parameter
    @RemoteAction
    public static List<BOATBUILDING__Part__c> getLstOfPart(String strPartNumber) {
        String str = '%'+strPartNumber+'%';
        System.debug('str value is::'+str);
        return [SELECT Vendor_Name__c, Retail_Price__c, Part_Number__c, Name, Id, Dealer_Price__c,Part_Cost__c,Weight__c FROM BOATBUILDING__Part__c WHERE Part_Number__c LIKE :str OR Name LIKE :str];
    } 

    // Returns the list of part according to passed parameter
    @RemoteAction
    public static List<BOATBUILDING__Part__c> getLstOfPart2(String strPartNumber) {
        return [SELECT Vendor_Name__c, Retail_Price__c, Part_Number__c, Name, Id, Dealer_Price__c,Part_Cost__c,Weight__c FROM BOATBUILDING__Part__c WHERE Part_Number__c =:strPartNumber ];
    } 

    //Returns the list of all the purchase orders
    public List<BOATBUILDING__Order__c> getlstOfPurchaseOrder(){
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Purchase_Order'
                                        AND
                                                SobjectType = 'BOATBUILDING__Order__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {                                      
            return [SELECT 
                            Id,
                            Name, 
                            Vendor_Name__c, 
                            Vendor_Name__r.Name, 
                            PO_Date__c, 
                            Amount_On_Order__c,
                    		CreatedBy.Name,
                    		createdDate,
                    		 RecordType.Name
                    FROM  
                            BOATBUILDING__Order__c 
                    WHERE 
                            RecordTypeId =: lstRecType[0].Id
                    limit   1000];
        }
        else {
            return null;
        }
    }

    // Generates a new purchase order with purchase order line item.
    @RemoteAction
    public static String createPurchaseOrder(Map<String, String> mapPartNum, String strManufacturer, String SL, String strFile, String fname) {
            Boolean isError = false;
            System.debug('Create PO');
            System.debug('Create strFile'+strFile);
            Map<String, String> mapPartNum2 = new Map<String, String>(); 
            for(String str: mapPartNum.keySet()) {
            	if(str.containsIgnoreCase('quot')) {
            		String newKey = str.replace('&quot;', '"');
            		mapPartNum2.put(newKey, mapPartNum.get(str));
            	} else {
            		mapPartNum2.put(str, mapPartNum.get(str)); 
            	}
            }
            mapPartNum = new Map<String, String>();
            mapPartNum.putAll(mapPartNum2);
            System.debug('Create PO'+mapPartNum);
            BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
            List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
            List<BOATBUILDING__Part__c> lstPart = [Select 
                                            Bin__c,
                                            Vendor_Name__c, 
                                            Retail_Price__c, 
                                            Part_Number__c, 
                                            Name, 
                                            Id,
                                            Dealer_Price__c,
                                            Part_Cost__c,
                                            Category1__c,
                                            Discount__c,
                                            Family1__c,
                                            Location__c,
                                            Map_Price__c,
                                            Minimum_Amount__c,
                                            Part_Color__c,
                                            Part_Size__c,
                                            Taxable__c,
                                            Weight__c
                                 From 
                                            BOATBUILDING__Part__c 
                                 WHERE 
                                            Part_Number__c 
                                 IN
                                            :mapPartNum.keySet()]; 

            List<RecordType> lstRecType = [SELECT           
                                                    Id
                                                FROM    
                                                        RecordType
                                                WHERE       
                                                        DeveloperName = 'Purchase_Order'
                                                AND
                                                        SobjectType = 'BOATBUILDING__Order__c'
                                                LIMIT 
                                                        1];
            if(lstRecType.size() > 0) {
                objOrder.RecordTypeId = lstRecType[0].id;
            }
            objOrder.PO_Date__c = Date.today();
            objOrder.Vendor_Name__c = strManufacturer;
            objOrder.Store_Location__c = SL;
            try {
                insert objOrder;
            }
            catch(Exception ex){
                isError = true;
                System.debug('Debug Log For Exception : '+ex);
            }
            
            Decimal amntOnOrder = 0.00;
            for(BOATBUILDING__Part__c objPrt : lstPart) {
                BOATBUILDING__Purchase_Order_Line_Item__c objPOLI = new BOATBUILDING__Purchase_Order_Line_Item__c();
                objPOLI.Name = objPrt.Name;
                objPOLI.Retail_Price__c = objPrt.Retail_Price__c;
                objPOLI.Dealer_Price__c = objPrt.Dealer_Price__c;
                objPOLI.Purchase_Order__c = objOrder.Id;
                objPOLI.Part_Number__c = objPrt.Part_Number__c;
                objPOLI.Vendor_Name__c = objPrt.Vendor_Name__c;
                objPOLI.Cost__c = objPrt.Part_Cost__c;
                objPOLI.Quantity__c = Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c));
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
                /*if(objPrt.Shipping_Charge__c != null) {
                    objPOLI.Shipping_Charge__c = objPrt.Shipping_Charge__c;                
                }*/
                if(objPrt.Weight__c != null && objPrt.Weight__c != ''){
                    objPOLI.Weight__c = objPrt.Weight__c; 
                }
                if(objPrt.Part_Cost__c != null){
                    amntOnOrder += Integer.valueOf(mapPartNum.get(objPrt.Part_Number__c)) * objPrt.Part_Cost__c;
                }
                lstPOLI.add(objPOLI);   
            }
            try {
                insert lstPOLI;
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+lstPOLI);
            }
            
            objOrder.Amount_On_Order__c = amntOnOrder;
            
            try {
                update objOrder;
                if(String.isNotBlank(strFile)) {
                	Attachment a = new Attachment (ParentId = objOrder.Id,
	                                       Body = EncodingUtil.base64Decode(strFile.subString(strFile.indexOfIgnoreCase('base64,') +7, strFile.length()-1)),
	                                       Name = fname);   
	            	insert a;
                }
                
            }
            catch(Exception ex) {
                isError = true;
                System.debug('Debug Log For Exception : '+ ex); 
            }
            if(!isError) {
                return 'SUCCESS';
            }
            else {
                return null;
            }
        return null;
    }
}