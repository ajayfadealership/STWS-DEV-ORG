@isTest
public with sharing class SendQuoteDetailPageControllerTest 
{
   public static testmethod void MyUnitTest1()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.Name = 'Test';
        objQuote.Account_Name__c = objAccount.Id;
        objQuote.Contact_Name__c = objContact.Id;
        objQuote.Additional_To__c = 'test';
        objQuote.Additional_To_Name__c = 'test';
        objQuote.Bill_To_Name__c = 'test';
        objQuote.Description__c = 'test';
        objQuote.Discount__c = 20.0;
        objQuote.Fax__c = '21354456';
        objQuote.Email__c  = 'test@360dc.in';
        objQuote.State__c = 'North Carolina';
        objQuote.Phone__c = '123456789';
        objQuote.Quote_Sale_Price__c = 0.00;
        objQuote.Total_Price_Quote__c = 50000.00;
        objQuote.Quote_MSRP_Boat_Price__c = 4000.00;
        objQuote.Quote_MSRP_Trailer_Price__c = 5200.00;
        objQuote.Quote_Cost__c = 6500.00;
        objQuote.Quote_Term__c = '5 Years';
        objQuote.Bill_To__c = 'abc';
        objQuote.Grand_Total__c = 5000.00;
        objQuote.Quote_To_Address__c = 'test';
        objQuote.Quote_To_Name__c = 'test';
        objQuote.Shipping_And_Handling__c = 200.00; 
        objQuote.Ship_To__c = 'test';
        objQuote.Status__c = 'Draft';
        //objQuote.Related_to_Order__c = objOrder.Id;
        objQuote.Tax__c = 30.00;
        objQuote.Syncing__c = true;
        objQuote.Quote_Sale_Price__c = 5000.00;
        objQuote.Ship_To_Name__c = 'test';
        objQuote.Quote_Rate__c = 20.00;
        objQuote.Quote_Trade_Allowance__c = 2.22;
        objQuote.Quote_Trailer_Allowance__c = 40.22;
        objQuote.Discount_On_Quote__c = 20.22;
        objQuote.Quote_Trailer_ACV__c = 222.00;
        objQuote.Quote_Trailer_Sales_Tax__c = 235.00;
        objQuote.Quote_Boat_Reg_Fee__c = 215.235;
        objQuote.Quote_Trailer_Reg_Fee__c = 13243.12;
        objQuote.Quote_Doc_Fee__c = 909.9;
        objQuote.Negotiation_Trade_Payoff__c = 165.2;
        objQuote.Quote_Down_Payment__c = 980.87;
        objQuote.Quote_Cost__c = 12.21;
        objQuote.Quote_Deal_Margin__c = 987.87;
        insert objQuote;
          
          Attachment attach=new Attachment(); 
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=objQuote.Id; 
        attach.ContentType = 'application/pdf'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach; 
          
          ApexPages.currentPage().getParameters().put('Id',objQuote.id);
         
        //ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        SendQuoteDetailPageController ObjController = new SendQuoteDetailPageController(); 
        
        
        
            Pagereference pf = ObjController.sendQuote();
          
    }
    
    public static testmethod void MyUnitTest2()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.Name = 'Test';
        objQuote.Account_Name__c = objAccount.Id;
        objQuote.Contact_Name__c = objContact.Id;
        objQuote.Additional_To__c = 'test';
        objQuote.Additional_To_Name__c = 'test';
        objQuote.Bill_To_Name__c = 'test';
        objQuote.Description__c = 'test';
        objQuote.Discount__c = 20.0;
        objQuote.Fax__c = '21354456';
        objQuote.Email__c  = '';
        objQuote.State__c = 'North Carolina';
        objQuote.Phone__c = '123456789';
        objQuote.Quote_Sale_Price__c = 0.00;
        objQuote.Total_Price_Quote__c = 50000.00;
        objQuote.Quote_MSRP_Boat_Price__c = 4000.00;
        objQuote.Quote_MSRP_Trailer_Price__c = 5200.00;
        objQuote.Quote_Cost__c = 6500.00;
        objQuote.Quote_Term__c = '5 Years';
        objQuote.Bill_To__c = 'abc';
        objQuote.Grand_Total__c = 5000.00;
        objQuote.Quote_To_Address__c = 'test';
        objQuote.Quote_To_Name__c = 'test';
        objQuote.Shipping_And_Handling__c = 200.00; 
        objQuote.Ship_To__c = 'test';
        objQuote.Status__c = 'Draft';
        //objQuote.Related_to_Order__c = objOrder.Id;
        objQuote.Tax__c = 30.00;
        objQuote.Syncing__c = true;
        objQuote.Quote_Sale_Price__c = 5000.00;
        objQuote.Ship_To_Name__c = 'test';
        objQuote.Quote_Rate__c = 20.00;
        objQuote.Quote_Trade_Allowance__c = 2.22;
        objQuote.Quote_Trailer_Allowance__c = 40.22;
        objQuote.Discount_On_Quote__c = 20.22;
        objQuote.Quote_Trailer_ACV__c = 222.00;
        objQuote.Quote_Trailer_Sales_Tax__c = 235.00;
        objQuote.Quote_Boat_Reg_Fee__c = 215.235;
        objQuote.Quote_Trailer_Reg_Fee__c = 13243.12;
        objQuote.Quote_Doc_Fee__c = 909.9;
        objQuote.Negotiation_Trade_Payoff__c = 165.2;
        objQuote.Quote_Down_Payment__c = 980.87;
        objQuote.Quote_Cost__c = 12.21;
        objQuote.Quote_Deal_Margin__c = 987.87;
        insert objQuote;
                          
          ApexPages.currentPage().getParameters().put('Id',objQuote.id);
         
        //ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        SendQuoteDetailPageController ObjController2 = new SendQuoteDetailPageController(); 
        
        
        
            Pagereference pf = ObjController2.sendQuote();
          
    }
}