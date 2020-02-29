({
	ClickMe : function(component, event, helper) {
		 
		$A.get("e.force:closeQuickAction").fire(); 
        window.open("/apex/BOATBUILDING__WOToService?Id="+component.get("v.recordId"));
        window.open("/"+component.get("v.recordId"),"_self");        
        /*setTimeout(function(){ 
           var urlEvent = $A.get("e.force:navigateToURL");
           var urlStr = "/apex/BOATBUILDING__WOToService?Id="+component.get("v.recordId");
           urlEvent.setParams({
               "url": urlStr 
           });
           urlEvent.fire();
           $A.get("e.force:closeQuickAction").fire();
       }, 100);*/
	}
})