@isTest
public class ScheduleFromAccountControllerTest {
    testmethod static void Test1(){
        
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';
        //objAcc.Id=strCustId;
        
        insert objAcc;
        ApexPages.currentPage().getParameters().put('CustId',objAcc.Id);
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        Time_Management__c objTime = new Time_Management__c();
        ScheduleFromAccountController objtest= new ScheduleFromAccountController();
        
        Map<String, String> mapEventDetails = new Map<String, String>();
        mapEventDetails.put('EventType','test');
        ScheduleFromAccountController.saveEvent(mapEventDetails);
    }
     testmethod static void Test2(){
        
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';
        //objAcc.Id=strCustId;
        
        insert objAcc;
        ApexPages.currentPage().getParameters().put('CustId',objAcc.Id);
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        Time_Management__c objTime = new Time_Management__c();
        ScheduleFromAccountController objtest= new ScheduleFromAccountController();
        
        Map<String, String> mapEventDetails = new Map<String, String>();
        mapEventDetails.put('CustomerId','test');
        ScheduleFromAccountController.saveEvent(mapEventDetails);
    }
    testmethod static void Test3(){
        
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';
        //objAcc.Id=strCustId;
        
        insert objAcc;
        ApexPages.currentPage().getParameters().put('CustId',objAcc.Id);
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        Time_Management__c objTime = new Time_Management__c();
        ScheduleFromAccountController objtest= new ScheduleFromAccountController();
        
        Map<String, String> mapEventDetails = new Map<String, String>();
        mapEventDetails.put('Technician','test');
        ScheduleFromAccountController.saveEvent(mapEventDetails);
    }
     testmethod static void Test4(){
        
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';
        //objAcc.Id=strCustId;
        
        insert objAcc;
        ApexPages.currentPage().getParameters().put('CustId',objAcc.Id);
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        Time_Management__c objTime = new Time_Management__c();
        ScheduleFromAccountController objtest= new ScheduleFromAccountController();
        
        Map<String, String> mapEventDetails = new Map<String, String>();
        mapEventDetails.put('InventoryId','test');
        ScheduleFromAccountController.saveEvent(mapEventDetails);
    }
     testmethod static void Test5(){
        
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';
        //objAcc.Id=strCustId;
        
        insert objAcc;
        ApexPages.currentPage().getParameters().put('CustId',objAcc.Id);
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        Time_Management__c objTime = new Time_Management__c();
        ScheduleFromAccountController objtest= new ScheduleFromAccountController();
        
        Map<String, String> mapEventDetails = new Map<String, String>();
        mapEventDetails.put('QuoteId','test');
        ScheduleFromAccountController.saveEvent(mapEventDetails);
    }
    
}