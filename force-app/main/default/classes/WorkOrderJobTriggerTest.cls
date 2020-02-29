@isTest
public class WorkOrderJobTriggerTest 
{
    static testMethod void UnitTest()
    {
        BOATBUILDING__TriggerSetting__c objSetting = new BOATBUILDING__TriggerSetting__c();
        objSetting.BOATBUILDING__WorkOrderJobTriggerCheckBox__c= true;
        insert objSetting;
        BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
        insert objCase;
        
        
    }
}