@isTest
public class NewworkOrderControllerTest {
    
    @isTest static void newWorkOrderTest(){
        RecordType objRecType = new RecordType();
        objRecType.Name = 'Test';
        objRecType.DeveloperName = 'Testing';
        objRecType.SobjectType = 'BOATBUILDING__Work_Order__c';
        //insert objRecType;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Name = 'Test123';
        insert objItem;

        NewWorkOrderController.getRecordType(String.valueOf(objRecType.Id));
        NewWorkOrderController.getAccountRelatedItems(String.valueOf(objItem.Id));
        NewWorkOrderController.getPageLayoutFields();
    }

}