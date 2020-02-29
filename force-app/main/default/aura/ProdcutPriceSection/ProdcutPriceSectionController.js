({
    searchBack : function(component, event, helper) {
        
        //Blank All the field
        var cmpEvent = $A.get("e.c:AssignBlank");            
        cmpEvent.fire();
        
        var srchtype = document.getElementById("hiddenTypeForSearchCheck").value;
        document.getElementById("toglSectionForNewORExProduct").style.display = "block";
        if(srchtype == "NewProduct") {
            document.getElementById("PPSectionBBWizard").style.display = "none";
            document.getElementById("ExistigInvList").style.display = "none";
            document.getElementById("newInvCreate").style.display = "block";
        } else if(srchtype == "InventorySearch") {
            document.getElementById("PPSectionBBWizard").style.display = "none";
            document.getElementById("ExistigInvList").style.display = "block";
            document.getElementById("newInvCreate").style.display = "none";
        }
    }
})