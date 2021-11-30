@isTest
public class WorkOrderPaymentTriggerTest 
{
    static testMethod void UnitTest()
    {     
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__WorkOrderPaymentTriggerCheckBox__c= true;
        insert ObjTriggerSetting;

        Account acc = new Account();
        acc.Name = 'Test Account';
        insert Acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test Con';
        con.LastName = 'Last Test Con';
        con.AccountId = acc.id;
        insert con;
        
        BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
        List<RecordType> lstRec = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Work_Order__c' AND DeveloperName = 'Work_Order' LIMIT 1];
        if(lstRec.size() > 0) {
            objCase.RecordTypeId = lstRec[0].Id;
            objCase.BOATBUILDING__Contact__c = con.id;
        }
        insert objCase;
        
        BOATBUILDING__Payments__c objPayment = new BOATBUILDING__Payments__c();
        objPayment.BOATBUILDING__Amount__c = 123;
        objPayment.BOATBUILDING__Work_Warranty_Order__c = objCase.Id;
        objPayment.BOATBUILDING__Payment_Type__c = 'Check';
        insert objPayment;
        
        BOATBUILDING__Payments__c objPayment1 = new BOATBUILDING__Payments__c();
        objPayment1.BOATBUILDING__Amount__c = 123;
        objPayment1.BOATBUILDING__Work_Warranty_Order__c = objCase.Id;
        objPayment1.BOATBUILDING__Payment_Type__c = 'Check';
        insert objPayment1;
        
        delete objPayment1;
       
    }
}