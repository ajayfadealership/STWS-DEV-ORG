public class ACVController {
    @AuraEnabled 
    public static ACV_Form__c saveACVForm(ACV_Form__c objACV) {
        
        upsert objACV;
        List<ProcessDefinition> lstpd = [SELECT DeveloperName,Id,Name,State,TableEnumOrId,Type FROM ProcessDefinition Where TableEnumOrId =: 'BOATBUILDING__ACV_Form__c' AND State =: 'Active'];
        if(lstpd.size() > 0 && !Approval.isLocked(objACV.Id))
        {
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(objACV.id);
            req1.setSubmitterId(Userinfo.getUserId()); 
            req1.setProcessDefinitionNameOrId(lstpd[0].DeveloperName);
            if(!Test.isRunningTest())
            Approval.ProcessResult result = Approval.process(req1);
        }
        return objACV;
    }
    @AuraEnabled
    public static BOATBUILDING__ACV_Form__c getNewACVObjInstance()
    {
        return new BOATBUILDING__ACV_Form__c();
    }
    
    public static Boolean checkApprovalStatus(Id recid)
    {
        List<ProcessInstance> lPI = [SELECT Status,TargetObjectId FROM ProcessInstance where TargetObjectId =: recid AND Status =: 'Approved'];
        if(lPI.size() > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}