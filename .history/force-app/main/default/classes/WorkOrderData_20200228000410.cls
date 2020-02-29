public class WorkOrderData {
	@AuraEnabled
	public String Id;
	@AuraEnabled
	public Boolean isDelete;
	@AuraEnabled
	public String tempUniqueId;
	@AuraEnabled
	public String workOrderId;
	@AuraEnabled
	public String technicianId;
	@AuraEnabled
	public Boolean isApprovedByCustomer;
	@AuraEnabled
	public Boolean isJobTaxable;
	@AuraEnabled
	public String discontOnJob;
	@AuraEnabled
	public String ShippingCharges;
	@AuraEnabled
	public String jobName;
	@AuraEnabled
	public String WorkType;
	@AuraEnabled
	public String numberOfLabor;
	@AuraEnabled
	public String totalAmountOnJob;
	@AuraEnabled
	public String laborMuliplier;
	@AuraEnabled
	public String RecordTypeName;
	@AuraEnabled
	public String claimStatus;
	@AuraEnabled
	public String claimApprovalDate;
	@AuraEnabled
	public String claimDate;
	@AuraEnabled
	public String claimPaidDate;
	@AuraEnabled
	public String claimLaborPaidAmount;
	@AuraEnabled
	public String claimPartsPaidAmount;
	@AuraEnabled
	public String claimMiscChargesPaid;
	@AuraEnabled
	public String claimLaborApprovedAmount;
	@AuraEnabled
	public String claimReturnPartsAmount;
	@AuraEnabled
	public Integer claimTotalPaidAmount;
	@AuraEnabled
	public Double PartsTotal;
	@AuraEnabled
	public String miscDesc1;
	@AuraEnabled
	public Double miscCharge1;
	@AuraEnabled
	public String miscDesc2;
	@AuraEnabled
	public Double miscCharge2;
	@AuraEnabled
	public String miscDesc3;
	@AuraEnabled
	public Double miscCharge3;
	@AuraEnabled
	public String customerComment;
	@AuraEnabled
	public String serviceWriterComment;
	@AuraEnabled
	public List<LstJobLineItems> lstJobLineItems;
	@AuraEnabled
	public String shopSupplies;
	@AuraEnabled
	public String taxOnJob;
	@AuraEnabled
	public String jobTotalwTax;

	public class LstJobLineItems {
		@AuraEnabled
		public String tempUniqueIdFromJob;
		@AuraEnabled
		public String partNumber;
		@AuraEnabled
		public String partName;
		@AuraEnabled
		public Boolean isDelete;
		@AuraEnabled
		public String lineItemId;
		@AuraEnabled
		public Double retailPrice;
		@AuraEnabled
		public Integer qunatity;
		@AuraEnabled
		public Double cost;
		@AuraEnabled
		public String inventoryId;
		@AuraEnabled
		public String partId;
	}

	
	@AuraEnabled
	public static List<WorkOrderData> parse(String json) {
		return (List<WorkOrderData>) System.JSON.deserialize(json, List<WorkOrderData>.class);
	}

}