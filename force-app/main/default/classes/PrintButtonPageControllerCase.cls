/** 
    * Author             : Shobhit Saxena 
    * Organization       : 360 Degree Cloud Technologies Pvt. Ltd. 
    * Created Date       : 23/02/2016 
    * Last Modified Date : 23/02/2016 
    */

public with sharing class PrintButtonPageControllerCase {
    List<Case> lstCase;
    public String btnStatus;
    
    //Access Check
    public PageReference checkAccess() {
    	String strAccessKey = AccessControllCheck.ckeckAccess();
    	
    	if(!strAccessKey.containsIgnoreCase('Service')) {
    		return new PageReference('/apex/ContactToYourAdministrator');
    	}
    	return null;
    }
    
    public PrintButtonPageControllerCase(ApexPages.StandardController controller) {
        lstCase = new List<Case>();
        btnStatus = 'Print';
    }
    public PageReference directToCase(){
        
        lstCase = [Select Id,ContactID,Contact.Email from Case where Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];
        return new PageReference('/apex/CasePDFPageClone2?scontrolCaching=1&id='+lstCase[0].Id+'&btnStatus='+btnStatus);
       
    }
}