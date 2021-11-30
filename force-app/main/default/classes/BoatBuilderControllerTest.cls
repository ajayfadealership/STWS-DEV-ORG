@istest
public with sharing class BoatBuilderControllerTest 
{
    Public static  testMethod void CallConstructor1()
    { 
        List<String> lstKeySet = new List<String>();
        String objCustomerName;
        String getManufacturerName;
        String selectedYearThirdPage;
        String selectedProductDCId;
        BOATBUILDING__System_Configure__c objSC = new BOATBUILDING__System_Configure__c();
        objSC.BOATBUILDING__Quote_Disclaimer__c = 'ABCD';
        objSC.BOATBUILDING__Site_URL__c = 'www.google.com';
        objSC.BOATBUILDING__Quote_PDF__c  = 'Test';
        objSC.BOATBUILDING__Quote_PDF_NT__c  = 'Test';
        objSC.BOATBUILDING__Quote_PDF_NT_skp__c   = 'Test';
        objSC.BOATBUILDING__Quote_PDF_skp__c    = 'Test';
        objSC.BOATBUILDING__BillOfSale__c      = 'Test';
        objSC.BOATBUILDING__BillOfSaleNT__c       = 'Test';
        insert objSC;
        BOATBUILDING__Manufacturer__c objManufacturer1 = new BOATBUILDING__Manufacturer__c();
        objManufacturer1.Manufacturer_name__c = '12345';
        objManufacturer1.Name = 'Skiers Choice(Moomba)';
        objManufacturer1.Model_Variant__c = false;
        insert objManufacturer1;
        
        
        BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
        objProduct1.M_Year__c = '2016';
        objProduct1.MModel2__c = 'Mondo(MD)';
        objProduct1.Product_Manufacturer__c = objManufacturer1.Id;
        objProduct1.Cost_Price__c = 40000;
        objProduct1.M_Boat_MSRP_PRICE__c = 50000;
        objProduct1.M_Dealer_Status__c ='Quoted';
        objProduct1.M_Manufacture_Status__c = 'Ordered';
        insert objProduct1;
        
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        
        
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        if(lstRT.size() > 0){
            objPP.RecordTypeId = lstRT[0].Id;
        }
        objPP.Option_Category__c = 'Trailer Light Options (9G)';
        objPP.ProductSelected_Category__c = 'Surface Mount Clear LED';
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Year__c ='2016';
        objPP.Product_Model__c ='Mondo(MD)';
        objPP.Product_Code__c = 'ABC123';
        objPP.ProductRetail_Price__c = 100;
        objPP.Dealer_Price__c =50;
        objPP.Sorting_Order__c = 35;
        insert objPP;
        
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
        
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem1 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem1.Related_to_Inventory__c = objInventory1 .Id;
        objInventoryLineItem1.Option_Category__c = 'Trailer Light Options (9G)';
        objInventoryLineItem1.Name = 'Surface Mount Clear LED';
        objInventoryLineItem1.Name__c = 'Surface Mount Clear LED';
        objInventoryLineItem1.Price__c = 500;
        objInventoryLineItem1.Dealer_Price__c= 50.00;
        objInventoryLineItem1.Product_Code__c = 'ABC123';
        objInventoryLineItem1.Quantity__c = 10;
        insert objInventoryLineItem1;
        
        BOATBUILDING__Dealer_Option__c objDealerOption = new BOATBUILDING__Dealer_Option__c();
        objDealerOption.Name = '360DC Test';
        objDealerOption.Cost__c = 100.00;
        objDealerOption.Part_Number__c = 'ABC123';
        objDealerOption.Retail_Price__c = 80.00;
        insert objDealerOption;
        
        ApexPages.currentPage().getParameters().put('invId',objInventory1.id);
        //ApexPages.currentPage().getParameters().put('SelectedType', 'test');
        BoatBuilderController objBoatBuilderController1 = new BoatBuilderController();
        objBoatBuilderController1.lstKeySet = lstKeySet;
        objBoatBuilderController1.objCustomerName = objCustomerName;
        objBoatBuilderController1.getManufacturerName = getManufacturerName;
        objBoatBuilderController1.selectedYearThirdPage = selectedYearThirdPage;
        objBoatBuilderController1.selectedProductDCId = selectedProductDCId;
        objBoatBuilderController1.selectedModel= objProduct1.Id;
        Pagereference prfc2 = objBoatBuilderController1.callThirdPage();
        Pagereference prfc1 = objBoatBuilderController1.getModel();
        objBoatBuilderController1.dealerPartNumber = 'ABC123';
        objBoatBuilderController1.getDealerOptionPrice();   
        objBoatBuilderController1.getDealerOptionPriceSub();
        objBoatBuilderController1.getManufacturer();
      //  objBoatBuilderController1.PageReference updateInventory();
     //   pagereference pr1 = objBoatBuilderController1.checkAccess(); //
       
        
        BOATBUILDING__Manufacturer__c objManufacturer2 = new BOATBUILDING__Manufacturer__c();
        objManufacturer2.Manufacturer_name__c = '123456';
        objManufacturer2.Name = 'Skiers Choice(Supra)';
        objManufacturer2.Model_Variant__c = true;
        insert objManufacturer2;
        BOATBUILDING__Product__c objProduct2 = new BOATBUILDING__Product__c();
        objProduct2.M_Year__c = '2017';
        objProduct2.MModel2__c = 'SR';
        objProduct2.Product_Manufacturer__c = objManufacturer2.Id;
        objProduct2.M_Model_Variant__c = 'SR400';
        objProduct2.Cost_Price__c = 40000;
        objProduct2.M_Boat_MSRP_PRICE__c = 50000;
        objProduct2.M_Dealer_Status__c ='Quoted';
        objProduct2.M_Manufacture_Status__c = 'Ordered';
        insert objProduct2;
       
         BOATBUILDING__Quote_Line_Item__c objQLI1 = new BOATBUILDING__Quote_Line_Item__c();
        objQLI1.Name = 'QLI';
        objQLI1.Name__c = objDealerOption.Name; 
        objQLI1.Product__c = objProduct1.Id;
        objQLI1.Option_Category__c = 'Dealer Options';
        objQLI1.Product_Code__c = objDealerOption.Part_Number__c;
        objQLI1.Dealer_Price__c = objDealerOption.Cost__c;
        objQLI1.Total_Price__c = objDealerOption.Retail_Price__c;
        
        
        List<RecordType>  lstInventory2Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats'];
        
        BOATBUILDING__Inventory__c objInventory2 = new BOATBUILDING__Inventory__c();
        if(lstInventory2Id.size()>0)
        {
            objInventory2.RecordTypeId =  lstInventory2Id[0].Id;
            
        }
        
        objInventory2.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory2.Year__c = '2017';
        objInventory2.Model__c = 'SR';
        objInventory2.Cost__c =10000;
        objInventory2.Model_Variant__c = 'SR400';
        insert objInventory2;
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem2 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem2.Related_to_Inventory__c = objInventory2.Id;
        objInventoryLineItem2.Name = 'Bow Cover';
        objInventoryLineItem2.Name__c = 'Bow Cover';
        objInventoryLineItem2.Product_Code__c = '122sdsd'; 
        objInventoryLineItem2.Option_Category__c = 'Canvas';
        objInventoryLineItem2.Price__c = 500;
        objInventoryLineItem2.Dealer_Price__c= 500.0;
        objInventoryLineItem2.Quantity__c = 10;
        insert objInventoryLineItem2;
        
        
        List<RecordType>  lstPPId = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        if(lstPPId.size() > 0){
            objProductPriceForSelectedCategory.RecordTypeId = lstPPId[0].Id;
        }
        objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bow Cover';
        objProductPriceForSelectedCategory.Product_Code__c = '123456';
        objProductPriceForSelectedCategory.ProductRetail_Price__c = 100;
        objProductPriceForSelectedCategory.Dealer_Price__c =50;
        objProductPriceForSelectedCategory.Sorting_Order__c = 40;
        insert objProductPriceForSelectedCategory;
        
        BOATBUILDING__Dealer_Option__c objDealerOptionUsed = new BOATBUILDING__Dealer_Option__c();
        objDealerOptionUsed.Name = '360DC Test';
        objDealerOptionUsed.Cost__c = 100.00;
        objDealerOptionUsed.Part_Number__c = 'ABC123';
        objDealerOptionUsed.Retail_Price__c = 80.00;
        insert objDealerOptionUsed;
        
        ApexPages.currentPage().getParameters().put('invId',objInventory2.id);
        BoatBuilderController objBoatBuilderController2 = new BoatBuilderController();
        Pagereference pagereferenceNew = objBoatBuilderController2.getModel();
        
        BOATBUILDING__Product__c objProduct3 = new BOATBUILDING__Product__c();
        objProduct3.M_Year__c = '2016';
        objProduct3.MModel2__c = 'SC';
        objProduct2.M_Model_Variant__c = 'SC400';
        objProduct3.Product_Manufacturer__c = objManufacturer2.Id;
        objProduct3.Cost_Price__c = 40000;
        objProduct3.M_Boat_MSRP_PRICE__c = 50000;
        objProduct3.M_Dealer_Status__c ='Quoted';
        objProduct3.M_Manufacture_Status__c = 'Ordered';
        insert objProduct3;
        
        List<RecordType>  lstInventory3Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        BOATBUILDING__Inventory__c objInventory3 = new BOATBUILDING__Inventory__c();
        if(lstInventory3Id.size() > 0){
            objInventory3.RecordTypeId = lstInventory3Id[0].Id;
        }
        objInventory3.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory3.Year__c = '2016';
        objInventory3.Model__c = 'SC';
        objInventory2.Model_Variant__c = 'SC400';
        objInventory3.Cost__c =10000;
        objInventory3.Part_Number__c ='5555';
        insert objInventory3;
        
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem3 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem3.Related_to_Inventory__c = objInventory3.Id;
        objInventoryLineItem3.Name = 'Surface Mount Clear LED';
        objInventoryLineItem3.Name__c = 'Surface Mount Clear LED';
        objInventoryLineItem3.Price__c = 500;
        objInventoryLineItem3.Option_Category__c = 'Trailer Light Options (9G)';
        objInventoryLineItem3.Dealer_Price__c = 20.0;
        objInventoryLineItem3.Product_Code__c = '864199';
        objInventoryLineItem3.Quantity__c = 10;
        insert objInventoryLineItem3;
        ApexPages.currentPage().getParameters().put('invId',objInventory3.id);
        BoatBuilderController objBoatBuilderController3 = new BoatBuilderController();
        
        
        
        BOATBUILDING__Product__c objProduct4 = new BOATBUILDING__Product__c();
        objProduct4.Product_Manufacturer__c = objManuFacturer1.Id;
        objProduct4.M_Year__c = '2016';  
        objProduct4.MModel2__c = 'Hexa'; 
        insert objProduct4;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'Test Account';
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'Test';
        objContact1.LastName = 'Contact';
        objContact1.AccountId = objAccount1.Id;
        insert objContact1;
        
        BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
        objQuote1.Name = 'Test';
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
        objQuote1.Status__c = 'Draft';
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
        insert objQuote1;
        
        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
        objQLI.Name = 'Test QLI';
        objQLI.Date__c = Date.today();
        objQLI.Option_Category__c = 'Trailer Light Options (9G)';
        objQLI.Dealer_Price__c = 2000.0;
        objQLI.Sales_Price__c = 2000.0;
        objQLI.Total_Price__c = 2000.0;
        objQLI.Product_Code__c = '3002256';
        objQLI.Product__c = objProduct4.Id;
        objQLI.Quote__c = objQuote1.Id;
        insert objQLI;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objQuote1);
        BoatBuilderController testAccPlan = new BoatBuilderController(sc);
        
        BOATBUILDING__Quote_Line_Item__c objQL2= new BOATBUILDING__Quote_Line_Item__c();
        objQL2.Name = 'Test QLI';
        objQL2.Date__c = Date.today();
        objQL2.Option_Category__c = 'Trailer Light Options (9G)';
        objQL2.Dealer_Price__c = 2000.0;
        objQL2.Sales_Price__c = 2000.0;
        objQL2.Total_Price__c = 2000.0;
        objQL2.Product_Code__c = '3002256';
        objQL2.Product__c = objProduct4.Id;
        objQL2.Quote__c = objQuote1.Id;
        insert objQL2;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objQuote1.id;
        insert attach;
        
        apexpages.currentpage().getparameters().put('Id' , objQuote1.Id);
        BoatBuilderController objBoatBuilderController4 = new BoatBuilderController();
        //Pagereference pf = objBoatBuilderController4.saveAndSendQuote();
        Pagereference pf7 = objBoatBuilderController4.saveQuoteasPDF();
        objBoatBuilderController4.rowNumber = '1';
        
        apexpages.currentpage().getparameters().put('quoteId',objQuote1.Id);
        BoatBuilderController newobjBoatBuilderController = new BoatBuilderController();
        //objBoatBuilderController4.getMFGPrice();
        
        
        BOATBUILDING__Product__c objProduct5 = new BOATBUILDING__Product__c();
        objProduct5.M_Year__c = '2017';
        objProduct5.MModel2__c = 'SR';
        objProduct5.Product_Manufacturer__c = objManufacturer2.Id;
        objProduct5.M_Model_Variant__c = 'SR400';
        objProduct5.Cost_Price__c = 40000;
        objProduct5.M_Boat_MSRP_PRICE__c = 50000;
        objProduct5.Engine_SN__c = 'AAA111';
        objProduct5.Boat_Length_in_Feets__c = '12';
        objProduct5.Hull_Id__c = 'XYZ';
        objProduct5.Trailer_VIN__c = '123abc';
        
        objProduct5.Part_Number__c  ='a3s5ed4';
        objProduct5.Dealer__c = 'South Indian Water Sport';
        objProduct5.M_Dealer_Base_Price__c = 564.00;
        objProduct5.M_Dealer_Discount__c = 20;
        objProduct5.M_Dealer_COD_Discount__c = 20;
        objProduct5.M_Dealer_Flat_Discount__c = 20;
        objProduct5.M_Dealer_Stock__c = 12;
        objProduct5.M_Dealer_Comments__c = 'asnhajdkl';
        objProduct5.Transmission_Gearbox_SN__c = 'asda131lk'; 
        objProduct5.M_Dealer_Status__c ='Quoted';
        objProduct5.M_Manufacture_Status__c = 'Ordered';
        insert objProduct5;
        
        Item__c objItem5 = new Item__c();
        
        
        List<RecordType>  lstInventory5Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        //String recIdInventory5 = lstInventory5Id.size() > 0 ? lstInventory5Id[0].Id : null;
        BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
        if(lstInventory5Id.size() > 0){
            objInventory5.RecordTypeId = lstInventory5Id[0].Id;
        }
        //objInventory5.RecordTypeId = recIdInventory5;
        objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory5.Year__c = '2017';
        objInventory5.Model__c = 'SR';
        objInventory5.Cost__c =10000;
        objInventory5.Model_Variant__c = 'SR400';
        objInventory5.Part_Number__c = 'ABC400';
        objInventory5.Engine_SN__c = '12345';
        objInventory5.Boat_Length_in_feets__c = '12';
        objInventory5.HIN_Number__c = 'ABC12';
        objInventory5.Trailer_VIN__c = 'xyz';
        insert objInventory5;
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem5 = new BOATBUILDING__Inventory_Line_Item__c();
        //objInventoryLineItem5.Related_to_Inventory__c = objInventory5.Id;
        objInventoryLineItem5.Name = 'Walk-Thru Screen';
        objInventoryLineItem5.Name__c = 'Walk-Thru Screen';
        objInventoryLineItem5.Option_Category__c = 'Trailer Light Options (9G)';
        objInventoryLineItem5.Price__c = 500;
        objInventoryLineItem5.Dealer_Price__c = 20.0;     
        objInventoryLineItem5.Product_Code__c = '817864';
        objInventoryLineItem5.Quantity__c = 10;
        //insert objInventoryLineItem5;
        
        
        ApexPages.currentPage().getParameters().put('invId',objInventory5.id);
        BoatBuilderController objBoatBuilderController5 = new BoatBuilderController();
        objBoatBuilderController5.getModel();
        objBoatBuilderController5.checkAccess();
        Pagereference pf6 = objBoatBuilderController5.getModelVariant();
        
        objBoatBuilderController5.objItem = objItem5;
        BOATBUILDING__Quote_Line_Item__c objQL3= new BOATBUILDING__Quote_Line_Item__c();
        objQL3.Name = 'Test QLI';
        objQL3.Date__c = Date.today();
        objQL3.Option_Category__c = 'Trailer Light Options (9G)';
        objQL3.Dealer_Price__c = 2000.0;
        objQL3.Sales_Price__c = 2000.0;
        objQL3.Total_Price__c = 2000.0;
        objQL3.Product_Code__c = '3002256';
        objQL3.Product__c = objProduct4.Id;
        //objQL3.Quote__c = objQuote1.Id;
        //insert objQL3;
        
        objBoatBuilderController5.lstQuoteLineItem.add(objQL3);
        objBoatBuilderController5 .selectedModelVariant= objProduct5.Id;
        //Pagereference pf1 = objBoatBuilderController5.callThirdPage();
        Pagereference pf2 = objBoatBuilderController5.thirdPageSave();
        objBoatBuilderController5.rowNumber = '1';
        //objBoatBuilderController5.getMFGPrice();
        objBoatBuilderController5.saveAndRecaculate();
        
        objBoatBuilderController5.lstInventoryLineItem.add(objInventoryLineItem5);
        objBoatBuilderController5.selectedManufacture = objManufacturer2.Id;
        objBoatBuilderController5.selectedYear = '2017';
        objBoatBuilderController5.selectedModel = objProduct5.Id;
        objBoatBuilderController5.totalPrice = 10000;
        Pagereference pf4 = objBoatBuilderController5.placeOrderForInventory();
        apexpages.currentpage().getparameters().put('quoteId',objQuote1.Id);
        Pagereference pf5 = objBoatBuilderController5.sendQuote();
        BoatBuilderController.getCanSendEmails();
        //Pagereference pf6 = objBoatBuilderController5.saveAndSendQuote();
        objBoatBuilderController5.selectedModel= objProduct5.Id;
        
        //Pagereference prfce1 = objBoatBuilderController5.callThirdPage();
        Pagereference prfce2 = objBoatBuilderController5.getModel();
        
        
        
        
        BOATBUILDING__Product__c objProduct6 = new BOATBUILDING__Product__c();
        objProduct6.M_Year__c = '2016';
        objProduct6.MModel2__c = 'SC';
        objProduct6.M_Model_Variant__c = 'SC400';
        objProduct6.Product_Manufacturer__c = objManufacturer2.Id;
        objProduct6.Cost_Price__c = 40000;
        objProduct6.M_Boat_MSRP_PRICE__c = 50000;
        objProduct6.M_Dealer_Status__c ='Quoted';
        objProduct6.M_Manufacture_Status__c = 'Ordered';
        insert objProduct6;
        
        
        List<RecordType>  lstobjPP6Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        BOATBUILDING__ProductPrice__c objPP6 = new BOATBUILDING__ProductPrice__c();
        if(lstobjPP6Id.size() > 0){
            objPP6.RecordTypeId = lstobjPP6Id[0].Id;
        }
        objPP6.Option_Category__c = 'Trailer Wheel Options (9F)';
        objPP6.ProductSelected_Category__c = '18" Spare Tire, Framed Side Mount';
        objPP6.ProductManufacturer__c = 'Skiers Choice(Supra)';
        objPP6.Year__c ='2016';
        objPP6.Product_Model__c ='SC';
        objPP6.Model_Variant__c = 'SC400';
        objPP6.Product_Code__c = '864199';
        objPP6.ProductRetail_Price__c = 100;
        objPP6.Dealer_Price__c =50;
        objPP6.Sorting_Order__c =51;
        insert objPP6;
    }
    
    Public static  testMethod void CallConstructor2()
    { 
        BOATBUILDING__Manufacturer__c objManufacturer2 = new BOATBUILDING__Manufacturer__c();
        objManufacturer2.Manufacturer_name__c = '123456';
        objManufacturer2.Name = 'Skiers Choice(Moomba)';
        objManufacturer2.Model_Variant__c = false;
        insert objManufacturer2;
        BOATBUILDING__Product__c objProduct2 = new BOATBUILDING__Product__c();
        objProduct2.M_Year__c = '2017';
        objProduct2.MModel2__c = 'Mondo(MD)';
        objProduct2.Product_Manufacturer__c = objManufacturer2.Id;
        //objProduct2.M_Model_Variant__c = 'SR400';
        objProduct2.Cost_Price__c = 40000;
        objProduct2.M_Boat_MSRP_PRICE__c = 50000;
        objProduct2.M_Dealer_Status__c ='Quoted';
        objProduct2.M_Manufacture_Status__c = 'Ordered';
        insert objProduct2;
        
        
        BOATBUILDING__Inventory__c objInventory2 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstobjInventory2RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        if(lstobjInventory2RT.size() > 0){
            objInventory2.RecordTypeId = lstobjInventory2RT[0].Id;
        }
        
        objInventory2.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory2.Year__c = '2017';
        objInventory2.Model__c = 'Mondo(MD)';
        objInventory2.Cost__c =10000;
        objInventory2.Part_Number__c = '12345';
        //objInventory2.Model_Variant__c = 'SR400';
        insert objInventory2;
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem2 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem2.Option_Category__c = 'Trailer Wheel Options (9F)';
        objInventoryLineItem2.Related_to_Inventory__c = objInventory2.Id;
        objInventoryLineItem2.Name = 'Bow Cover';
        objInventoryLineItem2.Name__c = 'Bow Cover';
        objInventoryLineItem2.Price__c = 500;
        objInventoryLineItem2.Dealer_Price__c = 20.0;     
        //objInventoryLineItem2.Product_Code__c = '817864';
        objInventoryLineItem2.Quantity__c = 10;
        insert objInventoryLineItem2;
        
        
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstPPriceRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
        if(lstPPriceRT.size() > 0){
            objProductPriceForSelectedCategory.RecordTypeId = lstPPriceRT[0].Id;
        }
        
        objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bow Cover';
        objProductPriceForSelectedCategory.Product_Code__c = '123456';
        objProductPriceForSelectedCategory.ProductRetail_Price__c = 100;
        objProductPriceForSelectedCategory.Dealer_Price__c =50;
        objProductPriceForSelectedCategory.Sorting_Order__c =50;
        insert objProductPriceForSelectedCategory;
        
        ApexPages.currentPage().getParameters().put('invId',objInventory2.id);
        BoatBuilderController objBoatBuilderController = new BoatBuilderController();
        objBoatBuilderController.getYearAndModel();
        objBoatBuilderController.getModel();
        objBoatBuilderController.getYearAndModel();
        objBoatBuilderController.secondPage();
        objBoatBuilderController.cancelPage();
        objBoatBuilderController.callFirstPage();
        
        objBoatBuilderController.selectedModel= objProduct2.Id;
        Pagereference pf1 = objBoatBuilderController.callThirdPage();
        Pagereference pf2 = objBoatBuilderController.thirdPageSave();
        
        objBoatBuilderController.saveAndRecaculate();
        
        
        Pagereference pf4 = objBoatBuilderController.placeOrderForInventory();
        Pagereference pf5 = objBoatBuilderController.sendQuote();
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        //Pagereference pf6 = objBoatBuilderController.saveAndSendQuote();
    }
    
    public static testMethod void myUnitTest3()
    {
        BOATBUILDING__Manufacturer__c objManufacturer5 = new BOATBUILDING__Manufacturer__c();
        objManufacturer5.Manufacturer_name__c = '12345655555';
        objManufacturer5.Name = 'Skiers Choice(Supra)';
        objManufacturer5.Model_Variant__c = true;
        insert objManufacturer5;
        BOATBUILDING__Product__c objProduct5 = new BOATBUILDING__Product__c();
        objProduct5.M_Year__c = '2017';
        objProduct5.MModel2__c = 'SR';
        objProduct5.Product_Manufacturer__c = objManufacturer5.Id;
        objProduct5.M_Model_Variant__c = 'SR400';
        objProduct5.Sale_Price__c = 40000;
        objProduct5.M_Trailer_MSRP_PRICE__c = 2;
        objProduct5.M_Discount__c = 0;
        objProduct5.M_Boat_Trade_Allowance__c = 2;
        objProduct5.M_Trailer_Trade_Allowance__c = 2;
        objProduct5.M_Boat_Actual_Cost_Value_ACV__c = 2;
        objProduct5.M_Trailer_Actual_Cost_Value_ACV__c = 2;
        objProduct5.M_Trailer_Sales_Tax__c = 2;
        objProduct5.M_Boat_Reg_Fee__c = 2;
        objProduct5.M_Trailer_Reg_Fee__c = 2;
        objProduct5.M_Doc_Fee__c =2;
        objProduct5.M_Retail_Price__c = 652.00;
        objProduct5.M_Trade_PayOFF__c = 2;
        objProduct5.M_Down_Payment__c = 2;
        objProduct5.M_Rfinance_Rate__c =2;
        objProduct5.M_Finance_Term__c = '5 Years';
        objProduct5.M_Payment__c = 2;
        //objProduct5.M_Deal_Margin__c = 2;
        
        Item__c objItem = new Item__c();
        objItem.Name = 'Sample Item';
        objItem.Trailer_Manufacturer__c = objManufacturer5.Id;
        insert objItem;
        
        
        objProduct5.M_Dealer_Status__c ='Quoted';
        objProduct5.M_Manufacture_Status__c = 'Ordered';
        insert objProduct5;
        
        BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstPPriceRT2= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        if(lstPPriceRT2.size() > 0){
            objProductPriceForSelectedCategory.RecordTypeId = lstPPriceRT2[0].Id;
        }
        objProductPriceForSelectedCategory.Option_Category__c = 'Upholstery Options (2G)';
        objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Walk-Thru Screen';
        objProductPriceForSelectedCategory.Product_Code__c = '123456';
        objProductPriceForSelectedCategory.Sorting_Order__c = 50;
        objProductPriceForSelectedCategory.ProductRetail_Price__c = 100;
        objProductPriceForSelectedCategory.Dealer_Price__c =50;
        insert objProductPriceForSelectedCategory;
        
        BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstobjInventory5RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        if(lstobjInventory5RT.size() > 0){
            objInventory5.RecordTypeId = lstobjInventory5RT[0].Id;
        }
        
        objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory5.Year__c = '2017';
        objInventory5.Model__c = 'SR';
        objInventory5.Cost__c =10000;
        objInventory5.Model_Variant__c = 'SR400';
        objInventory5.Part_Number__c = '888';
        insert objInventory5;
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem5 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem5.Related_to_Inventory__c = objInventory5.Id;
        objInventoryLineItem5.Option_Category__c = 'Upholstery Options (2G)';
        objInventoryLineItem5.Name = 'Walk-Thru Screen';
        objInventoryLineItem5.Name__c = 'Walk-Thru Screen';
        objInventoryLineItem5.Price__c = 500;
        objInventoryLineItem5.Dealer_Price__c = 20.0;     
        objInventoryLineItem5.Product_Code__c = '817864';
        objInventoryLineItem5.Quantity__c = 10;
        insert objInventoryLineItem5;
        ApexPages.currentPage().getParameters().put('invId',objInventory5.id);
        BoatBuilderController objBoatBuilderController5 = new BoatBuilderController();
        objBoatBuilderController5.getModel();
        Pagereference pf6 = objBoatBuilderController5.getModelVariant();
        
        
        objBoatBuilderController5 .selectedModelVariant= objProduct5.Id;
        Pagereference pf1 = objBoatBuilderController5.callThirdPage();
        Pagereference pf2 = objBoatBuilderController5.thirdPageSave();
        objBoatBuilderController5.rowNumber = '1';
        objBoatBuilderController5.selectedOptionString = 'Upholstery Options (2G)';
        objBoatBuilderController5.selectedOptionCategory = 'Walk-Thru Screen';
        objBoatBuilderController5.objItem.Trailer_Price__c = 55.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trailer_Price__c = 55.00;
        objBoatBuilderController5.trailerPrice = 110.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trailer_Price__c = 55.00;
        objBoatBuilderController5.trailerPrice = 55.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trailer_Price__c = 0;
        objBoatBuilderController5.trailerPrice = 0;
        objBoatBuilderController5.saveAndRecaculate();
        
        objBoatBuilderController5.objItem.Trade_In_Price_Value__c = 55.00;
        objBoatBuilderController5.trailerPrice = 22.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trade_In_Price_Value__c = 55.00;
        objBoatBuilderController5.trailerPrice = 222.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trade_In_Price_Value__c = 222.00;
        objBoatBuilderController5.trailerPrice = 222.00;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.objItem.Trade_In_Price_Value__c = 0;
        objBoatBuilderController5.trailerPrice = 0;
        objBoatBuilderController5.saveAndRecaculate();
        objBoatBuilderController5.pcCheckDis = true;
        objBoatBuilderController5.saveAndRecaculate();
        
        Pagereference pf4 = objBoatBuilderController5.placeOrderForInventory();
        Pagereference pf5 = objBoatBuilderController5.sendQuote();
        objBoatBuilderController5.selectedModel= objProduct5.Id;
        
        Pagereference prfce1 = objBoatBuilderController5.callThirdPage();
        Pagereference prfce2 = objBoatBuilderController5.getModel();
        
        
    }
    
    
    
    
   Public static  testMethod void CallConstructor3()
{ 

BOATBUILDING__Manufacturer__c objManufacturer1 = new BOATBUILDING__Manufacturer__c();
objManufacturer1.Manufacturer_name__c = '12345';
objManufacturer1.Name = 'Skiers Choice(supra)';
objManufacturer1.Model_Variant__c = true;
insert objManufacturer1;


BOATBUILDING__Product__c objProduct1 = new BOATBUILDING__Product__c();
objProduct1.M_Year__c = '2016';
objProduct1.MModel2__c = 'Mondo(MD)';
objProduct1.Product_Manufacturer__c = objManufacturer1.Id;
objProduct1.Cost_Price__c = 40000;
objProduct1.M_Boat_MSRP_PRICE__c = 50000;
objProduct1.M_Dealer_Status__c ='Quoted';
objProduct1.M_Manufacture_Status__c = 'Ordered';
insert objProduct1;
BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
List<RecordType>  lstobjPPRT2= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
if(lstobjPPRT2.size() > 0){
objPP.RecordTypeId = lstobjPPRT2[0].Id;
}
objPP.Option_Category__c = 'Trailer Light Options (9G)';
objPP.ProductSelected_Category__c = 'Surface Mount Clear LED';
objPP.ProductManufacturer__c = 'Skiers Choice(supra)';
objPP.Year__c ='2016';
objPP.Product_Model__c ='Mondo(MD)';
objPP.Product_Code__c = '864199';
objPP.Sorting_Order__c = 45;
objPP.ProductRetail_Price__c = 100;
objPP.Dealer_Price__c =50;
insert objPP;

BOATBUILDING__Inventory__c objInventory1 = new BOATBUILDING__Inventory__c();
List<RecordType>  lstobjInventory1RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
if(lstobjInventory1RT.size() > 0){
objInventory1.RecordTypeId = lstobjInventory1RT[0].Id;
}


objInventory1.Manufacturer__c = 'Skiers Choice(supra)';
objInventory1.Year__c = '2016';
objInventory1.Model__c = 'Mondo(MD)';
objInventory1.Cost__c =10000;
objInventory1.Part_Number__c = '777';
insert objInventory1;

BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem1 = new BOATBUILDING__Inventory_Line_Item__c();
objInventoryLineItem1.Related_to_Inventory__c = objInventory1 .Id;
objInventoryLineItem1.Option_Category__c = 'Trailer Light Options (9G)';
objInventoryLineItem1.Name = 'Surface Mount Clear LED';
objInventoryLineItem1.Name__c = 'Walk-Thru Screen';
objInventoryLineItem1.Price__c = 500;
objInventoryLineItem1.Dealer_Price__c= 50.00;
objInventoryLineItem1.Product_Code__c = '864199';
objInventoryLineItem1.Quantity__c = 10;
insert objInventoryLineItem1;




ApexPages.currentPage().getParameters().put('invId',objInventory1.id);
BoatBuilderController objBoatBuilderController1 = new BoatBuilderController();
objBoatBuilderController1.selectedModel= objProduct1.Id;

//Pagereference prfc2 = objBoatBuilderController1.callThirdPage();
Pagereference prfc1 = objBoatBuilderController1.getModel();
BOATBUILDING__Manufacturer__c objManufacturer2 = new BOATBUILDING__Manufacturer__c();
objManufacturer2.Manufacturer_name__c = '123456';
objManufacturer2.Name = 'Skiers Choice(Supra)';
objManufacturer2.Model_Variant__c = true;
insert objManufacturer2;
BOATBUILDING__Product__c objProduct2 = new BOATBUILDING__Product__c();
objProduct2.M_Year__c = '2017';
objProduct2.MModel2__c = 'SR';
objProduct2.Product_Manufacturer__c = objManufacturer2.Id;
objProduct2.M_Model_Variant__c = 'SR400';
objProduct2.Cost_Price__c = 40000;
objProduct2.M_Boat_MSRP_PRICE__c = 50000;
objProduct2.M_Dealer_Status__c ='Quoted';
objProduct2.M_Manufacture_Status__c = 'Ordered';
insert objProduct2;

BOATBUILDING__Inventory__c objInventory2 = new BOATBUILDING__Inventory__c();
List<RecordType>  lstobjInventory2RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats'];
if(lstobjInventory2RT.size() > 0){
objInventory2.RecordTypeId = lstobjInventory2RT[0].Id;
}

objInventory2.Manufacturer__c = 'Skiers Choice(Supra)';
objInventory2.Year__c = '2017';
objInventory2.Model__c = 'SR';
objInventory2.Cost__c =10000;
objInventory2.Model_Variant__c = 'SR400';
insert objInventory2;
BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem2 = new BOATBUILDING__Inventory_Line_Item__c();
objInventoryLineItem2.Option_Category__c = 'Trailer Light Options (9G)';
objInventoryLineItem2.Related_to_Inventory__c = objInventory2.Id;
objInventoryLineItem2.Name = 'Bow Cover';
objInventoryLineItem2.Name__c = 'Walk-Thru Screen';
objInventoryLineItem2.Price__c = 500;
objInventoryLineItem2.Dealer_Price__c= 500.0;
objInventoryLineItem2.Quantity__c = 10;
insert objInventoryLineItem2;

String recIdNew1 = [Select Id from RecordType where SobjectType='BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'].Id;
BOATBUILDING__ProductPrice__c objProductPriceForSelectedCategory = new BOATBUILDING__ProductPrice__c();
List<RecordType>  lstobjPPRT3= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'Used Boats'];
if(lstobjPPRT3.size() > 0){
objProductPriceForSelectedCategory.RecordTypeId = lstobjPPRT3[0].Id;
}
objProductPriceForSelectedCategory.Option_Category__c = 'Canvas';
objProductPriceForSelectedCategory.ProductSelected_Category__c = 'Bow Cover';
objProductPriceForSelectedCategory.Product_Code__c = '123456';
objProductPriceForSelectedCategory.ProductRetail_Price__c = 100;
objProductPriceForSelectedCategory.Dealer_Price__c =50;
objProductPriceForSelectedCategory.Sorting_Order__c =50;
insert objProductPriceForSelectedCategory;

