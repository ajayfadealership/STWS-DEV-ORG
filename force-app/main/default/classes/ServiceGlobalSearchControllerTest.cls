@isTest
public class ServiceGlobalSearchControllerTest {
    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objmanu =  new BOATBUILDING__Manufacturer__c ();
        BOATBUILDING__Part__c objpart = new BOATBUILDING__Part__c();
        BOATBUILDING__Order__c objorder = new BOATBUILDING__Order__c();
        BOATBUILDING__Inventory__c objInven = new BOATBUILDING__Inventory__c();
        BOATBUILDING__Invoice__c objInv = new BOATBUILDING__Invoice__c();
        BOATBUILDING__Work_Order__c objWo = new BOATBUILDING__Work_Order__c();
        ServiceGlobalSearchController objSearch = new ServiceGlobalSearchController();
        objSearch.searchStr = 'abc';                                                                             
       // objSearch.searchbox();
        objSearch.searchStr = ''; 
        //objSearch.searchbox();
        
                            
    }      
      
    
}