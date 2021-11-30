@isTest
public class TechWorkOrderDetailControllerTest {
    private static testmethod void MyTest(){
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        insert objWO;
        
        
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
        insert objWOJ;
        
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.Lunch_In__c = DateTime.now();
        objTm.Lunch_Out__c = DateTime.now();
        objTm.Clock_In__c = DateTime.now();
        objTm.BOATBUILDING__Related_Work_Order_Job__c = objWOJ.Id;
        insert objTm;
        TechWorkOrderDetailController objTWOD = new TechWorkOrderDetailController();
        TechWorkOrderDetailController.getWorkOrderDetail(objWO.Id);
        TechWorkOrderDetailController.updateclockout(objWOJ.Id,objTm.Id);
        TechWorkOrderDetailController.getTMHistory(objWOJ.Id);
        TechWorkOrderDetailController.completeToggle(objWOJ.Id,true);
        TechWorkOrderDetailController.insertclockin(objWOJ.Id);
    }
    private static testmethod void MyTest1(){
         TechWorkOrderDetailController.completeToggle(null,true);
         TechWorkOrderDetailController.updateclockout(null,null);
    }

}