@RestResource(urlMapping = '/checkModuleAccess/*')
global class GetModuleAccess {
    @HttpGet
    global static String doGet() {
        
        String orgID =   RestContext.request.params.get('oid');
        if(String.isNotBlank(orgID)){
            List<BOATBUILDING__Module_Access__c> lstModuleAccess = [Select BOATBUILDING__Module_Provided__c from BOATBUILDING__Module_Access__c where BOATBUILDING__Org_Id__c =: orgID];
            if(lstModuleAccess.size() > 0)
            {
                //Blob key = Crypto.generateAesKey(128);
                String uniqueKey =String.valueOf(Crypto.getRandomLong());
                uniqueKey = uniqueKey.substring(0,16);
                Blob key = Blob.valueOf(uniqueKey);
                
                Blob data = Blob.valueOf(lstModuleAccess[0].BOATBUILDING__Module_Provided__c);
                Blob  encrypted = Crypto.encryptWithManagedIV('AES128', key, data);
                String base64Val = EncodingUtil.base64Encode(encrypted);
                String blobKey = EncodingUtil.base64Encode(key);
                System.debug(base64Val);
                return base64Val+'&'+uniqueKey;
            }
            else
            {
                return 'No Access';
            }
        }
        else
        {
            return 'Please pass an org Id';
        }
        
    }
}