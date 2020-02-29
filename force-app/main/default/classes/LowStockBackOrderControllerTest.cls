@isTest
public class LowStockBackOrderControllerTest {
    testmethod static void TestController(){
        BOATBUILDING__Inventory__c ObjInv= new BOATBUILDING__Inventory__c();
        insert ObjInv;
        LowStockBackOrderController objLs = new LowStockBackOrderController();
        LowStockBackOrderController.getLowStockPart();
        LowStockBackOrderController objL = new LowStockBackOrderController();
      /*  LowStockBackOrderController.InventoryListViewWrapper objIL = new LowStockBackOrderController.InventoryListViewWrapper();
        objIL.partsOnOrder = 12; */
        
       
        
        
        
    }
    
}