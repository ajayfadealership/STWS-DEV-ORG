@isTest
public class QuotePDFLayoutControllerTest {
    static testMethod void myUnitTest(){
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        ApexPages.currentPage().getParameters().put('Id',objQuote.Id);
        insert objQuote;
        ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
       // QuotePDFLayoutController objQuotePdf = new QuotePDFLayoutController(sc);
 
    }
}