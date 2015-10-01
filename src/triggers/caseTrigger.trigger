trigger caseTrigger on Case (after insert, before update, after update) 
{
    CaseTriggerHandler handler = new CaseTriggerHandler();
    
    // Before Triggers
    if (trigger.isBefore)
    {
        
        
        // Before Update
        if (trigger.isUpdate)
        {
            handler.beforeUpdate(trigger.new, trigger.old);
        }
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
    }
}