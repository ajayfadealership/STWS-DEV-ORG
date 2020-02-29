@isTest
private Class LeadTriggerHandlerTest{
    
    static testMethod void Test_LeadConvert(){
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__LeadTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        
        Lead testLead = new Lead();
        testLead.FirstName = 'Test First';
        testLead.LastName = 'Test Last';
        testLead.Company = 'Test Co';
        testLead.LeadSource = 'Facebook Lead Form';
        insert testLead;        
    }
}