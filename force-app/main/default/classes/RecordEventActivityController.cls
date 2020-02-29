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
    public static String addCustomerComment(String subject, String customerComment, String whatId, String whoId, String accountId, String sectionName){
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
        lstEvent.add(e2);
        
        Event e3 = new Event();
        e3.whatId = accountId;
        if(sectionName == 'Work Order Section'){
            
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
        return 'Success';
    }
}