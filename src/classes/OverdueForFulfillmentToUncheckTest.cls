@isTest 
private class OverdueForFulfillmentToUncheckTest {
static testmethod void test() 
{
String query;
 query='SELECT Id,Overdue_for_fulfillment__c,Ownerid,What.Name,Owner.email,ActivityDate,LastModifiedDate FROM task WHERE Overdue_for_fulfillment__c=true and LastModifiedBy.Alias!=\'enebl\'';  
            
              
                  
               profile p=[select id from profile where name='SRV - Client Ops' limit 1];
               User u1 = TestmethodUtility.CreateUser(p);
               insert u1;
               Task tsk1 = new Task(
               Subject='Opportunity Moved to Closed Won',
              // ActivityDate=system.today()-2,
              // CreatedDate=system.today()-20,
               Priority='Normal',
               Ownerid=u1.id,
               Overdue_for_fulfillment__c=true,
              // LastModifiedDate=system.today()-20,
               Status='In Progress');
               insert tsk1;
               
       
       

       //Test.startTest();
       OverdueForFulfillmentToUncheck c = new OverdueForFulfillmentToUncheck();
       Database.executeBatch(c);
      //Test.stopTest();
      }
}