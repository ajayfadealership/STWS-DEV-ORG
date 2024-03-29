public with sharing class BoatBuilderUtil {
    
    private Decimal RegularSalestax = 0.00;
    private Decimal VehicleSalestax = 0.00;
    private Decimal CappingAmountForVehicleSalesTax = 0.00;
    
    private Boolean LaborTax = false;
    private Boolean PartsTax = false;
    private Boolean SSTax = false;
    private Boolean MISCTax = false;
	private Boolean docFeeTaxable = false;
    private Boolean boatRegFeeTaxable = false;
    private Boolean TradeAllowanceTaxable = false;
    
    private Decimal GST = 0.00;
    private Decimal PST = 0.00;
    private Boolean isCanadianTax = false;
    public BoatBuilderUtil(String strStateName) {
        
        Map<String, BOATBUILDING__SalesTaxConfiguration__c> objSTC = BOATBUILDING__SalesTaxConfiguration__c.getAll();
        
        for(String strStateNameKey: objSTC.keySet()) {
            if(strStateNameKey.equalsIgnoreCase(strStateName)) {
                if(objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c != null) {
                    RegularSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c;
                }
                if(objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c != null) {
                    VehicleSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c;
                }
                if(objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c != null) {
                    CappingAmountForVehicleSalesTax = objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c;
                }
                LaborTax = objSTC.get(strStateNameKey).BOATBUILDING__Labor_Tax__c;
                PartsTax = objSTC.get(strStateNameKey).BOATBUILDING__Part_Tax__c;
                SSTax = objSTC.get(strStateNameKey).BOATBUILDING__Shop_Supplies_Tax__c;
                MISCTax = objSTC.get(strStateNameKey).BOATBUILDING__Misc_Tax__c;
                docFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Doc_Fee_Taxable__c;
                boatRegFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Reg_Fee_Taxable__c;
  				TradeAllowanceTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Quote_Trade_Allowance_Taxable__c;           
                GST = objSTC.get(strStateNameKey).BOATBUILDING__GST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__GST__c : 0.00;
                PST = objSTC.get(strStateNameKey).BOATBUILDING__PST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__PST__c : 0.00;
                isCanadianTax = objSTC.get(strStateNameKey).BOATBUILDING__Canadian_Tax__c;
                break;
            }
        }
    }
    public BoatBuilderUtil(String strStateName, String InvRecTypeId) {
        String InvWebRecTypeId = Schema.SObjectType.BOATBUILDING__Invoice__c.getRecordTypeInfosByName().get('Web Invoices').getRecordTypeId(); 

        Map<String, BOATBUILDING__SalesTaxConfiguration__c> objSTC = BOATBUILDING__SalesTaxConfiguration__c.getAll();
        
        for(String strStateNameKey: objSTC.keySet()) {
            if(strStateNameKey.equalsIgnoreCase(strStateName)) {
                if(InvWebRecTypeId == InvRecTypeId) {
                    if(objSTC.get(strStateNameKey).BOATBUILDING__Web_Invoice_Taxable__c) {
                        if(objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c != null) {
                            RegularSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c;
                        }
                        if(objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c != null) {
                            VehicleSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c;
                        }
                        if(objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c != null) {
                            CappingAmountForVehicleSalesTax = objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c;
                        }
                        LaborTax = objSTC.get(strStateNameKey).BOATBUILDING__Labor_Tax__c;
                        PartsTax = objSTC.get(strStateNameKey).BOATBUILDING__Part_Tax__c;
                        SSTax = objSTC.get(strStateNameKey).BOATBUILDING__Shop_Supplies_Tax__c;
                        MISCTax = objSTC.get(strStateNameKey).BOATBUILDING__Misc_Tax__c;
                        docFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Doc_Fee_Taxable__c;
                        boatRegFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Reg_Fee_Taxable__c;
                        TradeAllowanceTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Quote_Trade_Allowance_Taxable__c;           
                        GST = objSTC.get(strStateNameKey).BOATBUILDING__GST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__GST__c : 0.00;
                        PST = objSTC.get(strStateNameKey).BOATBUILDING__PST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__PST__c : 0.00;
                        isCanadianTax = objSTC.get(strStateNameKey).BOATBUILDING__Canadian_Tax__c;
                        break;
                    } 
                } else {
                    if(objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c != null) {
                        RegularSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Regular_Sales_Tax__c;
                    }
                    if(objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c != null) {
                        VehicleSalestax = objSTC.get(strStateNameKey).BOATBUILDING__Vehicle_Sales_Tax__c;
                    }
                    if(objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c != null) {
                        CappingAmountForVehicleSalesTax = objSTC.get(strStateNameKey).BOATBUILDING__Tax_Capping_Amount__c;
                    }
                    LaborTax = objSTC.get(strStateNameKey).BOATBUILDING__Labor_Tax__c;
                    PartsTax = objSTC.get(strStateNameKey).BOATBUILDING__Part_Tax__c;
                    SSTax = objSTC.get(strStateNameKey).BOATBUILDING__Shop_Supplies_Tax__c;
                    MISCTax = objSTC.get(strStateNameKey).BOATBUILDING__Misc_Tax__c;
                    docFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Doc_Fee_Taxable__c;
                    boatRegFeeTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Reg_Fee_Taxable__c;
                    TradeAllowanceTaxable = objSTC.get(strStateNameKey).BOATBUILDING__Quote_Trade_Allowance_Taxable__c;           
                    GST = objSTC.get(strStateNameKey).BOATBUILDING__GST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__GST__c : 0.00;
                    PST = objSTC.get(strStateNameKey).BOATBUILDING__PST__c != null ? objSTC.get(strStateNameKey).BOATBUILDING__PST__c : 0.00;
                    isCanadianTax = objSTC.get(strStateNameKey).BOATBUILDING__Canadian_Tax__c;
                    System.debug('GST: '+GST);
                    System.debug('PST: '+PST);
                    break;
                }
            }
        }
    }
    
    public Decimal getRegularSalestax() {
        return RegularSalestax;
    }
    
    public Decimal getVehicleSalestax() {
        return VehicleSalestax; 
    }
    
    public Decimal getCappingAmountForVehicleSalesTax() {
        return CappingAmountForVehicleSalesTax;
    }
    
    public Boolean getLaborTax() {
        return LaborTax;
    }
    public Boolean getPartsTax() {
        return PartsTax;
    }
    public Boolean getSSTax() {
        return SSTax; 
    }
    public Boolean getMISCTax() {
        return MISCTax; 
    }
    public Boolean getdocFeeTaxable() {
        return docFeeTaxable; 
    }
    public Boolean getboatRegFeeTaxable() {
        return boatRegFeeTaxable; 
    }
    public Boolean getboatTradeAllowanceTaxable(){
        return TradeAllowanceTaxable;
    }

    public Boolean isCanadianTax() {
        return isCanadianTax;
    }

    public Decimal calculateCanadianTax(Decimal decPrice) {
		Decimal gstSalesTax = 0.00;
        Decimal pstSalesTax = 0.00; 
        if(GST != null) {
        	gstSalesTax = (decPrice * GST)/100;
        }
        if(PST != null) {
	        pstSalesTax = (decPrice * PST)/100;
        }
        Decimal totalCanadianTax = gstSalesTax + pstSalesTax;
        return totalCanadianTax; 
    }

    public Decimal getGST() {
        return GST; 
    }
    public Decimal getPST() {
        return PST; 
    }
}