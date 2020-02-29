@isTest
private class SendOrderDetailPageControllerTest {

    static testMethod void myUnitTest2() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
   Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.Email__c = 'abc@xyz.com';
        objManuFacturer1.RecordTypeId = [Select Id From RecordType Where sObjectType = 'BOATBUILDING__Manufacturer__c' AND DeveloperName = 'Vendor'].Id;
        objManuFacturer1.Phone__c = '999999999';
        objManuFacturer1.Contact_Person__c = objContact.Id;
        List<RecordType> lstRecType = [SELECT 
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Manufacturer__c'
                                        AND
                                                Name = 'Vendor'
                                                
                                    ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
       
        Order__c  objOrder = new Order__c();
       objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.AcocuntName__c = objAccount.Id;
        objOrder.ContactName__c = objContact.Id;
        List<RecordType> lstRecType1 = [SELECT
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Order__c'
                                        AND
                                                Name = 'Order'
                                                
                                    ];
        if(lstRecType1.size()>0) {
            objOrder.RecordTypeId = lstRecType1[0].Id;
        }
        insert objOrder;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objOrder.id;
        insert attach; 
        
        
        apexpages.currentpage().getparameters().put('Id' , objOrder.Id);
        SendOrderDetailPageController objSendOrderDetailPageController = new SendOrderDetailPageController();
        objSendOrderDetailPageController.sendOrder();
    }
    
        static testMethod void myUnitTest() {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test';
        objContact.LastName = 'Contact';
        objContact.AccountId = objAccount.Id;
        objContact.MailingState = 'Sample City';
        insert objContact;
        
 /*     Manufacturer__c objManuFacturer1 = new Manufacturer__c();
        objManuFacturer1.Name = 'Sample Vendor';
        objManuFacturer1.Manufacturer_name__c = '1234';
        objManuFacturer1.Email__c = 'abc@xyz.com';
        objManuFacturer1.Phone__c = '999999999';
        objManuFacturer1.Contact_Person__c = objContact.Id;
        List<RecordType> lstRecType = [SELECT
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Manufacturer__c'
                                        AND
                                                Name = 'Vendor'
                                                
                                    ];
        if(lstRecType.size()>0) {
            objManuFacturer1.RecordTypeId = lstRecType[0].Id;
        }
        insert objManuFacturer1;
       
        Order__c  objOrder = new Order__c();
        objOrder.Vendor_Name__c = objManuFacturer1.Id;
        objOrder.AcocuntName__c = objAccount.Id;
        objOrder.ContactName__c = objContact.Id;
        List<RecordType> lstRecType1 = [SELECT
                                                Id
                                        FROM
                                                RecordType
                                        WHERE
                                                sObjectType = 'Order__c'
                                        AND
                                                Name = 'Order'
                                                
                                    ];
        if(lstRecType1.size()>0) {
            objOrder.RecordTypeId = lstRecType1[0].Id;
        } */
      // insert objOrder;
        
  //      apexpages.currentpage().getparameters().put('Id' , objOrder.Id);
        SendOrderDetailPageController objSendOrderDetailPageController = new SendOrderDetailPageController();
        objSendOrderDetailPageController.sendOrder();
        //objSendOrderDetailPageController.checkAccess();
    }
}