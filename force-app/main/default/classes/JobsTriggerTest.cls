@isTest
public class JobsTriggerTest 
{
     static testMethod void UnitTest()
    {
        Case objCase1 = new Case();
        List<RecordType> lstRec1 = [Select Id From RecordType Where SobjectType = 'Case' AND DeveloperName = 'Work_Order' LIMIT 1];
        if(lstRec1.size() > 0) {
            objCase1.RecordTypeId = lstRec1[0].Id;
        }
        insert objCase1;
        
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
        
        BOATBUILDING__Job__c objJOb=new BOATBUILDING__Job__c();
            objJOb.BOATBUILDING__Job_Name__c='Testjob1';
            objJOb.BOATBUILDING__Work_Request__c=objCase1.id;
            objJOb.BOATBUILDING__Work_Order_Warranty_Work_Order__c=objCase.id;
            objJOb.BOATBUILDING__No_of_Labors__c=123;
            objJOb.BOATBUILDING__Price_per_Labor__c=88;
          insert objJOb;
        
        BOATBUILDING__Job__c objJOb1=new BOATBUILDING__Job__c();
            objJOb1.BOATBUILDING__Job_Name__c='Testjob1';
            objJOb1.BOATBUILDING__Work_Request__c=objCase1.id;
            objJOb1.BOATBUILDING__Work_Order_Warranty_Work_Order__c=objCase.id;
            objJOb1.BOATBUILDING__No_of_Labors__c=123;
            objJOb1.BOATBUILDING__Price_per_Labor__c=88;
            insert objJOb1;
        
          delete objJOb1;
    }
}