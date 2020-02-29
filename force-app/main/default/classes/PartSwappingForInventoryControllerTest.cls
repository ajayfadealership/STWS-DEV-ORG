@isTest
public class PartSwappingForInventoryControllerTest {
    testmethod static void TestController(){

        BOATBUILDING__Inventory__c ObjInv= new BOATBUILDING__Inventory__c();
        ApexPages.currentPage().getParameters().put('Id',ObjInv.id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ObjInv);
        ObjInv.BOATBUILDING__Part_Name__c='objPA.Inventory__r.Part_Name__c';
        ObjInv.BOATBUILDING__Quantity__c=1223;
        //ObjInv.Store_Location__c ='other';
        insert ObjInv;
        
        ApexPages.currentPage().getParameters().put('Id', ObjInv.Id);
        
        BOATBUILDING__Parts_Availability__c ObjA= new BOATBUILDING__Parts_Availability__c();
        OBjA.BOATBUILDING__Quantity__c = 123; 
        ObjA.BOATBUILDING__Inventory__c = ObjInv.Id;
        insert ObjA;
        
        PartSwappingForInventoryController ObjS= new PartSwappingForInventoryController();
        ObjS.saveSwapping();
        ObjS.getPAList();
        
        
    }
    
}