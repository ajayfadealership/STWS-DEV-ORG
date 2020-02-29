public with sharing class ServiceInspectionFormController {
    
    public BOATBUILDING__Dealership_Form__c objDF { get; set; }
    public String flag { get; set; }
    public boolean isServiceTech { get; set; }
    
    public ServiceInspectionFormController() {
        flag = '0';
        isServiceTech = false;
        User u = [Select Id, UserRoleId, UserRole.Name From User Where Id =: UserInfo.getUserId()];
        if(u.UserRoleId != null && u.UserRole.Name == 'Service Tech') {
            isServiceTech = true;
        }
        objDF = new BOATBUILDING__Dealership_Form__c();
        if(ApexPages.currentPage().getParameters().get('woId') != null && ApexPages.currentPage().getParameters().get('woId') != '') {
            Work_Order__c objWO = [Select 
                                   Id, Name, Hours__c, BOATBUILDING__Contact__c, Account__c, Account__r.Phone, Account__r.Email__c, BOATBUILDING__Boat__r.BOATBUILDING__Boat_HIN_No__c,BOATBUILDING__Boat__r.Name,
                                   (Select Id,BOATBUILDING__Speakers_CDN__c,BOATBUILDING__Rudder_Assembly_CDN__c,BOATBUILDING__Battery_ies_CDN__c,BOATBUILDING__Snaps_CDN__c,BOATBUILDING__Anchor_Light_CDN__c,BOATBUILDING__Anodes_Zincs_CDN__c,BOATBUILDING__Ballast_Pump_CDN__c,BOATBUILDING__Battery_Cables_CDN__c,BOATBUILDING__Belts_CDN__c,BOATBUILDING__Bilge_Inspection_CDN__c ,BOATBUILDING__Bilge_Pump_CDN__c,BOATBUILDING__Bimini_Top_CDN__c,BOATBUILDING__Canvas_Cover_CDN__c,BOATBUILDING__Carpet_CDN__c,BOATBUILDING__Cockpit_Lights_CDN__c,BOATBUILDING__Depth_Finder_CDN__c,BOATBUILDING__Docking_Lights_CDN__c,BOATBUILDING__Exterior_Details_CDN__c,BOATBUILDING__Fire_Extinguisher_CDN__c,BOATBUILDING__Gauges_CDN__c,BOATBUILDING__Gel_Coat_CDN__c,BOATBUILDING__Hinges_CDN__c,BOATBUILDING__Horn_CDN__c,BOATBUILDING__Hoses_CDN__c,BOATBUILDING__Impeller_CDN__c,BOATBUILDING__Impeller_Housing_CDN__c,BOATBUILDING__Interior_Detail_CDN__c,BOATBUILDING__Interior_Lights_CDN__c,BOATBUILDING__Latches_CDN__c,BOATBUILDING__Nav_Light_CDN__c,BOATBUILDING__Stereo_CDN__c,BOATBUILDING__Swim_Platform_Hardware_CDN__c,BOATBUILDING__Tracking_Fins_CDN__c,BOATBUILDING__Trailer_Brakes_CDN__c,BOATBUILDING__Trailer_Condition_CDN__c,BOATBUILDING__Trailer_Lights_CDN__c,BOATBUILDING__Trailer_Tires_CDN__c,BOATBUILDING__Vinyl_CDN__c, BOATBUILDING__Horn_EC__c,BOATBUILDING__Impeller_EC__c,BOATBUILDING__Gel_Coat_EC__c,Stereo_EC__c,Impeller_Housing_EC__c,BOATBUILDING__Propeller_EC__c,BOATBUILDING__Speakers_EC__c,BOATBUILDING__Battery_ies_EC__c ,BOATBUILDING__Depth_Finder_EC__c,BOATBUILDING__Belts_EC__c,BOATBUILDING__Hinges_EC__c ,BOATBUILDING__Gauges_EC__c,BOATBUILDING__Hoses_EC__c,BOATBUILDING__Latches_EC__c,BOATBUILDING__Bilge_Pump_EC__c,BOATBUILDING__Ballast_Pump_EC__c,BOATBUILDING__Swim_Platform_Hardware_EC__c,BOATBUILDING__Interior_Lights_EC__c,BOATBUILDING__Battery_Cables_EC__c,BOATBUILDING__Prop_Shaft_Packing_EC__c,BOATBUILDING__Cockpit_Lights_EC__c,BOATBUILDING__Paddlewheel_EC__c,BOATBUILDING__Exterior_Details_EC__c,BOATBUILDING__Docking_Lights_EC__c,BOATBUILDING__Bilge_Inspection_EC__c,BOATBUILDING__Nav_Light_EC__c,BOATBUILDING__Snaps_EC__c ,BOATBUILDING__Anodes_Zincs_EC__c,BOATBUILDING__Canvas_Cover_EC__c,BOATBUILDING__Anchor_Light_EC__c ,BOATBUILDING__Spark_Plugs_EC__c,BOATBUILDING__Bimini_Top_EC__c,BOATBUILDING__Fire_Extinguisher_EC__c,BOATBUILDING__Rudder_Assembly_EC__c,BOATBUILDING__Vinyl_EC__c,BOATBUILDING__Interior_Detail_EC__c,BOATBUILDING__Tracking_Fins_EC__c,BOATBUILDING__Carpet_EC__c,BOATBUILDING__Trailer_Condition_EC__c,BOATBUILDING__Trailer_Brakes_EC__c,BOATBUILDING__Guide_Pole_Covers_EC__c,BOATBUILDING__Trailer_Lights_EC__c,BOATBUILDING__Trailer_Tires_EC__c, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, BOATBUILDING__HIN__c, BOATBUILDING__Boat_Name_Location__c, BOATBUILDING__Engine_Warranty_Expiry__c, BOATBUILDING__Engine_Hours__c, BOATBUILDING__Compression_Comment__c	,BOATBUILDING__Recommended_Service_Notes__c,BOATBUILDING__MISC_1__c,BOATBUILDING__MISC_2__c,BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c, BOATBUILDING__Phone__c, BOATBUILDING__Email__c, BOATBUILDING__Preferred_Method_Of_Contact__c, BOATBUILDING__Horn__c, BOATBUILDING__Stereo__c, BOATBUILDING__Speakers__c, BOATBUILDING__Depth_Finder__c, BOATBUILDING__Gauges__c, BOATBUILDING__Bilge_Pump__c, BOATBUILDING__Interior_Lights__c, BOATBUILDING__Cockpit_Lights__c, BOATBUILDING__Docking_Lights__c, BOATBUILDING__Nav_Light__c, BOATBUILDING__Anchor_Light__c, BOATBUILDING__Fire_Extinguisher__c, BOATBUILDING__Interior_Detail__c, BOATBUILDING__Gel_Coat__c, BOATBUILDING__Propeller__c, BOATBUILDING__Snaps__c, BOATBUILDING__Hinges__c, BOATBUILDING__Latches__c, BOATBUILDING__Swim_Platform_Hardware__c, BOATBUILDING__Prop_Shaft_Packing__c, BOATBUILDING__Exterior_Details__c, BOATBUILDING__Trailer_Condition__c, BOATBUILDING__Trailer_Lights__c, BOATBUILDING__Trailer_Brakes__c, BOATBUILDING__Trailer_Tires__c, BOATBUILDING__Guide_Pole_Covers__c, BOATBUILDING__Impeller__c, BOATBUILDING__Impeller_Housing__c, BOATBUILDING__Battery_ies__c, BOATBUILDING__Belts__c, BOATBUILDING__Hoses__c, BOATBUILDING__Ballast_Pump__c, BOATBUILDING__Battery_Cables__c, BOATBUILDING__Paddlewheel__c, BOATBUILDING__Anodes_Zincs__c, BOATBUILDING__Spark_Plugs__c, BOATBUILDING__Rudder_Assembly__c, BOATBUILDING__Tracking_Fins__c, BOATBUILDING__Canvas_Cover__c, BOATBUILDING__Bimini_Top__c, BOATBUILDING__Vinyl__c, BOATBUILDING__Carpet__c, BOATBUILDING__Boat__c, BOATBUILDING__Inventory__c, BOATBUILDING__Customer__c, BOATBUILDING__Bilge_Inspection__c, BOATBUILDING__Technician__c, BOATBUILDING__Technician__r.Name, BOATBUILDING__Work_Order__c From BOATBUILDING__Dealership_Forms__r) 
                                   From 
                                   Work_Order__c Where Id =: ApexPages.currentPage().getParameters().get('woId')];
            
            objDF.BOATBUILDING__Work_Order__c = objWO.Id;
            if(objWO.Account__c != null)
                objDF.BOATBUILDING__Customer__c = objWO.Account__c;
            
            if(objWO.Account__r.Phone != null)                              
                objDF.Phone__c = objWO.Account__r.Phone;
            
            if(objWO.Account__r.Email__c != null)           
                objDF.Email__c = objWO.Account__r.Email__c;
            
            if(objWO.BOATBUILDING__Boat__r.BOATBUILDING__Boat_HIN_No__c != null)
                objDF.BOATBUILDING__HIN__c = objWO.BOATBUILDING__Boat__r.BOATBUILDING__Boat_HIN_No__c;
            
            if(objWO.BOATBUILDING__Boat__r.Name != null)    
                objDF.BOATBUILDING__Boat_Name_Location__c = objWO.BOATBUILDING__Boat__r.Name;
            
            if(objWO.Hours__c != null && isDecimal(String.valueOf(objWO.Hours__c)))      
                objDF.BOATBUILDING__Engine_Hours__c = Decimal.valueOf(objWO.Hours__c);
            
            if(objWO.BOATBUILDING__Dealership_Forms__r != null && !objWO.BOATBUILDING__Dealership_Forms__r.isEmpty()) {
                flag = '1';
                objDF= objWO.BOATBUILDING__Dealership_Forms__r[0]; 
                if(objWO.Hours__c != null && isDecimal(String.valueOf(objWO.Hours__c)))
                    objDF.BOATBUILDING__Engine_Hours__c = Decimal.valueOf(objWO.Hours__c);
            }
            if(objWO.Hours__c != null && isDecimal(String.valueOf(objWO.Hours__c)))
                objDF.BOATBUILDING__Engine_Hours__c = Decimal.valueOf(objWO.Hours__c);
        }
        if(objDF.Technician__c == null ) {
            objDF.Technician__c = UserInfo.getUserId();
        }	
        // objDF.Technician__c = UserInfo.getUserId();
    }
    
    private static Boolean isDecimal(String str) {
        try {
            Decimal decCheck = Decimal.valueOf(str);
            return true;
        } catch(Exception ex) {
            return false;
        }
    } 
    
    @RemoteAction
    public static BOATBUILDING__Dealership_Form__c getformRecord(String frmId) {
        BOATBUILDING__Dealership_Form__c objDF = [Select  BOATBUILDING__Speakers_CDN__c,BOATBUILDING__Rudder_Assembly_CDN__c,BOATBUILDING__Battery_ies_CDN__c,BOATBUILDING__Snaps_CDN__c,BOATBUILDING__Anchor_Light_CDN__c,BOATBUILDING__Anodes_Zincs_CDN__c,BOATBUILDING__Ballast_Pump_CDN__c,BOATBUILDING__Battery_Cables_CDN__c,BOATBUILDING__Belts_CDN__c,BOATBUILDING__Bilge_Inspection_CDN__c ,BOATBUILDING__Bilge_Pump_CDN__c,BOATBUILDING__Bimini_Top_CDN__c,BOATBUILDING__Canvas_Cover_CDN__c,BOATBUILDING__Carpet_CDN__c,BOATBUILDING__Cockpit_Lights_CDN__c,BOATBUILDING__Depth_Finder_CDN__c,BOATBUILDING__Docking_Lights_CDN__c,BOATBUILDING__Exterior_Details_CDN__c,BOATBUILDING__Fire_Extinguisher_CDN__c,BOATBUILDING__Gauges_CDN__c,BOATBUILDING__Gel_Coat_CDN__c,BOATBUILDING__Hinges_CDN__c,BOATBUILDING__Horn_CDN__c,BOATBUILDING__Hoses_CDN__c,BOATBUILDING__Impeller_CDN__c,BOATBUILDING__Impeller_Housing_CDN__c,BOATBUILDING__Interior_Detail_CDN__c,BOATBUILDING__Interior_Lights_CDN__c,BOATBUILDING__Latches_CDN__c,BOATBUILDING__Nav_Light_CDN__c,BOATBUILDING__Stereo_CDN__c,BOATBUILDING__Swim_Platform_Hardware_CDN__c,BOATBUILDING__Tracking_Fins_CDN__c,BOATBUILDING__Trailer_Brakes_CDN__c,BOATBUILDING__Trailer_Condition_CDN__c,
                                                  BOATBUILDING__Trailer_Lights_CDN__c,BOATBUILDING__Trailer_Tires_CDN__c,BOATBUILDING__Vinyl_CDN__c, 
                                                  BOATBUILDING__Horn_EC__c,BOATBUILDING__Impeller_EC__c,BOATBUILDING__Gel_Coat_EC__c,Stereo_EC__c,Impeller_Housing_EC__c,BOATBUILDING__Propeller_EC__c,BOATBUILDING__Speakers_EC__c,BOATBUILDING__Battery_ies_EC__c ,BOATBUILDING__Depth_Finder_EC__c,BOATBUILDING__Belts_EC__c,BOATBUILDING__Hinges_EC__c ,BOATBUILDING__Gauges_EC__c,BOATBUILDING__Hoses_EC__c,BOATBUILDING__Latches_EC__c,BOATBUILDING__Bilge_Pump_EC__c,BOATBUILDING__Ballast_Pump_EC__c,BOATBUILDING__Swim_Platform_Hardware_EC__c,BOATBUILDING__Interior_Lights_EC__c,BOATBUILDING__Battery_Cables_EC__c,BOATBUILDING__Prop_Shaft_Packing_EC__c,BOATBUILDING__Cockpit_Lights_EC__c,BOATBUILDING__Paddlewheel_EC__c,BOATBUILDING__Exterior_Details_EC__c,BOATBUILDING__Docking_Lights_EC__c,BOATBUILDING__Bilge_Inspection_EC__c,BOATBUILDING__Nav_Light_EC__c,BOATBUILDING__Snaps_EC__c ,BOATBUILDING__Anodes_Zincs_EC__c,BOATBUILDING__Canvas_Cover_EC__c,BOATBUILDING__Anchor_Light_EC__c ,BOATBUILDING__Spark_Plugs_EC__c,BOATBUILDING__Bimini_Top_EC__c,BOATBUILDING__Fire_Extinguisher_EC__c,BOATBUILDING__Rudder_Assembly_EC__c,BOATBUILDING__Vinyl_EC__c,BOATBUILDING__Interior_Detail_EC__c,BOATBUILDING__Tracking_Fins_EC__c,BOATBUILDING__Carpet_EC__c,BOATBUILDING__Trailer_Condition_EC__c,BOATBUILDING__Trailer_Brakes_EC__c,BOATBUILDING__Guide_Pole_Covers_EC__c,BOATBUILDING__Trailer_Lights_EC__c,BOATBUILDING__Trailer_Tires_EC__c, Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, BOATBUILDING__HIN__c, BOATBUILDING__Boat_Name_Location__c, BOATBUILDING__Engine_Warranty_Expiry__c, BOATBUILDING__Engine_Hours__c,BOATBUILDING__MISC_1__c,BOATBUILDING__MISC_2__c,BOATBUILDING__Compression_Comment__c,BOATBUILDING__Recommended_Service_Notes__c,BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c, BOATBUILDING__Phone__c, BOATBUILDING__Email__c, BOATBUILDING__Preferred_Method_Of_Contact__c, BOATBUILDING__Horn__c, BOATBUILDING__Stereo__c, BOATBUILDING__Speakers__c, BOATBUILDING__Depth_Finder__c, BOATBUILDING__Gauges__c, BOATBUILDING__Bilge_Pump__c, BOATBUILDING__Interior_Lights__c, BOATBUILDING__Cockpit_Lights__c, BOATBUILDING__Docking_Lights__c, BOATBUILDING__Nav_Light__c, BOATBUILDING__Anchor_Light__c, BOATBUILDING__Fire_Extinguisher__c, BOATBUILDING__Interior_Detail__c, BOATBUILDING__Gel_Coat__c, BOATBUILDING__Propeller__c, BOATBUILDING__Snaps__c, BOATBUILDING__Hinges__c, BOATBUILDING__Latches__c, BOATBUILDING__Swim_Platform_Hardware__c, BOATBUILDING__Prop_Shaft_Packing__c, BOATBUILDING__Exterior_Details__c, BOATBUILDING__Trailer_Condition__c, BOATBUILDING__Trailer_Lights__c, BOATBUILDING__Trailer_Brakes__c, BOATBUILDING__Trailer_Tires__c, BOATBUILDING__Guide_Pole_Covers__c, BOATBUILDING__Impeller__c, BOATBUILDING__Impeller_Housing__c, BOATBUILDING__Battery_ies__c, BOATBUILDING__Belts__c, BOATBUILDING__Hoses__c, BOATBUILDING__Ballast_Pump__c, BOATBUILDING__Battery_Cables__c, BOATBUILDING__Paddlewheel__c, BOATBUILDING__Anodes_Zincs__c, BOATBUILDING__Spark_Plugs__c, BOATBUILDING__Rudder_Assembly__c, BOATBUILDING__Tracking_Fins__c, BOATBUILDING__Canvas_Cover__c, BOATBUILDING__Bimini_Top__c, BOATBUILDING__Vinyl__c, BOATBUILDING__Carpet__c, BOATBUILDING__Boat__c, BOATBUILDING__Inventory__c, BOATBUILDING__Customer__c, BOATBUILDING__Bilge_Inspection__c, BOATBUILDING__Technician__c, BOATBUILDING__Work_Order__c From BOATBUILDING__Dealership_Form__c Where Id =: frmId];
        return objDF;
    }
    public List<SelectOption> getOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            BOATBUILDING__Dealership_Form__c.BOATBUILDING__Vinyl__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getOptionsCDN() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            BOATBUILDING__Dealership_Form__c.BOATBUILDING__Horn_CDN__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getWay() {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
            BOATBUILDING__Dealership_Form__c.BOATBUILDING__Preferred_Method_Of_Contact__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    @RemoteAction
    public static String saveFormRecord(Map<String, String> mapDF) {
        try {
            BOATBUILDING__Dealership_Form__c objDF = new BOATBUILDING__Dealership_Form__c();
            objDF.RecordTypeId = Schema.SObjectType.BOATBUILDING__Dealership_Form__c.getRecordTypeInfosByName().get('Inspection Form').getRecordTypeId();
            
            if(mapDF != null) {
                for(String str: mapDF.keySet()) {
                    if(mapDF.get(str) != null && mapDF.get(str) != '' && str != 'BOATBUILDING__Engine_Warranty_Expiry__c' && str != 'BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c' && str != 'BOATBUILDING__Engine_Hours__c' && str != 'BOATBUILDING__Engine_Hours__c' && !str.containsIgnoreCase('EC__c')) {
                        objDF.put(str, mapDF.get(str)); 
                    } else if(str == 'BOATBUILDING__Engine_Warranty_Expiry__c'  || str == 'BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c' ) {
                        if(mapDF.get(str) != '' && mapDF.get(str).contains('/')) {
                            String [] strDT = mapDF.get(str).split('/');
                            objDF.put(str, Date.newInstance(Integer.valueOf(strDT[2]), Integer.valueOf(strDT[0]), Integer.valueOf(strDT[1])));
                        } 
                    } else if(str == 'BOATBUILDING__Engine_Hours__c' && isDecimal(String.valueOf(mapDF.get(str)))) {
                        
                        objDF.put(str, Decimal.valueOf(mapDF.get(str)));
                    } else if(str.containsIgnoreCase('EC__c')  && isDecimal(String.valueOf(mapDF.get(str)))) {
                         objDF.put(str, Decimal.valueOf(mapDF.get(str)));
                    } 
                }
                if(mapDF.get('BOATBUILDING__Work_Order__c') != null) {
                    Work_Order__c objWO = [Select Id, Name, Hours__c From Work_Order__c Where Id =: mapDF.get('BOATBUILDING__Work_Order__c')];
                    
                    if(mapDF.get('BOATBUILDING__Engine_Hours__c') != null) {
                        objWO.Hours__c = String.valueOf(mapDF.get('BOATBUILDING__Engine_Hours__c'));
                        update objWO;
                    }  
                }
                /*if(mapDF.get('BOATBUILDING__Horn_EC__c') != null){
                    objDF.BOATBUILDING__Horn_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Horn_EC__c'));
                    
                }
                
                if(mapDF.get('BOATBUILDING__Impeller_EC__c') != null){
                    objDF.BOATBUILDING__Impeller_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Impeller_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Gel_Coat_EC__c') != null){
                    objDF.BOATBUILDING__Gel_Coat_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Gel_Coat_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Stereo_EC__c') != null){
                    objDF.BOATBUILDING__Stereo_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Stereo_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Impeller_Housing_EC__c') != null){
                    objDF.BOATBUILDING__Impeller_Housing_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Impeller_Housing_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Propeller_EC__c') != null){
                    objDF.BOATBUILDING__Propeller_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Propeller_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Speakers_EC__c') != null){
                    objDF.BOATBUILDING__Speakers_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Speakers_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Battery_ies_EC__c') != null){
                    objDF.BOATBUILDING__Battery_ies_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Battery_ies_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Depth_Finder_EC__c') != null){
                    objDF.BOATBUILDING__Depth_Finder_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Depth_Finder_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Belts_EC__c') != null){
                    objDF.BOATBUILDING__Belts_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Belts_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Hinges_EC__c') != null){
                    objDF.BOATBUILDING__Hinges_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Hinges_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Gauges_EC__c') != null){
                    objDF.BOATBUILDING__Gauges_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Gauges_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Hoses_EC__c') != null){
                    objDF.BOATBUILDING__Hoses_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Hoses_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Latches_EC__c') != null){
                    objDF.BOATBUILDING__Latches_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Latches_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Bilge_Pump_EC__c') != null){
                    objDF.BOATBUILDING__Bilge_Pump_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Bilge_Pump_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Ballast_Pump_EC__c') != null){
                    objDF.BOATBUILDING__Ballast_Pump_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Ballast_Pump_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Swim_Platform_Hardware_EC__c') != null){
                    objDF.BOATBUILDING__Swim_Platform_Hardware_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Swim_Platform_Hardware_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Interior_Lights_EC__c') != null){
                    objDF.BOATBUILDING__Interior_Lights_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Interior_Lights_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Battery_Cables_EC__c') != null){
                    objDF.BOATBUILDING__Battery_Cables_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Battery_Cables_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Prop_Shaft_Packing_EC__c') != null){
                    objDF.BOATBUILDING__Prop_Shaft_Packing_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Prop_Shaft_Packing_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Cockpit_Lights_EC__c') != null){
                    objDF.BOATBUILDING__Cockpit_Lights_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Cockpit_Lights_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Paddlewheel_EC__c') != null){
                    objDF.BOATBUILDING__Paddlewheel_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Paddlewheel_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Exterior_Details_EC__c') != null){
                    objDF.BOATBUILDING__Exterior_Details_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Exterior_Details_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Docking_Lights_EC__c') != null){
                    objDF.BOATBUILDING__Docking_Lights_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Docking_Lights_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Bilge_Inspection_EC__c') != null){
                    objDF.BOATBUILDING__Bilge_Inspection_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Bilge_Inspection_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Nav_Light_EC__c') != null){
                    objDF.BOATBUILDING__Nav_Light_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Nav_Light_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Anodes_Zincs_EC__c') != null){
                    objDF.BOATBUILDING__Anodes_Zincs_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Anodes_Zincs_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Canvas_Cover_EC__c') != null){
                    objDF.BOATBUILDING__Canvas_Cover_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Canvas_Cover_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Anchor_Light_EC__c') != null){
                    objDF.BOATBUILDING__Anchor_Light_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Anchor_Light_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Spark_Plugs_EC__c') != null){
                    objDF.BOATBUILDING__Spark_Plugs_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Spark_Plugs_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Bimini_Top_EC__c') != null){
                    objDF.BOATBUILDING__Bimini_Top_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Bimini_Top_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Fire_Extinguisher_EC__c') != null){
                    objDF.BOATBUILDING__Fire_Extinguisher_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Fire_Extinguisher_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Rudder_Assembly_EC__c') != null){
                    objDF.BOATBUILDING__Rudder_Assembly_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Rudder_Assembly_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Vinyl_EC__c') != null){
                    objDF.BOATBUILDING__Vinyl_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Vinyl_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Interior_Detail_EC__c') != null){
                    objDF.BOATBUILDING__Interior_Detail_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Interior_Detail_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Tracking_Fins_EC__c') != null){
                    objDF.BOATBUILDING__Tracking_Fins_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Tracking_Fins_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Carpet_EC__c') != null){
                    objDF.BOATBUILDING__Carpet_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Carpet_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Trailer_Condition_EC__c') != null){
                    objDF.BOATBUILDING__Trailer_Condition_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Trailer_Condition_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Trailer_Brakes_EC__c') != null){
                    objDF.BOATBUILDING__Trailer_Brakes_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Trailer_Brakes_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Guide_Pole_Covers_EC__c') != null){
                    objDF.BOATBUILDING__Guide_Pole_Covers_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Guide_Pole_Covers_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Trailer_Lights_EC__c') != null){
                    objDF.BOATBUILDING__Trailer_Lights_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Trailer_Lights_EC__c'));
                }
                if(mapDF.get('BOATBUILDING__Trailer_Tires_EC__c') != null){
                    objDF.BOATBUILDING__Trailer_Tires_EC__c = decimal.valueOf(mapDF.get('BOATBUILDING__Trailer_Tires_EC__c'));
                }*/
                
                
            }
            System.debug('objDF: '+objDF);
            
            objDF.Technician__c = UserInfo.getUserId();
            
            /*if(objDF.Id == null) {
List<RecordType> lstRecType = [SELECT Id FROM RecordType WHERE DeveloperName = 'Schedule' AND SObjectType = 'BOATBUILDING__Time_Management__c' LIMIT 1];
BOATBUILDING__Time_Management__c objTM = new BOATBUILDING__Time_Management__c();
objTM.RecordTypeId = lstRecType[0].Id;
}*/
            
            upsert objDF;
            
            Task tk = new Task();
            tk.Subject = 'Inspection Form';
            tk.ActivityDate = Date.today();
            tk.OwnerId = UserInfo.getUserId();
            tk.WhatId = objDF.Id;
            insert tk;
            /*
String siteURL = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c;

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();


List<String> sendTo = new List<String>();
sendTo.add(UserInfo.getUserEmail());
mail.setToAddresses(sendTo);

mail.setSubject('Inspection Form');
String body = 'Hello ' +UserInfo.getName() + ', <br/> Please find the following inspection form URL:<br/>'+siteURL+'/apex/BOATBUILDING__ServiceIFPDF?Id='+objDF.Id+'<br/><br/>Thank you.';
mail.setHtmlBody(body);
List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
mails.add(mail);
Messaging.sendEmail(mails);
*/
            return objDF.Id;
        } catch(Exception ex) {
            return 'Error: '+ex.getMessage() + ' : ' + ex.getLineNumber();
        }
    }
}