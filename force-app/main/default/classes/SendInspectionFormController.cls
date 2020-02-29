public with sharing class SendInspectionFormController {
    public String strTo { get; set; }
    public String strCC { get; set; }
    public String strSubject { get; set; }
    public String strBody { get; set; }
    public Dealership_Form__c objDF { get; set; }
    public SendInspectionFormController() {
    		
    		
    		String siteURL = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c;
    		
    		objDF = [Select 
                            b.RecordTypeId, b.OwnerId, b.Name, b.LastViewedDate, b.LastReferencedDate, b.LastModifiedDate, b.LastModifiedById, b.LastActivityDate, b.IsDeleted, 
                            b.Id, b.CreatedDate, b.CreatedById, b.BOATBUILDING__Work_Order__c, b.BOATBUILDING__Vinyl__c, b.BOATBUILDING__Trailer_Tires__c, b.BOATBUILDING__Trailer_Lights__c, 
                            b.BOATBUILDING__Trailer_Condition__c, b.BOATBUILDING__Trailer_Brakes__c, b.BOATBUILDING__Tracking_Fins__c, b.BOATBUILDING__Technician__c, b.BOATBUILDING__Technician__r.Name, 
                            b.BOATBUILDING__Swim_Platform_Hardware__c, b.BOATBUILDING__Stereo__c, b.BOATBUILDING__Speakers__c, b.BOATBUILDING__Spark_Plugs__c, b.BOATBUILDING__Snaps__c, 
                            b.BOATBUILDING__Rudder_Assembly__c, b.BOATBUILDING__Propeller__c, b.BOATBUILDING__Prop_Shaft_Packing__c, b.BOATBUILDING__Preferred_Method_Of_Contact__c, 
                            b.BOATBUILDING__Phone__c, b.BOATBUILDING__Paddlewheel__c, b.BOATBUILDING__Nav_Light__c, b.BOATBUILDING__Latches__c, b.BOATBUILDING__Inventory__c, 
                            b.BOATBUILDING__Interior_Lights__c, b.BOATBUILDING__Interior_Detail__c, b.BOATBUILDING__Impeller__c, b.BOATBUILDING__Impeller_Housing__c, b.BOATBUILDING__Hoses__c,
                            b.BOATBUILDING__Horn__c, b.BOATBUILDING__Hinges__c, b.BOATBUILDING__HIN__c, b.BOATBUILDING__Guide_Pole_Covers__c, b.BOATBUILDING__Gel_Coat__c, 
                            b.BOATBUILDING__Gauges__c, b.BOATBUILDING__Fire_Extinguisher__c, b.BOATBUILDING__Exterior_Details__c, b.BOATBUILDING__Engine_Warranty_Expiry__c, 
                            b.BOATBUILDING__Engine_Hours__c, b.BOATBUILDING__Email__c, b.BOATBUILDING__Docking_Lights__c, b.BOATBUILDING__Depth_Finder__c, b.BOATBUILDING__Customer__c,  
                            b.BOATBUILDING__Customer__r.Name, b.BOATBUILDING__Cockpit_Lights__c, b.BOATBUILDING__Carpet__c, b.BOATBUILDING__Canvas_Cover__c, b.BOATBUILDING__Boat__c, 
                            b.BOATBUILDING__Boat_Name_Location__c, b.BOATBUILDING__Boat_Factory_Warranty_Expired_Date__c, b.BOATBUILDING__Bimini_Top__c, b.BOATBUILDING__Bilge_Pump__c, 
                            b.BOATBUILDING__Bilge_Inspection__c, b.BOATBUILDING__Belts__c, b.BOATBUILDING__Battery_ies__c, b.BOATBUILDING__Battery_Cables__c, b.BOATBUILDING__Ballast_Pump__c, 
                            b.BOATBUILDING__Anodes_Zincs__c, b.BOATBUILDING__Anchor_Light__c From BOATBUILDING__Dealership_Form__c b
                Where 
                            Id =: ApexPages.currentPage().getParameters().get('id')];
                            
    		strBody = 'Hello,\n Please find the following inspection form URL:\n'+siteURL+'/apex/BOATBUILDING__ServiceIFPDF?Id='+objDF.Id;
    		User u = [Select Id, Signature From User Where Id =: UserInfo.getUserId()];
        if(u.Signature != null) {
        		strBody += '\n\n\n_____________\n'+u.Signature;	
        }
    }
    
    public PageReference sendIF() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        string[] to = new string[] {strTo};
            email.setToAddresses(to); 
        if(strCC != null && strCC != '') {
            string[] cc = new string[] {strCC};
                email.setCcAddresses(cc);
        }
        
        
        email.setSubject(strSubject);
        email.setHtmlBody(strBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
        return new PageReference('/'+objDF.Id);
    }
}