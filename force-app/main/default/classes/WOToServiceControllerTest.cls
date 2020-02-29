@isTest
public class WOToServiceControllerTest {
    static testMethod void myUnitTest(){
        WOToServiceController objCont = new WOToServiceController();
        BOATBUILDING__Work_Order__c ObjW = new BOATBUILDING__Work_Order__c();
        insert ObjW;
        ApexPages.currentPage().getParameters().put('Id',ObjW.Id);
        Id woId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
        ObjW.RecordTypeId= woId;
        Id woId1 = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        ObjW.RecordTypeId= woId1;
        update ObjW;
        objCont.redirectTo();
        
        
    }
    
    
    
}