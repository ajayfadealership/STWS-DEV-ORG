/** 
* Author : Akshay Kumar 
* Created Date : 21/10/2016
*/

global class AccountCreationEmailService implements Messaging.InboundEmailHandler {
    
    Account objAccount = new Account();
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        try{        
            String strForPlainText = email.PlainTextBody;
            String sourceEmail = email.fromAddress;
            sourceEmail = sourceEmail.substring(sourceEmail.indexOfIgnoreCase('@')+1,sourceEmail.length()-1);
            String tempLeadSource = sourceEmail.substring(0,sourceEmail.indexOfIgnoreCase('.'));
            System.debug('________tempLeadSource: '+ strForPlainText);
            //System.debug('strForPlainText: '+ strForPlainText);
            System.debug('strForhtmlBody: '+email.htmlBody);
            //System.debug('strForhtmlBody Contact Information : '+email.htmlBody.substring(email.htmlBody.indexOfIgnoreCase('Contact Information'), email.htmlBody.length()));
            
            String strForHTMLBody = email.htmlBody != null ? String.valueOf(email.htmlBody) : '';
            objAccount.BOATBUILDING__IsCreatedFromWeb__c = True;
            if(tempLeadSource == 'boattrader' || tempLeadSource == 'boatsmonitor'){
                objAccount.Lead_Source__c = 'Boat Trader';
                
            }else if(tempLeadSource == 'dealerspike'){
                objAccount.Lead_Source__c = 'Dealer Spike';
                
            }else if(tempLeadSource == 'skierschoice'){
                objAccount.Lead_Source__c = 'Skiers Choice';
                
            }else if(tempLeadSource == 'malibuboats'){
                objAccount.Lead_Source__c = 'MaliBu boats';
                
            }else if(tempLeadSource == 'onlyinboards'){
                objAccount.Lead_Source__c = 'Only Inboards';   
            
            }  /*else {
                objAccount.Lead_Source__c = 'Boat.com';
            }*/

            AccountCreationEmailServiceHandler objACES = new AccountCreationEmailServiceHandler(objAccount);
            

            // if(email.htmlBody.containsIgnoreCase('vikingyachts') && email.htmlBody.containsIgnoreCase('Name') && email.htmlBody.containsIgnoreCase('Address')
            //     && email.htmlBody.containsIgnoreCase('E-mail') ) {
            //             objACES.attachingSJYSVikingYachts(email.htmlBody);
            // }
            // else 
            if(strForPlainText != null && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Telephone Number')
                && strForPlainText.containsIgnoreCase('How did you hear about Jupiter Marine') && strForPlainText.containsIgnoreCase('Boating Location') 
                    && strForPlainText.containsIgnoreCase('Model of Interest')) {
                        objACES.attachingSJYSJupiterMarine(strForPlainText);
            }
            else if(strForPlainText != null && (strForPlainText.containsIgnoreCase('Supra') || strForPlainText.containsIgnoreCase('Moomba'))&&
                    (strForPlainText.containsIgnoreCase('View Lead <') || strForPlainText.containsIgnoreCase('VIEW LEAD<'))){
                        objACES.skiersChoiceLeadCreation(strForPlainText);
            } 
            else if(String.isNotBlank(strForHTMLBody) && strForHTMLBody.containsIgnoreCase('OnlyInboards') && strForHTMLBody.containsIgnoreCase('Boat') && strForHTMLBody.containsIgnoreCase('Boat ID')
                        && strForHTMLBody.containsIgnoreCase('Name') && strForHTMLBody.containsIgnoreCase('Email') 
                            && strForHTMLBody.containsIgnoreCase('Message')) {
                                objACES.attachingForOnlyInboardsTemplate(strForHTMLBody);
            }
            else if( strForPlainText != null && strForPlainText.containsIgnoreCase('Lead source') && strForPlainText.containsIgnoreCase('Lead request type') && strForPlainText.containsIgnoreCase('Sale class')
                        && strForPlainText.containsIgnoreCase('Make') && strForPlainText.containsIgnoreCase('Model description') && strForPlainText.containsIgnoreCase('Year')
                            && strForPlainText.containsIgnoreCase('Stock Number') && strForPlainText.containsIgnoreCase('IMT ID') && strForPlainText.containsIgnoreCase('URI')
                                && strForPlainText.containsIgnoreCase('INDIVIDUAL PROSPECT') && strForPlainText.containsIgnoreCase('LEAD INFORMATION') && strForPlainText.containsIgnoreCase('SALES BOAT')) {
                                    objACES.attachingForBTMobileTemplate(strForPlainText);
            }
            else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('City') 
                && strForPlainText.containsIgnoreCase('State') && strForPlainText.containsIgnoreCase('Zip') && strForPlainText.containsIgnoreCase('Phone')
                    && strForPlainText.containsIgnoreCase('Year') && strForPlainText.containsIgnoreCase('Price') && strForPlainText.containsIgnoreCase('Comments')){
                
                //***First Template       
                objACES.attachingFieldsValueForFirstTemplate(strForPlainText);
                
            }else if(strForPlainText != null && strForPlainText.containsIgnoreCase('First Name') && strForPlainText.containsIgnoreCase('Last Name') && strForPlainText.containsIgnoreCase('Work Phone') 
                    && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Telephone') &&  strForPlainText.containsIgnoreCase('SourcePage') 
                        && strForPlainText.containsIgnoreCase('FormPage') && strForPlainText.containsIgnoreCase('NewsLetterOptIn') && strForPlainText.containsIgnoreCase('Comments')){
                
                //***Second Template                    
                objACES.attachingFieldsValueForSecondTemplate(strForPlainText);
                
            }else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Address') && strForPlainText.containsIgnoreCase('City') 
                    && strForPlainText.containsIgnoreCase('State') && strForPlainText.containsIgnoreCase('Zip') &&  strForPlainText.containsIgnoreCase('Phone') 
                        && strForPlainText.containsIgnoreCase('Fax') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Catalog')){
                
                //***Third Template                     
                objACES.attachingFieldsValueForThirdTemplate(strForPlainText);
                
            } else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Boat') &&
                    strForPlainText.containsIgnoreCase('Name') &&
                    strForPlainText.containsIgnoreCase('Email')  &&
                    strForPlainText.containsIgnoreCase('Phone Number') &&
                    strForPlainText.containsIgnoreCase('Message')){
                
                //***Eight Template -- OnlyInboards.com                    
                objACES.attachingFieldsValueForEightTemplate(strForPlainText);
            
            } else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') &&
                    strForPlainText.containsIgnoreCase('Zip') && strForPlainText.containsIgnoreCase('Phone') &&
                    strForPlainText.containsIgnoreCase('Year') && strForPlainText.containsIgnoreCase('Price') &&
                    strForPlainText.containsIgnoreCase('Comments')){
                
                //***Ninth Template --- BoatTrader.Com
                objACES.attachingFieldsValueForNinthTemplate(strForPlainText);
                
            }else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Request Type') && strForPlainText.containsIgnoreCase('Source')  &&  strForPlainText.containsIgnoreCase('Date/Time') 
                        && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email') && strForPlainText.containsIgnoreCase('Zip/PostalCode') 
                            && strForPlainText.containsIgnoreCase('Country') && strForPlainText.containsIgnoreCase('Phone')){
                
                //***Fifth Template                     
                objACES.attachingFieldsValueForFifthTemplate(strForPlainText);
                
            }else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Address') && strForPlainText.containsIgnoreCase('Name')  &&  strForPlainText.containsIgnoreCase('Email') 
                        && strForPlainText.containsIgnoreCase('Lead') && strForPlainText.containsIgnoreCase('Sale') && strForPlainText.containsIgnoreCase('Make') 
                            && strForPlainText.containsIgnoreCase('Model') && strForPlainText.containsIgnoreCase('Year')&& strForPlainText.containsIgnoreCase('IMT')
                                && strForPlainText.containsIgnoreCase('URI') && strForPlainText.containsIgnoreCase('Comments')){
                
                //***Sixth Template                     
                objACES.attachingFieldsValueForSixthTemplate(strForPlainText);
            }else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Lead Source') && strForPlainText.containsIgnoreCase('Name')  &&  strForPlainText.containsIgnoreCase('Email') 
                        && strForPlainText.containsIgnoreCase('Phone') && strForPlainText.containsIgnoreCase('Address 1') && strForPlainText.containsIgnoreCase('Address 2') 
                            && strForPlainText.containsIgnoreCase('City') && strForPlainText.containsIgnoreCase('State')&& strForPlainText.containsIgnoreCase('Postal Code')
                                && strForPlainText.containsIgnoreCase('Country') && strForPlainText.containsIgnoreCase('Configured Boat') && strForPlainText.containsIgnoreCase('Configured Boat URL')
                                    && strForPlainText.containsIgnoreCase('Comments')){
                
                //***Seventh Template
                objACES.attachingFieldsValueForSeventhTemplate(strForPlainText);
            } else if(strForPlainText != null && strForPlainText.containsIgnoreCase('Name') && strForPlainText.containsIgnoreCase('Email')  &&  strForPlainText.containsIgnoreCase('Phone') 
                        && strForPlainText.containsIgnoreCase('Message')){
                
                //***Fourth Template                     
                objACES.attachingFieldsValueForFourthTemplate(strForPlainText);
            
            }  
            
            
                objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
                objAccount.Name = objAccount.Name+'(Email-Lead)';
                System.debug('>>>: '+objAccount);
                insert objAccount; 
            
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
        }catch(Exception ex){
            System.debug('Please Do Correct \nMessage: '+ex.getMessage() +' \nLineNumber :  '+ex.getLineNumber()+' \nStack: '+ex.getStackTraceString()); 
            //SendEmailUtility.sendQuickEmail(ex.getMessage() +'  :  '+ex.getLineNumber()+'--:--'+ex.getStackTraceString());
            System_Configure__c objSC = System_Configure__c.getOrgDefaults();
            if(objSC != null && objSC.Enable_Debug_Mails__c)  {
                BOATBUILDING__Custom_Log__c objCL = new BOATBUILDING__Custom_Log__c();
                objCL.Name = 'Email Service Log';
                objCL.BOATBUILDING__Summary__c = 'Please Do Correct \nMessage: '+ex.getMessage() +' \nLineNumber :  '+ex.getLineNumber()+' \nStack: '+ex.getStackTraceString();
                insert objCL;
             }
        }
        return result;

    }
}