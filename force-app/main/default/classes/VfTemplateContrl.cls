public class VfTemplateContrl{
    
    public BOATBUILDING__Template_WhyBuyFromUS__c CSTemp{get;set;}
    public List<BOATBUILDING__Inventory__c> listInventory{get;set;}
    public List<String>tempInfoList{get;set;}
    Public string selectedTemplate{get;set;}
    public string sideimageid{get;set;}
    public string Interiorimageid{get;set;}
    public Boolean imageavailableSide{get;set;}
    public Boolean imageavailableInterior{get;set;}
    
    public String LogoURL { get; set; }
    public String LogoURLBlack { get; set; }
    
    public VfTemplateContrl(){
        LogoURL = '';
        LogoURLBlack = '';
        List<Document> lstDoc = [SELECT Id FROM Document Where Name = 'VFTemplateLogo' LIMIT 1];
        if(lstDoc.size() > 0) {
            LogoURL = '/servlet/servlet.FileDownload?file='+String.valueOf(lstDoc[0].Id); 
        }
        List<Document> lstDoc2 = [SELECT Id FROM Document Where Name = 'VFTemplateLogoBlack' LIMIT 1];
        if(lstDoc2.size() > 0) {
            LogoURLBlack = '/servlet/servlet.FileDownload?file='+String.valueOf(lstDoc2[0].Id); 
        }
        listInventory = new List<BOATBUILDING__Inventory__c>(); 
        String invtID = ApexPages.currentPage().getParameters().get('invId');
        imageavailableSide = false;
        imageavailableInterior = false;
        
        CSTemp = BOATBUILDING__Template_WhyBuyFromUS__c.getValues('TemplateInfo');
        string tempInfo = CSTemp.BOATBUILDING__TemplateInfo__c;
        tempInfoList = tempInfo.split(',');
        listInventory = [SELECT Name,BOATBUILDING__Boat_Length_in_feets__c, BOATBUILDING__Boat_Ballast_Weight__c, BOATBUILDING__Window_Sticker_Down_Payment__c,
                         BOATBUILDING__Boat_Weight__c,BOATBUILDING__Total_MSRP_Price__c,BOATBUILDING__Total_Dealer_Price__c,
                         BOATBUILDING__Dealer_Flat_Discount__c, BOATBUILDING__Boat_Seating_Capacity__c,
                         BOATBUILDING__Boat_Overall_Length__c, BOATBUILDING__Web_Product_Name__c, BOATBUILDING__Model__c,
                         BOATBUILDING__Boat_Fuel_Capacity__c, BOATBUILDING__Window_Sticker_Interest_Rate__c, 
                         BOATBUILDING__Window_Sticker_MSRP__c, BOATBUILDING__Window_Sticker_Our_Discount__c, 
                         BOATBUILDING__Window_Sticker_Payment__c, BOATBUILDING__Window_sticker_Term__c, 
                         BOATBUILDING__Web_Down_Payment__c , BOATBUILDING__Window_Sticker_Your_Price__c 
                         FROM BOATBUILDING__Inventory__c where Id=:invtID];
        
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
        
        
        list<Attachment>lstOfAttachment = [select id,name,parentid from attachment where parentid=:invtID];
        for(Attachment objattachment : lstOfAttachment)
        {
            if (objattachment.name =='Side__c.jpg'){ 
                sideimageid = objattachment.id;
                imageavailableSide = true;
            }
            if(objattachment.name == 'Interior_Design_Bow__c.jpg'){
                Interiorimageid = objattachment.id;
                imageavailableInterior = true; 
            }
        }
    }
    
    
    Public List<Selectoption> getselectTemplate(){
        String strLabel= Label.Vf_Template;
        List<SelectOption> selectList = new List<SelectOption>();
        for(String s :strLabel.split(',')){
            System.debug('===str==='+s);
            string vfPageName = 'BOATBUILDING__'+s;
            selectList.add(new SelectOption(vfPageName,s));
        }
        return selectList;
    }
    
    public PageReference ContinueAfterSelection() {
        
        PageReference page = new PageReference('/apex/'+ selectedTemplate+'?invId='+listInventory[0].id);
        page.setRedirect(true);
        return page;
    }
}