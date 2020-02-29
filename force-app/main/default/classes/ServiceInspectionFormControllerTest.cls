@isTest
public class ServiceInspectionFormControllerTest {
    testmethod static void TestController(){
        Map<String, String> mapDF= new Map<String, String>();
        mapDF.put('key', 'value');
        
        Work_Order__c ObjW= new Work_Order__c();
        insert ObjW;
         ApexPages.currentPage().getParameters().put('woId',ObjW.Id);
       BOATBUILDING__Dealership_Form__c objDealer = new BOATBUILDING__Dealership_Form__c();
        insert objDealer;
        
        ServiceInspectionFormController ObjS = new  ServiceInspectionFormController();
        ObjS.getOptions();
        ObjS.getWay();
        ServiceInspectionFormController.saveFormRecord(mapDF);
        ServiceInspectionFormController.getformRecord(objDealer.Id);
      
        
        
        
    }
    
}