public class WorkRequestLightningCompController {
     public BOATBUILDING__Work_Order__c objWO { get; set; }
     @AuraEnabled
    public static Id getRecTypeId(){
        Id recid = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();        
        return recid;
    }    
    @AuraEnabled
    public static String generateWorkOrder(String recordId) {
    	try {
    		BOATBUILDING__Work_Order__c objWorkOrderWO = new BOATBUILDING__Work_Order__c();
			BOATBUILDING__Work_Order__c objWorkOrderWWO = new BOATBUILDING__Work_Order__c();
			
			
            BOATBUILDING__Work_Order__c objWO = [Select  
                                                 BOATBUILDING__Account__c, Boat__c, Id, Name,Contact__c, Contact__r.AccountId, Contact__r.Email, 
                                                 Contact__r.Phone, Vendor__c,CreatedDate,Part_Request_Status__c,Assigned_to__c,
                                                 BOATBUILDING__Request_Type__c,Status__c, BOATBUILDING__Parts_Request_Form__c, BOATBUILDING__Store_Location__c,
                                                 BOATBUILDING__Part_Number__c, BOATBUILDING__Source__c,
                                                 BOATBUILDING__Boat_Make__c, Part_description__c 
                                                 From 
												 BOATBUILDING__Work_Order__c Where Id =: recordId];
											 
			 BOATBUILDING__Dealership_Form__c[]	 objDf  = [select Id ,BOATBUILDING__Work_Order__c from BOATBUILDING__Dealership_Form__c  where BOATBUILDING__Work_Order__c =: recordId limit 1] ;
			
		
			if(objWO.Status__c == 'WO Created') {
				return 'Error: Work Order is already generated.';
			}

            if(objWO.Contact__c == null && objWO.BOATBUILDING__Account__c != null) {
				Account objAcc = [Select Id, (Select Id From Contacts) From Account Where Id =: objWO.BOATBUILDING__Account__c];
				if(!objAcc.Contacts.isEmpty()) {
					objWO.Contact__c = objAcc.Contacts[0].Id;  
				}
			}											
	    	String woRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
	        String wwoRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
	    	if(String.isNotBlank(objWO.Part_Description__c)) {
	    		Set<String> setWOJobs = new Set<String>();
	    		Set<String> setWWOJobs = new Set<String>(); 
	    		if(objWO.Part_Description__c.contains(',')) {
	    			String [] strSplt = objWO.Part_Description__c.split(',');
	    			for(String str: strSplt) {
						if(String.isNotBlank(str.trim())) {
							if(str.containsIgnoreCase('_w')) {
								setWWOJobs.add(str.replace('_w', '').replace('_W', ''));
							} else {
								setWOJobs.add(str);
							}	
						}
	    			}
	    		} else {
	    			if(objWO.Part_Description__c.containsIgnoreCase('_w')) {
						setWWOJobs.add(objWO.Part_Description__c.replace('_w', '').replace('_W', ''));
					} else {
						setWOJobs.add(objWO.Part_Description__c);
					}
	    		} 
	    		List<BOATBUILDING__Work_Order__c> lstWO = new List<BOATBUILDING__Work_Order__c>();
	    		System.debug('Debug Log For setWOJobs: '+setWOJobs);
	    		System.debug('Debug Log For setWWOJobs: '+setWWOJobs); 
	    		if(!setWOJobs.isEmpty()) { 
	    			
	    			objWorkOrderWO.RecordTypeId = woRT;
	    			if(objWO.Contact__c != null) {
	    				objWorkOrderWO.Contact__c = objWO.Contact__c;
	    				if(objWO.BOATBUILDING__Account__c != null) {
	    					objWorkOrderWO.BOATBUILDING__Account__c = objWO.BOATBUILDING__Account__c;
	    				}  else if(objWO.Contact__c != null && objWO.Contact__r.AccountId != null) {
	    					objWorkOrderWO.BOATBUILDING__Account__c = objWO.Contact__r.AccountId;
	    				}
	    				objWorkOrderWO.BOATBUILDING__ContactEmail__c = objWO.Contact__r.Email;
						objWorkOrderWO.BOATBUILDING__ContactPhone__c = objWO.Contact__r.Phone;
						if(objWO.BOATBUILDING__Store_Location__c != null)
							objWorkOrderWO.BOATBUILDING__Store_Location__c = objWO.BOATBUILDING__Store_Location__c;
						objWorkOrderWO.Boat__c = objWO.Boat__c;
						objWorkOrderWO.BOATBUILDING__Source__c = objWO.BOATBUILDING__Source__c;
	    				objWorkOrderWO.Status__c = 'Quote';
	    			}
					insert objWorkOrderWO;
					
					/*** New */
					if(objDf != null  && String.isNotBlank(objWorkOrderWO.Id) ){
						for( BOATBUILDING__Dealership_Form__c obj : objDf ){
							if(!Approval.isLocked(obj.Id)){
								obj.BOATBUILDING__Work_Order__c = objWorkOrderWO.Id ;
								update objDf;
							}
						
						}

					}
					
	    			List<Work_Order_Job__c> lstWOJ = new List<Work_Order_Job__c>();
	    			for(String strJN: setWOJobs) {
	    				Work_Order_Job__c objWOJ = new Work_Order_Job__c();
	    				objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objWorkOrderWO.Id;
	    				objWOJ.Job_Name__c = strJN;
	    				lstWOJ.add(objWOJ);
	    			} 
	    			
	    			insert lstWOJ;
	    		}
	    		if(!setWWOJobs.isEmpty()) {
	    			//BOATBUILDING__Work_Order__c objWorkOrder = new BOATBUILDING__Work_Order__c();
	    			System.debug('Debug Log For wwoRT: '+wwoRT);
	    			objWorkOrderWWO.RecordTypeId = wwoRT;
	    			if(objWO.Contact__c != null) {
	    				objWorkOrderWWO.Contact__c = objWO.Contact__c;  
	    				//objWorkOrderWWO.BOATBUILDING__Account__c = objWO.Contact__r.AccountId;
	    				if(objWO.BOATBUILDING__Account__c != null) {
	    					objWorkOrderWWO.BOATBUILDING__Account__c = objWO.BOATBUILDING__Account__c;
	    				}  else if(objWO.Contact__c != null && objWO.Contact__r.AccountId != null) {
	    					objWorkOrderWWO.BOATBUILDING__Account__c = objWO.Contact__r.AccountId;
						} 
						if(objWO.BOATBUILDING__Store_Location__c != null)
							objWorkOrderWO.BOATBUILDING__Store_Location__c = objWO.BOATBUILDING__Store_Location__c;
	    				objWorkOrderWWO.BOATBUILDING__ContactEmail__c = objWO.Contact__r.Email;
	    				objWorkOrderWWO.BOATBUILDING__ContactPhone__c = objWO.Contact__r.Phone;
						objWorkOrderWWO.Boat__c = objWO.Boat__c;  
						objWorkOrderWO.BOATBUILDING__Source__c = objWO.BOATBUILDING__Source__c;
						objWorkOrderWWO.Status__c = 'Quote';
						
	    			}
					insert objWorkOrderWWO;

					if(objDf != null  && String.isNotBlank(objWorkOrderWWO.Id) ){
					     for( BOATBUILDING__Dealership_Form__c obj2 : objDf ){
							if(!Approval.isLocked(obj2.Id)){
								obj2.BOATBUILDING__Work_Order__c = objWorkOrderWWO.Id ;
								update objDf;
							}
						}

					} 
					
	    			List<Work_Order_Job__c> lstWOJ = new List<Work_Order_Job__c>();
	    			for(String strJN: setWWOJobs) {
	    				Work_Order_Job__c objWOJ = new Work_Order_Job__c();
	    				objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c = objWorkOrderWWO.Id;
	    				objWOJ.Job_Name__c = strJN; 
	    				lstWOJ.add(objWOJ); 
	    			}
	    			
	    			insert lstWOJ;
	    			System.debug('Debug Log For lstWOJ: '+lstWOJ);
	    		}
	    		objWO.Status__c = 'WO Created';  
	    		update objWO;
	    		if(objWorkOrderWO.Id != null) {
	    			return objWorkOrderWO.Id;
	    		} else if(objWorkOrderWWO.Id != null) { 
	    			return objWorkOrderWWO.Id;
	    		} else {
	    			return 'Error: FAIL';
	    		}
	    	} else {
	    		return 'Error: Please fill description.';
	    	}
    	
    	} catch(Exception ex) {
    		System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
    	}
    	
    }
	
	@AuraEnabled
	public static Object fetchItem(String strItemId){
		return [SELECT Id, Boat_HIN_No__c, Engine_SN__c, BOATBUILDING__Engine_1_Serial_Number__c, BOATBUILDING__Engine_2_Serial_Number__c, BOATBUILDING__Engine_3_Serial_Number__c, BOATBUILDING__Engine_4_Serial_Number__c, Boat_Manufacture_Date__c, Trailer_VIN__c, Boat_Manufacturer__c, Boat_Manufacturer__r.Name, Boat_Model__c, M_Boat_Year__c FROM BOATBUILDING__Item__c where Id =: strItemId];
	}
	@AuraEnabled
	public static string cpOfWR(String wrId){
		BOATBUILDING__Work_Order__c objWO = [Select Id, Name, BOATBUILDING__Assigned_to__c, CreatedDate, LastModifiedDate From BOATBUILDING__Work_Order__c Where Id =: wrId];
		if(objWO.BOATBUILDING__Assigned_to__c != null
			&& objWO.CreatedDate == objWO.LastModifiedDate) {
			//PartRequestLightningCompController.doChatterPost(objWO.BOATBUILDING__Assigned_to__c, 'Work Request', objWO.Id);
		}
		return 'SUCCESS';
	}
}