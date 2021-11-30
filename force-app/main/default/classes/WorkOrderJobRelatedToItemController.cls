public class WorkOrderJobRelatedToItemController {
    
    @AuraEnabled
    public static List<BOATBUILDING__Work_Order_Job__c> getWOJRelatedToItem(String strWOId){
        
        List<BOATBUILDING__Work_Order__c> listWO = [SELECT Id,BOATBUILDING__Boat__c, BOATBUILDING__Account__c  
                                                    FROM BOATBUILDING__Work_Order__c WHERE Id =:strWOId];
        
        
        List<BOATBUILDING__Work_Order_Job__c> listWOJ = [SELECT Id, Name, BOATBUILDING__Job_Name__c, BOATBUILDING__Type__c,
                                                         BOATBUILDING__Work_Type__c, BOATBUILDING__No_of_Labors__c,
                                                         BOATBUILDING__Completed__c, BOATBUILDING__Job_Completed_Date__c 	
                                                         FROM BOATBUILDING__Work_Order_Job__c
                                                         WHERE BOATBUILDING__Account__c =: listWO[0].BOATBUILDING__Account__c 
                                                         ORDER BY CreatedDate DESC];
        
        return listWOJ;
    }
}