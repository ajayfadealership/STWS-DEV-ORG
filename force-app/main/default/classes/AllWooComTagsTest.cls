@isTest
private class AllWooComTagsTest {

    // This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '['+
		'  {'+
		'    \"id\": 34,'+
		'    \"name\": \"Leather Shoes\",'+
		'    \"slug\": \"leather-shoes\",'+
		'    \"description\": \"\",'+
		'    \"count\": 0,'+
		'    \"_links\": {'+
		'      \"self\": ['+
		'        {'+
		'          \"href\": \"https://example.com/wp-json/wc/v3/products/tags/34\"'+
		'        }'+
		'      ],'+
		'      \"collection\": ['+
		'        {'+
		'          \"href\": \"https://example.com/wp-json/wc/v3/products/tags\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  },'+
		'  {'+
		'    \"id\": 35,'+
		'    \"name\": \"Oxford Shoes\",'+
		'    \"slug\": \"oxford-shoes\",'+
		'    \"description\": \"\",'+
		'    \"count\": 0,'+
		'    \"_links\": {'+
		'      \"self\": ['+
		'        {'+
		'          \"href\": \"https://example.com/wp-json/wc/v3/products/tags/35\"'+
		'        }'+
		'      ],'+
		'      \"collection\": ['+
		'        {'+
		'          \"href\": \"https://example.com/wp-json/wc/v3/products/tags\"'+
		'        }'+
		'      ]'+
		'    }'+
		'  }'+
		']';
		List<AllWooComTags> r = AllWooComTags.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		AllWooComTags objAllWooComTags = new AllWooComTags(System.JSON.createParser(json));
		System.assert(objAllWooComTags != null);
		System.assert(objAllWooComTags.id == null);
		System.assert(objAllWooComTags.name == null);
	}
}