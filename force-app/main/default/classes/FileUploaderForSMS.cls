public with sharing class FileUploaderForSMS {
    @AuraEnabled
    public static String uploadFile(String base64, String filename, String strBody) {
        /*  system.debug('>>>>>filename'+filename);
system.debug('>>>>>base64***'+base64);
system.debug('>>>>>strBody***'+strBody); */
        try{
            
            ContentVersion cv = createContentVersion(base64, filename);
            ContentDocumentLink cdl = createContentLink(cv.Id,'0016F00003q1RRKQA2');
            if (cv == null || cdl == null) { return null; }
            system.debug('cdlcdl'+cdl.Id);
            return cdl.Id; 
        }catch(exception ex){
            system.debug('>>>'+ex);
            return ' ';
        }
        
    }
    
    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
            insert cv;
            return cv;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
            SELECT ContentDocumentId 
            FROM ContentVersion 
            WHERE Id =: contentVersionId
        ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
}