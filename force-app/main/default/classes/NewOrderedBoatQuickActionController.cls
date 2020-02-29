public class NewOrderedBoatQuickActionController {
    @AuraEnabled 
    public static String NewOrderedBoatCheckbox(String strQtId) {
        BOATBUILDING__Quote__c objQuote = [select id,BOATBUILDING__New_Ordered_Boat__c,BOATBUILDING__Status__c,BOATBUILDING__Test_2__c from BOATBUILDING__Quote__c Where Id =: strQtId];
        if(objQuote.BOATBUILDING__Status__c =='Final' && objQuote.BOATBUILDING__Test_2__c == null){
            objQuote.BOATBUILDING__New_Ordered_Boat__c = true;
            update objQuote;
            return 'SUCCESS';
        }
        else if(objQuote.BOATBUILDING__Test_2__c != null){
            return 'Ordered Boat is already created';
        } else if(objQuote.BOATBUILDING__Status__c !='Final') {
            return 'Quote is not final';
        }
        return null;
    }   
}