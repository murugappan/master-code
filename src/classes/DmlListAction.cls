public with sharing class DmlListAction 
{
	public static Boolean updateCaseList(set<Id> caseUpdateIdSet, map<Id, Case> caseMap, String className)
	{
		list<Case> caseUpdateList = new list<Case>();
    	
    	if (caseUpdateIdSet != null && !caseUpdateIdSet.isEmpty() && caseMap != null && !caseMap.isEmpty())
    	{
    		for (Id i : caseUpdateIdSet)
    		{
    			if (caseMap.containsKey(i))
    			{
    				caseUpdateList.add(caseMap.get(i));
    			}
    		}
    		
    		if (caseUpdateList != null && !caseUpdateList.isEmpty())
    		{
    			try
    			{
    				update caseUpdateList;
    				return true;
    			}
    			catch (DMLException e)
    			{
    				system.debug('Case Update Failed!');
    				list<Exception_Log__c> logList = new list<Exception_Log__c>();
    				Exception_Log__c el;
    				for (Integer i = 0; i < e.getNumDml(); i++)
    				{
				        // Process exception here
			        	el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml', Class_Name__c = className);
				        logList.add(el);
				    }
    				insert logList;
    				return false;
    			}
    		}
    	}
    	return false;
	}
}