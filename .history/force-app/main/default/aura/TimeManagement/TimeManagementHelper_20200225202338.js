({
    changeButtonStatus : function(component, event, helper) {
                var tmObject =   component.get("v.objTimeM");
                console.log(tmObject.Day_In__c);
                if(typeof tmObject.Day_In__c == "undefined"){
                    component.set("v.enableDayIn", false);
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined"){
                    component.set("v.enableDayOut", false);
                    if(typeof tmObject.Lunch_Out__c == "undefined"){
                        component.set("v.enableLunchOut", false);
                    }
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined" && typeof tmObject.Lunch_Out__c != "undefined"){
                    component.set("v.enableDayOut", false);
                    if(typeof tmObject.Lunch_In__c == "undefined"){
                        component.set("v.enableLunchIN", false);
                    }
                }
                if(typeof tmObject.Day_In__c != "undefined" && typeof tmObject.Day_Out__c == "undefined" && typeof tmObject.Lunch_Out__c != "undefined" && typeof tmObject.Lunch_In__c != "undefined"){
                    
                    component.set("v.enableDayOut", false);
                }
    }
})
