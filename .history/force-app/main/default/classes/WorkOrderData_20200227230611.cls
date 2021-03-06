public class WorkOrderData {
	public String Id;
	public Boolean isDelete;
	public String tempUniqueId;
	public String workOrderId;
	public String technicianId;
	public Boolean isApprovedByCustomer;
	public Boolean isJobTaxable;
	public String discontOnJob;
	public String ShippingCharges;
	public String jobName;
	public String WorkType;
	public String numberOfLabor;
	
	public String laborMuliplier;
	public String RecordTypeName;
	public String claimStatus;
	public String claimApprovalDate;
	public String claimDate;
	public String claimPaidDate;
	public String claimLaborPaidAmount;
	public String claimPartsPaidAmount;
	public String claimMiscChargesPaid;
	public String claimLaborApprovedAmount;
	public String claimReturnPartsAmount;
	public Integer claimTotalPaidAmount;
	public Double PartsTotal;
	public String miscDesc1;
	public Double miscCharge1;
	public String miscDesc2;
	public Double miscCharge2;
	public String miscDesc3;
	public Double miscCharge3;
	public String customerComment;
	public String serviceWriterComment;
	public List<LstJobLineItems> lstJobLineItems;
	public String shopSupplies;
	public String taxOnJob;
	public String jobTotalwTax;

	public class LstJobLineItems {
		public String tempUniqueIdFromJob;
		public String partNumber;
		public String partName;
		public Boolean isDelete;
		public String lineItemId;
		public Double retailPrice;
		public Integer qunatity;
		public Double cost;
		public String inventoryId;
		public String partId;
	}

	
	
	public static List<WorkOrderData> parse(String json) {
		return (List<WorkOrderData>) System.JSON.deserialize(json, List<WorkOrderData>.class);
	}

}