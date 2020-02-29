@isTest
public class DragAndDropRESTAPITest {
    static testMethod void doGetCoverage(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        RestContext.request = req;
        RestContext.response = res;
    }
    
}