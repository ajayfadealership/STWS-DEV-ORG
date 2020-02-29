public class CreditAppPageController {
    Account objAccount;
    BOATBUILDING__FroceDotCom__c objFDC;
    public String cancelURL { get; set; }
    public CreditAppPageController(ApexPages.StandardController stdController) {
        this.objAccount = (Account)stdController.getRecord(); 
        
        if(BOATBUILDING__FroceDotCom__c.getOrgDefaults() != null) {  
            objFDC = BOATBUILDING__FroceDotCom__c.getOrgDefaults();   
        }
        if(objFDC != null && objFDC.BOATBUILDING__Cancel_URL__c != null) {
            cancelURL = objFDC.BOATBUILDING__Cancel_URL__c;
        } 
    } 
    
    public PageReference saveCreditDetails() {
        System.debug('Debug Log For Account: '+objAccount);
        objAccount.Name = objAccount.Prospect_First_Name__c  + ' ' + objAccount.Prospect_Last_Name__c;
        objAccount.BOATBUILDING__Contact_Email__c = objAccount.BOATBUILDING__Email__c;
        objAccount.BOATBUILDING__Contact_Phone__c = objAccount.Phone;
        objAccount.Source_URL__c = String.valueOf(System.URL.getSalesforceBaseUrl());
        String invName = '';
        if(ApexPages.currentPage().getParameters().get('productId') != null) {
            invName = ApexPages.currentPage().getParameters().get('productId');
        } 
        List<Inventory__c> lstInv = new List<Inventory__c>();
        if(String.isNotBlank(invName)) { 
            lstInv = [Select Id From Inventory__c Where Name =: invName];    
        }  
        
        try { 
            Id creditAppRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Credit App').getRecordTypeId();
            if(String.isNotBlank(objAccount.Email__c)) { 
                List<Contact> lstCon = [Select Id, Name, AccountId, Account.Name, Account.OwnerId From Contact Where Email =: objAccount.Email__c];
                System.debug('ACC'+Account.Name);
                if(!lstCon.isEmpty()) {
                    objAccount.BOATBUILDING__Lead_Account_History__c = lstCon[0].AccountId;
                    objAccount.Name = lstCon[0].Account.Name + ' (Credit App)';
                    System.debug('lstCon[0].Account.OwnerId--'+lstCon[0].Account.OwnerId);
                    objAccount.OwnerId = lstCon[0].Account.OwnerId;
                    objAccount.RecordTypeId = creditAppRecordTypeId;
                    objAccount.BOATBUILDING__Product_ID__c = invName;
                    if(String.isNotBlank(objAccount.BOATBUILDING__Joint_Applicant_First_Name__c)){
                        objAccount.BOATBUILDING__Lead_Source__c = 'Joint Finance Application';
                    } else {
                        objAccount.BOATBUILDING__Lead_Source__c = 'Finance Application';
                    }
                    insert objAccount;
                } 
                else {
                    Id prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                    
                    Id salesManagerUserId;
                    
                    List<User> listUserToBeOwner = [SELECT Id, Name, UserRole.Name FROM User WHERE (UserRole.Name = 'Sales Manager' OR UserRole.Name = 'GM') AND isActive = True ORDER BY UserRole.Name DESC];
                    System.debug('listUserToBeOwner---'+listUserToBeOwner);
                    if(!listUserToBeOwner.isEmpty()){
                        for(User u :listUserToBeOwner){
                            if(u.UserRole.Name == 'Sales Manager'){
                                salesManagerUserId = u.Id;
                                break;
                            } else if(u.UserRole.Name == 'GM'){
                                salesManagerUserId = u.Id;
                                break;
                            }
                        }
                    }
                    
                    Account objAcc = new Account();
                    objAcc.RecordTypeId = prospectRecordTypeId;
                    objAcc.Name = objAccount.Name;
                    System.debug('@@@@'+objAccount.Name);
                    objAcc.BOATBUILDING__Email__c = objAccount.BOATBUILDING__Email__c;
                    objAcc.BOATBUILDING__Contact_Email__c = objAccount.BOATBUILDING__Email__c;
                    objAcc.BOATBUILDING__Contact_Phone__c = objAccount.Phone;
                                        
                    if(String.isNotBlank(salesManagerUserId)){
                        objAcc.OwnerId = salesManagerUserId;//Hardcoding by Sajal
                    }
                    objAccount.Name = objAcc.Name+ ' (Credit App)';
                    insert objAcc;
                    if(!lstInv.isEmpty()){
                        objAccount.Related_To_Inventory__c = lstInv[0].Id; 
                    }
                    objAccount.BOATBUILDING__Lead_Account_History__c = objAcc.Id;
                    objAccount.RecordTypeId = creditAppRecordTypeId;
                    objAccount.BOATBUILDING__Notify_Account_Owner__c = True;
                    
                    if(String.isNotBlank(objAccount.BOATBUILDING__Joint_Applicant_First_Name__c)){
                        objAccount.BOATBUILDING__Lead_Source__c = 'Joint Finance Application';
                    } else {
                        objAccount.BOATBUILDING__Lead_Source__c = 'Finance Application';
                    }
                    if(String.isNotBlank(salesManagerUserId)){
                        objAccount.OwnerId = salesManagerUserId;//Hardcoding by Sajal
                    }
                    System.debug('objAccount---'+objAccount);
                    insert objAccount;
                }
            }
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