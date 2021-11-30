({

	getProductPriceFromInv : function(component, event, helper) {
		var InvId = component.get('v.objInvW').objInv.Id;
        //alert(InvId);
        //InvIdCC
        //qtSpinnerWiz
        helper.invClickHelper(component, event, InvId);
    },
    handelRedirection: function(component, event, helper) {
        var invId = event.getParam("invId");
        console.log('HandII: '+invId);
        if(invId != '0') {
            helper.invClickHelper(component, event, invId);
        }    
    }
})