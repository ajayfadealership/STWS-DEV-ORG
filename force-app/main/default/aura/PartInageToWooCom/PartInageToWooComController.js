({
	init : function(component, event, helper) {
		var PartId = component.get("v.recordId");
        var action = component.get("c.uploadImage");
        action.setParams({
            "strPartId": PartId
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            console.log(res);
            if(state == 'SUCCESS') {
                if(res.getReturnValue() == 'SUCCESS') {
                	var urlEvent = $A.get("e.force:navigateToURL");
                    var urlStr = "/"+PartId;
                    urlEvent.setParams({
                        "url": urlStr
                    });
                    urlEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        title: "Please Wait...",
                        message: "We have initiated the process.",
                        type: "success"
                        
                    });
                    
                    toastEvent.fire();
                } else { 

                    var urlEvent = $A.get("e.force:navigateToURL");
                    var urlStr = "/"+PartId;
                    urlEvent.setParams({
                        "url": urlStr
                    });
                    urlEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    
                    toastEvent.setParams({
                        title: "Error!",
                        message: res.getReturnValue(), 
                        type: "error"
                        
                    });
                    
                    toastEvent.fire();
                }
            } 
        })
        $A.enqueueAction(action);
	}
})