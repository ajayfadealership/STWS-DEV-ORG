public with sharing class Accountcontroller{
  
  public Account objAccount {get; set;}
  public List<Account> la {get; set;}
  public List<SelectOption> lstUser { get; set; }
  public String selectedUser { get; set; }
  
  public Accountcontroller() {
   		objAccount = new Account();
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
  }
  public void CreateBoatShowaccount() { 
	
	try {
	       objaccount.Name=objaccount.BOATBUILDING__Prospect_First_Name__c + ' ' + objaccount.BOATBUILDING__Prospect_Last_Name__c;
	       
	       objaccount.BOATBUILDING__Prospect_Mobile_Phone_Number__c = objaccount.BOATBUILDING__Work_Phone__c;
	       objaccount.BOATBUILDING__Contact_Email__c =  objaccount.BOATBUILDING__Email__c;
	       objaccount.OwnerId = selectedUser;
	       Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
	       objaccount.recordTypeId = recordTypeId ;
	       
	       if(objaccount.BOATBUILDING__Prospect_Last_Name__c == '' || objaccount.BOATBUILDING__Prospect_Last_Name__c == null ) { 
	          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter last name')); 
	          return; 
	       }                
	       
	       insert objaccount;
	        
	   	} catch( exception e){
	   		System.debug('The following exception has occurred: ' + e.getMessage() +e.getStackTraceString());
		}
	}
}