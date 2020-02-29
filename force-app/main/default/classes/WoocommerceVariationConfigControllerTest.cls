@isTest
public class WoocommerceVariationConfigControllerTest {
    private static testmethod void WoocommerceVariationConfigControllerTest (){
        
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Manufacturer__c objManuFacturer2 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer2.Name = 'ven';
        objManuFacturer2.Manufacturer_name__c = '12';
        objManuFacturer2.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer2;
            
        Part__c objPart = new Part__c();
        objPart.Part_Number__c = 'abcgsgsg';
        objPart.Vendor_Name__c = objManuFacturer2.Id;
        insert objPart;
        
        Part__c objPart1 = new Part__c();
        objPart1.Part_Number__c = 'abc';
        objPart1.Part__c = objPart.Id;
        objPart1.Vendor_Name__c = objManuFacturer1.Id;
        insert objPart1;
        
       
        BOATBUILDING__Woocommerce_Attribute__c objAtt = new BOATBUILDING__Woocommerce_Attribute__c();
        objAtt.Name ='strNewAttName' ;
        insert objAtt;
        
        BOATBUILDING__Woocom_Variant_Option__c objWVO = new BOATBUILDING__Woocom_Variant_Option__c();
        objWVO.BOATBUILDING__Woocommerce_Attribute__c = objAtt.Id;
        objWVO.BOATBUILDING__Part__c = objPart1.Id ;
        objWVO.BOATBUILDING__Option__c = 'abcdTest';
        insert objWVO; 
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objPart);
        ApexPages.currentPage().getParameters().put('id', objPart.Id);
        WoocommerceVariationConfigController objWoo = new WoocommerceVariationConfigController(sc);
        
        objWoo.strNewAttName = 'test';
        objWoo.saveAttribute();
        objWoo.addNewAttToVarList();
        
        BOATBUILDING__Woocom_Variant_Option__c objWVO1 = new BOATBUILDING__Woocom_Variant_Option__c();
        objWVO1.BOATBUILDING__Woocommerce_Attribute__c = objAtt.Id;
        objWVO1.BOATBUILDING__Part__c = objPart1.Id ;
        objWVO1.BOATBUILDING__Option__c = 'asdaf';
        objWoo.lstVCW[0].objWVO = objWVO1;
        
        objWoo.saveVariantWithAttributesApex();
        objWoo.addNewAttToVarList();
        BOATBUILDING__Woocom_Variant_Option__c objWVO11 = new BOATBUILDING__Woocom_Variant_Option__c();
        objWVO11.BOATBUILDING__Woocommerce_Attribute__c = objAtt.Id;
        objWVO11.BOATBUILDING__Part__c = objPart1.Id ;
        objWVO11.BOATBUILDING__Option__c = 'asdaf';
        objWoo.lstVCW[0].objWVO = objWVO11;
        objWoo.lstVCW[0].strTempId = '12wdwew';
        objWoo.dltPartId = '12wdwew1';
        objWoo.deleteAttFromVarListApex();
        objWoo.deleteVarFromHomeListApex();
        
        
    }
    
}