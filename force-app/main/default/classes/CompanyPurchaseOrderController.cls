public with sharing class CompanyPurchaseOrderController {
    
    public BOATBUILDING__Order__c objOrder { get; set; }

    //Constructor
    public CompanyPurchaseOrderController() {
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
	
    @RemoteAction
    public static String saveVendDetails(String vendName, String vendId) {
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        try {
        	objManufacturer.Name = vendName;
            if(vendId != null) {
                objManufacturer.Manufacturer_name__c  = vendName;
            }
            insert objManufacturer;
        } catch(Exception ex) {
            return null;
        }
        return objManufacturer.Id;
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
                                                DeveloperName = 'Company_Purchase_Requests'
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
                            Amount_On_Order__c
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
    public static String createPurchaseOrder( String strManufacturer, String SL) {
            Boolean isError = false;
            BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
            List<BOATBUILDING__Purchase_Order_Line_Item__c> lstPOLI = new List<BOATBUILDING__Purchase_Order_Line_Item__c>();
            

            List<RecordType> lstRecType = [SELECT           
                                                    Id
                                                FROM    
                                                        RecordType
                                                WHERE       
                                                        DeveloperName = 'Company_Purchase_Requests'
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
            if(!isError) {
                return 'SUCCESS';
            }
            else {
                return null;
            }
        //return null;
    }
}