@isTest
private class GenerateCasePDFCloneTest {
    static testMethod void myUnitTest() {
        Contact objcont = new Contact();
		objcont.FirstName='Test';
		objcont.LastName='Test';
		insert objcont;	
       BOATBUILDING__Work_Order__c objWorkOrder = new BOATBUILDING__Work_Order__c();
        insert objWorkOrder;
        GenerateCasePDFClone objGC =  new GenerateCasePDFClone();
        objGC.checkAccess();
        objGC.backToService();
        objGC.saveCaseasPDF();
        objGC.saveAndSendCase();
       
        
    }}