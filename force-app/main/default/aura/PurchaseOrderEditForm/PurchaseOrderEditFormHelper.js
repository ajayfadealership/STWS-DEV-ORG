({
    fetchManuHelper : function(component, event, strManuId, recId) {
        component.set("v.detailSection", false);
        component.set("v.showSpinner", true);
        var action= component.get("c.fetchManuDetailsApex");
        action.setParams({ 
            "strManuId": strManuId,
            "strPoId" : recId
        }); 
        action.setCallback(this,function(response) { 
            component.set("v.showSpinner", false);
            var state= response.getState();
            console.log(">>>>: "+JSON.stringify(response.getReturnValue()));
            console.log(response.getReturnValue()); 
            if (state === "SUCCESS") {
                component.set("v.objManu", response.getReturnValue()); 
                component.set("v.vendorVal", response.getReturnValue().Id); 
                component.set("v.detailSection", true);   
                console.log(component.get("v.detailSection"));
            } else {
                console.log('Error',response.getError());
                component.set("v.detailSection", true);  
                component.set("v.objManu", {'sobjectType': 'BOATBUILDING__Manufacturer__c'});
            }
        });
        $A.enqueueAction(action);
    },
    getLineItemHelper: function(component, recId) {
        var action = component.get("c.getLineItems"); 
        action.setParams({
            "strPOId" : recId 
        });
        action.setCallback(this, function(response) {
            if(response.getState() == "SUCCESS") {
                console.log(JSON.stringify(response.getReturnValue()));
                component.set("v.lineItems", response.getReturnValue());
                var total = 0.00;
                if(response.getReturnValue().length > 0) {
                    for(var i = 0; i < response.getReturnValue().length; i++) { 
                        total += parseFloat(response.getReturnValue()[i].Quantity * response.getReturnValue()[i].Cost);
                    }
                } 
                component.set("v.lineItemPopTotal", total);
            }
        });
        $A.enqueueAction(action);
    }
})