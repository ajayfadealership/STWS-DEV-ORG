public with sharing class CustomLogUtil {
    public CustomLogUtil() {
    }

    public static List<BOATBUILDING__Custom_Log__c> createLog(String strLog, String strClassName){
        List<BOATBUILDING__Custom_Log__c> listCLToReturn = new List<BOATBUILDING__Custom_Log__c>();
        System_Configure__c objSC = System_Configure__c.getOrgDefaults();
        BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
        if(objSC != null && objSC.Enable_Debug_Mails__c)  {
            objCL.Name = 'Log';
            objCL.BOATBUILDING__Summary__c = strLog;
            objCL.BOATBUILDING__Class_Name__c = strClassName;
            listCLToReturn.add(objCL);
        }
        return listCLToReturn;
    }
}