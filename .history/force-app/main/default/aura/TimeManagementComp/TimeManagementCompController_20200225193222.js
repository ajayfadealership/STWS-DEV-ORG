({
    init : function(component, event, helper) {
        //var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var today = new Date();
        component.set('v.today', today);
        var action = component.get("c.getTimeManagement");
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS"){
                console.log('>>>>',response.getReturnValue());
                component.set("v.objTimeM", response.getReturnValue());
                var tmObject = response.getReturnValue();
                console.log(tmObject.Day_In__c);
            }
            
        });
         $A.enqueueAction(action);

    }
})