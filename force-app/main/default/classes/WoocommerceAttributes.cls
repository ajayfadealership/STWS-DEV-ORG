public class WoocommerceAttributes {
    public Integer id {get;set;} 
    public String name {get;set;}    
    
    public static List<WoocommerceAttributes> parse(String json) {
        return (List<WoocommerceAttributes>) System.JSON.deserialize(json, List<WoocommerceAttributes>.class);
    }
}