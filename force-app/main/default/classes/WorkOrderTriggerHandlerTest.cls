@isTest
public class WorkOrderTriggerHandlerTest {
    static testMethod void myUnitTest() {
        Map<Id, Work_Order__c> MapWo = new Map<Id, Work_Order__c>(); 
        List<Work_Order__c> lstWo = new List<Work_Order__c>();
        Work_Order__c objWo = new Work_Order__c();
        objWo.BOATBUILDING__Status__c = 'Closed';
        
        lstWo.add(objWo);
        MapWo.put(objWo.Id, ObjWo);
        insert objWo;
        objWo.BOATBUILDING__Status__c = 'new';
        //update objWo;
        
        WorkOrderTriggerHandler.onBeforeInsert(lstWo);
        WorkOrderTriggerHandler.onAfterUpdate(lstWo,MapWo);
        //WorkOrderTriggerHandler.onBeforeUpdate(lstWo, new Map<Id, Work_Order__c>()); 
        // WorkOrderTriggerHandler.onAfterInsert(lstWo);
        WorkOrderTriggerHandler.updateAccountOnWorkOrder(lstWo);
        WorkOrderTriggerHandler.closedWOSalesNotification(lstWo);
        //WorkOrderTriggerHandler.createWONotification(lstWo);
    }
}