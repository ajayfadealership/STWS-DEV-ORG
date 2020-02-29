({
    doInit : function(component, event, helper) {
        var action = component.get("c.getHiearchySettings");
        action.setCallback(this, function(response){
            console.log('hey',response.getReturnValue().BOATBUILDING__Registration_Fee__c);
        	if(response.getState() === "SUCCESS") {
                var objDF = response.getReturnValue();
                if(objDF.BOATBUILDING__Doc_Fee__c != undefined && objDF.BOATBUILDING__Doc_Fee__c > 0)
	                objDF.BOATBUILDING__Doc_Fee__c = 0.00;
                if(objDF.BOATBUILDING__Registration_Fee__c != undefined && objDF.BOATBUILDING__Registration_Fee__c > 0)
    	            objDF.BOATBUILDING__Registration_Fee__c = 0.00;
                if(objDF.BOATBUILDING__Trailer_Registration_Fee__c != undefined && objDF.BOATBUILDING__Trailer_Registration_Fee__c > 0)
	                objDF.BOATBUILDING__Trailer_Registration_Fee__c = 0.00;
               component.set("v.customSettingSobj", objDF);
            }                           
        });
		$A.enqueueAction(action);
        var action = component.get("c.getState");
        action.setCallback(this, function(res) {
            if(res.getState() == "SUCCESS") {
                component.set("v.StateSelect", res.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    valChange: function(component, evt, hlp) {
        component.set("v.customSettingSobj", component.get("v.customSettingSobj"));
        var state = document.getElementById("regStateST").value;
        var objQt = component.get("v.ObjQuoteC");
        objQt.BOATBUILDING__State__c = state;
        component.set("v.ObjQuoteC", objQt);
    },
    updateState : function (component, evt, hlp){
		var state = document.getElementById("regStateST").value;
        var objQt = component.get("v.ObjQuoteC");
        objQt.BOATBUILDING__State__c = state;
        component.set("v.ObjQuoteC", objQt);
        if(state == "Other") {
            document.getElementById("manualTaxOption").style.display = "block";
        } else {
            document.getElementById("manualTaxOption").style.display = "none";
        }
    }
})