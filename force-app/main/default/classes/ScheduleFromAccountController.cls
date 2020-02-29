public with sharing class ScheduleFromAccountController {

    public Time_Management__c objTM { get; set; }
    
    public ScheduleFromAccountController() {
        objTM  = new Time_Management__c();
        String strCustId = ApexPages.currentPage().getParameters().get('CustId');
        Account acc = [Select Id, (Select Id From Contacts) From Account Where Id =: strCustId Limit 1];
        if(acc.Contacts.size() > 0) {
            objTM.Contact__c = acc.Contacts[0].Id;
        }
    }
    
    
    @RemoteAction
  public static String saveEvent(Map<String, String> mapEventDetails) {
      try {
          List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
            Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
            List<RecordType> lstRecType = [SELECT
                                                    Id
                                            FROM 
                                                    RecordType
                                            WHERE
                                                    DeveloperName = 'Schedule'
                                            AND
                                                    SObjectType = 'BOATBUILDING__Time_Management__c'
                                            LIMIT 
                                                    1];
            if(!lstRecType.isEmpty()) {
                BOATBUILDING__Time_Management__c objTM = new BOATBUILDING__Time_Management__c();
                
                objTM.RecordTypeId = lstRecType[0].Id;
                if(String.isNotBlank(mapEventDetails.get('EventType'))) {
                    objTM.Type__c = mapEventDetails.get('EventType'); 
                }
                
                if(String.isNotBlank(mapEventDetails.get('CustomerId'))) {
                    objTM.Contact__c = mapEventDetails.get('CustomerId');
                }
                
                if(String.isNotBlank(mapEventDetails.get('Technician'))) {
                    objTM.Technician__c = mapEventDetails.get('Technician');
                }
                
                if(String.isNotBlank(mapEventDetails.get('InventoryId'))) {
                    objTM.Inventory__c = mapEventDetails.get('InventoryId');
                } 
                else if(String.isNotBlank(mapEventDetails.get('QuoteId'))) {
                    objTM.Quote__c = mapEventDetails.get('QuoteId');
                }
                
                objTM.Description__c = mapEventDetails.get('Description');
                objTM.Schedule_Date_Time__c = DateTime.valueOf(mapEventDetails.get('StartDate').replace('T',' ')+':'+'00');
                objTM.End_Schedule_Date_Time__c = DateTime.valueOf(mapEventDetails.get('EndDate').replace('T',' ')+':'+'00');
                
                
                if(!lstUR.isEmpty() && mapURD.containsKey(lstUR[0].Name)) {
                  insert objTM;
              } else {
                  return 'You do not have access for this operation.\nPlease contact your GM, Service Manager or Service Writer.';
              }
            } else { 
                return 'Check Record Type, size: ['+lstRecType.size()+']'; 
            }    
      } catch(Exception ex) {
          return ''+ex; 
      }
      return 'SUCCESS';
  }
}