ApexPages.currentPage().getParameters().put('invId',objInventory2.id);
BoatBuilderController objBoatBuilderController2 = new BoatBuilderController();



BOATBUILDING__Manufacturer__c objManufacturer3 = new BOATBUILDING__Manufacturer__c();
objManufacturer3.Manufacturer_name__c = '1234567';
objManufacturer3.Name = 'Skiers Choice(Supra)';
objManufacturer3.Model_Variant__c = true;
insert objManufacturer3;
BOATBUILDING__Product__c objProduct3 = new BOATBUILDING__Product__c();
objProduct3.M_Year__c = '2016';
objProduct3.MModel2__c = 'SC';
objProduct2.M_Model_Variant__c = 'SC400';
objProduct3.Product_Manufacturer__c = objManufacturer3.Id;
objProduct3.Cost_Price__c = 40000;
objProduct3.M_Boat_MSRP_PRICE__c = 50000;
objProduct3.M_Dealer_Status__c ='Quoted';
objProduct3.M_Manufacture_Status__c = 'Ordered';
insert objProduct3;
BOATBUILDING__Inventory__c objInventory3 = new BOATBUILDING__Inventory__c();
List<RecordType>  lstobjInventory3RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
if(lstobjInventory3RT.size() > 0){
objInventory3.RecordTypeId = lstobjInventory3RT[0].Id;
}
objInventory3.Manufacturer__c = 'Skiers Choice(Supra)';
objInventory3.Year__c = '2016';
objInventory3.Model__c = 'SC';
objInventory2.Model_Variant__c = 'SC400';
objInventory3.Cost__c =10000;
objInventory3.Part_Number__c ='ABC123';
insert objInventory3;
BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem3 = new BOATBUILDING__Inventory_Line_Item__c();
objInventoryLineItem3.Related_to_Inventory__c = objInventory3.Id;
objInventoryLineItem3.Option_Category__c = 'Canvas';
objInventoryLineItem3.Name = 'Surface Mount Clear LED';
 objInventoryLineItem3.Name__c = 'Walk-Thru Screen';
