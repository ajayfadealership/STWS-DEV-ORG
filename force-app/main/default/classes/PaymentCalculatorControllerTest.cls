@isTest
public class PaymentCalculatorControllerTest {
    testmethod static void TestController(){
        
        BOATBUILDING__Dealer_Option__c objDO = new BOATBUILDING__Dealer_Option__c();
        objDO.BOATBUILDING__Cost__c = 100;
        objDO.BOATBUILDING__Part_Number__c= 'test';
        List<String> listDOId = new List<String>();
        listDOId.add(objDO.Id);
        PaymentCalculatorController ObjPay = new PaymentCalculatorController();
        //insert ObjPay;
        
        PaymentCalculatorController.getPPDODetails(listDOId);
        
        BOATBUILDING__ProductPrice__c  ObjP= new BOATBUILDING__ProductPrice__c ();
        ObjP.BOATBUILDING__Product_Code__c='1234';
        //ObjP.BOATBUILDING__Cost__c=100;
        ObjP.BOATBUILDING__Dealer_Price__c=100;
        ObjP.BOATBUILDING__Model_Variant__c='test';
        ObjP.BOATBUILDING__Option_Category__c='ahsgga';
        ObjP.BOATBUILDING__ProductManufacturer__c='ahsggaas';
        ObjP.BOATBUILDING__Product_Model__c='ahsggatdf';
        ObjP.BOATBUILDING__Sorting_Order__c=12;
        ObjP.BOATBUILDING__ProductRetail_Price__c=1223;
        insert ObjP;
       
        PaymentCalculatorController.getPPDetails(ObjP.Id);
    }
    
}