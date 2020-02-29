/** 
* Author : Akshay Kumar
* Company: CloudCodiots LLP
* Created Date : 21/10/2016
*/
public with sharing class InventoryCustomViewController {
    public List<AllInventoryWrapper> lstAllInventory { get; set; }
    private List<AllInventoryWrapper> lstAllInventoryForClass;
    public Boolean baseCheck { get; set; }
    public String strPickListValue { get; set; } 
    public List<SelectOption> lstInventoryRecordType { get; set; }
    public BOATBUILDING__Inventory__c objInventoryPick { get; set; } 
    public String strSearchString { get; set; }
    public String defaultVal { get; set; }
    public Boolean checkStatus { get; set; }
    public String selectedStoreLocation {get; set;}
    public List<SelectOption> listStoreLocation { get; set; } 
    
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Sales')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    }
    
    public InventoryCustomViewController(ApexPages.StandardController controller) {
        baseCheck = false;
        checkStatus = false;
        Profile p = [Select Id, Name From Profile Where Id =: UserInfo.getProfileId()]; 
          
          if(p.Name.containsIgnoreCase('without') && p.Name.containsIgnoreCase('cost')) {
            checkStatus = true;
          }
        strPickListValue = '';
        strSearchString = '';
        lstInventoryRecordtype = new List<SelectOption>(); 
        lstAllInventory = new List<AllInventoryWrapper>();
        lstAllInventoryForClass = new List<AllInventoryWrapper>();
        selectedStoreLocation = '';
        listStoreLocation = new List<SelectOption>(); 
        
        objInventoryPick = new BOATBUILDING__Inventory__c();
        List<RecordType> lstRecTypeBoats = [SELECT           
                                            Id, Name FROM RecordType
                                            WHERE DeveloperName != 'Inventory_for_Parts' 
                                            AND SobjectType = 'BOATBUILDING__Inventory__c'];  
                                            
        if(lstRecTypeBoats.size() > 0) {
            for(RecordType objRec: lstRecTypeBoats) {
                lstInventoryRecordtype.add(new SelectOption(objRec.Id, objRec.Name));    
                if(objRec.Name == 'New Boats') {
                    defaultVal = objRec.Id;
                }
            }
            String defaultVal;
            Schema.DescribeFieldResult F = BOATBUILDING__Inventory__c.Stage__c.getDescribe();
            List <Schema.PicklistEntry> pickVals = F.getPicklistValues();        
            for (Schema.PicklistEntry pv: pickVals) {
                if (pv.isDefaultValue()) {
                    defaultVal = pv.getValue();
                }    
            }
            
            F = BOATBUILDING__Inventory__c.Store_Location__c.getDescribe();
            pickVals = F.getPicklistValues();
            listStoreLocation.add(new SelectOption('', 'All')); 
            for (Schema.PicklistEntry pv: pickVals) {
                if(pv.isActive()){
                    listStoreLocation.add(new SelectOption(pv.getValue(), pv.getValue()));
                }
            }
            
            List<BOATBUILDING__Inventory__c> lstInventory = [SELECT i.Year__c, i.Status_for_Days_on_the_Lot__c, i.Walkthrough__c, i.Underwater_lights__c, i.Transom_remote__c, i.Transom__c, i.Trailer_wheels__c, i.Trailer_VIN__c, 
                                                             i.Total_MSRP_Price__c ,i.Tower_speakers__c, i.Status_for_Interest_Start_Date__c, i.Surf_system__c, i.Steering_wheel_controls__c, i.Status__c, i.Stage__c, 
                                                             i.Speed_Wakeplate_levers__c, i.Date_Arrived__c, i.Boat_Length_in_feets__c,i.Side__c, i.Running_gear__c,i.Phone_holder__c, i.Part_Number__c, 
                                                             i.OwnerId, i.Name, i.Model__c, i.Status_for_Curtailment_Start_Date__c, i.Model_Variant__c, i.Manufacturer__c, i.Location__c,
                                                             i.LastModifiedDate, i.LastModifiedById, i.Interest_Start_Date__c, i.Id, i.HIN_Number__c, 
                                                             i.Engine_compartment__c, i.Engine_SN__c, i.Dealer__c, i.Dealer_Stock__c, i.Dealer_Status__c, i.Boat_Type__c, i.BOATBUILDING__Accent_color__c, i.BOATBUILDING__Main_color__c,
                                                             i.Dealer_Flat_Discount__c, i.Dealer_Discount__c, i.Dealer_Comments__c, i.Dealer_COD_Discount__c, i.Dealer_Base_Price__c, 
                                                             i.Days_on_Lot__c, i.Date_First_on_Sales_Lot__c, i.Dash_cluster__c, i.Dash_Screen__c, i.Curtailment_Start_Date__c, i.CreatedDate, 
                                                             i.CreatedById, i.Cooler__c, i.Convertible_seating__c, i.Hull_ID__c, i.Cabin__c, i.Bow__c, i.Board_racks__c, 
                                                             i.Backup_Camera__c, i.Suggested_List_Price__c, i.B_roll__c, i.Cost__c, i.BOATBUILDING__Store_Location__c, i.RecordTypeId, i.RecordType.Name, 
                                                             (SELECT Id FROM Attachments WHERE Name LIKE '%side__c%' LIMIT 1) 
                                                             FROM BOATBUILDING__Inventory__c i WHERE RecordType.DeveloperName = 'New_Boats' 
                                                             AND Stage__c =: defaultVal];
            
            Id recTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId(); 
        
            if(lstInventory.size() > 0){
                for(BOATBUILDING__Inventory__c objInv : lstInventory){
                    lstAllInventory.add(new AllInventoryWrapper(false, objInv, recTypeId));
                }
            } 
        } 
        lstAllInventoryForClass = lstAllInventory;                                                                                  
    }
    public PageReference newInventory(){
        return new PageReference('/a1M/e?retURL=%2Fa1M%2Fo');
    }
    
    public PageReference recordTypeChange() {
        lstAllInventory = new List<AllInventoryWrapper>();
        lstAllInventoryForClass = new List<AllInventoryWrapper>();
        List<BOATBUILDING__Inventory__c> lstInventory = [SELECT i.Year__c, i.Suggested_List_Price__c, i.Status_for_Days_on_the_Lot__c, i.Walkthrough__c, i.Underwater_lights__c, i.Transom_remote__c, i.Transom__c, i.Trailer_wheels__c, i.Trailer_VIN__c, 
                                                         i.Total_MSRP_Price__c ,i.Tower_speakers__c, i.Status_for_Interest_Start_Date__c, i.Surf_system__c, i.Steering_wheel_controls__c, i.Status__c, i.Stage__c, 
                                                         i.Speed_Wakeplate_levers__c, i.Date_Arrived__c, i.Boat_Length_in_feets__c,i.Side__c, i.Running_gear__c,i.Phone_holder__c, i.Part_Number__c, 
                                                         i.OwnerId, i.Name, i.Model__c, i.Status_for_Curtailment_Start_Date__c, i.Model_Variant__c, i.Manufacturer__c, i.Location__c, 
                                                         i.LastModifiedDate, i.LastModifiedById, i.Interest_Start_Date__c, i.Id, i.HIN_Number__c, 
                                                         i.Engine_compartment__c, i.Engine_SN__c, i.Dealer__c, i.Dealer_Stock__c, i.Dealer_Status__c, i.Boat_Type__c,
                                                         i.Dealer_Flat_Discount__c, i.Dealer_Discount__c, i.Dealer_Comments__c, i.Dealer_COD_Discount__c, i.Dealer_Base_Price__c, 
                                                         i.Days_on_Lot__c, i.Date_First_on_Sales_Lot__c, i.Dash_cluster__c, i.Dash_Screen__c, i.Curtailment_Start_Date__c, i.CreatedDate, 
                                                         i.BOATBUILDING__Accent_color__c,i.BOATBUILDING__Main_color__c,
                                                         i.CreatedById, i.Cooler__c, i.Convertible_seating__c, i.Hull_ID__c, i.Cabin__c, i.Bow__c, i.Board_racks__c, 
                                                         i.Backup_Camera__c, i.B_roll__c, i.Cost__c,i.BOATBUILDING__Store_Location__c, i.RecordTypeId, i.RecordType.Name, 
                                                         (SELECT Id FROM Attachments WHERE Name LIKE '%side__c%' LIMIT 1) 
                                                         FROM BOATBUILDING__Inventory__c i WHERE RecordTypeId =: strPickListValue AND Stage__c =: objInventoryPick.Stage__c];

        Id recTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('New Boats').getRecordTypeId(); 
        
        if(lstInventory.size() > 0){
            for(BOATBUILDING__Inventory__c objInv : lstInventory){
                lstAllInventory.add(new AllInventoryWrapper(false, objInv, recTypeId));
            }
        } 
        lstAllInventoryForClass = lstAllInventory;
        return null; 
    }
    
    public PageReference searchData() {
        lstAllInventory = new List<AllInventoryWrapper>(); 
        
        System.debug('Debug Log For lstAllInventoryForClass: '+lstAllInventoryForClass);
        System.debug('Debug Log For lstAllInventoryForClass.size(): '+lstAllInventoryForClass.size());
        if(String.isNotBlank(strSearchString)) {
            try {
                for(AllInventoryWrapper obj: lstAllInventoryForClass) {
                    if(obj.objInventory.Name.containsIgnoreCase(strSearchString)
                       || (obj.objInventory.RecordType.Name != null && obj.objInventory.RecordType.Name.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Stage__c != null && obj.objInventory.Stage__c.containsIgnoreCase(strSearchString)) 
                       || (obj.objInventory.Manufacturer__c != null && obj.objInventory.Manufacturer__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Model_Variant__c != null && obj.objInventory.Model_Variant__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.HIN_Number__c != null && obj.objInventory.HIN_Number__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Engine_SN__c != null && obj.objInventory.Engine_SN__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Trailer_VIN__c != null && obj.objInventory.Trailer_VIN__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Boat_Length_in_feets__c != null && obj.objInventory.Boat_Length_in_feets__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Location__c != null && obj.objInventory.Location__c.containsIgnoreCase(strSearchString))
                       || (obj.objInventory.Store_Location__c != null && obj.objInventory.Store_Location__c.containsIgnoreCase(strSearchString))) {
                        
                        
                                System.debug('Debug Log For selectedStoreLocation: '+selectedStoreLocation);
                                System.debug('Debug Log For obj.objInventory.Store_Location__c: '+obj.objInventory.Store_Location__c);
                                if(String.isNotBlank(selectedStoreLocation) && String.isNotBlank(objInventoryPick.Boat_Type__c)) {
                                    if(obj.objInventory.Store_Location__c != null
                                        &&obj.objInventory.Store_Location__c.equalsIgnoreCase(selectedStoreLocation) 
                                            && obj.objInventory.Boat_Type__c != null
                                                &&  obj.objInventory.Boat_Type__c.equalsIgnoreCase(objInventoryPick.Boat_Type__c)) {
                                             
                                            lstAllInventory.add(obj);       
                                    }
                                } else if(String.isNotBlank(selectedStoreLocation)) {
                                    if(obj.objInventory.Store_Location__c != null 
                                        && obj.objInventory.Store_Location__c.containsIgnoreCase(selectedStoreLocation)) {
                                            
                                            lstAllInventory.add(obj);       
                                    }
                                }  else if(String.isNotBlank(objInventoryPick.Boat_Type__c)) {
                                    if(obj.objInventory.Boat_Type__c != null 
                                        && obj.objInventory.Boat_Type__c.equalsIgnoreCase(objInventoryPick.Boat_Type__c)) {
                                            lstAllInventory.add(obj);       
                                    } 
                                } else {
                                    lstAllInventory.add(obj);
                                }
                       } 
                } 
            } catch(Exception ex) {System.debug('Debug Log For Exception: '+ex);return null;}
            
        } else if(String.isNotBlank(selectedStoreLocation) || String.isNotBlank(objInventoryPick.Boat_Type__c)) {
            
                for(AllInventoryWrapper obj: lstAllInventoryForClass) {
                        System.debug('Debug Log For selectedStoreLocation: '+selectedStoreLocation);
                    System.debug('Debug Log For obj.objInventory.Store_Location__c: '+obj.objInventory.Store_Location__c);
                    
                    System.debug('Debug Log For objInventoryPick.Boat_Type__c: '+objInventoryPick.Boat_Type__c);
                        System.debug('Debug Log For obj.objInventory.Boat_Type__c: '+obj.objInventory.Boat_Type__c); 
                    if(String.isNotBlank(selectedStoreLocation) && String.isNotBlank(objInventoryPick.Boat_Type__c)) {
                    if(obj.objInventory.Store_Location__c != null
                        &&obj.objInventory.Store_Location__c.equalsIgnoreCase(selectedStoreLocation) 
                            && obj.objInventory.Boat_Type__c != null
                                &&  obj.objInventory.Boat_Type__c.equalsIgnoreCase(objInventoryPick.Boat_Type__c)) {
                            
                            lstAllInventory.add(obj);   
                    }   
                } else if(String.isNotBlank(selectedStoreLocation)) {
                        System.debug('Debug Log For selectedStoreLocationin: '+selectedStoreLocation);
                    System.debug('Debug Log For obj.objInventory.Store_Location__cin: '+obj.objInventory.Store_Location__c);
                    if(obj.objInventory.Store_Location__c != null 
                        && obj.objInventory.Store_Location__c.equalsIgnoreCase(selectedStoreLocation)) {
                            System.debug('Debug Log For selectedStoreLocation deep: '+selectedStoreLocation);
                            System.debug('Debug Log For obj.objInventory.Store_Location__c deep: '+obj.objInventory.Store_Location__c);
                            
                            lstAllInventory.add(obj);
                                     
                    } 
                } else if(String.isNotBlank(objInventoryPick.Boat_Type__c)) {
                    System.debug('Debug Log For objInventoryPick.Boat_Type__c in: '+objInventoryPick.Boat_Type__c);
                    System.debug('Debug Log For obj.objInventory.Boat_Type__c in: '+obj.objInventory.Boat_Type__c);
                    if(obj.objInventory.Boat_Type__c != null 
                        && obj.objInventory.Boat_Type__c.equalsIgnoreCase(objInventoryPick.Boat_Type__c)) {
                            System.debug('Debug Log For objInventoryPick.Boat_Type__c Deep: '+objInventoryPick.Boat_Type__c);
                            System.debug('Debug Log For obj.objInventory.Boat_Type__c Deep: '+obj.objInventory.Boat_Type__c);
                            lstAllInventory.add(obj);       
                    } 
                }   
                }        
        } else {
                    lstAllInventory = lstAllInventoryForClass;
            } 
        
        return null;
    }
    
    public class AllInventoryWrapper{
        public Boolean isSelect { get; set; }
        public BOATBUILDING__Inventory__c objInventory { get; set; }
        public String fileId { get; set; }
        public Boolean renderImage { get; set; }
        public Boolean isNewBoat { get; set; }
        public AllInventoryWrapper(Boolean isSelect, BOATBUILDING__Inventory__c objInventory, String recTypeId){
            this.isSelect = isSelect;
            this.objInventory = objInventory;
            if(String.valueOf(objInventory.RecordTypeId) == recTypeId){
                isNewBoat = true;
            }else{
                isNewBoat = false;
            }
            if(objInventory.Attachments.size() > 0){
                renderImage = true;
                this.fileId = objInventory.Attachments[0].Id;
            }else{
                renderImage = false;
                this.fileId = '';
            }
        }
    }
}