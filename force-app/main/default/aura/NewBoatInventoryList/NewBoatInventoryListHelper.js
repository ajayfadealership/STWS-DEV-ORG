({
    getAllInventories : function(component, event, helper) {
        component.set("v.spinner", true); 
        var action = component.get("c.fetchAllInventories");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(response.getState() == "SUCCESS"){
                component.set("v.spinner", false);
                var result = response.getReturnValue(); 
                console.log('results', result);
                component.set("v.fetchData", response.getReturnValue());
                component.set("v.fetchDataLocal",response.getReturnValue());
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