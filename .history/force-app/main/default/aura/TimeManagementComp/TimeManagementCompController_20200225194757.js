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
                if(typeof tmObject.Day_In__c == "undefined"){
                    component.set("v.enableDayIn", true);
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined"){
                    component.set("v.enableDayOut", true);
                    if(typeof tmObject.Lunch_Out__c == "undefined"){
                        component.set("v.enableLunchOut", true);
                    }
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined" && typeof tmObject.Lunch_Out__c != "undefined"){
                    component.set("v.enableDayOut", true);
                    if(typeof tmObject.Lunch_In__c == "undefined"){
                        component.set("v.enableLunchIN", true);
                    }
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined" && typeof tmObject.Lunch_Out__c != "undefined" && typeof tmObject.Lunch_In__c != "undefined"){
                    
                    component.set("v.enableDayOut", true);
                }
            }
        });
         $A.enqueueAction(action);

    }
})