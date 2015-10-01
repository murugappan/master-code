/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardTaskTriggerHandler
    @abstract       handles all the logic for triggers on Task
    @since          2011.0915
    @discussion     Class to execute Task triggers logic
*/
public with sharing class BbTaskTriggerHandler {

    // Bb API User Profile
    private Id apiProfile = '00e70000000zlf8AAA';
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbTaskTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Task[] newTasks){
        if(UserInfo.getProfileId() != apiProfile)
        {
            updateTaskLineOfBusiness(newTasks);
            updateOpportunityStageWhenQuoteRequested(newTasks);
        }
    }
    
    public void OnAfterInsert(Task[] newTasks, Map<ID, Task> insertedTaskMap){
    UpdateLastFacultyDate(newTasks);
   set<Id> leadIds = new  set<Id>(); // Added by Prakash for TP 5050
    for(Task t: newTasks){
        if(t.whoid != null && string.valueof(t.Whoid).startswith('00Q')){
            leadIds.add(t.WhoId);
        }
    }
    system.debug('lead list---'+leadids);
    list<Lead> leadsToUpdate = new list<Lead>([Select Id, Name, First_Activity_Date__c,  ( Select Id, ActivityDate, CreatedDate From Tasks) From Lead Where Id in : leadIds]);

        for(Lead l: leadsToUpdate){
                
               
            for(Task t : l.Tasks){
            if( l.tasks.size() == 1)
            {
             l.First_Activity_Date__c = t.CreatedDate; 
            }
            }
            }
               
    update leadsToUpdate;
    }

    
    public void OnBeforeUpdate(Task[] oldTasks, Task[] updatedTasks, Map<ID, Task> oldTaskMap, Map<ID, Task> updatedTaskMap){
        if(UserInfo.getProfileId() != apiProfile)
        {
            updateTaskLineOfBusiness(updatedTasks);
            updateOpportunityStageWhenQuoteRequested(updatedTasks);
        }
    }
    
    public void OnAfterUpdate(Task[] oldTasks, Task[] updatedTasks, Map<ID, Task> oldTaskMap, Map<ID, Task> updatedTaskMap){
    UpdateLastFacultyDate(updatedTasks);

    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------    

    //Stamps Owner's Line of Business to the Task
    private void updateTaskLineOfBusiness(Task[] tasks)
    {
        //List of Owner ID's from Task object
        Set<Id> userIds = new Set<Id>();
    
        //Loop through incoming tasks and pull out OwnerID's
        for(Task t : tasks)
        {
            //Check to see if Owner ID is null
            if(t.OwnerId != null) userIds.add(t.OwnerId);
        }
    
        //Validate at least one Owner ID was returned
        if(userIds.size() > 0)
        {
            //Load all User objects based of Owner ID
            Map<Id,User> users = new Map<Id,User>([Select Id, Line_of_Business__c From User Where Id in :userIds]);
            
            //Iterate through Task objects again to update Line Of Business
            for(Task t: tasks) 
            {    
                //Check to make sure the User's Line Of Business is not empty
                if(users.get(t.OwnerId) != null && users.get(t.OwnerId).Line_of_Business__c != null) t.Line_of_Business__c =  users.get(t.OwnerId).Line_of_Business__c ;
            }
        } 
    }
    
    
    
    // JLAL - 2009-10-23 (REWRITE)
    // When the opp.Request Quote button is pressed, a task is created
    // and then emailed to the quotes team.
    // Once the email is sent out with the specified subject line,
    // The corresponding Opp object should be updated for the PSFT integration
    // to proceed.
    private void updateOpportunityStageWhenQuoteRequested(Task[] tasks)
    {
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();

        Set<Id> opportunityIds = new Set<Id>();    
        
        for(Task t: tasks) 
        {  
            if ( t.Subject.length() > 38  && t.Subject.substring(0, 38) == 'Email: SFDC: Please Approve Quote for ') opportunityIds.add(t.WhatId);
        }
        
        if(opportunityIds.size() > 0)
        {
            List<Opportunity> opportunities = [Select Id, Psft_Integration_Stage__c , Finance_Ops_Stage__c From Opportunity Where Id IN :opportunityIds];
            for(Opportunity opp : opportunities)
            {
                opp.Psft_Integration_Stage__c = 'Create Quote';
                opp.Finance_Ops_Stage__c = 'Quote';
                opportunitiesToUpdate.add(opp);
            }
            update opportunitiesToUpdate;
            
        }
    }
     private void UpdateLastFacultyDate(Task[] tasks) {
    
         //set of ids
         Set<id> AccId = New Set<id>();
         Set<Id> TskId = New Set<Id>();
         Map<Id,Task> mapofTsk = new Map<Id,Task>();
         Opportunity opp;
         if(tasks.size()>0)
         {
            For(Task evnt : tasks)
            {
                if(evnt.Whatid != null && evnt.Type=='Faculty Engagement (NAHE)' && evnt.Status=='Completed' && (String.Valueof(evnt.Whatid).contains('001') || String.Valueof(evnt.Whatid).contains('006')) )
                {
                    if(String.Valueof(evnt.Whatid).contains('001'))
                    {
                        AccId.Add(evnt.Whatid);
                        mapoftsk.put(evnt.Whatid,evnt);
                    }
                    else
                   {
                      //OppId = evnt.Whatid;
                      opp = [Select id, AccountId from Opportunity where Id =: evnt.Whatid];
                      mapoftsk.put(opp.AccountId,evnt);
                      AccId.add(opp.AccountId);
                      
                   }
                   //AccId.Add(evnt.Whatid);
                   TskId.Add(evnt.id);
                   //mapoftsk.put(evnt.Whatid,evnt);
                   System.Debug('2nd'+evnt.ActivityDate);
                   System.Debug('Map'+mapoftsk);
                }
            }
         
            if(AccId.size()>0)
            {
                 // List of account to update
                List<Account> LAcc= New List<Account>();
                 
                 //Query for Account
                For(Account acc:[select id,Last_Faculty_Engagement__c from Account Where id IN :AccId])
                {
                    acc.Last_Faculty_Engagement__c = mapoftsk.get(acc.id).ActivityDate;
                   LAcc.Add(acc);
                }
             
                If(LAcc.Size()>0)
                update LAcc;
            }   
        }     
    }
}