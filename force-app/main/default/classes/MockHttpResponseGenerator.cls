@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock{

         public  HTTPResponse respond(HTTPRequest req){
              HttpResponse res = new HttpResponse();
              res.setHeader('Content-Type', 'application/json');
         
            if(req.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/'){
                // Create a fake response
               // String resBody = String.escapeSingleQuotes('{"name1": "abc", "name2": "CloudCodiots1","email": "abcCloudcodiots@gmail.com"}');
               // res.setBody();
                res.setStatusCode(200);
            } else{
                res.setStatusCode(500);
                res.setBody('Error');
            }
            return res;
         }
    }