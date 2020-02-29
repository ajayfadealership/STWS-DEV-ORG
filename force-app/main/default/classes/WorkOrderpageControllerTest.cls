@isTest
public class WorkOrderpageControllerTest {
    static testMethod void myUnitTest(){
        BOATBUILDING__Work_Order__c objWo= new BOATBUILDING__Work_Order__c();
        insert objWo;    
        ApexPages.StandardController sc = new ApexPages.StandardController(objWo);
        WorkOrderpageController objCont = new WorkOrderpageController(sc);
        objCont.sendworkordertoqb();
        
        
        
        
        
    }
    
    
    
}