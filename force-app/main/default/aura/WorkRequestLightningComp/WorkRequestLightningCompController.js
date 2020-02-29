({
    getRecordTypeId: function(component, event, helper) {
        var action = component.get("c.getRecTypeId");
        action.setCallback(this, function(response) {
            component.set("v.attrRecordType", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    backToList: function(component, event, helper) {
        component.set("v.showform", false);
        component.set("v.showlist", true);
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(payload.id);
        var errorEvent = $A.get("e.force:showToast");
        errorEvent.setParams({ 
            "type" : "success",
            "title": "Success!",
            "message": "Work Request Created."
        });
        errorEvent.fire(); 
        component.set("v.showform", false);
        component.set("v.showlist", true);
        var action = component.get("c.cpOfWR");
        action.setParams({
            wrId : payload.id
        });
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
        });
       //$A.enqueueAction(action);
    },
    handleOnSubmit : function(component, event, helper) {
   
        //storeLocId
    },
    handleError : function(component, event, helper){

    },
    saveWorkRequest : function(component, event, helper) {
        var wrkRequetDes = component.find("WrkReqDesId").get("v.value");
        var srtloc = component.find("storeLocId").get("v.value");
       
        var isError = false;
            var errorMessage = '';
        if(wrkRequetDes == null || wrkRequetDes == ""){
            isError = true;
            errorMessage = 'Please Add Work Description.';
        } 
        if(srtloc == null || srtloc == ""){
            isError = true;
            errorMessage = 'Please select Store Location.';
        } 
        if(!isError) { 
            component.find("recordEditForm").submit();
             var toastEvent = $A.get("e.force:showToast");
       
        } else {
            var errorEvent = $A.get("e.force:showToast");
            errorEvent.setParams({
                "type" : 'error',
                "title": "Error!",
                "message": errorMessage
            });
            errorEvent.fire();
        }
    },
    getItemDetails : function(component, event, helper) { 
        console.log("Method Check");
        var itemId = component.find("item").get("v.value");
        console.log("itemId", itemId);
        if(itemId != undefined && itemId != null) {
            helper.getItemDetailsHelper(component, itemId);
        } else {
            var obj = new Object();
            component.set("v.objItem", obj);
        }
    }
})