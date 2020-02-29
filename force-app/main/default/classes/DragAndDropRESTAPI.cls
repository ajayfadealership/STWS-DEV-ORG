@RestResource(urlMapping='/DragAndDrop/v1/*')
global with sharing class DragAndDropRESTAPI
{
    @HttpPost
    global static String attachDoc(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        String fName = req.params.get('FileName');
        String parId = req.params.get('parId');
        Blob postContent = req.requestBody;
        
        List<Attachment> listAttach = [SELECT Id, Name FROM Attachment WHERE ParentId =: parId AND Name =:fName];
        
        Attachment a = new Attachment();
        
        Boolean isSuccess = True;
        
        try{
            if(!listAttach.isEmpty()){
                Delete listAttach;
            }
        } catch(Exception e){
            isSuccess = False;
        }
        
        if(isSuccess){
            a = new Attachment (ParentId = parId,
                                       Body = postContent,
                                       Name = fName);
            insert a;
            return a.Id;
        } else{
            return null;
        }
   }
}