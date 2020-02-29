@isTest
public class WooCommerce_ConnectTest {
    private static testmethod void WooCommerce_ConnectTest(){
       
        BOATBUILDING__Manufacturer__c objManu = new BOATBUILDING__Manufacturer__c();
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'BOATBUILDING__Manufacturer__c' AND Name = 'Vendor'];
        objManu.BOATBUILDING__Manufacturer_name__c = 'Test';
        objManu.RecordTypeId = rt.Id;
        insert objManu;
        
        BOATBUILDING__WooCmmerce_Config__c objWoo = new BOATBUILDING__WooCmmerce_Config__c();
        objWoo.BOATBUILDING__User_Name__c = 'test';
        objWoo.BOATBUILDING__Consumer_key__c = 'test1';
        objWoo.BOATBUILDING__Consumer_secret__c = 'test2';
        objwoo.BOATBUILDING__Password__c = '123err';
        objwoo.BOATBUILDING__API_URL__c = 'https://www.google.com';
        insert objWoo;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.BOATBUILDING__Part_Number__c ='testNo.';
        objPart.BOATBUILDING__Vendor_Name__c = objManu.Id;
        objPart.BOATBUILDING__Category1__c = 'Boat';
        insert objPart;
        
        BOATBUILDING__Invoice__c objInv = new BOATBUILDING__Invoice__c();
        objInv.Name = 'testname';
        insert objInv;
        
        
        map<string,string> mapAtt = new map<string,string>();
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objPart.id;
        mapAtt.put(attach.Id,attach.Name);
        insert attach; 
        
        WooCommerce_Connect.savePartsToWooCommerce(objPart.Id);
        WooCommerce_Connect.savePartsToWooComLightning(objPart.Id);
        WooCommerce_Connect.updateInvoice(objInv.Id);
     //  WooCommerce_Connect.getWooCommerceTags(objWoo);
        WooCommerce_Connect.createCustomCategoryToWoocommerce('titletest',objWoo, 'titletest');
        WooCommerce_Connect.createCustomTagToWoocommerce('strFamilyTitle',objWoo);    
        
          
    }

}