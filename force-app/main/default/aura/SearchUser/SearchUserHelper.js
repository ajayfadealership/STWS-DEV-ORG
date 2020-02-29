({
    searchUser : function(component, event, helper) {
        var searchkeyword = component.find('searchUsrInp').get('v.value');
        console.log("searchkeyword: "+searchkeyword);
        var action = component.get("c.getUser");
        action.setParams({
            "strUserId" : searchkeyword 
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.searchResults", response.getReturnValue()); 
        });
        $A.enqueueAction(action)
    }
})