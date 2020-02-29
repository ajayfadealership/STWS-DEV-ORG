public class EventTriggerHandler
{
    
    public static void afterInsertCount(Map<Id, Event> mapEvent) {
        Set<String> setAccId = new Set<String>();
        for(String srtEvt: mapEvent.keySet()) {
            if(mapEvent.get(srtEvt).WhatId != null && String.valueOf(mapEvent.get(srtEvt).WhatId).startsWithIgnoreCase('001')) {
                setAccId.add(mapEvent.get(srtEvt).WhatId);
            } 
        }
        List<Account> lstAcc = [Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks), (Select Description From Events) From Account Where Id =: setAccId];
        for(Account objAccount: lstAcc) {
            objAccount.BOATBUILDING__Sales_Activity_Score__c = (objAccount.Tasks.size() +  objAccount.Events.size()) * 5; 
        }
        update lstAcc;
    }
    
    public static void afterInsertCountTsk(Map<Id, Task> mapEvent) {
        Set<String> setAccId = new Set<String>();
        for(String srtEvt: mapEvent.keySet()) {
            if(mapEvent.get(srtEvt).WhatId != null && String.valueOf(mapEvent.get(srtEvt).WhatId).startsWithIgnoreCase('001')) {
                setAccId.add(mapEvent.get(srtEvt).WhatId);
            } 
        }
        List<Account> lstAcc = [Select Id, BOATBUILDING__Sales_Activity_Score__c, (Select Id From Tasks), (Select Description From Events) From Account Where Id =: setAccId];
        for(Account objAccount: lstAcc) {
            objAccount.BOATBUILDING__Sales_Activity_Score__c = (objAccount.Tasks.size() +  objAccount.Events.size()) * 5; 
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
        req.setHeader('Authorization', 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY2NGNmY2JlMGUyZWYyZTQxMTJlMjgzYjdmZjkzZmU2NmVhNjg0ZDA4MmNiOTVkNGMxNWZkYThmMWZlMWQzM2M5ZjVlMmFkMjk5YmVlMTVkIn0.eyJhdWQiOiIxIiwianRpIjoiNjY0Y2ZjYmUwZTJlZjJlNDExMmUyODNiN2ZmOTNmZTY2ZWE2ODRkMDgyY2I5NWQ0YzE1ZmRhOGYxZmUxZDMzYzlmNWUyYWQyOTliZWUxNWQiLCJpYXQiOjE1Njg3MzkyODMsIm5iZiI6MTU2ODczOTI4MywiZXhwIjoxNjAwMzYxNjgzLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.JHS6FrIzQ9WnTu7q5L88cMs9nAWegs3-a1wWP7YFqIRAyPMPv8BS6Ms05gQLSOrcg_bOpVkc4Qht8ZEtHBxDHO-Puf-XbDm6-IQ3oTiYwYl5pL4eGKYEDAaXD5xncukV7kh0DzaQIcTL7uZ0zeahMGO-SldjGlJ81wEuFK2zas6q0uEotaF8LqasBw7a-N35Zq6Fk78A39PLmIFjpBq4RatZrP8UJB8EZMxjjWzbjG7MFDIazuAlVB8ehBtVaZk3J6B6JoWURldO_ESvkw2ZdNKZ-rPf4obvsTe9FbhoKOoLCiWBIwVu2QYAzw8anH-wWKGDN4_04DFqUFui0h15wJMUpr2gPaY-K5EO3gjxOntdCuaW5BZJG6NTZEFcS-bgcg01OkfHxO2-MqHIbETeNJ4xlh2oRt9E6bMYGUSI3jKEJRStqHyHbW_lvqcLfX82nEGvlj-N6s76FteRtOzcvKZAQFladwepPB3HJjt2LZLeaF_s_ehJ4Q71zJ5TjTBRPFzXVwpOG62ZFjh3SFxOtxYU36nuKTAwjzaaARGb9wN3FQWDpjTzG3Frn_A4fZUIWSCknBqJrsGmB4qlzvINLzIWsIjsK5QdZ9nw432K4B0-GlXgkVkykSckwlwLsemPel6dAcUI_9wMlbBKgZY0yUR43SK6P9pypNZtsIeoXi8');
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