public with sharing class RiggingHandler {
    public static void onAfterInsertWO(Map<Id, Work_Order__c> mapWO) {
    		System.debug('onAfterInsertWO: WO: '+mapWO);
    		List<Work_Order__c> lstWO = [Select 
    												Id, Boat__c, Boat__r.Boat_HIN_No__c, BOATBUILDING__Deducted_Total_Due_Amount__c, Inventory__c, Status__c
										 From 
										 		Work_Order__c Where Id IN: mapWO.keySet()];
										 		
		Set<String> setInvId = new Set<String>();								 		
		for(Work_Order__c objWO: lstWO) {
			if(objWO.Inventory__c != null && 
				objWO.Status__c.containsIgnoreCase('closed')) {
				setInvId.add(objWO.Inventory__c);
			} 
		}
		System.debug('>>>>: '+setInvId);
		if(!setInvId.isEmpty()) {
			List<Inventory__c> lstInv = [Select Id, BOATBUILDING__Rigging_Cost__c, Cost__c, (Select Id, Deducted_Total_Due_Amount__c From BOATBUILDING__Work_Orders__r) From BOATBUILDING__Inventory__c Where Id IN: setInvId];
	    		for(Inventory__c objInv: lstInv) {
	    			Decimal AmnCount = 0.00;
	    			Decimal MainCost = 0.00;
	    			Decimal RiggingExisting = 0.00;
	    			
	    			if(objInv.Cost__c != null) {
	    				MainCost = objInv.Cost__c;
	    			}
	    			
	    			if(objInv.Rigging_Cost__c != null) {
	    				RiggingExisting = objInv.Rigging_Cost__c;
	    			}
	    			objInv.Cost__c = MainCost - RiggingExisting;
	    			
	    			for(Work_Order__c objWO: objInv.BOATBUILDING__Work_Orders__r) {
	    				if(objWO.Deducted_Total_Due_Amount__c != null) {
	    					System.debug('>>>: '+objWO.Deducted_Total_Due_Amount__c); 
	    					AmnCount += objWO.Deducted_Total_Due_Amount__c ;
	    				} 
	    			}
	    			if(objInv.Rigging_Cost__c != null) {
	    				objInv.Rigging_Cost__c += AmnCount;
	    			} else {
	    				objInv.Rigging_Cost__c = AmnCount;
	    			}
	    			if(objInv.Rigging_Cost__c != null && objInv.Cost__c != null && objInv.BOATBUILDING__Cost_With_Rigging__c != null) {
	    				objInv.BOATBUILDING__Cost_With_Rigging__c += objInv.Cost__c + objInv.Rigging_Cost__c;
	    			} else if(objInv.Rigging_Cost__c != null && objInv.Cost__c != null) {
	    				objInv.BOATBUILDING__Cost_With_Rigging__c = objInv.Cost__c + objInv.Rigging_Cost__c;
	    			} else {
	    				objInv.BOATBUILDING__Cost_With_Rigging__c = 0.00;
	    			}
	    		}
	    		update lstInv;
		} 
    } 
    
    public static void updateInventoryOnWO(Map<Id, Work_Order_Job__c> mapWOJ) {
    		System.debug('updateInventoryOnWO: Job: '+mapWOJ);
    		List<Work_Order_Job__c> lstWOJ= [Select 
    												Id, BOATBUILDING__Work_Order_Warranty_Work_Order__c, Work_Type__c,
    												BOATBUILDING__Work_Order_Warranty_Work_Order__r.Status__c, 
    												BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c,
    												BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__r.Boat_HIN_No__c,
    												BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Deducted_Total_Due_Amount__c
										 From 
										 		Work_Order_Job__c Where Id IN: mapWOJ.keySet()];
										 		
		System.debug('lstWOJ: '+lstWOJ);
		Set<String> setWOId = new Set<String>();
		for(Work_Order_Job__c objWOJ: lstWOJ) {
			if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null && 
				objWOJ.Work_Type__c != null && objWOJ.Work_Type__c.containsIgnoreCase('rigging') && 
					objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Status__c.containsIgnoreCase('closed')) { 
				setWOId.add(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
			} 
		}
		
		List<Work_Order__c> lstWO = [Select 
    												Id, Boat__c, Boat__r.Boat_HIN_No__c, Inventory__c
										 From 
										 		Work_Order__c Where Id IN: setWOId];
		System.debug('lstWO: '+lstWO);
		if(!lstWO.isEmpty()) {								 		
			Set<String> setHIN = new Set<String>();
			
			for(Work_Order__c objWO: lstWO) {
				if(objWO.Boat__r.Boat_HIN_No__c != null) {
					setHIN.add(objWO.Boat__r.Boat_HIN_No__c);
				}
			}
			Map<String, String> mapInvIdHIN = new Map<String, String>();
			for(Inventory__c objInv: [Select Id, HIN_Number__c From Inventory__c Where HIN_Number__c IN: setHIN]) {
				mapInvIdHIN.put(objInv.HIN_Number__c, objInv.Id); 
			}
			System.debug('mapInvIdHIN: '+mapInvIdHIN);
			for(Work_Order__c objWO: lstWO) {
				if(objWO.Boat__r.Boat_HIN_No__c != null) {
					objWO.Inventory__c = mapInvIdHIN.get(objWO.Boat__r.Boat_HIN_No__c);
				}
			}	
			update lstWO; 
		}
    }
}