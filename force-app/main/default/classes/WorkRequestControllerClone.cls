public with sharing class WorkRequestControllerClone {
    public BOATBUILDING__Work_Order__c objWO { get; set; }
    public List<BOATBUILDING__Work_Order__c> lstWOR { get; set; }
    public List<BOATBUILDING__Work_Order__c> lstPR { get; set; }
    public BOATBUILDING__Work_Order__c objWOder { get; set; }
    
    public WorkRequestControllerClone() {
        Id recTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
        objWO = new BOATBUILDING__Work_Order__c();
        objWO.RecordTypeId = recTypeId;
		lstWOR = new List<BOATBUILDING__Work_Order__c>();
		lstPR = new List<BOATBUILDING__Work_Order__c>();
        List<BOATBUILDING__Work_Order__c> listWorkPartRequest = [SELECT Id, Name,Contact__c,Vendor__c,CreatedDate,Part_Request_Status__c,Assigned_to__c,BOATBUILDING__Request_Type__c,
                                                                Status__c, BOATBUILDING__Parts_Request_Form__c, BOATBUILDING__Part_Number__c, BOATBUILDING__Boat_Make__c 
                                                                FROM BOATBUILDING__Work_Order__c 
                                                                WHERE RecordTypeId =: recTypeId ORDER BY CreatedDate DESC];
                                                                
        for(BOATBUILDING__Work_Order__c objWO: listWorkPartRequest){
            if(objWO.BOATBUILDING__Request_Type__c == 'Work Request' && objWO.Status__c != 'WO Created'){
                lstWOR.add(objWO);
            } else if(objWO.BOATBUILDING__Request_Type__c == 'Part Request' && objWO.Status__c != 'PO Created' && objWO.Part_Request_Status__c != 'Arrived Closed'){
                lstPR.add(objWO);
            }
        }
       
        List<User> lstUser = new List<User>();
        List<userRole> lstUserRole = [ SELECT Id, Name FROM userRole WHERE Name ='Parts Manager'];
        if( !lstUserRole.isEmpty()){
              lstUser = [SELECT Id FROM User WHERE UserRoleId =: lstUserRole[0].Id];  
            }
        if(!lstUser.isEmpty()){
        objWO.BOATBUILDING__Assigned_to__c = lstUser[0].Id;
        }
        else{
           objWO.BOATBUILDING__Assigned_to__c = UserInfo.getUserId();
        }
    } 
    
    @RemoteAction
    public static List<Attachment> getAttRecords(String recordId) {
    
    	return [select Id, name from Attachment Where ParentId =: recordId];
    }
    
    
    @RemoteAction
    public static String generateWorkOrder(String recordId) {
    	try {
    		BOATBUILDING__Work_Order__c objWorkOrderWO = new BOATBUILDING__Work_Order__c();
    		BOATBUILDING__Work_Order__c objWorkOrderWWO = new BOATBUILDING__Work_Order__c();
	    	BOATBUILDING__Work_Order__c objWO = [Select  
	    												BOATBUILDING__Account__c, Boat__c, Id, Name,Contact__c, Contact__r.AccountId, Contact__r.Email, Contact__r.Phone, Vendor__c,CreatedDate,Part_Request_Status__c,Assigned_to__c,
	    												BOATBUILDING__Request_Type__c,Status__c, BOATBUILDING__Parts_Request_Form__c, BOATBUILDING__Part_Number__c, 
	    												BOATBUILDING__Boat_Make__c, Part_description__c 
												From 
														BOATBUILDING__Work_Order__c Where Id =: recordId];
														
			if(objWO.Contact__c == null && objWO.BOATBUILDING__Account__c != null) {
				Account objAcc = [Select Id, (Select Id From Contacts) From Account Where Id =: objWO.BOATBUILDING__Account__c];
				if(!objAcc.Contacts.isEmpty()) {
					objWO.Contact__c = objAcc.Contacts[0].Id;  
				}
			}											
	    	String woRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
	        String wwoRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
	    	if(objWO.Part_Description__c != null) {
	    		Set<String> setWOJobs = new Set<String>();
	    		Set<String> setWWOJobs = new Set<String>(); 
	    		if(objWO.Part_Description__c.contains(',')) {
	    			String [] strSplt = objWO.Part_Description__c.split(',');
	    			for(String str: strSplt) {
	    				if(str.containsIgnoreCase('_w')) {
	    					setWWOJobs.add(str.replace('_w', '').replace('_W', ''));
	    				} else {
	    					setWOJobs.add(str);
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
	    				objWorkOrderWO.Boat__c = objWO.Boat__c;
	    				objWorkOrderWO.Status__c = 'New';
	    			}
	    			insert objWorkOrderWO;
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
	    				objWorkOrderWWO.BOATBUILDING__ContactEmail__c = objWO.Contact__r.Email;
	    				objWorkOrderWWO.BOATBUILDING__ContactPhone__c = objWO.Contact__r.Phone;
	    				objWorkOrderWO.Boat__c = objWO.Boat__c;  
	    				objWorkOrderWWO.Status__c = 'New';
	    			}
	    			insert objWorkOrderWWO;
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
	    			return [select Id, Name From BOATBUILDING__Work_Order__c Where Id =: objWorkOrderWO.Id].Name+':WO';
	    		} else if(objWorkOrderWWO.Id != null) { 
	    			return [select Id, Name From BOATBUILDING__Work_Order__c Where Id =: objWorkOrderWWO.Id].Name+':WWO';
	    		} else {
	    			return 'FAIL';
	    		}
	    	} else {
	    		return 'Please fill description.';
	    	}
    	
    	} catch(Exception ex) {
    		System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
    		return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber();
    	}
    	
    }
    
    
    //Creates a case of work request type
    @RemoteAction
    public static String createWorkRequest(Map <String, String> mapWrkReqValues , String strFile, String fname) {
        Boolean isError = false;
        List<BOATBUILDING__Item__c> lstItem = [SELECT Id, BOATBUILDING__Boat_HIN_No__c From BOATBUILDING__Item__c WHERE BOATBUILDING__Boat_HIN_No__c =: mapWrkReqValues.get('HIN') Limit 1];
        System.debug('Debug Log For Reuest : '+mapWrkReqValues);
        
        Id recTypeId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        objWO.RecordTypeId = recTypeId;
        
		if(mapWrkReqValues.get('Id') != null && mapWrkReqValues.get('Id') != '0') {
			objWO.Id = mapWrkReqValues.get('Id');
		}
        if(mapWrkReqValues.get('partnum') != null) {
            objWO.BOATBUILDING__Part_Number__c = mapWrkReqValues.get('partnum');
        }
        if(mapWrkReqValues.get('prtdes') != null) {
            objWO.BOATBUILDING__Part_description__c = mapWrkReqValues.get('prtdes');
        }
        if(mapWrkReqValues.get('HIN') != null) {
            objWO.HIN_Number__c = mapWrkReqValues.get('HIN');
        }
        if(mapWrkReqValues.get('Boat') != null) {
            objWO.Boat__c = mapWrkReqValues.get('Boat');   
        }
        if(mapWrkReqValues.get('HIN') != null && !lstItem.isEmpty() && String.isNotBlank(lstItem[0].BOATBUILDING__Boat_HIN_No__c))  {
             objWO.BOATBUILDING__Boat__c = lstItem[0].Id;
        }
        if(mapWrkReqValues.get('vendors') != null) {
            objWO.BOATBUILDING__Vendor__c = mapWrkReqValues.get('vendors');
        }
        if(mapWrkReqValues.get('custname') != null) {
            objWO.BOATBUILDING__Contact__c = mapWrkReqValues.get('custname');
        }
        if(mapWrkReqValues.get('Wofors') != null) {
            objWO.BOATBUILDING__WO_for__c = mapWrkReqValues.get('Wofors');
        }
        
        if(mapWrkReqValues.get('invoicefors') != null) {
            objWO.BOATBUILDING__Invoice_for__c = mapWrkReqValues.get('invoicefors');
        }
        if(mapWrkReqValues.get('BoatMakes') != null) {
            objWO.BOATBUILDING__Boat_Make__c = mapWrkReqValues.get('BoatMakes');
        }
        if(mapWrkReqValues.get('BoatModle') != null) {
            objWO.BOATBUILDING__Boat_Model__c = mapWrkReqValues.get('BoatModle');
        }
        if(mapWrkReqValues.get('BoatYear') != null) {
            objWO.BOATBUILDING__Boat_Year__c = mapWrkReqValues.get('BoatYear');
        }
        if(mapWrkReqValues.get('EngineMake') != null) {
            objWO.BOATBUILDING__Engine_Make__c = mapWrkReqValues.get('EngineMake');
        }
        if(mapWrkReqValues.get('EngineModel') != null) {
            objWO.BOATBUILDING__Engine_Model__c = mapWrkReqValues.get('EngineModel');
        }
        if(mapWrkReqValues.get('EngineYear') != null) {
            objWO.BOATBUILDING__Engine_Year__c = mapWrkReqValues.get('EngineYear');
        }
        if(mapWrkReqValues.get('assingedTo') != null) {
            system.debug('@@@@@@@@' + mapWrkReqValues.get('assingedTo'));
            objWO.BOATBUILDING__Assigned_to__c = mapWrkReqValues.get('assingedTo');
        }
        if(mapWrkReqValues.get('WorkRequestStatus') != null) {
            objWO.BOATBUILDING__Status__c = mapWrkReqValues.get('WorkRequestStatus');
            system.debug(objWO.BOATBUILDING__Status__c);
        } 
        if(mapWrkReqValues.containsKey('partRequestStatus') && mapWrkReqValues.get('partRequestStatus') != null
         && UserPermissionUtil.isUpdateable('BOATBUILDING__Work_Order__c','BOATBUILDING__Part_Request_Status__c')) {
            objWO.Part_Request_Status__c = mapWrkReqValues.get('partRequestStatus');
            
        } 
        if(mapWrkReqValues.containsKey('prtReq') && mapWrkReqValues.get('prtReq') != null
            && UserPermissionUtil.isUpdateable('BOATBUILDING__Work_Order__c','BOATBUILDING__Request_Type__c')) {
            objWO.Request_Type__c = mapWrkReqValues.get('prtReq');
        }
        
        try {
            upsert objWO;
            if(mapWrkReqValues.get('prtReq') != null) {
	            if(mapWrkReqValues.get('Id') == null || mapWrkReqValues.get('Id') == '0') {
		            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
		            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
		            //Mention user here
		            mentionSegmentInput.id = objWO.BOATBUILDING__Assigned_to__c;
		            messageBodyInput.messageSegments.add(mentionSegmentInput);
		            String strTC = '\n'+'Hi,\n A new '+objWO.Request_Type__c+' is assigned to you.\nPlease have a look.\nThanks\n\n';
		            textSegmentInput.text = strTC;
		            messageBodyInput.messageSegments.add(textSegmentInput);
		            entityLinkSegmentInput.entityId = objWO.Id;
	                messageBodyInput.messageSegments.add(entityLinkSegmentInput);
	                ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
					linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type='+objWO.Request_Type__c.replaceAll(' ', '')+'&prId='+objWO.Id;
					linkInput.urlName = 'Click here to open in Service App';
					ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
					feedElementCapabilitiesInput.link = linkInput;
					feedItemInput.capabilities = feedElementCapabilitiesInput;
		            feedItemInput.body = messageBodyInput;
		            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		            feedItemInput.subjectId = objWO.Id;
		            
		            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
		            batchInputs.add(batchInput);
		            ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
	            }
                 if(String.isNotBlank(strFile)) {
                	Attachment a = new Attachment (ParentId = objWO.Id,
	                                       Body = EncodingUtil.base64Decode(strFile.subString(strFile.indexOfIgnoreCase('base64,') +7, strFile.length()-1)),
	                                       Name = fname);
                    
                    
                   
	            	insert a;
                }
	        } 
            return objWO.Id;
        }
        catch(Exception ex) {
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
            return 'Fail: '+ex.getStackTraceString() + ex.getMessage() + ex.getCause() +ex.getTypeName() ;
        }
    } 
    @RemoteAction 
    public static List<Object> fetchWorkOrders(String objWOId) {
        list<object> lstobjwo = new  list<object>();
        BOATBUILDING__Work_Order__c objWko = [select Id,Name,
                                              Part_Number__c,
                                              Part_description__c,
                                              Vendor__c,
                                              Contact__c,
                                              Contact__r.FirstName,
                                              Contact__r.LastName,
                                              WO_for__c,
                                              HIN_Number__c,
                                              Part_Request_Status__c,
                                              WO_for__r.name,
                                              Invoice_for__c,
                                              Invoice_for__r.Name,
                                              Boat_Make__c,
                                              Boat_Model__c,
                                              Boat_Year__c,
                                              Engine_Make__c,
                                              Engine_Model__c,
                                              Engine_Year__c,
                                              Assigned_to__c,
                                              Assigned_to__r.Name,
                                              Status__c,
                                              BOATBUILDING__Boat__c,
                                              BOATBUILDING__Boat__r.Name,
                                              Request_Type__c
                                               
                                              FROM 
                                              BOATBUILDING__Work_Order__c
                                              WHERE  
                                              Id =: objWOId 
                                              LIMIT 
                                              1];
        
        
        lstobjwo.add(objWko);
        
        return lstobjwo;
        
        
    }
    @RemoteAction
	public static BOATBUILDING__Item__c fetchItem(String strItemId) {
        List<BOATBUILDING__Item__c> lstItem = (List<BOATBUILDING__Item__c>)WorkRequestLightningCompController.fetchItem(strItemId);
		return lstItem[0];
	}
}