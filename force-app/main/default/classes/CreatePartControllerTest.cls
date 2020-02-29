@isTest
private class CreatePartControllerTest {

    static testMethod void unitTest(){
        BOATBUILDING__Manufacturer__c objManuFacturer1 = new BOATBUILDING__Manufacturer__c();
        objManuFacturer1.Name = 'Skiers Choice(Moomba)';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.RecordTypeId = Schema.SObjectType.BOATBUILDING__Manufacturer__c.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        insert objManuFacturer1;
        
        BOATBUILDING__Part__c objPart = new BOATBUILDING__Part__c();
        objPart.Name = 'test';
        objPart.Part_Number__c = 'avsfd';
        objPart.Vendor_Name__c = objManuFacturer1.Id;
        objPart.Retail_Price__c = 23;
        insert objPart;
        
        Map<String,String> objMap = new Map<String,String>();
        objMap.put('vendor',objManuFacturer1.Id);
        objMap.put('partMSRP','25');
        objMap.put('partWeight','test');
        objMap.put('partSize','test');
        objMap.put('partNumber','test1');
        objMap.put('partColor','test');
        objMap.put('partDescription','test1');
        objMap.put('partDiscount','52');
        objMap.put('partCost','745');
        objMap.put('partCategory','Parts');
        objMap.put('partFamily','Boards');
        objMap.put('partMinAmount','85');
        objMap.put('partLocation','test1');
        objMap.put('partBin','test1');
        objMap.put('MapPrice','658');
         
        CreatePartController objCreatePartController = new CreatePartController();
        //objCreatePartController.getlstOfParts(); 
        CreatePartController.fetchManufacturer(objManuFacturer1.Id);
        CreatePartController.savePart(objMap);
       
    
    }
}