public class ContactTriggerHandler{
    
    public Static void onAfterInsert(List<Contact> lstContact){
        //write code here for onAfterInsert
        createQuickBookCustomer(lstContact);
    } 
    
    public static void onAfterUpdate(Map<Id, Contact> newMapContact,Map<Id, Contact> oldMapContact){
        System.debug('==After Update===');        
        //***Code Added
        List<Contact> lstToUpdateQB = new List<Contact>();
        for(Contact objCon : [Select id,Name,Firstname,LastName,Phone,Email,Salutation, Description,BOATBUILDING__QBCustomerID__c, BOATBUILDING__QBCustomerStatus__c,MailingStreet,MailingCity,MailingCountry,MailingPostalCode FROM Contact WHERE Id IN: newMapContact.keySet()]){
            System.debug(oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerID__c+'==='+oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerStatus__c);
            if((oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerID__c == null || oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerID__c =='') && !oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerStatus__c && !(objCon.BOATBUILDING__QBCustomerID__c!=oldMapContact.get(objCon.id).BOATBUILDING__QBCustomerID__c)){
                System.debug('Enter in Update account');
                lstToUpdateQB.add(objCon);
            }
        }
        
        createQuickBookCustomer(lstToUpdateQB);
    }
    
    //****Code Added***
    public Static void createQuickBookCustomer(list<Contact> lstObj){
        String payload;
        for(Contact con: lstObj){
            payload = generateContactJson(con);
            System.debug('====payload===='+payload);
            NewQBConnectTest.CreateQBCustomer(payload, con.id);    
        }
        System.debug('====payload1111===='+payload);
    }
    
    public Static String generateContactJson(Contact con){
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('BillAddr');
        gen.writeStartObject();
        gen.writeObjectField('Line1', con.MailingStreet == null?'': con.MailingStreet);
        gen.writeObjectField('City', con.MailingCity == null?'': con.MailingCity);
        gen.writeObjectField('Country', con.MailingCountry == null?'' :con.MailingCountry);
        gen.writeObjectField('CountrySubDivisionCode', con.MailingCountry== null?'' : con.MailingCountry);
        gen.writeObjectField('PostalCode', con.MailingPostalCode == null?'' : con.MailingPostalCode);
        gen.writeEndObject();
        gen.writeObjectField('Notes', con.Description == null?'': con.Description);
        gen.writeObjectField('Title', con.Salutation== null?'': con.Salutation);
        gen.writeObjectField('GivenName', con.FirstName == null?'': con.FirstName);
        //gen.writeObjectField('MiddleName', con.Name== null?'': con.Name);
        gen.writeObjectField('FamilyName', con.LastName == null?'': con.LastName);
        gen.writeObjectField('FullyQualifiedName', con.Name == null?'': con.Name);
        gen.writeObjectField('CompanyName', con.Name== null?'': con.Name);
        gen.writeObjectField('DisplayName', con.Name== null?'': con.Name);
        gen.writeFieldName('PrimaryPhone');
        gen.writeStartObject();
        gen.writeObjectField('FreeFormNumber', con.Phone == null?'': con.Phone);
        gen.writeEndObject();
        gen.writeFieldName('PrimaryEmailAddr');
        gen.writeStartObject();
        gen.writeObjectField('Address', con.Email == null?'': con.Email);
        gen.writeEndObject();
        gen.writeEndObject();
        String strjson= gen.getAsString(); 
        System.debug('==strjson==' +strjson);
        return strjson;
    }
}