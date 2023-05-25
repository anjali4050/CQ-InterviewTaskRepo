public class AccountTriggerHandler {
    
    //Inserting a task when account is created.
    public void accountCreationWithTaskCreation(List<Account> AccountList){
        System.debug('AccountList---'+AccountList);
        List<Task> taskList = new List<Task>();
        
        for(Account accItem : AccountList){
            Task taskInAccount = new Task();
            taskInAccount.Subject = 'Review Account - '+accItem.AccountNumber;
            taskInAccount.ActivityDate = system.today().addDays(7);
            taskInAccount.OwnerId = accItem.OwnerId;
            taskInAccount.Status = 'Not Started';
            taskInAccount.WhatId = accItem.Id;
            taskList.add(taskInAccount);
        }
        
        if(taskList.size() > 0){
            insert taskList;
        }
    }
    
    //Updating the releated task whenever Account is updated.
    public void updateTask(List<Account> AccountList,Map<Id,Account> OldAccMap){
        
        List<Task> tskListToUpdate = new List<Task>();
        Map<Id,List<Task>> accTaskListMap = new Map<Id,List<Task>>();
        List<Task> taskList = [Select id,Status,WhatId from Task Where WhatId IN: OldAccMap.keySet()];
        
        for(Task taskItem : taskList){
            if(taskItem.Status != 'Completed'){
                if(accTaskListMap.get(taskItem.WhatId) != null){
                    List<Task> taskList = accTaskListMap.get(taskItem.WhatId);
                    taskList.add(taskItem);
                    accTaskListMap.put(taskItem.WhatId, taskList);
                }else{
                    List<Task> taskList = new List<Task>();
                    taskList.add(taskItem);
                    accTaskListMap.put(taskItem.WhatId, taskList);
                }
            }
        }
        
        for(Account accItem : AccList){
            if(accItem.Active__c == true && OldAccMap.get(accItem.Id).Active__c != accItem.Active__c){
                if(accTaskListMap.get(accItem.Id) != null){
                    for(Task taskItem : accTaskListMap.get(accItem.Id)){
                        Task taskItemUpdate = new Task();
                        taskItemUpdate.Id = taskItem.Id;
                        taskItemUpdate.Status = 'Completed';
                        tskListToUpdate.add(taskItemUpdate);
                    }
                }
            }
        }
        if(tskListToUpdate.size() > 0){
            update taskListToUpdate;
        }
    }
}