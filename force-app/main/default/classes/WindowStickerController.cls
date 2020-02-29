public class WindowStickerController {
    
    public BOATBUILDING__Template_WhyBuyFromUS__c windowStickerConfig {get;set;}
    public List<BOATBUILDING__Inventory__c> listInventory {get;set;}
    public string sideImageId{get;set;}
    public string interiorImageId{get;set;}
    public List<String> tempInfoList{get;set;}
    
    public String logoURL { get; set; }    
    public String logoBackgroundColor {get; set;}
    public String logowidthPercent {get; set;}
    
    public WindowStickerController(){
        windowStickerConfig = BOATBUILDING__Template_WhyBuyFromUS__c.getValues('TemplateInfo');
        String invId = ApexPages.currentPage().getParameters().get('invId');
        
        listInventory = [SELECT Id, Name, BOATBUILDING__Year__c, BOATBUILDING__Boat_Length_in_feets__c, BOATBUILDING__Boat_Ballast_Weight__c, 
                         BOATBUILDING__Boat_Seating_Capacity__c, BOATBUILDING__Boat_Weight__c, BOATBUILDING__Boat_Fuel_Capacity__c,
                         BOATBUILDING__Boat_Overall_Length__c, BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Model__c,
                         BOATBUILDING__Window_Sticker_Interest_Rate__c, BOATBUILDING__Window_Sticker_Down_Payment__c,
                         BOATBUILDING__Window_Sticker_MSRP__c, BOATBUILDING__Window_Sticker_Our_Discount__c, 
                         BOATBUILDING__Window_Sticker_Payment__c, BOATBUILDING__Window_sticker_Term__c, 
                         BOATBUILDING__Web_Down_Payment__c , BOATBUILDING__Window_Sticker_Your_Price__c,
                         BOATBUILDING__Total_MSRP_Price__c,BOATBUILDING__Total_Dealer_Price__c, BOATBUILDING__Dealer_Flat_Discount__c
                         FROM BOATBUILDING__Inventory__c WHERE Id=:invId LIMIT 1];
        
        if(listInventory[0].BOATBUILDING__Window_Sticker_MSRP__c != null)
        {
            listInventory[0].BOATBUILDING__Window_Sticker_MSRP__c = listInventory[0].BOATBUILDING__Window_Sticker_MSRP__c.setScale(0);
        }
        
        if(listInventory[0].BOATBUILDING__Window_Sticker_Your_Price__c != null)
        {
            listInventory[0].BOATBUILDING__Window_Sticker_Your_Price__c = listInventory[0].BOATBUILDING__Window_Sticker_Your_Price__c.setScale(0);
        }
        
        if(listInventory[0].BOATBUILDING__Window_Sticker_Payment__c != null)
        {
            listInventory[0].BOATBUILDING__Window_Sticker_Payment__c = listInventory[0].BOATBUILDING__Window_Sticker_Payment__c.setScale(0);
        }
        
        if(listInventory[0].BOATBUILDING__Window_Sticker_Interest_Rate__c != null)
        {
            listInventory[0].BOATBUILDING__Window_Sticker_Interest_Rate__c = listInventory[0].BOATBUILDING__Window_Sticker_Interest_Rate__c.setScale(2);
        }
        
        if(listInventory[0].BOATBUILDING__Window_Sticker_Our_Discount__c != null)
        {
            listInventory[0].BOATBUILDING__Window_Sticker_Our_Discount__c = listInventory[0].BOATBUILDING__Window_Sticker_Our_Discount__c.setScale(0);
        }
        
        if(listInventory[0].BOATBUILDING__Web_Down_Payment__c != null)
        {
            listInventory[0].BOATBUILDING__Web_Down_Payment__c = listInventory[0].BOATBUILDING__Web_Down_Payment__c.setScale(0);
        }        
        
        list<Attachment> lstOfAttachment = [select id,name,parentid from attachment where parentid=:invId];
        for(Attachment objattachment : lstOfAttachment)
        {
            if (objattachment.name =='Side__c.jpg'){ 
                sideImageId = objattachment.id;
            }
            if(objattachment.name == 'Interior_Design_Bow__c.jpg'){
                interiorImageId = objattachment.id;
            }
        }
        
        tempInfoList = windowStickerConfig.BOATBUILDING__TemplateInfo__c.split(',');
        logoBackgroundColor = String.isNotBlank(windowStickerConfig.BOATBUILDING__LogoColorStyle__c)?windowStickerConfig.BOATBUILDING__LogoColorStyle__c:'black';
        logowidthPercent = String.isNotBlank(windowStickerConfig.BOATBUILDING__LogoWidth__c)?windowStickerConfig.BOATBUILDING__LogoWidth__c:'100%';
        logoURL = '';
        String logoName = '';
        if(String.isNotBlank(logoBackgroundColor) && logoBackgroundColor == 'black'){
            logoName = 'VFTemplateLogoWhite';
        } else {
            logoName = 'VFTemplateLogoBlack';
        }
        
        List<Document> lstDoc = [SELECT Id, Name, Folder.Name FROM Document Where Name =:logoName];
        if(!lstDoc.isEmpty()){
            logoURL = '/servlet/servlet.FileDownload?file='+String.valueOf(lstDoc[0].Id); 
        }
    }
}