global class LeadTriggerHandler{
    
    global static void isAfterInsert(List<Lead> listNewLeads){
        try {
            List<Account> lstAcc = new List<Account>();
            List<Lead> lstDlLead  = new List<Lead>();
            for(Lead objLead: listNewLeads) {
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
            }
            insert lstAcc; 
            delete lstDlLead;
        } catch(Exception ex) {
            System.debug('Debug Log For Ex: '+ex);
        }
    }
}