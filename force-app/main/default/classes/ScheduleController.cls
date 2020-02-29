public with sharing class ScheduleController {
    
    public BOATBUILDING__Time_Management__c objTM { get; set; }
    public String timeZone { get; set; }
    public Boolean techCheck { get; set; }
    public String UId { get; set; }
    public String currentUser { get; set; }
    public ScheduleController()  {
        objTM = new BOATBUILDING__Time_Management__c();
        currentUser = UserInfo.getUserId();
        techCheck = false;
        String currentUserRoleId = UserInfo.getUserRoleId();
        List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: currentUserRoleId Limit 1];
        Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
        if(!lstUR.isEmpty()) {
            if(mapURD.containsKey(lstUR[0].Name)) { 
                techCheck = true; 
            }
        }
        timeZone = UserInfo.getTimeZone().toString();
        UId = UserInfo.getUserId();
        User u = [Select Id, UserRoleId, UserRole.Name From User Where Id =: UserInfo.getUserId()];
        if(u.UserRoleId != null && u.UserRole.Name == 'Service Tech') {
            
            //UId = u.Id;
        }
    }
    
    @RemoteAction
    public static List<User> getUserDetails() {
        List<User> lstUser = new List<User>(); 
        lstUser = [Select Id, Name, Schedule_Texted_Color_Code__c, Schedule_Color_Code__c From User Where isActive = true Limit 1000 ];
        return lstUser;
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Time_Management__c> fetchRelatedEvents(String strUserId, String type) {
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        if(strUserId == 'All') {
            if(type == '0' || type == 'All') {
                lstTM = [SELECT
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         RecordType.DeveloperName = 'Schedule'];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Type__c =: type];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            } 
        } else {
            if(type == '0' || type == 'All') {
                lstTM = [SELECT 
                         Technician__r.Name, Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Technician__c =: strUserId
                         AND 
                         RecordType.DeveloperName = 'Schedule'];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Id, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Technician__c =: strUserId
                         AND 
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Type__c =: type];  
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            }
        }
        
        return lstTM;  
    } 
    
    @RemoteAction
    public static List<BOATBUILDING__Time_Management__c> fetchRelatedEventsWithType(String type, String UserId) {
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        if(UserId == '0' || UserId == 'All') {
            if(type == 'All') { 
                lstTM = [SELECT 
                         Id, Name, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Technician__r.Name, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c   
                         FROM  
                         BOATBUILDING__Time_Management__c  
                         WHERE  
                         RecordType.DeveloperName = 'Schedule']; 
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Id, Name, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Technician__r.Name, Schedule_Date_Time__c, Work_Order__c,Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Type__c =: type
                         AND
                         RecordType.DeveloperName = 'Schedule']; 
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            }    
        } else {
            if(type == 'All') {
                lstTM = [SELECT 
                         Id, Name, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Technician__r.Name, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Technician__c =: UserId]; 
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }    
            } else {
                lstTM = [SELECT 
                         Id, Name, Event_Name__c, Description__c, Inventory__c, BOATBUILDING__Work_Order__r.RecordType.Name, BOATBUILDING__Work_Order__r.Status__c, Related_Work_Order_Job__c, BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c, End_Schedule_Date_Time__c, Technician__c, Technician__r.Name, Schedule_Date_Time__c, Work_Order__c, Technician__r.Schedule_Color_Code__c, Technician__r.Schedule_Texted_Color_Code__c  
                         FROM  
                         BOATBUILDING__Time_Management__c
                         WHERE  
                         Type__c =: type
                         AND
                         RecordType.DeveloperName = 'Schedule'
                         AND 
                         Technician__c =: UserId]; 
                
                for(BOATBUILDING__Time_Management__c obj : lstTM) {
                    obj.Schedule_Date_Time__c = obj.Schedule_Date_Time__c;
                    obj.End_Schedule_Date_Time__c = obj.End_Schedule_Date_Time__c;
                }
            }
        }
        
        return lstTM; 
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Work_Order__c> fetchRelatedWorkOrders(String strUserId){
        List<BOATBUILDING__Work_Order__c> lstWO = new List<BOATBUILDING__Work_Order__c>();
        List<BOATBUILDING__Time_Management__c> lstTM = new List<BOATBUILDING__Time_Management__c>();
        
        lstTM = [SELECT 
                 Id, Work_Order__c  
                 FROM  
                 BOATBUILDING__Time_Management__c
                 WHERE  
                 Work_Order__c <> NUll]; 
        Set<String> setIdWO = new Set<String>();
        if(lstTM.isEmpty()) {
            for(BOATBUILDING__Time_Management__c objIT: lstTM) {
                setIdWO.add(objIT.Work_Order__c);
            }
        }
        
        lstWO = [Select Id, Name, Contact__r.Name, Balance__c, RecordType.DeveloperName From BOATBUILDING__Work_Order__c Where Id NOT IN: setIdWO AND Status__c != 'Closed' AND Contact__c != NULL];  
        return lstWO;     
    }
    
    @RemoteAction
    public static String resizeEvent(String eventEndDate, String eventId ) {
        List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
        Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
        
        List<BOATBUILDING__Time_Management__c> lstEvent = [Select End_Schedule_Date_Time__c from BOATBUILDING__Time_Management__c  where id =: eventId];
        try {
            if(lstEvent.size() > 0) {
                BOATBUILDING__Time_Management__c objTM =  lstEvent[0];
                
                String endtime = String.valueOf(eventEndDate).substringAfter('T');
                String newEndDate = eventEndDate.substringBefore('T')+' '+endtime;
                objTM.End_Schedule_Date_Time__c = DateTime.valueOf(newEndDate);
                if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                    update objTM;          
                } else {
                    return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
                }
                
            }
        } catch(Exception e) {
            return 'Error: '+e.getMessage();
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static String drageEvent(String eventStartDate, String eventEndDate, String eventId ) {
        List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
        Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
        
        List<BOATBUILDING__Time_Management__c> lstEvent = [Select Schedule_Date_Time__c, End_Schedule_Date_Time__c, Description__c from BOATBUILDING__Time_Management__c  where id =: eventId];
        try {
            if(lstEvent.size() > 0) {
                BOATBUILDING__Time_Management__c objTM =  lstEvent[0];
                
                String strttime = String.valueOf(eventStartDate).substringAfter('T');
                String newDate = eventStartDate.substringBefore('T')+' '+strttime;
                objTM.Schedule_Date_Time__c = DateTime.valueOf(newDate);
                
                String endtime = String.valueOf(eventEndDate).substringAfter('T');
                String newEndDate = eventEndDate.substringBefore('T')+' '+endtime;
                objTM.End_Schedule_Date_Time__c = DateTime.valueOf(newEndDate);
                
                if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                    update objTm;
                } else {
                    return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
                }
            } 
        } catch(Exception e) {
            return 'Error: '+e.getMessage();
        }
        return 'SUCCESS';
    }
    
    
    @RemoteAction
    public static String SaveEvent(Map<String, String> mapEventDetails) {
        try {
            List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
            Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
            List<RecordType> lstRecType = [SELECT
                                           Id
                                           FROM 
                                           RecordType
                                           WHERE
                                           DeveloperName = 'Schedule'
                                           AND
                                           SObjectType = 'BOATBUILDING__Time_Management__c'
                                           LIMIT 
                                           1];
            if(!lstRecType.isEmpty()) {
                BOATBUILDING__Time_Management__c objTM = new BOATBUILDING__Time_Management__c();
                
                objTM.RecordTypeId = lstRecType[0].Id;
                if(String.isNotBlank(mapEventDetails.get('WOId'))) {
                    objTM.Work_Order__c = mapEventDetails.get('WOId');
                    Work_Order__c objWO = [Select Id, Status__c From Work_Order__c Where Id =: mapEventDetails.get('WOId')];
                    objWO.Status__c = 'Scheduled';
                    update objWO;
                } else if(String.isNotBlank(mapEventDetails.get('JobId'))) {
                    objTM.Related_Work_Order_Job__c = mapEventDetails.get('JobId');
                }
                if(mapEventDetails.get('TechnicianId') != null)
                    objTM.Technician__c = mapEventDetails.get('TechnicianId');
                //objTM.Event_Name__c = mapEventDetails.get('EventName'); 
                objTM.Description__c = mapEventDetails.get('Description');
                objTM.Schedule_Date_Time__c = DateTime.valueOf(mapEventDetails.get('StartDate').replace('T',' ')+':'+'00');
                System.debug('mapEventDetails.get(\'StartDate\')'+mapEventDetails.get('StartDate'));
                objTM.End_Schedule_Date_Time__c = DateTime.valueOf(mapEventDetails.get('EndDate').replace('T',' ')+':'+'00');
                objTM.Type__c = 'Work Order/Jobs';
                if(mapEventDetails.get('ServiceLocation') != null) {
	                objTM.BOATBUILDING__Service_Location__c = mapEventDetails.get('ServiceLocation');
	            }
                if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                    insert objTM;
                } else {
                    return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
                }
            } else { 
                return 'Check Record Type, size: ['+lstRecType.size()+']'; 
            }
        } catch(Exception ex) {
            return 'Error: '+ex;
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static String getWoTechInfoApex(String strWOId) {
    	Work_Order__c objWO = [Select 
		                                Id, Name, Hours__c, BOATBUILDING__Contact__c, Account__c, Account__r.Phone, Account__r.Email__c, BOATBUILDING__Boat__r.BOATBUILDING__Boat_HIN_No__c,BOATBUILDING__Boat__r.Name,
		                                (Select Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, BOATBUILDING__HIN__c, BOATBUILDING__Boat_Name_Location__c, BOATBUILDING__Engine_Warranty_Expiry__c, BOATBUILDING__Engine_Hours__c, BOATBUILDING__Compression_Comment__c	,BOATBUILDING__Recommended_Service_Notes__c,BOATBUILDING__MISC_1__c,BOATBUILDING__MISC_2__c,BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c, BOATBUILDING__Phone__c, BOATBUILDING__Email__c, BOATBUILDING__Preferred_Method_Of_Contact__c, BOATBUILDING__Horn__c, BOATBUILDING__Stereo__c, BOATBUILDING__Speakers__c, BOATBUILDING__Depth_Finder__c, BOATBUILDING__Gauges__c, BOATBUILDING__Bilge_Pump__c, BOATBUILDING__Interior_Lights__c, BOATBUILDING__Cockpit_Lights__c, BOATBUILDING__Docking_Lights__c, BOATBUILDING__Nav_Light__c, BOATBUILDING__Anchor_Light__c, BOATBUILDING__Fire_Extinguisher__c, BOATBUILDING__Interior_Detail__c, BOATBUILDING__Gel_Coat__c, BOATBUILDING__Propeller__c, BOATBUILDING__Snaps__c, BOATBUILDING__Hinges__c, BOATBUILDING__Latches__c, BOATBUILDING__Swim_Platform_Hardware__c, BOATBUILDING__Prop_Shaft_Packing__c, BOATBUILDING__Exterior_Details__c, BOATBUILDING__Trailer_Condition__c, BOATBUILDING__Trailer_Lights__c, BOATBUILDING__Trailer_Brakes__c, BOATBUILDING__Trailer_Tires__c, BOATBUILDING__Guide_Pole_Covers__c, BOATBUILDING__Impeller__c, BOATBUILDING__Impeller_Housing__c, BOATBUILDING__Battery_ies__c, BOATBUILDING__Belts__c, BOATBUILDING__Hoses__c, BOATBUILDING__Ballast_Pump__c, BOATBUILDING__Battery_Cables__c, BOATBUILDING__Paddlewheel__c, BOATBUILDING__Anodes_Zincs__c, BOATBUILDING__Spark_Plugs__c, BOATBUILDING__Rudder_Assembly__c, BOATBUILDING__Tracking_Fins__c, BOATBUILDING__Canvas_Cover__c, BOATBUILDING__Bimini_Top__c, BOATBUILDING__Vinyl__c, BOATBUILDING__Carpet__c, BOATBUILDING__Boat__c, BOATBUILDING__Inventory__c, BOATBUILDING__Customer__c, BOATBUILDING__Bilge_Inspection__c, BOATBUILDING__Technician__c, BOATBUILDING__Technician__r.Name, BOATBUILDING__Work_Order__c From BOATBUILDING__Dealership_Forms__r) 
                            	From Work_Order__c Where Id =: strWOId];
                                                    
                                                    
	    if(!objWO.BOATBUILDING__Dealership_Forms__r.isEmpty() && objWO.BOATBUILDING__Dealership_Forms__r[0].BOATBUILDING__Technician__c != null) {
	    	return objWO.BOATBUILDING__Dealership_Forms__r[0].BOATBUILDING__Technician__c+':'+objWO.BOATBUILDING__Dealership_Forms__r[0].BOATBUILDING__Technician__r.Name;
	    } else {
	    	return 'NONE';
	    }
    }
    
    @RemoteAction
    public static String SaveEventPD(Map<String, String> mapEventDetails) {
        try {
            List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
            Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
            List<RecordType> lstRecType = [SELECT
                                           Id
                                           FROM 
                                           RecordType
                                           WHERE
                                           DeveloperName = 'Schedule'
                                           AND
                                           SObjectType = 'BOATBUILDING__Time_Management__c'
                                           LIMIT 
                                           1];
            if(!lstRecType.isEmpty()) {
                BOATBUILDING__Time_Management__c objTM = new BOATBUILDING__Time_Management__c();
                
                objTM.RecordTypeId = lstRecType[0].Id; 
                if(String.isNotBlank(mapEventDetails.get('WOId'))) {
                    objTM.Work_Order__c = mapEventDetails.get('WOId');
                    Work_Order__c objWO = [Select Id, Status__c From Work_Order__c Where Id =: mapEventDetails.get('WOId')];
                    objWO.Status__c = 'Scheduled';
                    update objWO; 
                } else if(String.isNotBlank(mapEventDetails.get('JobId'))) {
                    objTM.Related_Work_Order_Job__c = mapEventDetails.get('JobId');
                }
                objTM.Contact__c = mapEventDetails.get('CustomerId'); 
                if(mapEventDetails.get('TechnicianId') != null)
                    objTM.Technician__c = mapEventDetails.get('TechnicianId');
                //objTM.Event_Name__c = mapEventDetails.get('EventName'); 
                objTM.Description__c = mapEventDetails.get('Description');
                objTM.Schedule_Date_Time__c = DateTime.valueOf(mapEventDetails.get('StartDate').replace('T',' ')+':'+'00');
                objTM.End_Schedule_Date_Time__c = objTM.Schedule_Date_Time__c .addHours(1); 
                objTM.Type__c = mapEventDetails.get('TypeOfEvent');
                if(mapEventDetails.get('ServiceLocation') != null) {
	                objTM.BOATBUILDING__Service_Location__c = mapEventDetails.get('ServiceLocation');
	            }
                if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                    insert objTM; 
                } else {
                    return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
                }
            } else { 
                return 'Check Record Type, size: ['+lstRecType.size()+']'; 
            }
        } catch(Exception ex) {
            return 'Error: '+ex;
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static String updateEvent(Map<String, String> mapEvntDetail) {
        try {
            List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
            Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
            List<BOATBUILDING__Time_Management__c> lstTM = [Select Id, Work_Order__c, Related_Work_Order_Job__c, Description__c From BOATBUILDING__Time_Management__c Where Id =: mapEvntDetail.get('EventId') Limit 1];
            System.debug('(mapEvntDetail.get(StartDate): '+mapEvntDetail.get('StartDate'));
            lstTM[0].Schedule_Date_Time__c = DateTime.valueOf(mapEvntDetail.get('StartDate').replace('T',' ')+':'+'00');
            lstTM[0].End_Schedule_Date_Time__c = DateTime.valueOf(mapEvntDetail.get('EndDate').replace('T',' ')+':'+'00');
            lstTM[0].Description__c = mapEvntDetail.get('Description');
            
            if(mapEvntDetail.get('TechnicianId') != null) {
                lstTM[0].Technician__c = mapEvntDetail.get('TechnicianId');
            }
            if(mapEvntDetail.get('ServiceLocation') != null) {
                lstTM[0].BOATBUILDING__Service_Location__c = mapEvntDetail.get('ServiceLocation');
            }
            
            if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                update lstTM[0];
            } else {
                return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
            }
        } catch(Exception ex) {
            return 'Error: '+ex;
        }
        return 'SUCCESS';
    }
    
    @RemoteAction
    public static List<object> checkEvent(String eventId) {
        List<Object> lstObj = new List<Object>();
        List<BOATBUILDING__Time_Management__c> lstTM = [Select Id, BOATBUILDING__Service_Location__c, Event_Name__c, Type__c, Technician__r.Name, Work_Order__c, Inventory__c, Quote__c, Related_Work_Order_Job__c, Description__c From BOATBUILDING__Time_Management__c Where Id =: eventId Limit 1];
        
        if(lstTM[0].Type__c != null && (lstTM[0].Type__c.equalsIgnoreCase('Pickup') || lstTM[0].Type__c.equalsIgnoreCase('Drop'))) {
            lstObj.add(lstTM[0].Type__c);
            lstObj.add(lstTM[0].Type__c);
            lstObj.add(lstTM[0].Type__c);
            lstObj.add(lstTM[0].Type__c); 
            lstObj.add(lstTM[0].Type__c);
            lstObj.add(lstTM[0].Type__c);
            if(lstTM[0].Work_Order__c != null) {
                List<BOATBUILDING__Work_Order__c> lstWO = [Select Id, Name, Balance__c, RecordType.DeveloperName From BOATBUILDING__Work_Order__c Where Id =: lstTM[0].Work_Order__c Limit 1];
                lstObj.add(lstWO[0]);
            }
        }
        else if(lstTM[0].Related_Work_Order_Job__c != null) {
            List<BOATBUILDING__Work_Order_Job__c> lstJob= [Select Id, Name, Work_Order_Warranty_Work_Order__c From BOATBUILDING__Work_Order_Job__c Where Id =: lstTM[0].Related_Work_Order_Job__c Limit 1];
            
            if(!lstJob.isEmpty()) {
                if(lstJob[0].Work_Order_Warranty_Work_Order__c != null) {
                    lstObj.add(lstJob[0]);
                    List<BOATBUILDING__Work_Order__c> lstWO = [Select Id, Name, Balance__c, RecordType.DeveloperName From BOATBUILDING__Work_Order__c Where Id =: lstJob[0].Work_Order_Warranty_Work_Order__c Limit 1];
                    lstObj.add(lstWO[0]);
                }
            }
        }
        else if(lstTM[0].Work_Order__c != null) {
            List<BOATBUILDING__Work_Order__c> lstWO = [Select Id, Name, Balance__c, RecordType.DeveloperName From BOATBUILDING__Work_Order__c Where Id =: lstTM[0].Work_Order__c Limit 1];
            lstObj.add(lstWO[0]);
        } 
        else if(lstTM[0].Inventory__c != null) {
            List<Inventory__c> lstInv = [Select Id, Name From Inventory__c Where Id =: lstTM[0].Inventory__c Limit 1];    
            lstObj.add('Inventory');
            lstObj.add('Inventory');
            lstObj.add(lstInv[0]);
        }
        else if(lstTM[0].Quote__c != null) {
            List<Quote__c> lstQT = [Select Id, Name From Quote__c Where Id =: lstTM[0].Quote__c Limit 1];    
            lstObj.add('Quote');
            lstObj.add('Quote');
            lstObj.add('Quote');
            lstObj.add(lstQT[0]);
        } else {
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
            lstObj.add('BLANK');
        }
        lstObj.add(lstTM[0]);
        return lstObj;
    }
    
    @RemoteAction
    public static List<Object> fetchWorkOrder(String objCaseId) {
        
        List<Object> lstObj = new List<Object>();
        BOATBUILDING__Work_Order__c objCase = [SELECT 
                                               Account__c,
                                               Contact__c,
                                               ContactEmail__c,
                                               Contact__r.FirstName,
                                               Contact__r.Phone,
                                               Contact__r.LastName,
                                               Contact__r.MailingStreet,
                                               Contact__r.Email,
                                               Contact__r.MailingPostalCode,
                                               Contact__r.MailingCity,
                                               RecordType.Name,
                                               Boat__c,
                                               Boat__r.Name, 
                                               Boat__r.Boat_Model__c,
                                               Boat__r.Boat_HIN_No__c,
                                               Boat__r.Engine_SN__c, 
                                               Boat__r.Trailer_VIN__c,
                                               Boat__r.Boat_Manufacturer__c,
                                               Boat__r.Boat_Manufacturer__r.Name,
                                               Boat__r.M_Boat_Year__c,
                                               Boat__r.CreatedDateCustom__c,
                                               Name,
                                               Drive__c,
                                               Hours__c,
                                               Discount__c,
                                               Status__c,
                                               Priority__c,
                                               ContactPhone__c,
                                               Total_Parts__c,
                                               Total_Labor__c,
                                               Total_Shop_Supplies__c,
                                               Total__c,
                                               Sales_Tax__c,
                                               Total_Amount_Due__c,
                                               Total_Payment_job__c,
                                               BOATBUILDING__Total_Payment_payment__c,
                                               BOATBUILDING__Balance__c,
                                               BOATBUILDING__CreatedDate__c,
                                               ID,
                                               Created_Date_Formula__c
                                               FROM 
                                               BOATBUILDING__Work_Order__c
                                               WHERE  
                                               Id =: objCaseId 
                                               LIMIT 
                                               1];
        List<BOATBUILDING__Work_Order_Job__c> joblist = [Select 
                                                         Work_Type__c, 
                                                         Type__c, 
                                                         Name, 
                                                         Job_Name__c,
                                                         No_of_Labors__c, 
                                                         Price_per_Labor__c, 
                                                         Total_Cost_Labor__c, 
                                                         Shop_Supplies_Total__c, 
                                                         Shipping_Charge__c,
                                                         Total_Amount_Job__c, 
                                                         Total_Amount_on_Parts_del__c,
                                                         Customer_Pay__c,
                                                         Total_Hours_Job__c,
                                                         Worked_Hours__c,
                                                         Discount__c,
                                                         Id,
                                                         Work_Order_Warranty_Work_Order__r.Description__c,
                                                         Comments__c,
                                                         (Select
                                                          Id,
                                                          Name,
                                                          Part_Number__c,
                                                          Part_Name__c,
                                                          Quantity__c,
                                                          Price__c,
                                                          Total__c,
                                                          Related_to_Job__c
                                                          From
                                                          BOATBUILDING__Work_Order_Job_Line_Items__r
                                                         )
                                                         From 
                                                         BOATBUILDING__Work_Order_Job__c where Work_Order_Warranty_Work_Order__c =: objCase.Id];
        
        lstObj.add(objCase);
        
        if(!joblist.isEmpty()) {
            lstObj.add(joblist);
        }
        
        return lstObj;
    }
    
    @RemoteAction
    public Static String deleteEvent(String strEventId) {
        try {
            delete [Select Id From BOATBUILDING__Time_Management__c Where Id =: strEventId];
        } catch(Exception ex) {
            return 'Exception: '+ex;
        }
        return 'SUCCESS';
    }
    @AuraEnabled
    public static string getrecordType(){
        String recTypeId = Schema.SObjectType.BOATBUILDING__Time_Management__c.getRecordTypeInfosByName().get('Schedule').getRecordTypeId();
        return recTypeId;
    }
    @AuraEnabled
    public static String updateTechOnALlJobs(String strTMId) {
        try {
            BOATBUILDING__Time_Management__c objTM = [SELECT 
                                                                Id, Name, BOATBUILDING__Work_Order__c, BOATBUILDING__Technician__c, BOATBUILDING__Related_Work_Order_Job__c 
                                                    FROM 
                                                                BOATBUILDING__Time_Management__c Where Id =: strTMId];
            if(objTM.BOATBUILDING__Related_Work_Order_Job__c != null) {
                objTM.BOATBUILDING__Work_Order__c = null;
                update objTM;
            }
            if(objTM.BOATBUILDING__Work_Order__c != null) {
                List<BOATBUILDING__Work_Order_Job__c> lstJB = [SELECT Id FROM BOATBUILDING__Work_Order_Job__c WHERE BOATBUILDING__Completed__c = false AND BOATBUILDING__Work_Order_Warranty_Work_Order__c =: objTM.BOATBUILDING__Work_Order__c];  
                if(!lstJB.isEmpty()) {
                    for(BOATBUILDING__Work_Order_Job__c objJB: lstJB) {
                        objJB.BOATBUILDING__Technician__c = objTM.BOATBUILDING__Technician__c;
                    }
                    update lstJB;
                }
            } 
            
            return 'SUCCESS';
        } catch(Exception ex) {
            System.debug('Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber());
            return 'Error: '+ex.getMessage()+' Line Number: '+ex.getLineNumber()+' : '+ex.getStackTraceString();
        }
    }

}