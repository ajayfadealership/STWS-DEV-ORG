public class WorkOrderNavigationController {
    @AuraEnabled
    public static String getPDFName() {
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        if(objSC != null && objSC.BOATBUILDING__Work_Order_PDF__c != null) {
            return objSC.BOATBUILDING__Work_Order_PDF__c;
        }else{
            return 'CasePDFPageClone2skp';
        }
        
    }
}