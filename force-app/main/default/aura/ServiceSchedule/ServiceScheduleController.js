({
    doInit: function (component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('userId>>>; ', userId);
        component.set("v.selectedUser", userId);
        component.set("v.currentUser", userId);
        var actionUserInfo = component.get("c.getUserInfo");
        actionUserInfo.setCallback(this, function (response) {
            console.log('actionUserInfo ', response.getReturnValue().UserRole.Name);
            component.set("v.UserRoleName", response.getReturnValue().UserRole.Name);

            var actionRolPermission = component.get("c.getSchedulePermission");
            actionRolPermission.setCallback(this, function (responsePer) {
                console.log('actionRolPermission ', responsePer.getReturnValue());
                component.set("v.lstPermission", responsePer.getReturnValue());
            });
            $A.enqueueAction(actionRolPermission);

        });
        $A.enqueueAction(actionUserInfo);
        var actionRec = component.get("c.getrecordType");
        actionRec.setCallback(this, function (response) {
            console.log('recordTypeId ', response.getReturnValue());
            component.set("v.recordTypeId", response.getReturnValue());
        });
        $A.enqueueAction(actionRec);

        var action = component.get("c.getUsersSLocation");
        action.setCallback(this, function (response) {
            console.log('sLocation ', response.getReturnValue());
            component.set("v.sLocation", response.getReturnValue());
        });
        $A.enqueueAction(action);

        var action2 = component.get("c.getUseMonthlyViewInScheduleValue");
        action2.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('useMonthlyViewSchedule ', response.getReturnValue());
                component.set("v.useMonthlyViewSchedule", response.getReturnValue());
            }
        });
        $A.enqueueAction(action2);
    },
    filterUserViaSL: function (component, event, helper) {
        var location = component.get("v.slLoca");
        component.set("v.selectedUser", 'All');
        var action = component.get("c.getUserList");
        action.setParams({
            "sLoaction": location
        });
        action.setCallback(this, function (response) {
            console.log('User List Response ', response.getReturnValue());
            component.set("v.lstUser", response.getReturnValue());
            var selectedUser = component.get("v.selectedUser");
            var slLoca = component.get("v.slLoca");
            var typeP = component.get("v.typeP");
            var calendarEl = document.getElementById('calendar');
            calendarEl.innerHTML = '';
            var slLoca = component.get("v.slLoca");
            helper.loadEvents(component, event, selectedUser, typeP, slLoca);

            var action2 = component.get("c.getUserListSLGroup");
            action2.setParams({
                "sLoaction": location
            });
            action2.setCallback(this, function (response2) {
                console.log('User List Response Group: ', response2.getReturnValue());
                component.set("v.lstUserGrp", response2.getReturnValue());
            });
            $A.enqueueAction(action2);

        });
        $A.enqueueAction(action);
    },
    scriptsLoaded: function (component, event, helper) {
        var location = component.get("v.slLoca");
        var action = component.get("c.getUserList");
        action.setParams({
            "sLoaction": location
        });
        action.setCallback(this, function (response) {
            console.log('User List Response ', response.getReturnValue());
            component.set("v.lstUser", response.getReturnValue());
            var selectedUser = component.get("v.selectedUser");
            var typeP = component.get("v.typeP");
            var calendarEl = document.getElementById('calendar');
            calendarEl.innerHTML = '';
            var slLoca = component.get("v.slLoca");
            helper.loadEvents(component, event, selectedUser, typeP, slLoca);

            var action2 = component.get("c.getUserListSLGroup");
            action2.setParams({
                "sLoaction": location
            });
            action2.setCallback(this, function (response2) {
                console.log('User List Response Group: ', response2.getReturnValue());
                component.set("v.lstUserGrp", response2.getReturnValue());
                var userId = $A.get("$SObjectType.CurrentUser.Id");
                console.log('userId>>>; ', userId);
                component.set("v.selectedUser", userId);
            });
            $A.enqueueAction(action2);

        });
        $A.enqueueAction(action);

    },
    openModel: function (component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.RecordId", "");
        component.set("v.isModalOpen", true);
    },

    closeModel: function (component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        component.find("techId").set("v.value", "");
        component.set("v.RecordId", "");
        var open = component.get("v.isModalOpen");
        if (open == false) {
            var calendarEl = document.getElementsByClassName('desktop');
            console.log('>>>>calenIDCheck', calendarEl);
            calendarEl[0].setAttribute('style', 'overflow: scroll-y;');
        }
        //component.find("sDate").set("v.value", "");
        //component.find("eDate").set("v.value", "");
    },

    submitDetails: function (component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        component.find("techId").set("v.value", "");
        component.set("v.isModalOpen", false);
        component.set("v.RecordId", "");
    },
    onRecordSuccess: function (component, event, helper) {
        console.log('Success');
        component.set("v.type", 'Work Order/Jobs');
        var payload = event.getParams().response;
        console.log(payload.id);
        component.set("v.showSpinner", true);
        var action = component.get("c.updateTechOnALlJobs");
        action.setParams({
            strTMId: payload.id
        });
        action.setCallback(this, function (response) {
            component.set("v.showSpinner", false);
            if (response.getReturnValue().includes("Error")) {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": response.getReturnValue()
                });
                errorEvent.fire();
            } else {
                var event = $A.get("e.force:showToast");
                event.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Event created."
                });
                event.fire();
                component.set("v.isModalOpen", false);
                var selectedUser = component.get("v.selectedUser");
                var typeP = component.get("v.typeP");
                var calendarEl = document.getElementById('calendar');
                calendarEl.innerHTML = '';
                var slLoca = component.get("v.slLoca");
                helper.loadEvents(component, event, selectedUser, typeP, slLoca);
            }
        });
        $A.enqueueAction(action);
    },
    updateCustomerlookup: function (component, event, helper) {
        var type = component.find("type").get("v.value");
        if (type == 'Pickup' || type == 'Drop') {
            component.set("v.isPD", true);
        } else {
            component.set("v.isPD", false);
        }
    },
    getRelatedTMDetails: function (component, event, helper) {
        var selectedUser = component.get("v.selectedUser");
        var typeP = component.get("v.typeP");
        var calendarEl = document.getElementById('calendar');
        calendarEl.innerHTML = '';
        var slLoca = component.get("v.slLoca");
        helper.loadEvents(component, event, selectedUser, typeP, slLoca);
    },
    dateTileValueChange: function (component, event, helper) {
        var dateVal = component.find("sDate").get("v.value");
        console.log("Schedule dateVal ", dateVal);
        var tmpDate = new Date(dateVal);
        console.log("Schedule tmpDate ", tmpDate);
        //component.find("eDate").set("v.value", dateVal);
    },
    opeWO: function (component, event, helper) {
        var recId = component.get("v.RecordId");
        console.log('recId ', recId);
        var action = component.get("c.openWO");
        action.setParams({
            strTMId: recId
        });
        action.setCallback(this, function (response) {
            if (!response.getReturnValue().includes("NONE")) {
                window.open("/" + response.getReturnValue(), '_blank');
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": 'There is no Work Order or Work Order Job attached.'
                });
                errorEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    deleteEventJS: function (component, event, helper) {
        let userRol = component.get("v.UserRoleName");
        console.log('userRol: '+userRol);
        let userPer = [];
        userPer = component.get("v.lstPermission");
        console.log('userPer: '+userPer);
        if(userRol != 'GM' && !userPer.includes(userRol)) {
            component.set("v.changeRecordId", component.get("v.RecordId"));
            component.set("v.isModalOpen", false);
            component.set("v.delBool", true);
            return;
        }

        var recId = component.get("v.RecordId");
        var action = component.get("c.deleteEvent");
        action.setParams({
            strTMId: recId
        });
        action.setCallback(this, function (response) {
            console.log(response.getReturnValue());
            if (response.getState() == 'SUCCESS') {
                var event = $A.get("e.force:showToast");
                event.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Event is De-Scheduled."
                });
                event.fire();
                component.set("v.isModalOpen", false);
                var selectedUser = component.get("v.selectedUser");
                var typeP = component.get("v.typeP");
                var calendarEl = document.getElementById('calendar');
                calendarEl.innerHTML = '';
                var slLoca = component.get("v.slLoca");
                helper.loadEvents(component, event, selectedUser, typeP, slLoca);
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": 'Error!, ' + response.getReturnValue()
                });
                errorEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleError: function (component, event, helper) {
        var errors = event.getParams();
        console.log("response", JSON.stringify(errors));
        var errorEvent = $A.get("e.force:showToast");
        errorEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": JSON.stringify(errors)
        });
        errorEvent.fire();
    },
    closeChangePopup: function (component, event, helper) {
        component.set("v.reasonBool", false);
        component.set("v.delBool", false);
        var selectedUser = component.get("v.selectedUser");
        var typeP = component.get("v.typeP");
        var calendarEl = document.getElementById('calendar');
        calendarEl.innerHTML = '';
        var slLoca = component.get("v.slLoca");
        helper.loadEvents(component, event, selectedUser, typeP, slLoca);
    },
    handleSuccessChnage: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var payload = event.getParams().response;
        console.log(payload.id);
        let recordId = payload.id;
        let changeStartDate = component.get('v.changeStartDate');
        let changeEndDate = component.get('v.changeEndDate');
        let changeRecId = component.get('v.changeRecId');
        var action2 = component.get("c.updateEvent");
        action2.setParams({
            "strTMId": recordId,
            "strStartDT": changeStartDate,
            "strEndDT": changeEndDate,
            "strTechId": changeRecId
        });
        action2.setCallback(this, function (response2) {
            component.set("v.showSpinner", false);
            console.log('Response:  ', response2.getReturnValue());
            if (response2.getReturnValue() == "SUCCESS") {
                var eventSuccess = $A.get("e.force:showToast");
                eventSuccess.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Event updated."
                });
                eventSuccess.fire();
            } else {

                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": response2.getReturnValue()
                });
                errorEvent.fire();
                var selectedUser = component.get("v.selectedUser");
                var typeP = component.get("v.typeP");
                var calendarEl = document.getElementById('calendar');
                calendarEl.innerHTML = '';
                var slLoca = component.get("v.slLoca");
                helper.loadEvents(component, event, selectedUser, typeP, slLoca);
            }
            component.set("v.reasonBool", false);
        });
        $A.enqueueAction(action2);
    },
    handleDelSuccessChnage: function (component, event, helper) {
        var recId = component.get("v.changeRecordId");
        var action = component.get("c.deleteEvent");
        action.setParams({
            strTMId: recId
        });
        action.setCallback(this, function (response) {
            console.log(response.getReturnValue());
            if (response.getState() == 'SUCCESS') {
                var event = $A.get("e.force:showToast");
                event.setParams({
                    "type": "success",
                    "title": "Success!",
                    "message": "Event is De-Scheduled."
                });
                event.fire();
                component.set("v.delBool", false);
                var selectedUser = component.get("v.selectedUser");
                var typeP = component.get("v.typeP");
                var calendarEl = document.getElementById('calendar');
                calendarEl.innerHTML = '';
                var slLoca = component.get("v.slLoca");
                helper.loadEvents(component, event, selectedUser, typeP, slLoca);
            } else {
                var errorEvent = $A.get("e.force:showToast");
                errorEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": 'Error!, ' + response.getReturnValue()
                });
                errorEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})