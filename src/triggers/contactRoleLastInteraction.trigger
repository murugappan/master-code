trigger contactRoleLastInteraction on Contact_Role__c (before insert, before update) 
{
  for(Contact_Role__c c: Trigger.new) 
  {    
    string ProfileId = UserInfo.getProfileId();
    if ( ProfileId != '00e70000000zlf8AAA' ) // Bb API User Profile
    {
      c.last_interaction_dttm__c = system.now();
      c.last_interaction_flag__c = true;  
      c.last_interaction_user__c = UserInfo.getUserId();
    }  
  }
}