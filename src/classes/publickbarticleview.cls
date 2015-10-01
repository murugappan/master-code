public without sharing class publickbarticleview 
{   

    public publickbarticleview btbbController {get {return this;}} // To be passed to rendered VF components, avoids re-instantiation of controller
    public KnowledgeArticleWrapper mainArticle {get; private set;}
    public transient list<KnowledgeArticleWrapper> servicePackList {get; private set;}
    public transient list<KnowledgeArticleWrapper> knownIssuesList {get; private set;}
    public transient list<KnowledgeArticleWrapper> resolvedIssuesList {get; private set;}
    public Boolean hasServicePacks {get{if (hasServicePacks == null) return false; return hasServicePacks;} set;}
    public Boolean hasResolvedIssues {get{if (hasResolvedIssues == null) return false; return hasResolvedIssues;} set;}
    public Boolean hasKnownIssues {get{if (hasKnownIssues == null) return false; return hasKnownIssues;} set;}
    public String caseId {get; private set;}
    public Boolean hasAttachments {get; private set;}
    public Boolean hasFeedback {get; private set;}
    public Boolean hasArticle {get {if (hasArticle == null) return false; return hasArticle;} private set;}
    public String noArticleMessage {get; private set;}
    public Boolean isPrint {get; private set;}
    public String feedbackRanking {get; set;}
    public Boolean hasRankingError {get {if (hasRankingError == null) return false; return hasRankingError;} private set;}
    public Case caseObj {get; set;}
    public list<SelectOption> feedbackOptionList {get; private set;}
    public list<Case_Attachment__c> caseAttachmentList {get; private set;}
    public S3.AmazonS3 as3 { get; private set; }
    public AWSKeys credentials {get;set;}
    public string secret {get {return credentials.secret;}}
    public string key {get {return credentials.key;}}
    public Boolean isRunFromTest {get{if (isRunFromTest == null) return false; return isRunFromTest;} set;}
    private KnowledgeArticleVersion kav;
    private Solution solution;
    private map<String, Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
    private map<String, String> articlePrefixLabelMap;
    private list<Knowledge_Article_Feedback__c> feedbackList; // Need to replace with Knowledge feedback
    private String AWSCredentialName = 'Test Amazon Connection'; 
    private Knowledge_Follow__c kf =new Knowledge_Follow__c();
    public string tooltip{get;set;}
    public publickbarticleview()
    {   
        isPrint = false;
        if (ApexPages.currentPage().getParameters().get('print') == 'true')
        {
            isPrint = true;
        }
        caseId = ApexPages.currentPage().getParameters().get('cid');
        
               
        
        
        loadArticleTypes();
        loadArticleVersion();
        loadArticle();
        if (mainArticle != null)
        {
            laodFeedbackOptionList();
            loadCaseAttachmentList();
            loadFeeback();
            loadCase();
            try
            {
                credentials = new AWSKeys(AWSCredentialName);
                as3 = new S3.AmazonS3(credentials.key,credentials.secret);
            }
            catch (AWSKeys.AWSKeysException AWSEx)
            {
                system.debug('Caught exception ' + AWSEx);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
                ApexPages.addMessage(errorMsg);
            }
        }
    }
    
    public publickbarticleview(string kaid)
    {   
        ApexPages.currentPage().getParameters().put('id',kaid);
        isPrint = false;
        if (ApexPages.currentPage().getParameters().get('print') == 'true')
        {
            isPrint = true;
        }
        caseId = ApexPages.currentPage().getParameters().get('cid');
        
               
        
        
        loadArticleTypes();
        loadArticleVersion();
        loadArticle();
        if (mainArticle != null)
        {
            laodFeedbackOptionList();
            loadCaseAttachmentList();
            loadFeeback();
            loadCase();
            try
            {
                credentials = new AWSKeys(AWSCredentialName);
                as3 = new S3.AmazonS3(credentials.key,credentials.secret);
            }
            catch (AWSKeys.AWSKeysException AWSEx)
            {
                system.debug('Caught exception ' + AWSEx);
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
                ApexPages.addMessage(errorMsg);
            }
        }
    }
    public void loadArticleVersion()
    {
        try
        {
            kav = [Select KnowledgeArticleId, Title, ArticleNumber, Summary 
                    From KnowledgeArticleVersion 
                    Where IsVisibleInPkb = true
                    And KnowledgeArticleId =: ApexPages.currentPage().getParameters().get('id')
                    And PublishStatus = 'Online'
                    And Language = 'en_US' UPDATE VIEWSTAT];
        }
        catch (Queryexception e)
        {
            try
            {
                solution = [Select Id, Knowledge_Article_ID__c, Knowledge_Article_Version_ID__c From Solution Where Id =: ApexPages.currentPage().getParameters().get('id')];
                system.debug(solution);
                try
                {
                    kav = [Select KnowledgeArticleId, Title, ArticleNumber, Summary 
                            From KnowledgeArticleVersion 
                            Where IsVisibleInPkb = true
                            And KnowledgeArticleId =: solution.Knowledge_Article_ID__c
                            And PublishStatus = 'Online'
                            And Language = 'en_US' UPDATE VIEWSTAT];
                }
                catch (Queryexception e2)
                {
                    kav = new KnowledgeArticleVersion();
                    noArticleMessage = 'Your article was not migrated to Knowledge.';
                }
            }
            catch (Queryexception e1)
            {
                kav = new KnowledgeArticleVersion();
                solution = new Solution();
                noArticleMessage = 'Your article id is invalid.';
            }
        }
    }
    
    public void loadArticleTypes()
    {
        list<String> articleTypeNameList = new list<String>();
        articlePrefixLabelMap = new map<String, String>();
        
        for (String s : globalDescribeMap.keySet()) 
        {
            if (s.endswith('__kav')) 
            {
                articleTypeNameList.add(s);
                Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
                articlePrefixLabelMap.put(r.getKeyPrefix(), r.getLabel());
            }
        }        
    }
    
    public void laodFeedbackOptionList()
    {
        feedbackOptionList = new list<SelectOption>(); 
        feedbackOptionList.add(new SelectOption('1','Yes, I was able to resolve my issue')); 
        feedbackOptionList.add(new SelectOption('2','Yes, but instructions were unclear')); 
        feedbackOptionList.add(new SelectOption('3','Yes, but it did not solve my issue')); 
        feedbackOptionList.add(new SelectOption('4','No, it was not helpful at all'));
    }
    
    public PageReference exportToPDF()
    {
        return Page.btbb_exportarticlepdf;
        
    }
    
    public void loadArticle()
    {
        String prefix, articleLabel, versionId;
        hasArticle = true;
        
        if (kav != null && kav.Id != null && kav.KnowledgeArticleId != null)
        {
            versionId = kav.Id;
            prefix = versionId.substring(0, 3);
            
            if (articlePrefixLabelMap.containsKey(prefix))
            {
                articleLabel = articlePrefixLabelMap.get(prefix);
                
                if (articleLabel == 'Announcement')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryAnnouncement(articleLabel, kav);
                }
                else if (articleLabel == 'Known Issue')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryKnownIssue(articleLabel, kav);
                }
                else if (articleLabel == 'Other Resource')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryOtherResource(articleLabel, kav);
                }
                else if (articleLabel == 'Product Documentation')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryProductDocumentation(articleLabel, kav);
                }
                else if (articleLabel == 'Question/Answer')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryQuestionAnswer(articleLabel, kav);
                }
                else if (articleLabel == 'Release')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryRelease(articleLabel, kav);
                    servicePackList = QueryKnowledgeArticleUtility.queryServicePackArticleList(mainArticle);
                    
                    for(integer i=0; i<servicePackList.size()-1 ;i++)    //TP2810 added by Varghese 
                    {
                         knowledgearticlewrapper temp;
                       for(integer y= i+1;y<=servicepacklist.size()-1;y++)
                        {
                        if((servicepacklist[i].releasedate<servicepacklist[y].releasedate)||(servicepacklist[i].releasedate == null ))
                        {
                        temp=   servicepacklist[i];
                        servicepacklist[i]=servicepacklist[y];
                        servicepacklist[y]=temp;
                        }
                        }   
                    }
                    
                    if (servicePackList != null && !servicePackList.isEmpty())
                    {
                        hasServicePacks = true;
                    }
                    knownIssuesList = QueryKnowledgeArticleUtility.queryRelatedKnownIssueList(mainArticle);
                    if (knownIssuesList != null && !knownIssuesList.isEmpty())
                    {
                        hasKnownIssues = true;
                    }
                }
                else if (articleLabel == 'Maintenance Release')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryMaintenanceRelease(articleLabel, kav);
                    resolvedIssuesList = QueryKnowledgeArticleUtility.queryResolvedIssuesList(mainArticle);
                    //system.assert(false, resolvedIssuesList);
                    system.debug(LoggingLevel.DEBUG, resolvedIssuesList);
                    if (resolvedIssuesList != null && !resolvedIssuesList.isEmpty())
                    {
                        hasResolvedIssues = true;
                    }
                    knownIssuesList = QueryKnowledgeArticleUtility.queryRelatedKnownIssueList(mainArticle);
                    if (knownIssuesList != null && !knownIssuesList.isEmpty())
                    {
                        hasKnownIssues = true;
                    }
                }
                else if (articleLabel == 'General Article')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryGeneralArticle(articleLabel, kav);
                }
                else if (articleLabel == 'Support Bulletin/Security Advisory')
                {
                    mainArticle = QueryKnowledgeArticleUtility.querySupportBulletin(articleLabel, kav);
                }
                else if (articleLabel == 'Supported Technologies')
                {
                    mainArticle = QueryKnowledgeArticleUtility.querySupportedTechnology(articleLabel, kav);
                }
                else if (articleLabel == 'Troubleshooting/Informational')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryTroubleshootingInformation(articleLabel, kav);
                }
                else if (articleLabel == 'Blackboard Client Program')
                {
                    mainArticle = QueryKnowledgeArticleUtility.queryBlackboardClientProgram(articleLabel, kav);
                }
            }
        }
        else
        {
            hasArticle = false;
        }
        system.debug(mainArticle);
    }
    
    public void loadCaseAttachmentList()
    {
        caseAttachmentList = [Select c.File_Name_URL__c, c.Related_To_Article__c, c.Notes__c, c.File_Name__c, c.CreatedDate, c.Bucket_Name__c, c.File_Name_w_ext__c, c.CreatedBy.Name, 
                                     c.CreatedById, c.Article_Id__c 
                              From Case_Attachment__c c 
                              Where Article_Id__c =: mainArticle.KnowledgeArticleId
                              And Internal_Only_Attachment__c = false  
                              order BY CreatedDate desc];                       // modified TP2880
        
        hasAttachments = false;           
        if (caseAttachmentList != null && !caseAttachmentList.isEmpty() && !isPrint)
        {
            hasAttachments = true;
        }       
    }
    
    public void loadFeeback()
    {
        feedbackList = [Select Id From Knowledge_Article_Feedback__c Where CreatedById =: UserInfo.getUserId() And Article_ID__c =: mainArticle.articleId];
        
        hasFeedback = false;
        if (feedbackList != null && !feedbackList.isEmpty())
        {
            hasFeedback = true;
        }
    }
    
    public void loadCase()
    {
        try
        {
            caseObj = [Select Id, CaseNumber From Case Where Id =: caseId];
        }
        catch (Queryexception e)
        {
            caseObj = new Case();
        }
    }
    
    public Pagereference addFeedback()
    {
        PageReference pageRef;
        Integer feedbackNumber;
        hasRankingError = false;
        
        if (feedbackRanking != null && feedbackRanking != '')
        {
            feedbackNumber = Integer.valueOf(feedbackRanking);
            if (caseId != null)
            {
                if (feedbackNumber == 1)
                {
                    attachArticleToCase();
                    closeCaseWithArticle();
                }
                else if (feedbackNumber == 2 || feedbackNumber == 3)
                {
                    attachArticleToCase();
                }
            }
            Knowledge_Article_Feedback__c articleFeedback = new Knowledge_Article_Feedback__c();
            articleFeedback.Score__c = feedbackNumber;      
            articleFeedback.Article_ID__c = mainArticle.articleId;
            articleFeedback.Article_Number__c = mainArticle.articleNumber;
            articleFeedback.Article_Title__c = mainArticle.name;
            insert articleFeedback;
            pageRef = new PageReference('/apex/btbb_articleview');
            pageRef.getParameters().put('Id', kav.KnowledgeArticleId);
            pageRef.setRedirect(true);
        }
        else
        {
            hasRankingError = true;
        }
        return pageRef;
        
     }

    
    public void attachArticleToCase()
    {
        CaseArticle caseArticle = new CaseArticle(CaseId = caseId, KnowledgeArticleId = kav.KnowledgeArticleId);
        insert caseArticle; 
    }
    
    public void closeCaseWithArticle()
    {
        Solution_Detail__c solDet = new Solution_Detail__c(Case__c = caseId, Article_Id__c = kav.KnowledgeArticleId, Description__c = 'Problem Solved by KB Article via BTBB.', 
            Status__c = 'Successful Resolution');
        insert solDet;
        Case caseObj = new Case(Id = caseId);
        caseObj.status = 'Closed';
        caseObj.IsSelfServiceClosed = true;
        caseObj.IsClosedByRelevantArticle__c = true;
        update caseObj;
    }
    
    public PageReference closeCase()
    {
        attachArticleToCase();
        closeCaseWithArticle();
        PageReference casePage = Page.btbb_caseview;
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage;   
    }
    
    public PageReference attachArticle()
    { 
        attachArticleToCase();
        PageReference casePage = Page.btbb_caseRelevantArticles;
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage; 
    }
    
    public PageReference rejectArticle()
    {
        PageReference casePage = Page.btbb_caseRelevantArticles;
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage; 
    }
    
    public String getFollowDisplay()
    {
        if (mainArticle != null)
        {
            try
            {
                kf = [Select Id From Knowledge_Follow__c Where Following_Key__c =: mainArticle.knowledgeArticleId and user__c=:Userinfo.getuserid()];
                system.debug('kf---'+kf);
                tooltip='click to stop following this article';
                return 'Unfollow';
            }
            catch (Queryexception e)
            {
                tooltip='click to follow this article';
                return 'Follow';
            }
        }
        
        return null;
    }
    
    public PageReference doFollow()
    {
        if (kf != null && kf.Id != null)
        {
            delete kf;
            kf = new Knowledge_Follow__c();
        }
        else
        {
            kf = new Knowledge_Follow__c();
            kf.User__c = UserInfo.getUserId();
            kf.Type__c = 'Knowledge Article';
            kf.Following_Key__c = mainArticle.knowledgeArticleId;
            insert kf;
        }
        return null;
    }
    
      
}//