/**
 * Author:              Akshay Kumar
 * Organization:        360 Degree Cloud Technologies Pvt. Ltd.
 * Created Date:        02/03/2016
 * Last Modified Date:  02/03/2016
 */
global with sharing class AccessControllCheck {
    global static String ckeckAccess() { 
        List<BOATBUILDING__AccessController__c> lstAccessController = [SELECT Id, Name, AccessKey__c, EncryptionKey__c FROM BOATBUILDING__AccessController__c ORDER BY CreatedDate DESC LIMIT 1];
        if(lstAccessController.size() > 0) {
            String strAccessKey = lstAccessController[0].AccessKey__c;
            String strEncryptionKey = lstAccessController[0].EncryptionKey__c;
            try {
                Blob key = Blob.valueOf(strEncryptionKey);
                String base64URL = strAccessKey;
                Blob decB64 = EncodingUtil.base64Decode(base64URL);
                Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, decB64);
                String decryptedString = decrypted.toString();
                return decryptedString;
            }
            catch(Exception ex) {
                delete lstAccessController;
                System.debug('Debug Log For Exception: '+ex);
                return 'No Access';
            }
        }
        else {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://southtownwatersports-developer-edition.ap4.force.com/services/apexrest/BOATBUILDING/checkModuleAccess/?oid='+String.valueOf(UserInfo.getOrganizationId()).subString(0,15));
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String strResponceBody = String.valueOf(res.getBody());
            if(strResponceBody.containsIgnoreCase('"No Access"') || strResponceBody.containsIgnoreCase('"Please pass an org Id"')) {
                return 'No Access';
            }
            else {
                String uniqueKey = String.valueOf(res.getBody()).remove('"');
                String []strData = uniqueKey.split('&');
                String key = strData[1];
                String base64URL = strData[0];
                BOATBUILDING__AccessController__c objAccessController = new BOATBUILDING__AccessController__c();
                objAccessController.Name = UserInfo.getOrganizationId();
                objAccessController.AccessKey__c = strData[0];
                objAccessController.EncryptionKey__c = strData[1];
                try {
                    insert objAccessController;
                    Blob key1 = Blob.valueOf(objAccessController.EncryptionKey__c);
                    String base64URL1 = objAccessController.AccessKey__c;
                    Blob decB641 = EncodingUtil.base64Decode(base64URL1);
                    Blob decrypted1 = Crypto.decryptWithManagedIV('AES128', key1, decB641);
                    String decryptedString1 = decrypted1.toString();
                    return decryptedString1;
                }
                catch(Exception ex) {
                    System.debug('Debug log For Exception: '+ex);
                    return 'No Access';
                }
            }
        }
    }
}