@isTest
public class BoatMatchControllerTest {
    testmethod static void Test1(){       
        Account objAcc = new Account();
        objAcc.Name= 'abcd';
        objAcc.BOATBUILDING__Email__c='gfdrh@gmail.com';
        objAcc.Phone='234567890';
        insert objAcc; 
        Document objDoc = new Document();
        objDoc.DeveloperName='Boat_Match_Logo';
        objDoc.Name='Whi';
        objDoc.FolderId='00l6F000002Ns7b';
        insert objDoc;
        BOATBUILDING__BoatMatch__c objMch = new BOATBUILDING__BoatMatch__c();
        objMch.Name='Smith';
        insert objMch;
        BoatMatchController objTest = new BoatMatchController();
        BoatMatchController.searchAccount('All','asdf');
    }
    
    testmethod static void Test2(){
        Account objAcc = new Account();
        objAcc.Name= 'Acc1';
        objAcc.BOATBUILDING__Desire_price_high__c = 1.2;
        objAcc.BOATBUILDING__Desire_boat_model__c = 'model';
        objAcc.BOATBUILDING__Trade_Model__c = 'model';
        insert objAcc;
        
        Document objDoc = new Document();
        objDoc.DeveloperName='Will';
        objDoc.Name='Whi';
        objDoc.FolderId='00l6F000002Ns7b';
        insert objDoc;
        BoatMatchController objTest = new BoatMatchController();
        BoatMatchController.searchAccount('desiredboat','1.2');
        BoatMatchController.searchAccount('desiredboat','model');
        BoatMatchController.searchAccount('trade','model');
    }
    testmethod static void Test3(){
        Decimal svcPercent = .17;
        Account objAcc = new Account();
        objAcc.Name= 'ACC';
        
        objAcc.BOATBUILDING__Email__c='gfdrh@gmail.com';
        objAcc.Phone='234567890';
        objAcc.BOATBUILDING__Desired_Boat_Manufacturer__c='smith'; 
        objAcc.BOATBUILDING__Desire_boat_model__c='first';
        objAcc.BOATBUILDING__Desire_price_high__c=svcPercent;
        objAcc.BOATBUILDING__Desire_Price_low__c=svcPercent;
        objAcc.BOATBUILDING__Prospect_Desired_Boat_Length__c= svcPercent;
        insert objAcc;
        
        Document objDoc = new Document();
        objDoc.DeveloperName='Will';
        objDoc.Name='Whi';
        objDoc.FolderId='00l6F000002Ns7b';
        insert objDoc;
        BoatMatchController objTest = new BoatMatchController();
         BoatMatchController.searchAccount('boat' ,'model');
        
    }
    
}