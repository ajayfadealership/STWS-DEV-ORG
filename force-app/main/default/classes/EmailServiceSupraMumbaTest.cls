@isTest
public class EmailServiceSupraMumbaTest {
    static testMethod void testUnsubscribe() 
    {
       // Create a new email and envelope object.    
       
       Messaging.InboundEmail email = new Messaging.InboundEmail() ;
       Messaging.InboundEnvelope env    = new Messaging.InboundEnvelope();
    
       // Create Test record.
       Contact cont = new Contact(firstName='john', lastName='smith', Email='test@test.com', HasOptedOutOfEmail=false);
       insert cont ;
       
       // Test with the subject that matches the unsubscribe statement.
       email.subject = 'Test Contact Email';
       //email.plainTextBody = 'Test Contact Email';

       env.fromAddress = 'test@test.com';
       EmailServiceSupraMumba obj= new EmailServiceSupraMumba();
       obj.handleInboundEmail(email, env );
                            
    }
     
    
}