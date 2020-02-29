({
    changeButtonStatus : function(component, event, helper) {
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
})
