trigger caseSupportIncident on Case_Support_Incident__c (before insert, after insert, after update, before delete)
{
	CaseSupportIncidentTriggerHandler handler = new CaseSupportIncidentTriggerHandler();
	
	// Before Triggers
	if (trigger.isBefore)
	{
		// Before Insert
		if (trigger.isInsert)
		{
			handler.beforeInsert(trigger.new);
		}
		// Before Delete
		else
		{
			handler.beforeDelete(trigger.old);
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