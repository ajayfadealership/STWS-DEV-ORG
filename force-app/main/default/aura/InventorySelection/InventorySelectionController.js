({
	changeToggle: function(component, event, helper) {
		var isChecked = component.find('inputToggleInv').get('v.checked');
        if(isChecked) {
            component.set('v.ProIdC', "0");
            document.getElementById("hiddenTypeForSearchCheck").value = "InventorySearch"
            document.getElementById("ExistigInvList").style.display ="block";
            document.getElementById("newInvCreate").style.display ="none";
        } else {
            component.set('v.InvIdC', "0");
            document.getElementById("hiddenTypeForSearchCheck").value = "NewProduct"
            document.getElementById("ExistigInvList").style.display ="none";
            document.getElementById("newInvCreate").style.display ="block";
        }
       
	},
    getInventoryLst: function(component, event, helper) {
        
        var keyWrd = document.getElementById("invSearchInpText").value;
        console.log('keyWrd: '+keyWrd);
        var action = component.get("c.getInvList");
        action.setParams({
            "KeyWord": keyWrd
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                
                component.set('v.InvLstAfterSearch', res.getReturnValue());
                if(res.getReturnValue().length > 0) {
                	document.getElementById('InvListResult').style.display = 'block';    
                } else {
                    document.getElementById('InvListResult').style.display = 'none';
                }
            }  
        })
        $A.enqueueAction(action);
    }
})