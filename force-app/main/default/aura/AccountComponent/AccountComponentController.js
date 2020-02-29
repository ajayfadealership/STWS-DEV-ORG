({
	changeToggle : function(component, event, helper) {
		var isChecked = component.find('inputToggle').get('v.checked');
        if(isChecked) {
            document.getElementById("newCustomerDiv").style.display ="block";
            document.getElementById("existingCustomerDiv").style.display ="none";
        }
        else {
            document.getElementById("newCustomerDiv").style.display ="none";
            document.getElementById("existingCustomerDiv").style.display ="block";
        }
       
	}, 
    handleRecordSelectEvent : function( component, event, helper)
    {
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
        var id =  component.get("v.selectedRecord");
        console.log("value", id);
    }
})