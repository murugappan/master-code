trigger deleteknowledgefollow on User (after update) {
set<id>userids=new set<id>();
if(!system.isBatch() && !system.isFuture())
{
	for (user u : trigger.new)
	{
	if(u.isactive != trigger.oldmap.get(u.id).isactive && u.isactive==false)
	{
	userids.add(u.id);
	}
	}
	UserTriggerHandler.DeleteFollowlist(userids);
}
}