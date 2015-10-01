public with sharing class SupportIncidentsOnCase 
{
	public Case caseObj {get; set;}
	public learnJIRA__c supportIncident {get; set;}
	public Related_Bug__c relatedBug {get; set;}
	public Patch_Request__c patchRequest {get; set;}
	public Case_Support_Incident__c bookmark {get; set;}
	
	public SupportIncidentsOnCase(ApexPages.StandardController stdController)
	{
		loadCase();
		loadSupportIncident();
		loadRelatedBug();
		loadPatchRequest();
		loadBookmark();
	}
	
	private void loadCase()
	{
		try
		{
			caseObj = [Select Id, CaseNumber, learnJIRA_SI__c, Support_Incident_Fix__c, Patch_Request__c From Case Where Id =: ApexPages.currentPage().getParameters().get('id')];
		}
		catch (QueryException e)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There is no Case for this page. Please retry.'));
			caseObj = new Case();
		}
	}
	
	private void loadSupportIncident()
	{
		if (caseObj.LearnJIRA_SI__c != null)
		{
			try
			{
				supportIncident = [Select Id, Name, Status__c From learnJIRA__c Where Id =: caseObj.LearnJIRA_SI__c];
			}
			catch (QueryException e)
			{
				supportIncident = new learnJIRA__c();
			}
		}
		else
		{
			supportIncident = new learnJIRA__c();
		}
	}
	
	private void loadRelatedBug()
	{
		if (caseObj.Support_Incident_Fix__c != null)
		{
			try
			{
				relatedBug = [Select Id, Name, Status__c From Related_Bug__c Where Id =: caseObj.Support_Incident_Fix__c];
			}
			catch (QueryException e)
			{
				relatedBug = new Related_Bug__c();
			}
		}
		else
		{
			relatedBug = new Related_Bug__c();
		}
	}
	
	private void loadPatchRequest()
	{
		if (caseObj.Patch_Request__c != null)
		{
			try
			{
				patchRequest = [Select Id, Name, Status__c From Patch_Request__c Where Id =: caseObj.Patch_Request__c];
			}
			catch (QueryException e)
			{
				patchRequest = new Patch_Request__c();
			}
		}
		else
		{
			patchRequest = new Patch_Request__c();
		}
	}
	
	private void loadBookmark()
	{
		try
		{
			bookmark = [Select Id, Name, Support_Incident__c, Emails_Sent__c From Case_Support_Incident__c Where Case__c =: caseObj.Id And Active__c = true];
		}
		catch (QueryException e)
		{
			bookmark = new Case_Support_Incident__c();
		}
	}
	
	private static testmethod void CreateSupportIncidentControllerTest()
	{
        Account a = TestMethodUtility.createAccount();
        insert a;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;    
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        Test.startTest();
	        PageReference pageRef = Page.SupportIncidentsOnCase;
	        pageRef.getParameters().put('id', c.Id);
	        ApexPages.StandardController stdController = new ApexPages.StandardController(c);
	        SupportIncidentsOnCase csic = new SupportIncidentsOnCase(stdController);
		Test.stopTest();
    }
}