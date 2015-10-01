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
private class bb_test_class_task_lob 
{
    static testMethod void test_add_task() 
    {
    	
    	// Data preperation
     	Integer n = 1;
	    
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
	    
       	Map<Id,User> user_map  = new Map<Id,User>([SELECT Id, Line_of_Business__c FROM User Where Line_of_Business__c != null and IsActive = true Limit :n]);
	    List<User> user_list = new List<User>();
	    for(User  user :user_map.values() )
	    {     
	        user_list.add(user);
	    }
       
   		// Create n~ tasks
       	List<Task> tasks = new List<Task>{};
       	for(Integer j = 0; j < n; j++)
	    {
        	Task t = new Task(Subject = 'Task TESTING');
        	t.OwnerId = user_list[j].Id;
        	t.Priority = 'Normal';
        	t.Status = 'Completed';
        	t.WhatId = accounts[j].Id;
        	tasks.add(t);
	    }
       insert tasks;
       
       	// get the IDs of the newly created Tasks
       	Set<Id> new_task_array = new Set<Id>();
       	for(Task t0 :tasks)
       	{
       		new_task_array.add(t0.Id);
       	}
       
        // Query the database for the newly inserted taks.
    	List<Task> new_tasks = [SELECT Id, Line_of_Business__c, OwnerId FROM Task Where Id In :new_task_array];

    	// Assert that the Line of Business Field on the task matches the Owner's Line of Business
    	for(Task t1 :new_tasks)
    	{		
      		System.assertEquals(t1.Line_of_Business__c, user_map.get(t1.OwnerId).Line_of_Business__c);
    	}
       
    }
}