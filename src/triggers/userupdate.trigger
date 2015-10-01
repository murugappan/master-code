trigger userupdate on User (before insert,before update) {

set<id> Idset;

//list<User> userlist =[Select id, UserPermissionsKnowledgeUser, UserPermissionsLiveAgentUser, UserPermissionsSupportUser, SERVICE_CLOUD_USER__c,
                      //LIVE_AGENT_USER__c, KNOWLEDGE_USER__c from User];

for(User u: trigger.new){

    if(u.UserPermissionsKnowledgeUser == true){
        u.KNOWLEDGE_USER__c = true;
    }
    
   
    
    else{
        u.KNOWLEDGE_USER__c = false;
        
    }
    
    
    if(u.UserPermissionsLiveAgentUser == true){
        u.LIVE_AGENT_USER__c = true;
    }
    
    else{
         u.LIVE_AGENT_USER__c = false;
       
    }
    
    if(u.UserPermissionsSupportUser == true){
         u.SERVICE_CLOUD_USER__c = true;
    }
    
    else {
         u.SERVICE_CLOUD_USER__c = false;
    }
    
    

}



}