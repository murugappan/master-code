/*
    @author         Nikhil Kumar
    @class          OverdueForFulfillment
    @abstract       updates Accounts with information about active products from Assets
    @since          2011.0715
    @discussion     Class to update Accounts with Collborate product information
*/

global class OverdueForFulfillment implements Database.Batchable<sObject>{

    public String query;

    // The start method is called at the beginning of a sharing recalculation. 
    // This methods returns a SOQL query locator containing the records to be recalculated.     
    // This method must be global. 
    global Database.QueryLocator start(Database.BatchableContext BC){
      
      

      query='SELECT Id,Overdue_for_fulfillment__c,Ownerid,What.Name,Owner.email,ActivityDate,LastModifiedDate FROM task WHERE Subject IN (\'Opportunity Moved to Closed Won\',\'New Business - Won - Build Asset\',\'Additional Storage Purchased\',\'Renewal - Upgrade\',\'Renewal with ELM, Create or Annual Maintenance\') and status !=\'Completed\' and status !=\'Deferred\' and ActivityDate < today and LastModifiedDate < LAST_N_DAYS:15 and Owner.profile.Name IN (\'SRV - Client Ops\',\'SRV- Hosting User - CPQ\')';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
            
            // List of send emails
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            
            for(sObject s: scope)
            {
               
                Task  tsk = (Task)s;
                 
                tsk.Overdue_for_fulfillment__c=true;
                
                // send email part of code
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {tsk.Owner.Email};
                mail.setToAddresses(toAddresses);
                String subject='Your fulfillment task is overdue.';
                
              //String body='Our records indicate the task below has not been updated in over 15 days. Please, follow up on the outstanding fulfillment lines and update the comments.<br></br>Task: URL.getSalesforceBaseUrl().toExternalForm() + \'/\' +tsk.id <br></br>Related to: tsk.Whatid<br></br>Due Date: tsk. ActivityDate'; 
                mail.setHtmlBody('Our records indicate the task below has not been updated in over 15 days. Please, follow up on the outstanding fulfillment lines and update the comments.<br></br>Task:'+' <a href='+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.id +'>'+URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.id +'</a><br></br>Related to:'+  tsk.What.Name +'<br></br>Due Date:'+  tsk.ActivityDate); 
                mail.setSubject(subject);
                mail.setSaveAsActivity(false); 
                allMails.add(mail);
            
            }

              Update Scope;
        //Send email method
        Messaging.sendEmail(allMails); 
      // Send en email has been written to trigger part.

    }
    
    global void finish(Database.BatchableContext BC){
    
     // Get the ID of the AsyncApexJob representing this batch job 
       // from Database.BatchableContext.         
       // Query the AsyncApexJob object to retrieve the current job's information. 
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
       
       // Send an email to the Apex job's submitter notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {'nikhil.kumar@blackboard.com'};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Batch Nikhil On Fullfillment ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    
    
    }