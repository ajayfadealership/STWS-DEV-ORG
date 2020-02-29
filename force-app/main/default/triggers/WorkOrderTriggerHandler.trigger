/** 
* Author : Akshay Kumar
* Created Date : 05/20/2017
*/
trigger WorkOrderTriggerHandler on Work_Order__c (before insert, after insert, before update, after update) {


    if(trigger.isBefore){
        if(trigger.isInsert){
            List<User> lstUser = new List<User>();
            List<userRole> lstUserRole = [ SELECT Id, Name FROM userRole WHERE Name ='Parts Manager'];
           // List<Profile> lstProfile = [SELECT Id, Name FROM Profile WHERE Name ='Parts Manager'];
           /* if( !lstProfile.isEmpty()){
              lstUser = [SELECT Id FROM User WHERE ProfileId =: lstProfile[0].Id];  
            }*/
            if( !lstUserRole.isEmpty()){
              lstUser = [SELECT Id FROM User WHERE UserRoleId =: lstUserRole[0].Id];  
            }
            
            for(Work_Order__c objWO: trigger.new) {
                if(!lstUser.isEmpty() 
                   && objWO.RecordTypeId == Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId() 
                   && objWO.BOATBUILDING__Request_Type__c != null
                   && objWO.BOATBUILDING__Request_Type__c == 'Part Request') {
						objWO.OwnerId = lstUser[0].Id;
                }
            } 
        }
    }
    
    // Service Score Count
    if(trigger.isAfter) {
        if(trigger.isInsert || trigger.isUpdate) {
            Set<String> setAccId = new Set<String>();
            for(Work_Order__c objWO: trigger.new) {
                if(objWO.Account__c != null && objWO.Status__c != null && objWO.Status__c.equalsIgnoreCase('closed')) {
                    setAccId.add(objWO.Account__c);
                }
            }
            System.debug('>>>>>>setAccId: '+setAccId);
            if(!setAccId.isEmpty()) {
                List<Account> lstAcc = [Select Id, Service_score__c, (Select id From Work_Orders__r Where Status__c = 'Closed') From Account Where Id IN: setAccId];
                System.debug('>>>>>>lstAcc be: '+lstAcc);
                for(Account objAcc: lstAcc) {
                    objAcc.Service_score__c = objAcc.Work_Orders__r.size() * 5;
                }
                System.debug('>>>>>>lstAcc af: '+lstAcc);
                update lstAcc; 
            }
            List<BOATBUILDING__Dealership_Form__c> lstDF = [Select Id, BOATBUILDING__Engine_Hours__c, BOATBUILDING__Work_Order__r.Hours__c From BOATBUILDING__Dealership_Form__c Where BOATBUILDING__Work_Order__c IN: trigger.newMap.keySet()];
            
            for(BOATBUILDING__Dealership_Form__c objDF: lstDF) {
                if(objDF.BOATBUILDING__Work_Order__r.Hours__c != null)
                    objDF.BOATBUILDING__Engine_Hours__c = Decimal.valueOf(objDF.BOATBUILDING__Work_Order__r.Hours__c); 
            }
            update lstDF;
        }
        if(trigger.isUpdate) {
        	String strUsrId = '';
        	String roleId = '';
        	List<UserRole> lstRolePWM = [SELECT Id,Name FROM UserRole Where Name = 'Parts and Warranty Manager'];
        	if(lstRolePWM.isEmpty()) {
        		List<UserRole> lstRoleSM = [SELECT Id,Name FROM UserRole Where Name = 'Service Manager'];
        		if(lstRoleSM.isEmpty()) {
        			List<UserRole> lstRoleGM = [SELECT Id,Name FROM UserRole Where Name = 'GM'];
        			if(!lstRoleGM.isEmpty()) {
        				roleId = lstRoleGM[0].Id;
        			}
        		} else {
        			roleId = lstRoleSM[0].Id;
        		}
        	} else {
        		roleId = lstRolePWM[0].Id;
        	}
        	if(String.isNotBlank(roleId)) {
        		List<User> lstU = [Select Id From User Where UserRoleId =: roleId];
        		if(!lstU.isEmpty()) {
        			strUsrId = lstU[0].Id;
        		}
        	}
        	System.debug('>>>>: strUsrId  '+ strUsrId);
        	List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    		String woRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
    		String wwoRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
    		List<Event> lstTask = new List<Event>();
        	for(Work_Order__c objWO: trigger.new) {
        		if(String.isBlank(strUsrId)) {
        			strUsrId = objWO.OwnerId; 
        		}
        		if(objWO.RecordTypeId == woRT || objWO.RecordTypeId == wwoRT) {
        			if(objWO.BOATBUILDING__Status__c != null && objWO.BOATBUILDING__Status__c.equalsIgnoreCase('Warranty Review') && objWO.BOATBUILDING__Status__c != trigger.oldMap.get(objWO.Id).BOATBUILDING__Status__c) {
	                	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
			            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
			            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
			            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
			            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
			            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		                //Mention user here
		                mentionSegmentInput.id = strUsrId;  
		                messageBodyInput.messageSegments.add(mentionSegmentInput);
		                String strTC = objWO.Name+' is available for warranty review';
		                strTC += '\n\n';
		                textSegmentInput.text = strTC;
		                messageBodyInput.messageSegments.add(textSegmentInput);
		                
		                entityLinkSegmentInput.entityId = objWO.Id;
		                messageBodyInput.messageSegments.add(entityLinkSegmentInput);
	                	ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
	                	if(objWO.RecordTypeId == woRT) {
	                		
	                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
	                	} else {
	                		
	                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
	                	}
	                	linkInput.urlName = 'Click here to open in Service App';
						ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
						feedElementCapabilitiesInput.link = linkInput;
						feedItemInput.capabilities = feedElementCapabilitiesInput;
		                feedItemInput.body = messageBodyInput;
		                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		                feedItemInput.subjectId = objWO.Id;
		                
		                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
		                batchInputs.add(batchInput);
		                Event objTask = new Event();
		                objTask.OwnerId = strUsrId;
						objTask.Subject = objWO.Name+' is available for warranty review';
						objTask.ActivityDate = Date.today();
						objTask.WhatId = objWO.Id;
						objTask.Description = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
						objTask.DurationInMinutes = 0;
						objTask.ActivityDateTime = datetime.now();
						lstTask.add(objTask);
	                }
        		}	
        	}
        	ConnectApi.BatchResult[] objCA_BR;
            if(!Test.isRunningTest() && !batchInputs.isEmpty()) {
				objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
            } 
        	insert lstTask;
	        System.debug('Debug Log For objCA_BR: '+objCA_BR);
        }
        if(trigger.isInsert) {
        	List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
        	String woRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
        	String wwoRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Warranty Work Order').getRecordTypeId();
            String wrRT = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
        	List<Event> lstTask = new List<Event>();
        	for(Work_Order__c objWO: trigger.new) {
        		if(objWO.RecordTypeId == woRT || objWO.RecordTypeId == wwoRT) {
	        		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
		            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	                //Mention user here
	                mentionSegmentInput.id = objWO.OwnerId; 
	                messageBodyInput.messageSegments.add(mentionSegmentInput);
	                String strTC = '';  
	                if(objWO.RecordTypeId == woRT) {
	                	strTC = '\n'+'Hi,\n  New Work Order is created,\nWork Order Number: ' + objWO.Name +'\n\n';
	                } else if(objWO.RecordTypeId == wwoRT) {
	                	strTC = '\n'+'Hi,\n  New Warranty Work Order is created,\nWarranty Work Order Number: ' + objWO.Name +'\n\n';
	                }
	                strTC += '\n\n';
	                textSegmentInput.text = strTC;
	                messageBodyInput.messageSegments.add(textSegmentInput);
	                
	                entityLinkSegmentInput.entityId = objWO.Id;
	                messageBodyInput.messageSegments.add(entityLinkSegmentInput);
                	ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                	if(objWO.RecordTypeId == woRT) {
                		
                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
                	} else {
                		
                		linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
                	}
                	linkInput.urlName = 'Click here to open in Service App';
					ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
					feedElementCapabilitiesInput.link = linkInput;
					feedItemInput.capabilities = feedElementCapabilitiesInput;
	                feedItemInput.body = messageBodyInput;
	                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
	                feedItemInput.subjectId = objWO.Id;
	                
	                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
	                batchInputs.add(batchInput);
	                
	                if(objWO.BOATBUILDING__Account__c != null) { 
		                Event objTask = new Event();
						objTask.Subject = 'New Work Order is created, Work Order Number: ' + objWO.Name;
						if(objWO.RecordTypeId == woRT) {
		                	objTask.Subject = 'New Work Order is created: ' + objWO.Name;
		                } else if(objWO.RecordTypeId == wwoRT) {
		                	objTask.Subject = 'New Warranty Work Order is created: ' + objWO.Name;
		                }
						objTask.ActivityDate = Date.today();
						objTask.WhatId = objWO.BOATBUILDING__Account__c;
						if(objWO.RecordTypeId == woRT) {
	                		objTask.Description = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
	                	} else {
	                		
	                		objTask.Description = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objWO.Id+'\n\n';
	                	}
						objTask.DurationInMinutes = 0;
						objTask.ActivityDateTime = datetime.now();
						lstTask.add(objTask);
	                }
	                
	                
	                
        		} 
                else if(objWO.RecordTypeId == wrRT && objWO.BOATBUILDING__Assigned_to__c != null) {
                    PartRequestLightningCompController.doChatterPost(objWO.BOATBUILDING__Assigned_to__c, 'Work Request', objWO.Id);
                }
		                
        	}
            ConnectApi.BatchResult[] objCA_BR;
            if(!Test.isRunningTest() && !batchInputs.isEmpty()) {
				objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
            } 
        	insert lstTask;
	        System.debug('Debug Log For objCA_BR: '+objCA_BR);
        }
        
        
    }
    
    if(trigger.isBefore) {
        if(trigger.isInsert || trigger.isUpdate) {
            Id reWOId = Schema.SObjectType.BOATBUILDING__Work_Order__c.getRecordTypeInfosByName().get('Work Order').getRecordTypeId();
            if(reWOId != null) {
                for(BOATBUILDING__Work_Order__c objWO: trigger.new) {
                    if(trigger.isInsert) {
                        objWO.BOATBUILDING__Customer_Last_updated__c = DateTime.now();
                    }
                }
                
                if(trigger.isUpdate) { 
                    for(BOATBUILDING__Work_Order__c objWO: [Select b.Discount__c, b.Discount_on_Jobs__c, b.RecordtypeId,  b.BOATBUILDING__Customer_Last_updated__c, b.BOATBUILDING__Sales_Tax_Backend_2__c, b.Store_Location__c, b.Id, (Select Id, BOATBUILDING__Total_Amount_on_Parts_del__c, BOATBUILDING__Total_Cost_Labor__c, BOATBUILDING__Total_Misc__c, BOATBUILDING__Shop_Supplies_Total__c, BOATBUILDING__Taxable__c From BOATBUILDING__Work_Order_Jobs__r) From BOATBUILDING__Work_Order__c b Where Id IN: trigger.newMap.keySet()]) {
                        if(trigger.isInsert) {
                            objWO.BOATBUILDING__Customer_Last_updated__c = DateTime.now();
                        }
                        System.debug('Debug Log For objWO: '+objWO);
                        if(objWO.RecordtypeId == reWOId) { 
                            if(objWO.Store_Location__c != null) {
                                //Change 17/04/2018
                                BoatBuilderUtil objBoatBuilderUtil = new BoatBuilderUtil(objWO.Store_Location__c); 
                                Decimal RegularSalestax = objBoatBuilderUtil.getRegularSalestax();
                                Decimal taxCalAmt = 0.00;
                                if(objWO.BOATBUILDING__Work_Order_Jobs__r.size() > 0) { 
                                    for(BOATBUILDING__Work_Order_Job__c objWOJ: objWO.BOATBUILDING__Work_Order_Jobs__r) {
                                        System.debug('Debug Log For Taxable Check: '+objWOJ.Taxable__c);
                                        if(objWOJ.Taxable__c) {
                                            System.debug('Debug log For Taxable Check'); 
                                            if(objWOJ.BOATBUILDING__Total_Amount_on_Parts_del__c != null && objBoatBuilderUtil.getPartsTax()) {
                                                taxCalAmt += objWOJ.BOATBUILDING__Total_Amount_on_Parts_del__c;
                                            }
                                            if(objWOJ.BOATBUILDING__Total_Cost_Labor__c != null && objBoatBuilderUtil.getLaborTax()) { 
                                                taxCalAmt += objWOJ.BOATBUILDING__Total_Cost_Labor__c;
                                            }
                                            if(objWOJ.BOATBUILDING__Total_Misc__c != null && objBoatBuilderUtil.getMISCTax()) {
                                                taxCalAmt += objWOJ.BOATBUILDING__Total_Misc__c;
                                            } 
                                            if(objWOJ.BOATBUILDING__Shop_Supplies_Total__c != null && objBoatBuilderUtil.getSSTax()) {
                                                taxCalAmt += objWOJ.BOATBUILDING__Shop_Supplies_Total__c;
                                            }
                                        }
                                    }  
                                }
                                if(objWO.Discount_on_Jobs__c != null) {
                                    taxCalAmt -= objWO.Discount_on_Jobs__c;
                                }
                                
                                if(objWO.Discount__c != null) {
                                    taxCalAmt -= objWO.Discount__c; 
                                }
                                System.debug('Debug Log For taxCalAmt: '+taxCalAmt);
                                objWO.Sales_Tax_Backend_2__c = (taxCalAmt * RegularSalestax)/100;
                                if(objWO.Sales_Tax_Backend_2__c > 0) {
                                    trigger.newMap.get(objWO.Id).Sales_Tax_Backend_2__c = objWO.Sales_Tax_Backend_2__c;
                                } else {
                                    trigger.newMap.get(objWO.Id).Sales_Tax_Backend_2__c = 0.00;
                                }
                            } else {  
                                objWO.Sales_Tax_Backend_2__c = 0.00;
                            }  
                        }
                    }
                    //RiggingHandler.updateInventoryOnWO(trigger.newMap); 
                }
            } 
        }
    }
    
    Boolean isOff = BOATBUILDING__TriggerSetting__c.getOrgDefaults().BOATBUILDING__WorkOrderTriggerHandlerChecBox__c;
    if(isOff==true){
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                WorkOrderTriggerHandler.onBeforeInsert(Trigger.new);
                WorkOrderTriggerHandler.updateAccountOnWorkOrder(Trigger.new);
            }
            else if(Trigger.isUpdate){
                System.debug('==before update===');
                WorkOrderTriggerHandler.onBeforeUpdate(Trigger.new);
                WorkOrderTriggerHandler.updateAccountOnWorkOrder(Trigger.new);
            }
        }
        
        if(Trigger.isAfter){
            if(Trigger.isInsert){
                WorkOrderTriggerHandler.onAfterInsert(Trigger.new);
            }
            
            else if(Trigger.isUpdate){
                WorkOrderTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
    
    if(trigger.isAfter) {
        if(trigger.isUpdate || trigger.isInsert) {
            RiggingHandler.onAfterInsertWO(trigger.newMap);
        }
    }
}