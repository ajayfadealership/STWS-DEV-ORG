/** 
* Author        : Akshay Kumar  
* Created Date  : 21/10/2016
* Organization      : Cloudcodiots LLP. 
*/ 
public with sharing class PrintButtonPageController3 {
    List<BOATBUILDING__Quote__c> lstQuote;
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    public PrintButtonPageController3(ApexPages.StandardController controller) {
        lstQuote = new List<BOATBUILDING__Quote__c>();
        }
    public PageReference directTo(){
        BOATBUILDING__System_Configure__c objSC = BOATBUILDING__System_Configure__c.getOrgDefaults();
        
        lstQuote = [Select Id,Email__c,No_Trailer__c, (Select Id, IsDeleted,  ParentId, IsPrivate, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp 
                                        From Attachments) from BOATBUILDING__Quote__c where Id =: ApexPages.currentPage().getParameters().get('Id') limit 1];
        
        
        if(lstQuote[0].No_Trailer__c) {
                return new PageReference('/apex/'+objSC.BOATBUILDING__BillOfSaleNT__c +'?scontrolCaching=1&id='+lstQuote[0].Id);
        } else { 
                return new PageReference('/apex/'+objSC.BOATBUILDING__BillOfSale__c +'?scontrolCaching=1&id='+lstQuote[0].Id); 
        }
        
         
    }
}