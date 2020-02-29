public class CreateCustomerBoatController {
    
    public BOATBUILDING__Item__c objItem {get; set;}
    public BOATBUILDING__Inventory__c objInventory {get; set;}
    
    public CreateCustomerBoatController(ApexPages.StandardController controller) {
        objItem = new BOATBUILDING__Item__c();
        this.objInventory = (BOATBUILDING__Inventory__c)controller.getRecord();
        
        objInventory = [SELECT Id, Name, Model__c, Year__c, HIN_Number__c, BOATBUILDING__Serial_Number_2__c, BOATBUILDING__Manufacturer__c,
                        BOATBUILDING__Beam__c, BOATBUILDING__Boat_Draft__c, BOATBUILDING__Boat_Length_in_feets__c, BOATBUILDING__Boat_Seating_Capacity__c,
                        BOATBUILDING__Engine_Model__c, BOATBUILDING__Engine_SN__c, BOATBUILDING__Engine_Year__c,BOATBUILDING__Weight__c,
                        BOATBUILDING__Model_Variant__c, Trailer_VIN__c, Trailer_Year__c, Trailer_Make__c, Trailer_Model__c, Trailer_Axles__c
                        FROM BOATBUILDING__Inventory__c WHERE Id=: this.objInventory.Id];
    }
    
    public PageReference createBoat(){
        
        if(String.isNotBlank(objInventory.BOATBUILDING__Manufacturer__c)){
            List<BOATBUILDING__Manufacturer__c> listManufacturer = [SELECT Id, Name FROM BOATBUILDING__Manufacturer__c WHERE Name =: objInventory.BOATBUILDING__Manufacturer__c LIMIT 1];
            if(!listManufacturer.isEmpty()){
                objItem.BOATBUILDING__Boat_Manufacturer__c = listManufacturer[0].Id;
            }
        }
        objItem.BOATBUILDING__Boat_Model__c = objInventory.Model__c;
        objItem.BOATBUILDING__M_Boat_Year__c = objInventory.Year__c;
        objItem.BOATBUILDING__Boat_HIN_No__c = objInventory.HIN_Number__c;
        objItem.BOATBUILDING__Boat_Serial_Number__c = String.isNOTBlank(objInventory.BOATBUILDING__Serial_Number_2__c)?objInventory.BOATBUILDING__Serial_Number_2__c:'';
        objItem.BOATBUILDING__Boat_Model_Variant__c = String.isNOTBlank(objInventory.BOATBUILDING__Model_Variant__c)?objInventory.BOATBUILDING__Model_Variant__c:'';
        objItem.BOATBUILDING__Boat_Weight_in_lbs__c = String.isNOTBlank(objInventory.BOATBUILDING__Weight__c)?Decimal.valueOf(objInventory.BOATBUILDING__Weight__c):0;
        objItem.BOATBUILDING__Boat_Beam_in_Feets__c = String.isNOTBlank(objInventory.BOATBUILDING__Beam__c)?Decimal.valueOf(objInventory.BOATBUILDING__Beam__c):0;
        objItem.BOATBUILDING__Boat_Draft_in_Feets__c = String.isNOTBlank(objInventory.BOATBUILDING__Boat_Draft__c)?Decimal.valueOf(objInventory.BOATBUILDING__Boat_Draft__c):0;
        objItem.BOATBUILDING__Boat_Person_Capacity__c = String.isNOTBlank(objInventory.BOATBUILDING__Boat_Seating_Capacity__c)?Decimal.valueOf(objInventory.BOATBUILDING__Boat_Seating_Capacity__c):0;
        objItem.BOATBUILDING__Boat_Length_in_Feets__c = String.isNOTBlank(objInventory.BOATBUILDING__Boat_Length_in_feets__c)?objInventory.BOATBUILDING__Boat_Length_in_feets__c:'';
        objItem.BOATBUILDING__Engine_Model__c = String.isNOTBlank(objInventory.BOATBUILDING__Engine_Model__c)?objInventory.BOATBUILDING__Engine_Model__c:'';
        objItem.BOATBUILDING__Engine_SN__c = String.isNOTBlank(objInventory.BOATBUILDING__Engine_SN__c)?objInventory.BOATBUILDING__Engine_SN__c:'';
        objItem.BOATBUILDING__Engine_Year__c = String.isNOTBlank(objInventory.BOATBUILDING__Engine_Year__c)?objInventory.BOATBUILDING__Engine_Year__c:'';
        objItem.Trailer_VIN__c = String.isNOTBlank(objInventory.Trailer_VIN__c)?objInventory.Trailer_VIN__c:'';
        objItem.Trailer_Year__c = String.isNOTBlank(objInventory.Trailer_Year__c)?objInventory.Trailer_Year__c:'';
        if(objInventory.Trailer_Make__c != null) {
            List<BOATBUILDING__Manufacturer__c> lstManu = [Select Id, Name from BOATBUILDING__Manufacturer__c where Name =: objInventory.Trailer_Make__c Limit 1];
            if(!lstManu.isEmpty()) {
                objItem.Trailer_Manufacturer__c = lstManu[0].Id;        
            }
            
        }
        objItem.Trailer_Model__c = String.isNOTBlank(objInventory.Trailer_Model__c)?objInventory.Trailer_Model__c:'';
        
        insert objItem;
        
        PageReference pgRef = new PageReference('/'+objItem.Id);
        return pgRef;
    }
}