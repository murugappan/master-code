@isTest 
private class OverdueForFulfillmentTest {
static testmethod void test() 
{
String query;
 query='SELECT Id,Overdue_for_fulfillment__c,Ownerid,What.Name,Owner.email,ActivityDate,LastModifiedDate FROM task WHERE Subject IN (\'Opportunity Moved to Closed Won\',\'New Business - Won - Build Asset\',\'Additional Storage Purchased\',\'Renewal - Upgrade\',\'Renewal with ELM, Create or Annual Maintenance\') and status !=\'Completed\' and status !=\'Deferred\' and ActivityDate < today and LastModifiedDate < LAST_N_DAYS:15 and Owner.profile.Name IN (\'SRV - Client Ops\',\'SRV- Hosting User - CPQ\')';
      
            
              
                  
               profile p=[select id from profile where name='SRV - Client Ops' limit 1];
               User u1 = TestmethodUtility.CreateUser(p);
               insert u1;
               Task tsk1 = new Task(
               Subject='Opportunity Moved to Closed Won',
              // ActivityDate=system.today()-2,
              // CreatedDate=system.today()-20,
               Priority='Normal',
               Ownerid=u1.id,
              // LastModifiedDate=system.today()-20,
               Status='In Progress');
               insert tsk1;
               
       
       

       //Test.startTest();
       OverdueForFulfillment c = new OverdueForFulfillment();
       Database.executeBatch(c);
      //Test.stopTest();
      }
}