objInventoryLineItem3.Price__c = 500;
objInventoryLineItem3.Dealer_Price__c = 20.0;
objInventoryLineItem3.Product_Code__c = '864199';
objInventoryLineItem3.Quantity__c = 10;
insert objInventoryLineItem3;
ApexPages.currentPage().getParameters().put('invId',objInventory3.id);
BoatBuilderController objBoatBuilderController3 = new BoatBuilderController();

BOATBUILDING__Manufacturer__c objManuFacturer4 = new BOATBUILDING__Manufacturer__c();
objManuFacturer4.Name = 'Skiers Choice(Moomba)';
objManuFacturer4.Manufacturer_name__c = '123';
objManuFacturer4.Model_Variant__c = false;
insert objManuFacturer4;

BOATBUILDING__Product__c objProduct4 = new BOATBUILDING__Product__c();
objProduct4.Product_Manufacturer__c = objManuFacturer4.Id;
objProduct4.M_Year__c = '2016';  
objProduct4.MModel2__c = 'Hexa'; 
insert objProduct4;

Account objAccount1 = new Account();
objAccount1.Name = 'Test Account';
objAccount1.Email__c = 'test@as.in';
objAccount1.Phone = '12345678';
insert objAccount1;

Contact objContact1 = new Contact();
objContact1.FirstName = 'Test';
objContact1.LastName = 'Contact';
objContact1.AccountId = objAccount1.Id;
objContact1.Email = 'test@360dc.in';
insert objContact1;

