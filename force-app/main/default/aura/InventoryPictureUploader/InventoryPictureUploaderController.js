({
     doInit : function(component, event, helper) {
        var action = component.get("c.getInventoryImage");
        var fileName = component.get("v.fileName");
        action.setParams({
            "fileName" : fileName,
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                if(response.getReturnValue() != 'NoFile'){
                    component.set("v.fileId", response.getReturnValue());
                    component.set("v.isFileExist", true);
                }
                
              
            }
            
        });
        $A.enqueueAction(action);
    },
    FileUploaded : function(component, event, helper){
        var uploadedFiles = event.getParam("files");
        var cdId = uploadedFiles[0].documentId;
        component.set("v.fileId",cdId);
        component.set("v.isFileExist", true);
        var action = component.get("c.UpdateFileName");
        var fileName = component.get("v.fileName");
        action.setParams({
            "cdId" : cdId,
            "fileName" : fileName
        });
        action.setCallback(this, function(response){
           console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})