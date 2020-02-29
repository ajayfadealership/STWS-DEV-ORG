@isTest
global class Shopify_ConnectMockTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"custom_collections": {"id":2, "name":"Test"}}');
        response.setStatusCode(200);
        return response; 
    }
    /*
    global HTTPResponse respond1(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"custom_collections":[{"id":87526244463,"handle":"api-test","title":"API TEST","updated_at":"2018-10-30T05:56:18-04:00","body_html":null,"published_at":"2018-10-27T14:02:15-04:00","sort_order":"best-selling","template_suffix":null,"published_scope":"web"},{"id":84726349935,"handle":"boat-accessories","title":"BOAT ACCESSORIES","updated_at":"2018-10-17T09:06:24-04:00","body_html":"Get your Boat Accessories for MasterCraft, Supra, Moomba and Malibu Boats","published_at":"2018-10-13T16:47:03-04:00","sort_order":"best-selling","template_suffix":null,"published_scope":"global"},{"id":84726841455,"handle":"boat-parts","title":"BOAT PARTS","updated_at":"2018-10-26T21:50:37-04:00","body_html":"Boat Parts For MasterCraft, Supra, Moomba and Malibu Boats","published_at":"2018-10-13T16:52:39-04:00","sort_order":"best-selling","template_suffix":null,"published_scope":"global"}]}');
        response.setStatusCode(200);
        return response; 
    }*/
}