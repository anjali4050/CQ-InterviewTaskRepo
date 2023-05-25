trigger TaskTrigger on Task (before insert,after update) {
    TaskTriggerHandler Handler = new TaskTriggerHandler();
    if(Trigger.isAfter && Trigger.isUpdate){
        TaskTriggerHandler.WhenTaskIsCompletedActiveTheAccount(trigger.new,trigger.oldMap);
    }
}