public class BoatShowLeadCaptureController{
    
    public Account objAccount {get; set;}
    public List<SelectOption> lstUser { get; set; }
    public String selectedUser { get; set; }
    
    public String InVal { get; set; }
    
    public List<Key_Value> lstKV { get; set; }
    
    public BoatShowLeadCaptureController() {
    		lstKV = new List<Key_Value>();
        objAccount = new Account();
        InVal = '';
        selectedUser = '';
        lstUser = new List<SelectOption>();
        List<User> lstActiveUser = [Select Id, Name From User  
                                    Where IsActive = true 
                                    AND (UserRole.Name Like '%GM%' OR UserRole.Name Like '%Salesperson%' OR UserRole.Name Like '%Sales Manager%')
                                    Order By Name ASC];
        
        selectedUser = lstActiveUser[0].Id;
        
        for(User objUsr: lstActiveUser) {
            lstUser.add(new SelectOption(objUsr.Id, objUsr.Name));
        }
        System.debug('Debug Log For lstActiveUser: '+lstActiveUser);
        System.debug('Debug Log For lstUser: '+lstUser);
        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.BOATBUILDING__Interested_In__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            Key_Value obj = new Key_Value();
            obj.key = pickListVal.getLabel();
            obj.value = pickListVal.getLabel();
            lstKV.add(obj);
        } 
    }
    public void CreateBoatShowaccount() { 
        
        try {
        
            if(objaccount.BOATBUILDING__Prospect_Last_Name__c == '' || objaccount.BOATBUILDING__Prospect_Last_Name__c == null ) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter last name')); 
                return; 
            } else {
                objaccount.Name=objaccount.BOATBUILDING__Prospect_First_Name__c + ' ' + objaccount.BOATBUILDING__Prospect_Last_Name__c;
                
                objaccount.Phone = objaccount.BOATBUILDING__Prospect_Mobile_Phone_Number__c;
                objaccount.BOATBUILDING__Email__c = objaccount.BOATBUILDING__Contact_Email__c;
                objaccount.BillingStreet = objaccount.Prospect_Address_Line_1__c+' '+objaccount.Prospect_Address_Line_2__c;
                objaccount.BillingCity = objaccount.Prospect_City__c;
                objaccount.BillingState = objaccount.Prospect_State__c;
                objaccount.BillingPostalCode = objaccount.Prospect_Zip_Code__c;
                objaccount.BillingCountry = objaccount.Country__c;
                objaccount.OwnerId = selectedUser;
                Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
                objaccount.recordTypeId = recordTypeId;
                
                if(String.isNotBlank(InVal))
                		objaccount.BOATBUILDING__Interested_In__c = InVal;
                insert objaccount;
            } 
            
            
        } catch( exception e){
            System.debug('The following exception has occurred: ' + e.getMessage() +e.getStackTraceString());
        }
    }
    
}