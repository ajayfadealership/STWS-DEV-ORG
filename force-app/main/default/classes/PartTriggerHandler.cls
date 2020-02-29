public class PartTriggerHandler {
    public static void onAfterUpdate(Map<Id, Part__c> newMapPrt, Map<Id, Part__c> oldMapPrt) {
        if(runOnce()){
            updateInventoryFromPart(newMapPrt);
        }
        
        /*try {
Map<String, Part__c> mapPrt = new Map<String, Part__c>();
for(Id srtPrtId: newMapPrt.keySet()) {
mapPrt.put(newMapPrt.get(srtPrtId).Part_Number__c, newMapPrt.get(srtPrtId));
} 

List<Inventory__c> lstPartInv = new List<Inventory__c>();

for(Inventory__c objInv: [SELECT Id, Part_MSRP_Price__c, Weight__c, Part_Name__c, Map_Price__c, Size__c, 
Color__c, Cost__c, Minimum_Amount__c, Part_Location__c, Part_Number__c, BOATBUILDING__Family__c,
BOATBUILDING__Category__c
FROM Inventory__c WHERE Part_Number__c IN: mapPrt.keySet()]) 
{
Part__c objPrt = mapPrt.get(objInv.Part_Number__c);
objInv.Part_Name__c = objPrt.Name;
objInv.Part_MSRP_Price__c = objPrt.Retail_Price__c;
objInv.Weight__c = objPrt.Weight__c;
objInv.Map_Price__c = objPrt.Map_Price__c;
objInv.Size__c = objPrt.Part_Size__c;
objInv.Color__c = objPrt.Part_Color__c;
objInv.Cost__c = objPrt.Part_Cost__c;
objInv.Minimum_Amount__c = objPrt.Minimum_Amount__c;
objInv.Part_Location__c = objPrt.Location__c;

lstPartInv.add(objInv); 
}
if(!lstPartInv.isEmpty()) {
update lstPartInv; 
}
} catch(Exception ex) {
System.debug('Debug Log For Exception: ' + ex);
}*/
    } 
     public static void onAfterInsert(List<Part__c> lstPart){
      	addInventoryByPart(lstPart);   
     } 
    public static void updateInventoryFromPart(Map<Id, Part__c> newMapPrt) {
        
        List<Inventory__c> listInv = [SELECT Id, Part_Number__c, BOATBUILDING__Family__c, 
                                      BOATBUILDING__Category__c, BOATBUILDING__Part__c 
                                      FROM Inventory__c WHERE BOATBUILDING__Part__c IN: newMapPrt.keySet()];        
        
        if(!listInv.isEmpty()){
            for(Inventory__c inv: listInv){
                inv.BOATBUILDING__Category__c = newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Category1__c;
                inv.BOATBUILDING__Family__c = newMapPrt.get(inv.BOATBUILDING__Part__c).BOATBUILDING__Family1__c;
            }
            update listInv;
        }
    }
       
    public static void addInventoryByPart( list<Part__c> lstPart){
        for (Part__c objPart : lstPart) {
            if(objPart.Add_Inventory__c == true){
                BOATBUILDING__Inventory__c objInv = new BOATBUILDING__Inventory__c();
                objInv.BOATBUILDING__Part__c = objPart.Id;
                objInv.RecordTypeId = Schema.SObjectType.BOATBUILDING__Inventory__c.getRecordTypeInfosByName().get('Inventory for Parts').getRecordTypeId();
                if (objPart.BOATBUILDING__Vendor_Name__c != null) { 
                    objInv.BOATBUILDING__Vendor__c = objPart.BOATBUILDING__Vendor_Name__c;
                    objInv.BOATBUILDING__Category__c = objPart.BOATBUILDING__Category1__c;
                    objInv.BOATBUILDING__Cost__c =  objPart.BOATBUILDING__Part_Cost__c;
                    objInv.BOATBUILDING__Part_Number__c = objPart.BOATBUILDING__Part_Number__c;
                }
                insert objInv;
            }
        }
    }
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
}