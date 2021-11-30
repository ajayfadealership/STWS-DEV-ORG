({ 
    doInit : function(component, event, helper) {
        var actions = [
            { label: 'Details', name: 'details' }];
        component.set('v.mycolumns', [
            {label: 'Boat Name', fieldName: 'BoatName', type: 'text',sortable: true,visible:true},
            {label: 'Manufacture', fieldName: 'MakeString', type: 'text',sortable: true},
            {label: 'ModelYear', fieldName: 'ModelYear', type: 'Number',sortable: true},
            {label: 'Model', fieldName: 'Model', type: 'text ',sortable: true},
            {type: 'button',label: 'Action', typeAttributes: { rowActions: action,label: 'Add to Inventory',
                                                              name: 'AddUsedInventory',
                                                              variant: 'base',
                                                              disabled: false}},
            {type: 'button',label: 'View', typeAttributes: { rowActions: action,label:'View', iconName: 'utility:preview',
                                                            name: 'viewDetail',
                                                            variant: 'base',
                                                            disabled: false}}
            
        ]);
        var action = component.get("c.getBoatInfo");
        action.setCallback(this ,function(response){          
            if(response.getState() === "SUCCESS"){
                // alert('Great Going');
                var result = JSON.parse(response.getReturnValue()).results;
                console.log('result',result);
                //console.log(JSON.parse(result));
                //alert(result);
                component.set("v.Boat",result);
                component.set("v.BoatCopy",result);
                component.set("v.NameClicked",false);
                helper.sortData( component, component.get( "v.sortBy" ), component.set( "v.sortDirection" ) );
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    AddUsedInventory:  function(component, event, helper){
        alert('testing');
    },
    
    searchData : function(component, event, helper){
        var toSearch = component.get("v.searchSTR");
        
        if(toSearch.length > 1){
            //alert(toSearch);
            var results = [];
            var objects = component.get("v.BoatCopy");
            console.log('objectssssss',objects);
            for(var i=0; i<objects.length; i++) {
                console.log('inside first for'+toSearch,objects[i]);
                var jsonString =  JSON.stringify(objects[i].BoatName + '%'+objects[i].MakeString
                                                 +'%'+objects[i].ModelYear+'%'+objects[i].Model).toLowerCase();
                console.log('jsonString',jsonString);
                console.log('jsonStringase)',jsonString.search(toSearch.toLowerCase()));
                if(jsonString.search(toSearch.toLowerCase()) != -1) {
                    results.push(objects[i]);
                }
            }  
            console.log('resultss',results) ;
            component.set("v.Boat", results);
        }
        if(toSearch == ''){
            console.log('resultss--------',results) ;
            component.set("v.Boat",component.get("v.BoatCopy"));
        }
        
    },
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam('fieldName');
        //returns the direction of sorting like asc or desc
        var sortDirection =event.getParam('sortDirection');
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    },
    closeModel: function(component, event, helper) {
         console.log('closed');
      component.set("v.isOpen", false);
    },
    viewInventory: function(component, event, helper) {
        console.log('viewInventoryFunction');
        var InvId = component.get("v.currentInventoryId");
         window.open('/' +InvId); 
         component.set("v.isOpen", false);
      //  var navEvt = $A.get("e.force:navigateToSObject");
      /*  navEvt.setParams({
            "recordId": InvId,
            "slideDevName": "detail"
            
        });
        navEvt.fire(); */
    }, 
    
    handleClick:function(component, event, helper) {
        component.set("v.isloaded", true);
        console.log(event.getParam( 'action' ).name);
        console.log('documentID',event.getParam( 'row').DocumentID);
        var docId = event.getParam( 'row').DocumentID;
        var actionName = event.getParam( 'action' ).name;
        if(actionName == 'AddUsedInventory'){
            console.log('>>>>docId'+docId);
            var action2 = component.get("c.addUsedInventory");
            action2.setParams({
                "id" : docId
            });
            action2.setCallback(this ,function(response){    
                component.set("v.isloaded", false);
                if(response.getState() === "SUCCESS"){
                    var result = response.getReturnValue();
                    console.log('inventory Id ',result);
                    if(result.includes('unableToAddInventory')){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Error',
                            message: 'Sorry Something went wrong!',
                            duration:' 5000',
                            key: 'info_alt',
                            type: 'error',
                            mode: 'pester'
                        });
                        toastEvent.fire(); 
                    }
                    else{
                        component.set("v.currentInventoryId", result);
                          component.set("v.isOpen", true);
                    }
                    
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Sorry Something went wrong!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action2);
        }
        if(actionName == 'viewDetail'){
            component.set("v.isloaded", false);
            var row = event.getParam( 'row');
            var recId = row.DocumentID;
            helper.viewCurrentRecord(component,recId);
        }
        var action = event.getParam( 'action' );
        var row = event.getParam( 'row');
        /*  switch (action.name) {
            case 'details':
                //alert(row.DocumentID);
                // Do whatever you want with rowID
                var recId = row.DocumentID;
                helper.viewCurrentRecord(component,recId);
                break;
        }
        */
    }
    
})