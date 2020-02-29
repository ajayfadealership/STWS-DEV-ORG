/**
 * Author:              Akshay Kumar
 * Organization:        360 Degree Cloud Technologies Pvt. Ltd.
 * Created Date:        20/02/2017
 * Last Modified Date:  27/02/2017
 */
public with sharing class NewJobCreationController {
    public Case objCase { get; set; }
    public BOATBUILDING__Job__c objJob { get; set; }
    
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
    
    public NewJobCreationController() {
        allAssignment();
    }
    
    private void allAssignment() {
        strSelectedWorkType = '';
        strSelectedRecordType = '';
        strCannedJob = '';
        isWrranty = false;
        objJob = new BOATBUILDING__Job__c();
        if(ApexPages.currentPage().getParameters().get('Id') != null) {
            String strCaseId = ApexPages.currentPage().getParameters().get('Id');
            objCase = [Select Id, CaseNumber, RecordTypeId From Case Where Id =: strCaseId Limit 1];
            objJob.Work_Request__c = objCase.Id;
            if(objCase.RecordTypeId != null) {
                caseRecordTypeCheck(objCase.RecordTypeId);
            }
        }
        else {
            objCase = new Case();
        }
        lstCaseRecordType = new List<SelectOption>();
        List<RecordType> lstRec = [Select Id, Name From RecordType Where SobjectType = 'BOATBUILDING__Job__c' ];
        if(lstRec.size() > 0) {
            lstCaseRecordType.add(new SelectOption('0', '--None--'));
            for(RecordType objRC: lstRec) {
                lstCaseRecordType.add(new SelectOption(String.valueof(objRC.Id), objRC.Name));
            }
        }
    }
    public void caseRecordTypeCheck(String srtRecordTypeId) {
        String strRecordTypeName = [Select Id, DeveloperName From RecordType Where Id =: srtRecordTypeId Limit 1].DeveloperName;
        if(strRecordTypeName == 'Warranty_Work_Order') {
            isWrranty = true;
        }
        else {
            isWrranty = false;
        }
    }
    
    public List<SelectOption> getLstWorkType() {
        List<SelectOption> lstSelectOption = new List<SelectOption>();
        lstSelectOption.add(new SelectOption('0', '--None--'));
        for(BOATBUILDING__WorkTypePricing__c objWTP: [Select Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c ORDER BY Name ASC]) {
            lstSelectOption.add(new SelectOption((String)objWTP.Id, objWTP.Name));  
        }
        return lstSelectOption;
    }
    
    public List<SelectOption> getlstCannedJob() {
        List<SelectOption> lstSelectOption = new List<SelectOption>();
        List<BOATBUILDING__Canned_Job__c>  lstCannedJob= [Select Id, Name From BOATBUILDING__Canned_Job__c ORDER BY Name ASC];
        lstSelectOption.add(new SelectOption('0', '--None--'));
        for(BOATBUILDING__Canned_Job__c objCannedJob: lstCannedJob) {
            lstSelectOption.add(new SelectOption((String)objCannedJob.Id, objCannedJob.Name));  
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
        List<RecordType> lstRC = [Select Id From RecordType Where SobjectType = 'BOATBUILDING__Job__c' AND DeveloperName = 'Custom_Jobs'];
        BOATBUILDING__WorkTypePricing__c objWTP = [Select Id, Name, Price__c From BOATBUILDING__WorkTypePricing__c Where Id =: mapJobData.get('wrkType') LIMIT 1];
        if(lstRC.size() > 0) {
            BOATBUILDING__Job__c objJob = new BOATBUILDING__Job__c();
            objJob.Work_Request__c = mapJobData.get('relatedJob');
            objJob.Job_Name__c = mapJobData.get('jobName');
            objJob.RecordTypeId = lstRC[0].Id;
            System.debug('Debug log for Approval: '+mapJobData.get('isApproved'));
            objJob.Approved_By_Customer__c = String.valueOf(mapJobData.get('isApproved')) == 'true'? true: false;
            objJob.Work_Requested__c = mapJobData.get('wrkRequested');
            objJob.Work_Type__c = objWTP.Name;
            objJob.Price_per_Labor__c = objWTP.Price__c;
            objJob.Type__c = mapJobData.get('type');
            objJob.No_of_Labors__c = Decimal.valueOf(mapJobData.get('laborNo'));
            objJob.Discount__c = mapJobData.get('discount') != '' ? Decimal.valueOf(mapJobData.get('discount')) : 0.00;
            objJob.Claim_Status__c = mapJobData.get('claimStatus');
            objJob.Claim_Date__c = mapJobData.get('claimDate') != ''? convertStringIntoDate(mapJobData.get('claimDate')): null;
            objJob.Claim_Approval_Date__c = mapJobData.get('claimApprovalDate') != ''? convertStringIntoDate(mapJobData.get('claimApprovalDate')): null;
            objJob.Claim_Labor_Paid_Amount__c = mapJobData.get('claimLaborPaidAmount') != ''? Decimal.valueOf(mapJobData.get('claimLaborPaidAmount')): 0.00;
            objJob.Claim_Labor_Approved_Amount__c = mapJobData.get('claimLaborApprovedAmount') != ''? Decimal.valueOf(mapJobData.get('claimLaborApprovedAmount')): 0.00;
            objJob.Return_Parts_Amount__c = mapJobData.get('returnPartAmount') != ''? Decimal.valueOf(mapJobData.get('returnPartAmount')): 0.00;
            objJob.Claim_Paid_Date__c = mapJobData.get('claimPaidDate') != ''? convertStringIntoDate(mapJobData.get('claimPaidDate')): null;
            objJob.Parts_Paid_Amount__c = mapJobData.get('partPaidAmt') != ''? Decimal.valueOf(mapJobData.get('partPaidAmt')): 0.00;
            
            try{
                insert objJob;
            }catch(Exception ex) {
                System.debug('Debug log for Exception: '+ex);
                return null;
            }
            if(mapJobQuantityData.keySet().size() > 0 ) {
                Set<String> setPrtNum = new Set<String>();
                List<Job_Line_Item__c> lstJLI = new List<Job_Line_Item__c>(); 
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
                            Job_Line_Item__c objJLI = new Job_Line_Item__c();
                            objJLI.Part_Name__c = objInv.Part_Name__c;
                            objJLI.Part_Number__c = objInv.Part_Number__c;
                            objJLI.Quantity__c = Decimal.valueOf(mapJobQuantityData.get(objInv.Part_Number__c));
                            objJLI.Price__c = objInv.Part_MSRP_Price__c;
                            objJLI.Related_to_Job__c = objJob.Id;
                            lstJLI.add(objJLI);
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
                            Job_Line_Item__c objJLI = new Job_Line_Item__c();
                            objJLI.Part_Name__c = objPrt.Name;
                            objJLI.Part_Number__c = objPrt.Part_Number__c;
                            objJLI.Quantity__c = Decimal.valueOf(mapJobQuantityData.get(objPrt.Part_Number__c));
                            objJLI.Price__c = objPrt.Retail_Price__c;
                            objJLI.Related_to_Job__c = objJob.Id;
                            lstJLI.add(objJLI);
                        }                       
                    }
                    if(lstJLI.size() > 0) {
                        try {
                            insert lstJLI;
                        }
                        catch(Exception ex) {
                            System.debug('Debug Log For Exception : '+ex);
                            return null;
                        }
                    }
                }
            } 
            return 'SUCCESS';
        }
        return null;
    }
    
    @RemoteAction
    public static List<BOATBUILDING__Canned_Job__c> findCannedJob(String cJId) {
        List<BOATBUILDING__Canned_Job__c> lstCndJob = new List<BOATBUILDING__Canned_Job__c>();
        lstCndJob = [Select Id, Name,Discount__c, Work_Requested__c, No_of_Labors__c, Price_per_Labor__c, Shop_Supplies__c, Total_Cost_Labor__c, Lake_Call__c, Work_Type__c From BOATBUILDING__Canned_Job__c Where Id =: cJId Limit 1];
        
        
        List<BOATBUILDING__WorkTypePricing__c> lstWTP = [Select Id, Name From BOATBUILDING__WorkTypePricing__c Where Name =: lstCndJob[0].Work_Type__c Limit 1];
        
        if(lstWTP.size() > 0) {
            lstCndJob[0].Work_Type__c = lstWTP[0].Id;
        }
        
        return lstCndJob;
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