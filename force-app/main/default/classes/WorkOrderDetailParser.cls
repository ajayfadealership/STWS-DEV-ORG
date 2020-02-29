public class WorkOrderDetailParser {

	public ObjWOJ objWOJ;
	public MapCannedJob mapCannedJob;

	public class ObjWOJ {
		public String Id;
		public String jobKey;
		public String BOATBUILDING_Work_Order_Warranty_Work_Order_c;
		public String BOATBUILDING_Technician_c;
		public Boolean BOATBUILDING_Approved_By_Customer_c;
		public Boolean BOATBUILDING_Taxable_c;
		public Decimal BOATBUILDING_Discount_c;
		public Decimal BOATBUILDING_Shipping_Charge_c;
		public String Name;
		public String BOATBUILDING_Job_Name_c;
		public String BOATBUILDING_Work_Type_c;
		public Decimal BOATBUILDING_No_of_Labors_c;
		public Decimal BOATBUILDING_Total_Amount_Job_c;
		public Decimal BOATBUILDING_Shop_Supplies_Total_c;
		public List<BOATBUILDING_Work_Order_Job_Line_Items_r> BOATBUILDING_Work_Order_Job_Line_Items_r;
		public Decimal laborPriceMultiplier;
		public Decimal partsTotal;
		public Decimal jobTotalwTax;
		public Decimal taxOnJob;
		public String BOATBUILDING_Misc_Description_1_c;
		public Decimal BOATBUILDING_Misc_Charge_c;
		public Decimal totalMiscCharges;
		public String BOATBUILDING_Customer_Comments_c;
		public String BOATBUILDING_Comments_c;
	}

	public class BOATBUILDING_Work_Order_Job_Line_Items_r {
		public String BOATBUILDING_Related_to_Job_c;
		public String Id;
		public String Name;
		public Decimal BOATBUILDING_Quantity_c;
		public Decimal BOATBUILDING_Price_c;
		public Decimal BOATBUILDING_Dealer_Price_c;
		public String BOATBUILDING_Part_Number_c;
	}

	public class MapCannedJob {
	}
	
	public static List<WorkOrderDetailParser> parse(String json) {
		return (List<WorkOrderDetailParser>) System.JSON.deserialize(json, List<WorkOrderDetailParser>.class);
	}
}