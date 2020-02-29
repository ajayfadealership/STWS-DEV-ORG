@isTest
public class WorkOrderPaymentHandlerTest {
    static testMethod void unitTest(){
        Map<Id,BOATBUILDING__Work_Order_Payment__c> mapWOP = new Map<Id,BOATBUILDING__Work_Order_Payment__c>();
        list<BOATBUILDING__Work_Order_Payment__c> lstWOP = new list<BOATBUILDING__Work_Order_Payment__c>();
        BOATBUILDING__Work_Order_Payment__c objWop = new BOATBUILDING__Work_Order_Payment__c();
        lstWOP.add(objWop);
        mapWOP.put(objWop.Id,objWop);
        insert objWop;
        WorkOrderPaymentHandler.onAfterUpdate(lstWOP,mapWOP);
        WorkOrderPaymentHandler.createQBServicePayment(lstWOP,mapWOP);
        WorkOrderPaymentHandler.generateServicePaymentJson(objWop,'adcd1233');
        
    }

}