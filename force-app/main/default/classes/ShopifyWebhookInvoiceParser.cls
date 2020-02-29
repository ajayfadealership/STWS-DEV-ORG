public class ShopifyWebhookInvoiceParser {

    public class Default_address {
        public Long id {get;set;} 
        public Long customer_id {get;set;} 
        public Object first_name {get;set;} 
        public Object last_name {get;set;} 
        public Object company {get;set;} 
        public String address1 {get;set;} 
        public Object address2 {get;set;} 
        public String city {get;set;} 
        public String province {get;set;} 
        public String country {get;set;} 
        public String zip {get;set;} 
        public String phone {get;set;} 
        public String name {get;set;} 
        public String province_code {get;set;} 
        public String country_code {get;set;} 
        public String country_name {get;set;} 
        public Boolean default_Z {get;set;} // in json: default

        public Default_address(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getLongValue();
                        } else if (text == 'customer_id') {
                            customer_id = parser.getLongValue();
                        } else if (text == 'first_name') {
                            first_name = parser.readValueAs(Object.class);
                        } else if (text == 'last_name') {
                            last_name = parser.readValueAs(Object.class);
                        } else if (text == 'company') {
                            company = parser.readValueAs(Object.class);
                        } else if (text == 'address1') {
                            address1 = parser.getText();
                        } else if (text == 'address2') {
                            address2 = parser.readValueAs(Object.class);
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'province') {
                            province = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'zip') {
                            zip = parser.getText();
                        } else if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'province_code') {
                            province_code = parser.getText();
                        } else if (text == 'country_code') {
                            country_code = parser.getText();
                        } else if (text == 'country_name') {
                            country_name = parser.getText();
                        } else if (text == 'default') {
                            default_Z = parser.getBooleanValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Default_address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Discount_codes {

        public Discount_codes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'Discount_codes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Line_items {
        public Long id {get;set;} 
        public Object variant_id {get;set;} 
        public String title {get;set;} 
        public Integer quantity {get;set;} 
        public String price {get;set;} 
        public String sku {get;set;} 
        public Object variant_title {get;set;} 
        public Object vendor {get;set;} 
        public String fulfillment_service {get;set;} 
        public Long product_id {get;set;} 
        public Boolean requires_shipping {get;set;} 
        public Boolean taxable {get;set;} 
        public Boolean gift_card {get;set;} 
        public String name {get;set;} 
        public Object variant_inventory_management {get;set;} 
        public List<Discount_codes> properties {get;set;} 
        public Boolean product_exists {get;set;} 
        public Integer fulfillable_quantity {get;set;} 
        public Integer grams {get;set;} 
        public String total_discount {get;set;} 
        public Object fulfillment_status {get;set;} 
        public List<Discount_codes> discount_allocations {get;set;} 
        public List<Discount_codes> tax_lines {get;set;} 

        public Line_items(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getLongValue();
                        } else if (text == 'variant_id') {
                            variant_id = parser.readValueAs(Object.class);
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'quantity') {
                            quantity = parser.getIntegerValue();
                        } else if (text == 'price') {
                            price = parser.getText();
                        } else if (text == 'sku') {
                            sku = parser.getText();
                        } else if (text == 'variant_title') {
                            variant_title = parser.readValueAs(Object.class);
                        } else if (text == 'vendor') {
                            vendor = parser.readValueAs(Object.class);
                        } else if (text == 'fulfillment_service') {
                            fulfillment_service = parser.getText();
                        } else if (text == 'product_id') {
                            product_id = parser.getLongValue();
                        } else if (text == 'requires_shipping') {
                            requires_shipping = parser.getBooleanValue();
                        } else if (text == 'taxable') {
                            taxable = parser.getBooleanValue();
                        } else if (text == 'gift_card') {
                            gift_card = parser.getBooleanValue();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'variant_inventory_management') {
                            variant_inventory_management = parser.readValueAs(Object.class);
                        } else if (text == 'properties') {
                            properties = arrayOfDiscount_codes(parser);
                        } else if (text == 'product_exists') {
                            product_exists = parser.getBooleanValue();
                        } else if (text == 'fulfillable_quantity') {
                            fulfillable_quantity = parser.getIntegerValue();
                        } else if (text == 'grams') {
                            grams = parser.getIntegerValue();
                        } else if (text == 'total_discount') {
                            total_discount = parser.getText();
                        } else if (text == 'fulfillment_status') {
                            fulfillment_status = parser.readValueAs(Object.class);
                        } else if (text == 'discount_allocations') {
                            discount_allocations = arrayOfDiscount_codes(parser);
                        } else if (text == 'tax_lines') {
                            tax_lines = arrayOfDiscount_codes(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Line_items consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Customer {
        public Long id {get;set;} 
        public String email {get;set;} 
        public Boolean accepts_marketing {get;set;} 
        public Object created_at {get;set;} 
        public Object updated_at {get;set;} 
        public String first_name {get;set;} 
        public String last_name {get;set;} 
        public Integer orders_count {get;set;} 
        public String state {get;set;} 
        public String total_spent {get;set;} 
        public Object last_order_id {get;set;} 
        public Object note {get;set;} 
        public Boolean verified_email {get;set;} 
        public Object multipass_identifier {get;set;} 
        public Boolean tax_exempt {get;set;} 
        public Object phone {get;set;} 
        public String tags {get;set;} 
        public Object last_order_name {get;set;} 
        public Default_address default_address {get;set;} 

        public Customer(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getLongValue();
                        } else if (text == 'email') {
                            email = parser.getText();
                        } else if (text == 'accepts_marketing') {
                            accepts_marketing = parser.getBooleanValue();
                        } else if (text == 'created_at') {
                            created_at = parser.readValueAs(Object.class);
                        } else if (text == 'updated_at') {
                            updated_at = parser.readValueAs(Object.class);
                        } else if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'orders_count') {
                            orders_count = parser.getIntegerValue();
                        } else if (text == 'state') {
                            state = parser.getText();
                        } else if (text == 'total_spent') {
                            total_spent = parser.getText();
                        } else if (text == 'last_order_id') {
                            last_order_id = parser.readValueAs(Object.class);
                        } else if (text == 'note') {
                            note = parser.readValueAs(Object.class);
                        } else if (text == 'verified_email') {
                            verified_email = parser.getBooleanValue();
                        } else if (text == 'multipass_identifier') {
                            multipass_identifier = parser.readValueAs(Object.class);
                        } else if (text == 'tax_exempt') {
                            tax_exempt = parser.getBooleanValue();
                        } else if (text == 'phone') {
                            phone = parser.readValueAs(Object.class);
                        } else if (text == 'tags') {
                            tags = parser.getText();
                        } else if (text == 'last_order_name') {
                            last_order_name = parser.readValueAs(Object.class);
                        } else if (text == 'default_address') {
                            default_address = new Default_address(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Customer consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Discount_applications {
        public String type_Z {get;set;} // in json: type
        public String value {get;set;} 
        public String value_type {get;set;} 
        public String allocation_method {get;set;} 
        public String target_selection {get;set;} 
        public String target_type {get;set;} 
        public String description {get;set;} 
        public String title {get;set;} 

        public Discount_applications(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else if (text == 'value_type') {
                            value_type = parser.getText();
                        } else if (text == 'allocation_method') {
                            allocation_method = parser.getText();
                        } else if (text == 'target_selection') {
                            target_selection = parser.getText();
                        } else if (text == 'target_type') {
                            target_type = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Discount_applications consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Discount_allocations {
        public String amount {get;set;} 
        public Integer discount_application_index {get;set;} 

        public Discount_allocations(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'amount') {
                            amount = parser.getText();
                        } else if (text == 'discount_application_index') {
                            discount_application_index = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Discount_allocations consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Shipping_lines {
        public Long id {get;set;} 
        public String title {get;set;} 
        public String price {get;set;} 
        public Object code {get;set;} 
        public String source {get;set;} 
        public Object phone {get;set;} 
        public Object requested_fulfillment_service_id {get;set;} 
        public Object delivery_category {get;set;} 
        public Object carrier_identifier {get;set;} 
        public String discounted_price {get;set;} 
        public List<Discount_codes> discount_allocations {get;set;} 
        public List<Discount_codes> tax_lines {get;set;} 

        public Shipping_lines(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getLongValue();
                        } else if (text == 'title') {
                            title = parser.getText();
                        } else if (text == 'price') {
                            price = parser.getText();
                        } else if (text == 'code') {
                            code = parser.readValueAs(Object.class);
                        } else if (text == 'source') {
                            source = parser.getText();
                        } else if (text == 'phone') {
                            phone = parser.readValueAs(Object.class);
                        } else if (text == 'requested_fulfillment_service_id') {
                            requested_fulfillment_service_id = parser.readValueAs(Object.class);
                        } else if (text == 'delivery_category') {
                            delivery_category = parser.readValueAs(Object.class);
                        } else if (text == 'carrier_identifier') {
                            carrier_identifier = parser.readValueAs(Object.class);
                        } else if (text == 'discounted_price') {
                            discounted_price = parser.getText();
                        } else if (text == 'discount_allocations') {
                            discount_allocations = arrayOfDiscount_codes(parser);
                        } else if (text == 'tax_lines') {
                            tax_lines = arrayOfDiscount_codes(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Shipping_lines consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Billing_address {
        public String first_name {get;set;} 
        public String address1 {get;set;} 
        public String phone {get;set;} 
        public String city {get;set;} 
        public String zip {get;set;} 
        public String province {get;set;} 
        public String country {get;set;} 
        public String last_name {get;set;} 
        public Object address2 {get;set;} 
        public String company {get;set;} 
        public Object latitude {get;set;} 
        public Object longitude {get;set;} 
        public String name {get;set;} 
        public String country_code {get;set;} 
        public String province_code {get;set;} 

        public Billing_address(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'first_name') {
                            first_name = parser.getText();
                        } else if (text == 'address1') {
                            address1 = parser.getText();
                        } else if (text == 'phone') {
                            phone = parser.getText();
                        } else if (text == 'city') {
                            city = parser.getText();
                        } else if (text == 'zip') {
                            zip = parser.getText();
                        } else if (text == 'province') {
                            province = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'last_name') {
                            last_name = parser.getText();
                        } else if (text == 'address2') {
                            address2 = parser.readValueAs(Object.class);
                        } else if (text == 'company') {
                            company = parser.getText();
                        } else if (text == 'latitude') {
                            latitude = parser.readValueAs(Object.class);
                        } else if (text == 'longitude') {
                            longitude = parser.readValueAs(Object.class);
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'country_code') {
                            country_code = parser.getText();
                        } else if (text == 'province_code') {
                            province_code = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Billing_address consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Long id {get;set;} 
    public String email {get;set;} 
    public Object closed_at {get;set;} 
    public String created_at {get;set;} 
    public String updated_at {get;set;} 
    public Integer number_Z {get;set;} // in json: number
    public Object note {get;set;} 
    public String token {get;set;} 
    public Object gateway {get;set;} 
    public Boolean test {get;set;} 
    public String total_price {get;set;} 
    public String subtotal_price {get;set;} 
    public Integer total_weight {get;set;} 
    public String total_tax {get;set;} 
    public Boolean taxes_included {get;set;} 
    public String currencyChange {get;set;} 
    public String financial_status {get;set;} 
    public Boolean confirmed {get;set;} 
    public String total_discounts {get;set;} 
    public String total_line_items_price {get;set;} 
    public Object cart_token {get;set;} 
    public Boolean buyer_accepts_marketing {get;set;} 
    public String name {get;set;} 
    public Object referring_site {get;set;} 
    public Object landing_site {get;set;} 
    public String cancelled_at {get;set;} 
    public String cancel_reason {get;set;} 
    public Object total_price_usd {get;set;} 
    public Object checkout_token {get;set;} 
    public Object reference {get;set;} 
    public Object user_id {get;set;} 
    public Object location_id {get;set;} 
    public Object source_identifier {get;set;} 
    public Object source_url {get;set;} 
    public Object processed_at {get;set;} 
    public Object device_id {get;set;} 
    public Object phone {get;set;} 
    public String customer_locale {get;set;} 
    public Object app_id {get;set;} 
    public Object browser_ip {get;set;} 
    public Object landing_site_ref {get;set;} 
    public Integer order_number {get;set;} 
    public List<Discount_applications> discount_applications {get;set;} 
    public List<Discount_codes> discount_codes {get;set;} 
    public List<Discount_codes> note_attributes {get;set;} 
    public List<String> payment_gateway_names {get;set;} 
    public String processing_method {get;set;} 
    public Object checkout_id {get;set;} 
    public String source_name {get;set;} 
    public String fulfillment_status {get;set;} 
    public List<Discount_codes> tax_lines {get;set;} 
    public String tags {get;set;} 
    public String contact_email {get;set;} 
    public String order_status_url {get;set;} 
    public String total_tip_received {get;set;} 
    public List<Line_items> line_items {get;set;} 
    public List<Shipping_lines> shipping_lines {get;set;} 
    public Billing_address billing_address {get;set;} 
    public Billing_address shipping_address {get;set;} 
    public List<Discount_codes> fulfillments {get;set;} 
    public List<Discount_codes> refunds {get;set;} 
    public Customer customer {get;set;} 

    public ShopifyWebhookInvoiceParser(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        id = parser.getLongValue();
                    } else if (text == 'email') {
                        email = parser.getText();
                    } else if (text == 'closed_at') {
                        closed_at = parser.readValueAs(Object.class);
                    } else if (text == 'created_at') {
                        created_at = parser.getText();
                    } else if (text == 'updated_at') {
                        updated_at = parser.getText();
                    } else if (text == 'number') {
                        number_Z = parser.getIntegerValue();
                    } else if (text == 'note') {
                        note = parser.readValueAs(Object.class);
                    } else if (text == 'token') {
                        token = parser.getText();
                    } else if (text == 'gateway') {
                        gateway = parser.readValueAs(Object.class);
                    } else if (text == 'test') {
                        test = parser.getBooleanValue();
                    } else if (text == 'total_price') {
                        total_price = parser.getText();
                    } else if (text == 'subtotal_price') {
                        subtotal_price = parser.getText();
                    } else if (text == 'total_weight') {
                        total_weight = parser.getIntegerValue();
                    } else if (text == 'total_tax') {
                        total_tax = parser.getText();
                    } else if (text == 'taxes_included') {
                        taxes_included = parser.getBooleanValue();
                    } else if (text == 'currency') {
                        currencyChange = parser.getText();
                    } else if (text == 'financial_status') {
                        financial_status = parser.getText();
                    } else if (text == 'confirmed') {
                        confirmed = parser.getBooleanValue();
                    } else if (text == 'total_discounts') {
                        total_discounts = parser.getText();
                    } else if (text == 'total_line_items_price') {
                        total_line_items_price = parser.getText();
                    } else if (text == 'cart_token') {
                        cart_token = parser.readValueAs(Object.class);
                    } else if (text == 'buyer_accepts_marketing') {
                        buyer_accepts_marketing = parser.getBooleanValue();
                    } else if (text == 'name') {
                        name = parser.getText();
                    } else if (text == 'referring_site') {
                        referring_site = parser.readValueAs(Object.class);
                    } else if (text == 'landing_site') {
                        landing_site = parser.readValueAs(Object.class);
                    } else if (text == 'cancelled_at') {
                        cancelled_at = parser.getText();
                    } else if (text == 'cancel_reason') {
                        cancel_reason = parser.getText();
                    } else if (text == 'total_price_usd') {
                        total_price_usd = parser.readValueAs(Object.class);
                    } else if (text == 'checkout_token') {
                        checkout_token = parser.readValueAs(Object.class);
                    } else if (text == 'reference') {
                        reference = parser.readValueAs(Object.class);
                    } else if (text == 'user_id') {
                        user_id = parser.readValueAs(Object.class);
                    } else if (text == 'location_id') {
                        location_id = parser.readValueAs(Object.class);
                    } else if (text == 'source_identifier') {
                        source_identifier = parser.readValueAs(Object.class);
                    } else if (text == 'source_url') {
                        source_url = parser.readValueAs(Object.class);
                    } else if (text == 'processed_at') {
                        processed_at = parser.readValueAs(Object.class);
                    } else if (text == 'device_id') {
                        device_id = parser.readValueAs(Object.class);
                    } else if (text == 'phone') {
                        phone = parser.readValueAs(Object.class);
                    } else if (text == 'customer_locale') {
                        customer_locale = parser.getText();
                    } else if (text == 'app_id') {
                        app_id = parser.readValueAs(Object.class);
                    } else if (text == 'browser_ip') {
                        browser_ip = parser.readValueAs(Object.class);
                    } else if (text == 'landing_site_ref') {
                        landing_site_ref = parser.readValueAs(Object.class);
                    } else if (text == 'order_number') {
                        order_number = parser.getIntegerValue();
                    } else if (text == 'discount_applications') {
                        discount_applications = arrayOfDiscount_applications(parser);
                    } else if (text == 'discount_codes') {
                        discount_codes = arrayOfDiscount_codes(parser);
                    } else if (text == 'note_attributes') {
                        note_attributes = arrayOfDiscount_codes(parser);
                    } else if (text == 'payment_gateway_names') {
                        payment_gateway_names = arrayOfString(parser);
                    } else if (text == 'processing_method') {
                        processing_method = parser.getText();
                    } else if (text == 'checkout_id') {
                        checkout_id = parser.readValueAs(Object.class);
                    } else if (text == 'source_name') {
                        source_name = parser.getText();
                    } else if (text == 'fulfillment_status') {
                        fulfillment_status = parser.getText();
                    } else if (text == 'tax_lines') {
                        tax_lines = arrayOfDiscount_codes(parser);
                    } else if (text == 'tags') {
                        tags = parser.getText();
                    } else if (text == 'contact_email') {
                        contact_email = parser.getText();
                    } else if (text == 'order_status_url') {
                        order_status_url = parser.getText();
                    } else if (text == 'total_tip_received') {
                        total_tip_received = parser.getText();
                    } else if (text == 'line_items') {
                        line_items = arrayOfLine_items(parser);
                    } else if (text == 'shipping_lines') {
                        shipping_lines = arrayOfShipping_lines(parser);
                    } else if (text == 'billing_address') {
                        billing_address = new Billing_address(parser);
                    } else if (text == 'shipping_address') {
                        shipping_address = new Billing_address(parser);
                    } else if (text == 'fulfillments') {
                        fulfillments = arrayOfDiscount_codes(parser);
                    } else if (text == 'refunds') {
                        refunds = arrayOfDiscount_codes(parser);
                    } else if (text == 'customer') {
                        customer = new Customer(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'ShopifyWebhookInvoiceParser consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static ShopifyWebhookInvoiceParser parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new ShopifyWebhookInvoiceParser(parser);
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
    


    private static List<Shipping_lines> arrayOfShipping_lines(System.JSONParser p) {
        List<Shipping_lines> res = new List<Shipping_lines>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Shipping_lines(p));
        }
        return res;
    }




    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
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




    private static List<Discount_codes> arrayOfDiscount_codes(System.JSONParser p) {
        List<Discount_codes> res = new List<Discount_codes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Discount_codes(p));
        }
        return res;
    }





    private static List<Discount_applications> arrayOfDiscount_applications(System.JSONParser p) {
        List<Discount_applications> res = new List<Discount_applications>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Discount_applications(p));
        }
        return res;
    }


    private static List<Discount_allocations> arrayOfDiscount_allocations(System.JSONParser p) {
        List<Discount_allocations> res = new List<Discount_allocations>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Discount_allocations(p));
        }
        return res;
    }


}