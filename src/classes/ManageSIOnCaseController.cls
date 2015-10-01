public with sharing class ManageSIOnCaseController 
{
    public class SupportIncident
    {
        public learnJIRA__c supportIncident {get; set;}
        public list<SupportIncidentChild> children {get; set;}
        public map<Id, Related_Bug__c> bugMap {get; set;}
        public map<Id, Patch_Request__c> patchMap {get; set;}
        public Boolean isAttached {get; set;}
        public Boolean hasBugs {get; set;}
        public Boolean hasPatches {get; set;}
        private Case_Support_Incident__c caseSI;
        private Case caseObj;
        
        public SupportIncident (learnJIRA__c si, list<Related_Bug__c> bList, list<Patch_Request__c> pList, Case_Support_Incident__c csi, Case c)
        {
            supportIncident = si;
            isAttached = false;
            caseSI = csi;
            caseObj = c;
            loadChildren(bList, pList);
        }
        
        private void loadChildren(list<Related_Bug__c> rbs, list<Patch_Request__c> ps)
        {
            children = new list<SupportIncidentChild>();
            bugMap = new map<Id, Related_Bug__c>();
            patchMap = new map<Id, Patch_Request__c>();
            hasBugs = false;
            hasPatches = false;
            
            if (rbs != null && !rbs.isEmpty())
            {
                hasBugs = true;
                for (Related_Bug__c rb : rbs)
                {
                    children.add(new SupportIncidentChild(rb, caseObj));
                    bugMap.put(rb.Id, rb);
                }
            }
            if (ps != null && !ps.isEmpty())
            {
                hasPatches = true;
                for (Patch_Request__c p : ps)
                {
                    children.add(new SupportIncidentChild(p, caseObj));
                    patchMap.put(p.Id, p);
                }
            }
        }
        
        public PageReference modifyAttachment()
        {
            caseSI.Active__c = isAttached;
            if(isAttached)
            {
            	this.caseobj.LearnJIRA_SI__c=supportIncident.Id;
            }
            else{
            	this.caseobj.LearnJIRA_SI__c=null;
            }
            try
            {
                update caseSI;
             //   update this.caseobj; ////TP4262
            }
            catch (DmlException e)
            {
                ApexPages.addMessages(e);
                return null;
            }
            
            PageReference pageRef = Page.ManageSIOnCase;
            pageRef.getParameters().put('id', caseObj.Id);
            pageRef.getParameters().put('reload', 'true');
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public class SupportIncidentChild
    {
        public Related_Bug__c bug {get; set;}
        public Patch_Request__c patch {get; set;}
        public Id recordId {get; set;}
        public Boolean isBug {get; set;}
        public Boolean isPatch {get; set;}
        public Boolean isFollowed {get; set;}
        private Case caseObj;
        
        public SupportIncidentChild(Related_Bug__c rb, Case c)
        {
            bug = rb;
            recordId = rb.Id;
            caseObj = c;
            patch = null;
            isBug = true;
            isPatch = false;
            isFollowed = false;
        }
        
        public SupportIncidentChild(Patch_Request__c p, Case c)
        {
            patch = p;
            recordId = p.Id;
            caseObj = c;
            bug = null;
            isPatch = true;
            isBug = false;
            isFollowed = false;
        }
        
        public PageReference modifyFollow()
        {
            if (isBug)
            {
                if (isFollowed)
                {
                    caseObj.Support_Incident_Fix__c = bug.Id;
                    //caseObj.Patch_Request__c = null;
                }
                else
                {
                    caseObj.Support_Incident_Fix__c = null;
                }
            }
            else if (isPatch)
            {
                if (isFollowed)
                {
                    caseObj.Patch_Request__c = patch.Id;
                    //caseObj.Support_Incident_Fix__c = null;
                }
                else
                {
                    caseObj.Patch_Request__c = null;
                }
            }
            
            try
            {
                update caseObj;
            }
            catch (DmlException e)
            {
                ApexPages.addMessages(e);
                return null;
            }
            
            PageReference pageRef = Page.ManageSIOnCase;
            pageRef.getParameters().put('id', caseObj.Id);
            pageRef.getParameters().put('reload', 'true');
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    public Case caseObj {get; set;}
    public Boolean isPageError {get; set;}
    public list<SupportIncident> siList {get; set;}
    public String searchString {get; set;}
    private list<Case_Support_Incident__c> bookmarkList;
    private map<Id, SupportIncident> siDisplayMap;
    public String pageURL 
    {
        get
        {
            ApexPages.StandardController sc = new ApexPages.StandardController(caseObj);    
            PageReference pageRef = sc.view();
            return pageRef.getUrl();
        } set;
    }
    public Boolean reloadNeeded {get; set;}
    public Boolean isSearch {get; set;}
    
    public ManageSIOnCaseController(ApexPages.StandardController stdController)
    {
        reloadNeeded = false;
        if (ApexPages.currentPage().getParameters().get('reload') == 'true')
        {
            reloadNeeded = true;
        }
        isPageError = false;
        loadCase();
        loadTree();
        isSearch = false;
    }
    
    private void loadCase()
    {
        try
        {
            caseObj = [Select Id, CaseNumber, LearnJIRA_SI__c, Support_Incident_Fix__c, Patch_Request__c, Status 
                       From Case 
                       Where Id =: ApexPages.currentPage().getParameters().get('id')];
        }
        catch (QueryException e)
        {
            caseObj = new Case();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There is no Case for this page. Please retry.'));
            isPageError = true;
        }
    }
    
    private void loadTree()
    {
        map<Id, Case_Support_Incident__c> siCsiMap = new map<Id, Case_Support_Incident__c>();
        set<Id> supportIncidentIdSet = new set<Id>();
        bookmarkList = new list<Case_Support_Incident__c>();
        siDisplayMap = new map<Id, SupportIncident>();
        siList = new list<SupportIncident>();
        SupportIncident tempSI;
        
        for (Case_Support_Incident__c csi : [Select c.Support_Incident__c, c.Related_Bug__c, c.Not_Fixed_Reason__c, c.Name, c.Id, c.Follow__c, c.Fix_Version__c, c.Fix_Timeframe__c, 
                                                    c.Fix_Status__c, c.Case__c, c.Active__c
                                             From Case_Support_Incident__c c 
                                             Where Case__c =: caseObj.Id
                                             And Support_Incident__c != null])
        {
            if (csi.Support_Incident__c != null)
            {
                supportIncidentIdSet.add(csi.Support_Incident__c);
                siCsiMap.put(csi.Support_Incident__c, csi);
            }
        }
        
        if (supportIncidentIdSet != null && !supportIncidentIdSet.isEmpty())
        {
            for (learnJIRA__c lj : [Select Id, Name, Summary__c, Status__c, (Select Id, Name, Status__c, Timeframe__c, Not_Fixed_Reason__c From Related_Bugs__r), 
                                          (Select Id, Name, Codeline_Patch__c, Status__c, Support_Comment__c, Version__c From Patch_Requests__r) 
                                    From learnJIRA__c 
                                    Where Id IN : supportIncidentIdSet])
            {
                if (siCsiMap.containsKey(lj.Id))
                {
                    tempSI = new SupportIncident(lj, lj.Related_Bugs__r, lj.Patch_Requests__r, siCsiMap.get(lj.Id), caseObj);
                    if (siCsiMap.get(lj.Id).Active__c)
                    {
                        tempSI.isAttached = true;
                    }
                    siList.add(tempSI);
                    siDisplayMap.put(lj.Id, tempSI);
                }
            }
            
            if (caseObj.LearnJIRA_SI__c != null && (caseObj.Support_Incident_Fix__c != null || caseObj.Patch_Request__c != null))
            {
                if (siDisplayMap.containsKey(caseObj.LearnJIRA_SI__c))
                {
                    for (SupportIncidentChild sic : siDisplayMap.get(caseObj.LearnJIRA_SI__c).children)
                    {
                        if (caseObj.Support_Incident_Fix__c != null && sic.bug != null && sic.bug.Id == caseObj.Support_Incident_Fix__c)
                        {
                            sic.isFollowed = true;
                            //break;
                        }
                        if (caseObj.Patch_Request__c != null && sic.patch != null && sic.patch.Id == caseObj.Patch_Request__c)
                        {
                            sic.isFollowed = true;
                            //break;
                        }
                    }
                }
            }
        }
    }
    
    public PageReference doCreateSI()
    {
        PageReference pageRef = Page.CreateSupportIncident;
        pageRef.getParameters().put('cid', caseObj.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference doSearchSI()
    {
        PageReference pageRef = Page.SupportIncidentConsole;
        pageRef.getParameters().put('cid', caseObj.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}