public class FileUploadJsonToApex {
	public Integer id {get;set;} 
	public Guid guid {get;set;}

	public FileUploadJsonToApex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) { 
					if (text == 'id') {
						id = parser.getIntegerValue();
					}else if (text == 'guid') {
						guid = new Guid(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'FileUploadJsonToApex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Guid {
		public String rendered {get;set;} 
		//public String raw {get;set;} 

		public Guid(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'rendered') {
							rendered = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Guid consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static FileUploadJsonToApex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new FileUploadJsonToApex(parser);
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

}