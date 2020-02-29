@isTest
private class attachmentsampleTest {
    
    static testMethod void myUnitTest() {
        Account objAc = new account();
        objAc.Name = 'test'; 
        insert ObjAc;
        System.currentPagereference().getParameters().put('id',objAc.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objAc);
        attachmentsample objAttachment = new attachmentsample(sc);
        objAttachment.myfile = new Attachment();
        objAttachment.myfile.ParentId = objAc.Id;
        objAttachment.myfile.Name = 'Test';
        objAttachment.myfile.Body = Blob.valueOf('Unit Test Attachment Body');
        
        objAttachment.getmyfile(); 
        objAttachment.Savedoc();  
    }
}