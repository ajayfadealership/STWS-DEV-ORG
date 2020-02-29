@isTest
public class DDCloneControllerTest {
    
    testmethod static void TestController(){
        DDCloneController ObjD = new  DDCloneController();
        Account objAcc = new Account();
        objAcc.name ='test';
        insert objAcc;
        
        Contact objcont = new Contact();
        objcont.FirstName='Test';
        objcont.LastName='Test';
        objcont.Accountid= objAcc.id;
        insert Objcont;
        
        Case Objcase = new Case();
        Objcase.ContactId = objcont.Id;
        Objcase.AccountId = objAcc.Id; 
        Objcase.Status = 'Working';
        Objcase.Origin = 'Phone';
        insert Objcase;
        
        Attachment attach = new Attachment();   	
        attach.Name ='Unit Test Attachment';
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob;
        attach.parentId= Objcase.id;
        insert attach;
       
       DDCloneController.uploadImage('base64abcdefghijklmno','name',attach.parentId);
        
        
        
        
    }
    
    
}