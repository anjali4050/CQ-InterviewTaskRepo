@isTest
public class TaskTriggerHandlerTest {
    @testSetup
    static void setup() {
        
        /*Account testAccount = new Account(Name='Test Account',AccountNumber = '12456788',Active__c = false);
        insert testAccount;
        
        Task taskRecord = new Task(Description = 'TestDescription',WhatId = testAccount.Id,Status = 'Not Started');
        insert taskRecord;*/
    }
    
    static testMethod void updateTask(){
        
        List<Profile> profiles = [SELECT ID FROM Profile WHERE Name = 'Standard User'];
        
        
        User user = new User();
        user.Username =  'testcustom@juno.com';
        user.Email = 'testcustom@gmail.com';
        user.FirstName =  'Test Name';
        user.LastName = 'Test Last Name';
        user.CommunityNickname = 'Test';
        user.ProfileId = profiles[0].Id;
        
        user.Alias =  'Tuser';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        
        insert user;
        
        List<PermissionSet> permissionSets = [SELECT Id FROM PermissionSet WHERE Name = 'CQ_Account_Admin'];
        if(permissionSets.size() > 0){
            PermissionSetAssignment  assignPermission=   new PermissionSetAssignment(AssigneeId=user.Id, PermissionSetId=permissionSets[0].Id);
            insert assignPermission;
            
        }
        user customUser = [select Id from User where UserName = 'testcustom@juno.com'];
        system.runAs(customUser){
            
            Account testAccount = new Account(Name='Account',AccountNumber = '0987654321',Active__c = false);
            insert testAccount;
            
            Task taskRecord = new Task(Description = 'Test Description',WhatId = testAccount.Id,Status = 'Not Started');
            insert taskRecord;
            
            Task taskList = [select Id,WhatId,Status from Task limit 1];
            taskList.Status = 'Completed';
            update taskList;
            Account accountItem = [Select id,Active__c from Account Where Id =: taskList.WhatId];
            system.Assert(accountItem.Active__c , 'Account is Activated');
        }
    }
    
}