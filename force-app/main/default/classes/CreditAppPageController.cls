public class CreditAppPageController {
    BOATBUILDING__Customer_Inquiry__c objCI;
    BOATBUILDING__FroceDotCom__c objFDC;
    public String cancelURL { get; set; }
    
    public CreditAppPageController(ApexPages.StandardController stdController) {
        this.objCI = (BOATBUILDING__Customer_Inquiry__c)stdController.getRecord();
        if(BOATBUILDING__FroceDotCom__c.getOrgDefaults() != null) {  
            objFDC = BOATBUILDING__FroceDotCom__c.getOrgDefaults();   
        }
        if(objFDC != null && objFDC.BOATBUILDING__Cancel_URL__c != null) {
            cancelURL = objFDC.BOATBUILDING__Cancel_URL__c;
        } 
        objCI.RecordTypeId = Schema.SObjectType.BOATBUILDING__Customer_Inquiry__c.getRecordTypeInfosByName().get('Credit App').getRecordTypeId();
        objCI.BOATBUILDING__IsCreatedFromWeb__c = True;
        objCI.BOATBUILDING__Lead_Source__c = 'Finance Application';
    } 
    
    public PageReference saveCreditDetails() {
        
        try { 
            System.debug('Debug Log For objCI: '+objCI); 
            String invName = '';
            if(ApexPages.currentPage().getParameters().get('productId') != null) {
                invName = ApexPages.currentPage().getParameters().get('productId');
            } 
            String defaultVal;
            Schema.DescribeFieldResult F = BOATBUILDING__Customer_Inquiry__c.BOATBUILDING__Store_Location__c.getDescribe();
            List <Schema.PicklistEntry> pickVals = F.getPicklistValues();       
            for (Schema.PicklistEntry pv: pickVals) {
                if (pv.isDefaultValue()) {
                    defaultVal = pv.getValue();
                }   
            }
            if(ApexPages.currentPage().getParameters().get('storeLocation') != null) {
                String sLocation = ApexPages.currentPage().getParameters().get('storeLocation');
                objCI.Store_location__c = sLocation;
            } else {
                objCI.Store_location__c = defaultVal;
            }
            
            List<Inventory__c> lstInv = new List<Inventory__c>();
            if(String.isNotBlank(invName)) { 
                lstInv = [Select Id From Inventory__c Where Name =: invName];
                if(!lstInv.isEmpty()) {
                    objCI.BOATBUILDING__Inventory__c = lstInv[0].Id;	
                    objCI.BOATBUILDING__Inventory_Name__c = invName; 
                }    
            }
            insert objCI;
        } catch(Exception ex) {
            List<String> toAddresses = new List<String>{'support@fadealership.com'};
                SendEmailUtility.sendEmailUtil(toAddresses, null, ex.getMessage()+'---'+ex.getStackTraceString(), 'Credit App Error message In '+UserInfo.getOrganizationName());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+ex));
            return null;
        }
        if(objFDC != null && objFDC.BOATBUILDING__Save_URL__c != null) {
            return new PageReference(objFDC.BOATBUILDING__Save_URL__c); 
        } else {
            return null;
        }
    }
}