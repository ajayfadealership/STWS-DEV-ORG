public with sharing class VendorController {
    public BOATBUILDING__Manufacturer__c objManufacturer { get; set; }

    //Constructor
    public VendorController() {
        objManufacturer = new BOATBUILDING__Manufacturer__c();
    }

    // Returns this list of all manufacturers
    public List<BOATBUILDING__Manufacturer__c> getlstOfManu(){
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Vendor'
                                        AND
                                                SobjectType = 'BOATBUILDING__Manufacturer__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {                                      
            return [SELECT 
                            Zip__c, 
                            Terms__c, 
                            Street__c, 
                            State__c, 
                            Phone__c, 
                            Name,
                            Oustanding_Amount_on_Orders__c, 
                            Manufacturer_name__c, 
                            Id, 
                            Email__c, 
                            Description__c, 
                            Contact_Person__c,  
                            City__c 
                    FROM  
                                    BOATBUILDING__Manufacturer__c 
                    WHERE 
                            RecordTypeId =: lstRecType[0].Id
                    limit 999];
        }
        else {
            return null;
        }
    }

    // Save the new manufacturer
    @RemoteAction
    public static String saveDetails(Map<String, String> mapManuVal) {
        Boolean isError = false;
        BOATBUILDING__Manufacturer__c objManufacturer = new BOATBUILDING__Manufacturer__c();
        objManufacturer.Name = mapManuVal.get('Name');
        objManufacturer.Phone__c = mapManuVal.get('Phone');
        objManufacturer.Contact_Person__c = mapManuVal.get('ContactPerson');
        objManufacturer.Email__c = mapManuVal.get('Email');
        objManufacturer.Street__c = mapManuVal.get('Street');
        objManufacturer.City__c = mapManuVal.get('City');
        objManufacturer.State__c = mapManuVal.get('State');
        objManufacturer.Zip__c = mapManuVal.get('Zip');
        objManufacturer.Terms__c = mapManuVal.get('Terms');
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Vendor'
                                        AND
                                                SobjectType = 'BOATBUILDING__Manufacturer__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {
            objManufacturer.RecordTypeId = lstRecType[0].Id;
        }
        try{
            System.debug('Debug Log For manufacturer try'+objManufacturer);
            insert objManufacturer;
        }catch(Exception ex){
            isError = true;
            System.debug('Debug Log For Exception : '+ex);
        }
        if(!isError){
            return 'SUCCESS';
        }
        else {
            return null;
        }
        
    }
}