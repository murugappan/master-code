// This class is for all Javascript Buttons that need to execute APEX

global class JSButtonAndLink 
{
	webservice static Integer doesSupportIncidentHaveCases(Id supportIncidentId)
	{
		// This is the list of Cases related to this SI
		try
		{
			learnJIRA__c lj = [Select Id, Master_Case__c From learnJIRA__c Where Id =: supportIncidentId];
			
			list<Case> relatedCaseList = [Select Id, CaseNumber From Case Where learnJIRA_SI__c =: lj.Id And IsClosed = false];
			
			if (relatedCaseList == null || relatedCaseList.isEmpty())
			{
				return 0;
			}
			else if (relatedCaseList.size() == 1 && relatedCaseList[0].Id == lj.Master_Case__c)
			{
				return 1;
			}
			
			return 2;
		}
		catch (Exception e)
		{
			return 3;
		}
	}
	
	public static testMethod void testWebService()
	{
		Account a = TestMethodUtility.createAccount();
	    insert a;
	    Core_License__c cl = TestMethodUtility.createCoreLicense();
	    insert cl;
	    Contact con = TestMethodUtility.createContact(a);
	    insert con;
	    Module__c m = TestMethodUtility.createModule(cl);
	    insert m;
	    Case c = TestMethodUtility.createCase(con, cl, a, m);
	    insert c;
	    
	    Test.startTest();
	    	JSButtonAndLink.doesSupportIncidentHaveCases(null);
	    	learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
	    	insert lj;	      	
	    	JSButtonAndLink.doesSupportIncidentHaveCases(lj.Id);
	   	Test.stopTest();	
	}
}