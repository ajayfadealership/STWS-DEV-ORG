@isTest
private class AllWooComCategoriesTest {

    // This test method should give 100% coverage
    static testMethod void testParse() {
        /*String json = '['+
        '  {'+
        '    \"id\": 15,'+
        '    \"name\": \"Albums\",'+
        '    \"slug\": \"albums\",'+
        '    \"parent\": 11,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 4,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/15\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ],'+
        '      \"up\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/11\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 9,'+
        '    \"name\": \"Clothing\",'+
        '    \"slug\": \"clothing\",'+
        '    \"parent\": 0,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": {'+
        '      \"id\": 730,'+
        '      \"date_created\": \"2017-03-23T00:01:07\",'+
        '      \"date_created_gmt\": \"2017-03-23T03:01:07\",'+
        '      \"date_modified\": \"2017-03-23T00:01:07\",'+
        '      \"date_modified_gmt\": \"2017-03-23T03:01:07\",'+
        '      \"src\": \"https://example.com/wp-content/uploads/2017/03/T_2_front.jpg\",'+
        '      \"name\": \"\",'+
        '      \"alt\": \"\"'+
        '    },'+
        '    \"menu_order\": 0,'+
        '    \"count\": 36,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example/wp-json/wc/v3/products/categories/9\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 10,'+
        '    \"name\": \"Hoodies\",'+
        '    \"slug\": \"hoodies\",'+
        '    \"parent\": 9,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 6,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/10\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ],'+
        '      \"up\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/9\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 11,'+
        '    \"name\": \"Music\",'+
        '    \"slug\": \"music\",'+
        '    \"parent\": 0,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 7,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/11\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 12,'+
        '    \"name\": \"Posters\",'+
        '    \"slug\": \"posters\",'+
        '    \"parent\": 0,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 5,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/12\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 13,'+
        '    \"name\": \"Singles\",'+
        '    \"slug\": \"singles\",'+
        '    \"parent\": 11,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 3,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/13\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ],'+
        '      \"up\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/11\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  },'+
        '  {'+
        '    \"id\": 14,'+
        '    \"name\": \"T-shirts\",'+
        '    \"slug\": \"t-shirts\",'+
        '    \"parent\": 9,'+
        '    \"description\": \"\",'+
        '    \"display\": \"default\",'+
        '    \"image\": [],'+
        '    \"menu_order\": 0,'+
        '    \"count\": 6,'+
        '    \"_links\": {'+
        '      \"self\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/14\"'+
        '        }'+
        '      ],'+
        '      \"collection\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories\"'+
        '        }'+
        '      ],'+
        '      \"up\": ['+
        '        {'+
        '          \"href\": \"https://example.com/wp-json/wc/v3/products/categories/9\"'+
        '        }'+
        '      ]'+
        '    }'+
        '  }'+
        ']';
        List<AllWooComCategories> r = AllWooComCategories.parse(json);
        System.assert(r != null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories.Links_Z objLinks_Z = new AllWooComCategories.Links_Z(System.JSON.createParser(json));
        System.assert(objLinks_Z != null);
        System.assert(objLinks_Z.self == null);
        System.assert(objLinks_Z.collection == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories objAllWooComCategories = new AllWooComCategories(System.JSON.createParser(json));
        System.assert(objAllWooComCategories != null);
        System.assert(objAllWooComCategories.id == null);
        System.assert(objAllWooComCategories.name == null);
        System.assert(objAllWooComCategories.slug == null);
        System.assert(objAllWooComCategories.parent == null);
        System.assert(objAllWooComCategories.description == null);
        System.assert(objAllWooComCategories.display == null);
        System.assert(objAllWooComCategories.image == null);
        System.assert(objAllWooComCategories.menu_order == null);
        System.assert(objAllWooComCategories.count == null);
        System.assert(objAllWooComCategories.x_links == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories.Image_Z objImage_Z = new AllWooComCategories.Image_Z(System.JSON.createParser(json));
        System.assert(objImage_Z != null);
        System.assert(objImage_Z.id == null);
        System.assert(objImage_Z.date_created == null);
        System.assert(objImage_Z.date_created_gmt == null);
        System.assert(objImage_Z.date_modified == null);
        System.assert(objImage_Z.date_modified_gmt == null);
        System.assert(objImage_Z.src == null);
        System.assert(objImage_Z.name == null);
        System.assert(objImage_Z.alt == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories.Links objLinks = new AllWooComCategories.Links(System.JSON.createParser(json));
        System.assert(objLinks != null);
        System.assert(objLinks.self == null);
        System.assert(objLinks.collection == null);
        System.assert(objLinks.up == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories.Self objSelf = new AllWooComCategories.Self(System.JSON.createParser(json));
        System.assert(objSelf != null);
        System.assert(objSelf.href == null);

        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        AllWooComCategories.Image objImage = new AllWooComCategories.Image(System.JSON.createParser(json));
        System.assert(objImage != null);*/
    }
}