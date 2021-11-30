public with sharing class WoocommerceWebhook_Invoice {
    public Integer id {get;set;} 
	public Integer parent_id {get;set;} 
	public String number_Z {get;set;} // in json: number
	public String order_key {get;set;} 
	public String created_via {get;set;} 
	public String version {get;set;} 
	public String status {get;set;} 
	//public String currency_c {get;set;} 
	public String date_created {get;set;} 
	public String date_created_gmt {get;set;} 
	public String date_modified {get;set;} 
	public String date_modified_gmt {get;set;} 
	public String discount_total {get;set;} 
	public String discount_tax {get;set;} 
	public String shipping_total {get;set;} 
	public String shipping_tax {get;set;} 
	public String cart_tax {get;set;} 
	public String total {get;set;} 
	public String total_tax {get;set;} 
	public Boolean prices_include_tax {get;set;} 
	public Integer customer_id {get;set;} 
	public String customer_ip_address {get;set;} 
	public String customer_user_agent {get;set;} 
	public String customer_note {get;set;} 
	public Billing billing {get;set;} 
	public Shipping shipping {get;set;} 
	public String payment_method {get;set;} 
	public String payment_method_title {get;set;} 
	public String transaction_id {get;set;} 
	public String date_paid {get;set;} 
	public String date_paid_gmt {get;set;} 
	public String date_completed {get;set;} 
	public String date_completed_gmt {get;set;} 
	public String cart_hash {get;set;} 
	public List<Meta_data> meta_data {get;set;} 
	public List<Line_items> line_items {get;set;} 
	public List<Tax_lines> tax_lines {get;set;} 
	public List<Shipping_lines> shipping_lines {get;set;} 
	public List<Meta_data_Z> fee_lines {get;set;} 
	public List<Coupon_lines> coupon_lines {get;set;} 
	public List<Meta_data_Z> refunds {get;set;} 
	public String currency_symbol {get;set;} 
	public Links x_links {get;set;} // in json: _links

	public WoocommerceWebhook_Invoice(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						id = parser.getIntegerValue();
					} else if (text == 'parent_id') {
						parent_id = parser.getIntegerValue();
					} else if (text == 'number') {
						number_Z = parser.getText();
					} else if (text == 'order_key') {
						order_key = parser.getText();
					} else if (text == 'created_via') {
						created_via = parser.getText();
					} else if (text == 'version') {
						version = parser.getText();
					} else if (text == 'status') {
						status = parser.getText();
					} else if (text == 'currency') {
						//currency = parser.getText();
					} else if (text == 'date_created') {
						date_created = parser.getText();
					} else if (text == 'date_created_gmt') {
						date_created_gmt = parser.getText();
					} else if (text == 'date_modified') {
						date_modified = parser.getText();
					} else if (text == 'date_modified_gmt') {
						date_modified_gmt = parser.getText();
					} else if (text == 'discount_total') {
						discount_total = parser.getText();
					} else if (text == 'discount_tax') {
						discount_tax = parser.getText();
					} else if (text == 'shipping_total') {
						shipping_total = parser.getText();
					} else if (text == 'shipping_tax') {
						shipping_tax = parser.getText();
					} else if (text == 'cart_tax') {
						cart_tax = parser.getText();
					} else if (text == 'total') {
						total = parser.getText();
					} else if (text == 'total_tax') {
						total_tax = parser.getText();
					} else if (text == 'prices_include_tax') {
						prices_include_tax = parser.getBooleanValue();
					} else if (text == 'customer_id') {
						customer_id = parser.getIntegerValue();
					} else if (text == 'customer_ip_address') {
						customer_ip_address = parser.getText();
					} else if (text == 'customer_user_agent') {
						customer_user_agent = parser.getText();
					} else if (text == 'customer_note') {
						customer_note = parser.getText();
					} else if (text == 'billing') {
						billing = new Billing(parser);
					} else if (text == 'shipping') {
						shipping = new Shipping(parser);
					} else if (text == 'payment_method') {
						payment_method = parser.getText();
					} else if (text == 'payment_method_title') {
						payment_method_title = parser.getText();
					} else if (text == 'transaction_id') {
						transaction_id = parser.getText();
					} else if (text == 'date_paid') {
						date_paid = parser.getText();
					} else if (text == 'date_paid_gmt') {
						date_paid_gmt = parser.getText();
					} else if (text == 'date_completed') {
						date_completed = parser.getText();
					} else if (text == 'date_completed_gmt') {
						date_completed_gmt = parser.getText();
					} else if (text == 'cart_hash') {
						cart_hash = parser.getText();
					} else if (text == 'meta_data') {
						meta_data = arrayOfMeta_data(parser);
					} else if (text == 'line_items') {
						line_items = arrayOfLine_items(parser);
					} else if (text == 'tax_lines') {
						tax_lines = arrayOfTax_lines(parser);
					} else if (text == 'shipping_lines') {
						shipping_lines = arrayOfShipping_lines(parser);
					} else if (text == 'fee_lines') {
						fee_lines = arrayOfMeta_data_Z(parser);
					} else if (text == 'coupon_lines') {
						coupon_lines = arrayOfCoupon_lines(parser);
					} else if (text == 'refunds') {
						refunds = arrayOfMeta_data_Z(parser);
					} else if (text == 'currency_symbol') {
						currency_symbol = parser.getText();
					} else if (text == '_links') {
						x_links = new Links(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'WoocommerceWebhook_Invoice consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Line_items {
		public Integer id {get;set;} 
		public String name {get;set;} 
		public Integer product_id {get;set;} 
		public Integer variation_id {get;set;} 
		public Integer quantity {get;set;} 
		public String tax_class {get;set;} 
		public String subtotal {get;set;} 
		public String subtotal_tax {get;set;} 
		public String total {get;set;} 
		public String total_tax {get;set;} 
		public List<Taxes> taxes {get;set;} 
		public List<Meta_data> meta_data {get;set;} 
		public String sku {get;set;} 
		public Decimal price {get;set;} 

		public Line_items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'product_id') {
							product_id = parser.getIntegerValue();
						} else if (text == 'variation_id') {
							variation_id = parser.getIntegerValue();
						} else if (text == 'quantity') {
							quantity = parser.getIntegerValue();
						} else if (text == 'tax_class') {
							tax_class = parser.getText();
						} else if (text == 'subtotal') {
							subtotal = parser.getText();
						} else if (text == 'subtotal_tax') {
							subtotal_tax = parser.getText();
						} else if (text == 'total') {
							total = parser.getText();
						} else if (text == 'total_tax') {
							total_tax = parser.getText();
						} else if (text == 'taxes') {
							taxes = arrayOfTaxes(parser);
						} else if (text == 'meta_data') {
							meta_data = arrayOfMeta_data(parser);
						} else if (text == 'sku') {
							sku = parser.getText();
						} else if (text == 'price') {
							price = parser.getDecimalValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Line_items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Meta_data_Z {

		public Meta_data_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Meta_data_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Meta_data_Y {
		public Integer id {get;set;} 
		public String key {get;set;} 
		public Value value {get;set;} 

		public Meta_data_Y(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'key') {
							key = parser.getText();
						} else if (text == 'value') {
							value = new Value(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Meta_data_Y consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Meta_data {
		public Integer id {get;set;} 
		public String key {get;set;} 
		public String value {get;set;} 

		public Meta_data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'key') {
							key = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Meta_data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Date_created {
		//public String date_c {get;set;} 
		public Integer timezone_type {get;set;} 
		public String timezone {get;set;} 

		public Date_created(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'date') {
							//date = parser.getText();
						} else if (text == 'timezone_type') {
							timezone_type = parser.getIntegerValue();
						} else if (text == 'timezone') {
							timezone = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Date_created consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Self {
		public String href {get;set;} 

		public Self(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'href') {
							href = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Self consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Shipping_lines {
		public Integer id {get;set;} 
		public String method_title {get;set;} 
		public String method_id {get;set;} 
		public String instance_id {get;set;} 
		public String total {get;set;} 
		public String total_tax {get;set;} 
		public List<Taxes> taxes {get;set;} 
		public List<Meta_data> meta_data {get;set;} 

		public Shipping_lines(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'method_title') {
							method_title = parser.getText();
						} else if (text == 'method_id') {
							method_id = parser.getText();
						} else if (text == 'instance_id') {
							instance_id = parser.getText();
						} else if (text == 'total') {
							total = parser.getText();
						} else if (text == 'total_tax') {
							total_tax = parser.getText();
						} else if (text == 'taxes') {
							taxes = arrayOfTaxes(parser);
						} else if (text == 'meta_data') {
							meta_data = arrayOfMeta_data(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Shipping_lines consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Taxes {
		public Integer id {get;set;} 
		public String total {get;set;} 
		public String subtotal {get;set;} 

		public Taxes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'total') {
							total = parser.getText();
						} else if (text == 'subtotal') {
							subtotal = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Taxes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Billing {
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public String company {get;set;} 
		public String address_1 {get;set;} 
		public String address_2 {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String postcode {get;set;} 
		public String country {get;set;} 
		public String email {get;set;} 
		public String phone {get;set;} 

		public Billing(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'address_1') {
							address_1 = parser.getText();
						} else if (text == 'address_2') {
							address_2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Billing consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Value {
		public Integer id {get;set;} 
		public String code {get;set;} 
		public String amount {get;set;} 
		public Date_created date_created {get;set;} 
		public Date_created date_modified {get;set;} 
		public Object date_expires {get;set;} 
		public String discount_type {get;set;} 
		public String description {get;set;} 
		public Integer usage_count {get;set;} 
		public Boolean individual_use {get;set;} 
		public List<Integer> product_ids {get;set;} 
		public List<Meta_data_Z> excluded_product_ids {get;set;} 
		public Integer usage_limit {get;set;} 
		public Integer usage_limit_per_user {get;set;} 
		public Object limit_usage_to_x_items {get;set;} 
		public Boolean free_shipping {get;set;} 
		public List<Meta_data_Z> product_categories {get;set;} 
		public List<Meta_data_Z> excluded_product_categories {get;set;} 
		public Boolean exclude_sale_items {get;set;} 
		public String minimum_amount {get;set;} 
		public String maximum_amount {get;set;} 
		public List<Meta_data_Z> email_restrictions {get;set;} 
		public Boolean virtual_Z {get;set;} // in json: virtual
		public List<Meta_data_Z> meta_data {get;set;} 

		public Value(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'code') {
							code = parser.getText();
						} else if (text == 'amount') {
							amount = parser.getText();
						} else if (text == 'date_created') {
							date_created = new Date_created(parser);
						} else if (text == 'date_modified') {
							date_modified = new Date_created(parser);
						} else if (text == 'date_expires') {
							date_expires = parser.readValueAs(Object.class);
						} else if (text == 'discount_type') {
							discount_type = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'usage_count') {
							usage_count = parser.getIntegerValue();
						} else if (text == 'individual_use') {
							individual_use = parser.getBooleanValue();
						} else if (text == 'product_ids') {
							product_ids = arrayOfInteger(parser);
						} else if (text == 'excluded_product_ids') {
							excluded_product_ids = arrayOfMeta_data_Z(parser);
						} else if (text == 'usage_limit') {
							usage_limit = parser.getIntegerValue();
						} else if (text == 'usage_limit_per_user') {
							usage_limit_per_user = parser.getIntegerValue();
						} else if (text == 'limit_usage_to_x_items') {
							limit_usage_to_x_items = parser.readValueAs(Object.class);
						} else if (text == 'free_shipping') {
							free_shipping = parser.getBooleanValue();
						} else if (text == 'product_categories') {
							product_categories = arrayOfMeta_data_Z(parser);
						} else if (text == 'excluded_product_categories') {
							excluded_product_categories = arrayOfMeta_data_Z(parser);
						} else if (text == 'exclude_sale_items') {
							exclude_sale_items = parser.getBooleanValue();
						} else if (text == 'minimum_amount') {
							minimum_amount = parser.getText();
						} else if (text == 'maximum_amount') {
							maximum_amount = parser.getText();
						} else if (text == 'email_restrictions') {
							email_restrictions = arrayOfMeta_data_Z(parser);
						} else if (text == 'virtual') {
							virtual_Z = parser.getBooleanValue();
						} else if (text == 'meta_data') {
							meta_data = arrayOfMeta_data_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Value consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Links {
		public List<Self> self {get;set;} 
		public List<Self> collection {get;set;} 

		public Links(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'self') {
							self = arrayOfSelf(parser);
						} else if (text == 'collection') {
							collection = arrayOfSelf(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Links consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Tax_lines {
		public Integer id {get;set;} 
		public String rate_code {get;set;} 
		public Integer rate_id {get;set;} 
		public String label {get;set;} 
		public Boolean compound {get;set;} 
		public String tax_total {get;set;} 
		public String shipping_tax_total {get;set;} 
		public Double rate_percent {get;set;} 
		public List<Meta_data_Z> meta_data {get;set;} 

		public Tax_lines(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'rate_code') {
							rate_code = parser.getText();
						} else if (text == 'rate_id') {
							rate_id = parser.getIntegerValue();
						} else if (text == 'label') {
							label = parser.getText();
						} else if (text == 'compound') {
							compound = parser.getBooleanValue();
						} else if (text == 'tax_total') {
							tax_total = parser.getText();
						} else if (text == 'shipping_tax_total') {
							shipping_tax_total = parser.getText();
						} else if (text == 'rate_percent') {
							rate_percent = parser.getDoubleValue();
						} else if (text == 'meta_data') {
							meta_data = arrayOfMeta_data_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Tax_lines consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Shipping {
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public String company {get;set;} 
		public String address_1 {get;set;} 
		public String address_2 {get;set;} 
		public String city {get;set;} 
		public String state {get;set;} 
		public String postcode {get;set;} 
		public String country {get;set;} 

		public Shipping(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'address_1') {
							address_1 = parser.getText();
						} else if (text == 'address_2') {
							address_2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Shipping consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Coupon_lines {
		public Integer id {get;set;} 
		public String code {get;set;} 
		public String discount {get;set;} 
		public String discount_tax {get;set;} 
		public List<Meta_data_Y> meta_data {get;set;} 

		public Coupon_lines(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getIntegerValue();
						} else if (text == 'code') {
							code = parser.getText();
						} else if (text == 'discount') {
							discount = parser.getText();
						} else if (text == 'discount_tax') {
							discount_tax = parser.getText();
						} else if (text == 'meta_data') {
							meta_data = arrayOfMeta_data_Y(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Coupon_lines consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static WoocommerceWebhook_Invoice parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new WoocommerceWebhook_Invoice(parser);
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
	



    private static List<Meta_data_Y> arrayOfMeta_data_Y(System.JSONParser p) {
        List<Meta_data_Y> res = new List<Meta_data_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Meta_data_Y(p));
        }
        return res;
    }



    private static List<Coupon_lines> arrayOfCoupon_lines(System.JSONParser p) {
        List<Coupon_lines> res = new List<Coupon_lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Coupon_lines(p));
        }
        return res;
    }



    private static List<Meta_data> arrayOfMeta_data(System.JSONParser p) {
        List<Meta_data> res = new List<Meta_data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Meta_data(p));
        }
        return res;
    }


    private static List<Integer> arrayOfInteger(System.JSONParser p) {
        List<Integer> res = new List<Integer>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getIntegerValue());
        }
        return res;
    }



    private static List<Meta_data_Z> arrayOfMeta_data_Z(System.JSONParser p) {
        List<Meta_data_Z> res = new List<Meta_data_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Meta_data_Z(p));
        }
        return res;
    }





    private static List<Line_items> arrayOfLine_items(System.JSONParser p) {
        List<Line_items> res = new List<Line_items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Line_items(p));
        }
        return res;
    }




    private static List<Tax_lines> arrayOfTax_lines(System.JSONParser p) {
        List<Tax_lines> res = new List<Tax_lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Tax_lines(p));
        }
        return res;
    }


    private static List<Shipping_lines> arrayOfShipping_lines(System.JSONParser p) {
        List<Shipping_lines> res = new List<Shipping_lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_lines(p));
        }
        return res;
    }









    private static List<Taxes> arrayOfTaxes(System.JSONParser p) {
        List<Taxes> res = new List<Taxes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Taxes(p));
        }
        return res;
    }



    private static List<Self> arrayOfSelf(System.JSONParser p) {
        List<Self> res = new List<Self>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Self(p));
        }
        return res;
    }
}