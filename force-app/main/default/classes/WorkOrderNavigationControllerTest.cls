@isTest
public class WorkOrderNavigationControllerTest {
    static testMethod void myUnitTest() {
        BOATBUILDING__System_Configure__c obj = new BOATBUILDING__System_Configure__c();
        obj.BOATBUILDING__Work_Order_PDF__c = 'CasePDFPageClone2skp';
       // insert obj;
        WorkOrderNavigationController.getPDFName();
    }

}