public with sharing class ScheduleInventoryController {
    
    public BOATBUILDING__Time_Management__c objTM { get; set; }
    public String CurrentUserId { get; set; }
    public String CurrentUserName { get; set; }
    
    public ScheduleInventoryController()  {
    		objTM = new BOATBUILDING__Time_Management__c();
    		if(ApexPages.currentPage().getParameters().get('quoteId') != null) {
    			Quote__c objQt = [Select  BOATBUILDING__Contact_Name__c, BOATBUILDING__Test_2__c From Quote__c Where Id =: ApexPages.currentPage().getParameters().get('quoteId')];
    			objTM.Contact__c = objQt.BOATBUILDING__Contact_Name__c;
    			if(objQt.BOATBUILDING__Test_2__c != null )
    				objTM.Inventory__c = objQt.BOATBUILDING__Test_2__c;
    		}
    		if(ApexPages.currentPage().getParameters().get('invId') != null) {
    			Inventory__c Inv = [Select  Id From Inventory__c Where Id =: ApexPages.currentPage().getParameters().get('invId')];
    			objTM.Inventory__c = Inv.Id;
    		}
        
        CurrentUserId = UserInfo.getUserId();
        CurrentUserName = UserInfo.getName();
    }
    
    @RemoteAction
    public static Inventory__c getInventory(String InvId) {
        system.debug('++++InvId+++'+InvId);
        Inventory__c objInv = new Inventory__c();
        
        objInv = [Select Id, Name From Inventory__c Where Id =: InvId Limit 1];
        
        return objInv;
    }
    
    @RemoteAction
    public static String saveEvent(Map<String, String> mapEventDetails) {
        
        try {
            system.debug('===mapEventDetails===='+mapEventDetails);
            List<UserRole> lstUR = [Select Id, Name From UserRole Where Id =: UserInfo.getUserRoleId() Limit 1]; 
            system.debug('=====lstUR====='+lstUR);
            Map<String, UserRolesData__c> mapURD = UserRolesData__c.getAll();
            system.debug('===mapURD====='+mapURD);
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
                system.debug('======objTM====='+objTM);
                system.debug('======mapEventDetails====='+mapEventDetails);
                if(String.isNotBlank(mapEventDetails.get('EventType'))) {
                     
                    objTM.Type__c = mapEventDetails.get('EventType');
                   
                }
                
                if(String.isNotBlank(mapEventDetails.get('CustomerId'))) {
                    objTM.Contact__c = mapEventDetails.get('CustomerId');
                }
                
                if(String.isNotBlank(mapEventDetails.get('Technician'))) {
                    objTM.Technician__c = mapEventDetails.get('Technician');
                }
                
                if(String.isNotBlank(mapEventDetails.get('EventObject')) && mapEventDetails.get('EventObject').equalsIgnoreCase('INVENTORY')) {
                    objTM.Inventory__c = mapEventDetails.get('InventoryId');
                } 
                else if(String.isNotBlank(mapEventDetails.get('EventObject')) && mapEventDetails.get('EventObject').equalsIgnoreCase('QUOTE')) {
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