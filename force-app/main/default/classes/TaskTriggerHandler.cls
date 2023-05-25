public class TaskTriggerHandler {
    //Update Activate checkbox in Account to true, when related task is completed.
    public void WhenTaskIsCompletedActiveTheAccount(List<Task>TskList,Map<Id,Task> OldTsksMap){
        
        List<Account> updatedAccountList = new List<Account>(); 
        
        for(Task tskItem : TskList){
            system.debug('---------------'+OldTsksMap.get(tskItem.Id).Status);
            if(tskItem.Status == 'Completed' && OldTsksMap.get(tskItem.Id).Status != tskItem.Status){
                Account taskOnAccount = new Account();
                taskOnAccount.Id = tskItem.WhatId;
                taskOnAccount.Description = tskItem.Description;
                taskOnAccount.Active__c = true;
                accountListToUpdate.add(taskOnAccount);
            }
        }
        if(updatedAccountList.size() > 0){
            if (Schema.sObjectType.Account.fields.Active__c.isAccessible() && Schema.sObjectType.Account.fields.Active__c.isUpdateable()){
                update updatedAccountList;
            }
        }
    }
}