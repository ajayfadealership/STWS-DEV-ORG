@RestResource(urlMapping = '/inv/*')
global class GetInventoryDetails {
    @HttpGet
	global static String doGet() {
        DOM.Document doc = new DOM.Document();
        if(RestContext.request.params.containsKey('invWebsite') && String.isNotBlank(RestContext.request.params.get('invWebsite'))) {
            String invId = RestContext.request.params.get('invId');
            String invWebsite = RestContext.request.params.get('invWebsite');
            List<Inventory__c> lstInv = new List<Inventory__c>();
            String query = '';
            String SobjectApiName = 'BOATBUILDING__Inventory__c';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
    
            String commaSepratedFields = '';
            for(String fieldName : fieldMap.keyset()){
                if(commaSepratedFields == null || commaSepratedFields == ''){
                    commaSepratedFields = fieldName;
                } else {
                    commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                }
            }
            query = 'SELECT ' + commaSepratedFields + ' FROM ' + SobjectApiName + ' WHERE BOATBUILDING__External_Website__c =: invWebsite Limit 1000';
            List<Object> lstObj = Database.query(query);
            if(lstObj != null &&!lstObj.isEmpty()) {
                lstInv = (List<Inventory__c>)lstObj;
            }
            if(lstInv.isEmpty()) {
                dom.XmlNode domError = doc.createRootElement('error', '', '').addTextNode('No Invnentory Found.');
                return doc.toXmlString();
            } else {
                
                Organization o = [SELECT Address,City,Country,Fax,Id,Name,OrganizationType,Phone,PostalCode,State,Street FROM Organization Where Id =: UserInfo.getOrganizationId() limit 1];
                List<BOATBUILDING__Inventory_Rest_Details__mdt> lstIRD = [Select Id, DeveloperName, BOATBUILDING__SF_Field__c, BOATBUILDING__Website__c From  BOATBUILDING__Inventory_Rest_Details__mdt Where Website__c =: invWebsite];                
                //Inventory__c objInv = lstInv[0];
                Set<String> setInvId = new Set<String>();
                for(Inventory__c objInv: lstInv) {
                    setInvId.add(objInv.Id);
                }

                List<Attachment> lstAtt = [Select Id, Name, ParentId From Attachment Where ParentId IN: setInvId];
                Map<String, Map<String, String>> mapAttInfo1 = new Map<String, Map<String, String>>();
                for(Attachment att: lstAtt) {
                    String fld = att.Name.containsIgnoreCase('.') ? att.Name.subString(0, att.Name.indexOf('.')): att.Name;
                    if(!mapAttInfo1.containsKey(att.ParentId)) {
                        mapAttInfo1.put(att.ParentId, new Map<String, String>());
                    }
                    if(mapAttInfo1.containsKey(att.ParentId)) {
                        mapAttInfo1.get(att.ParentId).put(fld, att.Id);
                    }
                } 
                DOM.Document doc1 = new DOM.Document();
                dom.XmlNode domInventory = doc1.createRootElement('inventory', '', '');
                //dom.XmlNode domInventory = domInventory1.addChildElement('inventory', '', '');
                for(Inventory__c objInv: lstInv) {

                    //dom.XmlNode domInventory = domInventory1.addChildElement('inventory', '', '');
                    if(objInv.BOATBUILDING__External_Website__c == 'Only Inboards') {
                        dom.XmlNode domListing = domInventory.addChildElement('listing', null, null);
                        System.debug('>>>o: '+o);
                        System.debug('>>>lstIRD: '+lstIRD);
                        System.debug('>>>mapAttInfo: '+lstIRD);
                        String strSite = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c != null ? BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c: '';
                        for(BOATBUILDING__Inventory_Rest_Details__mdt objMDT: lstIRD) { 
                            Map<String, String> mapAttInfo = new Map<String, String>();
                            if(mapAttInfo1.containsKey(objInv.Id)) {
                                mapAttInfo.putAll(mapAttInfo1.get(objInv.Id));
                            }
                            if(objMDT.BOATBUILDING__SF_Field__c.containsIgnoreCase('org_')) {
                                String fld = objMDT.BOATBUILDING__SF_Field__c.remove('org_');
                                if(o.get(fld) != null) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(String.valueOf(o.get(fld)));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                            else if(objMDT.BOATBUILDING__SF_Field__c.containsIgnoreCase('att_')) {
                                String fld = objMDT.BOATBUILDING__SF_Field__c.remove('att_');
                                if(mapAttInfo.containsKey(fld) && mapAttInfo.get(fld) != null && String.isNotBlank(strSite)) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(strSite + '/servlet/servlet.FileDownload?file='+mapAttInfo.get(fld));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                            else {
                                String fld = objMDT.BOATBUILDING__SF_Field__c;
                                if(objInv.get(fld) != null) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(String.valueOf(objInv.get(fld)));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                        }
                    }
                    else if(objInv.BOATBUILDING__External_Website__c == 'Boat Trader') {
                        dom.XmlNode domListing = domInventory.addChildElement('item', null, null);
                        System.debug('>>>o: '+o);
                        System.debug('>>>lstIRD: '+lstIRD);
                        System.debug('>>>mapAttInfo: '+lstIRD);
                        String strSite = BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c != null ? BOATBUILDING__System_Configure__c.getOrgDefaults().BOATBUILDING__Site_URL__c: '';
                        for(BOATBUILDING__Inventory_Rest_Details__mdt objMDT: lstIRD) {
                            Map<String, String> mapAttInfo = new Map<String, String>();
                            if(mapAttInfo1.containsKey(objInv.Id)) {
                                mapAttInfo.putAll(mapAttInfo1.get(objInv.Id));
                            }
                            if(objMDT.BOATBUILDING__SF_Field__c.containsIgnoreCase('org_')) {
                                String fld = objMDT.BOATBUILDING__SF_Field__c.remove('org_');
                                if(o.get(fld) != null) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(String.valueOf(o.get(fld)));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                            else if(objMDT.BOATBUILDING__SF_Field__c.containsIgnoreCase('att_')) {
                                String fld = objMDT.BOATBUILDING__SF_Field__c.remove('att_');
                                if(mapAttInfo.containsKey(fld) && mapAttInfo.get(fld) != null && String.isNotBlank(strSite)) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(strSite + '/servlet/servlet.FileDownload?file='+mapAttInfo.get(fld));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                            else {
                                String fld = objMDT.BOATBUILDING__SF_Field__c;
                                if(objInv.get(fld) != null) {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode(String.valueOf(objInv.get(fld)));
                                } else {
                                    domListing.addChildElement(objMDT.DeveloperName, null, null).addTextNode('');
                                }
                            }
                        }
                    }
                }
                return doc1.toXmlString();
            }
        } else {
            dom.XmlNode domError = doc.createRootElement('error', '', '').addTextNode('Please enter inventory website in parameter "invWebsite".');
            return doc.toXmlString();
        }
	    
	}
}