@isTest
public class ServicePageControllerTest{
    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
         
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = 'test';
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
       
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        insert objOrder;
        
        BOATBUILDING__Item__c objItem = new BOATBUILDING__Item__c();
        objItem.Name = 'test';
        insert objItem;
        
        BOATBUILDING__Work_Order__c objWork = new BOATBUILDING__Work_Order__c();
        insert objWork;
        BOATBUILDING__Invoice__c objInvoice = new BOATBUILDING__Invoice__c();
        insert objInvoice;
        
        BOATBUILDING__Payment__c objPay = new BOATBUILDING__Payment__c();
        objPay.BOATBUILDING__Related_to_Invoice__c = objInvoice.Id;
        objPay.BOATBUILDING__Amount__c = 123;
        insert objPay;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        insert objContact;
       
        Map<String,String> objMap = new Map<String,String>();
        objMap.put('MSRP','25');
        objMap.put('inventoryLocation','test');
        objMap.put('Description','test1');
        objMap.put('PartNumber','123456');
        objMap.put('MapPrice','254');
        objMap.put('Discount','52');
        objMap.put('Size','large');
        objMap.put('Category','Parts');
        objMap.put('Family','Canvas');
        objMap.put('Color','red');
        objMap.put('Cost','365');
        objMap.put('MinAmount','214');
        
        Map<String,String> objMap2 = new Map<String,String>();
        objMap2.put('test','2254');
        Map<String,String> objMap3 = new Map<String,String>();
        objMap3.put('test','2254');
        
    
        Map<String,String> objMap1 = new Map<String,String>();
        objMap1.put('MSRP','25');
        objMap1.put('Description','test');
        objMap1.put('PartNumber','test1');
        objMap1.put('Category','aSSA');
        objMap1.put('MapPrice','254');
        objMap1.put('Discount','52');
        objMap1.put('Family','large');
        objMap1.put('Cost','1234');
        objMap1.put('inventoryLocation','134');
        ServicePageController.saveInventory(objMap1);
        
        String strRecordTypeIdTmgmt = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Time_Management__c' and Name = 'Standard Time Sheet' limit 1 ].Id;
        BOATBUILDING__Time_Management__c objTimeMgmt = new BOATBUILDING__Time_Management__c();
        if(strRecordTypeIdTmgmt != null){
        objTimeMgmt.RecordTypeId = strRecordTypeIdTmgmt;
        }
        objTimeMgmt.BOATBUILDING__Day_In__c = DateTime.Parse('3/1/2017 7:20 AM');
        objTimeMgmt.BOATBUILDING__Day_Out__c = DateTime.Parse('3/1/2017 7:20 PM');
        objTimeMgmt.BOATBUILDING__Lunch_In__c = DateTime.Parse('3/1/2017 3:20 PM');
        objTimeMgmt.BOATBUILDING__Lunch_Out__c = DateTime.Parse('3/1/2017 3:00 PM');
        insert objTimeMgmt;
        
        
        List<BOATBUILDING__Time_Management__c> checkrecordexists = ServicePageController.checkrecordexists();
        
        String dayin = ServicePageController.dayin();
        
        String lunchout = ServicePageController.lunchout(objTimeMgmt.Id);
        String lunchin = ServicePageController.lunchin(objTimeMgmt.Id);
        
        String dayout = ServicePageController.dayout(objTimeMgmt.Id);
        
        Test.startTest();
        objTimeMgmt.BOATBUILDING__Lunch_Out__c = DateTime.Parse('3/1/2017 3:19 PM');
        update objTimeMgmt;
        String dayout1 = ServicePageController.dayout(objTimeMgmt.Id);
        
        objTimeMgmt.BOATBUILDING__Day_In__c = DateTime.Parse('3/1/2017 7:28 PM');
        objTimeMgmt.BOATBUILDING__Day_Out__c = DateTime.Parse('3/1/2017 7:29 PM');
        update objTimeMgmt;
        String dayout2 = ServicePageController.dayout(objTimeMgmt.Id);
        
        BOATBUILDING__Time_Management__c objTimeMgmt2 = new BOATBUILDING__Time_Management__c();
        if(strRecordTypeIdTmgmt != null){
        objTimeMgmt2.RecordTypeId = strRecordTypeIdTmgmt;
        }
        objTimeMgmt2.BOATBUILDING__Day_In__c = DateTime.Parse('3/1/2017 7:20 AM');
        objTimeMgmt2.BOATBUILDING__Day_Out__c = DateTime.Parse('3/1/2017 7:20 PM');
        
        objTimeMgmt2.BOATBUILDING__Lunch_Out__c = DateTime.Parse('3/1/2017 3:00 PM');
        Test.stopTest();
        //insert objTimeMgmt2;
        //String dayout3 = ServicePageController.dayout(objTimeMgmt2.Id);
         ServicePageController objServicePageController = new ServicePageController();
        objServicePageController.getlstOfPurchaseOrder();
        objServicePageController.getlstOfOrder();
        objServicePageController.getlstOfInventory();
        objServicePageController.getListOrInvoice();
        
        ServicePageController.getContact(objContact.Id);
       // ServicePageController.getListOfInventoryViaPart('test' , '0');
        ServicePageController.getListOfInventoryViaPart('test' , '1');
        ServicePageController.getListOfInventoryViaPart('test' , '2');
        ServicePageController.getListOfInventoryViaPart('test' , '3');
        ServicePageController.getListOfInventoryViaPart('test' , '4');
        ServicePageController.getAllOrderLineItems(objOrder.Id);
         ServicePageController.getPromocodes(); 
       // ServicePageController.generateInvoice(objMap2,objMap3,objContact.Id, 'STWS');
        ServicePageController.fetchItems(objItem.Id);
  
        ServicePageController.storeLocationStatus();
        
        ServicePageController.getTimes();
        ServicePageController.fetchWO(objWork.Id);
        //ServicePageController.addPayment(objMap,objInvoice.Id);
        
    }
  
}