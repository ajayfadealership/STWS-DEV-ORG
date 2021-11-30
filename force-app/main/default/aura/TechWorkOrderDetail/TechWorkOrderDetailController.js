({
    doInit : function(component, event, helper) {
        var twoId = component.get("v.recordId");
        helper.getWOInfo(component, twoId);
    },
    uplaodFinished : function(component, event, helper){
        var childCmp = component.find("photoCmp")
        //console.log('photoCMP4photoCMP4', childCmp);
        childCmp.refreshChild();
    }
})