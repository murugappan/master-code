/* - JLAL - 10/22/2010 - Altiris:162361                     */ 
/* TEST CLASS for trigger.bb_update_account_learn_rep       */
/* 2010-10-25 - update for multiple roles                   */


@isTest
private class bb_test_class_account_team_role 
{
    static testMethod void test_add_account_team_role() 
    {
        // Perform our data preparation.
        
        Integer n =1;
        
        // Create n~ Accounts       
        List<Account> accounts = new List<Account>{};
        for(Integer i = 0; i < n; i++)
        {
            Account a = new Account(Name = 'Test Account ' + i);
            a.Industry = 'Higher Ed.';
            a.Type = 'Customer';
            a.BillingStreet = '650 Massachusetts Ave';
            a.BillingCity = 'Washington';
            a.BillingState = 'DC';
            a.BillingCountry = 'USA';       
            a.BillingPostalCode = '20001';  
            accounts.add(a);
        }
        insert accounts;
        
        //  Create n~ Roles    
        List<Bb_Account_Team_Role__c> roles = new List<Bb_Account_Team_Role__c>{};
        //Remove '3' from Below. No longer use.
        String[] codes = new String[]{'G', 'D', '6', 'C'/*, '3'*/};
        for(Integer j = 0; j < n; j++)
        {
            for(String code : codes )
            {
                Bb_Account_Team_Role__c r = new Bb_Account_Team_Role__c(Member__c = 'Test Name ' + j);
                r.Name = 'Some Test Name';
                r.Account__c = accounts[j].Id;
                r.Role_Code__c = code;
                r.Start_Date__c =  System.today();          
                roles.add(r);
            }
            
        }
        insert roles;
        

        // Query the database for the newly inserted records.
        List<Bb_Account_Team_Role__c> new_roles = [SELECT Id, Member__c,Role_Code__c,Account__c, Account__r.PSFT_Learn_Account_Rep__c 
                                                   FROM Bb_Account_Team_Role__c
                                                   WHERE Account__c IN :accounts];
      
      // Commented below , since Logic has been commented in assocaited trigger.   
      /*
        // Assert that the Description fields contains the proper value now.
        for(Bb_Account_Team_Role__c r1 :new_roles)
        {
            
            System.assertEquals(r1.Member__c, r1.Account__r.PSFT_Learn_Account_Rep__c);
        }
       */ 
        
        delete accounts;  // should cascade delete roles also.
    }


}