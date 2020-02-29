@isTest
public class MockService implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        if(req.getEndpoint() == 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145830824089/customer'){
            // Create a fake response
             String resBody='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><IntuitResponse xmlns="http://schema.intuit.com/finance/v3" time="2017-05-21T05:01:34.917-07:00"><Customer domain="QBO" sparse="false"><Id>105</Id><SyncToken>0</SyncToken><MetaData><CreateTime>2017-05-21T05:01:34-07:00</CreateTime><LastUpdatedTime>2017-05-21T05:01:34-07:00</LastUpdatedTime></MetaData><GivenName>CCLp Test</GivenName><MiddleName>CCLp Test</MiddleName><FamilyName>Test Street</FamilyName><FullyQualifiedName>CCLp Test</FullyQualifiedName><DisplayName>CCLp Test</DisplayName><PrintOnCheckName>CCLp Test CCLp Test Test Street</PrintOnCheckName><Active>true</Active><DefaultTaxCodeRef>2</DefaultTaxCodeRef><Taxable>true</Taxable><BillAddr><Id>109</Id><Line1>Test Street</Line1><City>Test City</City></BillAddr><Job>false</Job><BillWithParent>false</BillWithParent><Balance>0</Balance><BalanceWithJobs>0</BalanceWithJobs><CurrencyRef name="United States Dollar">USD</CurrencyRef><PreferredDeliveryMethod>Print</PreferredDeliveryMethod></Customer></IntuitResponse>';
             res.setBody(resBody);
             res.setStatusCode(200);
        }
     return res;
    }
}