@IsTest 
global class AccessControllCheckMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    { 
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        string fakeResp = 'T8t1qQKrfiSDRKYJjGT9N58q7ZDZzPUNpHub81RQYn8=&-287805199083649';
        res.setBody(fakeResp);
        res.setStatusCode(200);
        return res;   
    }
}