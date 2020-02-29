@isTest
public class MultipleUploadControllerTest {
    testmethod static void TestController(){
        BOATBUILDING__Inventory__c objInv= new BOATBUILDING__Inventory__c();
        insert objInv;
 
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId= objInv.Id;
        //insert attach;
        
       
        ApexPages.currentPage().getParameters().put('Id',objInv.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objInv);
        MultipleUploadController objM = new MultipleUploadController(sc);
        objM.filename = 'test';
        objM.filebody = bodyBlob;
       // objM.objattachment =
        objM.SaveAttachments();
       
        
        
    }
    
    
}