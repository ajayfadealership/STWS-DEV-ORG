({
    getAllData : function(component, event, helper) {
        component.set("v.spinner", true); 
        var action = component.get("c.fetchInventory");
        action.setParams({
            "Type" : component.find("select").get("v.value"),
            "stage" : component.find("stage").get("v.value"),
            "year"  :  component.find("Year").get("v.value"),
            "Modle" :  component.find("Modle").get("v.value"),
            "BoatType" :  component.find("BoatType").get("v.value"),
            "Make" :  component.find("MakeId").get("v.value"),
            "StoreLoc" :  component.find("storeId").get("v.value")
            
        });
        //component.set("v.myBoolean",true);
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                var result = response.getReturnValue(); 
                // alert("From server: " + JSON.stringify(response.getReturnValue()));
                component.set("v.fetchData", response.getReturnValue());
                if(result == 0 ){
                    component.set("v.Message", true);
                }else {
                    component.set("v.Message", false);
                }
            }            
        });
        $A.enqueueAction(action);
    },
    getAllInventories : function(component, event, helper) {
        component.set("v.spinner", true); 
        var action = component.get("c.fetchAllInventories");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                var result = response.getReturnValue(); 
                component.set("v.fetchData", response.getReturnValue());
/*
                var invRecordType = [];
                var invStatus = [];
                var invYear = [];
                var invBoatType = [];
                var invMake = [];
                var invModel = [];
                var invStoreLocation = [];

                var mapInvRecordType = {};
                for(var i = 0; i < result.length; i++){
                    mapInvRecordType.key = result[i].RecordType.Name;
                }
                */
                if(result == 0 ){
                    component.set("v.Message", true);
                }else {
                    component.set("v.Message", false);
                }
            }            
        });
        $A.enqueueAction(action);
    },
})