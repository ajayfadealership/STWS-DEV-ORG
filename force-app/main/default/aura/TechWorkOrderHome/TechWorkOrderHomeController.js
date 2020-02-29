({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'WOName', type: 'url', typeAttributes: { label: { fieldName: 'linkLabel' }, target: '_blank'}},
            {label: 'Customer Name', fieldName: 'CustomerName', type: 'text'},
            {label: 'Boat HIN', fieldName: 'BoatName', type: 'text'}
        ]);
        
        helper.loadDataTable(component, event, helper);
        helper.getCurrentUserHlpr(component, event, helper);
    },
    findWO : function(component, event, helper) {
        var selectedUser = component.get("v.objUserP");
        console.log('>>>>>>>>>>findWO: ',selectedUser); 
    },
    getWOList : function(component, event, helper){
        var action = component.get("c.getTechnicianJobByDate");
        action.setParams({"dateRange" : component.find("dateRange").get("v.value")});
        action.setCallback(this, function(res) {
            console.log('>>>>>:response value '+JSON.stringify(res.getReturnValue()));
            var rtnValue = res.getReturnValue();
                rtnValue.forEach(objVal => {
                    objVal.linkLabel =  objVal.WOName;
                    objVal.WOName = '/'+ objVal.WOId;
                    console.log(objVal);
                });
            component.set("v.WOList", rtnValue);
        });
        $A.enqueueAction(action);
        
    }

})