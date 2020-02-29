@isTest
public class TMTriggerHandlerTest {
    testmethod static void Test1(){
        BOATBUILDING__TriggerSetting__c objSet = new BOATBUILDING__TriggerSetting__c();
        objSet.BOATBUILDING__TMTriggerCheckBox__c =true;
        insert objSet;
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        BOATBUILDING__Work_Order__c objWk = new BOATBUILDING__Work_Order__c();
        objWk.BOATBUILDING__Account__c= objAcc.Id;
        insert objWk;
        Time_Management__c objTime = new Time_Management__c();
        objTime.BOATBUILDING__Type__c='Test Drive';
        objTime.BOATBUILDING__Contact__c=objCon.Id;       
        insert objTime;        
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);        
        TMTriggerHandler.updateName(lstTM);     
       
    }
    testmethod static void Test2(){
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;      
        BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
        objInv.BOATBUILDING__ACV__c=8000;
        insert objInv ;
        Time_Management__c objTime = new Time_Management__c();       
        objTime.BOATBUILDING__Inventory__c=objInv.Id;        
        insert objTime;        
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);       
        TMTriggerHandler.updateName(lstTM);        
    }
    testmethod static void Test3(){
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        BOATBUILDING__Quote__c objQut= new BOATBUILDING__Quote__c();
        objQut.BOATBUILDING__Account_Name__c=objAcc.Id;
        insert objQut;
        Time_Management__c objTime = new Time_Management__c();
        objTime.BOATBUILDING__Quote__c=objQut.Id;
        insert objTime;        
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);        
        TMTriggerHandler.updateName(lstTM);      
    }
     testmethod static void Test4(){
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;
        BOATBUILDING__Work_Order__c objWk = new BOATBUILDING__Work_Order__c();
        objWk.BOATBUILDING__Account__c= objAcc.Id;
        insert objWk;
        Time_Management__c objTime = new Time_Management__c();
        objTime.BOATBUILDING__Work_Order__c=objWk.Id;
        insert objTime;         
               
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);        
        TMTriggerHandler.updateName(lstTM);        
    }
    testmethod static void Test5(){
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon; 
        BOATBUILDING__Work_Order__c objWk = new BOATBUILDING__Work_Order__c();
        objWk.BOATBUILDING__Account__c= objAcc.Id;
        objWk.BOATBUILDING__Contact__c=objCon.Id;
        insert objWk;       
        BOATBUILDING__Work_Order_Job__c objRltd = new BOATBUILDING__Work_Order_Job__c();
        objRltd.BOATBUILDING__Claim_Labor_Approved_Amount__c=800;
        objRltd.BOATBUILDING__Work_Order_Warranty_Work_Order__c= objWk.Id;
        insert objRltd;
        
        Time_Management__c objTime = new Time_Management__c();       
        objTime.BOATBUILDING__Related_Work_Order_Job__c=objRltd.Id;   
        insert objTime;   
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);       
        TMTriggerHandler.updateName(lstTM);        
    }
	   
    testmethod static void Test6(){
        Account objAcc = new Account();
        objAcc.Type='yak';
        objAcc.Name='Sam';        
        insert objAcc;
        Contact objCon = new Contact();
        objCon.Email='dfghj@fvbn.com';
        objCon.FirstName='Namee';
        objCon.LastName='LName';
        objCon.AccountId=objAcc.Id;
        insert objCon;      
        BOATBUILDING__Work_Order_Job__c objRltd = new BOATBUILDING__Work_Order_Job__c();
        objRltd.BOATBUILDING__Claim_Labor_Approved_Amount__c=800;        
        insert objRltd;        
        Time_Management__c objTime = new Time_Management__c();       
        objTime.BOATBUILDING__Related_Work_Order_Job__c=objRltd.Id;   
        insert objTime;   
        List<Time_Management__c> lstTM = new List<Time_Management__c>();
        lstTM.add(objTime);       
        TMTriggerHandler.updateName(lstTM);        
    }

}