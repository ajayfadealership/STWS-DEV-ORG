@isTest
public class SendWODetailPageControllerTest {
    
    static testmethod void myUnitTest1() {
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
        Case objCase = new Case();
        List<RecordType> lstRec = [Select Id From RecordType Where SobjectType = 'Case' AND Name = 'Warranty Work Order' LIMIT 1];
        if(lstRec.size() > 0) {
            objCase.RecordTypeId = lstRec[0].Id;
        }
        objCase.ContactID = objContact.Id;
        insert objCase;
        
        BOATBUILDING__Work_Order__c objCaseWO1 = new BOATBUILDING__Work_Order__c();
        //objCaseWO1.RecordTypeId = recordTypeforCase;
        objCaseWO1.BOATBUILDING__Contact__c = objContact.Id;
        //objCaseWO1.Boat__c = objItem.Id;
        objCaseWO1.Drive__c = 'Test Drive';
        objCaseWO1.Hours__c = '500';
        objCaseWO1.Status__c = 'New';
        objCaseWO1.Priority__c = 'High';
        objCaseWO1.Sales_Tax_Percent__c = 0.0725;
        insert objCaseWO1;
    
        BOATBUILDING__Job__c objJobforCaseWO = new BOATBUILDING__Job__c();
        List<RecordType> lstRec2 = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Job__c' AND Name = 'Custom Jobs' LIMIT 1];
        if(lstRec2.size() > 0) {
            objJobforCaseWO.RecordTypeId = lstRec2[0].Id;
        }
        objJobforCaseWO.Work_Type__c = 'Internal';
        objJobforCaseWO.Job_Name__c = 'Internal';
        objJobforCaseWO.Work_Request__c = objCase.Id;
        objJobforCaseWO.BOATBUILDING__Work_Order_Warranty_Work_Order__c  = objCaseWO1.Id;
        //objJobforCaseWO.Work_Requested__c = 'Oil Change';
        objJobforCaseWO.Type__c = 'Lake Call';
        objJobforCaseWO.No_of_Labors__c = 2;
        objJobforCaseWO.Price_per_Labor__c = 1100;
        objJobforCaseWO.Shop_Supplies_Total__c = 22000;
        objJobforCaseWO.Customer_Pay__c = 12000;
        objJobforCaseWO.Total_Hours_Job__c = 50;
        insert objJobforCaseWO;
        
        BOATBUILDING__Job_Line_Item__c objJLI = new BOATBUILDING__Job_Line_Item__c();
        objJLI.Part_Name__c = 'ABC';
        objJLI.Part_Number__c = '123';
        objJLI.Price__c = 20.00;
        objJLI.Quantity__c = 10;
        objJLI.Related_to_Job__c = objJobforCaseWO.Id;
        insert objJLI;
        
        ApexPages.currentPage().getParameters().put('Id',objCaseWO1.id);
        SendWODetailPageController objSendWODetailPageController = new SendWODetailPageController();
        objSendWODetailPageController.sendWO();
        objSendWODetailPageController.checkAccess();
    }
    
}