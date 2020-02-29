@isTest
public with sharing class PrintButtonPageController2Test 
{
   public static testmethod void MyUnitTest1()
    {
    	BOATBUILDING__Quote__c ObjQuote = new BOATBUILDING__Quote__c();
    	  ObjQuote.Name = 'abcTst';
    	  insert ObjQuote;
    	  
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
        PrintButtonPageController2 ObjController = new PrintButtonPageController2(sc); 
        
        
        
            Pagereference pf = ObjController.directTo();
        	//pagereference pf1= ObjController.checkAccess();
    	  
    }
    
    public static testmethod void MyUnitTest2()
    {
    	BOATBUILDING__Quote__c ObjQuote = new BOATBUILDING__Quote__c();
    	  ObjQuote.Name = 'abcTst';
    	  insert ObjQuote;
    	    	     	  
    	  ApexPages.currentPage().getParameters().put('Id',objQuote.id);
    	 
  	  	ApexPages.StandardController sc = new ApexPages.StandardController(objQuote);
        PrintButtonPageController2 ObjController = new PrintButtonPageController2(sc); 
        
        
        
            Pagereference pf = ObjController.directTo();
    	  
    }
}