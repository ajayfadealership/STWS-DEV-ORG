public class JobLineItemController {    
   @AuraEnabled
   public static String searchPartsfromInventoryAndParts(String searchStr){
       List<PartSearchResult> lstPartSearchResult = new List<PartSearchResult>();
       String strName = searchStr;
       if(searchStr == 'recentlyViewed'){
            strName = '';
            List<RecentlyViewed> lstrv = [Select Id,Name from RecentlyViewed where Type = 'BOATBUILDING__Inventory__c' OR Type = 'BOATBUILDING__Part__c'];
            
            for(RecentlyViewed rv : lstrv){
                // String name = rv.Name.replaceAll('-', ' ');
                 strName = strName+'(\"' + String.escapeSingleQuotes(rv.Name) + '\")';
                 strName =  strName + ' OR ';


            }
          
            strName  = strName+'(\"' + 'test1234dummyString' + '\")';
       }
       System.debug(strName);
       

       String searchQuery = 'FIND \'' + strName + '\' IN ALL FIELDS RETURNING  BOATBUILDING__Inventory__c(Id,Name,BOATBUILDING__Vendor__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Part_Name__c,BOATBUILDING__Cost__c,BOATBUILDING__Description__c,BOATBUILDING__Category__c,BOATBUILDING__Map_Price__c,BOATBUILDING__Discount__c,BOATBUILDING__Family__c,BOATBUILDING__Size__c,BOATBUILDING__Color__c,BOATBUILDING__Quantity__c,BOATBUILDING__Minimum_Amount__c,BOATBUILDING__Part_Location__c,BOATBUILDING__Part_MSRP_Price__c,BOATBUILDING__Weight__c where RecordType.Name = \'Inventory for Parts\' AND BOATBUILDING__Part_MSRP_Price__c != null),BOATBUILDING__Part__c(Id,Name,BOATBUILDING__Part_Cost__c,BOATBUILDING__Quantity__c,BOATBUILDING__Retail_Price__c,BOATBUILDING__Part_Number__c,BOATBUILDING__Vendor_Name__r.Name,BOATBUILDING__Discount__c where BOATBUILDING__Retail_Price__c != null )';
       
       List<List <sObject>> searchList = search.query(searchQuery);
       System.debug('###'+searchList);
       Set<String> setPartNumber = new Set<String>();
       for(Object o : searchList[0]){
           BOATBUILDING__Inventory__c objInv = (BOATBUILDING__Inventory__c)o;
           if(!setPartNumber.contains(objInv.Part_Number__c)){
            PartSearchResult objPSR = new PartSearchResult(); 
            objPSR.partId = objInv.Id; 
            objPSR.partName =   objInv.BOATBUILDING__Part_Name__c;
            objPSR.partNumber = objInv.Part_Number__c;
            objPSR.isInventoryPart = true;
            objPSR.partCost = objInv.BOATBUILDING__Cost__c;
            objPSR.partMSRP = objInv.Part_MSRP_Price__c;
            if(objInv.BOATBUILDING__Quantity__c < 1){
                objPSR.isInventoryLow = true;
            }
            else{
                objPSR.isInventoryLow = false;
            }
            objPSR.quantity = objInv.BOATBUILDING__Quantity__c != null ? Integer.ValueOf(objInv.BOATBUILDING__Quantity__c) : 0;
            lstPartSearchResult.add(objPSR);
            setPartNumber.add(objInv.BOATBUILDING__Part_Name__c);
           }
            
           
           
       }
       for(Object o : searchList[1]){
           BOATBUILDING__Part__c objInv = (BOATBUILDING__Part__c)o;
            if(!setPartNumber.contains(objInv.BOATBUILDING__Part_Number__c)){

                PartSearchResult objPSR = new PartSearchResult();
                objPSR.partId = objInv.Id;
                objPSR.partName =   objInv.Name;
                objPSR.partNumber = objInv.BOATBUILDING__Part_Number__c;  
                objPSR.isInventoryPart = false;
                objPSR.partMSRP = objInv.BOATBUILDING__Retail_Price__c;
                objPSR.partCost = objInv.BOATBUILDING__Part_Cost__c;
                if(objInv.BOATBUILDING__Quantity__c < 1){
                    objPSR.isInventoryLow = true;
                } 
                else{
                    objPSR.isInventoryLow = false;
                }
                objPSR.quantity = objInv.BOATBUILDING__Quantity__c != null ? Integer.ValueOf(objInv.BOATBUILDING__Quantity__c) : 0;
                lstPartSearchResult.add(objPSR);
                setPartNumber.add(objInv.BOATBUILDING__Part_Number__c);
            }
       }

       return JSON.serialize(lstPartSearchResult);

       
   }
  
   
   @AuraEnabled
    public static void updateInvowithLineItems(String strPOId, String strLineItems) {


   }
   @AuraEnabled
   public static String saveJobWithLineItems(String jsonJobData){
       return null;
   }
   

   public class WorkOrderJob{
       public String workOrderId;
       public String Id;
       public String technicianId;
       public Boolean isApprovedByCustomer;
       public Boolean isJobTaxable;
       public Decimal discontOnJob;
       public Decimal ShippingCharges;
       public String Name;
       public String jobName;
       public String WorkType;
       public Integer numberOfLabor;
       public Decimal totalAmountOnJob;
       public Decimal taxOnJob;
       public Decimal shopSupplies;
       public Decimal jobTotalwTax;
       public String StoreLocation;
       public Decimal laborMuliplier;
       public Decimal PartsTotal;
       public String RecordTypeName;
       public List<PartSearchResult> lstJobLineItems;

   }
    public class PartSearchResult{
       @AuraEnabled
       public String Id{get; set;}
       @AuraEnabled
       public String partId{get; set;}
       @AuraEnabled
       public String partName{get; set;}
       @AuraEnabled
       public String partNumber{get; set;}
       @AuraEnabled
       public Boolean isInventoryPart{get; set;}
       @AuraEnabled
       public Decimal partMSRP{get; set;}
       @AuraEnabled
       public Boolean isInventoryLow{get; set;}
       @AuraEnabled
       public Integer quantity{get; set;}
       @AuraEnabled
       public Decimal partCost{get; set;}
       
   }
}