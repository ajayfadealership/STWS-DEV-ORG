public class PartSwappingForInventoryController {
	public List<Parts_Availability__c> lstPA { get; set; }
	public Integer totalQuantityCount { get; set; }
	String strInvId;
	public String PartName { get; set; }
	public PartSwappingForInventoryController() {
		totalQuantityCount = 0;
		strInvId = '';
		PartName = '';
		lstPA = new List<Parts_Availability__c>();
		strInvId = ApexPages.currentPage().getParameters().get('Id');
    		lstPA = [Select Id, Name, Store_Location__c , Quantity__c, Inventory__r.Part_Name__c From Parts_Availability__c Where Inventory__c =: strInvId Limit 1000];
    		
    		if(!lstPA.isEmpty()) {
	    		for(Parts_Availability__c objPA: lstPA) {
	    			if(objPA.Quantity__c != null) {
	    				totalQuantityCount += Integer.valueOf(objPA.Quantity__c);
	    				PartName = objPA.Inventory__r.Part_Name__c;
	    			}
	    		}
    		}
    		
	}
    
    public List<Parts_Availability__c> getPAList() {
    		return lstPA;
    }
 	
 	public PageReference saveSwapping() {
 		try {
	 		Integer totalQuantityCountTemp = 0;
	 		if(!lstPA.isEmpty()) {
		    		for(Parts_Availability__c objPA: lstPA) {
		    			if(objPA.Quantity__c != null) {
		    				totalQuantityCountTemp += Integer.valueOf(objPA.Quantity__c);
		    			}
		    		}
		    		if(totalQuantityCountTemp == totalQuantityCount) {
		    			update lstPA;
		    		} else {
		    			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Total quantity should be: '+totalQuantityCount);
	         		ApexPages.addMessage(apexMessage);
	         		return null;
		    		}
	    		}
 		} catch(Exception ex) {
 			ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: '+ex.getMessage() + ' ,Line Number: '+ex.getLineNumber());
         	ApexPages.addMessage(apexMessage);
         	return null;
 		}
 		return new PageReference('/' + strInvId);
 	}   
}