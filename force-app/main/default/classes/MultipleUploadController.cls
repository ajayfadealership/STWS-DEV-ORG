public class MultipleUploadController
{   
    //Picklist of tnteger values to hold file count
    public List<SelectOption> filesCountList {get; set;}
    public List<SelectOption> fileNameList{get;set;}
    //Selected count
    public String FileCount {get; set;}
    
    public  List<Attachment> allFileList {get; set;}
    public attachment objattachment{get;set;}
    public transient blob filebody{get;set;}
    public string filename{get;set;}
    public MultipleUploadController(ApexPages.StandardController controller)
    {   String InvId = System.currentPagereference().getParameters().get('id');
     set<string>setOfExAttName = new set<string>();
     list<Attachment>lstExistingAtt = [select id,name from attachment where parentid =:InvId];
     for(Attachment objexatt :lstExistingAtt ){
         setOfExAttName.add(objexatt.name);
     }
     //Initialize  
     filesCountList = new List<SelectOption>() ;
     fileNameList = new List<SelectOption>();
     List<String>pictureNameList = new List<String>();
     
     List<BOATBUILDING__InventoryPictureUploader__c> listImageNameConf = BOATBUILDING__InventoryPictureUploader__c.getAll().values();
     for(BOATBUILDING__InventoryPictureUploader__c objImageNameConf: listImageNameConf){
         pictureNameList.add(objImageNameConf.BOATBUILDING__Image_Name__c);
     }
     /*
pictureNameList.add('Board_racks__c.jpg');
pictureNameList.add('Bow__c.jpg');
pictureNameList.add('Cabin__c.jpg');
pictureNameList.add('Cooler__c.jpg');
pictureNameList.add('Dash_cluster__c.jpg');
pictureNameList.add('Dash_Screen__c.jpg');
pictureNameList.add('Interior_Design_Bow__c.jpg');
pictureNameList.add('Phone_holder__c.jpg');
pictureNameList.add('Running_gear__c.jpg');
pictureNameList.add('Side__c.jpg');
pictureNameList.add('Surf_system__c.jpg');
pictureNameList.add('Tower_speakers__c.jpg');
pictureNameList.add('Trailer_wheels__c.jpg');
*/
     for(string sToAdd :pictureNameList){
         if(!setOfExAttName.contains(sToAdd)){
             fileNameList.add(new SelectOption(sToAdd,sToAdd)) ;
         }
     }
     /*fileNameList.add(new SelectOption('Board_racks__c.jpg', 'Board_racks__c.jpg')) ;
fileNameList.add(new SelectOption('Bow__c.jpg', 'Bow__c.jpg')) ;
fileNameList.add(new SelectOption('Cabin__c.jpg', 'Cabin__c.jpg')) ;
fileNameList.add(new SelectOption('Convertible_seating__c.jpg', 'Convertible_seating__c.jpg')) ;
fileNameList.add(new SelectOption('Cooler__c.jpg', 'Cooler__c.jpg')) ;
fileNameList.add(new SelectOption('Dash_cluster__c.jpg', 'Dash_cluster__c.jpg')) ;
fileNameList.add(new SelectOption('Dash_Screen__c.jpg', 'Dash_Screen__c.jpg')) ;
fileNameList.add(new SelectOption('Interior_Design_Bow__c.jpg', 'Interior_Design_Bow__c.jpg')) ;
fileNameList.add(new SelectOption('Phone_holder__c.jpg', 'Phone_holder__c.jpg')) ;
fileNameList.add(new SelectOption('Running_gear__c.jpg', 'Running_gear__c.jpg')) ;
fileNameList.add(new SelectOption('Side__c.jpg', 'Side__c.jpg')) ;
fileNameList.add(new SelectOption('Surf_system__c.jpg', 'Surf_system__c.jpg')) ;
fileNameList.add(new SelectOption('Tower_speakers__c.jpg', 'Tower_speakers__c.jpg')) ;
fileNameList.add(new SelectOption('Trailer_wheels__c.jpg', 'Trailer_wheels__c.jpg')) ;*/
     
     filename='';
     objattachment = new attachment();
     FileCount = '' ;
     allFileList = new List<Attachment>() ;
     for(Integer i = 1 ; i <= 2; i++){
         allFileList.add(new Attachment()) ;}
     
     //Adding values count list - you can change this according to your need
     for(Integer i = 1 ; i < 11 ; i++)
         filesCountList.add(new SelectOption(''+i , ''+i)) ;
    }
    
    public Pagereference SaveAttachments()
    {
        String InvId = System.currentPagereference().getParameters().get('id');
        if(InvId == null || InvId == '')
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'No record is associated. Please pass record Id in parameter.'));
        
        
        List<Attachment> listToInsert = new List<Attachment>() ;
        
        
        if(filename != '' && filename != '' && filebody != null)
            listToInsert.add(new Attachment(parentId = InvId, name = filename, body = filebody)) ;
        
        if(listToInsert.size() > 0)
        {   
            
            insert listToInsert ;
            set<string>setOfExAttName = new set<string>();
            list<Attachment>lstExistingAtt = [select id,name from attachment where parentid =:InvId];
            for(Attachment objexatt :lstExistingAtt ){
                setOfExAttName.add(objexatt.name);
            }
            //Initialize  
            filesCountList = new List<SelectOption>() ;
            fileNameList = new List<SelectOption>();
            List<String> pictureNameList = new List<String>();
            List<BOATBUILDING__InventoryPictureUploader__c> listImageNameConf = BOATBUILDING__InventoryPictureUploader__c.getAll().values();
            for(BOATBUILDING__InventoryPictureUploader__c objImageNameConf: listImageNameConf){
                pictureNameList.add(objImageNameConf.BOATBUILDING__Image_Name__c);
            }
            /*pictureNameList.add('Board_racks__c.jpg');
pictureNameList.add('Bow__c.jpg');
pictureNameList.add('Cabin__c.jpg');
pictureNameList.add('Cooler__c.jpg');
pictureNameList.add('Dash_cluster__c.jpg');
pictureNameList.add('Dash_Screen__c.jpg');
pictureNameList.add('Interior_Design_Bow__c.jpg');
pictureNameList.add('Phone_holder__c.jpg');
pictureNameList.add('Running_gear__c.jpg');
pictureNameList.add('Side__c.jpg');
pictureNameList.add('Surf_system__c.jpg');
pictureNameList.add('Tower_speakers__c.jpg');
pictureNameList.add('Trailer_wheels__c.jpg');*/
            
            for(string sToAdd :pictureNameList){
                if(!setOfExAttName.contains(sToAdd)){
                    fileNameList.add(new SelectOption(sToAdd,sToAdd)) ;
                }
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.INFO,'File Uploaded successfully.Please select more file and click on upload.'));
        }
        else
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select at-least one file'));
        
        return null;
    }
}