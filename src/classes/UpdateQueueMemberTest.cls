@isTest
private class UpdateQueueMemberTest {
   
    private static Testmethod void UpdateQueueMember()
    {
        
        
        Profile p = [Select id,Name From Profile WHERE Name = 'Standard User'];
        User u = TestMethodUtility.createUser(p);
       insert u;
       u.Primary_Group__c='Test primary1';
       update u;
       }
  }