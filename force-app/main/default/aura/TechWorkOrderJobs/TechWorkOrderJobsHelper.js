({
    clockInHlpr : function(component) {
        component.set("v.showSpinner", true);
        var objJob = component.get("v.objJob");
        console.log("JOB RecordId: ", objJob.Id);
        var action = component.get("c.insertclockin");
        action.setParams({
            "JobId" :  objJob.Id
        }); 
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            console.log("Response: ",JSON.stringify(response.getReturnValue()));
            if(!JSON.stringify(response.getReturnValue()).includes("Error")) {
                var element = JSON.parse(response.getReturnValue()); 
                console.log(element.BOATBUILDING__Clock_In__c);
                if(element.BOATBUILDING__Clock_In__c != undefined) {
                    var d = parseInt(element.BOATBUILDING__Clock_In__c);
                    var dd = new Date(d); 
                    //var checkinTime = (dd.getMonth()+1)+"/"+dd.getDate()+"/"+dd.getFullYear()+" "+dd.getHours()+":"+dd.getMinutes()+":"+dd.getSeconds();
                    var checkinTime = element.BOATBUILDING__Clock_In__c.replace(".000Z", "").split("T");
                    var finalDate = checkinTime[0].split("-");
                    var finalTM = checkinTime[1].split(".");
                    var finalDT = finalDate[1]+'/'+finalDate[2]+'/'+finalDate[0]+' '+finalTM[0];
                    component.set("v.clckIn", finalDT);
                    component.set("v.clckOut", "");
                    component.set("v.clckInBTNDis", true);
                    component.set("v.clckOutBTNDis", false);
                    component.set("v.objTMRec", element); 
                } 
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    clockOutHlpr : function(component) { 
        component.set("v.showSpinner", true);
        var objJob = component.get("v.objJob");
        console.log("JOB RecordId: ", objJob.Id);
        var objTM = component.get("v.objTMRec");
        console.log("TM RecordId: ", objTM.Id);
        var action = component.get("c.updateclockout");
        action.setParams({
            "JobId" :  objJob.Id, "tmid" : objTM.Id
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            console.log("Response: ",JSON.stringify(response.getReturnValue()));
            var objTMRes = JSON.parse(response.getReturnValue());
            console.log(objTMRes.BOATBUILDING__Clock_Out__c);
            component.set("v.clckInBTNDis", false);
            component.set("v.clckOutBTNDis", true);
            if(objTMRes.BOATBUILDING__Clock_Out__c != undefined) {
                var d = parseInt(objTMRes.BOATBUILDING__Clock_Out__c);
                var dd = new Date(d);
                //var checkOutTime = (dd.getMonth()+1)+"/"+dd.getDate()+"/"+dd.getFullYear()+" "+dd.getHours()+":"+dd.getMinutes()+":"+dd.getSeconds();
                var checkinTime = objTMRes.BOATBUILDING__Clock_Out__c.replace(".000Z", "").split("T");
                var finalDate = checkinTime[0].split("-");
                var finalTM = checkinTime[1].split(".");
                var finalDT = finalDate[1]+'/'+finalDate[2]+'/'+finalDate[0]+' '+finalTM[0];
                component.set("v.clckOut", finalDT);
                if(!objJob.BOATBUILDING__Completed__c) {
                    component.set("v.clckInBTNDis", false);
                } else {
                    component.set("v.clckInBTNDis", true);
                }
                component.set("v.clckOutBTNDis", true);
                component.set("v.objTMRec", objTMRes); 
           }
        });
        $A.enqueueAction(action);
    },
    handleToggleChangeHlpr : function(component) { 
        component.set("v.showSpinner", true);
        var objJob = component.get("v.objJob");
        console.log("JOB RecordId: ", objJob.Id);
        var toggleVal = objJob.BOATBUILDING__Completed__c;
        console.log("toggleVal", toggleVal);

        var action = component.get("c.completeToggle");
        action.setParams({
            "strRecId" :  objJob.Id, "ischecked" : toggleVal
        }); 
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            console.log("Response: ",JSON.stringify(response.getReturnValue()));
            if(response.getReturnValue() != 'SUCCESS') {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            } else {
                var cIN = component.get("v.clckIn"); 
                var cOut = component.get("v.clckOut");
                if(!toggleVal) {
                    component.set("v.clckInBTNDis", false);
                    component.set("v.clckOutBTNDis", true);
                    component.set("v.clckIn", "");
                    component.set("v.clckOut", "");
                } else {
                    component.set("v.clckInBTNDis", true);
                    component.set("v.clckOutBTNDis", true);
                }
                if(toggleVal && cIN != '' && cOut == '') {
                    this.clockOutHlpr(component);
                    
                }
            }
        });
        $A.enqueueAction(action); 
    }
})