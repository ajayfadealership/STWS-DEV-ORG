@isTest
public class WorkOrderTriggerHandlerTest {
    static testMethod void myUnitTest() {
        map<Id,Work_Order__c> MapWo = new map<Id,Work_Order__c>(); 
        list<Work_Order__c> lstWo = new list<Work_Order__c>();
        Work_Order__c objWo = new Work_Order__c();
        objWo.BOATBUILDING__Status__c = 'Closed';
        
        lstWo.add(objWo);
        MapWo.put(objWo.Id,ObjWo);
        insert objWo ;
        objWo.BOATBUILDING__Status__c = 'new';
        update objWo ;
        
       WorkOrderTriggerHandler.onBeforeInsert(lstWo);
        WorkOrderTriggerHandler.onAfterUpdate(lstWo,MapWo);
        WorkOrderTriggerHandler.onBeforeUpdate(lstWo);
       // WorkOrderTriggerHandler.onAfterInsert(lstWo);
        WorkOrderTriggerHandler.updateAccountOnWorkOrder(lstWo);
        WorkOrderTriggerHandler.closedWOSalesNotification(lstWo);
        //WorkOrderTriggerHandler.createWONotification(lstWo);
       
        
        
        
       
        
        
        
        
        
        
        
    }
    
}