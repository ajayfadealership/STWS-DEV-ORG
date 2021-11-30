@isTest(SeeAllData=true)
public class PartRequestLightningCompControllerTest {
	 public static testmethod void myTestMethod() {
         ID recId = PartRequestLightningCompController.getRecTypeId();
         List<User> userList = [Select Id, Name From User Where Name =: 'Ajay Sharma'];

         BOATBUILDING__Manufacturer__c objVendor = new BOATBUILDING__Manufacturer__c();
         objVendor.BOATBUILDING__Manufacturer_name__c = 'test 1';
         insert objVendor;
         BOATBUILDING__Order__c objOrder = new BOATBUILDING__Order__c();
         objOrder.BOATBUILDING__Vendor_Name__c = objVendor.Id;
         objOrder.BOATBUILDING__Assigned_to__c = userList[0].Id ;
         insert objOrder;
         PartRequestLightningCompController.doChatterPost(userList[0].Id,'type', objOrder.Id);
         String strCpofPartReq = PartRequestLightningCompController.cpofPartReq(objOrder.Id);
    }
    
}