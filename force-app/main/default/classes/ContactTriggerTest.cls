@isTest
public class ContactTriggerTest {
    public static testmethod void contactTriggerTest(){
        BOATBUILDING__TriggerSetting__c objSetting = new BOATBUILDING__TriggerSetting__c();
       objSetting.SetupOwnerId=Userinfo.getUserId();
        objSetting.BOATBUILDING__ContactTriggerCheckbox__c = true;
        insert objSetting;
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        insert Acc;
        
        list<contact> lstCon = new list<contact> ();
        map<Id,contact> mapId = new map<Id,contact> ();
        contact objCont = new contact();
        objCont.AccountId = acc.id;
        objCont.LastName = 'test';
        objCont.FirstName = 'Test Con';
        objCont.BOATBUILDING__QBCustomerStatus__c = True;
        lstCon.add(objCont);
        mapId.put(objCont.Id,objCont);
        insert objCont;
       
     
        
        Account accc = new Account();
        accc.Name = 'Test Account';
        insert accc;
        
        objCont.AccountId = accc.ID;
        objCont.BOATBUILDING__QBCustomerStatus__c = false ;
        update objCont;
        ContactTriggerHandler.createQuickBookCustomer(lstCon);
        ContactTriggerHandler.onAfterInsert(lstCon);
        ContactTriggerHandler.onAfterUpdate(mapId,mapId);
    }
}