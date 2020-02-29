@isTest
public class DradNUploadControllerTest {
    testmethod static void TestController(){
        
        BOATBUILDING__Inventory__c ObjInv= new BOATBUILDING__Inventory__c();
        ApexPages.currentPage().getParameters().put('Id',ObjInv.id);
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(ObjInv);
        DradNUploadController ObjCont = new DradNUploadController(sc);
        ObjCont.Boardracks= true;
        ObjCont.Bow= true;
        ObjCont.Cabin= true;
        ObjCont.Cooler= true;
        ObjCont.Dashcluster= true;
        ObjCont.DashScreen= true;
        ObjCont.InteriorDesignBow= true;
        ObjCont.Phoneholder= true;
        ObjCont.Runninggear= true;
        ObjCont.Side= true;
        ObjCont.SurfSystem= true;
        ObjCont.Towerspeakers= true;
        ObjCont.Trailerwheels= true;
        ObjCont.BackupCamera= true;
        ObjCont.EngineCompartment= true;
        ObjCont.SpeedWakeplatelevers= true;
        ObjCont.SteeringWakeplatelevers= true;
        ObjCont.Transomremote= true;
        ObjCont.Transom= true;
        ObjCont.UnderwaterLights= true;
        ObjCont.Walkthrough= true;
        ObjCont.BRoll= true;
        ObjCont.ConvertibleSeating= true;
         
    }
    
}