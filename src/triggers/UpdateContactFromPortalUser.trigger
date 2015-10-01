trigger UpdateContactFromPortalUser on User (after update, after insert, after delete) 
{
    set <id> userids=new set<id>();
    if(!system.isBatch() && !system.isFuture())
    {

        for(User u: trigger.new)
        {
        	if(u.contactid!=null)
        	{
        		userids.add(u.id);
        	}
        }
        if(userids !=null && userids.size()>0)
        {
        	UpdateContactFromPortalUser.updateContacts(userids);	
        }
    }
}