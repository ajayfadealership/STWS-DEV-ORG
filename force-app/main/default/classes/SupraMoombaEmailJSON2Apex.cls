public class SupraMoombaEmailJSON2Apex {
	
	public class RecordData {
		public String MapView {get;set;} 
		public String DealerDistanceMilesText {get;set;} 
		public String Id {get;set;} 
		public String CompanyExternalId {get;set;} 
		public String LeadUid {get;set;} 
		public String ProspectId {get;set;} 
		public String DealerId {get;set;} 
		public String ProductId {get;set;} 
		public String FollowUpStatusId {get;set;} 
		public String PurchaseStatusId {get;set;} 
		public String LeadTypeId {get;set;} 
		public String LeadCategoryId {get;set;} 
		public String LeadSourceId {get;set;} 
		public String LeadCampaignId {get;set;} 
		public String LeadDate {get;set;} 
		public String ViewedDate {get;set;} 
		public String Event {get;set;} 
		public String Medium {get;set;} 
		public String LeadScore {get;set;} 
		public String LeadScoreText {get;set;} 
		public String CreateDate {get;set;} 
		public String ProspectAggregationId {get;set;} 
		public String ProspectUid {get;set;} 
		public String LastName {get;set;} 
		public String FirstName {get;set;} 
		public String Address1 {get;set;} 
		public String Address2 {get;set;} 
		public String City {get;set;} 
		public String State {get;set;} 
		public String PostalCode {get;set;} 
		public String ZIP4 {get;set;} 
		public String Country {get;set;} 
		public String HomePhone {get;set;} 
		public String WorkPhone {get;set;} 
		public String MobilePhone {get;set;} 
		public String Email {get;set;} 
		public String ProspectScore {get;set;} 
		public String ProspectScoreText {get;set;} 
		public String SentDate {get;set;} 
		public String DealerName {get;set;} 
		public String DealerNumber {get;set;} 
		public String DealerEmail {get;set;} 
		public String DealerAddress1 {get;set;} 
		public String DealerAddress2 {get;set;} 
		public String DealerCity {get;set;} 
		public String DealerState {get;set;} 
		public String DealerPostalCode {get;set;} 
		public String DealerCountry {get;set;} 
		public String BrandId {get;set;} 
		public String BrandName {get;set;} 
		public String ProductName {get;set;} 
		public String Model {get;set;} 
		public String ModelYear {get;set;} 
		public String ProductCode {get;set;} 
		public String FollowUpStatusName {get;set;} 
		public String PurchaseStatusName {get;set;} 
		public String LeadTypeName {get;set;} 
		public String LeadSourceName {get;set;} 
		public String LeadCategoryName {get;set;} 
		public String LeadCampaignName {get;set;} 
		public String ProspectInterestId {get;set;} 
		public String ProspectInterestName {get;set;} 
		public String CompanyId {get;set;} 
		public String CompanyName {get;set;} 
		public String Field1 {get;set;} 
		public String Field2 {get;set;} 
		public String Field3 {get;set;} 
		public String Field4 {get;set;} 
		public String Field5 {get;set;} 
		public String Field6 {get;set;} 
		public String Field7 {get;set;} 
		public String Field8 {get;set;} 
		public String Field9 {get;set;} 
		public String Field10 {get;set;} 
		public String Field11 {get;set;} 
		public String Field12 {get;set;} 
		public String Field13 {get;set;} 
		public String Field14 {get;set;} 
		public String Field15 {get;set;} 
		public String Field16 {get;set;} 
		public String Field17 {get;set;} 
		public String Field18 {get;set;} 
		public String Field19 {get;set;} 
		public String Field20 {get;set;} 
		public String Field21 {get;set;} 
		public String Field22 {get;set;} 
		public String Field23 {get;set;} 
		public String Field24 {get;set;} 
		public String Field25 {get;set;} 
		public String Field26 {get;set;} 
		public String Field27 {get;set;} 
		public String Field28 {get;set;} 
		public String Field29 {get;set;} 
		public String Field30 {get;set;} 
		public String Field31 {get;set;} 
		public String Field32 {get;set;} 
		public String Field33 {get;set;} 
		public String Field34 {get;set;} 
		public String Field35 {get;set;} 
		public String Field36 {get;set;} 
		public String Field37 {get;set;} 
		public String Field38 {get;set;} 
		public String Field39 {get;set;} 
		public String Field40 {get;set;} 
		public String Field41 {get;set;} 
		public String Field42 {get;set;} 
		public String Field43 {get;set;} 
		public String Field44 {get;set;} 
		public String Field45 {get;set;} 
		public String Field46 {get;set;} 
		public String Field47 {get;set;} 
		public String Field48 {get;set;} 
		public String Field49 {get;set;} 
		public String Field50 {get;set;} 
		public String AuthenticatedAccountId {get;set;} 
		public String SentToDealer {get;set;} 
		public String Viewed {get;set;} 
		public String DealerDistance {get;set;} 
		public String DealerDistanceMiles {get;set;} 
		public String IsQualified {get;set;} 
		public String SicCode {get;set;} 
		public String CompanyTypeName {get;set;} 
		public String CompanyTypeId {get;set;} 
		public String County {get;set;} 
		public String EmailDeliverabilityStatusName {get;set;} 
		public String EmailDeliverabilityStatusId {get;set;} 
		public String SubscriberStatusName {get;set;} 
		public String SubscriberStatusId {get;set;} 

		public RecordData(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'MapView') {
							MapView = parser.getText();
						} else if (text == 'DealerDistanceMilesText') {
							DealerDistanceMilesText = parser.getText();
						} else if (text == 'Id') {
							Id = parser.getText();
						} else if (text == 'CompanyExternalId') {
							CompanyExternalId = parser.getText();
						} else if (text == 'LeadUid') {
							LeadUid = parser.getText();
						} else if (text == 'ProspectId') {
							ProspectId = parser.getText();
						} else if (text == 'DealerId') {
							DealerId = parser.getText();
						} else if (text == 'ProductId') {
							ProductId = parser.getText();
						} else if (text == 'FollowUpStatusId') {
							FollowUpStatusId = parser.getText();
						} else if (text == 'PurchaseStatusId') {
							PurchaseStatusId = parser.getText();
						} else if (text == 'LeadTypeId') {
							LeadTypeId = parser.getText();
						} else if (text == 'LeadCategoryId') {
							LeadCategoryId = parser.getText();
						} else if (text == 'LeadSourceId') {
							LeadSourceId = parser.getText();
						} else if (text == 'LeadCampaignId') {
							LeadCampaignId = parser.getText();
						} else if (text == 'LeadDate') {
							LeadDate = parser.getText();
						} else if (text == 'ViewedDate') {
							ViewedDate = parser.getText();
						} else if (text == 'Event') {
							Event = parser.getText();
						} else if (text == 'Medium') {
							Medium = parser.getText();
						} else if (text == 'LeadScore') {
							LeadScore = parser.getText();
						} else if (text == 'LeadScoreText') {
							LeadScoreText = parser.getText();
						} else if (text == 'CreateDate') {
							CreateDate = parser.getText();
						} else if (text == 'ProspectAggregationId') {
							ProspectAggregationId = parser.getText();
						} else if (text == 'ProspectUid') {
							ProspectUid = parser.getText();
						} else if (text == 'LastName') {
							LastName = parser.getText();
						} else if (text == 'FirstName') {
							FirstName = parser.getText();
						} else if (text == 'Address1') {
							Address1 = parser.getText();
						} else if (text == 'Address2') {
							Address2 = parser.getText();
						} else if (text == 'City') {
							City = parser.getText();
						} else if (text == 'State') {
							State = parser.getText();
						} else if (text == 'PostalCode') {
							PostalCode = parser.getText();
						} else if (text == 'ZIP4') {
							ZIP4 = parser.getText();
						} else if (text == 'Country') {
							Country = parser.getText();
						} else if (text == 'HomePhone') {
							HomePhone = parser.getText();
						} else if (text == 'WorkPhone') {
							WorkPhone = parser.getText();
						} else if (text == 'MobilePhone') {
							MobilePhone = parser.getText();
						} else if (text == 'Email') {
							Email = parser.getText();
						} else if (text == 'ProspectScore') {
							ProspectScore = parser.getText();
						} else if (text == 'ProspectScoreText') {
							ProspectScoreText = parser.getText();
						} else if (text == 'SentDate') {
							SentDate = parser.getText();
						} else if (text == 'DealerName') {
							DealerName = parser.getText();
						} else if (text == 'DealerNumber') {
							DealerNumber = parser.getText();
						} else if (text == 'DealerEmail') {
							DealerEmail = parser.getText();
						} else if (text == 'DealerAddress1') {
							DealerAddress1 = parser.getText();
						} else if (text == 'DealerAddress2') {
							DealerAddress2 = parser.getText();
						} else if (text == 'DealerCity') {
							DealerCity = parser.getText();
						} else if (text == 'DealerState') {
							DealerState = parser.getText();
						} else if (text == 'DealerPostalCode') {
							DealerPostalCode = parser.getText();
						} else if (text == 'DealerCountry') {
							DealerCountry = parser.getText();
						} else if (text == 'BrandId') {
							BrandId = parser.getText();
						} else if (text == 'BrandName') {
							BrandName = parser.getText();
						} else if (text == 'ProductName') {
							ProductName = parser.getText();
						} else if (text == 'Model') {
							Model = parser.getText();
						} else if (text == 'ModelYear') {
							ModelYear = parser.getText();
						} else if (text == 'ProductCode') {
							ProductCode = parser.getText();
						} else if (text == 'FollowUpStatusName') {
							FollowUpStatusName = parser.getText();
						} else if (text == 'PurchaseStatusName') {
							PurchaseStatusName = parser.getText();
						} else if (text == 'LeadTypeName') {
							LeadTypeName = parser.getText();
						} else if (text == 'LeadSourceName') {
							LeadSourceName = parser.getText();
						} else if (text == 'LeadCategoryName') {
							LeadCategoryName = parser.getText();
						} else if (text == 'LeadCampaignName') {
							LeadCampaignName = parser.getText();
						} else if (text == 'ProspectInterestId') {
							ProspectInterestId = parser.getText();
						} else if (text == 'ProspectInterestName') {
							ProspectInterestName = parser.getText();
						} else if (text == 'CompanyId') {
							CompanyId = parser.getText();
						} else if (text == 'CompanyName') {
							CompanyName = parser.getText();
						} else if (text == 'Field1') {
							Field1 = parser.getText();
						} else if (text == 'Field2') {
							Field2 = parser.getText();
						} else if (text == 'Field3') {
							Field3 = parser.getText();
						} else if (text == 'Field4') {
							Field4 = parser.getText();
						} else if (text == 'Field5') {
							Field5 = parser.getText();
						} else if (text == 'Field6') {
							Field6 = parser.getText();
						} else if (text == 'Field7') {
							Field7 = parser.getText();
						} else if (text == 'Field8') {
							Field8 = parser.getText();
						} else if (text == 'Field9') {
							Field9 = parser.getText();
						} else if (text == 'Field10') {
							Field10 = parser.getText();
						} else if (text == 'Field11') {
							Field11 = parser.getText();
						} else if (text == 'Field12') {
							Field12 = parser.getText();
						} else if (text == 'Field13') {
							Field13 = parser.getText();
						} else if (text == 'Field14') {
							Field14 = parser.getText();
						} else if (text == 'Field15') {
							Field15 = parser.getText();
						} else if (text == 'Field16') {
							Field16 = parser.getText();
						} else if (text == 'Field17') {
							Field17 = parser.getText();
						} else if (text == 'Field18') {
							Field18 = parser.getText();
						} else if (text == 'Field19') {
							Field19 = parser.getText();
						} else if (text == 'Field20') {
							Field20 = parser.getText();
						} else if (text == 'Field21') {
							Field21 = parser.getText();
						} else if (text == 'Field22') {
							Field22 = parser.getText();
						} else if (text == 'Field23') {
							Field23 = parser.getText();
						} else if (text == 'Field24') {
							Field24 = parser.getText();
						} else if (text == 'Field25') {
							Field25 = parser.getText();
						} else if (text == 'Field26') {
							Field26 = parser.getText();
						} else if (text == 'Field27') {
							Field27 = parser.getText();
						} else if (text == 'Field28') {
							Field28 = parser.getText();
						} else if (text == 'Field29') {
							Field29 = parser.getText();
						} else if (text == 'Field30') {
							Field30 = parser.getText();
						} else if (text == 'Field31') {
							Field31 = parser.getText();
						} else if (text == 'Field32') {
							Field32 = parser.getText();
						} else if (text == 'Field33') {
							Field33 = parser.getText();
						} else if (text == 'Field34') {
							Field34 = parser.getText();
						} else if (text == 'Field35') {
							Field35 = parser.getText();
						} else if (text == 'Field36') {
							Field36 = parser.getText();
						} else if (text == 'Field37') {
							Field37 = parser.getText();
						} else if (text == 'Field38') {
							Field38 = parser.getText();
						} else if (text == 'Field39') {
							Field39 = parser.getText();
						} else if (text == 'Field40') {
							Field40 = parser.getText();
						} else if (text == 'Field41') {
							Field41 = parser.getText();
						} else if (text == 'Field42') {
							Field42 = parser.getText();
						} else if (text == 'Field43') {
							Field43 = parser.getText();
						} else if (text == 'Field44') {
							Field44 = parser.getText();
						} else if (text == 'Field45') {
							Field45 = parser.getText();
						} else if (text == 'Field46') {
							Field46 = parser.getText();
						} else if (text == 'Field47') {
							Field47 = parser.getText();
						} else if (text == 'Field48') {
							Field48 = parser.getText();
						} else if (text == 'Field49') {
							Field49 = parser.getText();
						} else if (text == 'Field50') {
							Field50 = parser.getText();
						} else if (text == 'AuthenticatedAccountId') {
							AuthenticatedAccountId = parser.getText();
						} else if (text == 'SentToDealer') {
							SentToDealer = parser.getText();
						} else if (text == 'Viewed') {
							Viewed = parser.getText();
						} else if (text == 'DealerDistance') {
							DealerDistance = parser.getText();
						} else if (text == 'DealerDistanceMiles') {
							DealerDistanceMiles = parser.getText();
						} else if (text == 'IsQualified') {
							IsQualified = parser.getText();
						} else if (text == 'SicCode') {
							SicCode = parser.getText();
						} else if (text == 'CompanyTypeName') {
							CompanyTypeName = parser.getText();
						} else if (text == 'CompanyTypeId') {
							CompanyTypeId = parser.getText();
						} else if (text == 'County') {
							County = parser.getText();
						} else if (text == 'EmailDeliverabilityStatusName') {
							EmailDeliverabilityStatusName = parser.getText();
						} else if (text == 'EmailDeliverabilityStatusId') {
							EmailDeliverabilityStatusId = parser.getText();
						} else if (text == 'SubscriberStatusName') {
							SubscriberStatusName = parser.getText();
						} else if (text == 'SubscriberStatusId') {
							SubscriberStatusId = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'RecordData consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public Integer Id {get;set;} 
    public RecordData RecordData {get;set;} 
	public String PublicUrl {get;set;} 
	public Boolean IsEditAvailable {get;set;} 
	public Boolean IsSaveAvailable {get;set;} 
	public Boolean IsPrintAvailable {get;set;} 
	public Boolean IsEditing {get;set;} 
	 
	public SupraMoombaEmailJSON2Apex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Id') {
						Id = parser.getIntegerValue();
					} else if (text == 'PublicUrl') {
						PublicUrl = parser.getText();
					} else if (text == 'RecordData') {
						RecordData = new RecordData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'SupraMoombaEmailJSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public static SupraMoombaEmailJSON2Apex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SupraMoombaEmailJSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
}