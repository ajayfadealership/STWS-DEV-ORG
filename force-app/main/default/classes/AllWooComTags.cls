public class AllWooComTags {
    public Integer id {get;set;} 
    public String name {get;set;} 
    
    public AllWooComTags(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'id') {
                        id = parser.getIntegerValue();
                    } else if (text == 'name') {
                        name = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'AllWooComTags consuming unrecognized property: '+text);
                    }
                }
            }
        }
    }
    
    public static List<AllWooComTags> parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return arrayOfAllWooComTags(parser);
    }
    
    private static List<AllWooComTags> arrayOfAllWooComTags(System.JSONParser p) {
        List<AllWooComTags> res = new List<AllWooComTags>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new AllWooComTags(p));
        }
        return res;
    }
}