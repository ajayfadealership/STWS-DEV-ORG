public with sharing class AllWooComCategories {
    public Integer id {get;set;} 
	public String name {get;set;}

    public static List<AllWooComCategories> parse(String json) {
        return (List<AllWooComCategories>) System.JSON.deserialize(json, List<AllWooComCategories>.class);
    }
}