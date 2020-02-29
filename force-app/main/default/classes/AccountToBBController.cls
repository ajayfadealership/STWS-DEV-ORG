public with sharing class AccountToBBController {
    public PageReference redirectToBB() {
        String accountId = ApexPages.currentPage().getParameters().get('Id');
        Account objAcc = [SELECT Id, BOATBUILDING__Related_To_Inventory__c, 
                          (SELECT Id, Name FROM Contacts) 
                          FROM 
                          Account 
                          WHERE 
                          Id =: accountId LIMIT 1];
        
        if(objAcc.BOATBUILDING__Related_To_Inventory__c != null) {
            return new PageReference('/apex/BOATBUILDING__ProductOrder?invId='+objAcc.BOATBUILDING__Related_To_Inventory__c);
        } else {
            if(!objAcc.Contacts.isEmpty()) {
                return new PageReference('/apex/BOATBUILDING__Purchase_Item2?conId='+objAcc.Contacts[0].Id+'&conName='+objAcc.Contacts[0].Name);
            }
        } 
        return null;
    }
}