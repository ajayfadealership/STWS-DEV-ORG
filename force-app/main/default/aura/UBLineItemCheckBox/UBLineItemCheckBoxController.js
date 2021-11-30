({
    changePPOption : function(component, event, helper) {
        var strPPId = component.get("v.strId");
        console.log('strPPId: '+strPPId);
        var ProductPriceIdListCCCC = component.get("v.ProductPriceIdListCCCC");
        var checkStatus = '0';
        if(component.find("ppcheck").get("v.value")) {
            checkStatus = '1';
        }
        
        if(checkStatus == '1') {
            ProductPriceIdListCCCC.push(strPPId); 
        } else { 
            ProductPriceIdListCCCC.splice(ProductPriceIdListCCCC.indexOf(strPPId), 1);
        }
        component.set("v.ProductPriceIdListCCCC", ProductPriceIdListCCCC);
        console.log('>>>>>:');
        console.log(ProductPriceIdListCCCC);
        
    }
})