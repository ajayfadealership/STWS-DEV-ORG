@isTest
public class EventTriggerHandlerTest {
    testmethod static void Test1(){
        BOATBUILDING__TriggerSetting__c ObjTriggerSetting = new BOATBUILDING__TriggerSetting__c();
        ObjTriggerSetting.BOATBUILDING__EventTriggerCheckBox__c = true;
        insert ObjTriggerSetting;
        
        BOATBUILDING__Time_Management__c objTime = new BOATBUILDING__Time_Management__c();
        objTime.BOATBUILDING__Event_Name__c='Name';
        objTime.BOATBUILDING__Type__c = 'Drive';
        insert objTime;
        
         BOATBUILDING__Time_Management__c objTime1 = new BOATBUILDING__Time_Management__c();
         objTime1.BOATBUILDING__Event_Name__c='Sales Event';
         objTime1.BOATBUILDING__Type__c = 'Sales';
         insert objTime1;
        
        map<Id,Task> maptk = new map<Id,Task>();
        Task objtk = new Task ();
        objtk.CallType ='out';
        objtk.Priority='Normal';
        objtk.Subject='Donni';
        objtk.Status='New';
        maptk.put(objtk.Id,objtk);
        
        
        
        Account objacc = new Account();
        objacc.Name = 'abc';
        objacc.BOATBUILDING__Sales_Activity_Score__c = 1234;
        
        
        list<Event> lstEvent = new list<Event>();
        Event objEv = new Event();
        objEv.Subject='Test Drive';
        objEv.DurationInMinutes=55;
        objEv.ActivityDateTime=system.now();
        objEv.WhatId = objTime.id;
        insert objEv;
        objEv.DurationInMinutes=59;
        update objEv;
        lstEvent.add(objEv); 
        
        EventTriggerHandler.afterInsert(lstEvent);
        EventTriggerHandler.afterUpdate(lstEvent);
        EventTriggerHandler.afterInsertCountTsk(maptk);
       
    } 
     testmethod static void Test2(){
       
        
        Event objEv = new Event();
        objEv.Subject='eve';
        objEv.DurationInMinutes=55;
        objEv.ActivityDateTime=system.now();
       // objEv.WhatId = objTime.id;
        insert objEv; 
         
        BOATBUILDING__Time_Management__c objTime=new BOATBUILDING__Time_Management__c();
        objTime.BOATBUILDING__Event_Name__c='Name';
        objTime.BOATBUILDING__Type__c = 'Drive';
        objTime.BOATBUILDING__Inventory__c = objEv.WhatId;
        insert objTime;
    } 
    testmethod static void Test3(){
       
        BOATBUILDING__Work_Order_Job__c objJob = new BOATBUILDING__Work_Order_Job__c();
        objJob.BOATBUILDING__Claim_Status_New__c ='Closed';
        insert objJob;
        Event objEv = new Event();
        objEv.Subject='eve';
        objEv.DurationInMinutes=55;
        objEv.ActivityDateTime=system.now();
        objEv.WhatId = objJob.id;
        insert objEv; 
       
    } 
     testmethod static void Test4(){
        BOATBUILDING__Work_Order__c objWork= new BOATBUILDING__Work_Order__c();
        objWork.BOATBUILDING__Discount__c=60;
        insert objWork;
        Event objEv = new Event();
        objEv.Subject='eve';
        objEv.DurationInMinutes=55;
        objEv.ActivityDateTime=system.now();
        objEv.WhatId = objWork.id;
        insert objEv; 
       
    } 
    testmethod static void Test5(){
       BOATBUILDING__Inventory__c objInv=new BOATBUILDING__Inventory__c();
        objInv.BOATBUILDING__ACV__c=900;
        insert objInv;
        Event objEv = new Event();
        objEv.Subject='eve';
        objEv.DurationInMinutes=55;
        objEv.ActivityDateTime=system.now();
        objEv.WhatId = objInv.id;
        insert objEv; 
       
    } 
    
}