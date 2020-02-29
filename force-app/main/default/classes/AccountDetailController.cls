public with sharing class AccountDetailController {


    //public static final String ProspectRecordType = 'Prospect';
    
    public Account objAcc {get; set;}
    
    public AccountDetailController(){
        
        objAcc = new Account();
        Id accId = ApexPages.currentPage().getParameters().get('id');
        
        //Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ProspectRecordType).getRecordTypeId();
        
        if(String.isNotBlank(accId)){
            objAcc = [SELECT Id, Name, Phone, BOATBUILDING__Account_Customer_Type__c, OwnerId FROM Account WHERE Id=: accId LIMIT 1];
        }
    }
}