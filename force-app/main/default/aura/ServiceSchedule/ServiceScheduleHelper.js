({
    loadEvents : function(component, event, usrId, type, sLoca) {
        component.set("v.showSpinner", true);
        
        var lstUser = component.get("v.lstUser");
        console.log('lstUser: ',lstUser);
        var resources = [];
        lstUser.forEach(element => {
            var objRec = new Object();
            objRec.id = element.Id;
            objRec.title = element.Name;
            if(element.BOATBUILDING__Schedule_Color_Code__c != undefined) {   
                objRec.eventColor = element.BOATBUILDING__Schedule_Color_Code__c;
        }
        if(usrId == 'All' || usrId == element.Id) {
            resources.push(objRec);
        }
    });
    console.log('resources', resources);
    console.log('Script Loaded ',usrId, type);

    var action = component.get("c.fetchRelatedEvents");
    action.setParams({
        "strUserId" : usrId,
        "type" : type,
        "sLoca": sLoca
    });
    action.setCallback(this, function(response){
    component.set("v.showSpinner", false);
    console.log('Response', response.getReturnValue());
    var result = response.getReturnValue();
    var newEvents = []; 
    if(result != null & result.length > 0) {
        
        for(var i = 0; i < result.length; i++) {
            
            var evtId = "", evtTitle = "", evtStart = "", eventEnd = "";
            if(result[i].BOATBUILDING__Schedule_Date_Time__c != undefined) {
                evtId = result[i].Id;
                if(result[i].BOATBUILDING__Event_Name__c != undefined) { 
                    evtTitle = result[i].BOATBUILDING__Event_Name__c;
                }
                
                var dt = new Date(result[i].BOATBUILDING__Schedule_Date_Time__c);
                var endDate = new Date(result[i].BOATBUILDING__End_Schedule_Date_Time__c);
                
                var sh = dt.getHours();
                var sm = dt.getMinutes();
                var ss = dt.getSeconds();
                var eh = endDate.getHours();
                var em = endDate.getMinutes();                                  
                var es = endDate.getSeconds();
                evtStart = dt.getFullYear() + "-" + this.pad(dt.getMonth()+1) + "-" + this.pad(dt.getDate())+"T"+this.pad(sh)+":"+this.pad(sm)+":"+this.pad(ss); 
                eventEnd = endDate.getFullYear() + "-" + this.pad(endDate.getMonth()+1) + "-" + this.pad(endDate.getDate())+"T"+this.pad(eh)+":"+this.pad(em)+":"+this.pad(es); 
                var newEvent = new Object(eventEnd);
                newEvent.id = evtId;
                newEvent.title = evtTitle;
                newEvent.start = evtStart;
                newEvent.end = eventEnd; 
                newEvent.allDay = false;
                
                if(result[i].BOATBUILDING__Related_Work_Order_Job__c != undefined) {
                    if(result[i].BOATBUILDING__Related_Work_Order_Job__r.BOATBUILDING__Completed__c == true) {
                        newEvent.color = 'red';  
                        newEvent.textColor = 'white';  
                    } else {
                        newEvent.textColor = 'black';  
                    }
                } else  if(result[i].BOATBUILDING__Work_Order__c != undefined) {
                    
                    if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                       && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Closed' || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Closed Internal')) {
                        newEvent.color = 'red';
                    } else if(result[i].BOATBUILDING__Technician__c != undefined 
                              && result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c != undefined
                              &&	result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c != undefined) {
                        newEvent.color = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c;
                        newEvent.textColor = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c;
                    }else {
                        if(result[i].BOATBUILDING__Work_Order__r.RecordType.Name == 'Work Order') {
                            if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                               && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Waiting On Payment' 
                                   || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Warranty Waiting on Payment')) {
                                newEvent.color = 'yellow';
                                newEvent.textColor = 'black';
                            } else {    
                                newEvent.color = 'green';
                            }
                        } else if(result[i].BOATBUILDING__Work_Order__r.RecordType.Name == 'Warranty Work Order') { 
                            if(result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c != undefined 
                               && (result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Waiting On Payment' 
                                   || result[i].BOATBUILDING__Work_Order__r.BOATBUILDING__Status__c == 'Warranty Waiting on Payment')) {
                                newEvent.color = 'yellow';
                                newEvent.textColor = 'black';
                            } else {     
                                newEvent.color = 'blue';
                            }     
                            
                        }
                    } 
                    
                    
                    
                } else if(result[i].BOATBUILDING__Technician__c != undefined 
                          && result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c != undefined
                          &&	result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c != undefined) {
                    newEvent.color = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Color_Code__c;
                    newEvent.textColor = result[i].BOATBUILDING__Technician__r.BOATBUILDING__Schedule_Texted_Color_Code__c;
                } 
                newEvent.resourceId = result[i].BOATBUILDING__Technician__c; 
                newEvents.push(newEvent);
                //  $('#calendar').fullCalendar( 'renderEvent', newEvent );
            }
        }
        console.log('newEvents', newEvents);
        //$('#calendar').fullCalendar( 'destroy' );
    }
    
    var calendarEl = document.getElementById('calendar');
    var d1 = new Date();
    var calendar = new FullCalendar.Calendar(calendarEl, {
        schedulerLicenseKey: 'GPL-My-Project-Is-Open-Source',
        plugins: [ 'interaction', 'resourceDayGrid', 'resourceTimeGrid' ],
        defaultView: component.get("v.useMonthlyViewSchedule") ? 'dayGridMonth' : 'resourceTimeGridDay',
        defaultDate: d1,
        editable: true, 
        selectable: true,
        eventLimit: true, // allow "more" link when too many events
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'resourceTimeGridDay,resourceTimeGridTwoDay,timeGridWeek,dayGridMonth'
        },
        views: {
            resourceTimeGridTwoDay: {
                type: 'resourceTimeGrid',
                duration: { days: 2 },
                buttonText: '2 days',
            } 
        },
        //// uncomment this line to hide the all-day slot
        //allDaySlot: false,
        resources: resources
        , 
        events: newEvents
        ,
        select: function(arg) {
            console.log(
                'select',
                arg.startStr,
                arg.endStr,
                arg.resource ? arg.resource.id : '(No resource)'
            );
            
            component.set("v.RecordId", "");
            component.set("v.isModalOpen", true);
            var recId = arg.resource ? arg.resource.id : '';
            
            component.find("techId").set("v.value", recId);
            console.log(">>>>1: ",arg.startStr);
            console.log(">>>>2: ",arg.endStr);
            component.find("sDate").set("v.value", arg.startStr);
            component.find("eDate").set("v.value", arg.endStr);

            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
            
        },
        dateClick: function(arg) {
            console.log(
                'dateClick',
                arg.date,
                arg.resource ? arg.resource.id : '(No  resource)'
            );
            
            component.set("v.RecordId", "");
            component.set("v.isModalOpen", true);
            var recId = arg.resource ? arg.resource.id : '';
            
            component.find("techId").set("v.value", recId);
            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
        },
        eventClick: function(arg) {
            console.log(arg.event.id);
            component.set("v.RecordId", arg.event.id);
            component.set("v.isModalOpen", true);
            var open = component.get("v.isModalOpen");
            if (open == true) {
                var calendarEl = document.getElementsByClassName('desktop');
                console.log('>>>>calenIDCheck', calendarEl);
                calendarEl[0].setAttribute('style', 'overflow: hidden;');
            }
        },
        eventDrop: function(arg) {
            component.set("v.showSpinner", true);
            console.log("event: ",arg.event);
            console.log(">>>>1: ",arg.event.start);
            console.log(">>>>2: ",arg.event.end);
            console.log(">>>>resource: ",arg.event._def.resourceIds[0]);
            
            //2020-04-22T12:30:00
            var recId = arg.event._def.resourceIds[0] != undefined ? arg.event._def.resourceIds[0] : '';
            var startDateT = arg.event.start.getFullYear()+'-'+(arg.event.start.getMonth()+1)+'-'+arg.event.start.getDate()+'T'+arg.event.start.getHours()+':'+arg.event.start.getMinutes()+':00';
            console.log('>>>startDateT: ',startDateT);
            var endDateT = arg.event.end.getFullYear()+'-'+(arg.event.end.getMonth()+1)+'-'+arg.event.end.getDate()+'T'+arg.event.end.getHours()+':'+arg.event.end.getMinutes()+':00';
            console.log('>>>endDateT: ',endDateT);
            let userRol = component.get("v.UserRoleName");
            console.log('userRol: '+userRol);
            let userPer = [];
            userPer = component.get("v.lstPermission");
            console.log('userPer: '+userPer);
            if(userRol != 'GM' && !userPer.includes(userRol)) {

                var eventDetailAction = component.get("c.getEventStartDate");
                eventDetailAction.setParams({"strTMId" : arg.event.id});
                eventDetailAction.setCallback(this, function(resEveDetail) {
                    console.log('resEveDetail: ', resEveDetail.getReturnValue());
                    console.log('NewDate: ', parseInt(arg.event.start.getDate()));
                    if(resEveDetail.getReturnValue() != parseInt(arg.event.start.getDate())) {
                        component.set("v.showSpinner", false);
                        component.set("v.changeRecordId", arg.event.id);
                        component.set("v.changeStartDate", startDateT);
                        component.set("v.changeEndDate", endDateT);
                        component.set("v.changeRecId", recId);
                        component.set("v.reasonBool", true);
                        return;
                    } else {
                        component.set("v.showSpinner", true);
                        var action2 = component.get("c.updateEvent");
                        action2.setParams({ 
                            "strTMId" : arg.event.id,
                            "strStartDT" : startDateT, 
                            "strEndDT" : endDateT,
                            "strTechId" : recId
                        });
                        action2.setCallback(this, function(response2) {
                            component.set("v.showSpinner", false);
                            console.log('Response:  ', response2.getReturnValue());
                            if(response2.getReturnValue() == "SUCCESS") {
                                var eventSuccess = $A.get("e.force:showToast");
                                eventSuccess.setParams({
                                    "type" : "success",
                                    "title": "Success!",
                                    "message": "Event updated."
                                });
                                eventSuccess.fire();
                            } else {
                                var errorEvent = $A.get("e.force:showToast");
                                errorEvent.setParams({
                                    "type" : "error",
                                    "title": "Error!",
                                    "message": response2.getReturnValue()
                                });
                                errorEvent.fire();
                            }
                        });
                        $A.enqueueAction(action2);
                    }
                });
                $A.enqueueAction(eventDetailAction);
                
            } else {
                var action2 = component.get("c.updateEvent");
                action2.setParams({ 
                    "strTMId" : arg.event.id,
                    "strStartDT" : startDateT, 
                    "strEndDT" : endDateT,
                    "strTechId" : recId
                });
                action2.setCallback(this, function(response2) {
                    component.set("v.showSpinner", false);
                    console.log('Response:  ', response2.getReturnValue());
                    if(response2.getReturnValue() == "SUCCESS") {
                        var eventSuccess = $A.get("e.force:showToast");
                        eventSuccess.setParams({
                            "type" : "success",
                            "title": "Success!",
                            "message": "Event updated."
                        });
                        eventSuccess.fire();
                    } else {
                        var errorEvent = $A.get("e.force:showToast");
                        errorEvent.setParams({
                            "type" : "error",
                            "title": "Error!",
                            "message": response2.getReturnValue()
                        });
                        errorEvent.fire();
                    }
                });
                $A.enqueueAction(action2);
            }
        },
        eventResize: function(arg) {
            //component.set("v.showSpinner", true);
            console.log(">>>>1: ",arg.event.start);
            console.log(">>>>2: ",arg.event.end);
            console.log(">>>>2: ",arg.event);
            console.log(">>>>resource: ",arg.event._def.resourceIds[0]);
            //2020-04-22T12:30:00
            var recId = arg.event._def.resourceIds[0] != undefined ? arg.event._def.resourceIds[0] : '';
            var startDateT = arg.event.start.getFullYear()+'-'+(arg.event.start.getMonth()+1)+'-'+arg.event.start.getDate()+'T'+arg.event.start.getHours()+':'+arg.event.start.getMinutes()+':00';
            console.log('>>>startDateT: ',startDateT);
            var endDateT = arg.event.end.getFullYear()+'-'+(arg.event.end.getMonth()+1)+'-'+arg.event.end.getDate()+'T'+arg.event.end.getHours()+':'+arg.event.end.getMinutes()+':00';
            console.log('>>>endDateT: ',endDateT);
            var action2 = component.get("c.updateEvent");
            action2.setParams({ 
                "strTMId" : arg.event.id,
                "strStartDT" : startDateT, 
                "strEndDT" : endDateT,
                "strTechId" : recId
            });
            action2.setCallback(this, function(response2) {
                //component.set("v.showSpinner", false);
                console.log('Response:  ', response2.getReturnValue());
                if(response2.getReturnValue() == "SUCCESS") {
                    var eventSuccess = $A.get("e.force:showToast");
                    eventSuccess.setParams({
                        "type" : "success",
                        "title": "Success!",
                        "message": "Event updated."
                    });
                    eventSuccess.fire();
                } else {
                    var errorEvent = $A.get("e.force:showToast");
                    errorEvent.setParams({
                        "type" : "error",
                        "title": "Error!",
                        "message": response2.getReturnValue()
                    });
                    errorEvent.fire();
                }
            });
            $A.enqueueAction(action2);
        } 
    });
    
    calendar.render();
});
$A.enqueueAction(action);

},
    pad : function(val) {
        var valString = val + "";
        if(valString.length < 2) {
            return "0" + valString;
        }
        else {
            return valString;
        } 
    }
})