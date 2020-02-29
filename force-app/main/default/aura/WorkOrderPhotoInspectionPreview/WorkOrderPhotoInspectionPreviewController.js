({
	doInit : function(component, event, helper) {
		var recordId = component.get("v.recordId");
        var action = component.get("c.getWOPhotoFiles");
        //alert(recordId);
        action.setParams({
            "WOID" :  recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
           // alert('alert');
            console.log('valueee',response.getReturnValue())
            if(state === "SUCCESS"){
                component.set("v.fileList", response.getReturnValue());
                console.log('valueee',response.getReturnValue())
            }
        });
        $A.enqueueAction(action);
	}
})