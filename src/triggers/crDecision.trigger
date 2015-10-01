trigger crDecision on CR_Decision__c (after insert, after update) 
{
    CRDecisionTriggerHandler handler = new CRDecisionTriggerHandler();
    
    // Before Triggers
    if (trigger.isBefore)
    {
        if (trigger.isInsert)
        {
            //handler.beforeInsert(trigger.new);
        }
    }
    else
    {
        if (trigger.isInsert)
        {
            handler.afterInsert(trigger.new);
        }
        else if (trigger.isUpdate)
        {
            handler.afterUpdate(trigger.new, trigger.old);
        }
    }
}