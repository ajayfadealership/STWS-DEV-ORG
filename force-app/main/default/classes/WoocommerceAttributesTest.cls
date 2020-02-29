@isTest
public class WoocommerceAttributesTest {
    static testMethod void testParse() {
		String json = '['+
		'    {'+
		'        \"id\": 23,'+
		'        \"name\": \"Burton FTW Size (Men\'s)\",'+
		'        \"slug\": \"pa_burton_ftw_size_mens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/23\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 27,'+
		'        \"name\": \"Burton FTW Size (Women\'s)\",'+
		'        \"slug\": \"pa_burton_ftw_size_womens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/27\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 28,'+
		'        \"name\": \"Burton FTW Size (Youth)\",'+
		'        \"slug\": \"pa_burton_ftw_size_youth\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/28\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 31,'+
		'        \"name\": \"Clothing\",'+
		'        \"slug\": \"pa_clothing\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/31\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 35,'+
		'        \"name\": \"Color232323\",'+
		'        \"slug\": \"pa_color____new\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/35\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 33,'+
		'        \"name\": \"Color\",'+
		'        \"slug\": \"pa_color_sf\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/33\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 18,'+
		'        \"name\": \"Colors\",'+
		'        \"slug\": \"pa_color_universal\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/18\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 11,'+
		'        \"name\": \"Generic Size (Men\'s)\",'+
		'        \"slug\": \"pa_generic_size_mens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/11\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 19,'+
		'        \"name\": \"Generic Size Range\",'+
		'        \"slug\": \"pa_generic_size_range\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/19\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 12,'+
		'        \"name\": \"Generic Size (Women\'s)\",'+
		'        \"slug\": \"pa_generic_size_womens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/12\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 17,'+
		'        \"name\": \"Generic Size (Youth)\",'+
		'        \"slug\": \"pa_generic_size_youth\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/17\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 20,'+
		'        \"name\": \"Shoe Size (Men\'s)\",'+
		'        \"slug\": \"pa_shoe_size_mens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/20\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 21,'+
		'        \"name\": \"Shoe Size (Women\'s)\",'+
		'        \"slug\": \"pa_shoe_size_womens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/21\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 22,'+
		'        \"name\": \"Shoe Size (Youth)\",'+
		'        \"slug\": \"pa_shoe_size_youth\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/22\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 30,'+
		'        \"name\": \"Sizes\",'+
		'        \"slug\": \"pa_sizes\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/30\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 37,'+
		'        \"name\": \"testingAJ\",'+
		'        \"slug\": \"pa_testingaj\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/37\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 39,'+
		'        \"name\": \"testingAJ234\",'+
		'        \"slug\": \"pa_testingaj22\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/39\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 29,'+
		'        \"name\": \"Union Binding Size (Men\'s)\",'+
		'        \"slug\": \"pa_union_binding_size_mens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": false,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/29\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 13,'+
		'        \"name\": \"Waist Size (Men\'s)\",'+
		'        \"slug\": \"pa_waist_size_mens\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/13\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    },'+
		'    {'+
		'        \"id\": 16,'+
		'        \"name\": \"Waist Size (Youth)\",'+
		'        \"slug\": \"pa_waist_size_youth\",'+
		'        \"type\": \"select\",'+
		'        \"order_by\": \"menu_order\",'+
		'        \"has_archives\": true,'+
		'        \"_links\": {'+
		'            \"self\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes/16\"'+
		'                }'+
		'            ],'+
		'            \"collection\": ['+
		'                {'+
		'                    \"href\": \"https://southtownboardsports.com/wp-json/wc/v3/products/attributes\"'+
		'                }'+
		'            ]'+
		'        }'+
		'    }'+
		']';
		List<WoocommerceAttributes> r = WoocommerceAttributes.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceAttributes objWoocommerceAttributes = new WoocommerceAttributes(System.JSON.createParser(json));
		System.assert(objWoocommerceAttributes != null);
		System.assert(objWoocommerceAttributes.id == null);
		System.assert(objWoocommerceAttributes.name == null);
	}
}