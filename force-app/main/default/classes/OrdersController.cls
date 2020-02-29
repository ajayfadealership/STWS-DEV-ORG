public with sharing class OrdersController {

    //Returns list of all orders
    public List<BOATBUILDING__Order__c> getlstOfOrder(){
        List<RecordType> lstRecType = [SELECT           
                                                Id
                                        FROM    
                                                RecordType
                                        WHERE       
                                                DeveloperName = 'Order'
                                        AND
                                                SobjectType = 'BOATBUILDING__Order__c'
                                        LIMIT 
                                                1];
        if(lstRecType.size() > 0) {                                      
            return [SELECT 
                            Id,
                            Name, 
                            Vendor_Name__c,
                            Vendor_Name__r.Name, 
                            PO_Date__c, 
                            Amount_On_Order__c,
                            	CreatedBy.Name ,
                    			createdDate,
                                  RecordType.Name
                    
                    FROM  
                            BOATBUILDING__Order__c 
                    WHERE 
                            RecordTypeId =: lstRecType[0].Id
                    limit   999];
        }
        else {
            return null;
        }
    }

}