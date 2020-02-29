@isTest
public class AccountCreationEmailServiceTest{
    public static testmethod void emailtestmethod1(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Name: Shobhit Saxena Address: 30 Stillwood Lane City: Semora State: NC Zip: 27343 Phone: 336-451-9774 Fax:  email: wkbunc83@aol.com Catalog: true Boat Click Here to review customers boat.';
        email.fromAddress = 'abc@boattrader.in';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod2(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Name: Shobhit Saxena Address: 30 Stillwood Lane City: Semora State: NC Zip: 27343 Phone: 336-451-9774 Fax:  email: wkbunc83@aol.com Catalog: false Boat Click Here to review customers boat.';
        email.fromAddress = 'abc@dealerspike.in';
        Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod3(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Source: webmaster@boattrader.com You\'ve received a sales lead from http://www.BoatTrader.com http://www.boattrader.com/listing/2006-malibu-23-lsv-wakesetter-102669478  VEHICLE INFO 2006 Malibu 23 LSV WAKESETTER, $38500.00 Ad ID 102669478 LEAD CONTACT INFO Name: Langston Peoples Email: Peopleslv@icloud.com City*: Greensboro State*: NC Zip*: 27406 Phone: 3366023930Year: Any Price: Any Comments: Hello! How many hours are on this boat? Thank you';
        email.fromAddress = 'abc@skierschoice.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod4(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Source: webleads@dealerspike.com First Name: Greg Last Name: Radulski Work Phone: 803-554-1800 Email Address: Gregradulski@outlook.com telephone: 803-554-1800 SourcePage: xcontact formpage: xcontact NewsletterOptIn: Y Comments: I\'ve tried calling . Your sales line just rings and then goes to a blank line. I wanted to know if you want me to bring my boat down for the showroom. Danny told I could when you got rid of your other se. Also has there been any action on the boat. Haven\'t heard a thing all summer. Can\'t imagine that there has been no interest in it. Pleases let me know Thanks. ';

        email.fromAddress = 'abc@malibuboats.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod5(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Source: webleads@dealerspike.com First Name:Last Name: Radulski Work Phone: 803-554-1800 Email Address: Gregradulski@outlook.com telephone: 803-554-1800 SourcePage: xcontact formpage: xcontact NewsletterOptIn: Y Comments: I\'ve tried calling . Your sales line just rings and then goes to a blank line. I wanted to know if you want me to bring my boat down for the showroom. Danny told I could when you got rid of your other se. Also has there been any action on the boat. Haven\'t heard a thing all summer. Can\'t imagine that there has been no interest in it. Pleases let me know Thanks. ';

        email.fromAddress = 'abc@onlyinboards.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod6(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Hello,We received a lead from the Axis Website for this dealership. Can you please reach out to this customer/potential customer as soon as possible?  Customer/ Potential Customer: Request Type: Axis Configurator Source: axiswake.com Date/Time: 05/12/2016 8:30 AM Name: Drew Quick Email: theinfamousdrew1@aol.com Zip/PostalCode: 29710 Country: US Phone: 235423432. \r\n';

        email.fromAddress = 'abc@aa.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod7(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'dfg adsf ads fas d asdf sadf asd  Name : abc email : as@dsd.in phone : 1324234 message : sdfsdfsd   thank you';

        email.fromAddress = 'abc@aa.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod8(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Address: sadfdsfasdfas Name: dfasfsdfads Email: dsfasdf@sadf.in Lead: aAdsfadsfa Sale:asdfasdf Make: adsfasdfadsf Model description: adsfadsfadsf Year:asdfasdfa IMT ID:asdfadsfas URI: https://ADFdfAD.Adsf. CUSTOMER COMMENTS: asdfasdfasd asdfadsa thank';




        email.fromAddress = 'abc@aa.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true); 
    }
    public static testmethod void emailtestmethod9(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test';
        email.fromName = 'test test';
        email.plainTextBody = 'Hey, Danny, We\'ve received a new lead for you to follow up on. Please see the details below. Lead Source: ConfiguratorName: Chase Corder Email: corderchase45@yahoo.com Phone:  Address 1:  Address 2:  City: Blythewood State: SC Postal Code: 29016 Country: United States Configured Boat: Supra SA Configured Boat URL: https://www.supraboats.com/configurator/6?isConfig=false&selectedOptions=315,321,329,332,334,335,337,339,340,346,349,364,375,391,393,396,399,402,403,404,405,406,430,452,484,496,522,538,544,547,551,558,568,581,872,873,875,877,879,883,1148,1165,1167,1168,1178,1189,1195 Comments:  You can view these details and the history of this prospect by logging into https://crm.skierschoice.com/.';




        email.fromAddress = 'abc@aa.in';
         Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1];  
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.txt';
        String algorithmName = 'HMacSHA1';
        Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
        Blob.valueOf('test_key'));
        binaryAttachment.Body = b;
        binaryAttachments[0] =  binaryAttachment ;
        email.binaryAttachments = binaryAttachments ;
        
        AccountCreationEmailService obj= new AccountCreationEmailService();
        Messaging.InboundEmailResult result = obj.handleInboundEmail(email, env);
        System.assertEquals( result.success  ,true);
        //obj.attachingFieldsValueForEightTemplate('ABCBoat');
       // obj.attachingFieldsValueForNinthTemplate('abctest');
    }
}