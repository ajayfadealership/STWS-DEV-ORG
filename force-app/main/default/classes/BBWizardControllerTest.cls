@isTest
public class BBWizardControllerTest {
    
    testmethod static void bbTest(){
        BBWizardController objBb = new BBWizardController();
        Account a = new Account();
        a.Name = 'Test';
        String str1= String.valueOf(a.id);
        insert a;
        
        Contact objContact = new Contact();     
        objContact.LastName = 'Test';
        objContact.AccountId = a.Id;
        insert objContact;
        
        ACV_Form__c acv = new ACV_Form__c();
        acv.BOATBUILDING__Contact_Name__c = objContact.Id;
        acv.BOATBUILDING__Requested_ACV__c = 100;
        acv.BOATBUILDING__High_Comp_1_Amount__c = 10;
        acv.BOATBUILDING__High_Comp_2_Amount__c = 100;
        acv.BOATBUILDING__High_Comp_3_Amount__c = 1000;
        acv.BOATBUILDING__Low_Comp_1_Amount__c = 1080;
        acv.BOATBUILDING__Low_Comp_2_Amount__c = 10000;
        String str4 = String.valueOf(acv.id);
        insert acv;
        
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.BOATBUILDING__State__c = 'Other';
       
        insert objQuote;
        
        BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
        String str2 = String.valueOf(objInv.id);
        objInv.Engine_SN__c = 'asdf';
        objInv.Boat_Length_in_feets__c  = 'text';
        objInv.HIN_Number__c = 'text1';
        objInv.Hull_ID__c = 'text2';
        objInv.Trailer_VIN__c = 'text3';
        objInv.Transmission_Gearbox_SN__c ='text4';
       
        
        insert objInv;
        
        BOATBUILDING__Manufacturer__c objManu = new BOATBUILDING__Manufacturer__c();
        objManu.BOATBUILDING__Manufacturer_name__c = 'Test';
        insert objManu;
  
        BOATBUILDING__Product__c objPro = new BOATBUILDING__Product__c();
        objPro.BOATBUILDING__Product_Manufacturer__c = objManu.Id;
        objPro.M_Manufacture_Status__c = 'other';
        String str3 = String.valueOf(objPro.id);
        insert objPro; 
        
        list<String> lstPP = new list<String>();
        BOATBUILDING__ProductPrice__c objPP = new BOATBUILDING__ProductPrice__c();
        objPP.BOATBUILDING__Beam__c = 12234;
        objPP.BOATBUILDING__Product_Code__c = 'ghjk';
   
        objPP.BOATBUILDING__Sorting_Order__c =7890;
        
        insert objPP ;
        lstPP.add(objPP.Id);
        list<String> lstDO = new list<String>();
      
        BOATBUILDING__Dealer_Option__c objDO = new BOATBUILDING__Dealer_Option__c ();
        objDO.BOATBUILDING__Cost__c = 2000;
        objDO.BOATBUILDING__Part_Number__c = 'xyz';
        objDO.Name = 'test';
        insert objDO;
        lstDO.add('xyz');
        list<BOATBUILDING__Dealer_Option__c> lstDO1 = new list<BOATBUILDING__Dealer_Option__c>();
        BOATBUILDING__Dealer_Option__c objDO1 = new BOATBUILDING__Dealer_Option__c ();
        objDO1.BOATBUILDING__Cost__c = 2000;
        objDO1.BOATBUILDING__Part_Number__c = 'xyza'; 
        lstDO1.add(objDO1);
        
        String lstDOJSON = JSON.serialize(lstDO1);
        BBWizardController.getApprovalCheck(acv.Id);
        BBWizardController.updateStateApex(objQuote.Id,'Other');
        BBWizardController.isNoSalesmanWithoutCost();
        BBWizardController.getState();
        Quote__c objQt = BBWizardController.generateQuote(str1,str2,str3,str4,'100','100','100',lstPP,lstDO,objQuote,lstDOJSON);
        
        
    }      
     
}