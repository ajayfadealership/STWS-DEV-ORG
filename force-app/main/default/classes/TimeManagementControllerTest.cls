@isTest
public class TimeManagementControllerTest {
    public static testmethod void myTestMethod(){
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.Lunch_In__c = DateTime.now();
        objTm.Lunch_Out__c = DateTime.now();
        insert objTm;
        TimeManagementController.getTimeManagement();
        TimeManagementController.updateDayIn(objTm);
        TimeManagementController.updateLunchOut(objTm);
        TimeManagementController.updateDayOut(objTm);
        TimeManagementController.updateLunchIn(objTm);        
    }
    public static testmethod void myTestMethod1(){
        Test.startTest();
          TimeManagementController.getTimeManagement();
         Test.stopTest();
                     
    }
    public static testmethod void myTestMethod2(){
        BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
        objTm.Lunch_Out__c = DateTime.now();
        insert objTm;
        TimeManagementController.finalCallOut(objTm.Id);

    }
}