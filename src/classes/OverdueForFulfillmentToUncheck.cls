global class OverdueForFulfillmentToUncheck implements Database.Batchable<sObject> {
    
    public String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        query='SELECT Id,Overdue_for_fulfillment__c,Ownerid,What.Name,Owner.email,ActivityDate,LastModifiedDate FROM task WHERE Overdue_for_fulfillment__c=true and LastModifiedBy.Alias!=\'enebl\'';
        return Database.getQueryLocator(query);
        
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        for(sObject s: scope)
            {
               
                Task  tsk = (Task)s;
                 
                tsk.Overdue_for_fulfillment__c=False;
            }
        Update Scope;        
    
    }
    
    global void finish(Database.BatchableContext BC) {

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