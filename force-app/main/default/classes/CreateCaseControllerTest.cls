@isTest
public class CreateCaseControllerTest {
    static testMethod void myUnitTest(){
        Case cse=new Case();
        insert cse;
 
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=cse.id;
        insert attach;
      //  CreateCaseController.doUploadAttachment(cse.id,'test',attach.Name);
        
    }

}