({
    doInit : function(component, event, helper) {
        var action = component.get("c.getWOJRelatedToItem");
        action.setParams({
            "strWOId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            console.log("Response: "+response.getReturnValue());
            if(response.getState() === "SUCCESS"){
                component.set('v.columns', [
                    {label: 'Name', fieldName: 'linkName', type: 'url', 
                     typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}},
                    {label: 'Job Name', fieldName: 'BOATBUILDING__Job_Name__c', type: 'text'},
                    {label: 'Job Completed Date', fieldName: 'BOATBUILDING__Job_Completed_Date__c', type: 'date'}
                ]);
                var records =response.getReturnValue();
                records.forEach(function(record){
                    record.linkName = '/'+record.Id;
                });
                
                component.set('v.listWOJ', response.getReturnValue());
            }
        }); 
        $A.enqueueAction(action);
    }
})