/*Order__c objOrder10 = new Order__c();
objOrder10.AcocuntName__c = objAccount1.Id;
objOrder10.ContactName__c = objContact1.Id;
objOrder10.Vendor_Name__c = objManufacturer1.Id ; 

insert objOrder10; */

BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
objQuote1.Name = 'Test';
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
objQuote1.Status__c = 'Draft';
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
insert objQuote1;

BOATBUILDING__Quote_Line_Item__c objQL2= new BOATBUILDING__Quote_Line_Item__c();
objQL2.Name = 'Test QLI';
objQL2.Option_Category__c = 'Trailer Light Options (9G)';
objQL2.Date__c = Date.today();
objQL2.Dealer_Price__c = 2000.0;
objQL2.Sales_Price__c = 2000.0;
objQL2.Total_Price__c = 2000.0;
objQL2.Product_Code__c = '3002256';
objQL2.Product__c = objProduct4.Id;
objQL2.Quote__c = objQuote1.Id;
insert objQL2;

Attachment attach=new Attachment();       
attach.Name='Unit Test Attachment';
Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
attach.body=bodyBlob;
attach.parentId=objQuote1.id;
insert attach;

apexpages.currentpage().getparameters().put('Id' , objQuote1.Id);
BoatBuilderController objBoatBuilderController4 = new BoatBuilderController();
apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
apexpages.currentpage().getparameters().put('strCC' , '');
Pagereference pf = objBoatBuilderController4.saveAndSendQuote();
Pagereference pf7 = objBoatBuilderController4.saveQuoteasPDF();


