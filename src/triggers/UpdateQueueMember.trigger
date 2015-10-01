/*
@author: Wipro
@context:  When the User.Primary_Group__c changes, reflect that change in GrompMember

Modified by Jon Lal - January 13, 2012
Bulkified; removed nested sOQL 

*/
trigger UpdateQueueMember on User (after update) 
{
	
	// Itterate through the saved user records
    List<User> ulist = Trigger.New;

	// Create a List of User.Ids    
    Set<Id> changed_user_ids = new Set<Id>();
	List<User> changed_users = new List<User>();
    for (User post_change_user : ulist )
    {
    		User pre_change_user = Trigger.oldMap.get(post_change_user.Id);
    		if (pre_change_user.Primary_Group__c != post_change_user.Primary_Group__c)
    		{
    			changed_users.add(post_change_user);
    			changed_user_ids.add( post_change_user.Id );    	    
    		}
    }
    
    // Remove the membership row for every user that changed
    List<GroupMember> gmlist = new List<GroupMember>();
    gmlist = [select Id from GroupMember where UserOrGroupId IN :changed_user_ids];
    delete gmlist; 
 
 	// Create a Map of the Group.Name - Group.Id
 	Map<String,Id> group_map = new Map<String,Id>();
  	List<Group> groups = [Select Id, Name From Group  where Type = 'Queue' ];
	for (Group g : groups)
	{
		group_map.put(g.Name, g.Id);
	}

	// Add new memberships one per user
	List<GroupMember> new_memberships = new List<GroupMember>();
	for(User u : changed_users)
	{
    		GroupMember gm = new GroupMember();
        gm.GroupId = group_map.get(u.Primary_Group__c);
        gm.UserOrGroupId = u.Id;
        if ( gm.GroupId != null &&  gm.UserOrGroupId  != null )
        {
        		new_memberships.add(gm);
        }
	}
	insert new_memberships;
    
}



/*  Old Trigger Jan 12, 2012 *


trigger UpdateQueueMember on User (after update) {

    List<User> ulist = Trigger.New;
    
        for(User u : ulist){
            User oldu = Trigger.oldMap.get(u.ID);
            if(u.Primary_Group__c != oldu.Primary_Group__c && u.Primary_Group__c != null){
                Group g = [Select g.Type, g.Name From Group g where Type = 'Queue' AND Name =: u.Primary_Group__c];         
                GroupMember gm = new GroupMember();
                gm.GroupId = g.ID;
                gm.UserOrGroupId = u.ID;
                insert gm;
                
                List<GroupMember> gmlist = new List<GroupMember>();
                gmlist = [select ID from GroupMember where UserOrGroupId =: u.ID AND ID !=: gm.ID];
                delete gmlist;
            }
    }
}

*/