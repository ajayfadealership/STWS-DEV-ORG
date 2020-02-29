@isTest
public class NewOrderedBoatQuickActionTest {
    private static testmethod void NewOrderedBoatQuickActionTest(){
        BOATBUILDING__Quote__c objQ = new BOATBUILDING__Quote__c();
        objQ.Name = 'test name';
       objQ.BOATBUILDING__Status__c = 'Final';
        objQ.BOATBUILDING__Test_2__c = objQ.Id ;
        objQ.BOATBUILDING__New_Ordered_Boat__c = true;
        objQ.BOATBUILDING__Boat_Sold_By__c = 'test';
        insert objQ ;
       
        NewOrderedBoatQuickActionController.NewOrderedBoatCheckbox(objQ.Id);
        
    }
     private static testmethod void NewOrderedBoatQuickActionTest2(){
        BOATBUILDING__Quote__c objQuote = new BOATBUILDING__Quote__c();
        objQuote.Name = 'test name';
        objQuote.BOATBUILDING__Status__c = 'Denied';
        objQuote.BOATBUILDING__Test_2__c = objQuote.Id ;
        objQuote.BOATBUILDING__New_Ordered_Boat__c = false;
        objQuote.BOATBUILDING__Boat_Sold_By__c = 'test';
        insert objQuote ;
       
        NewOrderedBoatQuickActionController.NewOrderedBoatCheckbox(objQuote.Id);
        
    }
  
  

}