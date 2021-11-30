@isTest
public class ReceiveAllAtLocationTest {
    public static testmethod void myTestMethod() {
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        objOrder.Received__c = 2;
        insert objOrder;
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c =2 ;
        objLI.Part_Number_del__c = '1';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        objLI.BOATBUILDING__Name__c = 'testing';
        insert objLI ;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Vendor_Name__c = objManuFacturer1.Id;  
        objPart.Part_Number__c = '1';  
        objPart.Name= '1'; 
        insert objPart;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.BOATBUILDING__Quantity__c =null ;
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Parts_Availability__c objPA = new BOATBUILDING__Parts_Availability__c();
        objPA.BOATBUILDING__Inventory__c = objInventory.Id;
        objPA.BOATBUILDING__Quantity__c = null;
        objPA.BOATBUILDING__Store_Location__c = 'Other';
        insert objPA;
        
        OrderEditWrapper objWrap = new OrderEditWrapper();
        //objWrap.received = objOrder.Received__c;
        // objWrap.quantity= objLI.Quantity__c;
        System.debug('>>>>Line Item values2'+objLI);
        System.debug('>>>>>order values2' + objOrder);
        objWrap.partNo = objLI.Part_Number_del__c;
        objWrap.lineItemId =objLI.Id ;
        objWrap.quantity =Integer.valueof(objLI.Quantity__c);
        objWrap.received = Integer.valueof(objOrder.Received__c);
        objWrap.amount= objLI.BOATBUILDING__Amount__c;
        objWrap.cost = objLI.Cost__c;
        
        
        List<OrderEditWrapper> lstWrap = new List<OrderEditWrapper>();
        lstWrap.add(objWrap); 
        ReceiveAllAtLocation.partAvailabilityAtLocation( 'Other', lstWrap, objOrder.Id);
    }
     public static testmethod void myTestMethod1() {
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        objOrder.Received__c = 2;
        insert objOrder;
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c =2 ;
        objLI.Part_Number_del__c = '1';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        objLI.BOATBUILDING__Name__c = 'testing';
        insert objLI ;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Vendor_Name__c = objManuFacturer1.Id;  
        objPart.Part_Number__c = '1';  
        objPart.Name= '1'; 
        insert objPart;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.BOATBUILDING__Quantity__c =null ;
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Parts_Availability__c objPA = new BOATBUILDING__Parts_Availability__c();
        objPA.BOATBUILDING__Inventory__c = objInventory.Id;
        objPA.BOATBUILDING__Quantity__c = 2;
        objPA.BOATBUILDING__Store_Location__c = 'Other';
        insert objPA;
        
        OrderEditWrapper objWrap = new OrderEditWrapper();
        //objWrap.received = objOrder.Received__c;
        // objWrap.quantity= objLI.Quantity__c;
        System.debug('>>>>Line Item values2'+objLI);
        System.debug('>>>>>order values2' + objOrder);
        objWrap.partNo = objLI.Part_Number_del__c;
        objWrap.lineItemId =objLI.Id ;
        objWrap.quantity =Integer.valueof(objLI.Quantity__c);
        objWrap.received = Integer.valueof(objOrder.Received__c);
        objWrap.amount= objLI.BOATBUILDING__Amount__c;
        objWrap.cost = objLI.Cost__c;
        
        
        List<OrderEditWrapper> lstWrap = new List<OrderEditWrapper>();
        lstWrap.add(objWrap); 
        ReceiveAllAtLocation.partAvailabilityAtLocation( 'Other', lstWrap, objOrder.Id);
    }
     public static testmethod void myTestMethod2() {
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        objOrder.Received__c = 2;
        insert objOrder;
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c =2 ;
        objLI.Part_Number_del__c = '1';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        objLI.BOATBUILDING__Name__c = 'testing';
        insert objLI ;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Vendor_Name__c = objManuFacturer1.Id;  
        objPart.Part_Number__c = '1';  
        objPart.Name= '1'; 
        insert objPart;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.BOATBUILDING__Quantity__c =null ;
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Parts_Availability__c objPA = new BOATBUILDING__Parts_Availability__c();
        objPA.BOATBUILDING__Inventory__c = objInventory.Id;
        objPA.BOATBUILDING__Quantity__c = null;
        objPA.BOATBUILDING__Store_Location__c = 'Other';
       insert objPA;
        
        OrderEditWrapper objWrap = new OrderEditWrapper();
        //objWrap.received = objOrder.Received__c;
        // objWrap.quantity= objLI.Quantity__c;
        System.debug('>>>>Line Item values2'+objLI);
        System.debug('>>>>>order values2' + objOrder);
        objWrap.partNo = objLI.Part_Number_del__c;
        objWrap.lineItemId =objLI.Id ;
        objWrap.quantity =Integer.valueof(objLI.Quantity__c);
        objWrap.received = Integer.valueof(objOrder.Received__c);
        objWrap.amount= objLI.BOATBUILDING__Amount__c;
        objWrap.cost = objLI.Cost__c;
        
        
        List<OrderEditWrapper> lstWrap = new List<OrderEditWrapper>();
        lstWrap.add(objWrap); 
        ReceiveAllAtLocation.partAvailabilityAtLocation( 'Other2', lstWrap, objOrder.Id);
    }
     public static testmethod void myTestMethod3() {
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        BOATBUILDING__Order__c  objOrder = new BOATBUILDING__Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.RecordTypeId = Schema.SObjectType.BOATBUILDING__Order__c.getRecordTypeInfosByName().get('Order').getRecordTypeId();
        objOrder.Received__c = 2;
        insert objOrder;
        BOATBUILDING__Line_Items__c objLI = new BOATBUILDING__Line_Items__c();
        objLI.Quantity__c =2 ;
        objLI.Part_Number_del__c = '1';
        objLI.Order__c = objOrder.Id;
        objLI.Name__c = 'test';
        objLI.Cost__c = 365;
        objLI.BOATBUILDING__Name__c = 'testing';
        insert objLI ;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Vendor_Name__c = objManuFacturer1.Id;  
        objPart.Part_Number__c = '1';  
        objPart.Name= '1'; 
        insert objPart;
        
        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Inventory__c' and Name = 'Inventory For Parts' limit 1 ].Id;
        BOATBUILDING__Inventory__c objInventory = new BOATBUILDING__Inventory__c();
        objInventory.RecordTypeId = strRecordTypeId ;
        objInventory.Part_Number__c = '1';
        objInventory.BOATBUILDING__Quantity__c =null ;
        objInventory.Vendor__c = objManuFacturer1.Id;
        insert objInventory;
        
        BOATBUILDING__Parts_Availability__c objPA = new BOATBUILDING__Parts_Availability__c();
        objPA.BOATBUILDING__Inventory__c = 'a0N6F00000UhOEnUAN';
        objPA.BOATBUILDING__Quantity__c = 2;
        objPA.BOATBUILDING__Store_Location__c = 'Other';
        //insert objPA;
        
        OrderEditWrapper objWrap = new OrderEditWrapper();
        //objWrap.received = objOrder.Received__c;
        // objWrap.quantity= objLI.Quantity__c;
        System.debug('>>>>Line Item values2'+objLI);
        System.debug('>>>>>order values2' + objOrder);
        objWrap.partNo = objLI.Part_Number_del__c;
        objWrap.lineItemId =objLI.Id ;
        objWrap.quantity =Integer.valueof(objLI.Quantity__c);
        objWrap.received = Integer.valueof(objOrder.Received__c);
        objWrap.amount= objLI.BOATBUILDING__Amount__c;
        objWrap.cost = objLI.Cost__c;
        
        
        List<OrderEditWrapper> lstWrap = new List<OrderEditWrapper>();
        lstWrap.add(objWrap); 
        ReceiveAllAtLocation.partAvailabilityAtLocation( 'Other', lstWrap, objOrder.Id);
    }
}