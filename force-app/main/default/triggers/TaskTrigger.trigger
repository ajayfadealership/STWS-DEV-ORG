trigger TaskTrigger on Task (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        EventTriggerHandler.afterInsertCountTsk(Trigger.newMap);
    }
}