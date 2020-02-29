@isTest
public class JLITriggerTest {
    static testmethod void myUnitTest() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__JLITriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Part_Number__c = '123';
        objPart.Dealer_Price__c = 10.0;
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        insert objPart;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert Acc;
        
        Contact con = new Contact();
        con.FirstName = 'Test Con';
        con.LastName = 'Last Test Con';
        con.AccountId = acc.id;
        insert con;
        
        
        BOATBUILDING__Work_Order__c objCase = new BOATBUILDING__Work_Order__c();
        List<RecordType> lstRec = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Work_Order__c' AND Name = 'Warranty Work Order' LIMIT 1];
        if(lstRec.size() > 0) {
            objCase.RecordTypeId = lstRec[0].Id;
            objCase.BOATBUILDING__Contact__c = con.id;
        }
        insert objCase;
        
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objCase.Id;
        //objJob.Work_Requested__c = 'Oil Change';
        objJob.Job_Name__c = 'Internal';
        objJob.Work_Type__c = 'Internal';
        objJob.Type__c = 'Lake Call';
        insert objJob;
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> objlst =  new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
        BOATBUILDING__Work_Order_Job_Line_Item__c objJLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
        objJLI.Part_Name__c = 'ABC';
        objJLI.Part_Number__c = '123';
        objJLI.Price__c = 20.00;
        objJLI.Quantity__c = 10;
        objJLI.Related_to_Job__c = objJob.Id;
        objlst.add(objJLI);
        insert objJLI;
        objJLI.Part_Number__c = '1234';
        update objJLI;
        JLITriggerHandler.onBeforeDelete(objlst);
    }
    
}