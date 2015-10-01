public without sharing class btbb_articleviewController 
{   
    public btbb_articleviewController btbbController {get {return this;}} // To be passed to rendered VF components, avoids re-instantiation of controller
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
    private GlobalComponent gc = new GlobalComponent();
    private String AWSCredentialName = 'Test Amazon Connection'; 
    private Knowledge_Follow__c kf =new Knowledge_Follow__c();
    public string tooltip{get;set;}
    public btbb_articleviewController()
    {   
        isPrint = false;
        if (ApexPages.currentPage().getParameters().get('print') == 'true')
        {
            isPrint = true;
        }
        caseId = ApexPages.currentPage().getParameters().get('cid');
        if(isMLAAdmin)
        {
            caseId=null;
        } 
    }
    
    private void loadArticleVersion()
    {
        try
        {
            kav = [Select KnowledgeArticleId, Title, ArticleNumber, Summary 
                    From KnowledgeArticleVersion 
                    Where IsVisibleInCsp = true
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
                            Where IsVisibleInCsp = true
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
    
    private void loadArticleTypes()
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
        feedbackOptionList.add(new SelectOption('4','Yes, I was able to resolve my issue')); 
        feedbackOptionList.add(new SelectOption('3','Yes, but instructions were unclear')); 
        feedbackOptionList.add(new SelectOption('2','Yes, but it did not solve my issue')); 
        feedbackOptionList.add(new SelectOption('1','No, it was not helpful at all'));
    }
    
    public PageReference exportToPDF()
    {
        return Page.btbb_exportarticlepdf;
        
    }
    
    private void loadArticle()
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
        validateaccess();
        system.debug(mainArticle);
    }
    
    private void loadCaseAttachmentList()
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
    
    private void loadFeeback()
    {
        feedbackList = [Select Id From Knowledge_Article_Feedback__c Where CreatedById =: UserInfo.getUserId() And Article_ID__c =: mainArticle.articleId];
        
        hasFeedback = false;
        if (feedbackList != null && !feedbackList.isEmpty())
        {
            hasFeedback = true;
        }
    }
    
    private void loadCase()
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
                if (feedbackNumber == 4)
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

    // This method will determine if the user is logged in and if the article passed exist
    public PageReference redirect()
    {
        PageReference pageRef;
        
        if ((gc.userRedirect == true || isRunFromTest == true)&& (!(Apexpages.currentpage().getUrl().containsignorecase('btbb_ArticlePrint')||Apexpages.currentpage().getUrl().containsignorecase('btbb_exportarticlepdf'))))
        {
            pageRef = new PageReference(gc.IDMRedirectURL);
            pageRef.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRef.setRedirect(true);
            return pageRef;
        }
        
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
              
        return null;
    }
    
    private void attachArticleToCase()
    {
        CaseArticle caseArticle = new CaseArticle(CaseId = caseId, KnowledgeArticleId = kav.KnowledgeArticleId);
        insert caseArticle; 
    }
    
    private void closeCaseWithArticle()
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
    
    
       public boolean isMLAAdmin {
                
                get {   
                    try{    
                       isMLAAdmin = false;             
                       list<user>u=[select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()];
                        if(u != null && u.size() > 0) {
                            Integer flag = 0;                
                            for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :u[0].ContactId and role__c != null and Expire_Role__c = false AND Contact__c!= NULL]) {
                                if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin'))) {
                                    
                                    isMLAAdmin = true;                      
                                } else {
                                    isMLAAdmin = false;  
                                    break; 
                                }
                            }
                        }         
                            System.debug('isMLAAdmin >>>>>>>>>' +isMLAAdmin);
                            return isMLAAdmin;
                        }
                        catch(exception e)
                        {
                         return false;
                        }
                    }
                set { 
                    if(value != null) isMLAAdmin = value;
                }
         } 
    
    
        public void validateaccess()
        {
            hasArticle = false;
            String BUaccess='';
            List<user> u=[select id,contactid from user where id=:userinfo.getuserid()];
            if(u!= null && u.size()>0)
            {
                for(Contact_Role__c cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c=: u[0].ContactID  AND Expire_Role__c  = false and role__c != null AND Contact__c!= NULL])
                {
                    if(cr.Role__c.containsignorecase('Learn')||cr.Role__c.containsignorecase('Angel')||cr.Role__c.containsignorecase('Vista')||cr.Role__c.containsignorecase('Xythos') )
                    {
                        BUaccess=BUaccess+',Learn_BU,ANGEL_BU,Xythos_BU,CE_Vista_BU';
                    }
                    else if(cr.Role__c.containsignorecase('Collaborate'))
                    {
                        BUaccess=BUaccess+',Collaborate';
                    }
                    
                    else if(cr.Role__c.containsignorecase('Moodlerooms'))
                    {
                        BUaccess=BUaccess+',Moodlerooms';
                    }
                    else if(cr.Role__c.containsignorecase('Analytics'))
                    {
                        BUaccess=BUaccess+',Analytics';
                    }
                    else if(cr.Role__c.containsignorecase('xpLor'))
                    {
                        BUaccess=BUaccess+',xpLor';
                    }
                }
            }
            
            if(mainArticle != null)
            {
                if(mainArticle.dataCategories != null)
                {
                    string dataCatgoryTemp= mainArticle.dataCategories;
                    
                    for(string s:dataCatgoryTemp.split(';',-2))
                    {
                        if(s!= null && s.containsignorecase('Version:'))
                        {
                            for(string c: s.SubStringAfter('Version:').split(','))
                            {
                                if(c=='All')
                                {
                                    hasArticle=true;
                                    break;
                                }
                                string temp= c;
                                while(temp != null && temp != 'All' && Versions__c.getValues(temp.left(38).toLowerCase())!=null)
                                {
                                system.debug('temp--'+temp);
                                    if(Versions__c.getValues(temp.left(38).toLowerCase())!=null)
                                    {
                                        if(BUAccess.ContainsignoreCase(temp))
                                        {
                                           hasArticle = true;
                                           break;
                                          
                                        }
                                        temp= Versions__c.getValues(temp.left(38).toLowerCase()).parent__c;
                                        
                                    }   
                                }
                               if(hasArticle==true)
                               { 
                                break;
                               }
                            }
                            if(hasArticle==true)
                               { 
                                break;
                               }
                        }
                    }
                    
                }
            }
            if(hasArticle==false)
            {
                 //noArticleMessage='We’re sorry, you do not have appropriate permissions to view this item.  Please either submit a support case or contact your institution’s primary administrator if you believe your permissions should be adjusted.';
            
                 noArticleMessage='We’re sorry, but we are not able to display this article for you. Perhaps your institution has not licensed the Blackboard product referenced in the article, or your Behind the Blackboard account is not designated with administrator permissions for the Blackboard product tagged on the article. Please contact your system administrator or submit a support ticket inquiring if a change is required on your account.';            
            
            
            }
        }
         
  private static testmethod void btbb_articleviewTestController(){
   
   Profile p =[Select id, Name from profile where Name='BTBB Profile'];
   
   User u =TestMethodUtility.createUser(p);
   insert u;
    
    Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        
        
        Case cas = TestMethodUtility.createCase1(a,aset);
        Insert cas; 
        
        
        
        Case_Attachment__c ca = new Case_Attachment__c();
        ca.CurrencyIsoCode='GBP';
       // ca.Case_Note__c=cn.id;
        ca.Related_To__c=cas.id;
        ca.UserID__c =u.id; 
        ca.Internal_Only_Attachment__c = false; 
        insert ca;
        
      
        
   // here for knowledgeArticleVersion we are using version:23(for class) and directly quering from database   
    
    KnowledgeArticleVersion krv=  [Select KnowledgeArticleId, Title, ArticleNumber, Summary 
                    From KnowledgeArticleVersion 
                    Where IsVisibleInCsp = true
                    And PublishStatus = 'Online'
                    And Language = 'en_US' limit 1];
                    
             
        
        ApexPages.currentPage().getParameters().put('cid',cas.id);
        ApexPages.currentPage().getParameters().Put('print','true'); 
        ApexPages.currentPage().getParameters().Put('id',krv.KnowledgeArticleId); 
        btbb_articleviewController Controller = new btbb_articleviewController();
        Controller.feedbackRanking='1';
        Controller.caseId=cas.id;
       
        
        Controller.loadArticleVersion();
        Controller.loadArticleTypes();
        Controller.laodFeedbackOptionList();
        Controller.loadArticle();
        Controller.loadCaseAttachmentList();
        Controller.loadFeeback();
        Controller.loadCase();
        Controller.addFeedback();
        Controller.redirect();
        Controller.attachArticleToCase();
        Controller.closeCaseWithArticle();
        Controller.closeCase();
        Controller.attachArticle();
        Controller.rejectArticle();
        controller.getfollowdisplay();
        controller.dofollow();
        
     System.runas(u)
        {   
       ApexPages.currentPage().getParameters().Put('id',Null);  
       btbb_articleviewController Controller1 = new btbb_articleviewController(); 
       Controller1.loadArticleVersion();
      // Controller1.redirect(); 
        }
     } 

     static testMethod void UnitTestMoodleroomsPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Moodlerooms';
        insert cr;



        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'Moodlerooms - Admin';
        
        insert crr;

        system.runAs(u){

      btbb_articleviewController controller1 = new btbb_articleviewController();
      controller1.validateaccess();
      


      }
      }


     }

     static testMethod void UnitTestAnalyticsPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'Analytics';
        insert cr;



        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'ANALYTICS - Admin';
        
        insert crr;

        system.runAs(u){

      btbb_articleviewController controller1 = new btbb_articleviewController();
      controller1.validateaccess();
      controller1.exportToPDF();


      }
      }


     }

      static testMethod void UnitTestxpLorPositiveScenario(){
      user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
      system.runas(sysuser){

        Account ac=TestMethodUtility.createAccount();
        ac.ownerid=userinfo.getuserid();
        ac.PS_Company_ID__c='78907';
        insert ac; 

        Contact cont = new Contact(LastName = 'Contact Last Name', AccountId = ac.id);
        cont.AccountId=ac.id;
        cont.Account=ac;
        cont.PS_Person_Id__c='67367332';
        cont.email='test@bb.com';
        insert cont; 
        
        Profile p1 = [select id,Name from Profile where Name='SRV - BTBB User'];
        User u = TestMethodUtility.createUser(p1);
        u.contactId=cont.id;
        insert u;

        Core_License__c cr = TestMethodUtility.createCoreLicense();
        cr.Name = 'xpLor';
        insert cr;



        Contact_Role__c crr = TestMethodUtility.createContactRole(ac);
        crr.CurrencyIsoCode='GBP';
        crr.Expire_Role__c=False;
        crr.Contact__c=u.contactId;
        crr.Role__c= 'XPLOR - Admin';
        
        insert crr;

        system.runAs(u){

      btbb_articleviewController controller1 = new btbb_articleviewController();
      controller1.validateaccess();
      controller1.exportToPDF();


      }
      }


     }
   
}