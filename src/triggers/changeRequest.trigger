trigger changeRequest on Change_Request__c (before insert, after insert, before update) 
{
    ChangeRequestTriggerHandler handler = new ChangeRequestTriggerHandler();
    
    // Before Triggers
    if (trigger.isBefore)
    {
        if (trigger.isInsert)
        {
            handler.beforeInsert(trigger.new);
        }
        else if (trigger.isUpdate)
        {
            handler.beforeUpdate(trigger.new, trigger.old);
        }
    }
    else
    {
        if (trigger.isInsert)
        {
            handler.afterInsert(trigger.new);
        }
    }
}