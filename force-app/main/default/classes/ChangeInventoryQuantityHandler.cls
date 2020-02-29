public with sharing class ChangeInventoryQuantityHandler {
    public static void onUpdate(List<Invoice__c> lstInvoiceTriggerNew,List<Invoice__c> lstInvoiceTriggerOld){
        System.debug('Debug Log for lstInvoiceTriggerNew'+lstInvoiceTriggerNew.size());
        System.debug('Debug Log for lstInvoiceTriggerOld'+lstInvoiceTriggerOld.size());
        String strSoldBoatInvID = '';
        String strStandardInvID = '';
        String strRecordTypeInventory = '';
        Set<Id> setSoldBoatInvIDsNew = new Set<Id>();
        Set<Id> setStandardInvIDsNew = new Set<Id>();
        //Set<Id> setSoldBoatInvIDsOld = new Set<Id>();
        //Set<Id> setStandardInvIDsOld = new Set<Id>();
        Map<String,Decimal> mapPartNametoPartNmbr = new Map<String,Decimal>();
        List<Invoice__c> lstSoldBoatInvCriteriaOld = new List<Invoice__c>();
        List<Invoice__c> lstStandardInvCriteriaOld = new List<Invoice__c>();
    
        List<RecordType> lstSoldBoatInvoice = [SELECT 
                                                        Id 
                                               FROM 
                                                        RecordType 
                                               WHERE 
                                                        SobjectType = 'BOATBUILDING__Invoice__c' 
                                               AND 
                                                        DeveloperName = 'Sold_Boat_Invoice'

                                                        limit 1];
        List<RecordType> lstStandardInvoice = [SELECT 
                                                        Id 
                                               FROM 
                                                        RecordType 
                                               WHERE 
                                                        SobjectType = 'BOATBUILDING__Invoice__c' 
                                               AND 
                                                        DeveloperName = 'Standard_Invoice'

                                                        limit 1];
        List<RecordType> lstInventoryRT = [SELECT           
                                                    Id
                                            FROM    
                                                    RecordType
                                            WHERE       
                                                    DeveloperName = 'Inventory_for_Parts'
                                            AND
                                                    SobjectType = 'BOATBUILDING__Inventory__c'
                                            LIMIT 
                                                    1];
        if(lstSoldBoatInvoice.size() > 0){
            strSoldBoatInvID = lstSoldBoatInvoice[0].Id;
        }

        if(lstStandardInvoice.size() > 0){
            strStandardInvID = lstStandardInvoice[0].Id;
        }

        if(lstInventoryRT.size() > 0){
            strRecordTypeInventory = lstInventoryRT[0].Id;
        }
        
        
        for(Invoice__c objInvoiceNew : lstInvoiceTriggerNew){
            if(objInvoiceNew.RecordTypeId == strSoldBoatInvID){
                setSoldBoatInvIDsNew.add(objInvoiceNew.Id);
            }
            else if(objInvoiceNew.RecordTypeId == strStandardInvID){
                setStandardInvIDsNew.add(objInvoiceNew.Id);
            }
        }
        
        for(Invoice__c objInvoiceOld : lstInvoiceTriggerOld){
            if(objInvoiceOld.RecordTypeId == strSoldBoatInvID){
                lstSoldBoatInvCriteriaOld.add(objInvoiceOld);
            }
            else if(objInvoiceOld.RecordTypeId == strStandardInvID){
                lstStandardInvCriteriaOld.add(objInvoiceOld);
            }
        }
        
        List<Invoice__c> lstSoldBoatInvCriteriaNew = [SELECT 
                                                                Inventory__c,
                                                                Inventory__r.Quantity__c,
                                                                Related_to_Product__c,
                                                                Invoice_Status__c
                                                       FROM 
                                                                Invoice__c
                                                       WHERE
                                                                RecordTypeId =: strSoldBoatInvID
                                                       AND
                                                                Id IN : setSoldBoatInvIDsNew
                                                                ];
        System.debug('Debug Log for lstSoldBoatInvCriteriaNew'+lstSoldBoatInvCriteriaNew.size());
        System.debug('Debug Log for lstSoldBoatInvCriteriaOld'+lstSoldBoatInvCriteriaOld.size());
        
        List<Invoice__c> lstStandardInvCriteriaNew = [SELECT
                                                                Id,
                                                                Name,
                                                                Invoice_Status__c,
                                                                                    (SELECT
                                                                                            Id,
                                                                                            Name,
                                                                                            Part_Vendor__c,
                                                                                            Part_Number__c,
                                                                                            Part_Cost__c,
                                                                                            Quantity__c,
                                                                                            Refunded__c,
                                                                                            Refunded_Amount__c
                                                                                    FROM
                                                                                            Invoice_Line_Items__r
                                                                                    )
                                                        FROM
                                                                Invoice__c
                                                        WHERE
                                                                RecordTypeId =: strStandardInvID
                                                        AND
                                                                Id IN : setStandardInvIDsNew
                                                        ];
            
        System.debug('Debug Log for lstStandardInvCriteriaNew'+lstStandardInvCriteriaNew.size());
        System.debug('Debug Log for lstStandardInvCriteriaOld'+lstStandardInvCriteriaOld.size());
        
        Map<String,String> mapSldBtInvIdtoStatus = new Map<String,String>();
        
        for(Invoice__c oldSldBtInvoice : lstSoldBoatInvCriteriaOld){
            mapSldBtInvIdtoStatus.put(oldSldBtInvoice.Id,oldSldBtInvoice.Invoice_Status__c);
        }
        System.debug('Debug Log for mapSldBtInvIdtoStatus'+mapSldBtInvIdtoStatus);
        List<Inventory__c> lstForUpdatingSoldBtInv = new List<Inventory__c>();
        
        if(lstSoldBoatInvCriteriaNew.size() > 0){
            for(Invoice__c objSoldBtInv : lstSoldBoatInvCriteriaNew){
                if(mapSldBtInvIdtoStatus.containsKey(objSoldBtInv.Id) && mapSldBtInvIdtoStatus.get(objSoldBtInv.Id) != objSoldBtInv.Invoice_Status__c){
                    if(objSoldBtInv.Invoice_Status__c == 'Active' && objSoldBtInv.Inventory__r.Quantity__c != null){
                        objSoldBtInv.Inventory__r.Quantity__c -= 1;
                        lstForUpdatingSoldBtInv.add(objSoldBtInv.Inventory__r);
                    }
                    else if(objSoldBtInv.Invoice_Status__c == 'Cancelled' && objSoldBtInv.Inventory__r.Quantity__c != null){
                        objSoldBtInv.Inventory__r.Quantity__c += 1;
                        lstForUpdatingSoldBtInv.add(objSoldBtInv.Inventory__r);
                    }
                }
            }
            update lstForUpdatingSoldBtInv;
        }
        
        
        Map<String,String> mapStndrdInvIdtoStatus = new Map<String,String>();
        Map<String,String> mapILIPartNotoInvStatusNew = new Map<String,String>();
        
        for(Invoice__c oldStndrdInvoice : lstStandardInvCriteriaOld){
            mapStndrdInvIdtoStatus.put(oldStndrdInvoice.Id,oldStndrdInvoice.Invoice_Status__c);
        }
        System.debug('Debug Log for mapStndrdInvIdtoStatus'+mapStndrdInvIdtoStatus);
        //List<Inventory__c> lstForUpdatingSoldBtInv = new List<Inventory__c>();
        
        if(lstStandardInvCriteriaNew.size() > 0){
            for(Invoice__c objStndrdInv : lstStandardInvCriteriaNew){
                if(mapStndrdInvIdtoStatus.containsKey(objStndrdInv.Id) && mapStndrdInvIdtoStatus.get(objStndrdInv.Id) != objStndrdInv.Invoice_Status__c){
                    if(objStndrdInv.Invoice_Line_Items__r.size()>0) {
                        for(Invoice_Line_Item__c objILI : objStndrdInv.Invoice_Line_Items__r) {
                            mapPartNametoPartNmbr.put(objILI.Part_Number__c,objILI.Quantity__c);
                            mapILIPartNotoInvStatusNew.put(objILI.Part_Number__c,objStndrdInv.Invoice_Status__c);
                        }
                    }
                }
                
            }
            
            List<Inventory__c> lstCriteriaInvRecords =  [SELECT  
                                                                Name, 
                                                                Vendor__c, 
                                                                Vendor__r.Name, 
                                                                Part_Number__c, 
                                                                Description__c, 
                                                                Category__c, 
                                                                Map_Price__c, 
                                                                Discount__c, 
                                                                Family__c, 
                                                                Size__c, 
                                                                Color__c, 
                                                                Cost__c,
                                                                Minimum_Amount__c, 
                                                                Part_Location__c, 
                                                                Part_MSRP_Price__c, 
                                                                Part_Name__c, 
                                                                Quantity__c,  
                                                                (Select Id, Quantity__c From BOATBUILDING__Parts_Availability__r)//onit
                                                         FROM  
                                                                Inventory__c  
                                                         WHERE 
                                                                RecordTypeId =: strRecordTypeInventory 
                                                         AND
                                                                Part_Number__c IN : mapPartNametoPartNmbr.keySet()
                                                                ];
            List<BOATBUILDING__Parts_Availability__c> lstPA = new List<BOATBUILDING__Parts_Availability__c>();
            List<Inventory__c> lstInvUpdate = new List<Inventory__c>();
            if(lstCriteriaInvRecords.size() > 0){
            	Map<String, Integer> mapPartId = new Map<String, Integer>();
                for(Inventory__c objInvforPart : lstCriteriaInvRecords){
                      
                    if(mapPartNametoPartNmbr.containsKey(objInvforPart.Part_Number__c) && mapILIPartNotoInvStatusNew.get(objInvforPart.Part_Number__c) == 'Final'){
                        if(mapPartNametoPartNmbr.get(objInvforPart.Part_Number__c) != null){
                        	if(objInvforPart.BOATBUILDING__Parts_Availability__r.isEmpty()) {
                            	objInvforPart.Quantity__c -= mapPartNametoPartNmbr.get(objInvforPart.Part_Number__c);
                            	lstInvUpdate.add(objInvforPart);
                        	} else {
                        		objInvforPart.BOATBUILDING__Parts_Availability__r[0].Quantity__c -= mapPartNametoPartNmbr.get(objInvforPart.Part_Number__c);
                        		lstPA.add(objInvforPart.BOATBUILDING__Parts_Availability__r[0]);
                        	}
                        	mapPartId.put(objInvforPart.Part_Number__c, Integer.valueOf(mapPartNametoPartNmbr.get(objInvforPart.Part_Number__c)));
                        }
                    }
                }
                if(!lstInvUpdate.isEmpty())
                	update lstInvUpdate;
                if(!lstPA.isEmpty())
                	update lstPA;
                	
                if(!mapPartId.isEmpty()) {
                	System.debug('>>>>>>mapPartId: '+mapPartId);
                	List<Part__c> lstPrt = [Select Id, Part__c, BOATBUILDING__Part_Number__c, Quantity__c From Part__c Where Part_Number__c IN: mapPartId.keySet()];
                	Set<String> srtPrtIdUpdate = new Set<String>();
                	for(Part__c objPrt: lstPrt) {
                		if(objPrt.Quantity__c != null) {
                			objPrt.Quantity__c -= mapPartId.get(objPrt.Part_Number__c);
                		} else {
                			objPrt.Quantity__c = 0 - mapPartId.get(objPrt.Part_Number__c);
                		}
                		
                		if(objPrt.Part__c != null && !srtPrtIdUpdate.contains(objPrt.Part__c)) 
                		{
                			srtPrtIdUpdate.add(objPrt.Part__c);
                		} 
                		else if(srtPrtIdUpdate.contains(objPrt.Id))
                		{
                			srtPrtIdUpdate.add(objPrt.Id);
                		}
                	}
                	System.debug('>>>>>>lstPrt: '+lstPrt);
                	update lstPrt;
                	System.debug('>>>>>>srtPrtIdUpdate: '+srtPrtIdUpdate);
                	for(String strPrtId: srtPrtIdUpdate) {//WooCommerce_Connect
                		WooCommerceQuntityUpdate.savePartsToWooCommerce(strPrtId);
                	} 
                }
                
            }
        }
    }
}