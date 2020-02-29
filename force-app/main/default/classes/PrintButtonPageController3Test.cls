@isTest
public class PrintButtonPageController3Test {

     Public static  testMethod void MyUnitTest1()
  { 
     BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
     objQuote.Name = 'Test1';
     objQuote.Email__c = 'abc@njf.in';
     insert objQuote;
        Attachment attach=new Attachment();
        attach.Name='Unit Test Attachment'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body'); 
        attach.body=bodyBlob; 
        attach.parentId=objQuote.Id; 
        attach.ContentType = 'application/pdf'; 
        attach.IsPrivate = false; 
        attach.Description = 'Test'; 
        insert attach;
        ApexPages.currentPage().getParameters().put('Id',objQuote.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        PrintButtonPageController3 ObjController = new PrintButtonPageController3(sc); 
        //ObjController.QuoteId = objQuote.Id;
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objQuote.id];
        ObjController.directTo();
        System.assertEquals(1, attachments.size());
    
        
  } 
    Public static  testMethod void MyUnitTest2()
  { 
     BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
     objQuote.Name = 'Test2';
     objQuote.Email__c = 'abc123@xyz.in';
     insert objQuote;

        ApexPages.currentPage().getParameters().put('Id',objQuote.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        PrintButtonPageController3 ObjController = new PrintButtonPageController3(sc); 
        //ObjController.QuoteId = objQuote.Id;
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objQuote.id];
        ObjController.directTo();
        System.assertEquals(0, attachments.size());
        
  } 
}