/**
 * Author:              Akshay Kumar
 * Organization:        CloudCodiots LLP.
 * Created Date:        20/02/2017
 * Last Modified Date:  20/03/2018
 */
public with sharing class NewCannedJobCreationController {

    public NewCannedJobCreationController(ApexPages.StandardController controller) {

    }
    public NewCannedJobCreationController(){}
    public BOATBUILDING__Work_Order_Job__c objCannedJob { get; set; }
     
    public List<SelectOption> lstCaseRecordType { get; set; }
    
    public String strSelectedRecordType { get; set; }
    public String strSelectedWorkType { get; set; }
    public Boolean isWrranty { get; set; } 
    public String strCannedJob { get; set; }
   
    //Access Check
    public PageReference checkAccess() {
        String strAccessKey = AccessControllCheck.ckeckAccess();
        
        if(!strAccessKey.containsIgnoreCase('Service')) {
            return new PageReference('/apex/ContactToYourAdministrator');
        }
        return null;
    } 
   
    
    
    public List<SelectOption> getLstWorkType() {
        List<SelectOption> lstSelectOption = new List<SelectOption>();
        lstSelectOption.add(new SelectOption('0', '--None--'));
        for(BOATBUILDING__WorkTypePricing__c objWTP: [Select Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]) {
            lstSelectOption.add(new SelectOption((String)objWTP.Id, objWTP.Name));  
        }
        return lstSelectOption;
    }
    
    @RemoteAction
    public static List<PartResultDiv> searchParts(String strPrtDetail) {
        
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
        
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        Set<String> setPrtNum = new Set<String>();
        String prtDetail = '%'+strPrtDetail+'%';  
        if(lstInventoryRT.size() > 0) {
            List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                        Id, 
                                                        Quantity__c, 
                                                        Part_Number__c, 
                                                        Part_Name__c, 
                                                        Part_MSRP_Price__c 
                                               From 
                                                        BOATBUILDING__Inventory__c 
                                               Where 
                                                        (Part_Number__c LIKE: prtDetail OR Part_Name__c LIKE: prtDetail) AND RecordTypeId =: lstInventoryRT[0].Id];
            
            if(lstInventory.size() > 0) {
                for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                    lstPartResultDiv.add(new PartResultDiv(objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                    setPrtNum.add(objInv.Part_Number__c);
                }
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
		                                        Part_Number__c, 
		                                        Name, 
		                                        Retail_Price__c, 
		                                        Id 
		                                From 
		                                        BOATBUILDING__Part__c 
		                                Where 
		                                        (Part_Number__c LIKE: prtDetail OR Name LIKE: prtDetail) AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c));
            }                       
        }   
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    }
    
    @RemoteAction
    public static List<PartResultDiv> getFinalList(List<String> lstPartNum) {
        List<PartResultDiv> lstPartResultDiv = new List<PartResultDiv>();
        System.debug('Debug Log For List: '+lstPartNum);
        Set<String> setPrtNum = new Set<String>();
        List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                    Id, 
                                                    Quantity__c, 
                                                    Part_Number__c, 
                                                    Part_Name__c, 
                                                    Part_MSRP_Price__c 
                                           From 
                                                    BOATBUILDING__Inventory__c 
                                           Where 
                                                    Part_Number__c IN: lstPartNum];
        if(lstInventory.size() > 0) {
            for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                lstPartResultDiv.add(new PartResultDiv(objInv.Part_Number__c, objInv.Part_Name__c, Integer.valueOf(objInv.Quantity__c), objInv.Part_MSRP_Price__c));
                setPrtNum.add(objInv.Part_Number__c);
            }
        }
        List<BOATBUILDING__Part__c> lstPrt = [Select 
                                        Part_Number__c, 
                                        Name, 
                                        Retail_Price__c, 
                                        Id 
                                From 
                                        BOATBUILDING__Part__c 
                                Where 
                                        Part_Number__c IN: lstPartNum AND Part_Number__c NOT IN: setPrtNum];
        if(lstPrt.size() > 0) {                                     
            for(BOATBUILDING__Part__c objPrt: lstPrt) {
                lstPartResultDiv.add(new PartResultDiv(objPrt.Part_Number__c, objPrt.Name, 0, objPrt.Retail_Price__c));
            }                       
        }
        if(lstPartResultDiv.size() > 0) {
            return lstPartResultDiv;
        }   
        return null;
    }   
    
    private static Date convertStringIntoDate(String strDate) {
        Date objDate;
        String []strSplitedDate= strDate.split('/');
        Integer year = Integer.valueOf(strSplitedDate[2]);
        Integer month = Integer.valueOf(strSplitedDate[0]);
        Integer day = Integer.valueOf(strSplitedDate[1]);
        objDate = Date.newInstance(year, month, day);
        return objDate;
    } 
    
    @RemoteAction
    public static String createJob(Map<String, String> mapJobData, Map<String, String> mapJobQuantityData) {
        //List<RecordType> lstRC = [Select Id From RecordType Where SobjectType = 'Job__c' AND DeveloperName = 'Custom_Jobs']; 
        BOATBUILDING__WorkTypePricing__c objWTP = [Select Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c Where Id =: mapJobData.get('wrkType') LIMIT 1];
        Id wojId = Schema.SObjectType.BOATBUILDING__Work_Order_Job__c.getRecordTypeInfosByName().get('Canned Job').getRecordTypeId();
        BOATBUILDING__Work_Order_Job__c objCannedJob = new BOATBUILDING__Work_Order_Job__c();
        if(wojId != null) {
            objCannedJob.RecordTypeId = wojId;      
        }
        objCannedJob.Job_Name__c = mapJobData.get('jobName');
        objCannedJob.Work_Requested__c = mapJobData.get('wrkRequested');
        objCannedJob.Work_Type__c = objWTP.Name;
        objCannedJob.Price_per_Labor__c = objWTP.Price__c;
        objCannedJob.Type__c = mapJobData.get('type');
        if(mapJobData.get('MISC') != null) {
        		objCannedJob.Misc_Charge__c = Decimal.valueOf(mapJobData.get('MISC'));
        }
        if(mapJobData.get('MISC2') != null) {
        		objCannedJob.Misc_Charge_2__c = Decimal.valueOf(mapJobData.get('MISC2'));
        }
        if(mapJobData.get('MISC3') != null) {
        		objCannedJob.Misc_Charge_3__c = Decimal.valueOf(mapJobData.get('MISC3'));
        }
        
        if(mapJobData.get('MISCDesc1') != null) {
        		objCannedJob.Misc_Description_1__c = String.valueOf(mapJobData.get('MISCDesc1'));
        }
        if(mapJobData.get('MISCDesc2') != null) {
        		objCannedJob.Misc_Description_2__c = String.valueOf(mapJobData.get('MISCDesc2'));
        }
        if(mapJobData.get('MISCDesc3') != null) {
        		objCannedJob.Misc_Description_3__c = String.valueOf(mapJobData.get('MISCDesc3'));
        }
        if(mapJobData.get('Taxable') == '1') {
        		objCannedJob.Taxable__c = true;
        } else {
        		objCannedJob.Taxable__c = false;
        }
          
        objCannedJob.No_of_Labors__c = Decimal.valueOf(mapJobData.get('laborNo'));
        //objCannedJob.Hours_Allowed_On_Job__c = mapJobData.get('hrAllowed') != '' ? Decimal.valueOf(mapJobData.get('hrAllowed')) : 0.00;

        try{
            insert objCannedJob;
        }catch(Exception ex) {
            System.debug('Debug log for Exception: '+ex);
            return null;
        }
        if(mapJobQuantityData.keySet().size() > 0 ) {
            Set<String> setPrtNum = new Set<String>();
            List<BOATBUILDING__Work_Order_Job_Line_Item__c> lstCannedJLI = new List<BOATBUILDING__Work_Order_Job_Line_Item__c>(); 
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

            if(lstInventoryRT.size() > 0) {
                List<BOATBUILDING__Inventory__c> lstInventory = [Select 
                                                            Id, 
                                                            Quantity__c, 
                                                            Part_Number__c, 
                                                            Part_Name__c, 
                                                            Part_MSRP_Price__c 
                                                   From 
                                                            BOATBUILDING__Inventory__c 
                                                   Where 
                                                            Part_Number__c IN: mapJobQuantityData.keySet() AND RecordTypeId =: lstInventoryRT[0].Id];

                if(lstInventory.size() > 0) {
                    for(BOATBUILDING__Inventory__c objInv: lstInventory) {
                        BOATBUILDING__Work_Order_Job_Line_Item__c objCannedJLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                        objCannedJLI.Part_Name__c = objInv.Part_Name__c;
                        objCannedJLI.Part_Number__c = objInv.Part_Number__c;
                        objCannedJLI.Quantity__c = Decimal.valueOf(mapJobQuantityData.get(objInv.Part_Number__c));
                        objCannedJLI.Price__c = objInv.Part_MSRP_Price__c;
                        objCannedJLI.BOATBUILDING__Related_to_Job__c = objCannedJob.Id;
                        lstCannedJLI.add(objCannedJLI);
                        setPrtNum.add(objInv.Part_Number__c);
                    }
                } 
                List<BOATBUILDING__Part__c> lstPrt = [Select 
                                                Part_Number__c, 
                                                Name, 
                                                Retail_Price__c, 
                                                Id 
                                        From 
                                                BOATBUILDING__Part__c 
                                        Where 
                                                Part_Number__c IN: mapJobQuantityData.keySet() AND Part_Number__c NOT IN: setPrtNum];
                if(lstPrt.size() > 0) {                                     
                    for(BOATBUILDING__Part__c objPrt: lstPrt) {
                        BOATBUILDING__Work_Order_Job_Line_Item__c objCannedJLI = new BOATBUILDING__Work_Order_Job_Line_Item__c();
                        objCannedJLI.Part_Name__c = objPrt.Name;
                        objCannedJLI.Part_Number__c = objPrt.Part_Number__c;
                        objCannedJLI.Quantity__c = Decimal.valueOf(mapJobQuantityData.get(objPrt.Part_Number__c));
                        objCannedJLI.Price__c = objPrt.Retail_Price__c;
                        objCannedJLI.BOATBUILDING__Related_to_Job__c = objCannedJob.Id;
                        lstCannedJLI.add(objCannedJLI);
                    }                       
                }
                if(lstCannedJLI.size() > 0) {
                    try {
                        insert lstCannedJLI;
                    }
                    catch(Exception ex) {
                        System.debug('Debug Log For Exception : '+ex);
                        return null;
                    }
                }
            }
        } 
        return String.valueOf(objCannedJob.Id); 
    }
    
    
    public class PartResultDiv {
        public String PartNumber;
        public String PartName;
        public Integer Quantity;
        public Decimal MSRP;
        
        public PartResultDiv(String PartNumber, String PartName, Integer Quantity, Decimal MSRP) {
            this.PartNumber = PartNumber;
            this.PartName = PartName;
            this.Quantity = Quantity;
            this.MSRP = MSRP;
        }
    }
}