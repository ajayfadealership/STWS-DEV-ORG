@istest
public class TechWorkOrderControllerCloneTest
{
    static testmethod void mytest()
    {
        TechWorkOrderControllerClone ObjT = new TechWorkOrderControllerClone();
        BOATBUILDING__Work_Order_Job__c objWork = new BOATBUILDING__Work_Order_Job__c();
        objWork.BOATBUILDING__Completed__c = true;
        objWork.BOATBUILDING__Worked_Hours__c = 1234;
        insert objWork;
        
        Case c = new Case();
        insert c;
        
   
        
        BOATBUILDING__Time_Management__c objManagement = new BOATBUILDING__Time_Management__c();
        Id RecordType = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Time Management for Jobs').getRecordTypeId();
        objManagement.RecordTypeId = RecordType;
        objManagement.BOATBUILDING__Status__c = 'testt';
        objManagement.BOATBUILDING__Service_writer_comment__c = 'testtt';
        objManagement.BOATBUILDING__Related_Work_Order_Job__c = objWork.Id;
        objManagement.BOATBUILDING__Clock_In__c = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        objManagement.BOATBUILDING__Clock_Out__c = datetime.newInstance(2014, 9, 15, 13, 30, 0);
        objManagement.BOATBUILDING__Related_to_Job__c = objWork.Id;
        objManagement.BOATBUILDING__Number_of_Hours_Worked__c = 3456;
        //insert objManagement; 
        
        BOATBUILDING__Work_Order__c ObjW= new BOATBUILDING__Work_Order__c();
        Id WorkId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        ObjW.RecordTypeId = WorkId;
        ObjW.BOATBUILDING__Hours__c = 'testing';
        insert ObjW;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c ();
        objItem.BOATBUILDING__Engine_SN__c = 'test';
        insert objItem;
        
        TechWorkOrderControllerClone.getDetailsOfWrkOrder(ObjW.Id);
        TechWorkOrderControllerClone.insertclockin(objWork.Id);
        //TechWorkOrderControllerClone.updateclockout(objWork.Id ,objManagement.Id);
        TechWorkOrderControllerClone.fetchOOWH(objWork.Id);
        TechWorkOrderControllerClone.getCommentList(objWork.Id);
        TechWorkOrderControllerClone.completeTheJob(objWork.Id, 'true');
        TechWorkOrderControllerClone.updateEngineSN(ObjW.ID,'test');
        TechWorkOrderControllerClone.updateHoursWO(ObjW.Id,'testing');
        //TechWorkOrderControllerClone.addCommentonJob(objManagement.Id,'testt' ,'testtt');
    }
}