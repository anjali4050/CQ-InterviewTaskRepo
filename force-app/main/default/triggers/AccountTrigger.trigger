trigger AccountTrigger on Account (before insert,after insert,after update) {
    AccountTriggerHandler Handler = new AccountTriggerHandler();
    if(Trigger.isAfter && Trigger.isInsert){
        Handler.accountCreationWithTaskCreation(Trigger.new);
    }else if(Trigger.isAfter && Trigger.isUpdate){
        Handler.updateTask(Trigger.new,trigger.oldMap);
    }
    

}