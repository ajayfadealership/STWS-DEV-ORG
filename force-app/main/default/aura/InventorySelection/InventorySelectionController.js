({
    doInit: function(component, event, helper) {
        console.log(">>>>>: "+ component.get("v.InvIdC"));
        /*if(component.get("v.InvIdC") != '0') {
            component.find('inputToggleInv').set('v.checked', true);
            console.log("<><>: ", component.find('inputToggleInv').get('v.checked'));
            component.set('v.ProIdC', "0");
            document.getElementById("hiddenTypeForSearchCheck").value = "InventorySearch"
            document.getElementById("ExistigInvList").style.display ="block";
            document.getElementById("newInvCreate").style.display ="none";
        }*/
    },
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
    },
    handelRedirection: function(component, event, helper) {
        var invId = event.getParam("invId");
        console.log('Hand: '+invId);
        component.set("v.InvIdC", invId)
        if(component.get("v.InvIdC") != '0') {
            component.find('inputToggleInv').set('v.checked', true);
            console.log("<><>: ", component.find('inputToggleInv').get('v.checked'));
            component.set('v.ProIdC', "0"); 
            document.getElementById("ExistigInvList").style.display ="block";
            document.getElementById("hiddenTypeForSearchCheck").value = "InventorySearch"
            document.getElementById("ProductPriceSectionDiv").style.display ="block";
            document.getElementById("newInvCreate").style.display ="none";

            //var keyWrd = document.getElementById("invSearchInpText").value;
            //console.log('keyWrd: '+keyWrd);
            document.getElementById("qtSpinnerWiz").style.display = 'block';
            var action = component.get("c.getInvListId");
            action.setParams({
                "KeyWord": component.get("v.InvIdC")
            });
            action.setCallback(this, function(res) {
                document.getElementById("qtSpinnerWiz").style.display = 'none';
                var state = res.getState();
                console.log(res.getReturnValue());
                if(state == 'SUCCESS') {
                    
                    component.set('v.InvLstAfterSearch', res.getReturnValue());
                    if(res.getReturnValue().length > 0) {
                        document.getElementById('InvListResult').style.display = 'block';  
                        var cmpEventii = $A.get("e.c:InvRedirectionII");                
                        cmpEventii.setParams({ 
                        "invId": component.get("v.InvIdC")
                        }); 
                        cmpEventii.fire();  
                    } else {
                        document.getElementById('InvListResult').style.display = 'none';
                    }
                }  
            })
            $A.enqueueAction(action);

            
        }    
    }
})