@isTest
public class Shopify_ConnectTest {

    testmethod static void shopifyTest(){
        
        Id vendorRecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        
        BOATBUILDING__Manufacturer__c objManu = new BOATBUILDING__Manufacturer__c();
        objManu.Name = 'Test manufacturer';
        objManu.BOATBUILDING__Manufacturer_name__c = 'Test123';
        objManu.RecordTypeId = vendorRecordTypeId;
        insert objManu;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'Test Part';
        objPart.BOATBUILDING__Part_Number__c = '12345';
        objPart.BOATBUILDING__Vendor_Name__c = objManu.Id;
        objPart.BOATBUILDING__Category1__c = 'Boat Parts';
        insert objPart;
        
        Attachment objAttach = new Attachment();
        objAttach.Body = Blob.valueOf('o');
        objAttach.Name = 'Test Attach';
        objAttach.ParentId = objPart.Id;
        insert objAttach;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Shopify_ConnectMockTest());  
        Shopify_Connect.savePartsToShopifyLightning(objPart.Id);
        Test.stopTest();
    }
}