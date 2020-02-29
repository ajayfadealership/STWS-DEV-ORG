({
    searchPartKeyUp : function(component, event, helper) {
        var searchkeyword = component.find('searchUsrInp').get('v.value');
        if(searchkeyword.length > 2){ 
            helper.searchUser(component, event, helper);
        } else {
            component.set("v.searchResults", []);   
        }
    },
    selectValue : function(component, event, helper) {
        var usrLst = component.get("v.searchResults"); 
        var index = event.currentTarget.id;
        console.log("index: "+index);
        usrLst.forEach(objUsr => {
            if(index == objUsr.Id) {
                console.log(objUsr.Id);
                console.log(objUsr.Name);
                console.log(objUsr.Email);
                component.set("v.objUser", objUsr); 
            }
        });
        console.log('>>>: '+component.get("v.objUser"));
        component.set("v.searchResults", []);
        console.log('>>>: '+component.get("v.showPill"));
        component.set("v.showPill", true);
    },
    removeUser: function(component, event, helper) {
        var objU = new Object();
        objU.Id = '';
        objU.Name = '';
        objU.Email = '';
        component.set("v.objUser", objU); 
        component.set("v.showPill", false);
    }
})