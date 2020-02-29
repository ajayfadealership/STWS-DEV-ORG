@isTest
private class FileUploadJsonToApexTest {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'	\"id\": 19896,'+
		'	\"date\": \"2019-02-23T12:28:44\",'+
		'	\"date_gmt\": \"2019-02-23T12:28:44\",'+
		'	\"guid\": {'+
		'		\"rendered\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1.jpg\",'+
		'		\"raw\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1.jpg\"'+
		'	},'+
		'	\"modified\": \"2019-02-23T12:28:44\",'+
		'	\"modified_gmt\": \"2019-02-23T12:28:44\",'+
		'	\"slug\": \"img_0217-jpeg-1\",'+
		'	\"status\": \"inherit\",'+
		'	\"type\": \"attachment\",'+
		'	\"link\": \"https:\\/\\/dev.southtownwatersports.com\\/img_0217-jpeg-1\\/\",'+
		'	\"title\": {'+
		'		\"raw\": \"IMG_0217.jpeg-1\",'+
		'		\"rendered\": \"IMG_0217.jpeg-1\"'+
		'	},'+
		'	\"author\": 2,'+
		'	\"comment_status\": \"open\",'+
		'	\"ping_status\": \"closed\",'+
		'	\"template\": \"\",'+
		'	\"meta\": [],'+
		'	\"permalink_template\": \"https:\\/\\/dev.southtownwatersports.com\\/?attachment_id=19896\",'+
		'	\"generated_slug\": \"img_0217-jpeg-1\",'+
		'	\"description\": {'+
		'		\"raw\": \"\",'+
		'		\"rendered\": \"<p class=\\\"attachment\\\"><a href=\'https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1.jpg\'><img width=\\\"300\\\" height=\\\"225\\\" src=\\\"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x225.jpg\\\" class=\\\"attachment-medium size-medium\\\" alt=\\\"\\\" srcset=\\\"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x225.jpg 300w, https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-768x576.jpg 768w, https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-1024x768.jpg 1024w, https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-600x450.jpg 600w\\\" sizes=\\\"(max-width: 300px) 100vw, 300px\\\" \\/><\\/a><\\/p>\\n\"'+
		'	},'+
		'	\"caption\": {'+
		'		\"raw\": \"\",'+
		'		\"rendered\": \"\"'+
		'	},'+
		'	\"alt_text\": \"\",'+
		'	\"media_type\": \"image\",'+
		'	\"mime_type\": \"image\\/jpeg\",'+
		'	\"media_details\": {'+
		'		\"width\": 4032,'+
		'		\"height\": 3024,'+
		'		\"file\": \"2019\\/02\\/IMG_0217.jpeg-1.jpg\",'+
		'		\"sizes\": {'+
		'			\"thumbnail\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-150x150.jpg\",'+
		'				\"width\": 150,'+
		'				\"height\": 150,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-150x150.jpg\"'+
		'			},'+
		'			\"medium\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-300x225.jpg\",'+
		'				\"width\": 300,'+
		'				\"height\": 225,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x225.jpg\"'+
		'			},'+
		'			\"medium_large\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-768x576.jpg\",'+
		'				\"width\": 768,'+
		'				\"height\": 576,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-768x576.jpg\"'+
		'			},'+
		'			\"large\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-1024x768.jpg\",'+
		'				\"width\": 1024,'+
		'				\"height\": 768,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-1024x768.jpg\"'+
		'			},'+
		'			\"woocommerce_thumbnail\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-300x300.jpg\",'+
		'				\"width\": 300,'+
		'				\"height\": 300,'+
		'				\"uncropped\": false,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x300.jpg\"'+
		'			},'+
		'			\"woocommerce_single\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-600x450.jpg\",'+
		'				\"width\": 600,'+
		'				\"height\": 450,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-600x450.jpg\"'+
		'			},'+
		'			\"woocommerce_gallery_thumbnail\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-100x100.jpg\",'+
		'				\"width\": 100,'+
		'				\"height\": 100,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-100x100.jpg\"'+
		'			},'+
		'			\"shop_catalog\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-300x300.jpg\",'+
		'				\"width\": 300,'+
		'				\"height\": 300,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x300.jpg\"'+
		'			},'+
		'			\"shop_single\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-600x450.jpg\",'+
		'				\"width\": 600,'+
		'				\"height\": 450,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-600x450.jpg\"'+
		'			},'+
		'			\"shop_thumbnail\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-100x100.jpg\",'+
		'				\"width\": 100,'+
		'				\"height\": 100,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-100x100.jpg\"'+
		'			},'+
		'			\"wpsfp_vehicle_single\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-960x540.jpg\",'+
		'				\"width\": 960,'+
		'				\"height\": 540,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-960x540.jpg\"'+
		'			},'+
		'			\"wpsfp_product_thumbnail\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-300x168.jpg\",'+
		'				\"width\": 300,'+
		'				\"height\": 168,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-300x168.jpg\"'+
		'			},'+
		'			\"wpsfp_product_listings_item\": {'+
		'				\"file\": \"IMG_0217.jpeg-1-100x100.jpg\",'+
		'				\"width\": 100,'+
		'				\"height\": 100,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1-100x100.jpg\"'+
		'			},'+
		'			\"full\": {'+
		'				\"file\": \"IMG_0217.jpeg-1.jpg\",'+
		'				\"width\": 4032,'+
		'				\"height\": 3024,'+
		'				\"mime_type\": \"image\\/jpeg\",'+
		'				\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1.jpg\"'+
		'			}'+
		'		},'+
		'		\"image_meta\": {'+
		'			\"aperture\": \"0\",'+
		'			\"credit\": \"\",'+
		'			\"camera\": \"\",'+
		'			\"caption\": \"\",'+
		'			\"created_timestamp\": \"0\",'+
		'			\"copyright\": \"\",'+
		'			\"focal_length\": \"0\",'+
		'			\"iso\": \"0\",'+
		'			\"shutter_speed\": \"0\",'+
		'			\"title\": \"\",'+
		'			\"orientation\": \"0\",'+
		'			\"keywords\": []'+
		'		}'+
		'	},'+
		'	\"post\": null,'+
		'	\"source_url\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-content\\/uploads\\/2019\\/02\\/IMG_0217.jpeg-1.jpg\",'+
		'	\"_links\": {'+
		'		\"self\": [{'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/media\\/19896\"'+
		'		}],'+
		'		\"collection\": [{'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/media\"'+
		'		}],'+
		'		\"about\": [{'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/types\\/attachment\"'+
		'		}],'+
		'		\"author\": [{'+
		'			\"embeddable\": true,'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/users\\/2\"'+
		'		}],'+
		'		\"replies\": [{'+
		'			\"embeddable\": true,'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/comments?post=19896\"'+
		'		}],'+
		'		\"wp:action-unfiltered-html\": [{'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/media\\/19896\"'+
		'		}],'+
		'		\"wp:action-assign-author\": [{'+
		'			\"href\": \"https:\\/\\/dev.southtownwatersports.com\\/wp-json\\/wp\\/v2\\/media\\/19896\"'+
		'		}],'+
		'		\"curies\": [{'+
		'			\"name\": \"wp\",'+
		'			\"href\": \"https:\\/\\/api.w.org\\/{rel}\",'+
		'			\"templated\": true'+
		'		}]'+
		'	}'+
		'}';
		FileUploadJsonToApex r = FileUploadJsonToApex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FileUploadJsonToApex objFileUploadJsonToApex = new FileUploadJsonToApex(System.JSON.createParser(json));

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		FileUploadJsonToApex.Guid objGuid = new FileUploadJsonToApex.Guid(System.JSON.createParser(json));
		System.assert(objGuid != null);
		System.assert(objGuid.rendered == null);
		System.assert(objGuid.raw == null);
		
	}
}