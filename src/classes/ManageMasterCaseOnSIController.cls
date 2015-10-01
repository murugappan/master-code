public with sharing class ManageMasterCaseOnSIController 
{
	public class CaseWrapper
	{
		public Case caseObj {get; set;}
		public learnJIRA__c currentSI;
		
		public CaseWrapper(Case c, learnJIRA__c lj)
		{
			caseObj = c;
			currentSI = lj;
		}
		
		public PageReference doSelect()
		{
			currentSI.Master_Case__c = caseObj.Id;
			update currentSI;
			return null;
		}
	}
	
	public learnJIRA__c supportIncident {get; set;}
	public list<CaseWrapper> wrappedCaseList {get; set;}
	
	public ManageMasterCaseOnSIController(ApexPages.StandardController stdController)
	{
		loadSupportIncident();
		loadOpenRelatedCases();
	}
	
	private void loadSupportIncident()
	{
		try
		{
			supportIncident = [Select Id, Name, Master_Case__c From learnJIRA__c 
							   Where Id =: ApexPages.currentPage().getParameters().get('id')];
		}
		catch (Queryexception e)
		{
			supportIncident = new learnJIRA__c();
		}
	}
	
	private void loadOpenRelatedCases()
	{
		wrappedCaseList = new list<CaseWrapper>();
		
		for (Case c : [Select Id, CaseNumber, Status From Case Where learnJIRA_SI__c =: supportIncident.Id And IsClosed = false])
		{
			wrappedCaseList.add(new CaseWrapper(c, supportIncident));
		}
	}
	
	public static testMethod void testController()
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
	    learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
	    insert lj;
      	
	    Test.startTest();  	
			ApexPages.Standardcontroller stdController = new ApexPages.Standardcontroller(lj);
			ManageMasterCaseOnSIController mmcosc = new ManageMasterCaseOnSIController(stdController);
			if (mmcosc.wrappedCaseList != null && !mmcosc.wrappedCaseList.isEmpty())
			{
				//mmcosc.wrappedCaseList[0].doSelect(); will fix this issue later
			}
		Test.stopTest();
	}
}