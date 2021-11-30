({
    
    rerender : function(component, helper) {
       this.superRerender();
         var recordTypeId = component.get("v.pageReference").state.recordTypeId;
        component.set("v.selectedRecordId", recordTypeId);
       // helper.setRecordType(component, helper);
        //alert('recordTypeId afer'+recordTypeId);
       // Write your custom code here. 
    }
// Your renderer method overrides go here 

})