@RestResource(urlMapping = '/Inventories/*')
global class GetProducts {
    @HttpGet
    global static String doGet() {
        
        String type = 'BOATBUILDING__Inventory__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType inventorySchema = schemaMap.get(type);
        Map<String, Schema.SObjectField> fieldMap = inventorySchema.getDescribe().fields.getMap();
        if(fieldMap.keySet().size() > 0) {
            String strQuery = 'Select ';
            for(String strName : fieldMap.keySet()) {
                strQuery += strName+',';
            }
            strQuery = strQuery.subString(0, strQuery.length()-1);
            strQuery += ' FROM BOATBUILDING__Inventory__c WhERE RecordType.DeveloperName = \'Used_Boats\' OR RecordType.DeveloperName = \'New_Boats\' LIMIT 50000';
            
            List<Inventory__c> lstInventory = Database.query(strQuery);
            Set<String> setInventoryId = new Set<String>();
            for(Inventory__c objInv : lstInventory) {
                setInventoryId.add(String.valueOf(objInv.Id));
            }
            
            Map<String, Map<String, String>> mapAttachmentBlobBody = new Map<String, Map<String, String>>();
            for(Attachment objAtt : [Select Id, Name, Body, ParentId From Attachment Where ParentId IN: setInventoryId]) {
                
                if(!mapAttachmentBlobBody.containsKey(String.valueOf(objAtt.ParentId))) {
                    mapAttachmentBlobBody.put(String.valueOf(objAtt.ParentId), new Map<String, String>());
                }
                if(!mapAttachmentBlobBody.get(String.valueOf(objAtt.ParentId)).containsKey(String.ValueOf('BOATBUILDING__'+objAtt.Name))) {
                    System.debug('strName : '+objAtt.Name);
                    String strName = '';
                    if(String.valueOf(objAtt.Name).containsIgnoreCase('.')) {                        
                        strName = String.valueOf('BOATBUILDING__'+objAtt.Name).subString(0, String.valueOf('BOATBUILDING__'+objAtt.Name).indexOf('.'));
                    }
                    if(strName != '') {
                        mapAttachmentBlobBody.get(String.valueOf(objAtt.ParentId)).put(String.ValueOf(strName), objAtt.Id);
                    }
                }    
            }
            System.debug('Debug Log For mapFields'+mapAttachmentBlobBody);
            for(Inventory__c objInventory : lstInventory) {
                if(mapAttachmentBlobBody.get(String.valueOf(objInventory.Id)) != null) {
                    for(String strAttName : mapAttachmentBlobBody.get(String.valueOf(objInventory.Id)).keySet()) {
                        if(fieldMap.containsKey(strAttName)) {
                            String imageId = mapAttachmentBlobBody.get(String.valueOf(objInventory.Id)).get(strAttName);
                            objInventory.put(strAttName,String.valueOf(imageId));
                        }
                        System.debug('Debug Log for strAttName : '+strAttName);
                    } 
                }
            }
            try {
                return JSON.serialize(lstInventory);
                //return lstInventory;
            }
            catch (exception e) {
                return String.valueOf(e);
            }
        }
        else {
            return 'No Inventory Found';
        }
    }
}