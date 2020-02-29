({
	callNext : function(component, event) {
        var id_str = parseInt(1);
        console.log(id_str); 
         
        var nextInd = id_str+1;
        var prevInd = id_str - 1;
        
        var nextLI = nextInd+"LI";
        var prevLI = prevInd+"LI";
        var currLI = id_str+"LI";
        console.log(nextLI+'  '+currLI+'  '+prevLI);
        var nextId = "tab-default-"+nextInd;
        var CurrId = "tab-default-"+id_str;
        var PrevId = "tab-default-"+prevInd;
        console.log(nextId+'  '+CurrId+'  '+PrevId);
        var currElement = document.getElementById(CurrId);
        var nextElement = document.getElementById(nextId);
        $A.util.toggleClass(currElement, "slds-show");
        $A.util.toggleClass(currElement, "slds-hide");
        $A.util.toggleClass(nextElement, "slds-show");
        $A.util.toggleClass(nextElement, "slds-hide");
        console.log('asdfadsfasdf');
        var currLIel = document.getElementById(currLI);
        var nextLIel = document.getElementById(nextLI);
        $A.util.removeClass(currLIel, "slds-is-current");
        $A.util.removeClass(currLIel, "slds-is-active");
        $A.util.addClass(currLIel, "slds-is-complete");
        $A.util.removeClass(nextLIel, "slds-is-incomplete");
        $A.util.addClass(nextLIel, "slds-is-active");
        $A.util.addClass(nextLIel, "slds-is-current"); 
        console.log('ssdfsdfa');
	}
})