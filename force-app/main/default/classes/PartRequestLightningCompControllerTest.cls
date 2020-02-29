@isTest
public class PartRequestLightningCompControllerTest {
	 public static testmethod void myTestMethod() {
         ID recId = PartRequestLightningCompController.getRecTypeId();
         
         BOATBUILDING__Manufacturer__c objVendor = new BOATBUILDING__Manufacturer__c();
         objVendor.BOATBUILDING__Manufacturer_name__c = 'test';
        
         insert objVendor;
         BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
         objOrder.BOATBUILDING__Vendor_Name__c = objVendor.Id;
        //  objOrder.BOATBUILDING__Assigned_to__c =  ;
         
         insert objOrder;
         String strCpofPartReq = PartRequestLightningCompController.cpofPartReq(objOrder.Id);
    }
    
}