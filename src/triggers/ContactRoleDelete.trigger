trigger ContactRoleDelete on Contact_Role__c (before delete) {

 Set<String> roles = new Set<String>();
    roles.add('ANALYTICS - Admin');
    roles.add('ANGEL - Admin');
    roles.add('COLLABORATE - Admin');
    roles.add('COLLABORATE - Read-Only');
    roles.add('LEARN (Bb) - Admin');
    roles.add('LEARN (CE/Vista) - Admin');
    roles.add('LEARN - Read-Only');
    roles.add('MOODLEROOMS - Admin');
    roles.add('TRANSACT - Admin');
    roles.add('Xythos - Admin');
   
     
    string ProfileId = UserInfo.getProfileId();
    String first = '<a href="';
    String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
    String last = '">Click here to Expire Contact Role.</a>'; 
   
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;   
 
 for(Contact_Role__c c: Trigger.old) 
  {  
   String roleID = c.ID;
   if(roles.contains(c.Role__c)){
    if ( profileName != 'System Administrator' && profileName != 'Bb - API User' ) // Exempt System Admin and Cast Iron user
    {
      c.addError('<span><b>An Administrator contact role should not be deleted. Instead, please expire it by checking the "Expire Role" check box.</b></span>'+ first + fullFileURL + '/' +roleID+ last,false); 

    }  
    }
  }

}