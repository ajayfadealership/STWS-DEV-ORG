public class RecordEventActivityController {
    
    @AuraEnabled
    public static List<Event> getAllEventsForJob(String woId , List<String> setCommentTypes){
        Set<String> setType = new Set<String>(setCommentTypes);
        if(!setType.contains('All')){
            return [Select id,Subject,Type,Description,what.Name,Who.Name,CreatedBy.Name,
                    CreatedDate from Event where whatId =: woId AND Type IN : setType ORDER BY CreatedDate DESC];
        }
        else{
            return [Select id,Subject,Type,Description,what.Name,Who.Name,CreatedBy.Name,
                    CreatedDate from Event where whatId =: woId ORDER BY CreatedDate DESC];
        }
    }
    
    @AuraEnabled
    public static String addCustomerComment(String subject, String customerComment, String whatId, String whoId, String accountId, String sectionName, String Type){
        if(subject == null || String.isBlank(subject)){
            subject = '';
        }
        BOATBUILDING__Work_Order_Job__c objWOJ = new BOATBUILDING__Work_Order_Job__c();
        BOATBUILDING__Work_Order__c objWO = new BOATBUILDING__Work_Order__c();
        if(sectionName == 'Work Order Section'){
            objWO = [Select Id, BOATBUILDING__Boat__c,Name from BOATBUILDING__Work_Order__c where id =: whatId];
        }else{
            objWOJ = [Select Id, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c,
                      BOATBUILDING__Technician__c,Name,BOATBUILDING__Work_Order_Warranty_Work_Order__c,
                      BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name from BOATBUILDING__Work_Order_Job__c 
                      where id =: whatId];
        }
        
        List<Event> lstEvent = new List<Event>();                        
        Event e = new Event();
        e.whatId = whatId;
        e.whoId = whoId;
        e.Subject = subject;
        e.Description = customerComment;
        e.StartDateTime = System.Now();
        e.EndDateTime = System.Now()+1;
        if(sectionName == 'Customer Comment'){
            e.Type = 'Comment for Customer';
        }
        if(sectionName == 'Service Writer Comment'){
            e.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
        }
        if(sectionName == 'Tech Comment'){
            e.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
        }
        if(sectionName == 'Work Order Section'){
            e.Type = Type;
        }
        
        lstEvent.add(e);
        
        Event e2 = new Event();
        e2.whatId = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
        
        e2.Subject = subject+' (Comment on '+objWOJ.Name+')';
        e2.Description = customerComment;
        e2.StartDateTime = System.Now();
        e2.EndDateTime = System.Now()+1;
        
        if(sectionName == 'Customer Comment'){
            e2.Type = 'Comment for Customer';
        }
        if(sectionName == 'Service Writer Comment'){
            e2.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e2.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
        }
        if(sectionName == 'Tech Comment'){
            e2.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e2.OwnerId = objWOJ.BOATBUILDING__Technician__c;
                e2.Subject = subject+' (Comment from Tech on '+objWOJ.Name+')';
            }
        }
        if(sectionName == 'Work Order Section'){
            e2.Type = Type;
        }
        lstEvent.add(e2);
        
        Event e3 = new Event();
        e3.whatId = accountId;
        if(sectionName == 'Work Order Section'){
            e3.Type = Type;
            e3.Subject = 'Comment on '+objWO.Name;
        }else{
           
            e3.Subject = 'Comment on '+objWO.Name +'---Job:'+objWOJ.Name;
        }
        
        
        e3.Description = customerComment;
        e3.StartDateTime = System.Now();
        e3.EndDateTime = System.Now()+1;
        if(sectionName == 'Customer Comment'){
            e3.Type = 'Comment for Customer';
        }
        if(sectionName == 'Service Writer Comment'){
            e3.Type = 'Comment for Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e3.OwnerId = objWOJ.BOATBUILDING__Technician__c;
            }
        }
        if(sectionName == 'Tech Comment'){
            e3.Type = 'Comment from Technician';
            if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                e3.OwnerId = objWOJ.BOATBUILDING__Technician__c;
                e3.Subject = subject+' (Comment from Tech on '+objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'--'+objWOJ.Name+')';
            }
        }
        lstEvent.add(e3);
        if(String.isNotBlank(String.valueOf(objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c)) || String.isNotBlank(String.valueOf(objWO.BOATBUILDING__Boat__c))){
            Event e4 = new Event();
            if(sectionName == 'Work Order Section'){
                e4.whatId = objWO.BOATBUILDING__Boat__c;
                e3.Type = Type;
                e4.Subject = 'Comment on '+objWO.Name;
            }else{
                e4.whatId = objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Boat__c;
                e4.Subject = 'Comment on '+objWO.Name +'---Job:'+objWOJ.Name;
            }
            
            e4.Description = customerComment;
            e4.StartDateTime = System.Now();
            e4.EndDateTime = System.Now()+1;
            if(sectionName == 'Customer Comment'){
                e4.Type = 'Comment for Customer';
            }
            if(sectionName == 'Service Writer Comment'){
                e4.Type = 'Comment for Technician';
                if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                    e4.OwnerId = objWOJ.BOATBUILDING__Technician__c;
                }
            }
            if(sectionName == 'Tech Comment'){
                e4.Type = 'Comment from Technician';
                if(String.isNotBlank(objWOJ.BOATBUILDING__Technician__c)){
                    e4.OwnerId = objWOJ.BOATBUILDING__Technician__c;
                    e4.Subject = subject+' (Comment from Tech on '+objWOJ.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+'--'+objWOJ.Name+')';
                }
                
            }
            lstEvent.add(e4);
        }        
        insert lstEvent;
        if(sectionName == 'Tech Comment'){
            doChatterPostFromTechToServiceWriter(customerComment, objWOJ.Id);
        }
        if(sectionName == 'Service Writer Comment'){
            doChatterPostFromServiceWriterToTechnician(customerComment, objWOJ.Id);
        }
        return 'Success';
    }
    public static void doChatterPostFromTechToServiceWriter(String comment, String strJobId) {
        BOATBUILDING__Work_Order_Job__c objJob = [Select 
                                                                Technician__c, Id , BOATBUILDING__Work_Order_Warranty_Work_Order__c, OwnerId, Job_Name__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName,
                                                                BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c,
                                                                BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c
                                                        From 
                                                                BOATBUILDING__Work_Order_Job__c Where Id =: strJobId];
        
        if(!Test.isRunningTest()) {
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            Map<String, String> MapAccId = new Map<String, String>();
            Map<String, String> MapAccIdWONameNJN = new Map<String, String>();
            Map<String, String> MapBoatId = new Map<String, String>();    
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            //Mention user here
            mentionSegmentInput.id = objJob.OwnerId;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            String strTC = '\n'+'Hi,\n  New Comment added for Service Writer on job,\nWork Order Number: ' + objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objJob.Job_Name__c+ '\n\n';
                strTC += 'Comment: '+comment;
                strTC += '\n\n';
            textSegmentInput.text = strTC;
            messageBodyInput.messageSegments.add(textSegmentInput);
            entityLinkSegmentInput.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
            messageBodyInput.messageSegments.add(entityLinkSegmentInput);
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                linkInput.urlName = 'Click here to open in Service App';
                ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
                feedElementCapabilitiesInput.link = linkInput;
                feedItemInput.capabilities = feedElementCapabilitiesInput;
            }
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c;//objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputs.add(batchInput);
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
                && objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
                MapAccId.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, comment);
                MapAccIdWONameNJN.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
                objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name +'~'+objJob.Job_Name__c);	
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
                entityLinkSegmentInput1.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
                if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                    ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
                    linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                    linkInput1.urlName = 'Click here to open in Service App';
                    ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
                    feedElementCapabilitiesInput1.link = linkInput1;
                    feedItemInput1.capabilities = feedElementCapabilitiesInput1;
                }
                feedItemInput1.body = messageBodyInput1;
                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem; 
                feedItemInput1.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
                batchInputs.add(batchInput1);	
            } 
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
                MapBoatId.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, comment);
                MapAccIdWONameNJN.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
                objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name +'~'+objJob.Job_Name__c);
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
                entityLinkSegmentInput1.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
                if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                    ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
                    linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                    linkInput1.urlName = 'Click here to open in Service App';
                    ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
                    feedElementCapabilitiesInput1.link = linkInput1;
                    feedItemInput1.capabilities = feedElementCapabilitiesInput1;
                }
                feedItemInput1.body = messageBodyInput1;
                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput1.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
                batchInputs.add(batchInput1);
                
            }
            ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
            System.debug('Debug Log For objCA_BR: '+objCA_BR);
            
        }
    }
    public static void doChatterPostFromServiceWriterToTechnician(String comment, String strJobId) {
        BOATBUILDING__Work_Order_Job__c objJob = [Select 
                                                            Technician__c, Id , BOATBUILDING__Work_Order_Warranty_Work_Order__c, OwnerId, Job_Name__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.RecordType.DeveloperName,
                                                                BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name, BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c,
                                                                BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c
                                                        From 
                                                                BOATBUILDING__Work_Order_Job__c Where Id =: strJobId];
        
        if(!Test.isRunningTest() && objJob.Technician__c != null) {
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            Map<String, String> MapAccId = new Map<String, String>(); 
            Map<String, String> MapAccIdWONameNJN = new Map<String, String>();
            Map<String, String> MapBoatId = new Map<String, String>();    
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
            ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
            ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
            messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
            //Mention user here
            mentionSegmentInput.id = objJob.Technician__c;
            messageBodyInput.messageSegments.add(mentionSegmentInput);
            String strTC = '\n'+'Hi,\n  New Comment added for Technician on job,\nWork Order Number: ' + objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name+' \nJob Name: '+objJob.Job_Name__c+ '\n\n';
                strTC += 'Comment: '+comment;
                strTC += '\n\n';
            textSegmentInput.text = strTC;
            messageBodyInput.messageSegments.add(textSegmentInput);
            entityLinkSegmentInput.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c;
            messageBodyInput.messageSegments.add(entityLinkSegmentInput);
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                linkInput.urlName = 'Click here to open in Service App';
                ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
                feedElementCapabilitiesInput.link = linkInput;
                feedItemInput.capabilities = feedElementCapabilitiesInput;
            }
            feedItemInput.body = messageBodyInput;
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
            feedItemInput.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c;//objTimeMgmt.BOATBUILDING__Related_Work_Order_Job__r.OwnerId;
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
            batchInputs.add(batchInput);
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__c != null 
                && objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId != null) {
                MapAccId.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, comment);
                MapAccIdWONameNJN.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId, 
                objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name +'~'+objJob.Job_Name__c);	
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
                entityLinkSegmentInput1.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
                if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                    ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
                    linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                    linkInput1.urlName = 'Click here to open in Service App';
                    ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
                    feedElementCapabilitiesInput1.link = linkInput1;
                    feedItemInput1.capabilities = feedElementCapabilitiesInput1;
                }
                feedItemInput1.body = messageBodyInput1;
                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem; 
                feedItemInput1.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.BOATBUILDING__Contact__r.AccountId;
                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
                batchInputs.add(batchInput1);	
            } 
            if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c != null) {
                MapBoatId.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, comment);
                MapAccIdWONameNJN.put(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c, 
                objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name +'~'+objJob.Job_Name__c);
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
                entityLinkSegmentInput1.entityId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
                messageBodyInput1.messageSegments.add(entityLinkSegmentInput1);
                if(objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                    ConnectApi.LinkCapabilityInput linkInput1 = new ConnectApi.LinkCapabilityInput();
                    linkInput1.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Id+'\n\n';
                    linkInput1.urlName = 'Click here to open in Service App';
                    ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput1 = new ConnectApi.FeedElementCapabilitiesInput();
                    feedElementCapabilitiesInput1.link = linkInput1;
                    feedItemInput1.capabilities = feedElementCapabilitiesInput1;
                }
                feedItemInput1.body = messageBodyInput1;
                feedItemInput1.feedElementType = ConnectApi.FeedElementType.FeedItem;
                feedItemInput1.subjectId = objJob.BOATBUILDING__Work_Order_Warranty_Work_Order__r.Boat__c;
                ConnectApi.BatchInput batchInput1 = new ConnectApi.BatchInput(feedItemInput1); 
                batchInputs.add(batchInput1);
                
            }
            ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
            System.debug('Debug Log For objCA_BR: '+objCA_BR);
            
        }
    }
}