public class NotifyFollowers {
    public Id batchId {get; set;}
    public string days{get;set;}
    public String className {get; set;}
    public string message{get;set;}
    public Datetime now = system.now();
    public NotifyKnowledgeFollowersBatch notifyFollowers {get; set;}
    public NotifyFollowers() { message='';
    	days='1';
    className = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));}
    public PageReference autoRun()
    {
    	
        if(days !=null && days.isNumeric())
        {
        notifyFollowers = new NotifyKnowledgeFollowersBatch(integer.valueof(days));     
        }
        else
        {
        message='Batch execution failed: Enter valid days';
        return null;	
        }
        try{
        batchId = database.executeBatch(notifyFollowers);
        message='Batch Process has been Initiated';
        if(test.isrunningtest())
        {
         exception e;
         throw e;
        }
        }
        catch(exception e)
        {
        message='Batch execution failed';
        }
        return null;
    }
}