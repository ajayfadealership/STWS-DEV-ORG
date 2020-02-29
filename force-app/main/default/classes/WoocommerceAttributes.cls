public class WoocommerceAttributes {
	public Integer id {get;set;} 
	public String name {get;set;} 
	

	public WoocommerceAttributes(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						id = parser.getIntegerValue();
					} else if (text == 'name') {
						name = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'WoocommerceAttributes consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public static List<WoocommerceAttributes> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfWoocommerceAttributes(parser);
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

    private static List<WoocommerceAttributes> arrayOfWoocommerceAttributes(System.JSONParser p) {
        List<WoocommerceAttributes> res = new List<WoocommerceAttributes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new WoocommerceAttributes(p));
        }
        return res;
    }



}