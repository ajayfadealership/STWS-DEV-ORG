({
	getItemDetailsHelper : function(component, itemID) {
		var action = component.get("c.fetchItem");
		action.setParams({ 
			"strItemId" : itemID
		});
		action.setCallback(this, function(response) {
			console.log("$>>>>",response.getReturnValue());
			component.set("v.objItem", response.getReturnValue()[0]);
			var obj = component.get("v.objItem");
			console.log(">>>",obj);
		});
		$A.enqueueAction(action);
	}
})