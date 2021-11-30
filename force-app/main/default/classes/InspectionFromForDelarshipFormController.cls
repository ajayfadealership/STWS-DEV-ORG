public class InspectionFromForDelarshipFormController {
    @AuraEnabled
    public static BOATBUILDING__Dealership_Form__c getWOfromDelarshipForm(String recId){
        BOATBUILDING__Dealership_Form__c objDF = [SELECT Id,BOATBUILDING__Work_Order__c from BOATBUILDING__Dealership_Form__c WHERE Id =: recId];
        return objDF;
        
    }

}