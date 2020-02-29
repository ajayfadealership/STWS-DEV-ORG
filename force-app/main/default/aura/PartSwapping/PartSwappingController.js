({
	ClickMe : function(component, event, helper) {

        setTimeout(function(){
           var urlEvent = $A.get("e.force:navigateToURL");
           var urlStr = "/apex/BOATBUILDING__PartSwappingForInventory?Id="+component.get("v.recordId");
           urlEvent.setParams({
               "url": urlStr
           });
           urlEvent.fire();
           $A.get("e.force:closeQuickAction").fire();
       }, 100);
        
	}
})