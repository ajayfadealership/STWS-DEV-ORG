({
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    onok : function(component, event, helper) {
        console.log(component.get("v.lstPA"));
        component.set("v.partDistribution", false);
    }
})