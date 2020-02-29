public with sharing class DDCloneController {
    @RemoteAction 
    public static String uploadImage(String strFile, String fName, String parId) {
        System.debug('Debug Log For Blob: '+strFile);
        List<Attachment> listAttach = [SELECT Id, Name FROM Attachment WHERE ParentId =: parId AND Name =:fName];
        
        Attachment a = new Attachment();
        
        Boolean isSuccess = True;
        
        try{
            if(!listAttach.isEmpty()){
                delete listAttach;
            }
        } catch(Exception e){
            isSuccess = False;
        }
        System.debug('>>'+strFile.subString(strFile.indexOfIgnoreCase('base64,') +7, strFile.length()-1));
        if(isSuccess){
            a = new Attachment (ParentId = parId,
                                Body = EncodingUtil.base64Decode(strFile.subString(strFile.indexOfIgnoreCase('base64,') +7, strFile.length()-1)),
                                Name = fName);  
            insert a; 
            return a.Id; 
        } else{
            return null;
        }
    }
}