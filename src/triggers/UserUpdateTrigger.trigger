trigger UserUpdateTrigger on User (after update, after insert, before insert,before update)
{
	/* For future method in handler class */
	set <id> userids=new set<id>();
    for(User u: trigger.new)
    {
    	if(u.contactid!=null)
    	{
    		userids.add(u.id);
    	}
    }
    
	
	UserUpdateTriggerHandler handler = new UserUpdateTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore)
    {
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter)
    {
    	handler.OnAfterInsert(Trigger.new,userids);
    }
    else if(Trigger.isUpdate && Trigger.isBefore)
    {
        handler.OnBeforeUpdate(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter)
    {
        handler.OnAfterUpdate(Trigger.new);
    }
}