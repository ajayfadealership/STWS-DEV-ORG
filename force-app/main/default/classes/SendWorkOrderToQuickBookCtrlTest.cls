@isTest
public class SendWorkOrderToQuickBookCtrlTest {
    testmethod static void TestController(){
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        insert objJob;
        BOATBUILDING__QBProductServiceConfig__c objServ = new BOATBUILDING__QBProductServiceConfig__c();
        objServ.Name = 'test';
        insert objServ;
        
        SendWorkOrderToQuickBookCtrl objWork = new SendWorkOrderToQuickBookCtrl();
       //objWork.generateWOJson(objJob,objServ.Id);
        
        
    }

}