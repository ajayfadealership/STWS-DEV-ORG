public class FileUploadController {
    @AuraEnabled
    public static String UpdateFileNameToSide(String JsonString){
        if(JsonString != null && JsonString != ''){
            system.debug('>?>?>?'+JsonString);
            list<Filedetails> obj = ( list<Filedetails>)JSON.deserializeStrict(
                JsonString,
                list<Filedetails>.class);
            set<Id> setOfId = new Set<Id>();
            for(Filedetails objFd : obj){
                setOfId.add(objFd.documentId);
            }
            List<ContentVersion> lst = [SELECT FileExtension, Title FROM ContentVersion 
                                        Where ContentDocumentId IN: setOfId];
            List<ContentVersion> lstConV = new  List<ContentVersion>();
            for(ContentVersion objCv :lst ){
                objCv.Title = 'side';
                lstConV.add(objCv);
                
            }
            update lstConV;
        }
        return 'SUCCESS';
    }
    public class Filedetails {         
        public String name;
        public String documentId;
    }
    
}