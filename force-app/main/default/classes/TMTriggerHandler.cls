public with sharing class TMTriggerHandler {
	
	public static void doChatterPost(List<BOATBUILDING__Time_Management__c> lstTM, Map<Id,BOATBUILDING__Time_Management__c> newMapTM, Map<Id,BOATBUILDING__Time_Management__c> oldMapTM, Boolean isInsert, Boolean isUpdate){
		if(!Test.isRunningTest()) {
			List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
			List<BOATBUILDING__Time_Management__c> lstTimeMgmt = [SELECT Id,BOATBUILDING__Related_Work_Order_Job__c, Service_writer_comment__c,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.OwnerId, BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c,
			                                                              BOATBUILDING__Clock_In__c,BOATBUILDING__Clock_Out__c,
			                                                              
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId,
			                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c
			                                                               
	                                                              FROM BOATBUILDING__Time_Management__c WHERE Id IN: newMapTM.KeySet() 
	                                                              AND RecordType.DeveloperName = 'Time_Management_for_Jobs'];
	        Map<String, String> MapAccId = new Map<String, String>();
	        Map<String, String> MapAccIdWONameNJN = new Map<String, String>();
	        Map<String, String> MapBoatId = new Map<String, String>();                                                      
	        for(BOATBUILDING__Time_Management__c objTimeMgmt: lstTimeMgmt) { 
	        	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__c != null) { 
		        	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
		            if(isUpdate && objTimeMgmt.Service_writer_comment__c != null 
		               && objTimeMgmt.Service_writer_comment__c != oldMapTM.get(objTimeMgmt.Id).Service_writer_comment__c) 
		            {
		            	
		            	
		            	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		                //Mention user here
		                mentionSegmentInput.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		                messageBodyInput.messageSegments.add(mentionSegmentInput);
		                String strTC = '\n'+'Hi,\n  New Comment added for Service Writer on job,\nWork Order Number: ' + objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c+ '\n\n';
		                String cmnt = '';
		                if(oldMapTM.get(objTimeMgmt.Id).Service_writer_comment__c != null) {
		                	if(objTimeMgmt.Service_writer_comment__c.contains(oldMapTM.get(objTimeMgmt.Id).Service_writer_comment__c)) {
		                		strTC += 'Comment: '+objTimeMgmt.Service_writer_comment__c.remove(oldMapTM.get(objTimeMgmt.Id).Service_writer_comment__c);
		                		cmnt = objTimeMgmt.Service_writer_comment__c.remove(oldMapTM.get(objTimeMgmt.Id).Service_writer_comment__c);
		                	} else {
		                		strTC += 'Comment: '+objTimeMgmt.Service_writer_comment__c;
		                		cmnt = objTimeMgmt.Service_writer_comment__c;
		                	}
		                } else {
		                	strTC += 'Comment: '+objTimeMgmt.Service_writer_comment__c;
		                	cmnt = objTimeMgmt.Service_writer_comment__c;
		                }
		                strTC += '\n\n';
		                textSegmentInput.text = strTC;
		                messageBodyInput.messageSegments.add(textSegmentInput);
		                
		                entityLinkSegmentInput.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
		                messageBodyInput.messageSegments.add(entityLinkSegmentInput);
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
		                	ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
		                		
		                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
		                	} else {
		                		
		                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
		                	}
		                	linkInput.urlName = 'Click here to open in Service App';
							ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
							feedElementCapabilitiesInput.link = linkInput;
							feedItemInput.capabilities = feedElementCapabilitiesInput;
		                }
		                feedItemInput.body = messageBodyInput;
		                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		                feedItemInput.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
		                
		                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
		                batchInputs.add(batchInput);
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
		                	&& objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
		                	MapAccId.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, cmnt);
		                	MapAccIdWONameNJN.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
		                							objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
		                								+'~'+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c);
		                	ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
				            ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
				            ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
				            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
				            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
		                	messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			                //Mention user here
			                 
		                	//mentionSegmentInput1.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		               		//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
			            	
			            	textSegmentInput1.text = strTC;
			                messageBodyInput1.messageSegments.add(textSegmentInput1);
			                entityLinkSegmentInput1.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
			                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
			                	ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
			                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	} else {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	}
			                	linkInput1.urlName = 'Click here to open in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
			                }
			                feedItemInput1.body = messageBodyInput1;
			                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
			                feedItemInput1.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
			                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
			                batchInputs.add(batchInput1);	
		                }
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
		                	MapBoatId.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, cmnt);
		                	MapAccIdWONameNJN.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
		                							objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
		                								+'~'+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c);
		                	ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
				            ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
				            ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
				            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
				            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
		                	messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			                //Mention user here
			                 
		                	//mentionSegmentInput1.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		               		//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
			            	 
			            	textSegmentInput1.text = strTC;
			                messageBodyInput1.messageSegments.add(textSegmentInput1);
			                entityLinkSegmentInput1.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
			                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
			                	ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
			                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	} else {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	}
			                	linkInput1.urlName = 'Click here to open in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
			                }
			                feedItemInput1.body = messageBodyInput1;
			                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
			                feedItemInput1.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
			                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
			                batchInputs.add(batchInput1);
		                }
		                
		            } else if(isInsert && objTimeMgmt.Service_writer_comment__c != null) {
		            	messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		                //Mention user here
		                mentionSegmentInput.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		                messageBodyInput.messageSegments.add(mentionSegmentInput);
		                String strTC = '\n'+'Hi,\n  New Comment added for Service Writer on job,\nWork Order Number: ' + objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c+ '\n\n';
		               	strTC += 'Comment: '+objTimeMgmt.Service_writer_comment__c;
		               	String cmnt = +objTimeMgmt.Service_writer_comment__c;
		               	strTC += '\n\n';
		                textSegmentInput.text = strTC;
		                messageBodyInput.messageSegments.add(textSegmentInput);
		                entityLinkSegmentInput.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
		                messageBodyInput.messageSegments.add(entityLinkSegmentInput);
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
		                	ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
		                		
		                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
		                	} else {
		                		
		                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
		                	}
		                	linkInput.urlName = 'Click here to open in Service App';
							ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
							feedElementCapabilitiesInput.link = linkInput;
							feedItemInput.capabilities = feedElementCapabilitiesInput;
		                }
		                feedItemInput.body = messageBodyInput;
		                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		                feedItemInput.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c;//objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
		                batchInputs.add(batchInput);
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
		                	&& objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
		                	MapAccId.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, cmnt);
		                	MapAccIdWONameNJN.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
		                							objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
		                								+'~'+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c);	
		                	ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
				            ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
				            ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
				            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
				            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
		                	messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			                //Mention user here
			                 
		                	//mentionSegmentInput1.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		               		//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
			            	
			            	textSegmentInput1.text = strTC;
			                messageBodyInput1.messageSegments.add(textSegmentInput1);
			                entityLinkSegmentInput1.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
			                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
			                	ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
			                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	} else {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	}
			                	linkInput1.urlName = 'Click here to open in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
			                }
			                feedItemInput1.body = messageBodyInput1;
			                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
			                feedItemInput1.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
			                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
			                batchInputs.add(batchInput1);	
		                } 
		                if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
		                	MapBoatId.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, cmnt);
		                	MapAccIdWONameNJN.put(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
		                							objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
		                								+'~'+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.Job_Name__c);
		                	ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
				            ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
				            ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
				            ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
				            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
		                	messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
			                //Mention user here
			                 
		                	//mentionSegmentInput1.id = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
		               		//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
			            	
			            	textSegmentInput1.text = strTC;
			                messageBodyInput1.messageSegments.add(textSegmentInput1);
			                entityLinkSegmentInput1.entityId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
			                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
		                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
			                	ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
			                	if(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	} else {
			                		
			                		linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
			                	}
			                	linkInput1.urlName = 'Click here to open in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
			                }
			                feedItemInput1.body = messageBodyInput1;
			                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
			                feedItemInput1.subjectId = objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
			                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
			                batchInputs.add(batchInput1);
		                	
		                }
		            }
	            }
	        }
	        ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
	        System.debug('Debug Log For objCA_BR: '+objCA_BR);
	        if(!MapAccId.isEmpty()) {
	        	createActivity(MapAccId, MapAccIdWONameNJN);
	        }
	        //if(!MapAccId.isEmpty()) {
	        //	createActivity(MapAccId);
	        //}
	        if(!MapBoatId.isEmpty()) {
	        	createActivity(MapBoatId, MapAccIdWONameNJN); 
	        }
		}
	}
	public static void createActivity(Map<String, String> mapAccId, Map<String, String> MapAccIdWONameNJN) {
		List<Event> lstTask = new List<Event>();
		for(String setStr: mapAccId.keySet()) {
			Event objTask = new Event(); 
			
			if(MapAccIdWONameNJN.get(setStr).contains('~')) {
				String[] strSpltVal = MapAccIdWONameNJN.get(setStr).split('~');
				objTask.Subject = 'Comment on '+strSpltVal[0]+'\'s Job: '+strSpltVal[1];
			} else {
				objTask.Subject = 'Comment on Job';
			}
			//objTask.Status = 'Completed';
			objTask.ActivityDate = Date.today();
			objTask.WhatId = setStr;
			objTask.Description = mapAccId.get(setStr);
			objTask.DurationInMinutes = 0;
			objTask.ActivityDateTime = datetime.now();
			lstTask.add(objTask);
		}
		insert lstTask;
	}
	public static void updateWOStatus(List<BOATBUILDING__Time_Management__c> lstTM, Map<Id, BOATBUILDING__Time_Management__c> newMapTM) {
		list<BOATBUILDING__Time_Management__c> lstTimeMgmt = [SELECT Id,BOATBUILDING__Related_Work_Order_Job__r.Id,
                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                                                              BOATBUILDING__Clock_In__c,BOATBUILDING__Clock_Out__c 
                                                              FROM BOATBUILDING__Time_Management__c WHERE Id IN: newMapTM.KeySet() 
                                                              AND RecordType.DeveloperName = 'Time_Management_for_Jobs'];
        
        System.debug('>>>>>lstTimeMgmt: '+lstTimeMgmt);
        set<String> setStr = new set<String>();
        
        for(BOATBUILDING__Time_Management__c objTimeMgmt: lstTimeMgmt) {
            setStr.add(objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
        }
        List<BOATBUILDING__Work_Order__c> lstWO = [SELECT Id,BOATBUILDING__Status__c,(SELECT Id,BOATBUILDING__Completed__c FROM Work_Order_Jobs__r) 
                                                   FROM BOATBUILDING__Work_Order__c WHERE Id IN: setStr ];
        
        System.debug('>>>>>lstWO: '+lstWO);
        set<String> setWO2Id = new set<String>();
        for(BOATBUILDING__Work_Order__c objWO :lstWO) {
            integer completedJob = 0;
            for(BOATBUILDING__Work_Order_Job__c objWOJ :objWO.Work_Order_Jobs__r) {
                if(objWOJ.BOATBUILDING__Completed__c)
                {
                    completedJob++;      
                }
            }
            System.debug('>>>>>completedJob: '+completedJob);
            if(objWO.Work_Order_Jobs__r.size() == completedJob)
            {
                objWO.BOATBUILDING__Status__c = 'Waiting On Payment';	    
            }
            else
            {
                    setWO2Id.add(objWO.Id);
            }
            System.debug('>>>>>objWO.BOATBUILDING__Status__c: '+objWO.BOATBUILDING__Status__c);
        }
        list<BOATBUILDING__Time_Management__c> lstTimeMgmt2 = [SELECT Id,BOATBUILDING__Related_Work_Order_Job__r.Id,
                                                              BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                                                              BOATBUILDING__Clock_In__c,BOATBUILDING__Clock_Out__c 
                                                              FROM BOATBUILDING__Time_Management__c WHERE BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c IN: setWO2Id 
                                                              AND RecordType.DeveloperName = 'Time_Management_for_Jobs' ORDER BY CreatedDate DESC];
    
    	if(!lstTimeMgmt2.isEmpty()) {
	    	System.debug('>>>>>lstTimeMgmt2: '+lstTimeMgmt2);
	    	Map<String, List<BOATBUILDING__Time_Management__c>> mapWOTM = new Map<String, List<BOATBUILDING__Time_Management__c>>(); 
	    	for(BOATBUILDING__Time_Management__c objIM: lstTimeMgmt2) {
	    		if(!mapWOTM.containsKey(objIM.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c)) {
	    			mapWOTM.put(objIM.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c, new List<BOATBUILDING__Time_Management__c>());
	    		}
	    		if(mapWOTM.containsKey(objIM.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c)) {
	    			mapWOTM.get(objIM.BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Work_Order_Warranty_Work_Order__c).add(objIM);
	    		}
	    	}
	    	System.debug('>>>>>mapWOTM: '+mapWOTM);
	    	for(BOATBUILDING__Work_Order__c objWO :lstWO) {
	            if(setWO2Id.contains(objWO.Id)) {
	            	BOATBUILDING__Time_Management__c objTM = mapWOTM.get(objWO.Id)[0];
	            	if(objTM.BOATBUILDING__Clock_In__c != null && objTM.BOATBUILDING__Clock_Out__c != null) {
	            		objWO.BOATBUILDING__Status__c = 'Scheduled';
	            	} else if(objTM.BOATBUILDING__Clock_In__c == null && objTM.BOATBUILDING__Clock_Out__c == null) {
	            		objWO.BOATBUILDING__Status__c = 'Scheduled';
	            	} else if(objTM.BOATBUILDING__Clock_In__c != null && objTM.BOATBUILDING__Clock_Out__c == null) {
	            		objWO.BOATBUILDING__Status__c = 'In Progress';
	            	}
	            } else {
	            	objWO.BOATBUILDING__Status__c = 'Scheduled';
	            }
	        }
	        System.debug('>>>>>lstWO: '+lstWO);
	        
    	}
    	update lstWO;	
	}
	
    public static void updateName(List<Time_Management__c> lstTM) {
        Set<String> setWOId = new Set<String>();
        Set<String> setJobId = new Set<String>();
        Set<String> setInvId = new Set<String>();
        Set<String> setQuoteId = new Set<String>();
        Set<String> setCustId = new Set<String>();
        Map<String, String> mapIdName = new Map<String, String>();
        
        for(Time_Management__c objTM: lstTM) {
            if(objTM.Contact__c != null) {
                setCustId.add(objTM.Contact__c);
            }
            if(objTM.Work_Order__c != null) {
                setWOId.add(objTM.Work_Order__c);
            }
            if(objTM.Related_Work_Order_Job__c != null) {
                setJobId.add(objTM.Related_Work_Order_Job__c);
            } 
            if(objTM.Inventory__c != null) {
                setInvId.add(objTM.Inventory__c);
            } 
            if(objTM.Quote__c != null) {
                setQuoteId.add(objTM.Quote__c);
            } 
        }
        
        for(Contact objCon: [Select Id, Name From Contact Where Id IN: setCustId]) {
            mapIdName.put(objCon.Id, objCon.Name); 
        }
        
        for(Work_Order__c objWO: [Select Id, Name, Contact__c, Contact__r.Name, Boat__r.Name, Boat__c From Work_Order__c Where Id IN: setWOId]) {
        	if(objWO.Boat__c != null && objWO.Contact__c != null) {
        		mapIdName.put(objWO.Id, objWO.Name + ' - ' + objWO.Contact__r.Name + objWO.Boat__r.Name);
        	}
            else if(objWO.Contact__c != null) {
                mapIdName.put(objWO.Id, objWO.Name + ' - ' + objWO.Contact__r.Name); 
            } 
            else {
                mapIdName.put(objWO.Id, objWO.Name);    
            }
        }
        
        for(Inventory__c objInv: [Select Id, Name From Inventory__c Where Id IN: setInvId]) {
            mapIdName.put(objInv.Id, objInv.Name); 
        }
        
        for(Quote__c objQt: [Select Id, Name From Quote__c Where Id IN: setQuoteId]) {
            mapIdName.put(objQt.Id, objQt.Name); 
        }
        Map<String, String> mapIdInv = new Map<String, String>();
        for(Work_Order_Job__c objWOJ: [Select Id, Name, Work_Order_Warranty_Work_Order__c, Work_Order_Warranty_Work_Order__r.Contact__c, Work_Order_Warranty_Work_Order__r.Contact__r.Name From Work_Order_Job__c Where Id IN: setJobId]) {
            if(objWOJ.Work_Order_Warranty_Work_Order__c != null && objWOJ.Work_Order_Warranty_Work_Order__r.Contact__c != null) {
                mapIdName.put(objWOJ.Id, objWOJ.Name + ' - ' + objWOJ.Work_Order_Warranty_Work_Order__r.Contact__r.Name);    
            } else { 
                mapIdName.put(objWOJ.Id, objWOJ.Name);
            }
            
        }
        
        for(Time_Management__c objTM: lstTM) {
            
            if(objTM.Type__c == 'Test Drive' && objTM.Contact__c != null) {
                objTM.Event_Name__c =  'Test Drive ' + mapIdName.get(objTM.Contact__c); 
            } else if(objTM.Contact__c != null) {
                    objTM.Event_Name__c = objTM.Type__c+ ' : ' +mapIdName.get(objTM.Contact__c);
            }  
            
            if(objTM.Work_Order__c != null && mapIdName.containsKey(objTM.Work_Order__c)) {
                objTM.Event_Name__c = mapIdName.get(objTM.Work_Order__c);
            }
            else if(objTM.Related_Work_Order_Job__c != null) {
                objTM.Event_Name__c = mapIdName.get(objTM.Related_Work_Order_Job__c);
            } 
            else if(objTM.Quote__c != null) {
                    String str= '';
                    if(objTM.Contact__c != null) {
                        str = mapIdName.get(objTM.Contact__c)+' ('+objTM.Type__c+')';
                    } 
                    else{
                        if(mapIdName.containsKey(objTM.Quote__c)){
                          str = objTM.Type__c+' ('+mapIdName.get(objTM.Quote__c)+')';
                        }
                        else
                        {
                         str = objTM.Type__c;
                        }
                    }
                    
                objTM.Event_Name__c =  /*mapIdName.get(objTM.Quote__c) + ' ' +*/ str;
            }
            else if(objTM.Inventory__c != null) {  
                    String str= '';
                    if(objTM.Contact__c != null) {
                        str = mapIdName.get(objTM.Contact__c)+' ('+objTM.Type__c+')';
                    }
                    else
                    {
                        if(mapIdName.containsKey(objTM.Inventory__c)){
                            str = objTM.Type__c+' ('+mapIdName.get(objTM.Inventory__c)+')';
                        }
                        else
                        {
                            str = objTM.Type__c;
                        }
                        
                    }
                objTM.Event_Name__c = /*mapIdName.get(objTM.Inventory__c) + ' ' +*/ str;
            }
            if(objTM.Inventory__c == null && objTM.Quote__c == null &&  objTM.Related_Work_Order_Job__c == null && objTM.Contact__c == null && objTM.Work_Order__c == null){
                objTM.Event_Name__c = objTM.Type__c+' Event';
            }
        }
    }
}