BOATBUILDING__Manufacturer__c objManufacturer5 = new BOATBUILDING__Manufacturer__c();
objManufacturer5.Manufacturer_name__c = '12345655555';
objManufacturer5.Name = 'Skiers Choice(Supra)';
objManufacturer5.Model_Variant__c = true;
insert objManufacturer5;
BOATBUILDING__Product__c objProduct5 = new BOATBUILDING__Product__c();
objProduct5.M_Year__c = '2017';
objProduct5.MModel2__c = 'SR';
objProduct5.Product_Manufacturer__c = objManufacturer5.Id;
objProduct5.M_Model_Variant__c = 'SR400';
objProduct5.Cost_Price__c = 40000;
objProduct5.M_Boat_MSRP_PRICE__c = 50000;


objProduct5.M_Dealer_Status__c ='Quoted';
objProduct5.M_Manufacture_Status__c = 'Ordered';
insert objProduct5;
BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
List<RecordType>  lstobjInventory5RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
if(lstobjInventory5RT.size() > 0){
objInventory5.RecordTypeId = lstobjInventory5RT[0].Id;
}
objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
objInventory5.Year__c = '2017';
objInventory5.Model__c = 'SR';
objInventory5.Cost__c =10000;
objInventory5.Model_Variant__c = 'SR400';
objInventory5.Engine_SN__c = 'asda232';
objInventory5.Boat_Length_in_feets__c = '22\'54"';
objInventory5.HIN_Number__c = 'asdA234';
objInventory5.Trailer_VIN__c = 'asd2345';
objInventory5.Part_Number__c = 'asd2345';
objInventory5.Transmission_Gearbox_SN__c = '45fsdg';
insert objInventory5;
BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem5 = new BOATBUILDING__Inventory_Line_Item__c();
objInventoryLineItem5.Related_to_Inventory__c = objInventory5.Id;
objInventoryLineItem5.Name = 'Walk-Thru Screen';
objInventoryLineItem5.Name__c = 'Walk-Thru Screen';
objInventoryLineItem5.Option_Category__c = 'Upholstery Options (2G)';
objInventoryLineItem5.Price__c = 500;
objInventoryLineItem5.Dealer_Price__c = 20.0;     
objInventoryLineItem5.Product_Code__c = '817864';
objInventoryLineItem5.Quantity__c = 10;
insert objInventoryLineItem5;
Order__c objOrder1 = new Order__c();
objOrder1.ContactName__c = objContact1.Id;
ApexPages.currentPage().getParameters().put('invId',objInventory5.id);
BoatBuilderController objBoatBuilderController5 = new BoatBuilderController();
objBoatBuilderController5.getModel();
Pagereference pf6 = objBoatBuilderController5.getModelVariant();
objBoatBuilderController5.objOrder.ContactName__c = objContact1.Id;
Pagereference pf5 = objBoatBuilderController5.sendQuote();
objInventory5.HIN_Number__c = '';
objInventory5.Hull_ID__c = 'asdA234';
Pagereference pf55 = objBoatBuilderController5.sendQuote();

objBoatBuilderController5 .selectedModelVariant= objProduct5.Id;
Pagereference pf1 = objBoatBuilderController5.callThirdPage();
Pagereference pf2 = objBoatBuilderController5.thirdPageSave();
objBoatBuilderController5.saveAndRecaculate();

Pagereference pf4 = objBoatBuilderController5.placeOrderForInventory();
objBoatBuilderController5.selectedModel= objProduct5.Id;

//Pagereference prfce1 = objBoatBuilderController5.callThirdPage();
Pagereference prfce2 = objBoatBuilderController5.getModel();

BOATBUILDING__Manufacturer__c objManufacturer6 = new BOATBUILDING__Manufacturer__c();
objManufacturer6.Manufacturer_name__c = '12345abc';
objManufacturer6.Name = 'Skiers Choice(Supra)';
objManufacturer6.Model_Variant__c = true;
insert objManufacturer6;


BOATBUILDING__Product__c objProduct6 = new BOATBUILDING__Product__c();
objProduct6.M_Year__c = '2016';
objProduct6.MModel2__c = 'SC';
objProduct6.M_Model_Variant__c = 'SC400';
objProduct6.Product_Manufacturer__c = objManufacturer6.Id;
objProduct6.Cost_Price__c = 40000;
objProduct6.M_Boat_MSRP_PRICE__c = 50000;
objProduct6.M_Dealer_Status__c ='Quoted';
objProduct6.M_Manufacture_Status__c = 'Ordered';
insert objProduct6;


BOATBUILDING__ProductPrice__c objPP6 = new BOATBUILDING__ProductPrice__c();
List<RecordType>  lstobjPP6RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
if(lstobjPP6RT.size() > 0){
objPP6.RecordTypeId = lstobjPP6RT[0].Id;
}

objPP6.Option_Category__c = 'Trailer Wheel Options (9F)';
objPP6.ProductSelected_Category__c = '18" Spare Tire, Framed Side Mount';
objPP6.ProductManufacturer__c = 'Skiers Choice(Supra)';
objPP6.Year__c ='2016';
objPP6.Product_Model__c ='SC';
objPP6.Model_Variant__c = 'SC400';
objPP6.Product_Code__c = '864199';
objPP6.ProductRetail_Price__c = 100;
objPP6.Dealer_Price__c =50;
objPP6.Sorting_Order__c =80;
insert objPP6;

BOATBUILDING__Inventory__c objInventory6 = new BOATBUILDING__Inventory__c();
List<RecordType>  lstobjInventory6RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats' LIMIT 1];
if(lstobjInventory6RT.size() > 0){
objInventory6.RecordTypeId = lstobjInventory6RT[0].Id;
}

objInventory6.Manufacturer__c = 'Skiers Choice(Supra)';
objInventory6.Year__c = '2016';
objInventory6.Model__c = 'SC';
objInventory6.Model_Variant__c = 'SC400';
objInventory6.Part_Number__c = '4000A';
objInventory6.Cost__c =10000;
insert objInventory6;

BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem6 = new BOATBUILDING__Inventory_Line_Item__c();
objInventoryLineItem6.Related_to_Inventory__c = objInventory6 .Id;
objInventoryLineItem6.Option_Category__c = 'Trailer Wheel Options (9F)';
objInventoryLineItem6.Name = '18" Spare Tire, Framed Side Mount';
objInventoryLineItem6.Name__c = 'Walk-Thru Screen';
objInventoryLineItem6.Price__c = 500;
objInventoryLineItem6.Dealer_Price__c = 20.0;     
objInventoryLineItem6.Product_Code__c = '864199';
objInventoryLineItem6.Quantity__c = 10;
insert objInventoryLineItem6;




