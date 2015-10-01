trigger relatedBug on Related_Bug__c (after delete, after insert, after update) 
{
  if(!Userinfo.getUserName().containsignoreCase('tsg@blackboard.com'))
  {
    RelatedBugTriggerHandler handler = new RelatedBugTriggerHandler();
    
    // Before Triggers
    if (trigger.isBefore)
    {
        
    }
    // After Triggers
    else
    {
        // After Insert
        if (trigger.isInsert)
        {
            handler.afterInsert(trigger.new);
        }
        // After Update
        else if (trigger.isUpdate)
        {
            handler.afterUpdate(trigger.new, trigger.old);
        }
        // After Delete
        else if (trigger.isDelete)
        {
            handler.afterDelete(trigger.old);
        }
    }
   }
}