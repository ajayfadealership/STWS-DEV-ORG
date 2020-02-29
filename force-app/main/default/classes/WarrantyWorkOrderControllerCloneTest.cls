@istest
public class WarrantyWorkOrderControllerCloneTest 
{
    static testMethod void UnitTest()
    {
        WarrantyWorkOrderControllerClone objTest1 = new WarrantyWorkOrderControllerClone();
        objTest1.getWarrantyWorkOrderList();
        
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        
        //objJob.Work_Request__c = objCase.Id;
        //objJob.Work_Requested__c = 'Oil Change';
        objJob.Job_Name__c = 'Internal';
        objJob.Work_Type__c = 'Internal';
        objJob.Type__c = 'Lake Call';
        Test.startTest();
        insert objJob;
        Test.stopTest();
        
        List<BOATBUILDING__Work_Order_Job__c> lstJob = new  List<BOATBUILDING__Work_Order_Job__c>();
        lstJob.add(objJob); 
        
        
        BOATBUILDING__Service_Module_Tax_Rates__c objSMTR = new BOATBUILDING__Service_Module_Tax_Rates__c();
        objSMTR.Name = 'New York';
        objSMTR.Tax__c = 5.55;
        insert objSMTR;
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.Email = 'test@360dc.com';
        objContact.MailingStreet = 'Street';
        objContact.MailingCity = 'City';
        objContact.MailingState = 'New York';
        objContact.MailingCountry = 'US';
        objContact.MailingPostalCode = '202020';
        insert objContact; 
        
        WarrantyWorkOrderControllerClone objWWOC = new WarrantyWorkOrderControllerClone();
        WarrantyWorkOrderControllerClone.getContact(String.valueOf(objContact.Id));
        
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Name = 'Skiers Choice(Moomba)';
        objManufacturer.Manufacturer_name__c = '1234';
        List<RecordType> lstRecManu = [Select Id From RecordType Where Name = 'Boat Manufacturer' And SobjectType = 'BOATBUILDING__Manufacturer__c'];
        if(lstRecManu.size() > 0) {
            objManufacturer.RecordTypeId = lstRecManu[0].Id;
        }
        insert objManufacturer;
        
         BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'SSS';
        objManuFacturer1.Manufacturer_name__c = '12345';
        List<RecordType> lstRecManuVen = [Select Id From RecordType Where Name = 'Vendor' And SobjectType = 'BOATBUILDING__Manufacturer__c'];
        if(lstRecManuVen.size() > 0) {
            objManuFacturer1.RecordTypeId = lstRecManuVen[0].Id;
        }
        insert objManuFacturer1;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Contact__c = objContact.Id;
        objItem.Boat_HIN_No__c = '12321456';
        objItem.Engine_SN__c = 'dfs456s46s'; 
        objItem.Trailer_VIN__c = '456dfs46df';
        objItem.Boat_Manufacturer__c = objManufacturer.Id;
        objItem.Boat_Model__c = 'Test Model';
        objItem.M_Boat_Year__c = '2017';
        insert objItem;
        
        WarrantyWorkOrderControllerClone.fetchItemsWo(String.valueOf(objItem.Id));
        
       
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.Part_Name__c = 'Test Part';
        objInventory.Part_Number__c = 'lstString';
        objInventory.Vendor__c = objManuFacturer1.Id;
        List<RecordType> lstRecInv = [Select Id From RecordType Where Name = 'Inventory for Parts' And SobjectType = 'BOATBUILDING__Inventory__c'];
        if(lstRecInv.size() > 0) {
            objInventory.RecordTypeId = lstRecInv[0].Id;
        }
        insert objInventory;
        
        
        BOATBUILDING__Work_Order_Job_Line_Item__c objJLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
        objJLI.Quantity__c = 5;
        objJLI.Related_to_Job__c = objJob.Id;
        objJLI.Price__c = 5000;
        objJLI.Select_Part__c = objInventory.Id;
        insert objJLI;
        
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
        lstJLI.add(objJLI) ;
        
        BOATBUILDING__Work_Order__c objwo = new BOATBUILDING__Work_Order__c();
        objwo.BOATBUILDING__Account__c= objAcc.Id;
        objwo.BOATBUILDING__Drive__c='Test';
        objwo.BOATBUILDING__Hours__c='12';
        objwo.BOATBUILDING__Contact__c=objContact.Id;
        objwo.BOATBUILDING__Status__c='Open';
        insert objwo;
        WarrantyWorkOrderControllerClone.PopulatePartNumber();
        WarrantyWorkOrderControllerClone.getDetailsOfJob(String.valueOf(objJob.Id));
        String strRecJSON = '[{"Contact_Id":"'+objContact.Id+'","boatId":"'+objItem.Id+'","Drive":"Drive","Hours":"Hrs","Status":"New","WOCaseId":"'+objwo.Id+'","SalesTax":"7.25","Job_item":[{"ExistingJobId":"","Id":"0c4f766d770b376e4d8c","WorkRequested":"Test WR","WorkType":"Internal","Type":"Lake","Line_item_count":"2","line_items":[{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000RVM2UAO","PartQuantity":"2","PartPrice":"1000"},{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000R5XVUA0","PartQuantity":"1","PartPrice":"10000"}],"Labour_Quantity":"1","Labour_Price":"5000","WWOMISCChrge":"5000","WWOMISCChrge2":"5000","WWOMISCChrge3":"5000","Shop_Price":"2000","Customer_Pay":"1000","Claim_Status":"Approved","Claim_Date":"2017-02-02","Claim_Approval_Date":"2017-02-03","Claim_Approved_Amo":"5000","Return_Part_Amount":"2000","Claim_Paid_Date":"2017-12-31","Claim_Labor_Paid_Amount":"4000","Parts_Paid_Amount":"5000","Total_Paid":"9000.00","WWOBalance_Due":"10000.00","WWOMISCChrgep":"10000.00","WWOMISCChrge":"10000.00"}]}]';
        WarrantyWorkOrderControllerClone.createWarrantyWorkOrder(strRecJSON);
        
        String strRecJSON1 = '[{"Contact_Id":"'+objContact.Id+'","boatId":"'+objItem.Id+'","Drive":"Drive","Hours":"Hrs","Status":"New","SalesTax":"7.25","Job_item":[{"ExistingJobId":"'+String.valueOf(objJob.Id)+'","Id":"0c4f766d770b376e4d8c","WorkRequested":"Test WR","WorkType":"Internal","Type":"Lake","Line_item_count":"2","line_items":[{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000RVM2UAO","PartQuantity":"2","PartPrice":"1000"},{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000R5XVUA0","PartQuantity":"1","PartPrice":"10000"}],"Labour_Quantity":"1","Labour_Price":"5000","WWOMISCChrge":"5000","WWOMISCChrge2":"5000","WWOMISCChrge3":"5000","Shop_Price":"2000","Customer_Pay":"1000","Claim_Status":"Approved","Claim_Date":"2017-02-02","Claim_Approval_Date":"2017-02-03","Claim_Approved_Amo":"5000","Return_Part_Amount":"2000","Claim_Paid_Date":"2017-12-31","Claim_Labor_Paid_Amount":"4000","Parts_Paid_Amount":"5000","Total_Paid":"9000.00","WWOBalance_Due":"10000.00","WWOMISCChrgep":"10000.00","WWOMISCChrge":"10000.00"}]}]';
        WarrantyWorkOrderControllerClone.createWarrantyWorkOrder(strRecJSON1);
        WarrantyWorkOrderControllerClone.getClaimStatus();
        
        BOATBUILDING__WorkTypePricing__c objPri = new BOATBUILDING__WorkTypePricing__c(); 
        objPri.Name='Test Price';
        objPri.BOATBUILDING__Price__c=8000;
        insert objPri;
        List<BOATBUILDING__WorkTypePricing__c> lstPri = new  List<BOATBUILDING__WorkTypePricing__c>();
        lstPri.add(objPri);
        WarrantyWorkOrderControllerClone.fetchWorkTypePricingDetails();
        WarrantyWorkOrderControllerClone.updatePartFromEditableMode(objJLI.Id,'6'); 
        WarrantyWorkOrderControllerClone.removeExistingElement(objJLI.Id);
        List<String> lstString= new List<String>();
        lstString.add('TestString');
        Map<String, String> objMap = new Map<String, String>();
        String str = 'Test23';
        WarrantyWorkOrderControllerClone.getFinalList(lstString, objMap, str);
        
        List<BOATBUILDING__Inventory__c> lstInv = new List<BOATBUILDING__Inventory__c>();
        lstInv.add(objInventory);
        
       
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.BOATBUILDING__Part_Number__c='prtDetail';
        objPart.Name='Vendor';
        objPart.BOATBUILDING__Vendor_Name__c= objManufacturer1.Id;
        insert  objPart;
        
        List<BOATBUILDING__Part__c> lstPart = new List<BOATBUILDING__Part__c>();
        lstPart.add(objPart);
        //BOATBUILDING__Part__c objPart2 = new BOATBUILDING__Part__c();
        //objPart2.BOATBUILDING__Part_Number__c='prtDetail';
        //objPart2.Name='prtDetail';
        //insert  objPart2;
        List<BOATBUILDING__Work_Order_Job__c> lstWOJ= new List<BOATBUILDING__Work_Order_Job__c>(); 
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c(); 
        objWOJ.BOATBUILDING__Unique_Job_id__c= 'vh';
        insert objWOJ;
        List<BOATBUILDING__Work_Order_Job__c> lstWo= new  List<BOATBUILDING__Work_Order_Job__c>();
        lstWo.add(objWOJ);
    }
    static testMethod void UnitTest1()
    {
        WarrantyWorkOrderControllerClone objTest1 = new WarrantyWorkOrderControllerClone();
        objTest1.getWarrantyWorkOrderList();
        
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        
        //objJob.Work_Request__c = objCase.Id;
        //objJob.Work_Requested__c = 'Oil Change';
        objJob.Job_Name__c = 'Internal';
        objJob.Work_Type__c = 'Internal';
        objJob.Type__c = 'Lake Call';
        Test.startTest();
        insert objJob;
        Test.stopTest();
        
        List<BOATBUILDING__Work_Order_Job__c> lstJob = new  List<BOATBUILDING__Work_Order_Job__c>();
        lstJob.add(objJob); 
        
        BOATBUILDING__Service_Module_Tax_Rates__c objSMTR = new BOATBUILDING__Service_Module_Tax_Rates__c();
        objSMTR.Name = 'New York';
        objSMTR.Tax__c = 5.55;
        insert objSMTR;
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.Email = 'test@360dc.com';
        objContact.MailingStreet = 'Street';
        objContact.MailingCity = 'City';
        objContact.MailingState = 'New York';
        objContact.MailingCountry = 'US';
        objContact.MailingPostalCode = '202020';
        insert objContact; 
        
        WarrantyWorkOrderControllerClone objWWOC = new WarrantyWorkOrderControllerClone();
        WarrantyWorkOrderControllerClone.getContact(String.valueOf(objContact.Id));
        
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Name = 'Skiers Choice(Moomba)';
        objManufacturer.Manufacturer_name__c = '1234';
        List<RecordType> lstRecManu = [Select Id From RecordType Where Name = 'Boat Manufacturer' And SobjectType = 'BOATBUILDING__Manufacturer__c'];
        if(lstRecManu.size() > 0) {
            objManufacturer.RecordTypeId = lstRecManu[0].Id;
        }
        insert objManufacturer;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Contact__c = objContact.Id;
        objItem.Boat_HIN_No__c = '12321456';
        objItem.Engine_SN__c = 'dfs456s46s'; 
        objItem.Trailer_VIN__c = '456dfs46df';
        objItem.Boat_Manufacturer__c = objManufacturer.Id;
        objItem.Boat_Model__c = 'Test Model';
        objItem.M_Boat_Year__c = '2017';
        insert objItem;
        
        WarrantyWorkOrderControllerClone.fetchItemsWo(String.valueOf(objItem.Id));
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'SSS';
        objManuFacturer1.Manufacturer_name__c = '12345';
        List<RecordType> lstRecManuVen = [Select Id From RecordType Where Name = 'Vendor' And SobjectType = 'BOATBUILDING__Manufacturer__c'];
        if(lstRecManuVen.size() > 0) {
            objManuFacturer1.RecordTypeId = lstRecManuVen[0].Id;
        }
        insert objManuFacturer1;
        
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.Part_Name__c = 'Test Part';
        objInventory.Part_Number__c = '1213158';
        objInventory.Vendor__c = objManuFacturer1.Id;
        List<RecordType> lstRecInv = [Select Id From RecordType Where Name = 'Inventory for Parts' And SobjectType = 'BOATBUILDING__Inventory__c'];
        if(lstRecInv.size() > 0) {
            objInventory.RecordTypeId = lstRecInv[0].Id;
        }
        insert objInventory;
        
        BOATBUILDING__Work_Order_Job_Line_Item__c objJLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
        objJLI.Quantity__c = 5;
        objJLI.Related_to_Job__c = objJob.Id;
        objJLI.Price__c = 5000;
        objJLI.Select_Part__c = objInventory.Id;
        insert objJLI;
        
        List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstJLI = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>();
        lstJLI.add(objJLI) ;
        
        BOATBUILDING__Work_Order__c objwo = new BOATBUILDING__Work_Order__c();
        objwo.BOATBUILDING__Account__c= objAcc.Id;
        objwo.BOATBUILDING__Drive__c='Test';
        objwo.BOATBUILDING__Hours__c='12';
        objwo.BOATBUILDING__Contact__c=objContact.Id;
        objwo.BOATBUILDING__Status__c='Open';
        insert objwo;
        WarrantyWorkOrderControllerClone.PopulatePartNumber();
        WarrantyWorkOrderControllerClone.getDetailsOfJob(String.valueOf(objJob.Id));
        String strRecJSON = '[{"Contact_Id":"'+objContact.Id+'","boatId":"'+objItem.Id+'","Drive":"Drive","Hours":"Hrs","Status":"New","WOCaseId":"'+objwo.Id+'","SalesTax":"7.25","Job_item":[{"ExistingJobId":"'+String.valueOf(lstJob[0].Id)+'","Id":"0c4f766d770b376e4d8c","WorkRequested":"Test WR","WorkType":"Internal","Type":"Lake","Line_item_count":"2","line_items":[{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000RVM2UAO","PartQuantity":"2","PartPrice":"1000"},{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000R5XVUA0","PartQuantity":"1","PartPrice":"10000"}],"Labour_Quantity":"1","WWOMISCChrge":"5000","WWOMISCChrge2":"5000","WWOMISCChrge3":"5000","Labour_Price":"5000","Shop_Price":"2000","Customer_Pay":"1000","Claim_Status":"Approved","Claim_Date":"2017-02-02","Claim_Approval_Date":"2017-02-03","Claim_Approved_Amo":"5000","Return_Part_Amount":"2000","Claim_Paid_Date":"2017-12-31","Claim_Labor_Paid_Amount":"4000","Parts_Paid_Amount":"5000","Total_Paid":"9000.00","WWOBalance_Due":"10000.00","WWOMISCChrgep":"10000.00","WWOMISCChrge":"10000.00"}]}]';
        WarrantyWorkOrderControllerClone.createWarrantyWorkOrder(strRecJSON);
        
        String strRecJSON1 = '[{"Contact_Id":"'+objContact.Id+'","boatId":"'+objItem.Id+'","Drive":"Drive","Hours":"Hrs","Status":"New","SalesTax":"7.25","Job_item":[{"ExistingJobId":"","Id":"0c4f766d770b376e4d8c","WorkRequested":"Test WR","WorkType":"Internal","Type":"Lake","Line_item_count":"2","line_items":[{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000RVM2UAO","PartQuantity":"2","PartPrice":"1000"},{"Id":"0c4f766d770b376e4d8c","PartId":"a1M4E000000R5XVUA0","PartQuantity":"1","PartPrice":"10000"}],"Labour_Quantity":"1","Labour_Price":"5000","WWOMISCChrge":"5000","WWOMISCChrge2":"5000","WWOMISCChrge3":"5000","Shop_Price":"2000","Customer_Pay":"1000","Claim_Status":"Approved","Claim_Date":"2017-02-02","Claim_Approval_Date":"2017-02-03","Claim_Approved_Amo":"5000","Return_Part_Amount":"2000","Claim_Paid_Date":"2017-12-31","Claim_Labor_Paid_Amount":"4000","Parts_Paid_Amount":"5000","Total_Paid":"9000.00","WWOBalance_Due":"10000.00","WWOMISCChrgep":"10000.00","WWOMISCChrge":"10000.00"}]}]';
        WarrantyWorkOrderControllerClone.createWarrantyWorkOrder(strRecJSON1);
        WarrantyWorkOrderControllerClone.getClaimStatus();
        
        WarrantyWorkOrderControllerClone.fetchWorkOrder(objwo.Id);
        WarrantyWorkOrderControllerClone.searchParts('Test');
        BOATBUILDING__WorkTypePricing__c objPri = new BOATBUILDING__WorkTypePricing__c(); 
        objPri.Name='Test Price';
        objPri.BOATBUILDING__Price__c=8000;
        insert objPri;
        List<BOATBUILDING__WorkTypePricing__c> lstPri = new  List<BOATBUILDING__WorkTypePricing__c>();
        lstPri.add(objPri);
        WarrantyWorkOrderControllerClone.fetchWorkTypePricingDetails();
        WarrantyWorkOrderControllerClone.updatePartFromEditableMode(objJLI.Id,'6'); 
        WarrantyWorkOrderControllerClone.removeExistingElement(objJLI.Id);
        WarrantyWorkOrderControllerClone.removeFromExistingWO(objJob.Id);
      //  WarrantyWorkOrderControllerClone.getPromocodeDetail('prom12');
        
        //List<BOATBUILDING__Work_Order__c> lstWo= new  List<BOATBUILDING__Work_Order__c>();
        //lstWo.add(objwo);
        
        
    }
}