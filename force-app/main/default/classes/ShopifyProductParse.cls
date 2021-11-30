public with sharing class ShopifyProductParse {
   
	public class Variants {
		public Long id;
		public Long product_id;
		public String title;
		public String price;
		public String sku;
		public Integer position;
		public String inventory_policy;
		public Object compare_at_price;
		public String fulfillment_service;
		public String inventory_management; 
		public String option1;
		public String option2;
		public Object option3;
		public String created_at;
		public String updated_at;
		public Boolean taxable;
		public String barcode;
		public Integer grams;
		public Object image_id;
		public Double weight;
		public String weight_unit;
		public Long inventory_item_id;
		public Integer inventory_quantity;
		public Integer old_inventory_quantity;
		public Boolean requires_shipping;
		public String admin_graphql_api_id;
	}

	public class Options {
		public Long id;
		public Long product_id;
		public String name;
		public Integer position;
		public List<String> values;
	}

	public class Variant_ids {
	}

	public Product product;

	public class Images {
		public Long id;
		public Long product_id;
		public Integer position;
		public String created_at;
		public String updated_at;
		public Object alt;
		public Integer width;
		public Integer height;
		public String src;
		public List<Variant_ids> variant_ids;
		public String admin_graphql_api_id;
	}

	public class Product {
		public Long id;
		public String title;
		public String body_html;
		public String vendor;
		public String product_type;
		public String created_at;
		public String handle;
		public String updated_at;
		public String published_at;
		public Object template_suffix;
		public String published_scope;
		public String tags;
		public String admin_graphql_api_id;
		public List<Variants> variants;
		public List<Options> options;
		public List<Images> images;
		public Images image;
	}

	
	public static ShopifyProductParse parse(String json) {
		return (ShopifyProductParse) System.JSON.deserialize(json, ShopifyProductParse.class);
	}
}