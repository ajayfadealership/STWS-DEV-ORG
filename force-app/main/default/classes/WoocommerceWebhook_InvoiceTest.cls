@isTest
private class WoocommerceWebhook_InvoiceTest {

    // This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'	\"id\": 21637,'+
		'	\"parent_id\": 0,'+
		'	\"number\": \"21637\",'+
		'	\"order_key\": \"wc_order_dBIDGfjJHGb9T\",'+
		'	\"created_via\": \"checkout\",'+
		'	\"version\": \"3.7.0\",'+
		'	\"status\": \"completed\",'+
		'	\"currency\": \"USD\",'+
		'	\"date_created\": \"2019-10-04T13:58:04\",'+
		'	\"date_created_gmt\": \"2019-10-04T18:58:04\",'+
		'	\"date_modified\": \"2019-10-06T14:00:54\",'+
		'	\"date_modified_gmt\": \"2019-10-06T19:00:54\",'+
		'	\"discount_total\": \"0.05\",'+
		'	\"discount_tax\": \"0.00\",'+
		'	\"shipping_total\": \"0.00\",'+
		'	\"shipping_tax\": \"0.00\",'+
		'	\"cart_tax\": \"0.00\",'+
		'	\"total\": \"0.00\",'+
		'	\"total_tax\": \"0.00\",'+
		'	\"prices_include_tax\": false,'+
		'	\"customer_id\": 0,'+
		'	\"customer_ip_address\": \"174.106.92.133\",'+
		'	\"customer_user_agent\": \"Mozilla\\/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/76.0.3809.132 Safari\\/537.36\",'+
		'	\"customer_note\": \"\",'+
		'	\"billing\": {'+
		'		\"first_name\": \"Paxton\",'+
		'		\"last_name\": \"Parker\",'+
		'		\"company\": \"paxton@southtownriders.com\",'+
		'		\"address_1\": \"3333 Scott Futrell Drive\",'+
		'		\"address_2\": \"\",'+
		'		\"city\": \"Charlotte\",'+
		'		\"state\": \"NC\",'+
		'		\"postcode\": \"28208\",'+
		'		\"country\": \"US\",'+
		'		\"email\": \"paxton@southtownriders.com\",'+
		'		\"phone\": \"9498009882\"'+
		'	},'+
		'	\"shipping\": {'+
		'		\"first_name\": \"Paxton\",'+
		'		\"last_name\": \"Parker\",'+
		'		\"company\": \"paxton@southtownriders.com\",'+
		'		\"address_1\": \"3333 Scott Futrell Drive\",'+
		'		\"address_2\": \"\",'+
		'		\"city\": \"Charlotte\",'+
		'		\"state\": \"NC\",'+
		'		\"postcode\": \"28208\",'+
		'		\"country\": \"US\"'+
		'	},'+
		'	\"payment_method\": \"\",'+
		'	\"payment_method_title\": \"\",'+
		'	\"transaction_id\": \"\",'+
		'	\"date_paid\": \"2019-10-04T13:58:05\",'+
		'	\"date_paid_gmt\": \"2019-10-04T18:58:05\",'+
		'	\"date_completed\": \"2019-10-06T14:00:54\",'+
		'	\"date_completed_gmt\": \"2019-10-06T19:00:54\",'+
		'	\"cart_hash\": \"36041f670404b77b02836f91dbc7b155\",'+
		'	\"meta_data\": [{'+
		'		\"id\": 292383,'+
		'		\"key\": \"is_vat_exempt\",'+
		'		\"value\": \"no\"'+
		'	}],'+
		'	\"line_items\": [{'+
		'		\"id\": 211,'+
		'		\"name\": \"SouthTown Test Item - Blue\",'+
		'		\"product_id\": 20685,'+
		'		\"variation_id\": 20689,'+
		'		\"quantity\": 1,'+
		'		\"tax_class\": \"\",'+
		'		\"subtotal\": \"0.05\",'+
		'		\"subtotal_tax\": \"0.00\",'+
		'		\"total\": \"0.00\",'+
		'		\"total_tax\": \"0.00\",'+
		'		\"taxes\": [{'+
		'			\"id\": 1,'+
		'			\"total\": \"0\",'+
		'			\"subtotal\": \"0.003625\"'+
		'		}],'+
		'		\"meta_data\": [{'+
		'			\"id\": 1633,'+
		'			\"key\": \"pa_color\",'+
		'			\"value\": \"blue\"'+
		'		}, {'+
		'			\"id\": 1665,'+
		'			\"key\": \"_reduced_stock\",'+
		'			\"value\": \"1\"'+
		'		}],'+
		'		\"sku\": \"STBS TEST BLU\",'+
		'		\"price\": 0'+
		'	}],'+
		'	\"tax_lines\": [{'+
		'		\"id\": 215,'+
		'		\"rate_code\": \"US-NC-NORTH CAROLINA TAX-1\",'+
		'		\"rate_id\": 1,'+
		'		\"label\": \"North Carolina Tax\",'+
		'		\"compound\": false,'+
		'		\"tax_total\": \"0.00\",'+
		'		\"shipping_tax_total\": \"0.00\",'+
		'		\"rate_percent\": 7.25,'+
		'		\"meta_data\": []'+
		'	}],'+
		'	\"shipping_lines\": [{'+
		'		\"id\": 213,'+
		'		\"method_title\": \"Local pickup\",'+
		'		\"method_id\": \"local_pickup\",'+
		'		\"instance_id\": \"1\",'+
		'		\"total\": \"0.00\",'+
		'		\"total_tax\": \"0.00\",'+
		'		\"taxes\": [{'+
		'			\"id\": 1,'+
		'			\"total\": \"\",'+
		'			\"subtotal\": \"\"'+
		'		}],'+
		'		\"meta_data\": [{'+
		'			\"id\": 1645,'+
		'			\"key\": \"Items\",'+
		'			\"value\": \"SouthTown Test Item - Blue &times; 1\"'+
		'		}]'+
		'	}],'+
		'	\"fee_lines\": [],'+
		'	\"coupon_lines\": [{'+
		'		\"id\": 217,'+
		'		\"code\": \"f3t6mtec\",'+
		'		\"discount\": \"0.05\",'+
		'		\"discount_tax\": \"0\",'+
		'		\"meta_data\": [{'+
		'			\"id\": 1663,'+
		'			\"key\": \"coupon_data\",'+
		'			\"value\": {'+
		'				\"id\": 21635,'+
		'				\"code\": \"f3t6mtec\",'+
		'				\"amount\": \"100\",'+
		'				\"date_created\": {'+
		'					\"date\": \"2019-10-04 18:55:43.000000\",'+
		'					\"timezone_type\": 1,'+
		'					\"timezone\": \"+00:00\"'+
		'				},'+
		'				\"date_modified\": {'+
		'					\"date\": \"2019-10-04 18:56:23.000000\",'+
		'					\"timezone_type\": 1,'+
		'					\"timezone\": \"+00:00\"'+
		'				},'+
		'				\"date_expires\": null,'+
		'				\"discount_type\": \"percent\",'+
		'				\"description\": \"\",'+
		'				\"usage_count\": 0,'+
		'				\"individual_use\": false,'+
		'				\"product_ids\": [20685],'+
		'				\"excluded_product_ids\": [],'+
		'				\"usage_limit\": 0,'+
		'				\"usage_limit_per_user\": 0,'+
		'				\"limit_usage_to_x_items\": null,'+
		'				\"free_shipping\": true,'+
		'				\"product_categories\": [],'+
		'				\"excluded_product_categories\": [],'+
		'				\"exclude_sale_items\": false,'+
		'				\"minimum_amount\": \"\",'+
		'				\"maximum_amount\": \"\",'+
		'				\"email_restrictions\": [],'+
		'				\"virtual\": false,'+
		'				\"meta_data\": []'+
		'			}'+
		'		}]'+
		'	}],'+
		'	\"refunds\": [],'+
		'	\"currency_symbol\": \"$\",'+
		'	\"_links\": {'+
		'		\"self\": [{'+
		'			\"href\": \"https:\\/\\/southtownboardsports.com\\/wp-json\\/wc\\/v2\\/orders\\/21637\"'+
		'		}],'+
		'		\"collection\": [{'+
		'			\"href\": \"https:\\/\\/southtownboardsports.com\\/wp-json\\/wc\\/v2\\/orders\"'+
		'		}]'+
		'	}'+
		'}';
		WoocommerceWebhook_Invoice r = WoocommerceWebhook_Invoice.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice objWoocommerceWebhook_Invoice = new WoocommerceWebhook_Invoice(System.JSON.createParser(json));
		System.assert(objWoocommerceWebhook_Invoice != null);
		System.assert(objWoocommerceWebhook_Invoice.id == null);
		System.assert(objWoocommerceWebhook_Invoice.parent_id == null); 
		System.assert(objWoocommerceWebhook_Invoice.number_Z == null);
		System.assert(objWoocommerceWebhook_Invoice.order_key == null);
		System.assert(objWoocommerceWebhook_Invoice.created_via == null);
		System.assert(objWoocommerceWebhook_Invoice.version == null);
		System.assert(objWoocommerceWebhook_Invoice.status == null);
		//System.assert(objWoocommerceWebhook_Invoice.currency == null);
		System.assert(objWoocommerceWebhook_Invoice.date_created == null);
		System.assert(objWoocommerceWebhook_Invoice.date_created_gmt == null);
		System.assert(objWoocommerceWebhook_Invoice.date_modified == null);
		System.assert(objWoocommerceWebhook_Invoice.date_modified_gmt == null);
		System.assert(objWoocommerceWebhook_Invoice.discount_total == null);
		System.assert(objWoocommerceWebhook_Invoice.discount_tax == null);
		System.assert(objWoocommerceWebhook_Invoice.shipping_total == null);
		System.assert(objWoocommerceWebhook_Invoice.shipping_tax == null);
		System.assert(objWoocommerceWebhook_Invoice.cart_tax == null);
		System.assert(objWoocommerceWebhook_Invoice.total == null);
		System.assert(objWoocommerceWebhook_Invoice.total_tax == null);
		System.assert(objWoocommerceWebhook_Invoice.prices_include_tax == null);
		System.assert(objWoocommerceWebhook_Invoice.customer_id == null);
		System.assert(objWoocommerceWebhook_Invoice.customer_ip_address == null);
		System.assert(objWoocommerceWebhook_Invoice.customer_user_agent == null);
		System.assert(objWoocommerceWebhook_Invoice.customer_note == null);
		System.assert(objWoocommerceWebhook_Invoice.billing == null);
		System.assert(objWoocommerceWebhook_Invoice.shipping == null);
		System.assert(objWoocommerceWebhook_Invoice.payment_method == null);
		System.assert(objWoocommerceWebhook_Invoice.payment_method_title == null);
		System.assert(objWoocommerceWebhook_Invoice.transaction_id == null);
		System.assert(objWoocommerceWebhook_Invoice.date_paid == null);
		System.assert(objWoocommerceWebhook_Invoice.date_paid_gmt == null);
		System.assert(objWoocommerceWebhook_Invoice.date_completed == null);
		System.assert(objWoocommerceWebhook_Invoice.date_completed_gmt == null);
		System.assert(objWoocommerceWebhook_Invoice.cart_hash == null);
		System.assert(objWoocommerceWebhook_Invoice.meta_data == null);
		System.assert(objWoocommerceWebhook_Invoice.line_items == null);
		System.assert(objWoocommerceWebhook_Invoice.tax_lines == null);
		System.assert(objWoocommerceWebhook_Invoice.shipping_lines == null);
		System.assert(objWoocommerceWebhook_Invoice.fee_lines == null);
		System.assert(objWoocommerceWebhook_Invoice.coupon_lines == null);
		System.assert(objWoocommerceWebhook_Invoice.refunds == null);
		System.assert(objWoocommerceWebhook_Invoice.currency_symbol == null);
		System.assert(objWoocommerceWebhook_Invoice.x_links == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Line_items objLine_items = new WoocommerceWebhook_Invoice.Line_items(System.JSON.createParser(json));
		System.assert(objLine_items != null);
		System.assert(objLine_items.id == null);
		System.assert(objLine_items.name == null);
		System.assert(objLine_items.product_id == null);
		System.assert(objLine_items.variation_id == null);
		System.assert(objLine_items.quantity == null);
		System.assert(objLine_items.tax_class == null);
		System.assert(objLine_items.subtotal == null);
		System.assert(objLine_items.subtotal_tax == null);
		System.assert(objLine_items.total == null);
		System.assert(objLine_items.total_tax == null);
		System.assert(objLine_items.taxes == null);
		System.assert(objLine_items.meta_data == null);
		System.assert(objLine_items.sku == null);
		System.assert(objLine_items.price == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Meta_data_Z objMeta_data_Z = new WoocommerceWebhook_Invoice.Meta_data_Z(System.JSON.createParser(json));
		System.assert(objMeta_data_Z != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Meta_data_Y objMeta_data_Y = new WoocommerceWebhook_Invoice.Meta_data_Y(System.JSON.createParser(json));
		System.assert(objMeta_data_Y != null);
		System.assert(objMeta_data_Y.id == null);
		System.assert(objMeta_data_Y.key == null);
		System.assert(objMeta_data_Y.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Meta_data objMeta_data = new WoocommerceWebhook_Invoice.Meta_data(System.JSON.createParser(json));
		System.assert(objMeta_data != null);
		System.assert(objMeta_data.id == null);
		System.assert(objMeta_data.key == null);
		System.assert(objMeta_data.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Date_created objDate_created = new WoocommerceWebhook_Invoice.Date_created(System.JSON.createParser(json));
		System.assert(objDate_created != null);
		//System.assert(objDate_created.date == null);
		System.assert(objDate_created.timezone_type == null);
		System.assert(objDate_created.timezone == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Self objSelf = new WoocommerceWebhook_Invoice.Self(System.JSON.createParser(json));
		System.assert(objSelf != null);
		System.assert(objSelf.href == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Shipping_lines objShipping_lines = new WoocommerceWebhook_Invoice.Shipping_lines(System.JSON.createParser(json));
		System.assert(objShipping_lines != null);
		System.assert(objShipping_lines.id == null);
		System.assert(objShipping_lines.method_title == null);
		System.assert(objShipping_lines.method_id == null);
		System.assert(objShipping_lines.instance_id == null);
		System.assert(objShipping_lines.total == null);
		System.assert(objShipping_lines.total_tax == null);
		System.assert(objShipping_lines.taxes == null);
		System.assert(objShipping_lines.meta_data == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Taxes objTaxes = new WoocommerceWebhook_Invoice.Taxes(System.JSON.createParser(json));
		System.assert(objTaxes != null);
		System.assert(objTaxes.id == null);
		System.assert(objTaxes.total == null);
		System.assert(objTaxes.subtotal == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Billing objBilling = new WoocommerceWebhook_Invoice.Billing(System.JSON.createParser(json));
		System.assert(objBilling != null);
		System.assert(objBilling.first_name == null);
		System.assert(objBilling.last_name == null);
		System.assert(objBilling.company == null);
		System.assert(objBilling.address_1 == null);
		System.assert(objBilling.address_2 == null);
		System.assert(objBilling.city == null);
		System.assert(objBilling.state == null);
		System.assert(objBilling.postcode == null);
		System.assert(objBilling.country == null);
		System.assert(objBilling.email == null);
		System.assert(objBilling.phone == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Value objValue = new WoocommerceWebhook_Invoice.Value(System.JSON.createParser(json));
		System.assert(objValue != null);
		System.assert(objValue.id == null);
		System.assert(objValue.code == null);
		System.assert(objValue.amount == null);
		System.assert(objValue.date_created == null);
		System.assert(objValue.date_modified == null);
		System.assert(objValue.date_expires == null);
		System.assert(objValue.discount_type == null);
		System.assert(objValue.description == null);
		System.assert(objValue.usage_count == null);
		System.assert(objValue.individual_use == null);
		System.assert(objValue.product_ids == null);
		System.assert(objValue.excluded_product_ids == null);
		System.assert(objValue.usage_limit == null);
		System.assert(objValue.usage_limit_per_user == null);
		System.assert(objValue.limit_usage_to_x_items == null);
		System.assert(objValue.free_shipping == null);
		System.assert(objValue.product_categories == null);
		System.assert(objValue.excluded_product_categories == null);
		System.assert(objValue.exclude_sale_items == null);
		System.assert(objValue.minimum_amount == null);
		System.assert(objValue.maximum_amount == null);
		System.assert(objValue.email_restrictions == null);
		System.assert(objValue.virtual_Z == null);
		System.assert(objValue.meta_data == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Links objLinks = new WoocommerceWebhook_Invoice.Links(System.JSON.createParser(json));
		System.assert(objLinks != null);
		System.assert(objLinks.self == null);
		System.assert(objLinks.collection == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Tax_lines objTax_lines = new WoocommerceWebhook_Invoice.Tax_lines(System.JSON.createParser(json));
		System.assert(objTax_lines != null);
		System.assert(objTax_lines.id == null); 
		System.assert(objTax_lines.rate_code == null);
		System.assert(objTax_lines.rate_id == null);
		System.assert(objTax_lines.label == null);
		System.assert(objTax_lines.compound == null);
		System.assert(objTax_lines.tax_total == null);
		System.assert(objTax_lines.shipping_tax_total == null);
		System.assert(objTax_lines.rate_percent == null);
		System.assert(objTax_lines.meta_data == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Shipping objShipping = new WoocommerceWebhook_Invoice.Shipping(System.JSON.createParser(json));
		System.assert(objShipping != null);
		System.assert(objShipping.first_name == null);
		System.assert(objShipping.last_name == null);
		System.assert(objShipping.company == null);
		System.assert(objShipping.address_1 == null);
		System.assert(objShipping.address_2 == null);
		System.assert(objShipping.city == null);
		System.assert(objShipping.state == null);
		System.assert(objShipping.postcode == null);
		System.assert(objShipping.country == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		WoocommerceWebhook_Invoice.Coupon_lines objCoupon_lines = new WoocommerceWebhook_Invoice.Coupon_lines(System.JSON.createParser(json));
		System.assert(objCoupon_lines != null);
		System.assert(objCoupon_lines.id == null);
		System.assert(objCoupon_lines.code == null);
		System.assert(objCoupon_lines.discount == null);
		System.assert(objCoupon_lines.discount_tax == null);
		System.assert(objCoupon_lines.meta_data == null);
	}
}