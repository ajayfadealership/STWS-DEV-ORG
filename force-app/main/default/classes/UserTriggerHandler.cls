public with sharing class UserTriggerHandler {
    
    public static void countAccountOnAssignedUserinsert(List<User> lstuser)
    {
        list<User> lstofexistinguser = new list<User>();
        
        for(User u : lstuser)
        { 
            system.debug('insideusertrigger');
            system.debug('testttt'+u.UserRoleid);
            
            if(u.UserRoleid !=null)
                lstofexistinguser = [select id, BOATBUILDING__Assigned_Lead_Count__c, UserType from user where UserRoleid =: u.UserRoleid order by BOATBUILDING__Assigned_Lead_Count__c ];
            
            if(lstofexistinguser!=null && lstofexistinguser.size()>0)
            {
                if(u.id==null)
                    u.BOATBUILDING__Assigned_Lead_Count__c = lstofexistinguser[0]. BOATBUILDING__Assigned_Lead_Count__c;
            }
        }
    }
    
    
    public static void countAccountOnAssignedUserupdate(List<User> lstuser)
    {
        list<User> lstofexistinguser = new list<User>();
        
        for(User u : lstuser)
        {
            system.debug('insideusertrigger');
            system.debug('testttt'+u.UserRoleid);
            
            if(u.UserRoleid !=null)
                lstofexistinguser = [select id, BOATBUILDING__Assigned_Lead_Count__c, UserType from user where UserRoleid =: u.UserRoleid and id != :u.id order by BOATBUILDING__Assigned_Lead_Count__c ];
            
            if(lstofexistinguser!=null && lstofexistinguser.size()>0)
            {
                u.BOATBUILDING__Assigned_Lead_Count__c = lstofexistinguser[0]. BOATBUILDING__Assigned_Lead_Count__c;
            }
        }
    }
}