@RestResource(urlMapping='/UAORequestHandler/v1/*')
global with sharing class UAORequestHandlerRest
{
    @HttpGet
    webservice static UAOResponseWrapper fetchContactDetails() {
        String payload = RestContext.request.requestBody.toString();
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(payload);
        
        UAOResponseWrapper objWrap = new UAOResponseWrapper();
        if(!m.containsKey('conId') || m.get('conId') == null){
            
            objWrap.contact = null;
            objWrap.response_Code = 'Required Field Missing.';
            objWrap.message = 'Please provide Contact Id.';
        }
        else if(!m.containsKey('queryString') || m.get('queryString') == null){
            
            objWrap.contact = null;
            objWrap.response_Code = 'Required Field Missing.';
            objWrap.message = 'Please provide Fields to be returned.';
        } 
        else {
            String conId = String.valueOf(m.get('conId'));
            String queryString = 'SELECT '+String.valueOf(m.get('queryString'))+' FROM Contact WHERE Id =\''+conId+'\'';
            Contact con = Database.query(queryString);
            
            objWrap.contact = String.valueOf(con);
            objWrap.response_Code = '200 OK';
            objWrap.message = 'SUCCESS';
        }
        return objWrap;
    }
}