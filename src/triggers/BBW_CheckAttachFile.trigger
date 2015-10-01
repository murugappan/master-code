trigger BBW_CheckAttachFile on Task (before insert,before update) {
List<task> tsk=new List<task>();
if(Trigger.isInsert)
{
for(task t:Trigger.New)
{
List<attachment> atch=[Select Id, ParentId, Name, OwnerId From Attachment a where a.ParentId=:t.id];
if(atch.size()!=0)
{
t.ANGEL_Attached_Files__c=true;
system.debug('Attached File'+t.ANGEL_Attached_Files__c);
tsk.add(t);
}
}

}
if(Trigger.isUpdate)
{
for(task t:Trigger.New)
{
List<attachment> atch=[Select Id, ParentId, Name, OwnerId From Attachment a where a.ParentId=:t.id];
if(atch.size()!=0)
{
t.ANGEL_Attached_Files__c=true;
system.debug('Attached File'+t.ANGEL_Attached_Files__c);
tsk.add(t);
}
}
}
}