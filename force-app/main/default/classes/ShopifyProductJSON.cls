public class ShopifyProductJSON {

	public class Variants {
        public String price;
        public String sku;
        public String barcode;
        public Double weight;
        public Boolean requires_shipping;
        public String inventory_management;
        public String inventory_policy;
        public Integer inventory_quantity;
        public String option1;
		public String option2;
        public Object option3;
        /*
        public String title;
		public Integer position;
		
		public Object compare_at_price;
		public String fulfillment_service;
		
		
		public String created_at;
		public String updated_at;
		public Boolean taxable;
		
		public Integer grams;
		public Object image_id;
		
		public String weight_unit;
		public Long inventory_item_id;
		
		public Integer old_inventory_quantity;
		
        public String admin_graphql_api_id;
        */
	}

	public class Options {
		public String name;
		public Integer position;
	}

	public class Variant_ids {
	}

	public Product product;

	public class Images {
		public String attachment;
	}

	public class Product {
		public Long id;
		public String title;
		public String body_html;
		public String vendor;
		public String product_type;
		//public String created_at; 
		//public String handle;
		//public String updated_at;
		//public String published_at;
		//public Object template_suffix;
		//public String published_scope;
		public String tags;
		//public String admin_graphql_api_id;
		public List<Variants> variants;
		public List<Options> options;
		public List<Images> images;
		//public Images image;
	}

	
	public static ShopifyProductJSON parse(String json) {
		return (ShopifyProductJSON) System.JSON.deserialize(json, ShopifyProductJSON.class);
	}
}