ApexPages.currentPage().getParameters().put('invId',objInventory6.id);





}
    Public static  testMethod void myUnitTest() {
        
        BOATBUILDING__Manufacturer__c objManufacturer99 = new BOATBUILDING__Manufacturer__c();
        objManufacturer99.Manufacturer_name__c = 'abc55555';
        objManufacturer99.Name = 'Skiers Choice(Supra)';
        objManufacturer99.Model_Variant__c = true;
        insert objManufacturer99;
        
        
        BOATBUILDING__Product__c objProduct99 = new BOATBUILDING__Product__c();
        objProduct99.M_Year__c = '2017';
        objProduct99.MModel2__c = 'SR';
        objProduct99.M_Model_Variant__c = 'SR400';
        objProduct99.Product_Manufacturer__c = objManufacturer99.Id;
        objProduct99.Cost_Price__c = 40000;
        objProduct99.M_Boat_MSRP_PRICE__c = 50000;
        objProduct99.M_Dealer_Status__c ='Quoted';
        objProduct99.M_Manufacture_Status__c = 'Ordered';
        insert objProduct99;
        List<RecordType>  lstRT99= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        BOATBUILDING__ProductPrice__c objPP99 = new BOATBUILDING__ProductPrice__c();
        if(lstRT99.size() > 0){
            objPP99.RecordTypeId = lstRT99[0].Id;
        }
        objPP99.Option_Category__c = 'Package and Trim Level Options (1A)';
        objPP99.ProductSelected_Category__c = 'Trim Level 400';
        objPP99.ProductManufacturer__c = 'Skiers Choice(Supra)';
        objPP99.Year__c ='2017';
        objPP99.Product_Model__c ='SR';
        objPP99.Model_Variant__c = 'SR400';
        objPP99.Product_Code__c = 'ABC123';
        objPP99.ProductRetail_Price__c = 100;
        objPP99.Dealer_Price__c =50;
        objPP99.Sorting_Order__c = 35;
        insert objPP99;
        
        BOATBUILDING__Inventory__c objInventory99 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory99Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory99 = lstInventory99Id.size() > 0 ? lstInventory99Id[0].Id : null;
        if(lstInventory99Id.size() > 0){
            objInventory99.RecordTypeId = lstInventory99Id[0].Id;
        }
        objInventory99.RecordTypeId = recIdInventory99;
        objInventory99.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory99.Year__c = '2017';
        objInventory99.Model__c = 'SR';
        objInventory99.Model_Variant__c = 'SR400';
        objInventory99.Part_Number__c = '99999abcd';
        objInventory99.Cost__c =10000;
        insert objInventory99;
        
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem99 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem99.Related_to_Inventory__c = objInventory99.Id;
        objInventoryLineItem99.Option_Category__c = 'Package and Trim Level Options (1A)';
        objInventoryLineItem99.Name = 'Trim Level 400';
        objInventoryLineItem99.Name__c = 'Trim Level 400';
        objInventoryLineItem99.Price__c = 500;
        objInventoryLineItem99.Dealer_Price__c= 50.00;
        objInventoryLineItem99.Product_Code__c = 'ABC123';
        objInventoryLineItem99.Quantity__c = 10;
        insert objInventoryLineItem99;
        
        BOATBUILDING__Dealer_Option__c objDealerOption99 = new BOATBUILDING__Dealer_Option__c();
        objDealerOption99.Name = '360DC Test';
        objDealerOption99.Cost__c = 100.00;
        objDealerOption99.Part_Number__c = 'ABC123';
        objDealerOption99.Retail_Price__c = 80.00;
        insert objDealerOption99;
        
        ApexPages.currentPage().getParameters().put('invId',objInventory99.id);
        BoatBuilderController objBoatBuilderController99 = new BoatBuilderController();
        objBoatBuilderController99.selectedModel= objProduct99.Id;
        objBoatBuilderController99.dealerPartNumber = 'ABC123';
        objBoatBuilderController99.getDealerOptionPrice();
        objBoatBuilderController99.getDealerOptionPriceSub();
        
        
        BOATBUILDING__Manufacturer__c objManufacturer5 = new BOATBUILDING__Manufacturer__c();
        objManufacturer5.Manufacturer_name__c = '12345655555';
        objManufacturer5.Name = 'Skiers Choice(Supra)';
        objManufacturer5.Model_Variant__c = true;
        insert objManufacturer5;
        BOATBUILDING__Product__c objProduct5 = new BOATBUILDING__Product__c();
        objProduct5.Product_Manufacturer__c = objManufacturer5.Id;     objProduct5.Cost_Price__c = 40000;
        objProduct5.M_Boat_MSRP_PRICE__c = 50000;
        objProduct5.Engine_SN__c = 'AAA111';
        objProduct5.Boat_Length_in_Feets__c = '12';
        objProduct5.Hull_Id__c = 'XYZ';
        objProduct5.Trailer_VIN__c = '123abc';
        
        objProduct5.Part_Number__c  ='a3s5ed4';
        objProduct5.Dealer__c = 'South Indian Water Sport';
        objProduct5.M_Dealer_Base_Price__c = 564.00;
        objProduct5.M_Dealer_Discount__c = 20;
        objProduct5.M_Dealer_COD_Discount__c = 20;
        objProduct5.M_Dealer_Flat_Discount__c = 20;
        objProduct5.M_Dealer_Stock__c = 12;
        objProduct5.M_Dealer_Comments__c = 'asnhajdkl';
        objProduct5.Transmission_Gearbox_SN__c = 'asda131lk'; 
        objProduct5.M_Dealer_Status__c ='Quoted';
        objProduct5.M_Manufacture_Status__c = 'Ordered';
        insert objProduct5;
        
        BOATBUILDING__ProductPrice__c objProductPrice = new BOATBUILDING__ProductPrice__c();
        List<RecordType>  lstRTNew= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        
        BOATBUILDING__ProductPrice__c objProductPrice99 = new BOATBUILDING__ProductPrice__c();
        if(lstRTNew.size() > 0){
            objProductPrice99.RecordTypeId = lstRTNew[0].Id;
        }
        objProductPrice99.Option_Category__c = 'Package and Trim Level Options (1A)';
        objProductPrice99.ProductSelected_Category__c = 'Walk-Thru Screen';
        objProductPrice99.ProductManufacturer__c = 'Skiers Choice(Supra)';
        objProductPrice99.Year__c ='2017';
        objProductPrice99.Product_Model__c ='SR';
        objProductPrice99.Model_Variant__c = 'SR400';
        objProductPrice99.Product_Code__c = '817864';
        objProductPrice99.ProductRetail_Price__c = 100;
        objProductPrice99.Dealer_Price__c =50;
        objProductPrice99.Sorting_Order__c = 35;
        insert objProductPrice99;
        
        Item__c objItem5 = new Item__c();
        
        
        List<RecordType>  lstInventory5Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats'];
        BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
        if(lstInventory5Id.size() > 0){
            objInventory5.RecordTypeId = lstInventory5Id[0].Id;
        }
        objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory5.Year__c = '2017';
        objInventory5.Model__c = 'SR';
        objInventory5.Cost__c =10000;
        objInventory5.Model_Variant__c = 'SR400';
        objInventory5.Part_Number__c = 'ABC400';
        objInventory5.Engine_SN__c = '12345';
        objInventory5.Boat_Length_in_feets__c = '12';
        objInventory5.HIN_Number__c = 'ABC12';
        objInventory5.Trailer_VIN__c = 'xyz';
        insert objInventory5;
        
        
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem5 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem5.Name = 'Walk-Thru Screen';
        objInventoryLineItem5.Name__c = 'Walk-Thru Screen';
        objInventoryLineItem5.Option_Category__c = 'Package and Trim Level Options (1A)';
        objInventoryLineItem5.Price__c = 500;
        objInventoryLineItem5.Dealer_Price__c = 20.0;     
        objInventoryLineItem5.Product_Code__c = '817864';
        objInventoryLineItem5.Quantity__c = 10;
        ApexPages.currentPage().getParameters().put('invId',objInventory5.id);
        BoatBuilderController objBoatBuilderController5 = new BoatBuilderController();
        objBoatBuilderController5.getModel();
        Pagereference pf6 = objBoatBuilderController5.getModelVariant();
        
        objBoatBuilderController5.objItem = objItem5;
        objBoatBuilderController5 .selectedModelVariant= objProduct5.Id;
        Pagereference pf1 = objBoatBuilderController5.callThirdPage();
        Pagereference pf2 = objBoatBuilderController5.thirdPageSave();
        objBoatBuilderController5.rowNumber = '1';
        objBoatBuilderController5.saveAndRecaculate();
        
        objBoatBuilderController5.lstInventoryLineItem.add(objInventoryLineItem5);
        Pagereference pf4 = objBoatBuilderController5.placeOrderForInventory();
        Pagereference pf5 = objBoatBuilderController5.sendQuote();
        objBoatBuilderController5.selectedModel= objProduct5.Id;
        
        Pagereference prfce1 = objBoatBuilderController5.callThirdPage();
        Pagereference prfce2 = objBoatBuilderController5.getModel();
        
        
        BOATBUILDING__Manufacturer__c objManuFacturer4 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer4.Name = 'Skiers Choice(Moomba)';
        objManuFacturer4.Manufacturer_name__c = '123';
        objManuFacturer4.Model_Variant__c = false;
        insert objManuFacturer4;
        
        BOATBUILDING__Product__c objProduct4 = new BOATBUILDING__Product__c();
        objProduct4.Product_Manufacturer__c = objManuFacturer4.Id;
        objProduct4.M_Year__c = '2016';  
        objProduct4.MModel2__c = 'Hexa'; 
        insert objProduct4;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'Test Account';
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'Test';
        objContact1.LastName = 'Contact';
        objContact1.AccountId = objAccount1.Id;
        objContact1.Email = 'test@360dc.in';
        insert objContact1;
        /*
Order__c objOrder1 = new Order__c();
objOrder1.AcocuntName__c = objAccount1.Id;
objOrder1.ContactName__c = objContact1.Id;
insert objOrder1;
*/
        BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
        objQuote1.Name = 'Test';
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
        objQuote1.Status__c = 'Draft';
        objQuote1.Related_to_Product__c = objProduct4.Id;
        
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
        insert objQuote1;
        
        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
        objQLI.Name = 'Test QLI';
        objQLI.Option_Category__c = 'Trailer Light Options (9G)';
        objQLI.Date__c = Date.today();
        objQLI.Dealer_Price__c = 2000.0;
        objQLI.Sales_Price__c = 2000.0;
        objQLI.Total_Price__c = 2000.0;
        objQLI.Product_Code__c = '3002256';
        objQLI.Product__c = objProduct4.Id;
        objQLI.Quote__c = objQuote1.Id;
        insert objQLI;
        
        
        BOATBUILDING__Quote_Line_Item__c objQL2= new BOATBUILDING__Quote_Line_Item__c();
        objQL2.Name = 'Test QLI';
        objQL2.Option_Category__c = 'Trailer Light Options (9G)';
        objQL2.Date__c = Date.today();
        objQL2.Dealer_Price__c = 2000.0;
        objQL2.Sales_Price__c = 2000.0;
        objQL2.Total_Price__c = 2000.0;
        objQL2.Product_Code__c = '3002256';
        objQL2.Product__c = objProduct4.Id;
        objQL2.Quote__c = objQuote1.Id;
        insert objQL2;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objQuote1.id;
        insert attach;
        
        apexpages.currentpage().getparameters().put('Id' , objQuote1.Id);
        BoatBuilderController objBoatBuilderController4 = new BoatBuilderController();
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        Pagereference pf = objBoatBuilderController4.saveAndSendQuote();
        Pagereference pf7 = objBoatBuilderController4.saveQuoteasPDF();
        objBoatBuilderController4.rowNumber = '1';
        
        objQuote1.Test_2__c = objInventory5.Id;
        apexpages.currentpage().getparameters().put('quoteId' , objQuote1.Id);
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        BoatBuilderController objBoatBuilderController4444 = new BoatBuilderController();
        Pagereference pf8 = objBoatBuilderController4.saveAndSendQuote();
        Pagereference pf7777 = objBoatBuilderController4444.saveQuoteasPDF();
        objBoatBuilderController4444.rowNumber = '1';
    }
    
    Public static  testMethod void myUnitTest2(){
        BOATBUILDING__Manufacturer__c objManuFacturer4 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer4.Name = 'Skiers Choice(Moomba)';
        objManuFacturer4.Manufacturer_name__c = '123';
        objManuFacturer4.Model_Variant__c = false;
        insert objManuFacturer4;
        
        BOATBUILDING__Product__c objProduct4 = new BOATBUILDING__Product__c();
        objProduct4.Product_Manufacturer__c = objManuFacturer4.Id;
        objProduct4.M_Year__c = '2016';  
        objProduct4.MModel2__c = 'Hexa'; 
        insert objProduct4;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'Test Account';
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'Test';
        objContact1.LastName = 'Contact';
        objContact1.Email =  'test@360dc.in';
        insert objContact1;
        /*
Order__c objOrder1 = new Order__c();
objOrder1.AcocuntName__c = objAccount1.Id;
objOrder1.ContactName__c = objContact1.Id;
insert objOrder1;
*/
        
        BOATBUILDING__Inventory__c objInventory99 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstInventory99Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        String recIdInventory99 = lstInventory99Id.size() > 0 ? lstInventory99Id[0].Id : null;
        if(lstInventory99Id.size() > 0){
            objInventory99.RecordTypeId = lstInventory99Id[0].Id;
        }
        objInventory99.RecordTypeId = recIdInventory99;
        objInventory99.Manufacturer__c = 'Skiers Choice(Moomba)';
        objInventory99.Year__c = '2016';
        objInventory99.Model__c = 'Hexa';
        objInventory99.Part_Number__c = '99999abcd';
        objInventory99.Cost__c =10000;
        insert objInventory99;
        
        BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
        objQuote1.Name = 'Test';
        objQuote1.Account_Name__c = objAccount1.Id;
        objQuote1.Contact_Name__c = objContact1.Id;
        objQuote1.Additional_To__c = 'test';
        objQuote1.Additional_To_Name__c = 'test';
        objQuote1.Bill_To_Name__c = 'test';
        objQuote1.Description__c = 'test';
        objQuote1.Discount__c = 20.0;
        objQuote1.Test_2__c = objInventory99.Id;
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
        objQuote1.Status__c = 'Draft';
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
        insert objQuote1;
        
        BOATBUILDING__Quote_Line_Item__c objQLI = new BOATBUILDING__Quote_Line_Item__c();
        objQLI.Name = 'Test QLI';
        objQLI.Option_Category__c = 'Trailer Light Options (9G)';
        objQLI.Date__c = Date.today();
        objQLI.Dealer_Price__c = 2000.0;
        objQLI.Sales_Price__c = 2000.0;
        objQLI.Total_Price__c = 2000.0;
        objQLI.Product_Code__c = '3002256';
        objQLI.Product__c = objProduct4.Id;
        objQLI.Quote__c = objQuote1.Id;
        insert objQLI;
        
        
        BOATBUILDING__Quote_Line_Item__c objQL2= new BOATBUILDING__Quote_Line_Item__c();
        objQL2.Name = 'Test QLI';
        objQL2.Option_Category__c = 'Trailer Light Options (9G)';
        objQL2.Date__c = Date.today();
        objQL2.Dealer_Price__c = 2000.0;
        objQL2.Sales_Price__c = 2000.0;
        objQL2.Total_Price__c = 2000.0;
        objQL2.Product_Code__c = '3002256';
        objQL2.Product__c = objProduct4.Id;
        objQL2.Quote__c = objQuote1.Id;
        insert objQL2;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objQuote1.id;
        insert attach;
        
        apexpages.currentpage().getparameters().put('Id' , objQuote1.Id);
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        BoatBuilderController objBoatBuilderController4 = new BoatBuilderController();
        Pagereference pf = objBoatBuilderController4.saveAndSendQuote();
        Pagereference pf7 = objBoatBuilderController4.saveQuoteasPDF();
        objBoatBuilderController4.rowNumber = '1';
        objBoatBuilderController4.selectedYear = '2016';
        objBoatBuilderController4.selectedManufacture =objManuFacturer4.Id;
        Pagereference pf88 = objBoatBuilderController4.getModel();
        Pagereference pf8 = objBoatBuilderController4.getModelVariant();
        Pagereference pf999 = objBoatBuilderController4.getYearAndModel();
    }
    
    
    Public static  testMethod void MyUnitTest99()
    { 
        
        BOATBUILDING__Manufacturer__c objManufacturer3 = new BOATBUILDING__Manufacturer__c();
        objManufacturer3.Manufacturer_name__c = '1234567';
        objManufacturer3.Name = 'Skiers Choice(Supra)';
        objManufacturer3.Model_Variant__c = true;
        insert objManufacturer3;
        BOATBUILDING__Product__c objProduct3 = new BOATBUILDING__Product__c();
        objProduct3.M_Year__c = '2016';
        objProduct3.MModel2__c = 'SC';
        objProduct3.M_Manufacture_Status__c = 'Pre production';
        objProduct3.M_Dealer_Status__c = 'Quoted'; 
        objProduct3.M_Model_Variant__c = 'SC400';
        objProduct3.Product_Manufacturer__c = objManufacturer3.Id;
        objProduct3.Cost_Price__c = 40000;
        objProduct3.M_Boat_MSRP_PRICE__c = 50000;
        objProduct3.M_Dealer_Status__c ='Quoted';
        objProduct3.M_Manufacture_Status__c = 'Ordered';
        insert objProduct3;
        BOATBUILDING__Inventory__c objInventory3 = new BOATBUILDING__Inventory__c();
        List<RecordType>  lstobjInventory3RT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'New Boats'];
        if(lstobjInventory3RT.size() > 0){
            objInventory3.RecordTypeId = lstobjInventory3RT[0].Id;
        }
        objInventory3.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory3.Year__c = '2016';
        objInventory3.Model__c = 'SC';
        objInventory3.Model_Variant__c = 'SC400';
        objInventory3.Cost__c =10000;
        objInventory3.Part_Number__c ='ABC123';
        insert objInventory3;
        BOATBUILDING__Inventory_Line_Item__c objInventoryLineItem3 = new BOATBUILDING__Inventory_Line_Item__c();
        objInventoryLineItem3.Related_to_Inventory__c = objInventory3.Id;
        objInventoryLineItem3.Option_Category__c = 'Canvas';
        objInventoryLineItem3.Name = 'Surface Mount Clear LED';
        objInventoryLineItem3.Name__c = 'Surface Mount Clear LED';
        objInventoryLineItem3.Price__c = 500;
        objInventoryLineItem3.Dealer_Price__c = 20.0;
        objInventoryLineItem3.Product_Code__c = '864199';
        objInventoryLineItem3.Quantity__c = 10;
        insert objInventoryLineItem3;
        ApexPages.currentPage().getParameters().put('invId',objInventory3.id);
        BoatBuilderController objBoatBuilderController3 = new BoatBuilderController();
        
        BOATBUILDING__Manufacturer__c objManuFacturer4 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer4.Name = 'Skiers Choice(Moomba)';
        objManuFacturer4.Manufacturer_name__c = '123';
        objManuFacturer4.Model_Variant__c = false;
        insert objManuFacturer4;
        
        BOATBUILDING__Product__c objProduct4 = new BOATBUILDING__Product__c();
        objProduct4.Product_Manufacturer__c = objManuFacturer4.Id;
        objProduct4.M_Year__c = '2016';  
        objProduct4.MModel2__c = 'Hexa';
        objProduct4.M_Manufacture_Status__c = 'Pre production'; 
        objProduct4.M_Dealer_Status__c = 'Quoted'; 
        objProduct4.M_Boat_MSRP_PRICE__c = 1000;
        insert objProduct4;
        
        List<RecordType>  lstRT= [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__ProductPrice__c' AND Name = 'New Boats'];
        
        
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        if(lstRT.size() > 0){
            objPP.RecordTypeId = lstRT[0].Id;
        }
        objPP.Option_Category__c = 'Trailer Light Options (9G)';
        objPP.ProductSelected_Category__c = 'Surface Mount Clear LED';
        objPP.ProductManufacturer__c = 'Skiers Choice(Moomba)';
        objPP.Year__c ='2016';
        objPP.Product_Model__c ='Mondo(MD)';
        objPP.Product_Code__c = 'ABC123';
        objPP.ProductRetail_Price__c = 100;
        objPP.Dealer_Price__c =50;
        objPP.Sorting_Order__c = 35;
        insert objPP;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'Test Account';
        objAccount1.Email__c = 'test@as.in';
        objAccount1.Phone = '12345678';
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.FirstName = 'Test';
        objContact1.LastName = 'Contact';
        objContact1.AccountId = objAccount1.Id;
        objContact1.Email  = 'test@360dc.in';
        insert objContact1;
        /*
Order__c objOrder1 = new Order__c();
objOrder1.AcocuntName__c = objAccount1.Id;
objOrder1.ContactName__c = objContact1.Id;
insert objOrder1;
*/
        BOATBUILDING__Quote__c objQuote1 = new BOATBUILDING__Quote__c();
        objQuote1.Name = 'Test';
        objQuote1.Account_Name__c = objAccount1.Id;
        objQuote1.Contact_Name__c = objContact1.Id;
        objQuote1.Additional_To__c = 'test';
        objQuote1.Additional_To_Name__c = 'test';
        objQuote1.Related_to_Product__c = objProduct4.Id;
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
        objQuote1.Status__c = 'Draft';
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
        objQuote1.Test_2__c = objInventory3.Id;
        insert objQuote1;
        
        BOATBUILDING__Quote_Line_Item__c objQL2= new BOATBUILDING__Quote_Line_Item__c();
        objQL2.Name = 'Surface Mount Clear LED';
        objQL2.Option_Category__c = 'Trailer Light Options (9G)';
        objQL2.Date__c = Date.today();
        objQL2.Dealer_Price__c = 2000.0;
        objQL2.Sales_Price__c = 2000.0;
        objQL2.Total_Price__c = 2000.0;
        objQL2.Product_Code__c = '3002256';
        //objQL2.Product__c = objProduct4.Id;
        objQL2.Quote__c = objQuote1.Id;
        insert objQL2;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objQuote1.id;
        insert attach;
        
        apexpages.currentpage().getparameters().put('quoteId' , objQuote1.Id);
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        BoatBuilderController objBoatBuilderController4 = new BoatBuilderController();
        //Pagereference pf = objBoatBuilderController4.saveAndSendQuote();
        Pagereference pf7 = objBoatBuilderController4.saveQuoteasPDF();
        
        objQuote1.Related_to_Product__c = objProduct3.Id;
        update objQuote1;
        apexpages.currentpage().getparameters().put('quoteId' , objQuote1.Id);
        apexpages.currentpage().getparameters().put('strSubject' , 'Test Case');
        apexpages.currentpage().getparameters().put('strBody' , 'Sample Body');
        apexpages.currentpage().getparameters().put('strCC' , '');
        BoatBuilderController objBoatBuilderController5 = new BoatBuilderController();
        //Pagereference pf1 = objBoatBuilderController5.saveAndSendQuote();
        Pagereference pf2 = objBoatBuilderController5.saveQuoteasPDF();
        
        List<RecordType>  lstInventory5Id = [Select Id FROM RecordType where sObjectType = 'BOATBUILDING__Inventory__c' AND Name = 'Used Boats'];
        BOATBUILDING__Inventory__c objInventory5 = new BOATBUILDING__Inventory__c();
        if(lstInventory5Id.size() > 0){
            objInventory5.RecordTypeId = lstInventory5Id[0].Id;
        }
        objInventory5.Manufacturer__c = 'Skiers Choice(Supra)';
        objInventory5.Year__c = '2017';
        objInventory5.Model__c = 'SR';
        objInventory5.Cost__c =10000;
        objInventory5.Model_Variant__c = 'SR400';
        objInventory5.Part_Number__c = 'ABC400';
        objInventory5.Engine_SN__c = '12345';
        objInventory5.Boat_Length_in_feets__c = '12';
        objInventory5.HIN_Number__c = 'ABC12';
        objInventory5.Trailer_VIN__c = 'xyz';
        insert objInventory5;
        
        BOATBUILDING__Quote__c objQuote11 = new BOATBUILDING__Quote__c();
        objQuote11.Name = 'Test';
        objQuote11.Account_Name__c = objAccount1.Id;
        objQuote11.Contact_Name__c = objContact1.Id;
        objQuote11.Additional_To__c = 'test';
        objQuote11.Additional_To_Name__c = 'test';
        objQuote11.Related_to_Product__c = objProduct4.Id;
        objQuote11.Bill_To_Name__c = 'test';
        objQuote11.Description__c = 'test';
        objQuote11.Discount__c = 20.0;
        objQuote11.Fax__c = '21354456';
        objQuote11.Email__c  = 'test@360dc.in';
        objQuote11.State__c = 'North Carolina';
        objQuote11.Phone__c = '123456789';
        objQuote11.Quote_Sale_Price__c = 0.00;
        objQuote11.Total_Price_Quote__c = 50000.00;
        objQuote11.Quote_MSRP_Boat_Price__c = 4000.00;
        objQuote11.Quote_MSRP_Trailer_Price__c = 5200.00;
        objQuote11.Quote_Cost__c = 6500.00;
        objQuote11.Quote_Term__c = '5 Years';
        objQuote11.Bill_To__c = 'abc';
        objQuote11.Grand_Total__c = 5000.00;
        objQuote11.Quote_To_Address__c = 'test';
        objQuote11.Quote_To_Name__c = 'test';
        objQuote11.Shipping_And_Handling__c = 200.00; 
        objQuote11.Ship_To__c = 'test';
        objQuote11.Status__c = 'Draft';
        objQuote11.Tax__c = 30.00;
        objQuote11.Syncing__c = true;
        objQuote11.Quote_Sale_Price__c = 5000.00;
        objQuote11.Ship_To_Name__c = 'test';
        objQuote11.Quote_Rate__c = 20.00;
        objQuote11.Quote_Trade_Allowance__c = 2.22;
        objQuote11.Quote_Trailer_Allowance__c = 40.22;
        objQuote11.Discount_On_Quote__c = 20.22;
        objQuote11.Quote_Trailer_ACV__c = 222.00;
        objQuote11.Quote_Trailer_Sales_Tax__c = 235.00;
        objQuote11.Quote_Boat_Reg_Fee__c = 215.235;
        objQuote11.Quote_Trailer_Reg_Fee__c = 13243.12;
        objQuote11.Quote_Doc_Fee__c = 909.9;
        objQuote11.Negotiation_Trade_Payoff__c = 165.2;
        objQuote11.Quote_Down_Payment__c = 980.87;
        objQuote11.Quote_Cost__c = 12.21;
        objQuote11.Quote_Deal_Margin__c = 987.87;
        objQuote11.Test_2__c = objInventory5.Id;
        insert objQuote11;
        
        BOATBUILDING__Quote_Line_Item__c objQL22= new BOATBUILDING__Quote_Line_Item__c();
        objQL22.Name = 'Surface Mount Clear LED';
        objQL22.Option_Category__c = 'Trailer Light Options (9G)';
        objQL22.Date__c = Date.today();
        objQL22.Dealer_Price__c = 2000.0;
        objQL22.Sales_Price__c = 2000.0;
        objQL22.Total_Price__c = 2000.0;
        objQL22.Product_Code__c = '3002256';
        //objQL2.Product__c = objProduct4.Id;
        objQL22.Quote__c = objQuote11.Id;
        insert objQL22;
        BOATBUILDING__Dealer_Option__c objD = new BOATBUILDING__Dealer_Option__c();
        objD.Name = 'test';
        objD.BOATBUILDING__Part_Number__c = 'testp';
        insert objD;
        objBoatBuilderController5.updateDealerOptionList();
        objBoatBuilderController5.getDeleteDealerOptionPriceSub();
        objBoatBuilderController5.changeCoBuyer();
        objBoatBuilderController5.showpopup1();
        objBoatBuilderController5.changeCustomer();
        objBoatBuilderController5.saveProduct();
        objBoatBuilderController5.getExistManuDetail();
        objBoatBuilderController5.getMFGPrice();
        //objBoatBuilderController5.getMFGPriceSubtrct();
    }
}