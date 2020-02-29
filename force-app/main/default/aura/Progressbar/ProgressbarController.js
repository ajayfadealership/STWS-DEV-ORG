({
    //Specifying progress === 100 ? clearInterval(interval) : progress + 20 increases
    //the progress value by 20% and stops the animation when the progress reaches 100%
    //The progress bar is updated every 1000 milliseconds.
    doInit:  function (component, event, helper) {
        var interval = setInterval($A.getCallback(function () {
            var progress = component.get('v.progress');
            component.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 20);
        }), 1000);
    }
})