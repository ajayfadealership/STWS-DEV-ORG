({
	ClickMe : function(component, event, helper) {
		//alert(component.get("v.recordId"));
        
        setTimeout(function(){
           var urlEvent = $A.get("e.force:navigateToURL");
           var urlStr = "/apex/BOATBUILDING__ScheduleInventory?type=inventory&invId="+component.get("v.recordId");
           urlEvent.setParams({
               "url": urlStr
           });
           urlEvent.fire();
           $A.get("e.force:closeQuickAction").fire();
       }, 100);
        
	}
})