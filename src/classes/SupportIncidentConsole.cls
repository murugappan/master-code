public with sharing class SupportIncidentConsole 
{
    public list<SupportIncidentWrapper> siList {get; private set;}
    public Case caseObj {get; set;}
    public String coreLicense {get; set;}
    public Asset assetObj {get; set;}
    public String assetVersion {get; set;}
    public String searchText {get; set;}
    public Boolean validSearch {get; private set;}
    private String privateSearchText;
    
    public class SupportIncidentWrapper
    {
    	public Boolean showLinks {get; set;}
    	public learnJIRA__c supportIncident {get; private set;}
    	private Case caseObj;
    	private PageReference pageRef;
    	
    	public SupportIncidentWrapper(learnJIRA__c lj, Case c)
    	{
    		showLinks = true;
    		supportIncident = lj;
    		caseObj = c;
    		pageRef = Page.ManageSIOnCase;
    		pageRef.getParameters().put('id', c.Id);
    		pageRef.setRedirect(true);
    	}
    	
    	public PageReference doAttach()
    	{
    		Case_Support_Incident__c csi = new Case_Support_Incident__c(Case__c = caseObj.Id, Support_Incident__c = supportIncident.Id, Active__c = true);
    		this.caseobj.LearnJIRA_SI__c=supportIncident.Id; //TP4262
	        try
	        {
	            insert csi;
	         //   update caseobj;
	        }
	        catch (DMLException e)
	        {
	            ApexPages.addMessages(e);
	            return null;
	        }
    		return pageRef;
    	}
    	
    	public PageReference doBookmark()
    	{
    		Case_Support_Incident__c csi = new Case_Support_Incident__c(Case__c = caseObj.Id, Support_Incident__c = supportIncident.Id);
	        try
	        {
	            insert csi;
	        }
	        catch (DMLException e)
	        {
	            ApexPages.addMessages(e);
	            return null;
	        }
    		return pageRef;
    	}
    }
    
    public SupportIncidentConsole() 
    {
        validSearch = false;
        searchText = ApexPages.currentPage().getParameters().get('input');
        privateSearchText = null;
        
        loadCase();
        loadAsset();
        if (assetObj.version__c != null && assetObj.version__c.length() >= 3)
        {
            assetVersion = assetObj.version__c.substring(0,3);
        }
        else
        {
            assetVersion = 'THIS ASSET DOES NOT HAVE A VALID VALUE FOR VERSION PLEASE UPDATE RECORD ACCORDINGLY AND TRY AGAIN';
        }
        loadSupportIncidentList();
    }
    
    private void loadCase()
    {
        try
        {
            caseObj = [Select Core_License__c, Core_License__r.Name, OwnerId, Id, Status, Portal_Status__c, LearnJIRA_SI__c, AssetId, Asset.Version_Build__c,RecordType.Name 
                       From Case 
                       Where Id =: Apexpages.currentPage().getParameters().get('cid')];
        }
        catch (Exception e)
        {
            caseObj = new Case();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is no Case associated with this page. This list is only SI\'s that have no Related Bugs.'));
        }
    }
    
    private void loadAsset()
    {
        try
        {
            assetObj = [Select Id, Version__c From Asset Where id =: caseObj.AssetId];
        }
        catch (Exception e)
        {
            assetObj = new Asset();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There is no Asset associated with this page.'));
        }
    }
    
    private void loadSupportIncidentList()
    {
        if (searchtext != null && searchText.length() > 1)
        {
            siList = new list<SupportIncidentWrapper>();
            validSearch = true;
            privateSearchText = '%' + searchText + '%';
            assetVersion = '%'+AssetVersion+'%';
            
            for (learnJIRA__c lj : [Select Id, Name, Summary__c, Target_Release__c, Status__c, JIRA_Key__c, Tier_2_Assessment__c, Steps_to_Replicate_HTML__c, Number_of_Related_Bugs__c,
                                           Not_Fixed_Reason__c
                                    From learnJIRA__c
                                    Where (Product_Id__c =: caseObj.Core_License__r.Name OR Business_Unit__c =:caseObj.Core_License__r.Name Or RecordType.Name =:caseObj.RecordType.Name )
                                    And (Summary__c like : privateSearchText Or Name like : privateSearchText Or JIRA_Key__c like : privateSearchText)
                                    limit 1000])
            {
                if (siList.size() < 1000)
                {
                    siList.add(new SupportIncidentWrapper(lj, caseObj));
                }
            }
            if (siList.size() == 1000)
            {
                validSearch = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are more that 1000 rows for your search criteria. Please add more detail.'));
            }
        }
        else if (ApexPages.currentPage().getParameters().containsKey('input'))
        {
            validSearch = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a search criteria.'));
        }
    }
    
    public PageReference searchIssues()
    {       
        if (searchText == null)
        {
            searchText = '';
        }
        
        PageReference pageRef = Page.SupportIncidentConsole;
        pageRef.getParameters().put('cid', caseObj.Id);
        pageRef.getParameters().put('input', searchText);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference doCancel()
    {
        PageReference pageRef = Page.ManageSIOnCase;
        pageRef.getParameters().put('id', caseObj.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public static testMethod void testController()
    {
        Account a = TestMethodUtility.createAccount();
        insert a;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Asset aa = TestMethodUtility.createAsset(a, cl);
        insert aa;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        c.AssetId = aa.Id;
        insert c;
        list<learnJIRA__c> siList = new list<learnJIRA__c>();
        learnJIRA__c lj;
        
        for (Integer i = 0; i < 5; i++)
        {
            lj = TestMethodUtility.createSupportIncident(c);
            lj.Summary__c += i;
            siList.add(lj);
        }
        insert siList;
        list<Related_Bug__c> relatedBugs = new list<Related_Bug__c>();
        Related_Bug__c rb;
        for (Integer i = 0; i < 3; i++)
        {
            rb = TestMethodUtility.createRelatedBug(siList[i]);
            relatedBugs.add(rb);
        }
        insert relatedBugs;
        
        Test.startTest();
            SupportIncidentConsole sic = new SupportIncidentConsole();
            PageReference pageRef = Page.SupportIncidentConsole;
            pageRef.getParameters().put('cid', c.Id);
            Test.setCurrentPageReference(pageRef);
            sic = new SupportIncidentConsole();
            sic.searchText = 'Test';
            pageRef = sic.searchIssues();
            Test.setCurrentPageReference(pageRef);
            sic = new SupportIncidentConsole();
        Test.stopTest();
    }
}