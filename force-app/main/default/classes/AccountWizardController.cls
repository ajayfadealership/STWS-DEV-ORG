public class AccountWizardController {
    @AuraEnabled
    public static String createAccountApex(Account objAccount) {
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        insert objAccount;
        return objAccount.Id;
    }
}