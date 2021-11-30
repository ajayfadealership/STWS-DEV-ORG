public class RollUpSummaryUtility {
    
    public static void doChatterPost(List<Work_Order_Job__c> lstJob, Map<id,Work_Order_Job__c> oldMapJob, Boolean isInsert, Boolean isUpdate){
		try {
    		DOChatterPost objDOChatterPost = new DOChatterPost(lstJob, oldMapJob, isInsert, isUpdate);
			System.enqueueJob(objDOChatterPost);
		} catch(Exception ex) {System.debug('>>>>>>>ex: '+ex);}
    }
    
    public class DOChatterPost implements Queueable, Database.AllowsCallouts {
		List<Work_Order_Job__c> lstJob;
		Map<id,Work_Order_Job__c> oldMapJob;
		Boolean isInsert;
		Boolean isUpdate;
		public DOChatterPost(List<Work_Order_Job__c> lstJob, Map<id,Work_Order_Job__c> oldMapJob, Boolean isInsert, Boolean isUpdate) {
			this.lstJob = lstJob;
			this.oldMapJob = oldMapJob;
			this.isInsert = isInsert;
			this.isUpdate = isUpdate;
		}
		public void execute(QueueableContext context) {
			System.debug('>>>>>>>doChatterPost: ');
			if(!Test.isRunningTest()) {
				Set<String> setWOJID = new Set<String>(); 
				for(Work_Order_Job__c objWOJ: lstJob){
					setWOJID.add(objWOJ.Id);
				}
				
				Map<Id, Work_Order_Job__c> mapWOJ = new Map<Id, Work_Order_Job__c>([Select Id, BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName, 
																					BOATBUILDING__Work_Order_Warranty_Work_Order__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name, 
																					BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c, 
																					BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId,
																					BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c 
																					From Work_Order_Job__c Where Id IN: setWOJID]);
				
				
				
				List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
				Map<String, String> mapAccId = new Map<String, String>();
				Map<String, String> MapAccIdWONameNJN = new Map<String, String>();
				Map<String, String> MapBoatId = new Map<String, String>();
				for(Work_Order_Job__c objWOJ: lstJob){
					ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
					ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
					ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
					ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
					ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
					if(isUpdate && objWOJ.BOATBUILDING__Comments__c != null 
					&& objWOJ.BOATBUILDING__Comments__c != oldMapJob.get(objWOJ.Id).BOATBUILDING__Comments__c && objWOJ.BOATBUILDING__Technician__c != null) 
					{
						System.debug('>>>>>>>doChatterPost objWOJ.ID: '+objWOJ.Id);
						messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
						//Mention user here
						if(objWOJ.BOATBUILDING__Technician__c != null) { 
							mentionSegmentInput.id = objWOJ.BOATBUILDING__Technician__c;
							messageBodyInput.messageSegments.add(mentionSegmentInput);
						}
						String strTC = '\n'+'Hi,\n  New Comment added for Technician on job, \nWork Order Number: ' + mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objWOJ.Job_Name__c+ '\n\n';
						String cmnt = ''; 
						if(oldMapJob.get(objWOJ.Id).BOATBUILDING__Comments__c != null) {
							if(objWOJ.BOATBUILDING__Comments__c.contains(oldMapJob.get(objWOJ.Id).BOATBUILDING__Comments__c)) {
								strTC += 'Comment: '+objWOJ.BOATBUILDING__Comments__c.remove(oldMapJob.get(objWOJ.Id).BOATBUILDING__Comments__c);
								cmnt = objWOJ.BOATBUILDING__Comments__c.remove(oldMapJob.get(objWOJ.Id).BOATBUILDING__Comments__c);
							} else {
								strTC += 'Comment: '+objWOJ.BOATBUILDING__Comments__c;
								cmnt = objWOJ.BOATBUILDING__Comments__c;
							}
						} else {
							strTC += 'Comment: '+objWOJ.BOATBUILDING__Comments__c;
							cmnt = objWOJ.BOATBUILDING__Comments__c;
						}
						strTC += '\n\n';
						textSegmentInput.text = strTC;
						messageBodyInput.messageSegments.add(textSegmentInput);
						entityLinkSegmentInput.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
						messageBodyInput.messageSegments.add(entityLinkSegmentInput);
						
						if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
							ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
							if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
							{
								linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
							} 
							else 
							{
								linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
							}
							linkInput.urlName = 'Click here to open in Service App';
							ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
							feedElementCapabilitiesInput.link = linkInput;
							feedItemInput.capabilities = feedElementCapabilitiesInput;
						}
						feedItemInput.body = messageBodyInput;
						feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
						feedItemInput.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
						ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
						System.debug('>>>>>>>Add 1: '+batchInput); 
						batchInputs.add(batchInput);
						if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
							&& mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
							mapAccId.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, cmnt);
							
							
							MapAccIdWONameNJN.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
														mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
															+'~'+objWOJ.Job_Name__c);
							
							
							ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
							ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
							ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
							ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
							messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							//Mention user here
							if(objWOJ.BOATBUILDING__Technician__c != null) { 
								//mentionSegmentInput1.id = objWOJ.BOATBUILDING__Technician__c;
								//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
							}
							textSegmentInput1.text = strTC;
							messageBodyInput1.messageSegments.add(textSegmentInput1);
							entityLinkSegmentInput1.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
							messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
							if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
								ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
								if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								} 
								else 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								}
								linkInput1.urlName = 'Click here to open WO/WWO in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
							}
							feedItemInput1.body = messageBodyInput1;
							feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
							feedItemInput1.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
							ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1);
							System.debug('>>>>>>>Add 2: '+batchInput1); 
							batchInputs.add(batchInput1);	
						}
						if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
							MapBoatId.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, cmnt);
							
							MapAccIdWONameNJN.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
														mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
															+'~'+objWOJ.Job_Name__c);
							
							ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
							ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
							ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
							ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
							messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							//Mention user here
							if(objWOJ.BOATBUILDING__Technician__c != null) { 
								//mentionSegmentInput1.id = objWOJ.BOATBUILDING__Technician__c;
								//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
							}
							textSegmentInput1.text = strTC;
							messageBodyInput1.messageSegments.add(textSegmentInput1);
							entityLinkSegmentInput1.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
							messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
							if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
								ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
								if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								} 
								else 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								}
								linkInput1.urlName = 'Click here to open WO/WWO in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
							}
							feedItemInput1.body = messageBodyInput1;
							feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
							feedItemInput1.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c; 
							ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1);
							System.debug('>>>>>>>Add 3: '+batchInput1); 
							batchInputs.add(batchInput1);	
						}
					} 
					else if(isInsert && objWOJ.BOATBUILDING__Technician__c != null 
							&& objWOJ.BOATBUILDING__Comments__c != null ) 
					{
						messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
						//Mention user here
						if(objWOJ.BOATBUILDING__Technician__c != null) {
							mentionSegmentInput.id = objWOJ.BOATBUILDING__Technician__c;
							messageBodyInput.messageSegments.add(mentionSegmentInput);
						}
						String cmnt = '';
						String strTC = '\n'+'Hi,\n  New Comment added for Technician on job, \nWork Order Number: ' + mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objWOJ.Job_Name__c+ '\n\n';
						strTC += 'Comment: '+objWOJ.BOATBUILDING__Comments__c;
						cmnt = objWOJ.BOATBUILDING__Comments__c;
						strTC += '\n\n';
						textSegmentInput.text = strTC;
						
						if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
							ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
							if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
							{
								linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
							} 
							else 
							{
								linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
							}
							linkInput.urlName = 'Click here to open in Service App';
							ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
							feedElementCapabilitiesInput.link = linkInput;
							feedItemInput.capabilities = feedElementCapabilitiesInput;
						}
						messageBodyInput.messageSegments.add(textSegmentInput); 
						entityLinkSegmentInput.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
						messageBodyInput.messageSegments.add(entityLinkSegmentInput);
						feedItemInput.body = messageBodyInput;
						feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
						feedItemInput.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
						ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
						batchInputs.add(batchInput);
						if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
							&& mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
							mapAccId.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, cmnt);
							
							MapAccIdWONameNJN.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
														mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
															+'~'+objWOJ.Job_Name__c);
							
							ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
							ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
							ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
							ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
							messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							//Mention user here
							if(objWOJ.BOATBUILDING__Technician__c != null) { 
								//mentionSegmentInput1.id = objWOJ.BOATBUILDING__Technician__c;
								//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
							}
							textSegmentInput1.text = strTC;
							messageBodyInput1.messageSegments.add(textSegmentInput1);
							entityLinkSegmentInput1.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
							messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
							if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
								ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
								if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								} 
								else 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								}
								linkInput1.urlName = 'Click here to open WO/WWO in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
							}
							feedItemInput1.body = messageBodyInput1;
							feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
							feedItemInput1.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
							ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
							batchInputs.add(batchInput1);	
								
						}
						if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
							MapBoatId.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, cmnt);
							MapAccIdWONameNJN.put(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
														mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name
															+'~'+objWOJ.Job_Name__c);
							
							ConnectApi.FeedItemInput feedItemInput1 = new ConnectApi.FeedItemInput();
							ConnectApi.MentionSegmentInput mentionSegmentInput1 = new ConnectApi.MentionSegmentInput();
							ConnectApi.MessageBodyInput messageBodyInput1 = new ConnectApi.MessageBodyInput();
							ConnectApi.TextSegmentInput textSegmentInput1 = new ConnectApi.TextSegmentInput();
							ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput1 = new ConnectApi.EntityLinkSegmentInput();
							messageBodyInput1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
							//Mention user here
							if(objWOJ.BOATBUILDING__Technician__c != null) { 
								//mentionSegmentInput1.id = objWOJ.BOATBUILDING__Technician__c;
								//messageBodyInput1.messageSegments.add(mentionSegmentInput1);
							}
							textSegmentInput1.text = strTC;
							messageBodyInput1.messageSegments.add(textSegmentInput1);
							entityLinkSegmentInput1.entityId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
							messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
							if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
								ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
								if(mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName == 'Work_Order') 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WO&WOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								} 
								else 
								{
									linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/apex/BOATBUILDING__ServicePage?type=WWO&WWOId='+mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'\n\n';
								}
								linkInput1.urlName = 'Click here to open WO/WWO in Service App';
								ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
								feedElementCapabilitiesInput1.link = linkInput1;
								feedItemInput1.capabilities = feedElementCapabilitiesInput1;
							}
							feedItemInput1.body = messageBodyInput1;
							feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
							feedItemInput1.subjectId = mapWOJ.get(objWOJ.Id).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c; 
							ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
							batchInputs.add(batchInput1);	
						}
					} 
				}
				System.debug('Debug Log For batchInputs: '+batchInputs);
				System.debug('Debug Log For batchInputs.size: '+batchInputs.size());
				System.debug('>>>>>>>>');
				
				ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
				System.debug('Debug Log For objCA_BR: '+objCA_BR);
				
				if(!mapAccId.isEmpty()) {
					TMTriggerHandler.createActivity(mapAccId, MapAccIdWONameNJN);
				}
				if(!MapBoatId.isEmpty()) {
					TMTriggerHandler.createActivity(MapBoatId, MapAccIdWONameNJN);
				}
			}
		}
	}
    
    public static void isCompleteOperation(List<Work_Order_Job__c> lstJob, Map<id,Work_Order_Job__c> mapJob, Boolean isInsert, Boolean isUpdate){
        Map<String, Date> MapTIdDate = new Map<String, Date>();
        Set<Date> setJCDate = new Set<Date>();
        for(Work_Order_Job__c WOJob:lstJob){
            if(isUpdate && WOJob.BOATBUILDING__Completed__c != mapJob.get(WOJob.Id).BOATBUILDING__Completed__c && WOJob.BOATBUILDING__Completed__c==true){
                WOJob.BOATBUILDING__Job_Completed_Date__c=Date.today();
                WOJob.BOATBUILDING__Job_Completed_Date_Time__c=DateTime.now();
                
            } else if(isInsert && WOJob.BOATBUILDING__Completed__c==true){
                WOJob.BOATBUILDING__Job_Completed_Date__c=Date.today();
                WOJob.BOATBUILDING__Job_Completed_Date_Time__c=DateTime.now();
            }else if(WOJob.BOATBUILDING__Completed__c==false){
                WOJob.BOATBUILDING__Job_Completed_Date__c=null;
                WOJob.BOATBUILDING__Job_Completed_Date_Time__c=null;
            }
            if(isUpdate && WOJob.BOATBUILDING__Completed__c==true && WOJob.BOATBUILDING__Job_Completed_Date__c != null
               && WOJob.BOATBUILDING__Technician__c != null && WOJob.BOATBUILDING__Technician_Timesheet__c == null && WOJob.BOATBUILDING__Job_Completed_Date__c != null) {
                   MapTIdDate.put(WOJob.BOATBUILDING__Technician__c, WOJob.BOATBUILDING__Job_Completed_Date__c);
                   setJCDate.add(WOJob.BOATBUILDING__Job_Completed_Date__c); 
               }
        } 
        if(!MapTIdDate.isEmpty()) {
            List<BOATBUILDING__Time_Management__c> lstTM = [Select Id, CreatedDate, BOATBUILDING__Technician__c From BOATBUILDING__Time_Management__c 
                                                            Where BOATBUILDING__Technician__c IN: MapTIdDate.keySet() 
                                                            AND RecordType.DeveloperName = 'Standard_Time_Sheet'
                                                            AND DAY_ONLY(CreatedDate) IN: setJCDate];
            System.debug('>>>>>>>lstTM: '+lstTM); 
            if(!lstTM.isEmpty()) {
                Map<String, BOATBUILDING__Time_Management__c> mapTM = new Map<String, BOATBUILDING__Time_Management__c>();
                for(BOATBUILDING__Time_Management__c objTM: lstTM) {
                    if(objTM.BOATBUILDING__Technician__c != null) {
                        DateTime dT = objTM.CreatedDate;
                        Date objTMCreatedDate = date.newinstance(dT.year(), dT.month(), dT.day());
                        mapTM.put(objTM.BOATBUILDING__Technician__c+String.valueOf(objTMCreatedDate), objTM);
                    }
                }                                                           
                for(Work_Order_Job__c WOJob:lstJob){
                    if(WOJob.BOATBUILDING__Job_Completed_Date_Time__c != null) {
                        DateTime dT = WOJob.BOATBUILDING__Job_Completed_Date_Time__c;
                        Date woJobDate = date.newinstance(dT.year(), dT.month(), dT.day());
                        if(mapTM.containsKey(WOJob.BOATBUILDING__Technician__c+String.valueOf(woJobDate)) ){
                            WOJob.BOATBUILDING__Technician_Timesheet__c = mapTM.get(WOJob.BOATBUILDING__Technician__c+String.valueOf(woJobDate)).Id;
                        }
                    }
                }
            }
        }
    }
    
    //the following class will be used to house the field names
    //and desired operations
    public class fieldDefinition {
        
        public String operation {get;set;}
        public String childField {get;set;}
        public String parentField {get;set;}
        
        public fieldDefinition (String o, String c, String p) {
            operation = o;
            childField = c;
            parentField = p;
        }
    }
    
    public static void rollUpTrigger(list<fieldDefinition> fieldDefinitions,
                                     list<sObject> records, String childObject, 
                                     String childParentLookupField, 
                                     String parentObject, String queryFilter) 
    {
        
        //Limit the size of list by using Sets which do not contain duplicate
        //elements prevents hitting governor limits
        set<Id> parentIds = new set<Id>();
        
        for(sObject s : records) {
            parentIds.add((Id)s.get(childParentLookupField));
        }
        
        //populate query text strings to be used in child aggregrator and 
        //parent value assignment
        String fieldsToAggregate = '';
        String parentFields = '';
        
        for(fieldDefinition d : fieldDefinitions) {
            fieldsToAggregate += d.operation + '(' + d.childField + ') ' + ', ';
            parentFields += d.parentField + ', ';
        }
        
        //Using dynamic SOQL with aggergate results to populate parentValueMap
        String aggregateQuery = 'Select ' + fieldsToAggregate + childParentLookupField + ' from ' + childObject +
            ' where  ' + childParentLookupField + ' IN :parentIds ' + queryFilter + ' ' +
            ' group by ' + childParentLookupField;
        
        //Map will contain one parent record Id per one aggregate object
        map<Id, AggregateResult> parentValueMap = new map <Id, AggregateResult>();
        //System.debug('Debug log For Database.query(aggregateQuery): '+Database.query(aggregateQuery));
        
        for(AggregateResult q : Database.query(aggregateQuery)){
            parentValueMap.put((Id)q.get(childParentLookupField), q);
        }
        
        //list of parent object records to update
        list<sObject> parentsToUpdate = new list<sObject>();
        String parentQuery = 'select ' + parentFields + ' Id ' + ' from ' + parentObject + ' where Id IN :parentIds';
        
        //for each affected parent object, retrieve aggregate results and 
        //for each field definition add aggregate value to parent field
        //System.debug('Debug log For Database.query(parentQuery): '+Database.query(parentQuery));
        for(sObject s : Database.query(parentQuery)) {
            System.debug('Debug log For s: '+s);
            Integer row = 0; //row counter reset for every parent record
            for(fieldDefinition d : fieldDefinitions) {
                String field = 'expr' + row.format();
                AggregateResult r = parentValueMap.get(s.Id);
                //r will be null if no records exist 
                //(e.g. last record deleted)
                if(r != null) { 
                    Decimal value = ((Decimal)r.get(field) == null ) ? 0 : 
                    (Decimal)r.get(field);
                    s.put(d.parentField, value);
                } else {
                    s.put(d.parentField, 0);
                }
                row += 1; //plus 1 for every field definition after first
            }
            parentsToUpdate.add(s);
        }
        
        //if parent records exist, perform update of all parent records 
        //with a single DML statement
        if(parentsToUpdate.Size() > 0) {
            update parentsToUpdate;
        }
    } 
    
    public static void rollAllTheDataOnWO(Set<String> setWOId) {
        List<Work_Order__c> lstWO = [Select 
                                     Id, BOATBUILDING__Total_Parts__c, BOATBUILDING__Total_Labor__c, BOATBUILDING__Discount_on_Jobs__c, BOATBUILDING__Total_Shop_Supplies__c, 
                                     BOATBUILDING__Total_Payment_job__c, BOATBUILDING__Total_Amt_No_Shipping__c, BOATBUILDING__Total_Shipping_Charges__c, BOATBUILDING__Total_Misc__c, 
                                     RecordType.DeveloperName,
                                     (
                                         Select 
                                         Id, BOATBUILDING__Total_Amount_on_Parts_del__c, BOATBUILDING__Total_Cost_Labor__c, BOATBUILDING__Discount__c, 
                                         BOATBUILDING__Shop_Supplies_Total__c, BOATBUILDING__Total_Amount_Job__c, BOATBUILDING__Total_Amt_No_Shipping__c, 
                                         BOATBUILDING__Shipping_Charge__c, BOATBUILDING__Total_Misc__c, BOATBUILDING__Total_Part_Cost__c, BOATBUILDING__Completed__c
                                         From 
                                         Work_Order_Jobs__r 
                                     )
                                     From 
                                     Work_Order__c 
                                     Where 
                                     Id IN: setWOId];
        List<Work_Order__c> lstWOForUpdate = new List<Work_Order__c>();
        for(Work_Order__c objWO: lstWO) {
            Decimal PART_TOTAL = 0.00, LABOR_TOTAL = 0.00, DISCOUNT_ON_JOB_TOTAL = 0.00, SHOPSUPPLIES_TOTAL = 0.00, PAYMENT_JOB_TOTAL = 0.00, TOTAL_AMOUNT_NO_SHIPPING = 0.00;
            Decimal SHIPPING_TOTAL = 0.00, MISC_TOTAL = 0.00;
			Decimal Incomplete_Jobs_Count = 0.00; 
            for(Work_Order_Job__c objWOJ: objWO.Work_Order_Jobs__r) {
            	
                // for BOATBUILDING__Total_Amount_on_Parts_del__c Rollup
                if(objWO.RecordType.DeveloperName == 'Work_Order') {
                	PART_TOTAL += objWOJ.BOATBUILDING__Total_Amount_on_Parts_del__c != null? objWOJ.BOATBUILDING__Total_Amount_on_Parts_del__c: 0.00;
                } else {
                	PART_TOTAL += objWOJ.BOATBUILDING__Total_Part_Cost__c != null? objWOJ.BOATBUILDING__Total_Part_Cost__c: 0.00;
                }                
                // for BOATBUILDING__Total_Cost_Labor__c Rollup
                LABOR_TOTAL += objWOJ.BOATBUILDING__Total_Cost_Labor__c != null? objWOJ.BOATBUILDING__Total_Cost_Labor__c: 0.00;
                
                // for BOATBUILDING__Discount__c Rollup
                DISCOUNT_ON_JOB_TOTAL += objWOJ.BOATBUILDING__Discount__c != null? objWOJ.BOATBUILDING__Discount__c: 0.00;
                
                // for BOATBUILDING__Shop_Supplies_Total__c Rollup
                SHOPSUPPLIES_TOTAL += objWOJ.BOATBUILDING__Shop_Supplies_Total__c != null? objWOJ.BOATBUILDING__Shop_Supplies_Total__c: 0.00;
                
                // for BOATBUILDING__Customer_Pay__c Rollup
                PAYMENT_JOB_TOTAL += objWOJ.BOATBUILDING__Total_Amount_Job__c != null? objWOJ.BOATBUILDING__Total_Amount_Job__c: 0.00;
                
                // for Total Amnt Without Shipping
                TOTAL_AMOUNT_NO_SHIPPING += objWOJ.BOATBUILDING__Total_Amt_No_Shipping__c != null? objWOJ.BOATBUILDING__Total_Amt_No_Shipping__c: 0.00;
                
                // for BOATBUILDING__Total_Shipping_Charges__c Rollup
                SHIPPING_TOTAL += objWOJ.BOATBUILDING__Shipping_Charge__c != null? objWOJ.BOATBUILDING__Shipping_Charge__c: 0.00;
                
                // for BOATBUILDING__Total_Misc__c Rollup
                MISC_TOTAL += objWOJ.BOATBUILDING__Total_Misc__c != null? objWOJ.BOATBUILDING__Total_Misc__c: 0.00;
				//for count of complete job
				if( !objWOJ.BOATBUILDING__Completed__c )
					Incomplete_Jobs_Count += 1;
            }
            
            objWO.BOATBUILDING__Total_Parts__c = PART_TOTAL;
            objWO.BOATBUILDING__Total_Labor__c = LABOR_TOTAL;
            objWO.BOATBUILDING__Discount_on_Jobs__c = DISCOUNT_ON_JOB_TOTAL;
            objWO.BOATBUILDING__Total_Shop_Supplies__c = SHOPSUPPLIES_TOTAL;
            objWO.BOATBUILDING__Total_Payment_job__c = PAYMENT_JOB_TOTAL;
            objWO.BOATBUILDING__Total_Amt_No_Shipping__c = TOTAL_AMOUNT_NO_SHIPPING;
            objWO.BOATBUILDING__Total_Shipping_Charges__c = SHIPPING_TOTAL;
            objWO.BOATBUILDING__Total_Misc__c = MISC_TOTAL;
			objWO.BOATBUILDING__Number_of_Total_Incomplete_Jobs__c = Incomplete_Jobs_Count;
            objWO.BOATBUILDING__Number_of_Total_Jobs__c = objWO.Work_Order_Jobs__r != null && !objWO.Work_Order_Jobs__r.isEmpty() ? objWO.Work_Order_Jobs__r.size() : 0;
            lstWOForUpdate.add(objWO);
        }
        update lstWOForUpdate;
    }
    public static void updateWOStatus(List<Work_Order_Job__c> newLstWOJ, Map<Id, Work_Order_Job__c> oldMapWOJ) {
		BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        Set<String> setStr = new Set<String>();
        Id WWORecType = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
        for(Work_Order_Job__c objWOJ: newLstWOJ) {
            if(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null && objWOJ.BOATBUILDING__Completed__c  != oldMapWOJ.get(objWOJ.Id).BOATBUILDING__Completed__c) {
                setStr.add(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c);
            }
        }
        if(!setStr.isEmpty() && ( objSC == null || !objSC.BOATBUILDING__Prevent_WO_Complete_Operation__c ) ) {
            List<BOATBUILDING__Work_Order__c> lstWO = [SELECT Id,BOATBUILDING__Status__c, RecordTypeId, (SELECT Id,BOATBUILDING__Completed__c FROM Work_Order_Jobs__r) 
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
                    if(objWO.RecordTypeId == WWORecType) {
                        objWO.BOATBUILDING__Status__c = 'Warranty Waiting On Approval';
                    } else {
                        objWO.BOATBUILDING__Status__c = 'Completed Pending Review';
                    }	    
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
            
            System.debug('>>>>>lstTimeMgmt2: '+lstTimeMgmt2);
            if(!lstTimeMgmt2.isEmpty()) {
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
                    }
                }
                System.debug('>>>>>lstWO: '+lstWO);
                
            }
            update lstWO;
        }
        
        
    }  
}