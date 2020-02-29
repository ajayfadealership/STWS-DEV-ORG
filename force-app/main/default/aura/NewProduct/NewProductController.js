({
	getManufacturerDropDown : function(component, event, helper) {
		var SelectedType = document.getElementById("BoatTypeList").value;
        document.getElementById("BoatYearList").disabled = true;
        document.getElementById("BoatModelList").disabled = true;
        document.getElementById("BoatModelVariantList").disabled = true;
        document.getElementById("BoatYearList").value = '0';
        document.getElementById("BoatModelList").value = '0';
        document.getElementById("BoatModelVariantList").value = '0';
        component.set('v.ProIdCC', "0");
        if(SelectedType != '0') {
            document.getElementById("BoatManufacturerList").disabled = false;
        } else {
            document.getElementById("BoatManufacturerList").disabled = true;
        }
        var action = component.get("c.getManufacturer");
        action.setParams({
            "selectedType": SelectedType
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.ManuList', res.getReturnValue());
                
            }  
        })
        $A.enqueueAction(action);
	},
    
    getYearDropDown: function(component, event, helper) {
        var SelectedType = document.getElementById("BoatTypeList").value;
        var selectedManu = document.getElementById("BoatManufacturerList").value;
        component.set('v.ProIdCC', "0");
        document.getElementById("BoatModelList").disabled = true;
        document.getElementById("BoatModelVariantList").disabled = true;
        document.getElementById("BoatModelList").value = '0';
        document.getElementById("BoatModelVariantList").value = '0';
        
        if(selectedManu != '0') {
            document.getElementById("BoatYearList").disabled = false;
        } else {
            document.getElementById("BoatYearList").disabled = true;
        }
       
        var action = component.get("c.getYear");
        action.setParams({
           	"strManuId" : selectedManu,
            "selectedType" : SelectedType
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.YearList', res.getReturnValue());
            }  
        }) 
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getMVStatus");
        action1.setParams({
           	"strManuId" : selectedManu
        });
        action1.setCallback(this, function(res) { 
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.ModelVariantStatus', res.getReturnValue());
            }  
        })
        $A.enqueueAction(action1);
    },
    
    getModelDropDown: function(component, event, helper) {
        var SelectedType = document.getElementById("BoatTypeList").value;
        var selectedManu = document.getElementById("BoatManufacturerList").value;
		var selectedYear = document.getElementById("BoatYearList").value;
        var MVStatus = component.get('v.ModelVariantStatus');
        
        
        document.getElementById("BoatModelVariantList").disabled = true;
        document.getElementById("BoatModelVariantList").value = '0';
        component.set('v.ProIdCC', "0"); 
        if(selectedYear != '0') {
            document.getElementById("BoatModelList").disabled = false;
        } else {
            document.getElementById("BoatModelList").disabled = true;
        }
        
        var action = component.get("c.getModel");
        action.setParams({
            "selectedType" : SelectedType,
            "strManuId" : selectedManu,
            "selectedYear" : selectedYear,
            "MVStatus" : MVStatus
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.ModelList', res.getReturnValue());
            }  
        }) 
        $A.enqueueAction(action);
    }, 
    
    getModelVariant: function(component, event, helper) {
    	var SelectedType = document.getElementById("BoatTypeList").value;
        var selectedManu = document.getElementById("BoatManufacturerList").value;
		var selectedYear = document.getElementById("BoatYearList").value;
        var selectedModel = document.getElementById("BoatModelList").value;
        var MVStatus = component.get('v.ModelVariantStatus');
        
        
        console.log(MVStatus);
        if(selectedModel != '0' && MVStatus == '1') {
            document.getElementById("BoatModelVariantList").disabled = false;
            component.set('v.ProIdCC', "0");
        } else {
            document.getElementById("BoatModelVariantList").disabled = true;
            component.set('v.ProIdCC', selectedModel);
        }
        
        var action = component.get("c.getModelVariantApex");
        action.setParams({
            "selectedType" : SelectedType,
            "strManuId" : selectedManu,
            "selectedYear" : selectedYear,
            "selectedModel" : selectedModel
        });
        action.setCallback(this, function(res) {
            var state = res.getState();
            console.log(res.getReturnValue());
            if(state == 'SUCCESS') {
                component.set('v.ModelVList', res.getReturnValue());
            }  
        }) 
        $A.enqueueAction(action);
        
    },
    assignId: function(component, event, helper) { 
        var modVar = document.getElementById("BoatModelVariantList").value;
        component.set('v.ProIdCC', modVar);
    },
    searchProductPriceForNewProduct: function(component, event, helper) { 
        var SelectedType = document.getElementById("BoatTypeList").value;
        var selectedManu = document.getElementById("BoatManufacturerList").value;
		var selectedYear = document.getElementById("BoatYearList").value;
        var selectedModel = document.getElementById("BoatModelList").value;
        var selectedModelVariant = document.getElementById("BoatModelVariantList").value;
        var MVStatus = component.get('v.ModelVariantStatus');
        
        if(SelectedType == "Used Boat") {
            var urlEvent = $A.get("e.force:navigateToURL");
            window.onbeforeunload = null;
            urlEvent.setParams({
                "url": '/apex/BOATBUILDING__UsedBoatForm'
            });
            urlEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
            return;
        }
        
        if(SelectedType != '0' && selectedManu != '0' && selectedYear != '0' && selectedModel != '0') {
            if(MVStatus == '0' && (selectedModelVariant != '0' || selectedModelVariant == '0')) {
                helper.getProductPrice(component, SelectedType, selectedManu, selectedYear, selectedModel, selectedModelVariant, MVStatus);
                helper.getProductPricing(component, event,selectedModel);
            } else if(MVStatus == '1' && selectedModelVariant != '0') {
                helper.getProductPrice(component, SelectedType, selectedManu, selectedYear, selectedModel, selectedModelVariant, MVStatus);
                helper.getProductPricing(component, event,selectedModelVariant); 
            } else { 
                alert('Please select model variant.');
            }
        } else {
            alert('Please select all options.');
        } 
    }
})