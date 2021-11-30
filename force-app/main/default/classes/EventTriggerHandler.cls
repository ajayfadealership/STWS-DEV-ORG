public class EventTriggerHandler
{
    
    public static void updateSalesServiceActivityScore(Map<Id, Event> mapEvent) {
        doChatterPostCustomerComment(mapEvent);
        Set<String> setAccId = new Set<String>();
        for(String srtEvt: mapEvent.keySet()) {
            if(mapEvent.get(srtEvt).WhatId != null && String.valueOf(mapEvent.get(srtEvt).WhatId).startsWithIgnoreCase('001')) {
                setAccId.add(mapEvent.get(srtEvt).WhatId);
            } 
        }
        Set<String> setServiceEventType = new Set<String>{'Inspection Form Created', 'Inspection Form Responded',
            'Customer Comment', 'Comment for Customer', 'Comment for Technician', 'Comment from Technician'};
                
        List<Account> lstAcc = [Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks),
                                (Select Description From Events WHERE Type NOT IN: setServiceEventType)
                                From Account Where Id =: setAccId];
        
        Map<Id, Account> mapAccForSalesActivity = new Map<Id, Account>([Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks),
                                                                        (Select Description From Events WHERE Type IN: setServiceEventType)
                                                                        From Account Where Id =: setAccId]);
        for(Account objAccount: lstAcc) {
            objAccount.BOATBUILDING__Sales_Activity_Score__c = (objAccount.Tasks.size() +  objAccount.Events.size()) * 5;
            if(mapAccForSalesActivity.containsKey(objAccount.Id)){
                objAccount.BOATBUILDING__Service_score__c = (mapAccForSalesActivity.get(objAccount.Id).Tasks.size() +  mapAccForSalesActivity.get(objAccount.Id).Events.size()) * 5;
            }
        }
        update lstAcc;
    }
    
    public static void doChatterPostCustomerComment(Map<Id, Event> mapEvent) {
        Set<String> setWOJId = new Set<String>();
        for(Event objE: mapEvent.values()) {
            if(objE.WhatId != null && objE.Type != null && (objE.Type == 'Customer Comment' || objE.Type == 'Comment for Technician' || objE.Type == 'Inspection Form Responded')) {
                setWOJId.add(objE.WhatId);
                String sObjName = objE.WhatId.getSObjectType().getDescribe().getName();  
                system.debug('Object Name is ' + sObjName);  
                
                //if(sObjName.equalsIgnoreCase('BOATBUILDING__Work_Order_Job__c')) {
                  //  setWOJId.add(objE.WhatId);
                //s}
            }
        }
        if(!setWOJId.isEmpty()) {
            Map<Id, BOATBUILDING__Work_Order_Job__c> mapWOJ = new Map<Id, BOATBUILDING__Work_Order_Job__c>([Select Id, Name, BOATBUILDING__Work_Order_Warranty_Work_Order__c, BOATBUILDING__Work_Order_Warranty_Work_Order__r.OwnerId, BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name, Technician__c From BOATBUILDING__Work_Order_Job__c Where Id IN: setWOJId]);
            List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
            for(Event objE: mapEvent.values()) {
                if(mapWOJ.containsKey(objE.WhatId)) {
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    //Mention user here
                    if(objE.Type == 'Customer Comment') {
                        mentionSegmentInput.id = mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__r.OwnerId;
                        messageBodyInput.messageSegments.add(mentionSegmentInput);
                    } else if(mapWOJ.get(objE.WhatId).Technician__c != null){
                        mentionSegmentInput.id = mapWOJ.get(objE.WhatId).Technician__c;
                        messageBodyInput.messageSegments.add(mentionSegmentInput);
                    }
                    
                    String strTC = '';
                    if(objE.Type == 'Customer Comment') {
                        strTC = '\n'+'Hi,\n  New comment added by customer on work order,\nWork Order Number: ' + mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name + ' \nJob Name: '+ mapWOJ.get(objE.WhatId).Name + '\n\n';
                    } else {
                        strTC = '\n'+'Hi,\n  New comment added by service writer on work order,\nWork Order Number: ' + mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__r.Name + ' \nJob Name: '+ mapWOJ.get(objE.WhatId).Name + '\n\n';
                    }
                    String cmnt = '';
                    strTC += 'Comment: ' + objE.Description;
                    strTC += '\n\n';
                    textSegmentInput.text = strTC;
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    entityLinkSegmentInput.entityId = mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
                    messageBodyInput.messageSegments.add(entityLinkSegmentInput); 
                    if(mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__c != null) {
                        ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                        linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__c+'\n\n';
                        linkInput.urlName = 'Click here to open in Service App';
                        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
                        feedElementCapabilitiesInput.link = linkInput;
                        feedItemInput.capabilities = feedElementCapabilitiesInput;
                    }
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = mapWOJ.get(objE.WhatId).BOATBUILDING__Work_Order_Warranty_Work_Order__c;
                    System.debug('>>>>>>>: '+objE.Type );
                    System.debug('>>>>>>>: '+mapWOJ.get(objE.WhatId).Technician__c );
                    System.debug('>>>>>>>IN: ');
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                    if(objE.Type == 'Customer Comment' || (objE.Type != 'Customer Comment' && mapWOJ.get(objE.WhatId).Technician__c != null)) {
                        System.debug('>>>>>>>: '+objE.Type );
                        System.debug('>>>>>>>: '+mapWOJ.get(objE.WhatId).Technician__c );
                        batchInputs.add(batchInput);   
                    }
                    System.debug('>>>>>>>batchInputs: '+batchInputs);
                    System.debug('>>>>>>>batchInputs.size: '+batchInputs.size());
                }   
            }
            Map<Id, BOATBUILDING__Work_Order__c> mapWO = new Map<Id, BOATBUILDING__Work_Order__c>([Select Id, Name, OwnerId, (Select Id, Name, OwnerId, BOATBUILDING__Work_Order__c From Dealership_Forms__r Order By CreatedDate DESC Limit 1) From BOATBUILDING__Work_Order__c Where Id IN: setWOJId]);
            for(Event objE: mapEvent.values()) {
                if(mapWO.containsKey(objE.WhatId) && objE.Type != 'Inspection Form Responded') { 
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    //Mention user here
                    mentionSegmentInput.id = mapWO.get(objE.WhatId).OwnerId;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                    String strTC = '';
                        strTC = '\n'+'Hi,\n  New comment added by customer on work order,\nWork Order Number: ' + mapWO.get(objE.WhatId).Name + '\n\n'; 
                    String cmnt = '';
                    strTC += 'Comment: ' + objE.Description;
                    strTC += '\n\n';
                    textSegmentInput.text = strTC; 
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    entityLinkSegmentInput.entityId = mapWO.get(objE.WhatId).Id;
                    messageBodyInput.messageSegments.add(entityLinkSegmentInput); 
                    if(mapWO.get(objE.WhatId).Id != null) {
                        ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                        linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+mapWO.get(objE.WhatId).Id+'\n\n';
                        linkInput.urlName = 'Click here to open in Service App';
                        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
                        feedElementCapabilitiesInput.link = linkInput;
                        feedItemInput.capabilities = feedElementCapabilitiesInput;
                    } 
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = mapWO.get(objE.WhatId).Id;
                    
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput);
                    if(objE.Type == 'Customer Comment')
                        batchInputs.add(batchInput);   
                    System.debug('>>>>>>>: '+objE.Type );
                    System.debug('>>>>>>>batchInputs: '+batchInputs);
                    System.debug('>>>>>>>batchInputs.size: '+batchInputs.size());
                } 
                else if(mapWO.containsKey(objE.WhatId) && objE.Type == 'Inspection Form Responded' && !mapWO.get(objE.WhatId).Dealership_Forms__r.isEmpty()) { 
                    Map<Id, BOATBUILDING__Dealership_Form__c> mapIF = new Map<Id, BOATBUILDING__Dealership_Form__c>();
                    mapIF.put(mapWO.get(objE.WhatId).Dealership_Forms__r[0].Id, mapWO.get(objE.WhatId).Dealership_Forms__r[0]);
                    String dsIf = mapWO.get(objE.WhatId).Dealership_Forms__r[0].Id;
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    ConnectApi.EntityLinkSegmentInput entityLinkSegmentInput = new ConnectApi.EntityLinkSegmentInput();
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    //Mention user here
                    mentionSegmentInput.id = mapWO.get(objE.WhatId).OwnerId;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);
                    String strTC = '';
                    strTC = '\n'+'Hi,\n  The inspection form: ' + mapIF.get(dsIf).Name + ', has been responded. Please check.\n\n'; 
                    textSegmentInput.text = strTC; 
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    entityLinkSegmentInput.entityId = mapIF.get(dsIf).Id;
                    messageBodyInput.messageSegments.add(entityLinkSegmentInput); 
                    if(mapIF.get(dsIf).Id != null) {
                        ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
                        linkInput.url = System.Url.getSalesforceBaseURL().toExternalForm()+'/'+mapIF.get(dsIf).Id+'\n\n';
                        linkInput.urlName = 'Click here to open.';
                        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();
                        feedElementCapabilitiesInput.link = linkInput;
                        feedItemInput.capabilities = feedElementCapabilitiesInput;
                    } 
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = mapIF.get(dsIf).BOATBUILDING__Work_Order__c;
                    
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(feedItemInput); 
                    batchInputs.add(batchInput);  
                    System.debug('>>>>>>>: '+objE.Type );
                    System.debug('>>>>>>>batchInputs: '+batchInputs);
                    System.debug('>>>>>>>batchInputs.size: '+batchInputs.size());
                }   
            }
            // Map<Id, BOATBUILDING__Dealership_Form__c> mapIF = new Map<Id, BOATBUILDING__Dealership_Form__c>([Select Id, Name, OwnerId, BOATBUILDING__Work_Order__c From BOATBUILDING__Dealership_Form__c Where Id IN: setWOJId]);
            // System.debug('>>>>mapIF: '+mapIF);
            // for(Event objE: mapEvent.values()) {
            //     if(mapIF.containsKey(objE.WhatId) && objE.Type.equalsIgnoreCase('Inspection Form Responded')) {
                    
            //     }
            // }
            if(!batchinputs.isEmpty()) {
                ConnectApi.BatchResult[] objCA_BR = ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
                System.debug('Debug Log For objCA_BR: '+objCA_BR);
            }
        }
    }

    //Called from Task Trigger
    public static void updateSalesServiceActivityScoreFromTask(Map<Id, Task> mapEvent) {
        Set<String> setAccId = new Set<String>();
        for(String srtEvt: mapEvent.keySet()) {
            if(mapEvent.get(srtEvt).WhatId != null && String.valueOf(mapEvent.get(srtEvt).WhatId).startsWithIgnoreCase('001')) {
                setAccId.add(mapEvent.get(srtEvt).WhatId);
            } 
        }
        Set<String> setServiceEventType = new Set<String>{'Inspection Form Created', 'Inspection Form Responded',
            'Customer Comment', 'Comment for Customer', 'Comment for Technician', 'Comment from Technician'};
                
        List<Account> lstAcc = [Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks),
                                (Select Description From Events WHERE Type NOT IN: setServiceEventType)
                                From Account Where Id =: setAccId];
        
        Map<Id, Account> mapAccForSalesActivity = new Map<Id, Account>([Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks),
                                                                        (Select Description From Events WHERE Type IN: setServiceEventType)
                                                                        From Account Where Id =: setAccId]);
        for(Account objAccount: lstAcc) {
            objAccount.BOATBUILDING__Sales_Activity_Score__c = (objAccount.Tasks.size() +  objAccount.Events.size()) * 5;
            if(mapAccForSalesActivity.containsKey(objAccount.Id)){
                objAccount.BOATBUILDING__Service_score__c = (mapAccForSalesActivity.get(objAccount.Id).Tasks.size() +  mapAccForSalesActivity.get(objAccount.Id).Events.size()) * 5;
            }
        }
        update lstAcc;
    }
    
    public static void afterInsert(List<Event> lstEvt){
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        
        for(Event objEvent : lstEvt){
           System.debug('objEvent_-------------'+objEvent);
            if(objEvent.DurationInMinutes != 0 && objEvent.DurationInMinutes != 1440 ) {
                BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
                Id ScheduleRTId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();
                
                String evId = String.valueOf(objEvent.Id).subString(0,15);
                objTm.BOATBUILDING__Event_Id__c = evId; 
                objTm.RecordTypeId = ScheduleRTId;
                objTm.BOATBUILDING__Schedule_Date_Time__c = objEvent.StartDateTime;
                objTM.BOATBUILDING__End_Schedule_Date_Time__c = objEvent.EndDateTime;
                if(objEvent.Subject.containsIgnoreCase('Test Drive')){
                    objTM.BOATBUILDING__Type__c = 'Test Drive';
                    objTM.BOATBUILDING__Event_Name__c = 'Test Drive';
                }
                else
                {
                    objTM.BOATBUILDING__Type__c = 'Sales';
                    objTM.BOATBUILDING__Event_Name__c = 'Sales Event';
                }
                Id sId = objEvent.WhatId;
                if(String.isNotBlank(String.valueOf(sId)))
                {
                    String sobjectType = sId.getSObjectType().getDescribe().getName();
                    if(sobjectType == 'BOATBUILDING__Inventory__c')
                    {
                        objTM.BOATBUILDING__Inventory__c = objEvent.WhatId;
                    }
                    if(sobjectType == 'BOATBUILDING__Work_Order_Job__c')
                    {
                        objTM.BOATBUILDING__Related_Work_Order_Job__c = objEvent.WhatId;
                    }
                    if(sobjectType == 'BOATBUILDING__Work_Order__c')
                    {
                        objTM.BOATBUILDING__Work_Order__c = objEvent.WhatId;
                    }
                    if(sobjectType == 'BOATBUILDING__Quote__c')
                    {
                        objTM.BOATBUILDING__Quote__c = objEvent.WhatId;
                    }
                }
                
                
                objTM.BOATBUILDING__Description__c = objEvent.Description;
                
                if( objEvent.OwnerId != null && String.valueOf(objEvent.OwnerId).startsWith('005')){
                    objTM.BOATBUILDING__Technician__c = objEvent.OwnerId;
                }
                
                lstTM.add(objTM);
            }
        }
        
        if(lstTM.size() > 0)
        {
            insert lstTM;
        }
        
        notifyAppForWOEvent(lstEvt);
    }
    
    public static void afterUpdate(List<Event> lstEvt){   
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        List<BOATBUILDING__Time_Management__c> lstTMToUpdate = new List<BOATBUILDING__Time_Management__c>();
        Id ScheduleRTId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();
        
        Set<String> eventId = new Set<String>();
        for(Event e : lstEvt)
        {
            String evId = String.valueOf(e.Id).subString(0,15);
            eventId.add(evId);
        }
        System.debug(eventId);
        Map<String, String> m = new Map<String, String>();
        for(BOATBUILDING__Time_Management__c objt : [Select Id, BOATBUILDING__Event_Id__c from BOATBUILDING__Time_Management__c 
                                                     where BOATBUILDING__Event_Id__c != null AND RecordTypeId =: ScheduleRTId 
                                                     AND BOATBUILDING__Event_Id__c IN : eventId limit 50000 ])
        {
            
            m.put(objt.BOATBUILDING__Event_Id__c, objt.Id );
        }
        for(Event objEvent : lstEvt){
            if(!objEvent.Subject.containsIgnoreCase('Comment on')) {
                BOATBUILDING__Time_Management__c objTm = new BOATBUILDING__Time_Management__c();
                
                String evId = String.valueOf(objEvent.Id).subString(0,15);
                System.debug('??????'+m+'------'+evId);
                if(m.containsKey(evId))
                {
                    objTm.Id = m.get(evId);
                    objTm.RecordTypeId = ScheduleRTId;
                    objTm.BOATBUILDING__Schedule_Date_Time__c = objEvent.StartDateTime;
                    objTM.BOATBUILDING__End_Schedule_Date_Time__c = objEvent.EndDateTime;
                    Id sId = objEvent.WhatId;
                    //String sobjectType = sId.getSObjectType().getDescribe().getName();
                    if(objEvent.Subject.containsIgnoreCase('Test Drive'))
                    {
                        objTM.BOATBUILDING__Type__c = 'Test Drive';
                        objTM.BOATBUILDING__Event_Name__c = 'Test Drive';
                        //objTM.Name = 'Test Drive';
                    }
                    else
                    {
                        objTM.BOATBUILDING__Type__c = 'Sales';
                        objTM.BOATBUILDING__Event_Name__c = 'Sales Event';
                    }
                    if(String.isNotBlank(String.valueOf(sId)))
                    {
                        String sobjectType = sId.getSObjectType().getDescribe().getName();
                        if(sobjectType == 'BOATBUILDING__Inventory__c')
                        {
                            objTM.BOATBUILDING__Inventory__c = objEvent.WhatId;
                            
                        }
                        if(sobjectType == 'BOATBUILDING__Work_Order_Job__c')
                        {
                            objTM.BOATBUILDING__Related_Work_Order_Job__c = objEvent.WhatId;
                        }
                        if(sobjectType == 'BOATBUILDING__Work_Order__c')
                        {
                            objTM.BOATBUILDING__Work_Order__c = objEvent.WhatId;
                        }
                        if(sobjectType == 'BOATBUILDING__Quote__c')
                        {
                            objTM.BOATBUILDING__Quote__c = objEvent.WhatId;
                        }
                    }
                    
                    objTM.BOATBUILDING__Description__c = objEvent.Description;
                    if( objEvent.OwnerId != null && String.valueOf(objEvent.OwnerId).startsWith('005')){
                        objTM.BOATBUILDING__Technician__c = objEvent.OwnerId;
                    }
                    lstTMToUpdate.add(objTM);
                }
                else
                {
                    
                    objTm.RecordTypeId = ScheduleRTId;
                    objTm.BOATBUILDING__Event_Id__c = evId;
                    objTm.BOATBUILDING__Schedule_Date_Time__c = objEvent.StartDateTime;
                    objTM.BOATBUILDING__End_Schedule_Date_Time__c = objEvent.EndDateTime;
                    Id sId = objEvent.WhatId;
                    
                    if(objEvent.Subject.containsIgnoreCase('Test Drive'))
                    {
                        objTM.BOATBUILDING__Type__c = 'Test Drive';
                        // objTM.Name = 'Test Drive';
                        objTM.BOATBUILDING__Event_Name__c = 'Test Drive';
                    }
                    else
                    {
                        objTM.BOATBUILDING__Type__c = 'Sales';
                        //objTM.Name = 'Sales Event';
                        objTM.BOATBUILDING__Event_Name__c = 'Sales Event';
                    }
                    if(String.isNotBlank(String.valueOf(sId)))
                    {
                        String sobjectType = sId.getSObjectType().getDescribe().getName();
                        if(sobjectType == 'BOATBUILDING__Inventory__c')
                        {
                            objTM.BOATBUILDING__Inventory__c = objEvent.WhatId;
                        }
                        if(sobjectType == 'BOATBUILDING__Work_Order_Job__c')
                        {
                            objTM.BOATBUILDING__Related_Work_Order_Job__c = objEvent.WhatId;
                        }
                        if(sobjectType == 'BOATBUILDING__Work_Order__c')
                        {
                            objTM.BOATBUILDING__Work_Order__c = objEvent.WhatId;
                        }
                        if(sobjectType == 'BOATBUILDING__Quote__c')
                        {
                            objTM.BOATBUILDING__Quote__c = objEvent.WhatId;
                        }
                    }
                    objTM.BOATBUILDING__Description__c = objEvent.Description;
                    if( objEvent.OwnerId != null && String.valueOf(objEvent.OwnerId).startsWith('005')){
                        objTM.BOATBUILDING__Technician__c = objEvent.OwnerId;
                    }
                    lstTM.add(objTM);
                }
            }
        }
        
        if(lstTM.size() > 0)
        {
            insert lstTM;
        }
        if(lstTMToUpdate.size() > 0)
        {
            update lstTMToUpdate;
        }
    }
    
    public static void notifyAppForWOEvent(List<Event> lstEvt){
        
        Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe();
        Schema.SObjectType s = m.get('BOATBUILDING__Work_Order__c');
        String keyPrefix = s.getDescribe().getKeyPrefix();

        for(Event objEvent : lstEvt){
            if(String.isNotBlank(objEvent.WhatId) && String.valueOf(objEvent.WhatId).startsWith(keyPrefix)){
                sendAppCallout(objEvent.WhatId, objEvent.Id);
            }
        }
    }
    
    @future(callout = true)
    public static void sendAppCallout(Id newWorkOrderId, Id eventId){
        
        Map<String, String> mapRequestBody = new Map<String, String>();
        mapRequestBody.put('salesforce_org_id', 'stws.secure');
        mapRequestBody.put('workorder_id', newWorkOrderId);
        mapRequestBody.put('event_id', eventId);
        HttpRequest req = new HttpRequest();
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjhhYWE5MjQxZjA4NzJhNDA3NmUyMDU0MDI2NWEwMjlhZGI2NDY2NmEzOWVkMmIxNzY3ZmFjZjJhZDg4NTc3YzA2N2MwM2FmYzNiOTYyYjMyIn0.eyJhdWQiOiIxIiwianRpIjoiOGFhYTkyNDFmMDg3MmE0MDc2ZTIwNTQwMjY1YTAyOWFkYjY0NjY2YTM5ZWQyYjE3NjdmYWNmMmFkODg1NzdjMDY3YzAzYWZjM2I5NjJiMzIiLCJpYXQiOjE2MDAzNjU2NjQsIm5iZiI6MTYwMDM2NTY2NCwiZXhwIjoxNjMxOTAxNjY0LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Q1Rx7o1ffBsCpnOCSnV6nlkresBvEG_n_h3lFdcNw-5BmgN9QBQs5JrhG-ZkirrI6CUiluwuapzTgz6yglShMkQYXvh8rXsM7RCopmM791p-CF32P6GZkgU93-W_cKhVsgk4QQI7SGfjE-3_9_swnRz3Qt0M8G_QkXi-Yy_-0jHF0gVQcYPvMUYq5rRO5xl0pT739AO0tOHh8HFLEukd-TSvjGjl4jKuZWwwOGNnrWbmr3vhuXiuv1OUB70vhQrC33snsidlYEo2P9GNVD6pbBV5o351CoojvaiWcxqxUqKmfOeZaZJYkCEsSgYLrVGfqoHKPFqDWszbV4G94E-dh0hUWXRmJcDlRz_PuLIiYWlDOZQ5pzb6Lr9270kg45dsHf9nm6BVNwP1GqvdDAJrL44DSrUhLWkdTV-IsH29XYGNLb17_2Al5tZ1iRwLoI1a8McaWRRifSWbJ6DIq4aZIlfiLzuv7XxirTo-0RF2IdS980MSrBAYoRsbAWKW2mUYwiLkvUSmGzEq-Dzi2kms377hXbH2q56W7-KTRxMNsczPH0C0OjbAkAmDSV2IHttJnXpybhhf6aMIPYYCn3irfdJVjUZFGS1UlmecB7Opci09aH10zX0e5AthuYZ6c-oBWMN1c9OvUr49WpTdRTKqYwsNJdILUTVSQsQCarWiijQ');
        req.setEndpoint('https://appmanager.fadealership.com/api/workOrder/event/update');
        req.setMethod('POST');
        String body = JSON.serialize(mapRequestBody);
        req.setBody(body);
        Http http = new Http();
        if(!Test.isRunningTest()){
            HttpResponse res = http.send(req);
            System.debug('APP res---'+res);
        }
    }
}