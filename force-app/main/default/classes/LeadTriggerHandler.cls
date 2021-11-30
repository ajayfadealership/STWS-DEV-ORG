global class LeadTriggerHandler{
    
    global static void isAfterInsert(List<Lead> listNewLeads){
        try {
            List<Account> lstAcc = new List<Account>();
            List<Lead> lstDlLead  = new List<Lead>();
            for(Lead objLead: listNewLeads) {
                if(objLead.LeadSource != 'Parts Online'){
                    Account objAcc = new Account();
                    Lead objLD = new Lead(Id = objLead.Id);
                    objAcc.Name = objLead.FirstName + ' ' + objLead.LastName;
                    objAcc.BOATBUILDING__Email__c = objLead.Email;
                    objAcc.BOATBUILDING__Contact_Email__c = objLead.Email;
                    objAcc.BOATBUILDING__Joint_Applicant_Email__c = objLead.Email;
                    objAcc.Phone = objLead.Phone;
                    objAcc.Prospect_First_Name__c = objLead.FirstName;
                    objAcc.Prospect_Last_Name__c = objLead.LastName;
                    objAcc.Lead_Source__c = 'Facebook Leads'; 
                    objAcc.BOATBUILDING__Comments__c = objLead.BOATBUILDING__Facebook_form_Name__c;
                    objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Contact Us').getRecordTypeId();
                    System.debug(objAcc.RecordTypeId);
                    System.debug(objAcc);
                    System.debug(objLead); 
                    lstAcc.add(objAcc);
                    lstDlLead.add(objLD);
                } else if(objLead.LeadSource == 'Parts Online') {
                    Account objAcc = new Account();
                    objAcc.Name = objLead.FirstName + ' ' + objLead.LastName;
                    objAcc.BOATBUILDING__Email__c = objLead.Email;
                    objAcc.BOATBUILDING__Contact_Email__c = objLead.Email;
                    objAcc.BOATBUILDING__Joint_Applicant_Email__c = objLead.Email;
                    objAcc.Lead_Source__c = 'Parts Online'; 
                    objAcc.BOATBUILDING__IsCreatedFromWeb__c = true; 
                    objAcc.BOATBUILDING__Parts_Request_Description_of_parts__c = objLead.Description;
                    objAcc.Phone = objLead.Phone;
                    objAcc.BOATBUILDING__Parts_Request_Required_Part_Number__c = objLead.BOATBUILDING__Required_Part_Number__c;
                    objAcc.BOATBUILDING__Parts_Request_Your_Boat_Engine_Hours__c = objLead.BOATBUILDING__Your_Boat_Engine_Hours__c;
                    objAcc.BOATBUILDING__Parts_Request_Your_Boat_Manufacturer__c = objLead.BOATBUILDING__Your_Boat_Manufacturer__c;
                    objAcc.BOATBUILDING__Parts_Request_Your_Boat_Model__c = objLead.BOATBUILDING__Your_Boat_Model__c;
                    objAcc.BOATBUILDING__Parts_Request_Your_Boat_Year__c = objLead.BOATBUILDING__Your_Boat_Year__c; 
                    objAcc.BOATBUILDING__Parts_Request_Your_HIN_Number__c = objLead.BOATBUILDING__Your_HIN_Number__c;
                    lstAcc.add(objAcc);
                }
            }
            insert lstAcc; 
            delete lstDlLead;
        } catch(Exception ex) {
            System.debug('Debug Log For Ex: '+ex);
        }
    }
}