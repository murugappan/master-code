public class UserTriggerHandler {
  @future
  public static void DeleteFollowlist(Set<Id> userids) {
    list<Knowledge_Follow__c> followlist=new list<Knowledge_Follow__c>();
followlist=[SELECT id from Knowledge_Follow__c where User__c in:userids];
if(!followlist.isempty())
{
  try{
     delete followlist;
     }
  catch (exception e)
    {

    }
}
  }
}