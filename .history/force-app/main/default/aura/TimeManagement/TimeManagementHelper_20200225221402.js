({
    changeButtonStatus : function(component, event, helper) {
                var today = new Date();
                component.set('v.today', today);
                var action = component.get("c.getTimeManagement");
                action.setCallback(this, function(response){
                    if(response.getState() == "SUCCESS"){
                        console.log('>>>>',response.getReturnValue());
                        component.set("v.objTimeM", response.getReturnValue());
                        
                        var tmObject =   component.get("v.objTimeM");
                        console.log(tmObject.BOATBUILDING__Day_In__c);
                        if(typeof tmObject.BOATBUILDING__Day_In__c == "undefined"){
                            component.set("v.enableDayIn", false);
                        }
                        if(typeof tmObject.BOATBUILDING__Day_In__c != "undefined" && typeof tmObject.BOATBUILDING__Day_Out__c == "undefined"){
                            component.set("v.enableDayOut", false);
                            if(typeof tmObject.BOATBUILDING__Lunch_Out__c == "undefined"){
                                component.set("v.enableLunchOut", false);
                            }
                        }
                        if(typeof tmObject.BOATBUILDING__Day_In__c != "undefined" && typeof tmObject.BOATBUILDING__Day_Out__c == "undefined" && typeof tmObject.BOATBUILDING__Lunch_Out__c != "undefined"){
                            component.set("v.enableDayOut", false);
                            if(typeof tmObject.BOATBUILDING__Lunch_In__c == "undefined"){
                                component.set("v.enableLunchIn", false);
                            }
                        }
                        if(typeof tmObject.BOATBUILDING__Day_In__c != "undefined" && typeof tmObject.BOATBUILDING__Day_Out__c == "undefined" && typeof tmObject.BOATBUILDING__Lunch_Out__c != "undefined" && typeof tmObject.BOATBUILDING__Lunch_In__c != "undefined"){
                            
                            component.set("v.enableDayOut", false);
                        }
                    }
                });
                $A.enqueueAction(action);
                
    }
})
