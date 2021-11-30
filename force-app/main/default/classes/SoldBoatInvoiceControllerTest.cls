@istest
public with sharing class SoldBoatInvoiceControllerTest{
    Public static  testMethod void myUnitTest1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardusadsfadsfaer@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardusasfsdfadfsaer@testorg.com');
        u.UserRoleId = [SELECT ID FROM USERROLE WHERE NAME = 'GM' LIMIT 1].Id;
        insert u;
        System.runAs(u) {
            Account objAccount1 = new Account();
            objAccount1.Name = 'Test Account';
            objAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            insert objAccount1;
            
            Contact objContact1 = new Contact();
            objContact1.FirstName = 'Test';
            objContact1.LastName = 'Contact';
            objContact1.AccountId = objAccount1.Id;
            insert objContact1;
            
            BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
            List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
            String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
            if(lstInventory1Id.size() > 0){
                objInventory1.RecordTypeId = lstInventory1Id[0].Id;
            }
            //objInventory1.RecordTypeId = recIdInventory;
            objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
            objInventory1.Year__c = '2016';
            objInventory1.Model__c = 'Mondo(MD)';
            objInventory1.Part_Number__c = '99999';
            objInventory1.Cost__c =10000;
            objInventory1.Quantity__c = 2;
            insert objInventory1;
            
            BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
            objQuote1.Name = 'Test';
            objQuote1.Test_2__c = objInventory1.Id;
            objQuote1.Account_Name__c = objAccount1.Id;
            objQuote1.Contact_Name__c = objContact1.Id;
            objQuote1.Additional_To__c = 'test';
            objQuote1.Additional_To_Name__c = 'test';
            objQuote1.Bill_To_Name__c = 'test';
            objQuote1.Description__c = 'test';
            objQuote1.Discount__c = 20.0;
            objQuote1.Fax__c = '21354456';
            objQuote1.Email__c  = 'test@360dc.in';
            objQuote1.State__c = 'North Carolina';
            objQuote1.Phone__c = '123456789';
            objQuote1.Quote_Sale_Price__c = 0.00;
            objQuote1.Total_Price_Quote__c = 50000.00;
            objQuote1.Quote_MSRP_Boat_Price__c = 4000.00;
            objQuote1.Quote_MSRP_Trailer_Price__c = 5200.00;
            objQuote1.Quote_Cost__c = 6500.00;
            objQuote1.Quote_Term__c = '5 Years';
            objQuote1.Bill_To__c = 'abc';
            objQuote1.Grand_Total__c = 5000.00;
            objQuote1.Quote_To_Address__c = 'test';
            objQuote1.Quote_To_Name__c = 'test';
            objQuote1.Shipping_And_Handling__c = 200.00; 
            objQuote1.Ship_To__c = 'test';
            objQuote1.Status__c = 'Final';
            //objQuote1.Related_to_Order__c = objOrder1.Id;
            objQuote1.Tax__c = 30.00;
            objQuote1.Syncing__c = true;
            objQuote1.Quote_Sale_Price__c = 5000.00;
            objQuote1.Ship_To_Name__c = 'test';
            objQuote1.Quote_Rate__c = 20.00;
            objQuote1.Quote_Trade_Allowance__c = 2.22;
            objQuote1.Quote_Trailer_Allowance__c = 40.22;
            objQuote1.Discount_On_Quote__c = 20.22;
            objQuote1.Quote_Trailer_ACV__c = 222.00;
            objQuote1.Quote_Trailer_Sales_Tax__c = 235.00;
            objQuote1.Quote_Boat_Reg_Fee__c = 215.235;
            objQuote1.Quote_Trailer_Reg_Fee__c = 13243.12;
            objQuote1.Quote_Doc_Fee__c = 909.9;
            objQuote1.Negotiation_Trade_Payoff__c = 165.2;
            objQuote1.Quote_Down_Payment__c = 980.87;
            objQuote1.Quote_Cost__c = 12.21;
            objQuote1.Quote_Deal_Margin__c = 987.87;
            objQuote1.BOATBUILDING__Boat_Sold_By__c = UserInfo.getName();
            //objQuote1.BOATBUILDING__Payment__r =0 ;
            insert objQuote1;
            BOATBUILDING__Payments__c objpay1 = new BOATBUILDING__Payments__c();
          
            objpay1.Amount__c= 120.12;
           // objpay1.Check_Number__c= 'test';
            objpay1.Credit_Card_Type__c= 'test';
            objpay1.Payment_Type__c = 'test';
            objpay1.BOATBUILDING__Store_Location__c  = 'Other';
            objpay1.BOATBUILDING__Quote__c= objQuote1.id;
            
            insert objpay1;                       
            
            List<BOATBUILDING__Quote__c> listQuote = new List<BOATBUILDING__Quote__c>();
            listQuote.add(objQuote1);
            apexpages.currentpage().getparameters().put('Id',objQuote1.Id);
            
            SoldBoatInvoiceController objSoldBoatInvoiceController = new SoldBoatInvoiceController(new ApexPages.StandardController(objQuote1));
            // objSoldBoatInvoiceController.checkAccess();
            
            objSoldBoatInvoiceController.lstQuote.addAll(listQuote);
            objSoldBoatInvoiceController.directTo();
            
        }
    }   
}