public without sharing class UserPermissionUtil {


    public static Boolean isCreateable(String Sobjectname, String fieldName){
        
        Boolean isCreateableToReturn = False;
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
        
        if(fields.containsKey(fieldName)){
            Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
            if(fieldResult.isCreateable()){
                isCreateableToReturn = True;
            }
        }
        
        return isCreateableToReturn;
    }
    
    public static Boolean isUpdateable(String Sobjectname, String fieldName){
        
        Boolean isUpdateableToReturn = False;
        Map<String, Schema.SObjectField> fields = Schema.getGlobalDescribe().get(sobjectname).getDescribe().SObjectType.getDescribe().fields.getMap();
        
        if(fields.containsKey(fieldName)){
            Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
            if(fieldResult.isUpdateable()){
                isUpdateableToReturn = True;
            }
        }
        
        return isUpdateableToReturn;
    }
}