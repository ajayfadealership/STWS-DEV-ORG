({
	searchParts : function(component, event, helper) {
        var searchAction = component.get("c.searchPartsfromInventoryAndParts");
        var queryTerm = component.find('enter-search').get('v.value');
        
        searchAction.setParams({
            "searchStr" : queryTerm
        });
        searchAction.setCallback(this, function(response){
            component.set("v.isSearchLoading", false);
                console.log('searchResult',JSON.parse(response.getReturnValue()));
                component.set("v.searchResults", JSON.parse(response.getReturnValue()));
        });

        $A.enqueueAction(searchAction);

    }
})