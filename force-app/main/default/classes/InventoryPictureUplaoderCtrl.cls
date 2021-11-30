public with sharing class InventoryPictureUplaoderCtrl {
    
    @AuraEnabled
    public static string getInventoryImage(String fileName, String recordId){
        
        List<ContentDocumentLink> lstCDL =  [SELECT ContentDocumentId,LinkedEntityId,Visibility FROM ContentDocumentLink where ContentDocument.Title =: fileName and LinkedEntityId =: recordId];

        if(lstCDL.size() > 0){
            return lstCDL[0].ContentDocumentId;
        }else{
            return 'NoFile';
        }

        
    }


    @AuraEnabled
    public static String UpdateFileName(String cdId, String fileName ){
            
                List<ContentVersion> lst = [SELECT FileExtension, Title FROM ContentVersion 
                                            Where ContentDocumentId =: cdId];
                List<ContentVersion> lstConV = new  List<ContentVersion>();
                for(ContentVersion objCv :lst ){
                    objCv.Title = fileName;
                    lstConV.add(objCv);
                    
                }
                update lstConV;
            
            return 'SUCCESS';
        }
}