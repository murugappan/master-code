trigger learnJIRANote on learnJIRANote__c (after insert, after update) 
{
	LearnJIRANoteTriggerHandler handler = new LearnJIRANoteTriggerHandler();
	
	// After Triggers
	if (Trigger.isAfter)
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