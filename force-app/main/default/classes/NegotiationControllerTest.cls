@isTest
private class NegotiationControllerTest {
    
    static testMethod void myUnitTest() {
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
        
        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
        objQLI.Name = 'Test QLI';
        objQLI.Date__c = Date.today();
        objQLI.Dealer_Price__c = 2000.0;
        objQLI.Sales_Price__c = 2000.0;
        objQLI.Total_Price__c = 2000.0;
        objQLI.Product_Code__c = '3002256';
        objQLI.Product__c = objProduct.Id;
        objQLI.Quote__c = objQuote.Id;
        objQLI.Option_Category__c = 'Sample Test Option';
        insert objQLI;
        
        apexpages.currentpage().getparameters().put('id' , objQuote.Id);
        NegotiationController objNegotiationController = new NegotiationController();
        objNegotiationController.cancel();
        objNegotiationController.clear();
        Map<String, String> quoteMap = new Map<String, String>();
        
        quoteMap.put('tempName', objQuote.Name);
        quoteMap.put('accountName', objQuote.Account_Name__c);
        quoteMap.put('additionalTo', objQuote.Additional_To__c);
        quoteMap.put('additionalToName', objQuote.Additional_To_Name__c);
        quoteMap.put('billTo', objQuote.Bill_To__c);
        quoteMap.put('billToName', objQuote.Bill_To_Name__c);
        quoteMap.put('contactName', objQuote.Contact_Name__c);
        quoteMap.put('descriptionTemp', objQuote.Description__c);
        quoteMap.put('discountTemp', String.valueOf(objQuote.Discount__c));
        quoteMap.put('emailTemp', objQuote.Email__c);
        quoteMap.put('expirationDate', String.valueOf(objQuote.Expiration_Date__c));
        quoteMap.put('faxTemp', objQuote.Fax__c);
        quoteMap.put('grandTotal', String.valueOf(objQuote.Grand_Total__c));
        quoteMap.put('phoneTemp', objQuote.Phone__c);
        quoteMap.put('quoteToAddress', objQuote.Quote_To_Address__c);
        quoteMap.put('quoteToName', objQuote.Quote_To_Name__c);
        quoteMap.put('shippingAndHandling', String.valueOf(objQuote.Shipping_And_Handling__c));
        quoteMap.put('shipTo', objQuote.Ship_To__c);
        quoteMap.put('shipToName', objQuote.Ship_To_Name__c);
        quoteMap.put('statusTemp', objQuote.Status__c);
        quoteMap.put('relatedToOrder', objQuote.Related_to_Order__c);
        quoteMap.put('taxTemp', String.valueOf(objQuote.Tax__c));
        quoteMap.put('syncTemp', String.valueOf(objQuote.Syncing__c));
        quoteMap.put('quoteSalePrice', String.valueOf(objQuote.Quote_Sale_Price__c));
        quoteMap.put('totalPriceQuote', String.valueOf(objQuote.Total_Price_Quote__c));
        quoteMap.put('stateTemp', objQuote.State__c);
        quoteMap.put('Rate', String.valueOf(objQuote.Quote_Rate__c));
        quoteMap.put('TradeAllowance', String.valueOf(objQuote.Quote_Trade_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('Discount', String.valueOf(objQuote.Discount_On_Quote__c));
        quoteMap.put('msrpBoatPrice', String.valueOf(objQuote.Quote_MSRP_Boat_Price__c));
        quoteMap.put('msrpTrailerPrice', String.valueOf(objQuote.Quote_MSRP_Trailer_Price__c));
        quoteMap.put('TrailerACV', String.valueOf(objQuote.Quote_Trailer_ACV__c));
        quoteMap.put('TrailerSalesTax', String.valueOf(objQuote.Quote_Trailer_Sales_Tax__c));
        quoteMap.put('BoatRegfee', String.valueOf(objQuote.Quote_Boat_Reg_Fee__c));
        quoteMap.put('TrailerRegfee', String.valueOf(objQuote.Quote_Trailer_Reg_Fee__c));
        quoteMap.put('Docfee', String.valueOf(objQuote.Quote_Doc_Fee__c));
        quoteMap.put('Tradepayoff', String.valueOf(objQuote.Negotiation_Trade_Payoff__c));
        quoteMap.put('Downpayment', String.valueOf(objQuote.Quote_Down_Payment__c));
        quoteMap.put('cost', String.valueOf(objQuote.Quote_Cost__c));
        quoteMap.put('dealMargin', String.valueOf(objQuote.Quote_Deal_Margin__c));
        quoteMap.put('lstQuoteLineItem', objQLI.Id);
        
        
        NegotiationController.save(quoteMap);    
    }
    
    static testMethod void myUnitTest1() {
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
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.Name = 'Test ()';
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
        
        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
        objQLI.Name = 'Test QLI';
        objQLI.Date__c = Date.today();
        objQLI.Dealer_Price__c = 2000.0;
        objQLI.Sales_Price__c = 2000.0;
        objQLI.Total_Price__c = 2000.0;
        objQLI.Product_Code__c = '3002256';
        objQLI.Product__c = objProduct.Id;
        objQLI.Quote__c = objQuote.Id;
        objQLI.Option_Category__c = 'Sample Test Option';
        insert objQLI;
        
        apexpages.currentpage().getparameters().put('id' , objQuote.Id);
        NegotiationController objNegotiationController = new NegotiationController();
        objNegotiationController.cancel();
        objNegotiationController.clear();
        Map<String, String> quoteMap = new Map<String, String>();
        
        quoteMap.put('tempName', objQuote.Name);
        quoteMap.put('accountName', objQuote.Account_Name__c);
        quoteMap.put('additionalTo', objQuote.Additional_To__c);
        quoteMap.put('additionalToName', objQuote.Additional_To_Name__c);
        quoteMap.put('billTo', objQuote.Bill_To__c);
        quoteMap.put('billToName', objQuote.Bill_To_Name__c);
        quoteMap.put('contactName', objQuote.Contact_Name__c);
        quoteMap.put('descriptionTemp', objQuote.Description__c);
        quoteMap.put('discountTemp', String.valueOf(objQuote.Discount__c));
        quoteMap.put('emailTemp', objQuote.Email__c);
        quoteMap.put('expirationDate', String.valueOf(objQuote.Expiration_Date__c));
        quoteMap.put('faxTemp', objQuote.Fax__c);
        quoteMap.put('grandTotal', String.valueOf(objQuote.Grand_Total__c));
        quoteMap.put('phoneTemp', objQuote.Phone__c);
        quoteMap.put('quoteToAddress', objQuote.Quote_To_Address__c);
        quoteMap.put('quoteToName', objQuote.Quote_To_Name__c);
        quoteMap.put('shippingAndHandling', String.valueOf(objQuote.Shipping_And_Handling__c));
        quoteMap.put('shipTo', objQuote.Ship_To__c);
        quoteMap.put('shipToName', objQuote.Ship_To_Name__c);
        quoteMap.put('statusTemp', objQuote.Status__c);
        quoteMap.put('relatedToOrder', objQuote.Related_to_Order__c);
        quoteMap.put('taxTemp', String.valueOf(objQuote.Tax__c));
        quoteMap.put('syncTemp', String.valueOf(objQuote.Syncing__c));
        quoteMap.put('quoteSalePrice', String.valueOf(objQuote.Quote_Sale_Price__c));
        quoteMap.put('totalPriceQuote', String.valueOf(objQuote.Total_Price_Quote__c));
        quoteMap.put('stateTemp', objQuote.State__c);
        quoteMap.put('Rate', String.valueOf(objQuote.Quote_Rate__c));
        quoteMap.put('TradeAllowance', String.valueOf(objQuote.Quote_Trade_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('Discount', String.valueOf(objQuote.Discount_On_Quote__c));
        quoteMap.put('msrpBoatPrice', String.valueOf(objQuote.Quote_MSRP_Boat_Price__c));
        quoteMap.put('msrpTrailerPrice', String.valueOf(objQuote.Quote_MSRP_Trailer_Price__c));
        quoteMap.put('TrailerACV', String.valueOf(objQuote.Quote_Trailer_ACV__c));
        quoteMap.put('TrailerSalesTax', String.valueOf(objQuote.Quote_Trailer_Sales_Tax__c));
        quoteMap.put('BoatRegfee', String.valueOf(objQuote.Quote_Boat_Reg_Fee__c));
        quoteMap.put('TrailerRegfee', String.valueOf(objQuote.Quote_Trailer_Reg_Fee__c));
        quoteMap.put('Docfee', String.valueOf(objQuote.Quote_Doc_Fee__c));
        quoteMap.put('Tradepayoff', String.valueOf(objQuote.Negotiation_Trade_Payoff__c));
        quoteMap.put('Downpayment', String.valueOf(objQuote.Quote_Down_Payment__c));
        quoteMap.put('cost', String.valueOf(objQuote.Quote_Cost__c));
        quoteMap.put('dealMargin', String.valueOf(objQuote.Quote_Deal_Margin__c));
        quoteMap.put('lstQuoteLineItem', objQLI.Id);
        
        
        NegotiationController.save(quoteMap);    
    }
    static testMethod void myUnitTest2() {
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        BOATBUILDING__ACV_Form__c ObjF = new BOATBUILDING__ACV_Form__c();
        ObjF.BOATBUILDING__Contact_Name__c = objContact.Id;
        ObjF.BOATBUILDING__High_Comp_1_Amount__c = 1;
        ObjF.BOATBUILDING__High_Comp_2_Amount__c = 12;
        ObjF.BOATBUILDING__High_Comp_3_Amount__c= 123;
        ObjF.BOATBUILDING__Low_Comp_1_Amount__c = 1234;
        ObjF.BOATBUILDING__Low_Comp_2_Amount__c = 12345;
        insert ObjF;
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.Part_Number__c = 'dfvdsgsgv';
        objInventory.BOATBUILDING__Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
        objProduct1.M_Year__c = '2016';
        objProduct1.MModel2__c = 'Mondo(MD)';
        objProduct1.Product_Manufacturer__c = objManufacturer1.Id;
        objProduct1.Cost_Price__c = 40000;
        objProduct1.M_Boat_MSRP_PRICE__c = 50000;
        objProduct1.M_Dealer_Status__c ='Quoted';
        objProduct1.M_Manufacture_Status__c = 'Ordered';
        insert objProduct1;
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        Map<String, String> quoteMap = new Map<String, String>();
        objQuote.Name = 'Test ()';
        objQuote.Additional_To__c = 'test';
        objQuote.Additional_To_Name__c = 'test';
        objQuote.Bill_To_Name__c = 'test';
        objQuote.BOATBUILDING__ACV_Form__c = ObjF.Id;
        objQuote.BOATBUILDING__Test_2__c = objInventory.Id;
        objQuote.BOATBUILDING__Account_Name__c = a.Id;
        objQuote.BOATBUILDING__Contact_Name__c = objContact.Id;
        objQuote.BOATBUILDING__Quote_Total_MSRP__c = 1234;
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
        objQuote.BOATBUILDING__Related_to_Product__c = objProduct1.Id;
        objQuote.BOATBUILDING__Quote_Term__c = 'Other';
        objQuote.BOATBUILDING__Mapped_Engine_SN__c = 'tested';
        objQuote.BOATBUILDING__Mapped_HIN__c = 'testtttt';
        objQuote.BOATBUILDING__Mapped_Trailer_VIN__c = 'test';
       // objQuote.BOATBUILDING__Trailer__c = objInventory.Id;
       // objQuote.BOATBUILDING__Engine__c = objInventory.Id;
        insert objQuote;
        
        quoteMap.put('tempName', objQuote.Name);
        quoteMap.put('accountName', objQuote.Account_Name__c);
        quoteMap.put('additionalTo', objQuote.Additional_To__c);
        quoteMap.put('additionalToName', objQuote.Additional_To_Name__c);
        quoteMap.put('billTo', objQuote.Bill_To__c);
        quoteMap.put('billToName', objQuote.Bill_To_Name__c);
        quoteMap.put('contactName', objQuote.Contact_Name__c);
        quoteMap.put('descriptionTemp', objQuote.Description__c);
        quoteMap.put('discountTemp', String.valueOf(objQuote.Discount__c));
        quoteMap.put('emailTemp', objQuote.Email__c);
        quoteMap.put('expirationDate', String.valueOf(objQuote.Expiration_Date__c));
        quoteMap.put('faxTemp', objQuote.Fax__c);
        quoteMap.put('grandTotal', String.valueOf(objQuote.Grand_Total__c));
        quoteMap.put('phoneTemp', objQuote.Phone__c);
        quoteMap.put('quoteToAddress', objQuote.Quote_To_Address__c);
        quoteMap.put('quoteToName', objQuote.Quote_To_Name__c);
        quoteMap.put('shippingAndHandling', String.valueOf(objQuote.Shipping_And_Handling__c));
        quoteMap.put('shipTo', objQuote.Ship_To__c);
        quoteMap.put('shipToName', objQuote.Ship_To_Name__c);
        quoteMap.put('statusTemp', objQuote.Status__c);
        quoteMap.put('relatedToOrder', objQuote.Related_to_Order__c);
        quoteMap.put('taxTemp', String.valueOf(objQuote.Tax__c));
        quoteMap.put('syncTemp', String.valueOf(objQuote.Syncing__c));
        quoteMap.put('quoteSalePrice', String.valueOf(objQuote.Quote_Sale_Price__c));
        quoteMap.put('totalPriceQuote', String.valueOf(objQuote.Total_Price_Quote__c));
        quoteMap.put('stateTemp', objQuote.State__c);
        quoteMap.put('Rate', String.valueOf(objQuote.Quote_Rate__c));
        quoteMap.put('TradeAllowance', String.valueOf(objQuote.Quote_Trade_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('TrailerAllowance', String.valueOf(objQuote.Quote_Trailer_Allowance__c));
        quoteMap.put('Discount', String.valueOf(objQuote.Discount_On_Quote__c));
        quoteMap.put('msrpBoatPrice', String.valueOf(objQuote.Quote_MSRP_Boat_Price__c));
        quoteMap.put('msrpTrailerPrice', String.valueOf(objQuote.Quote_MSRP_Trailer_Price__c));
        quoteMap.put('TrailerACV', String.valueOf(objQuote.Quote_Trailer_ACV__c));
        quoteMap.put('TrailerSalesTax', String.valueOf(objQuote.Quote_Trailer_Sales_Tax__c));
        quoteMap.put('BoatRegfee', String.valueOf(objQuote.Quote_Boat_Reg_Fee__c));
        quoteMap.put('TrailerRegfee', String.valueOf(objQuote.Quote_Trailer_Reg_Fee__c));
        quoteMap.put('Docfee', String.valueOf(objQuote.Quote_Doc_Fee__c));
        quoteMap.put('Tradepayoff', String.valueOf(objQuote.Negotiation_Trade_Payoff__c));
        quoteMap.put('Downpayment', String.valueOf(objQuote.Quote_Down_Payment__c));
        quoteMap.put('cost', String.valueOf(objQuote.Quote_Cost__c));
        quoteMap.put('dealMargin', String.valueOf(objQuote.Quote_Deal_Margin__c));
        quoteMap.put('ACVFORM', ObjF.Id);
        quoteMap.put('relatedInv', objInventory.Id);
        quoteMap.put('accountName', a.Id);
        quoteMap.put('quoteTotalMSRP', String.valueOf(objQuote.BOATBUILDING__Quote_Total_MSRP__c));
        quoteMap.put('contactName', objcontact.Id);
         quoteMap.put('relatedToProduct', objProduct1.Id);
         quoteMap.put('Term', 'Other');
         quoteMap.put('engineSN', 'tested');
         quoteMap.put('hin', 'testtt');
         quoteMap.put('trailerVIN', 'test');
         quoteMap.put('QuoteTrailer',objInventory.Id );
         quoteMap.put('QuoteEngine',objInventory.Id );
         quoteMap.put('tranGearSN','test' );
        
        
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        NegotiationPageLayoutController objNegotiation = new NegotiationPageLayoutController(sc); 
        NegotiationPageLayoutController.save(quoteMap);
        
    }
    
}