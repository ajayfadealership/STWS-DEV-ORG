({
	changeToggle : function(component, event, helper) {
		var isChecked = component.find('inputToggle').get('v.checked');
        if(isChecked)
        {
            document.getElementById("newACVDiv").style.display ="block";
            document.getElementById("existingACVDiv").style.display ="none";
        }
        else
        {
            document.getElementById("newACVDiv").style.display ="none";
            document.getElementById("existingACVDiv").style.display ="block";
        }
       
	}
})