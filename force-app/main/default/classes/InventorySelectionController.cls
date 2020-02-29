public with sharing class InventorySelectionController {
   
   @AuraEnabled
   public static List<InventoryListWrapper> getInvList(String KeyWord) {
   		
   		List<InventoryListWrapper> lstInvW = new List<InventoryListWrapper>();
   		if(String.isNotBlank(KeyWord)) {
	   		String strSearch = '%'+KeyWord+'%';
	   		System.debug('strSearch: '+strSearch);
	   		List<BOATBUILDING__Inventory__c> lstInv = [Select 
		   														Id, Name, BOATBUILDING__Manufacturer__c,
		   														BOATBUILDING__Model__c, BOATBUILDING__Model_Variant__c,
		   														BOATBUILDING__Year__c, BOATBUILDING__Stage__c, (Select Id from Attachments where Name like '%side__c%' limit 1)
	   												  From
	   												  			BOATBUILDING__Inventory__c
	   												  Where 
	   												  			(Name LIKE: strSearch
	   												  OR
	   												  			BOATBUILDING__Manufacturer__c LIKE: strSearch
	   												  OR
	   												  			BOATBUILDING__Model__c LIKE: strSearch
	   												  OR
	   												  			BOATBUILDING__Model_Variant__c LIKE: strSearch
	   												  OR
	   												  			BOATBUILDING__Year__c LIKE: strSearch)
	   												  AND
	   												  				(
	   												  				 (BOATBUILDING__Stage__c IN ('Ordered', 'Rigging', 'Intransit', 'In Stock', 'Marketing Photos', 'In-transit Factory', 'In-transit Raleigh')) 
   												  				AND  
   												  					(RecordType.Name != 'Used Boats' AND RecordType.Name != 'Inventory for Parts'))];
	   												  			  
	   		System.debug('lstInv: '+lstInv);
	   		for(BOATBUILDING__Inventory__c objInv: lstInv) {
	   			InventoryListWrapper objILW = new InventoryListWrapper();
	   			objILW.AttId = '';
	   			if(!objInv.Attachments.isEmpty()) {
	   				objILW.AttId = objInv.Attachments[0].Id;
	   			}
	   			objILW.objInv = objInv;
	   			lstInvW.add(objILW);  
	   		}
   		}
   		return lstInvW;
   }
}