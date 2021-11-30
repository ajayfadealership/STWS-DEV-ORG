@IsTest
public class ShopifyProductParseTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"product\": {'+
		'		\"id\": 4763548450949,'+
		'		\"title\": \"Hyperlite Byerly Buzz 5\'2\\\" Wakesurf Board 2019\",'+
		'		\"body_html\": \"sdasdas\\nda\\nsd\\nasd\\nas\\nd\\nasd\\nas\\ndas\\nd\",'+
		'		\"vendor\": \"HO SPORTS\",'+
		'		\"product_type\": \"Snowboards\",'+
		'		\"created_at\": \"2020-03-25T08:03:11-04:00\",'+
		'		\"handle\": \"hyperlite-byerly-buzz-52-wakesurf-board-2019\",'+
		'		\"updated_at\": \"2020-03-26T04:35:37-04:00\",'+
		'		\"published_at\": \"2020-03-25T08:03:11-04:00\",'+
		'		\"template_suffix\": null,'+
		'		\"published_scope\": \"global\",'+
		'		\"tags\": \"Men\'s Snowboard Equipment \\u0026 Apparel, Pants\",'+
		'		\"admin_graphql_api_id\": \"gid:\\/\\/shopify\\/Product\\/4763548450949\",'+
		'		\"variants\": [{'+
		'			\"id\": 33186114732165,'+
		'			\"product_id\": 4763548450949,'+
		'			\"title\": \"Red \\/ 1\",'+
		'			\"price\": \"499.99\",'+
		'			\"sku\": \"93780611testbsja:i7V5Isafasdfasdfadfasdfadff\",'+
		'			\"position\": 1,'+
		'			\"inventory_policy\": \"continue\",'+
		'			\"compare_at_price\": null,'+
		'			\"fulfillment_service\": \"manual\",'+
		'			\"inventory_management\": \"shopify\",'+
		'			\"option1\": \"Red\",'+
		'			\"option2\": \"1\",'+
		'			\"option3\": null,'+
		'			\"created_at\": \"2020-03-25T08:03:11-04:00\",'+
		'			\"updated_at\": \"2020-03-26T04:31:59-04:00\",'+
		'			\"taxable\": true,'+
		'			\"barcode\": \"93780611Testasda:i7V5I\",'+
		'			\"grams\": 4536,'+
		'			\"image_id\": null,'+
		'			\"weight\": 10.0,'+
		'			\"weight_unit\": \"lb\",'+
		'			\"inventory_item_id\": 34902090317957,'+
		'			\"inventory_quantity\": 0,'+
		'			\"old_inventory_quantity\": 0,'+
		'			\"requires_shipping\": true,'+
		'			\"admin_graphql_api_id\": \"gid:\\/\\/shopify\\/ProductVariant\\/33186114732165\"'+
		'		}, {'+
		'			\"id\": 33186114764933,'+
		'			\"product_id\": 4763548450949,'+
		'			\"title\": \"Blue \\/ 2\",'+
		'			\"price\": \"499.99\",'+
		'			\"sku\": \"93780611testbsja:BfMXR\",'+
		'			\"position\": 2,'+
		'			\"inventory_policy\": \"continue\",'+
		'			\"compare_at_price\": null,'+
		'			\"fulfillment_service\": \"manual\",'+
		'			\"inventory_management\": \"shopify\",'+
		'			\"option1\": \"Blue\",'+
		'			\"option2\": \"2\",'+
		'			\"option3\": null,'+
		'			\"created_at\": \"2020-03-25T08:03:11-04:00\",'+
		'			\"updated_at\": \"2020-03-25T08:03:11-04:00\",'+
		'			\"taxable\": true,'+
		'			\"barcode\": \"93780611Testasda:BfMXR\",'+
		'			\"grams\": 4536,'+
		'			\"image_id\": null,'+
		'			\"weight\": 10.0,'+
		'			\"weight_unit\": \"lb\",'+
		'			\"inventory_item_id\": 34902090350725,'+
		'			\"inventory_quantity\": 0,'+
		'			\"old_inventory_quantity\": 0,'+
		'			\"requires_shipping\": true,'+
		'			\"admin_graphql_api_id\": \"gid:\\/\\/shopify\\/ProductVariant\\/33186114764933\"'+
		'		}],'+
		'		\"options\": [{'+
		'			\"id\": 6214608683141,'+
		'			\"product_id\": 4763548450949,'+
		'			\"name\": \"Color\",'+
		'			\"position\": 1,'+
		'			\"values\": [\"Red\", \"Blue\"]'+
		'		}, {'+
		'			\"id\": 6214608715909,'+
		'			\"product_id\": 4763548450949,'+
		'			\"name\": \"Size\",'+
		'			\"position\": 2,'+
		'			\"values\": [\"1\", \"2\"]'+
		'		}],'+
		'		\"images\": [{'+
		'			\"id\": 15264629096581,'+
		'			\"product_id\": 4763548450949,'+
		'			\"position\": 1,'+
		'			\"created_at\": \"2020-03-26T04:35:37-04:00\",'+
		'			\"updated_at\": \"2020-03-26T04:35:37-04:00\",'+
		'			\"alt\": null,'+
		'			\"width\": 700,'+
		'			\"height\": 700,'+
		'			\"src\": \"https:\\/\\/cdn.shopify.com\\/s\\/files\\/1\\/0056\\/9429\\/2079\\/products\\/53b13f93d336d4db3c22f07f5eac29f7_37148fa9-f12a-45c5-a070-0630285afce2.jpg?v=1585211737\",'+
		'			\"variant_ids\": [],'+
		'			\"admin_graphql_api_id\": \"gid:\\/\\/shopify\\/ProductImage\\/15264629096581\"'+
		'		}],'+
		'		\"image\": {'+
		'			\"id\": 15264629096581,'+
		'			\"product_id\": 4763548450949,'+
		'			\"position\": 1,'+
		'			\"created_at\": \"2020-03-26T04:35:37-04:00\",'+
		'			\"updated_at\": \"2020-03-26T04:35:37-04:00\",'+
		'			\"alt\": null,'+
		'			\"width\": 700,'+
		'			\"height\": 700,'+
		'			\"src\": \"https:\\/\\/cdn.shopify.com\\/s\\/files\\/1\\/0056\\/9429\\/2079\\/products\\/53b13f93d336d4db3c22f07f5eac29f7_37148fa9-f12a-45c5-a070-0630285afce2.jpg?v=1585211737\",'+
		'			\"variant_ids\": [],'+
		'			\"admin_graphql_api_id\": \"gid:\\/\\/shopify\\/ProductImage\\/15264629096581\"'+
		'		}'+
		'	}'+
		'}';
		ShopifyProductParse obj = ShopifyProductParse.parse(json);
		System.assert(obj != null);
	}
}