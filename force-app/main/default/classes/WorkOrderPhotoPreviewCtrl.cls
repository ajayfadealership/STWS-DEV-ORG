public class WorkOrderPhotoPreviewCtrl {

    @AuraEnabled
    public static List<ContentDocumentLink> getWOPhotoFiles(String WOID){
        Set<String> setPhotoInspId = new Set<String>();
       
        
        List<ContentDocumentLink> cdlList = [SELECT Id,  LinkedEntityId, ShareType,Visibility, 
                                                    ContentDocument.ContentSize, ContentDocument.FileType, ContentDocument.FileExtension, 
                                                    ContentDocument.Title, ContentDocument.LastModifiedDate, ContentDocument.Id
                                               FROM ContentDocumentLink 
                                              WHERE linkedentityid =:  WOID];
        
        
        return cdlList;
    }
}