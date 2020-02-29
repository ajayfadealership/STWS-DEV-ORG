({
    HandelPPEvent: function(component, event, helper) {
        var retMessagePP = event.getParam("lstPriceAndProductOptionWraperClassPPE");
        component.set('v.newPLstPriceAndProductOptionWraperClass', retMessagePP);
    },
    HandelDOEvent: function(component, event, helper) {
        console.log('RUN');
        console.log(event.getParam("newPLstDealerOptionWraper"));
        var retMessageDE = event.getParam("newPLstDealerOptionWraper");
        component.set('v.newPLstDealerOptionWraper', retMessageDE);
    },
    displayDOPopup: function(component, event, helper) {
    	document.getElementById("doId").style.display = 'block';
	},
    handelBlank: function(component, event, helper) {
        console.log('Blank');
        var ProductPriceIdListCCCCBlank = component.get("v.ProductPriceIdListCCCBlank");
        component.set("v.ProductPriceIdListCCC", ProductPriceIdListCCCCBlank);
    }
 })