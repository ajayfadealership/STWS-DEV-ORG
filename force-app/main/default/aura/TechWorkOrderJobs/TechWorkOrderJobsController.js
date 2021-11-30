({
    doInit : function(component, event, helper) {
        var objJob = component.get("v.objJob");
        console.log('Job Comp: ', objJob.BOATBUILDING__Completed__c + ' ' + objJob.BOATBUILDING__Job_Name__c );
        
        if(objJob.BOATBUILDING__Completed__c == true) {
            component.set("v.completed", true)
            component.set("v.clckInBTNDis", true);
            component.set("v.clckOutBTNDis", true);
        }
        if(objJob.BOATBUILDING__Time_Management__r != undefined && objJob.BOATBUILDING__Time_Management__r.length > 0) {
            var listTM = objJob.BOATBUILDING__Time_Management__r;
            console.log('Job TM: ', JSON.stringify(listTM)); 
            listTM.forEach(element => {
                if(element.BOATBUILDING__Clock_In__c != undefined && element.BOATBUILDING__Clock_Out__c == undefined 
                	&& !objJob.BOATBUILDING__Completed__c) {
                    component.set("v.tmId", element.Id);     
                    var d = parseInt(element.BOATBUILDING__Clock_In__c);
                    var dd = new Date(d); 
                    //var checkinTime = (dd.getMonth()+1)+"/"+dd.getDate()+"/"+dd.getFullYear()+" "+dd.getHours()+":"+dd.getMinutes()+":"+dd.getSeconds();
                    
                    var checkinTime = element.BOATBUILDING__Clock_In__c.replace(".000Z", "").split("T");
                    console.log('checkinTime: ', checkinTime);
                    var finalDate = checkinTime[0].split("-");
                    console.log('finalDate: ', finalDate);
                    var finalTM = checkinTime[1].split(".");
                    console.log('finalTM: ', finalTM);
                    var finalDT = finalDate[1]+'/'+finalDate[2]+'/'+finalDate[0]+' '+finalTM[0];
                    component.set("v.clckIn", finalDT); 
                    component.set("v.clckOut", "");
                    component.set("v.clckInBTNDis", true);
                    component.set("v.clckOutBTNDis", false);
                    component.set("v.objTMRec", element);
                } else if(element.BOATBUILDING__Clock_In__c != undefined && element.BOATBUILDING__Clock_Out__c == undefined && objJob.BOATBUILDING__Completed__c) {
                    component.set("v.objTMRec", element);
                    helper.clockOutHlpr(component);
                } else if(element.BOATBUILDING__Clock_In__c != undefined && element.BOATBUILDING__Clock_Out__c != undefined) {
                    component.set("v.tmId", element.Id); 
                }
            });
        }
    }, 
    clockIn : function(component, event, helper) {
        helper.clockInHlpr(component); 
    	$A.get('e.force:refreshView').fire();
    },
    clockOut : function(component, event, helper) {
        helper.clockOutHlpr(component);
        $A.get('e.force:refreshView').fire();
    },
    handleToggleChange : function(component, event, helper) {
        console.log(component.find("completeId").get("v.checked"));
        helper.handleToggleChangeHlpr(component);
        $A.get('e.force:refreshView').fire();
    },
    uplaodFinished : function(component, event, helper){
        var childCmp = component.find("photoCmp");
        childCmp.refreshChild();
    }
})