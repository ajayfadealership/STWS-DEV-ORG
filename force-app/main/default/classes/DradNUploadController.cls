public class DradNUploadController
{   
    public Boolean Boardracks {get;set;}
    public Boolean Bow {get;set;}
    public Boolean Cabin{get;set;}
    public Boolean Cooler{get;set;}
    public Boolean Dashcluster {get;set;}
    public Boolean DashScreen {get;set;}
    public Boolean InteriorDesignBow {get;set;}
    public Boolean Phoneholder {get;set;}
    public Boolean Runninggear {get;set;}
    public Boolean Side {get;set;}
    public Boolean SurfSystem {get;set;}
    public Boolean Towerspeakers {get;set;}
    public Boolean Trailerwheels {get;set;}
    public Boolean BackupCamera {get;set;}
    public Boolean EngineCompartment {get;set;}
    public Boolean SpeedWakeplatelevers {get;set;}
    public Boolean SteeringWakeplatelevers {get;set;}
    public Boolean Transomremote {get;set;}
    public Boolean Transom {get;set;}
    public Boolean UnderwaterLights {get;set;}
    public Boolean Walkthrough {get;set;}
    public Boolean BRoll {get;set;}
    public Boolean ConvertibleSeating {get;set;}
    public String baseURL{get; set;}
    
    
    public DradNUploadController(ApexPages.StandardController controller)
    {   
        baseURL = URL.getSalesforceBaseUrl().getHost();    
        /*Boardracks = false;
        Bow = false;
        Cabin = false;
        Cooler = false;
        Dashcluster = false;
        DashScreen = false;
        InteriorDesignBow = false;
        Phoneholder = false;
        Runninggear = false;
        Side = false;
        SurfSystem = false;
        Towerspeakers = false;
        Trailerwheels = false;
        BackupCamera = false;
        EngineCompartment = false;
        SpeedWakeplatelevers = false;
        SteeringWakeplatelevers = false;
        Transomremote = false;
        Transom = false;
        UnderwaterLights = false;
        Walkthrough = false;
        BRoll = false;
        ConvertibleSeating = false;*/
        
        String InvId = System.currentPagereference().getParameters().get('id');
        set<string>setOfExAttName = new set<string>();
        list<Attachment>lstExistingAtt = [select id,name from attachment where parentid =:InvId];
        for(Attachment objexatt :lstExistingAtt ){
            setOfExAttName.add(objexatt.name);
        }
        
        Set<String> pictureNameList = new Set<String>();
        List<BOATBUILDING__InventoryPictureUploader__c> listImageNameConf = BOATBUILDING__InventoryPictureUploader__c.getAll().values();
        for(BOATBUILDING__InventoryPictureUploader__c objImageNameConf: listImageNameConf){
            pictureNameList.add(objImageNameConf.BOATBUILDING__Image_Name__c);
        }
        
        /*
        if(!setOfExAttName.contains('Board_racks__c.jpg') ){
            Boardracks = true;
        }
        if(!setOfExAttName.contains('Bow__c.jpg') ){
            Bow = true;
        }
        if(!setOfExAttName.contains('Cabin__c.jpg') ){
            Cabin = true;
        }
        if(!setOfExAttName.contains('Cooler__c.jpg') ){
            Cooler = true;
        }
        if(!setOfExAttName.contains('Dash_cluster__c.jpg') ){
            Dashcluster = true;
        }
        if(!setOfExAttName.contains('Dash_Screen__c.jpg') ){
            DashScreen = true;
        }
        if(!setOfExAttName.contains('Interior_Design_Bow__c.jpg') ){
            InteriorDesignBow = true;
        }
        if(!setOfExAttName.contains('Phone_holder__c.jpg') ){
            Phoneholder = true;
        }
        if(!setOfExAttName.contains('Running_gear__c.jpg') ){
            Runninggear = true;
        }
        if(!setOfExAttName.contains('Side__c.jpg') ){
            Side = true;
        }
        if(!setOfExAttName.contains('Surf_system__c.jpg') ){
            SurfSystem = true;
        }
        if(!setOfExAttName.contains('Tower_speakers__c.jpg') ){
            Towerspeakers = true;
        }
        if(!setOfExAttName.contains('Trailer_wheels__c.jpg') ){
            Trailerwheels = true;
        }
        if(!setOfExAttName.contains('Backup_camera__c.jpg') ){
            BackupCamera = true;
        }
        if(!setOfExAttName.contains('Engine_Compartment__c.jpg') ){
            EngineCompartment = true;
        }
        if(!setOfExAttName.contains('Speed_Wakeplate_levers__c.jpg') ){
            SpeedWakeplatelevers = true;
        }
        if(!setOfExAttName.contains('Steering_wakeplate_controls__c.jpg') ){
            SteeringWakeplatelevers = true;
        }
        if(!setOfExAttName.contains('Transom_remote__c.jpg') ){
            Transomremote = true;
        }
        if(!setOfExAttName.contains('Transom__c.jpg') ){
            Transom = true;
        }
        if(!setOfExAttName.contains('Underwater_Lights__c.jpg') ){
            UnderwaterLights = true;
        }
        if(!setOfExAttName.contains('Walkthrough__c.jpg') ){
            Walkthrough = true;
        }
        if(!setOfExAttName.contains('B_Roll__c.jpg') ){
            BRoll = true;
        }
        if(!setOfExAttName.contains('Convertible_Seating__c.jpg') ){
            ConvertibleSeating = true;
        }
        */
    }
}