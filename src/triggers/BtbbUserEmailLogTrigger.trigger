trigger BtbbUserEmailLogTrigger on BtbbUserEmailLog__c (before insert) {

	for(BtbbUserEmailLog__c record: trigger.new)
	{
		string temp=record.email__c;
		if(temp != null && temp != '')
		{
			record.username__c=temp;
			if(temp.containsignorecase('@bbbb.net')||temp.containsignorecase('@crm.blackboard.com'))
			{
				record.email__c=temp.replace('@bbbb.net','@blackboard.com').replace('@crm.blackboard.com','@blackboard.com');
			}
		}
	}

}