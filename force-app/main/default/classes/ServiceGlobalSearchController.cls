public class ServiceGlobalSearchController {
    public List<BOATBUILDING__Manufacturer__c> manuList {get;set;}
    public List<BOATBUILDING__Part__c> partList{get;set;}
    public List<BOATBUILDING__Order__c> purOrderList{get;set;}
    public List<BOATBUILDING__Inventory__c> invenList{get;set;}
    public List<BOATBUILDING__Invoice__c> invoiceList{get;set;}
    public List<BOATBUILDING__Work_Order__c> workOrderList{get;set;}
    public String searchStr{get;set;}
    public Boolean displayPopup {get;set;}
    public Integer manuListsize {get;set;}
    public Integer partListsize {get;set;}
    public Integer purOrdertListsize {get;set;}
    public Integer invenListsize {get;set;}
    public Integer invoiceListsize {get;set;}
    public Integer workListsize {get;set;}
    public ServiceGlobalSearchController(){
        manuListsize = 0;
        partListsize = 0;
        purOrdertListsize= 0;
        invenListsize = 0;
        invoiceListsize = 0;
        workListsize = 0;
        
    }
    public void showPopup()
    {
        
        displayPopup = true;
        
        
    }
    public void closePopup() {
        displayPopup = false;
        
    }
    @RemoteAction
    public static List<List <sObject>> searchRecords(String searchKeyWrd){
        String searchStr1 = '*'+searchKeyWrd+'*';
        String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING BOATBUILDING__Part__c(Id, BOATBUILDING__Vendor_Name__c, BOATBUILDING__Vendor_Name__r.Name,Name,BOATBUILDING__Part_Number__c,BOATBUILDING__Map_Price__c,BOATBUILDING__Retail_Price__c,BOATBUILDING__Part_Cost__c),BOATBUILDING__Inventory__c(Name,BOATBUILDING__Part_Number__c,BOATBUILDING__Description__c,BOATBUILDING__Category__c, RecordType.DeveloperName, BOATBUILDING__Vendor__c, BOATBUILDING__Vendor__r.Name, BOATBUILDING__Part_MSRP_Price__c),BOATBUILDING__Invoice__c(Id, Name, Customer_Name__c, BOATBUILDING__Invoice_Number__c , RecordTypeId, RecordType.DeveloperName, Sum_Price_Line_Items__c), BOATBUILDING__Work_Order__c(Name, BOATBUILDING__Balance__c, RecordType.DeveloperName,  BOATBUILDING__Contact__c, BOATBUILDING__Contact__r.Name,BOATBUILDING__Status__c,BOATBUILDING__Case_Age__c, BOATBUILDING__Boat__c, BOATBUILDING__Boat__r.Name)';                                                               
        List<List <sObject>> lstResult = search.query(searchQuery);
        return lstResult;
        
    }
    
}