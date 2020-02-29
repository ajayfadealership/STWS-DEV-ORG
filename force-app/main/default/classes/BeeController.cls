public class BeeController{
    public String htmlValue1{get; set;}
    public String recordId{get; set;}
    public String HTMLForThumbnail{get;set;}
    public String HTMLData{get; set;}
    public  EmailTemplate mapIdTOJSON{get; set;}
   
    public List<SelectOption> options{get; set;}
    
    public BeeController()
    {
      EmailTemplate e = [Select Id,Name,body,HtmlValue from EmailTemplate where developername = 'MyTestEmailTemplate1'][0];
        htmlValue1 = e.body;
        recordId = e.Id;
        HTMLForThumbnail = JSON.serialize(e.HtmlValue);
        HTMLData = e.body;
        mapIdTOJSON = new EmailTemplate();
        mapIdTOJSON = e;
        
        
         options= new List<SelectOption>();
         options.add(new SelectOption('none', 'None'));
            options.add(new SelectOption(e.id, e.Name));
        
        
        }
    @RemoteAction
    public static String getJSONBody(String Id)
    {   //EmailTemplate e = new EmailTemplate();
        EmailTemplate e =  [Select Id,Name,body from EmailTemplate where Id =: Id];
        return e.body;
    }
    
    
    @RemoteAction
    public static String saveEmailTemplate(String blobvalue, string jsonbody, String recId)
    {   EmailTemplate e = new EmailTemplate();
        Id folderId = [Select id from Folder where type ='Email'][0].Id;
        
        
        
        
        
        if(recId == '' || recId == null)
        {   e.developerName = 'MyTestEmailTemplate1'; 
            e.TemplateType= 'custom';
            e.HtmlValue = blobvalue;
            e.body = jsonbody;
            e.name = 'testemailtemplate';
            e.folderId = folderId;
        }
        else
        {   e.Id = recId;
            System.debug(blobvalue);
            e.HtmlValue = blobvalue;
            e.body = jsonbody;
        }
        
        upsert e;
        
        return e.Id;
    }


}