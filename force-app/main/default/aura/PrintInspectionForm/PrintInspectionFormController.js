({
	ClickMe : function(component, event, helper) {
		//alert(component.get("v.recordId"));
        
        setTimeout(function(){
           /*var urlEvent = $A.get("e.force:navigateToURL");
           var urlStr = "/apex/BOATBUILDING__ServiceIFPDF?Id="+component.get("v.recordId");
           urlEvent.setParams({
               "url": urlStr n
           });
           urlEvent.fire();
           $A.get("e.force:closeQuickAction").fire(); */
            window.open("/apex/BOATBUILDING__ServiceIFPDF?Id="+component.get("v.recordId"), '_blank');
       }, 100);
        
	}
})