@isTest
private class CreateDealerQuoteControllerTest {
    
    static testMethod void myUnitTest() {
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__QuoteTriggerCheckBox__c= true;
        insert ObjTriggerSetting;
        
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManufacturer1.Model_Variant__c = false;
        insert objManuFacturer1;
        
        BOATBUILDING__Product__c objProduct = new BOATBUILDING__Product__c();
        objProduct.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct.M_Year__c = '2016';  
        objProduct.MModel2__c = 'Hexa'; 
        insert objProduct;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
        
        BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory1Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory = lstInventory1Id.size() > 0 ? lstInventory1Id[0].Id : null;
        if(lstInventory1Id.size() > 0){
            objInventory1.RecordTypeId = lstInventory1Id[0].Id;
        }
        objInventory1.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory1.Year__c = '2016';
        objInventory1.Model__c = 'Mondo(MD)';
        objInventory1.Part_Number__c = '99999';
        objInventory1.Cost__c =10000;
        insert objInventory1;
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.Name = 'Test';
        objQuote.Account_Name__c = objAccount.Id;
        objQuote.Contact_Name__c = objContact.Id;
        objQuote.Mapped_HIN__c = 'AA1234';
        objQuote.Test_2__c = objInventory1.Id;
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
        objQuote.Transmission_Gearbox_SN__c = 'test';
        objQuote.Mapped_Trailer_VIN__c = 'Draft';
        objQuote.Related_to_Product__c = objProduct.Id;
        objQuote.Tax__c = 30.00;
        objQuote.Syncing__c = true;
        objQuote.Quote_Sale_Price__c = 5000.00;
        objQuote.Mapped_Engine_SN__c = 'test';
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
        objQuote.BOATBUILDING__Status__c = 'final';
        objQuote.BOATBUILDING__BOat_Sold_by__c = userinfo.getName();
        insert objQuote;
        BOATBUILDING__Quote_Line_Item__c objQLI1 = new BOATBUILDING__Quote_Line_Item__c();
        objQLI1.Name = 'QLI';
        objQLI1.Name__c = 'Test';
        objQLI1.Quote__c = objQuote.Id;
        objQLI1.Option_Category__c = 'Dealer Options';
        objQLI1.Product_Code__c = 'Test';
        objQLI1.Dealer_Price__c = 20;
        objQLI1.Total_Price__c = 30;
        insert objQLI1;
        CreateDealerQuoteController.generateDealerQuoteApex(objQuote.Id); 
        CreateDealerQuoteController.generateDealerQuoteApex(objQuote.Id); 
    }
}