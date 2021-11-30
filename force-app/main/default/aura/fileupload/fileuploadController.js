({
    handleUploadFinished: function (cmp, event) {
        
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var action = cmp.get("c.UpdateFileNameToSide");
        action.setParams({
            JsonString :JSON.stringify(uploadedFiles)
        });
         action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "type" : "success",
                "message":" Files has been uploaded successfully!"
            });
            toastEvent.fire();
            $A.get("e.force:refreshView").fire();


        }
            else
            {
                toastEvent.setParams({
                    "title": "Error!",
                    "type" : "Error",
                    "message":"Error"
                });
                toastEvent.fire();
            }
        });

      $A.enqueueAction(action);
        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    }
})