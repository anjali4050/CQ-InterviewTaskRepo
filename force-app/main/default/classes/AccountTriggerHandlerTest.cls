@isTest
public class AccountTriggerHandlerTest {
    @testSetup
    static void setup() {
       
        Account tstAccount = new Account(Name='Account',AccountNumber = '18764267',Active__c = false);
        insert tstAccount;
        
    }
    //Check Task is created or not when account is Inserted.
    static testMethod void accountToInsert(){
        Account Acc = [select Id,Name,Active__c from Account limit 1];
        List<Task> TskList = [Select id,Status,WhatId from Task where WhatId =:Acc.Id];
        system.Assert(TskList.size() > 0,'Task should be created.');
    }
    
    //Check Task is updated or not when account activation is updated.
    static testMethod void accountToUpdate(){
        
        List<Profile> profiles = [SELECT ID FROM Profile WHERE Name = 'Standard User'];
        
        
        User user = new User();
        user.Username =  'testuser@juno.com';
        user.Email = 'testemail@gmail.com';
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
            PermissionSetAssignment  PermissionToAssign=   new PermissionSetAssignment(AssigneeId=user.Id, PermissionSetId=permissionSets[0].Id);
            insert PermissionToAssign;
            
        }
        user User1 = [select Id from User where UserName = 'testuser@juno.com'];
        system.runAs(User1){
            
            Account Acc = [select Id,Name,Active__c from Account limit 1];
            Acc.Active__c = true;
            update Acc;
            
            
            List<Task> TskList = [Select id,Status,WhatId from Task where WhatId =:Acc.Id];
            system.Assert(TskList[0].Status == 'Completed','Task status is not updated.');
        }
        
    }
}