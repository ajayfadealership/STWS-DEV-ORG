@isTest
public class Part_DetailControllerTest {
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
        objPart.BOATBUILDING__Category1__c = 'Boat Parts';
        objPart.BOATBUILDING__Part_Cost__c = 700;
        objPart.Add_Inventory__c = true;
        insert objPart;
       Test.StartTest(); 

        PageReference pageRef = Page.Part_Detail;
        pageRef.getParameters().put('id', String.valueOf(objPart.Id));
        Test.setCurrentPage(pageRef);
        Part_DetailController objPDC = new Part_DetailController();
        objPDC.updatePartDetail();
        Test.StopTest();

    }

}