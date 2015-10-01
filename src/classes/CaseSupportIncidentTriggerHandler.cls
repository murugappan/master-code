public with sharing class CaseSupportIncidentTriggerHandler 
{
	public static Boolean hasRun {get{if (hasRun == null) return false; return hasRun;} set;}
	public static Boolean hasBeforeInsertRun {get{if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
	public static Boolean hasAfterInsertRun {get{if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
	public static Boolean hasAfterUpdateRun {get{if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
	
	public CaseSupportIncidentTriggerHandler()
	{
		hasRun = true;
	}
	
	public void beforeInsert(list<Case_Support_Incident__c> newList)
	{
		if (!hasBeforeInsertRun)
		{
			list<Case_Support_Incident__c> csiValidList;
			set<Id> caseIdSet = new set<Id>();
			map<Id, Case_Support_Incident__c> csiOnCaseMap;
			hasBeforeInsertRun = true;
			
			for (Case_Support_Incident__c csi : newList)
			{
				if (csi.Case__c != null)
				{
					caseIdSet.add(csi.Case__c);
				}
			}
			
			csiOnCaseMap = queryForCsiOnCase(caseIdSet);
			throwErrors(newList, csiOnCaseMap);
		}
	}
	
	public void afterInsert(list<Case_Support_Incident__c> newList)
	{
		if (!hasAfterInsertRun)
		{
			set<Id> caseIdSet = new set<Id>();
			set<Id> supportIncidentIdSet = new set<Id>();
			map<Id, Case> caseMap;
			map<Id, Case_Support_Incident__c> csiOnCaseMap;
			map<Id, learnJIRA__c> siMap;
			list<Case> caseUpdateList;
			list<Case_Support_Incident__c> csiUpdateList;
			Case caseObj;
			hasAfterInsertRun = true;
			
			for (Case_Support_Incident__c csi : newList)
			{
				if (csi.Case__c != null)
				{
					caseIdSet.add(csi.Case__c);
				}
				if (csi.Support_Incident__c != null)
				{
					supportIncidentIdSet.add(csi.Support_Incident__c);
				}
			}
			
			csiOnCaseMap = queryForCsiOnCase(caseIdSet);
			caseMap = queryCase(caseIdSet);
			siMap = querySIs(supportIncidentIdSet);
			caseUpdateList = modifyCaseFields(newList, null, caseMap, siMap);
			csiUpdateList = deactivateCSIs(newList, csiOnCaseMap);
			
			// Dml statements
			updateCaseList(caseUpdateList);
			updateCsiList(csiUpdateList);
		}
	}
	
	public void afterUpdate(list<Case_Support_Incident__c> newList, list<Case_Support_Incident__c> oldList)
	{
		map<Id, Case_Support_Incident__c> oldMap = new map<Id, Case_Support_Incident__c>(oldList);
		set<Id> caseIdSet = new set<Id>();
		set<Id> supportIncidentIdSet = new set<Id>();
		list<Case> caseUpdateList;
		list<Case_Support_Incident__c> csiUpdateList;
		list<learnJIRA__c> siUpdateList;
		map<Id, Case> caseMap;
		map<Id, learnJIRA__c> siMap;
		map<Id, Case_Support_Incident__c> csiOnCaseMap;
		
		for (Case_Support_Incident__c csi : newList)
		{
			if (oldMap.containsKey(csi.Id) && csi.Case__c != null && csi.Active__c != oldMap.get(csi.Id).Active__c)
			{
				caseIdSet.add(csi.Case__c);
			}
			if (csi.Support_Incident__c != null)
			{
				supportIncidentIdSet.add(csi.Support_Incident__c);
			}
		}
		siMap = querySIs(supportIncidentIdSet);
		siUpdateList = modifySupportIncidentFields(newList, oldMap, siMap);
		
		if (!hasAfterUpdateRun)
		{
			hasAfterUpdateRun = true;
			csiOnCaseMap = queryForCsiOnCase(caseIdSet);
			caseMap = queryCase(caseIdSet);
			caseUpdateList = modifyCaseFields(newList, oldMap, caseMap, siMap);
			csiUpdateList = deactivateCSIs(newList, csiOnCaseMap);
			
			// Dml statements
			updateCaseList(caseUpdateList);
			updateCsiList(csiUpdateList);
		}
		
		//Dml Operations
		updateSupportIncidentList(siUpdateList);
	}
	
	public void beforeDelete(list<Case_Support_Incident__c> oldList)
	{
		for (Case_Support_Incident__c csi : oldList)
		{
			if (csi.Active__c)
			{
				csi.addError('You cannot delete an Attached Bookmark. Please attach another Support Incident to delete this record.');
			}
		}
	}
	
	private map<Id, Case_Support_Incident__c> queryForCsiOnCase(set<Id> caseIdSet)
	{
		return new map<Id, Case_Support_Incident__c>([Select Id, Active__c, Case__c, Support_Incident__c, Related_Bug__c, Patch_Request__c
													  From Case_Support_Incident__c 
													  Where Case__c IN : caseIdSet]);
	}
	
	private map<Id, Case> queryCase(set<Id> caseIdSet)
	{
		return new map<Id, Case>([Select Id, LearnJIRA_SI__c, Support_Incident_Fix__c, Patch_Request__c From Case Where Id IN : caseIdSet]);
	}
	
	private map<Id, learnJIRA__c> querySIs(set<Id> supportIncidentIdSet)
	{
		return new map<Id, learnJIRA__c>([Select Id, Name, (Select Id, Name From Related_Bugs__r) From learnJIRA__c Where Id IN : supportIncidentIdSet]);
	}
	
	private void throwErrors(list<Case_Support_Incident__c> csiList, map<Id, Case_Support_Incident__c> csiOnCaseMap)
	{		
		if (csiList != null && !csiList.isEmpty() && csiOnCaseMap != null && !csiOnCaseMap.isEmpty())
		{
			for (Case_Support_Incident__c csi : csiList)
			{
				if (!csi.Follow__c && (csi.Related_Bug__c != null || csi.Patch_Request__c != null))
				{
					csi.addError('You cannot add a bug or patch that is not being followed.');
				}
				else if (csi.Follow__c && csi.Related_Bug__c == null && csi.Patch_Request__c == null)
				{
					csi.addError('You cannot follow a Support Incident.');
				}
				else if (csi.Active__c && csi.Related_Bug__c != null && csi.Patch_Request__c != null)
				{
					csi.addError('You cannot attach a Related Bug or Patch Request.');
				}
				else 
				{
					for (Case_Support_Incident__c csi2 : csiOnCaseMap.values())
					{
						if (csi.Id != csi2.Id && csi.Case__c == csi2.Case__c && csi.Support_Incident__c == csi2.Support_Incident__c)
						{
							csi.Support_Incident__c.addError('This Support Incident has already been Bookmarked/Attached to this Case.');
						}
					}
				}
			}
		}
	}
	
	private list<Case> modifyCaseFields(list<Case_Support_Incident__c> newList, map<Id, Case_Support_Incident__c> oldMap, map<Id, Case> caseMap, map<Id, learnJIRA__c> siMap)
	{
		map<Id, Case> caseUpdateMap = new map<Id, Case>();
		Case caseObj;
		
		for (Case_Support_Incident__c csi : newList)
		{
			system.debug('csi--'+csi);
			if (caseMap.containsKey(csi.Case__c) && !caseUpdateMap.containsKey(csi.Case__c))
			{
				caseObj = caseMap.get(csi.Case__c);
				if (csi.Active__c && siMap.containsKey(csi.Support_Incident__c))
				{
					caseObj.LearnJIRA_SI__c = csi.Support_Incident__c;
					caseObj.Support_Incident_Fix__c = null;
					system.debug('csi2--'+caseObj.LearnJIRA_SI__c+'--'+caseObj.Support_Incident_Fix__c);
					if (siMap.get(csi.Support_Incident__c).Related_Bugs__r != null && siMap.get(csi.Support_Incident__c).Related_Bugs__r.size() == 1)
					{
						caseObj.Support_Incident_Fix__c = siMap.get(csi.Support_Incident__c).Related_Bugs__r[0].Id;
					}
					caseObj.Patch_Request__c = null;
				}
				else if (oldMap != null && oldMap.containsKey(csi.Id) && csi.Active__c != oldMap.get(csi.Id).Active__c)
				{
					if(caseObj.LearnJIRA_SI__c == csi.Support_Incident__c)
					{
						caseObj.LearnJIRA_SI__c = null;
						caseObj.Support_Incident_Fix__c = null;
						caseObj.Patch_Request__c = null;
					}
				}
				caseUpdateMap.put(caseObj.Id, caseObj);
			}
		}
		
		return caseUpdateMap.values();
	}
	
	private list<Case_Support_Incident__c> deactivateCSIs(list<Case_Support_Incident__c> csiList, map<Id, Case_Support_Incident__c> csiOnCaseMap)
	{
		list<Case_Support_Incident__c> csiUpdateList = new list<Case_Support_Incident__c>();
		
		if (csiList != null && !csiList.isEmpty() && csiOnCaseMap != null && !csiOnCaseMap.isEmpty())
		{
			for (Case_Support_Incident__c csi : csiList)
			{
				if (csi.Active__c)
				{
					for (Case_Support_Incident__c csi2 : csiOnCaseMap.values())
					{
						if (csi.Id != csi2.Id && csi.Case__c == csi2.Case__c && csi2.Active__c)
						{
							csi2.Active__c = false;
							csiUpdateList.add(csi2);
						}
					}
				}
			}
		}
		return csiUpdateList;
	}
	
	private list<learnJIRA__c> modifySupportIncidentFields(list<Case_Support_Incident__c> newList, map<Id, Case_Support_Incident__c> oldMap, map<Id, learnJIRA__c> siMap)
	{
		list<learnJIRA__c> siUpdateList = new list<learnJIRA__c>();
		
		for (Case_Support_Incident__c csi : newList)
		{
			if (oldMap != null && oldMap.containsKey(csi.Id) && !csi.Active__c && oldMap.get(csi.Id).Active__c && siMap != null && siMap.containsKey(csi.Support_Incident__c))
			{
				siUpdateList.add(siMap.get(csi.Support_Incident__c));
			}
		}
		
		return siUpdateList;
	}
	
	private void updateCaseList(list<Case> caseList)
	{
		if (caseList != null && !caseList.isEmpty())
		{
			try
			{
				update caseList;
			}
			catch (DmlException e)
			{
				system.debug('Case Update Failed!');
				list<Exception_Log__c> logList = new list<Exception_Log__c>();
				Exception_Log__c el;
				for (Integer i = 0; i < e.getNumDml(); i++)
				{
			        // Process exception here
			        el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
			        	Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
			        logList.add(el);
			    }
				insert logList;
			}
		}
	}
	
	private void updateCsiList(list<Case_Support_Incident__c> csiList)
	{
		if (csiList != null && !csiList.isEmpty())
		{
			try
			{
				update csiList;
			}
			catch (DmlException e)
			{
				system.debug('Case Support Incident Update Failed!');
				list<Exception_Log__c> logList = new list<Exception_Log__c>();
				Exception_Log__c el;
				for (Integer i = 0; i < e.getNumDml(); i++)
				{
			        // Process exception here
			        el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
			        	Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
			        logList.add(el);
			    }
				insert logList;
			}
		}
	}
	
	private void updateSupportIncidentList(list<learnJIRA__c> siList)
	{
		if (siList != null && !siList.isEmpty())
		{
			try
			{
				update siList;
			}
			catch (DmlException e)
			{
				system.debug('Support Incident Update Failed!');
				list<Exception_Log__c> logList = new list<Exception_Log__c>();
				Exception_Log__c el;
				for (Integer i = 0; i < e.getNumDml(); i++)
				{
			        // Process exception here
			        el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
			        	Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
			        logList.add(el);
			    }
				insert logList;
			}
		}
	}
	@Istest
	public static  void testHandler()
	{
		Core_License__c cl = TestMethodUtility.createCoreLicense();
		insert cl;
		Module__c m = TestMethodUtility.createModule(cl);
		insert m;
		Account a = TestMethodUtility.createAccount();
		insert a;
		Contact con = TestMethodUtility.createContact(a);
		insert con;
		Case c = TestMethodUtility.createCase(con, cl, a, m);
		insert c;
		learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
		insert lj;
		list<Related_Bug__c> relatedBugs = new list<Related_Bug__c>();
		Related_Bug__c rb;
		for (Integer i = 0; i < 5; i ++)
		{
			rb = TestMethodUtility.createRelatedBug(lj);
			relatedBugs.add(rb);
		}
		insert relatedBugs;
		
		// Begin Testing
		Test.startTest();
		// Test an insert
		
		try
		{
			list<Case_Support_Incident__c> csiList = new list<Case_Support_Incident__c>();
			Case_Support_Incident__c csi;
			
			for (Integer i = 0; i < 3; i++)
			{
				csi = TestMethodUtility.createCaseSupportIncident(c, lj);
				csi.Active__c = true;
				csiList.add(csi);
			}
			insert csiList;
			
			// Test a duplicate
			csi = TestMethodUtility.createCaseSupportIncident(c, lj);
			
			try
			{
				insert csi;
			}
			catch (DMLException e){}			
			csi = TestMethodUtility.createCaseSupportIncident(c, lj);
			csi.Active__c = true;
			insert csi;
			try
			{
				delete csi;
			}
			catch (DMLException e){}			
			csi = TestMethodUtility.createCaseSupportIncident(c, lj);
			insert csi;
			csi.Active__c = true;
			try
			{
				update csi;
			}
			catch (DMLException e){}
			csi = [Select Id, Active__c, IsDeleted From Case_Support_Incident__c Where Id =: csi.Id];
		}
		catch (Exception e){}
		
		// End Testing
		Test.stopTest();		
	}
}