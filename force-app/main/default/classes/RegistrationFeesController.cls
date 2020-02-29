public class RegistrationFeesController {
	@AuraEnabled
    public static BOATBUILDING__System_Configure__c  getHiearchySettings(){
        return BOATBUILDING__System_Configure__c.getInstance();
    }
    @AuraEnabled
    public static List<Key_Value> getState() {
        List<Key_Value> lstKV = new List<Key_Value>();
        
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Quote__c.State__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            Key_Value obj = new Key_Value();
            obj.key = pickListVal.getLabel();
            obj.value = pickListVal.getLabel();
            lstKV.add(obj);
        }  
        
        return lstKV;
    }
}