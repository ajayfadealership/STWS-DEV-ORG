@isTest
public class BeeControllerTest {
    static testMethod void myUnitTest(){
        EmailTemplate e = new EmailTemplate();
        Id folderId = [Select id from Folder where type ='Email'][0].Id;     
        e.Name = 'testemailtemplate';
        e.DeveloperName = 'MyTestEmailTemplate1dfsaafasdfasdzjkj';
        e.TemplateType = 'custom';
        e.HtmlValue = '<html> Hello Test!!</html>';
        e.FolderId = folderId;
        e.body = 'some json';
        insert e;
        BeeController ObjBee = new BeeController();
        BeeController.getJSONBody(e.id);
        BeeController.saveEmailTemplate('<html> Hello Test!!</html>','some json',e.Id );
        
        
    }
    
    
}