public class AccountCreationEmailServiceHandler {
    Account objAccount;
    public AccountCreationEmailServiceHandler(Account objAccount) {
        this.objAccount = objAccount;
    }
    //***First Template       
    public void attachingFieldsValueForFirstTemplate(String strForPlainText){
        
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.length()-1);
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        
        for(String strArray : splitedPlainBody){
            
            if(strArray.containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('City') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('City')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('State') && String.isBlank(objAccount.BillingCity)){
                objAccount.BillingCity = strArray.substring(0,strArray.indexOfIgnoreCase('State')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Zip') && String.isBlank(objAccount.BillingState)){
                objAccount.BillingState = strArray.substring(0,strArray.indexOfIgnoreCase('Zip')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Phone') && String.isBlank(objAccount.BillingPostalCode)){
                objAccount.BillingPostalCode = strArray.substring(0,strArray.indexOfIgnoreCase('Phone')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Year') && String.isBlank(objAccount.Phone)){
                objAccount.Phone = strArray.removeEndIgnoreCase('Year').removeStart(' ');
            } 
            else if(strArray.containsIgnoreCase('Price') && String.isBlank(objAccount.Year__c)){
                objAccount.Year__c = strArray.substring(0,strArray.indexOfIgnoreCase('Price')).removeStart(' ');
            } 
            else if(strArray.containsIgnoreCase('Comments') && String.isBlank(objAccount.Price__c)){
                objAccount.Price__c = strArray.substring(0,strArray.indexOfIgnoreCase('Comments')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Thank') && String.isBlank(objAccount.Comments__c)){
                objAccount.Comments__c = strArray.substring(0,strArray.indexOfIgnoreCase('Thank')).removeStart(' ');
            }  
        }       
    }
    
    public void attachingFieldsValueForSecondTemplate(String strForPlainText){
        
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('First Name'), strForPlainText.length()-1);
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        
        for(String strArray : splitedPlainBody){
            if(strArray.containsIgnoreCase('Last Name')){
                String tempFirstName =  strArray.substring(0,strArray.indexOfIgnoreCase('Last Name')).removeStart(' ');
                objAccount.Name = tempFirstName.removeEnd(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('Work Phone')){
                if(objAccount.Name != ''){
                    objAccount.Name = objAccount.Name +' '+ strArray.substring(0,strArray.indexOfIgnoreCase('Work Phone')).removeStart(' ');
                }else{
                    objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Work Phone')).removeStart(' ');
                }
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('Email') && String.isBlank(objAccount.Work_Phone__c)){
                objAccount.Work_Phone__c = strArray.substring(0,strArray.indexOfIgnoreCase('Email')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('telephone') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('telephone')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('SourcePage') && String.isBlank(objAccount.Telephone__c)){
                objAccount.Telephone__c = strArray.substring(0,strArray.indexOfIgnoreCase('SourcePage')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('formpage') && String.isBlank(objAccount.SourcePage__c)){
                objAccount.SourcePage__c = strArray.substring(0,strArray.indexOfIgnoreCase('formpage')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('NewsletterOptIn') && String.isBlank(objAccount.FormPage__c)){
                objAccount.FormPage__c = strArray.substring(0,strArray.indexOfIgnoreCase('NewsletterOptIn')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Comments') && String.isBlank(objAccount.NewsletterOptIn__c)){
                objAccount.NewsletterOptIn__c = strArray.substring(0,strArray.indexOfIgnoreCase('Comments')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Thank') && String.isBlank(objAccount.Comments__c)){
                objAccount.Comments__c = strArray.substring(0,strArray.indexOfIgnoreCase('Thank')).removeStart(' ');
            }
        } 
    }
    
    public void attachingFieldsValueForThirdTemplate(String strForPlainText){
        
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.length()-1);
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        
        for(String strArray : splitedPlainBody){
            if(strArray.containsIgnoreCase('Address') && String.isBlank(objAccount.Name)){
                objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Address')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('City') && String.isBlank(objAccount.BillingStreet)){
                objAccount.BillingStreet = strArray.substring(0,strArray.indexOfIgnoreCase('City')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('State') && String.isBlank(objAccount.BillingCity)){
                objAccount.BillingCity = strArray.substring(0,strArray.indexOfIgnoreCase('State')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Zip') && String.isBlank(objAccount.BillingState)){
                objAccount.BillingState = strArray.substring(0,strArray.indexOfIgnoreCase('Zip')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Phone') && String.isBlank(objAccount.BillingPostalCode)){
                objAccount.BillingPostalCode = strArray.substring(0,strArray.indexOfIgnoreCase('Phone')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Fax') && String.isBlank(objAccount.Phone)){
                objAccount.Phone = strArray.substring(0,strArray.indexOfIgnoreCase('Fax')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('email') && String.isBlank(objAccount.Fax)){
                objAccount.Fax = strArray.substring(0,strArray.indexOfIgnoreCase('email')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Catalog') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('Catalog')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('true')){
                objAccount.Catalog__c = true;
            }else if(strArray.containsIgnoreCase('false')){
                objAccount.Catalog__c = false;
            }
        }  
    }
    
    public void attachingFieldsValueForFourthTemplate(String strForPlainText){
        
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.indexOfIgnoreCase('Thank'));
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        
        for(String strArray : splitedPlainBody){
            if(strArray.containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('Phone') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('Phone')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Message') && strArray.length()<20){
                objAccount.Phone = strArray.substring(0,strArray.indexOfIgnoreCase('Message')).removeStart(' ');
            }
            else{
                objAccount.Comments__c = strArray.substring(0,strArray.length()-1).removeStart(' ');
            }
        }  
    }
    
    public void attachingFieldsValueForFifthTemplate(String strForPlainText){
        
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Request'), strForPlainText.length()-1);
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        
        for(Integer i=0 ; i < splitedPlainBody.size() ; i++){
            if(splitedPlainBody[i].containsIgnoreCase('Source') && String.isBlank(objAccount.Request_Type__c)){
                objAccount.Request_Type__c = splitedPlainBody[i].removeEndIgnoreCase('Source').removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Date/Time') && String.isBlank(objAccount.Source__c)){
                objAccount.Source__c = splitedPlainBody[i].removeEndIgnoreCase('Date/Time').removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Name') && String.isBlank(objAccount.Date_Time__c)){
                objAccount.Date_Time__c = splitedPlainBody[i-1]+':'+splitedPlainBody[i].removeEndIgnoreCase('Name').removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = splitedPlainBody[i].removeEndIgnoreCase('Email').removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Zip/PostalCode') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = splitedPlainBody[i].removeEndIgnoreCase('Zip/PostalCode').removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Country') && String.isBlank(objAccount.BillingPostalCode)){
                objAccount.BillingPostalCode = splitedPlainBody[i].removeEndIgnoreCase('Country').removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Phone') && String.isBlank(objAccount.BillingCountry) && String.isBlank(objAccount.Phone)) {
            System.debug('____________: '+splitedPlainBody[i]);
                objAccount.BillingCountry = splitedPlainBody[i].removeEndIgnoreCase('Phone').removeStart(' ');
                if(splitedPlainBody[i+1] != null && splitedPlainBody[i+1].containsIgnoreCase('\n')){
                    objAccount.Phone = splitedPlainBody[i+1].substring(0,String.valueOf(splitedPlainBody[i+1]).indexOfIgnoreCase('\n'));
                }
            } 
        }  
    }

    public void attachingFieldsValueForSixthTemplate(String strForPlainText){
        String []splitedPlainBody = strForPlainText.split(':');
        objAccount.Name = '';
        System.debug('splitedPlainBody______________: '+splitedPlainBody);
        for(Integer i=0 ; i<splitedPlainBody.size() ; i++){
            if(splitedPlainBody[i].containsIgnoreCase('INDIVIDUAL') && String.isBlank(objAccount.BillingStreet)){
                objAccount.BillingStreet = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('INDIVIDUAL')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(splitedPlainBody[i].containsIgnoreCase('LEAD INFORMATION')){
                objAccount.Email__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('LEAD')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Lead source')){
                objAccount.Date_Time__c = splitedPlainBody[i-1]+':'+splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Lead')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Lead request type')){
                objAccount.Lead_Status__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Lead')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('SALES BOAT')){
                objAccount.Request_Type__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('SALES')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Make') && String.isBlank(objAccount.Sale_Class__c)){
                objAccount.Sale_Class__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Make')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Model description')){
                objAccount.Make__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Model')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Year') && String.isBlank(objAccount.Model__c)){
                objAccount.Model__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Year')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('IMT ID')){
                objAccount.Year__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('IMT ID')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('URI') && String.isBlank(objAccount.IMT_ID__c)){
                objAccount.IMT_ID__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('URI')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('CUSTOMER COMMENTS')){
                objAccount.URI__c = splitedPlainBody[i-1]+':'+splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('CUSTOMER')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Thank') && String.isBlank(objAccount.Comments__c)){
                objAccount.Comments__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Thank')).removeStart(' ');
            }
        }
    }
    
    public void attachingFieldsValueForSeventhTemplate(String strForPlainText){
    System.debug('plaintextdebug------attachingFieldsValueForSeventhTemplate'+strForPlainText);
        String []splitedPlainBody = strForPlainText.split(':');
        objAccount.Name = '';
        System.debug('splitedPlainBody______________: '+splitedPlainBody);
        for(Integer i=0 ; i<splitedPlainBody.size() ; i++){
            if(splitedPlainBody[i].containsIgnoreCase('Name') && String.isBlank(objAccount.Source__c)){
                objAccount.Source__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Name')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Phone') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Phone')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Address 1') && String.isBlank(objAccount.Phone)){
                objAccount.Phone = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Address')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Address 2') && String.isBlank(objAccount.BillingStreet)){
                objAccount.BillingStreet = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Address')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('City') && String.isBlank(objAccount.ShippingStreet)){
                objAccount.ShippingStreet = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('City')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('State') && String.isBlank(objAccount.BillingCity)){
                objAccount.BillingCity = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('State')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Postal Code') && String.isBlank(objAccount.BillingState)){
                objAccount.BillingState = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Postal')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Country') && String.isBlank(objAccount.BillingPostalCode)){
                objAccount.BillingPostalCode = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Country')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Configured Boat') && String.isBlank(objAccount.BillingCountry) && !splitedPlainBody[i].containsIgnoreCase('Configured Boat URL')){
                objAccount.BillingCountry = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Configured')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Configured Boat URL') && String.isBlank(objAccount.Configured_Boat__c)){
                objAccount.Configured_Boat__c = splitedPlainBody[i].substring(0,splitedPlainBody[i].indexOfIgnoreCase('Configured')).removeStart(' ');
            }
            else if(splitedPlainBody[i].containsIgnoreCase('Comments') && splitedPlainBody[i].containsIgnoreCase('www') && String.isBlank(objAccount.Configured_Boat_URL__c)){
                objAccount.Configured_Boat_URL__c = 'https://'+splitedPlainBody[i].substring(splitedPlainBody[i].indexOfIgnoreCase('www'),splitedPlainBody[i].indexOfIgnoreCase('Comments')).trim();
                
                if(splitedPlainBody[i+1] != null && splitedPlainBody[i+1].containsIgnoreCase('\n') && String.isBlank(objAccount.Comments__c)){
                    objAccount.Comments__c = splitedPlainBody[i+1].substring(0,splitedPlainBody[i+1].indexOfIgnoreCase('\n')).removeStart(' ');
                }else if(splitedPlainBody[i+1] != null && String.isBlank(objAccount.Comments__c) && splitedPlainBody[i+1].containsIgnoreCase('You can view')){
                    objAccount.Comments__c = splitedPlainBody[i+1].substring(0,splitedPlainBody[i+1].indexOfIgnoreCase('You can view')).removeStart(' ');
                }
            } 
        }
    }
    @TestVisible 
    public void attachingFieldsValueForEightTemplate(String strForPlainText){
        //OnlyInboards.com
        System.debug('plaintextdebug------attachingFieldsValueForEightTemplate'+strForPlainText);
        String subSTRDesiredBoat = strForPlainText.subString(strForPlainText.indexOfIgnoreCase('Boat:'), strForPlainText.indexOfIgnoreCase('To contact this lead'));
        String subStringForPlainText = '';
        if(strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('P.S.')){
            subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.indexOfIgnoreCase('P.S.'));
        
        }
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        objAccount.BOATBUILDING__Desire_boat_model__c = subSTRDesiredBoat;
        
        for(String strArray : splitedPlainBody){
            if(strArray.containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('Phone number') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('Phone number')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Message') && strArray.length()<20){
                objAccount.Phone = strArray.substring(0,strArray.indexOfIgnoreCase('Message')).removeStart(' ');
            }
            else{
                objAccount.Comments__c = strArray.substring(0,strArray.length()-1).removeStart(' ');
            }
        }  
    }
    @TestVisible 
    public void attachingFieldsValueForNinthTemplate(String strForPlainText){
        //BoatTrader.com
        System.debug('plaintextdebug------attachingFieldsValueForNinthTemplate'+strForPlainText);
        String subSTRDesiredBoat = strForPlainText.subString(strForPlainText.indexOfIgnoreCase('VEHICLE INFO')+1, strForPlainText.indexOfIgnoreCase('Ad ID')-1);
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.indexOfIgnoreCase('Warmest regards'));
        String []splitedPlainBody = subStringForPlainText.split(':');
        objAccount.Name = '';
        objAccount.BOATBUILDING__Desire_boat_model__c = subSTRDesiredBoat;
        System.debug('splitedPlainBody---'+splitedPlainBody);
        for(String strArray : splitedPlainBody){
            
            if(strArray.containsIgnoreCase('Email') && String.isBlank(objAccount.Name)){
                objAccount.Name = strArray.substring(0,strArray.indexOfIgnoreCase('Email')).removeStart(' ');
                //To Update First Name & Last Name
                addFirstLastName(objAccount.Name);
            }
            else if(strArray.containsIgnoreCase('Zip*') && String.isBlank(objAccount.Email__c)){
                objAccount.Email__c = strArray.substring(0,strArray.indexOfIgnoreCase('Zip*')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Phone') && String.isBlank(objAccount.BillingPostalCode)){
                objAccount.BillingPostalCode = strArray.substring(0,strArray.indexOfIgnoreCase('Phone')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('Year') && String.isBlank(objAccount.Phone)){
                objAccount.Phone = strArray.removeEndIgnoreCase('Year').removeStart(' ');
            } 
            else if(strArray.containsIgnoreCase('Price') && String.isBlank(objAccount.Year__c)){
                objAccount.Year__c = strArray.substring(0,strArray.indexOfIgnoreCase('Price')).removeStart(' ');
            } 
            else if(strArray.containsIgnoreCase('Comments') && String.isBlank(objAccount.Price__c)){
                objAccount.Price__c = strArray.substring(0,strArray.indexOfIgnoreCase('Comments')).removeStart(' ');
            }
            else if(strArray.containsIgnoreCase('*This Location') && String.isBlank(objAccount.Comments__c)){
                objAccount.Comments__c = strArray.substring(0,strArray.indexOfIgnoreCase('*This Location')).removeStart(' ');
            }
        }       
    }
    
    public void addFirstLastName(String strAccountName){
        if(strAccountName.containsIgnoreCase(' ')){
            List<String> listAccountName = strAccountName.split(' ');
            if(listAccountName.size() >= 1){
                objAccount.BOATBUILDING__Prospect_First_Name__c = listAccountName.get(0);
                objAccount.BOATBUILDING__Prospect_Last_Name__c = listAccountName.get(listAccountName.size()-1);
            }
        } else {
            objAccount.BOATBUILDING__Prospect_Last_Name__c = strAccountName;
        }
    }
    
    public void skiersChoiceLeadCreation(String strForPlainText){
        String url = '';
        
        if(strForPlainText.contains('View Lead <')){
            url = strForPlainText.substringBetween('View Lead <','>');
        } else if(strForPlainText.contains('VIEW LEAD<')){
            url = strForPlainText.substringBetween('VIEW LEAD<','>');
        }
        
        System.debug('----------'+url);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        Http h = new Http();
        String response = '';
        if(!Test.isRunningTest()){
            HttpResponse httpResponse = h.send(req);
            System.debug(httpResponse.getBody());
            response = httpResponse.getBody();
            String newURL = EncodingUtil.urlDecode(response.substringbetween('target URL: <a href="','">').replaceAll('amp;',''), 'UTF-8');
            
            HttpRequest reqNew = new HttpRequest();
            reqNew.setMethod('GET');
            reqNew.setEndpoint(newURL);
            Http hNew = new Http();
            HttpResponse httpResponseNew = hNew.send(reqNew);
            System.debug('Response: '+httpResponseNew.getBody());
            String json = httpResponseNew.getBody().substringbetween('var model = ',';');
            
            System.debug('----json'+json);
            SupraMoombaEmailJSON2Apex obj = SupraMoombaEmailJSON2Apex.parse(json);
            System.debug('---obj---'+obj.RecordData);
            System.debug('---obj---'+obj.RecordData.FirstName);
            System.debug('---obj---'+obj.RecordData.LastName);
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
            acc.Name = obj.RecordData.FirstName+' '+obj.RecordData.LastName;
            acc.Name = acc.Name+'(Email-Lead)';
            acc.BOATBUILDING__Prospect_First_Name__c = obj.RecordData.FirstName;
            acc.BOATBUILDING__Prospect_Last_Name__c = obj.RecordData.LastName; 
            acc.BOATBUILDING__Contact_Email__c = obj.RecordData.Email;
            acc.BOATBUILDING__Email__c = obj.RecordData.Email;
            acc.BOATBUILDING__Prospect_Address_Line_1__c = obj.RecordData.Address1;
            acc.BOATBUILDING__Prospect_Address_Line_2__c = obj.RecordData.Address2;
            acc.BOATBUILDING__Prospect_City__c = obj.RecordData.City;
            acc.BOATBUILDING__Prospect_State__c = obj.RecordData.State;
            acc.BOATBUILDING__County__c = obj.RecordData.County;
            acc.BOATBUILDING__Country__c = obj.RecordData.Country;
            acc.BOATBUILDING__Prospect_Zip_Code__c = obj.RecordData.PostalCode;
            acc.BOATBUILDING__BrandId__c = obj.RecordData.BrandId;
            acc.BOATBUILDING__DealerDistance__c = obj.RecordData.DealerDistance;
            acc.BOATBUILDING__DealerDistance__c = obj.RecordData.DealerDistanceMiles;
            acc.BOATBUILDING__DealerDistanceMilesText__c = obj.RecordData.DealerDistanceMilesText;
            acc.BOATBUILDING__FollowUpStatus__c = obj.RecordData.FollowUpStatusName;
            acc.BOATBUILDING__Telephone__c = obj.RecordData.HomePhone;
            acc.BOATBUILDING__Lead_Source__c  = 'Skiers Choice';
            acc.BOATBUILDING__Prospect_Mobile_Phone_Number__c = obj.RecordData.MobilePhone;
            acc.BOATBUILDING__Desire_boat_model__c = obj.RecordData.ProductName+'('+obj.RecordData.Model+')';
            acc.BOATBUILDING__Year__c = obj.RecordData.ModelYear;
            acc.BOATBUILDING__Desired_Boat_Manufacturer__c = 'Skiers Choice('+obj.RecordData.BrandName+')';
            acc.BOATBUILDING__Work_Phone__c = obj.RecordData.WorkPhone;
            acc.BOATBUILDING__SkiersChoiceLeadUid__c = obj.RecordData.LeadUid;
            acc.BOATBUILDING__IsCreatedFromWeb__c = True;
            
            insert acc;
        }        
    }
    public void attachingForBTMobileTemplate(String strForHTMLBody){
        System.debug('>>>>>>strForHTMLBody: '+strForHTMLBody.remove('\n'));
        String strBody = strForHTMLBody.remove('\n');
        String subStr = strBody.substring(strBody.indexOfIgnoreCase('INDIVIDUAL PROSPECT:')+14, strBody.indexOfIgnoreCase('Email:')+8);
        String Name = '';
        if(subStr.containsIgnoreCase('Telephone:')) {
            Name = subStr.substring(subStr.indexOfIgnoreCase('Name:')+5, subStr.indexOfIgnoreCase('Telephone:')).trim();
        } else if(subStr.containsIgnoreCase('Email:')) {
            Name = subStr.substring(subStr.indexOfIgnoreCase('Name:')+5, subStr.indexOfIgnoreCase('Email:')).trim();
        }
        System.debug('>>>>Name: '+Name);
        objAccount.Name = Name;
        addFirstLastName(objAccount.Name);
        if(strBody.containsIgnoreCase('Telephone:')) {
            objAccount.Phone = strBody.substring(strBody.indexOfIgnoreCase('Telephone:')+10, strBody.indexOfIgnoreCase('Email:')).trim();
        }
        if(strBody.containsIgnoreCase('Email:') ) {
            if(!strBody.containsIgnoreCase('<mailto') ) {
                objAccount.Email__c = strBody.substring(strBody.indexOfIgnoreCase('Email:')+6, strBody.indexOfIgnoreCase('LEAD INFO')).trim();
            } else {
                objAccount.Email__c = strBody.substring(strBody.indexOfIgnoreCase('Email:')+6, strBody.indexOfIgnoreCase('<')).trim();
            }
        } 
        if(strBody.containsIgnoreCase('Lead source:') ) {
            objAccount.Lead_Source__c = 'Boat Trader';
        } 
        
        if(strBody.containsIgnoreCase('Lead request type:') ) {
            objAccount.BOATBUILDING__Request_Type__c = strBody.substring(strBody.indexOfIgnoreCase('Lead request type:')+18, strBody.indexOfIgnoreCase('SALES BOAT:')).trim();
        } 
        if(strBody.containsIgnoreCase('Sale class:')){
            objAccount.Sale_Class__c = strBody.substring(strBody.indexOfIgnoreCase('Sale class:')+11, strBody.indexOfIgnoreCase('Make:')).trim();
        }
        if(strBody.containsIgnoreCase('Make:')){
            objAccount.Make__c = strBody.substring(strBody.indexOfIgnoreCase('Make:')+5, strBody.indexOfIgnoreCase('Model description:')).trim();
        }
        if(strBody.containsIgnoreCase('Model description:')){
            objAccount.Model__c = strBody.substring(strBody.indexOfIgnoreCase('Model description:')+18, strBody.indexOfIgnoreCase('Year:')).trim();
        }
        if(strBody.containsIgnoreCase('Year:')){
            objAccount.Year__c = strBody.substring(strBody.indexOfIgnoreCase('Year:')+5, strBody.indexOfIgnoreCase('Stock Number:')).trim();
        }
        if(strBody.containsIgnoreCase('Stock Number:')){
            objAccount.Stock_Number__c = strBody.substring(strBody.indexOfIgnoreCase('Stock Number:')+13, strBody.indexOfIgnoreCase('IMT ID:')).trim();
        }
        if(strBody.containsIgnoreCase('IMT ID:')){
            objAccount.IMT_ID__c = strBody.substring(strBody.indexOfIgnoreCase('IMT ID:')+7, strBody.indexOfIgnoreCase('URI:')).trim();
        }
        if(strBody.containsIgnoreCase('URI:') ) {
            objAccount.URI__c = strBody.substring(strBody.indexOfIgnoreCase('URI:')+4, strBody.indexOfIgnoreCase('OFFICEINFO:')).trim();
        } 
        if(strForHTMLBody.containsIgnoreCase('CUSTOMER COMMENTS:') ) {
            objAccount.Comments__c = strBody.substring(strBody.indexOfIgnoreCase('CUSTOMER COMMENTS:')+18, strBody.length()).trim();
        } 
        System.debug('>>>objAccount: '+objAccount);
    } 
    public void attachingForOnlyInboardsTemplate(String strForHTMLBody) {
        
        System.debug('>>>>>>strForHTMLBody: '+strForHTMLBody.remove('\n'));
        String strBody = strForHTMLBody.remove('\n').remove('<br>'); 
        String subNameString = strBody.substring(strBody.indexOfIgnoreCase('Name:'), strBody.length());
        String Name = subNameString.substring(subNameString.indexOfIgnoreCase('Name:')+5, subNameString.indexOfIgnoreCase('</')).trim();
        objAccount.Name = Name;
        addFirstLastName(objAccount.Name);
        if(strBody.containsIgnoreCase('Boat:') ) {
            String subStr = strBody.substring(strBody.indexOfIgnoreCase('Boat:'), strBody.indexOfIgnoreCase('Boat ID:'));
            System.debug('>>>>>>subStr: '+subStr);
            objAccount.Model__c = subStr.substring(subStr.indexOfIgnoreCase('>')+1, subStr.indexOfIgnoreCase('</a')).trim();
            objAccount.URI__c = subStr.substring(subStr.indexOfIgnoreCase('href=')+6, subStr.indexOfIgnoreCase('>')-1).trim();
        }
        if(strBody.containsIgnoreCase('Boat ID:') ) {
            String subStr = strBody.substring(strBody.indexOfIgnoreCase('Boat ID:'), strBody.indexOfIgnoreCase('Name:'));
            System.debug('>>>>>>subStr: '+subStr);
            objAccount.Stock_Number__c = subStr.substring(subStr.indexOfIgnoreCase('Boat ID:')+8, subStr.indexOfIgnoreCase('</p><p>To')).trim();
        } 
        if(strBody.containsIgnoreCase('Email:') && strBody.containsIgnoreCase('Phone number:')) {
            String subStr = strBody.substring(strBody.indexOfIgnoreCase('Email:'), strBody.indexOfIgnoreCase('</p><p>Phone')+13);
            System.debug('>>>>>>subStr: '+subStr);
            objAccount.Email__c = subStr.substring(subStr.indexOfIgnoreCase('Email:')+6, subStr.indexOfIgnoreCase('</p><p>Phone')).trim();
        }  
        
        if(strBody.containsIgnoreCase('Phone number:') ) {
            String subStr = strBody.substring(strBody.indexOfIgnoreCase('Phone number:'), strBody.indexOfIgnoreCase('</p><p>Message')+15);
            System.debug('>>>>>>subStr: '+subStr);
            if(String.isNotBlank(subStr.substring(subStr.indexOfIgnoreCase('Phone number:')+13, subStr.indexOfIgnoreCase('</p><p>Message')).trim()))
                objAccount.Phone = subStr.substring(subStr.indexOfIgnoreCase('Phone number:')+13, subStr.indexOfIgnoreCase('</p><p>Message')).trim();
        } 
        if(strBody.containsIgnoreCase('Message:') ) {
            objAccount.Comments__c = strBody.substring(strBody.indexOfIgnoreCase('Message:')+8, strBody.indexOfIgnoreCase('</p></body>')).trim();
        }
        objAccount.Lead_Source__c = 'Only Inboards'; 
    } 

    //SJYS
    public void attachingSJYSJupiterMarine(String strForHTMLBody) {
        String strBody = strForHTMLBody;
        System.debug('>>>>>>strBody: '+strBody);
        objAccount.Lead_Source__c = 'Jupiter Marine';
        if(strBody.containsIgnoreCase('name')) {
            String strName = strBody.substring(strBody.indexOfIgnoreCase('Name'), strBody.indexOfIgnoreCase('Email'));
            String [] spltName = strName.split('\n');
            System.debug('>>>>>>strBody Name: '+spltName);
            objAccount.Name = spltName[2].trim();
            if(spltName.size() >= 5 && String.isNotBlank(spltName[4])) {
                objAccount.BillingStreet = spltName[4];
            }
            if(spltName.size() >= 6 && String.isNotBlank(spltName[5])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[5] : spltName[5];
            }
            if(spltName.size() >= 7 && String.isNotBlank(spltName[6])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[6] : spltName[6];
            }
            if(spltName.size() >= 8 && String.isNotBlank(spltName[7])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[7] : spltName[7];
            }
        }
        if(strBody.containsIgnoreCase('Email')) {
            String strEmail = strBody.substring(strBody.indexOfIgnoreCase('Email'), strBody.indexOfIgnoreCase('Telephone Number'));
            String [] spltName = strEmail.split('\n');
            System.debug('>>>>>>spltName: '+spltName);
            objAccount.Email__c = spltName[2].substring(0, spltName[2].indexOfIgnoreCase('<ma')).trim();
        }
        if(strBody.containsIgnoreCase('Telephone Number')) {
            String strTE = strBody.substring(strBody.indexOfIgnoreCase('Telephone Number'), strBody.indexOfIgnoreCase('How did you hear'));
            String [] spltName = strTE.split('\n');
            objAccount.Phone = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('How did you hear about')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('How did you hear about'), strBody.indexOfIgnoreCase('Boating Location'));
            String [] spltName = strBL.split('\n');
            objAccount.Source__c = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('Boating Location')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('Boating Location'), strBody.indexOfIgnoreCase('Model of Interest'));
            String [] spltName = strBL.split('\n'); 
            objAccount.BOATBUILDING__Boat_Location__c = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('Model of Interest')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('Model of Interest'), strBody.length());
            String [] spltName = strBL.split('\n'); 
            objAccount.BOATBUILDING__Desire_boat_model__c = spltName[2].trim();
        }
        System.debug('>>>>>>objAccount: '+objAccount);
    }
    public void attachingSJYSVikingYachts(String strForHTMLBody) {
        String strBody = strForHTMLBody;
        strBody = strBody.substring(strBody.indexOfIgnoreCase('Contact'), strBody.length()-1); 
        System.debug('>>>>>>strBody1: '+strBody);
        strBody = strBody.remove('\n').remove('<br>').replace('&nbsp;', ' ');
        System.debug('>>>>>>strBody2: '+strBody);
        if(strBody.containsIgnoreCase('Name:')) {

        }
        /*
        objAccount.Lead_Source__c = 'Jupiter Marine';
        if(strBody.containsIgnoreCase('name')) {
            String strName = strBody.substring(strBody.indexOfIgnoreCase('Name'), strBody.indexOfIgnoreCase('Email'));
            String [] spltName = strName.split('\n');
            System.debug('>>>>>>strBody Name: '+spltName);
            objAccount.Name = spltName[2].trim();
            if(spltName.size() >= 5 && String.isNotBlank(spltName[4])) {
                objAccount.BillingStreet = spltName[4];
            }
            if(spltName.size() >= 6 && String.isNotBlank(spltName[5])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[5] : spltName[5];
            }
            if(spltName.size() >= 7 && String.isNotBlank(spltName[6])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[6] : spltName[6];
            }
            if(spltName.size() >= 8 && String.isNotBlank(spltName[7])) {
                objAccount.BillingStreet = objAccount.BillingStreet != null ? objAccount.BillingStreet += spltName[7] : spltName[7];
            }
        }
        if(strBody.containsIgnoreCase('Email')) {
            String strEmail = strBody.substring(strBody.indexOfIgnoreCase('Email'), strBody.indexOfIgnoreCase('Telephone Number'));
            String [] spltName = strEmail.split('\n');
            System.debug('>>>>>>spltName: '+spltName);
            objAccount.Email__c = spltName[2].substring(0, spltName[2].indexOfIgnoreCase('<ma')).trim();
        }
        if(strBody.containsIgnoreCase('Telephone Number')) {
            String strTE = strBody.substring(strBody.indexOfIgnoreCase('Telephone Number'), strBody.indexOfIgnoreCase('How did you hear'));
            String [] spltName = strTE.split('\n');
            objAccount.Phone = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('How did you hear about')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('How did you hear about'), strBody.indexOfIgnoreCase('Boating Location'));
            String [] spltName = strBL.split('\n');
            objAccount.Source__c = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('Boating Location')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('Boating Location'), strBody.indexOfIgnoreCase('Model of Interest'));
            String [] spltName = strBL.split('\n'); 
            objAccount.BOATBUILDING__Boat_Location__c = spltName[2].trim();
        }
        if(strBody.containsIgnoreCase('Model of Interest')) {
            String strBL = strBody.substring(strBody.indexOfIgnoreCase('Model of Interest'), strBody.length());
            String [] spltName = strBL.split('\n'); 
            objAccount.BOATBUILDING__Desire_boat_model__c = spltName[2].trim();
        }
        System.debug('>>>>>>objAccount: '+objAccount);
        */
    }
}