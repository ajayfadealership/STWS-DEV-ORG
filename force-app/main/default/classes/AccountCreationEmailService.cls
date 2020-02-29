/** 
* Author : Akshay Kumar 
* Created Date : 21/10/2016
*/

global class AccountCreationEmailService implements Messaging.InboundEmailHandler {
    
    Account objAccount = new Account();
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
       
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String strForPlainText = email.PlainTextBody;
        String sourceEmail = email.fromAddress;
        sourceEmail = sourceEmail.substring(sourceEmail.indexOfIgnoreCase('@')+1,sourceEmail.length()-1);
        String tempLeadSource = sourceEmail.substring(0,sourceEmail.indexOfIgnoreCase('.'));
        System.debug('________tempLeadSource: '+tempLeadSource);
        
        objAccount.BOATBUILDING__IsCreatedFromWeb__c = True;
        if(tempLeadSource == 'boattrader'){
            objAccount.Lead_Source__c = 'Boat Trader';
            
        }else if(tempLeadSource == 'dealerspike'){
            objAccount.Lead_Source__c = 'Dealer Spike';
            
        }else if(tempLeadSource == 'skierschoice'){
            objAccount.Lead_Source__c = 'Skiers Choice';
            
        }else if(tempLeadSource == 'malibuboats'){
            objAccount.Lead_Source__c = 'MaliBu boats';
            
        }else if(tempLeadSource == 'onlyinboards'){
            objAccount.Lead_Source__c = 'Only Inboards';   
        
        } else if((strForPlainText.containsIgnoreCase('Supra') || strForPlainText.containsIgnoreCase('Moomba'))&&
                 (strForPlainText.containsIgnoreCase('View Lead <') || strForPlainText.containsIgnoreCase('VIEW LEAD<'))){
            skiersChoiceLeadCreation(strForPlainText);
        } /*else {
            objAccount.Lead_Source__c = 'Boat.com';
        }*/
        
        if(strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('City') 
            && strForPlainText.containsIgnoreCase('State') && strForPlainText.containsIgnoreCase('Zip') && strForPlainText.containsIgnoreCase('Phone')
                && strForPlainText.containsIgnoreCase('Year') && strForPlainText.containsIgnoreCase('Price') && strForPlainText.containsIgnoreCase('Comments')){
             
             //***First Template       
            attachingFieldsValueForFirstTemplate(strForPlainText);
            
        }else if(strForPlainText.containsIgnoreCase('First Name') && strForPlainText.containsIgnoreCase('Last Name') && strForPlainText.containsIgnoreCase('Work Phone') 
                && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Telephone') &&  strForPlainText.containsIgnoreCase('SourcePage') 
                    && strForPlainText.containsIgnoreCase('FormPage') && strForPlainText.containsIgnoreCase('NewsLetterOptIn') && strForPlainText.containsIgnoreCase('Comments')){
            
            //***Second Template                    
            attachingFieldsValueForSecondTemplate(strForPlainText);
            
        }else if(strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Address') && strForPlainText.containsIgnoreCase('City') 
                && strForPlainText.containsIgnoreCase('State') && strForPlainText.containsIgnoreCase('Zip') &&  strForPlainText.containsIgnoreCase('Phone') 
                    && strForPlainText.containsIgnoreCase('Fax') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Catalog')){
            
            //***Third Template                     
            attachingFieldsValueForThirdTemplate(strForPlainText);
            
        } else if(strForPlainText.containsIgnoreCase('Boat') &&
                  strForPlainText.containsIgnoreCase('Name') &&
                  strForPlainText.containsIgnoreCase('Email')  &&
                  strForPlainText.containsIgnoreCase('Phone Number') &&
                  strForPlainText.containsIgnoreCase('Message')){
            
            //***Eight Template -- OnlyInboards.com                    
            attachingFieldsValueForEightTemplate(strForPlainText);
        
        } else if(strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') &&
                  strForPlainText.containsIgnoreCase('Zip') && strForPlainText.containsIgnoreCase('Phone') &&
                  strForPlainText.containsIgnoreCase('Year') && strForPlainText.containsIgnoreCase('Price') &&
                  strForPlainText.containsIgnoreCase('Comments')){
             
             //***Ninth Template --- BoatTrader.Com
            attachingFieldsValueForNinthTemplate(strForPlainText);
            
        }else if(strForPlainText.containsIgnoreCase('Request Type') && strForPlainText.containsIgnoreCase('Source')  &&  strForPlainText.containsIgnoreCase('Date/Time') 
                    && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Zip/PostalCode') 
                        && strForPlainText.containsIgnoreCase('Country') && strForPlainText.containsIgnoreCase('Phone')){
            
            //***Fifth Template                     
            attachingFieldsValueForFifthTemplate(strForPlainText);
            
        }else if(strForPlainText.containsIgnoreCase('Address') && strForPlainText.containsIgnoreCase('Name')  &&  strForPlainText.containsIgnoreCase('Email') 
                    && strForPlainText.containsIgnoreCase('Lead') && strForPlainText.containsIgnoreCase('Sale') && strForPlainText.containsIgnoreCase('Make') 
                        && strForPlainText.containsIgnoreCase('Model') && strForPlainText.containsIgnoreCase('Year')&& strForPlainText.containsIgnoreCase('IMT')
                            && strForPlainText.containsIgnoreCase('URI') && strForPlainText.containsIgnoreCase('Comments')){
            
            //***Sixth Template                     
            attachingFieldsValueForSixthTemplate(strForPlainText);
        }else if(strForPlainText.containsIgnoreCase('Lead Source') && strForPlainText.containsIgnoreCase('Name')  &&  strForPlainText.containsIgnoreCase('Email') 
                    && strForPlainText.containsIgnoreCase('Phone') && strForPlainText.containsIgnoreCase('Address 1') && strForPlainText.containsIgnoreCase('Address 2') 
                        && strForPlainText.containsIgnoreCase('City') && strForPlainText.containsIgnoreCase('State')&& strForPlainText.containsIgnoreCase('Postal Code')
                            && strForPlainText.containsIgnoreCase('Country') && strForPlainText.containsIgnoreCase('Configured Boat') && strForPlainText.containsIgnoreCase('Configured Boat URL')
                                && strForPlainText.containsIgnoreCase('Comments')){
            
            //***Seventh Template
            attachingFieldsValueForSeventhTemplate(strForPlainText);
        } else if(strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email')  &&  strForPlainText.containsIgnoreCase('Phone') 
                    && strForPlainText.containsIgnoreCase('Message')){
            
            //***Fourth Template                     
            attachingFieldsValueForFourthTemplate(strForPlainText);
        
        }
        
        try{
            objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account Trade').getRecordTypeId();
            objAccount.Name = objAccount.Name+'(Email-Lead)';
            insert objAccount; 
        }catch(Exception ex){
            System.debug('Please Do Correct : '+ex.getMessage()); 
            SendEmailUtility.sendQuickEmail(ex.getMessage() +'  :  '+ex.getLineNumber()+'--:--'+ex.getStackTraceString());
        }
        List<Attachment> lstAttachment = new List<Attachment>();
        if (email.binaryAttachments != null && email.binaryAttachments.size() > 0){
            for(Integer i = 0 ; i < email.binaryAttachments.size() ; i++){
                Attachment objAttchment = new Attachment();
                objAttchment.ParentId = objAccount.Id;
                objAttchment.Name = email.binaryAttachments[i].filename;
                objAttchment.Body = email.binaryAttachments[i].body;
                lstAttachment.add(objAttchment); 
            }
            try{
                insert lstAttachment;  
            }catch(Exception ex){
                System.debug('Please Do Correct : '+ex.getMessage());
                SendEmailUtility.sendQuickEmail(ex.getMessage() +'  :  '+ex.getLineNumber()+'--:--'+ex.getStackTraceString());
               // System.debug('Please Do Correct In : '+ex.getLineNuber());
            }
        }   
        return result;
    }
    
    //***First Template       
    private void attachingFieldsValueForFirstTemplate(String strForPlainText){
        
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
    
    private void attachingFieldsValueForSecondTemplate(String strForPlainText){
        
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
    
    private void attachingFieldsValueForThirdTemplate(String strForPlainText){
        
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
    
    private void attachingFieldsValueForFourthTemplate(String strForPlainText){
        
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
    
    private void attachingFieldsValueForFifthTemplate(String strForPlainText){
        
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

    private void attachingFieldsValueForSixthTemplate(String strForPlainText){
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
    
    private void attachingFieldsValueForSeventhTemplate(String strForPlainText){
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
    private void attachingFieldsValueForEightTemplate(String strForPlainText){
        //OnlyInboards.com
        System.debug('plaintextdebug------attachingFieldsValueForEightTemplate'+strForPlainText);
        String subSTRDesiredBoat = strForPlainText.subString(strForPlainText.indexOfIgnoreCase('Boat:'), strForPlainText.indexOfIgnoreCase('To contact this lead'));
        String subStringForPlainText = strForPlainText.subString( strForPlainText.indexOfIgnoreCase('Name'), strForPlainText.indexOfIgnoreCase('P.S.'));
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
    private void attachingFieldsValueForNinthTemplate(String strForPlainText){
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
    
    private void addFirstLastName(String strAccountName){
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
    
    private void skiersChoiceLeadCreation(String strForPlainText){
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
            String json = httpResponseNew.getBody().substringbetween('var model = ',';');
            
            System.debug('----json'+json);
            SupraMoombaEmailJSON2Apex obj = SupraMoombaEmailJSON2Apex.parse(json);
            System.debug('---obj---'+obj.RecordData);
            
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect Account Trade').getRecordTypeId();
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
}