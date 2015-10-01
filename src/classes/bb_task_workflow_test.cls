/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class bb_task_workflow_test 
{

    static testMethod void task_stamping() 
    {
        // Perform our data preparation.      
        Integer n = 1;


        // Create n~ Accounts      
        List<Account> accounts = new List<Account>{};
        for(Integer i = 0; i < n; i++)
        {
            Account a = new Account(Name = 'Account ' + i);
            a.Industry = 'Higher Ed.';
            a.Type = 'Customer';
            a.PS_Company_Id__c = '10000' + i;
            a.BillingStreet = '650 Massachusetts Ave';
            a.BillingCity = 'Washington';
            a.BillingState = 'DC';
            a.BillingCountry = 'USA';       
            a.BillingPostalCode = '20001';   
            accounts.add(a);
        }      
        insert accounts;

        // Create n~ contacts
        List<Contact> contacts = new List<Contact>{};
        for(Integer i = 0; i < n; i++)
        {
            Contact c = new Contact(LastName = 'Cole');
            c.FirstName = 'Taylor';
            c.AccountId = accounts[i].Id;
            c.PS_Person_Id__c = '9000 ' + i;
            c.MailingStreet = '650 Massachusetts Ave';
            c.MailingCity = 'Washington';
            c.MailingState = 'DC';
            c.MailingCountry = 'USA';       
            c.MailingPostalCode = '20001';   
            contacts.add(c);
        }      
        insert contacts;
        
        //profile
        Profile pf =[Select id from profile Where Name='System Administrator' limit 1];
        // Get a real user
        User uR = [Select Id, Line_of_Business__c From User Where profileid=:pf.id and Isactive=true limit 1];
        Id new_task_id;
        System.RunAs (uR)
        {
            // Create the task
            Task t = new Task(Subject='Task Master');
            t.WhatId = accounts[0].Id;
            t.WhoId = contacts[0].Id;
            insert t;
            new_task_id = t.Id;
        }
        
        Task new_task = [Select Id, OwnerId, Line_of_Business__c From Task Where Id = :new_task_id][0];
        
        //Test the Line of Business Stamping
        User u = [Select Id, Line_of_Business__c From User Where Id = :new_task.OwnerId][0];
        system.assertEquals(u.Line_of_Business__c, new_task.Line_of_Business__c);
    }
    
    // JLAL - test the "Create Quote" button for opp Task 
    static testMethod void test_create_quote_task() 
    {
        // Perform data preparation.      
        Integer n = 1;

        // Create n~ Accounts      
        List<Account> accounts = new List<Account>{};
        for(Integer i = 0; i < n; i++)
        {
            Account a = new Account(Name = 'Account ' + i);
            a.Industry = 'Higher Ed.';
            a.Type = 'Customer';
            a.PS_Company_Id__c = '10000' + i;
            a.BillingStreet = '650 Massachusetts Ave';
            a.BillingCity = 'Washington';
            a.BillingState = 'DC';
            a.BillingCountry = 'USA';       
            a.BillingPostalCode = '20001';   
            accounts.add(a);
        }      
        insert accounts;
        
        
        //  Create n~ Opportunities    
        List<Opportunity> opportunities = new List<Opportunity>{};
        for(Integer k = 0; k < n; k++)
        {
            Opportunity o = new Opportunity(Name = 'Test Opportunity ' + k);
            o.AccountId = accounts[k].Id;
            o.Type = 'Expansion Business';
            o.CloseDate =  System.today();
            o.StageName = '(S) Suspect Qualification';          
            opportunities.add(o);                   
        }     
        insert opportunities;       
    
    
        // Create a task
        String SubjectLine = 'Email: SFDC: Please Approve Quote for ' + accounts[0].Name;
        Task t = new Task (Subject = subjectLine );              
        t.WhatId = opportunities[0].Id;
        insert t;

    
        // Verify the fields on the Opp 
        Opportunity o = [Select Id, Psft_Integration_Stage__c, Finance_Ops_Stage__c From Opportunity Where Id = :t.WhatId ][0];
    
        system.assertEquals('Create Quote', o.Psft_Integration_Stage__c);
        system.assertEquals('Quote', o.Finance_Ops_Stage__c);   
    
    
    }
        
}