public class articleViewController {
    GlobalComponent gc = new GlobalComponent();
    public Solution solution{get;set;} 
    public String recordName { get; set; }
    //Added by Shirish 10-june-2011 for Solution feedback
    public String voteValue { get; set; }
    public AWSKeys credentials {get;set;}
    private String AWSCredentialName = 'Test Amazon Connection'; 
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public S3.AmazonS3 as3 { get; private set; }
    public Integer size {get; set;}
    String product;
    String release;
    String servicePack;
    public Integer KISize {get; set;}
    public Integer ResolvedKISize {get; set;}
    public Integer RPSize {get; set;}    
    public Integer STSize {get; set;}
    public Transient List<Solution> results;
    public List<Solution> resultsKI = new List<Solution>();
    public Boolean runFromTest;
    public Id productId ;
    public articleViewController(ApexPages.StandardController controller) {
         this.solution = (Solution)controller.getRecord();
        aId = solution.Id;
         rId = solution.RecordTypeId;
          product = solution.Product__c;
          release = solution.Major_Release__c;
          servicePack = solution.Version_s__c;
       //  pid = solution.Product__c.id
         if(rid != null) {
            recordName = [Select Name From RecordType where Id = :rId].Name;
            //recordName = recType.Name;  
         }
              
         try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
         }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
         }  
    }
    public articleViewController() {
    try{
   solution = [Select s.summary__c, s.iscopy__c, s.Last_Updated__c, s.isVisibleCustomerPortal__c, s.isContentReviewCopy__c, s.isApprovalSent__c, s.Visible_in_Partner_Portal__c, s.Visible_in_Customer_Portal__c, s.Visible_Internally__c, s.Version_s__c, s.Upgrade_Paths__c, s.Upgrade_Information__c, s.Type__c, s.TimesUsed, s.Team_s__c, s.Target_Release__c, s.Target_Release_New__c, s.SystemModstamp, s.Symptoms__c, s.Supported_Technologies__c, s.Support_Policy__c, s.Support_Incident__c, s.Steps_to_Reproduce__c, s.Status, s.SolutionNumber, s.SolutionNote, s.SolutionName, s.SI_Name__c, s.Resources_use_to_troubleshoot_this_cp__c, s.Resource_Link__c, s.Resource_Description__c, s.ResourceType__c, s.Resolved_Issues__c, s.Resolution_Workaround__c, s.Release_Notes__c, s.Release_Date__c, s.Related_Resources__c, s.Related_Link_s__c, s.Related_Issue_Key__c, s.Reference_Material__c, s.RecordTypeId, s.Question__c, s.Published_Date__c, s.Public_URL__c, s.Product__c, s.Product_Documentation__c, s.Product_Documentation_New__c, s.Process_Flow__c, s.Process_Details__c, s.Platform_Technologies__c, s.Patch_Versions__c, s.Patch_Comments__c, s.Patch_Available__c, s.ParentId__c, s.OwnerId, s.Other_Information__c, s.Number_of_Clients_Reporting__c, s.NotJunk__c, s.Major_Release__c, s.Link__c, s.LastModifiedDate, s.LastModifiedById, s.Known_Issues__c, s.Issue_Description__c, s.Isrejected__c, s.Is_SME_Reviewed__c, s.IsRunFromTestClass__c, s.IsReviewed, s.IsPublishedInPublicKb, s.IsPublished, s.IsHtml, s.IsDeleted, s.IsClonetoBug__c, s.Internal_Only_Notes__c, s.Internal_Bb_Salesforce_Support_Solution__c, s.Important_Information_about_the_Issue__c, s.Important_Information__c, s.Id, s.How_is_the_component_designed_to_work__c, s.Files_collection_to_troubleshoot_cpnent__c, s.Field_4__c, s.Field_3__c, s.Field_2__c, s.Field_1__c, s.Evaluation_of_logs_information__c, s.Download__c, s.Document_Type__c, s.Document_Summary__c, s.Document_Link__c, s.Document_Details__c, s.Disclaimer__c, s.CurrencyIsoCode, s.CreatedDate, s.CreatedById, s.Client_Technologies__c, s.Change_Status_12_months__c, s.Causes_of_the_common_issues_with_this_cp__c, s.Cause__c, s.Calculate_12_months__c, s.Bulletin_Advisory_Information__c, s.Best_Practice_Information__c, s.Available_Versions__c, s.Approver_Name__c, s.Approval_Comments__c, s.Answer__c, s.Announcing__c, s.Announcement_Detail__c, s.Accessing_the_Build__c 
                        From Solution s
                        Where s.Id =: ApexPages.currentPage().getParameters().get('id')];
         aId = solution.Id;
         rId = solution.RecordTypeId;
          Product = solution.Product__c;
          Release = solution.Major_Release__c;
         ServicePack = solution.Version_s__c;
         if(rid != null) {
            recordName = [Select Name From RecordType where Id = :rId].Name;
            //recordName = recType.Name;  
         }
   }
   catch(QueryException e){
    }
    
   try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
         }catch(AWSKeys.AWSKeysException AWSEx){
             System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
         }   
    }
    // Start TP#1766
    public String getCategories() { 
        set<id> nodeIdSet = new Set<Id>();
        String categories;
        if(aId != null) {
            for(CategoryData catData:[Select CategoryNodeId From CategoryData where RelatedSobjectId = : aId]) {
            
                nodeIdSet.add(catData.CategoryNodeId);
            }
            if(null != nodeIdSet && nodeIdSet.size() > 0)
                for(CategoryNode catNode : [Select MasterLabel From CategoryNode where id IN : nodeIdSet]) {
                    if(categories != null)
                        categories = categories + ', '+ catNode.MasterLabel;
                    else 
                        categories = catNode.MasterLabel;
                    
                }
        }
        return categories;
    }
    //End of TP#1766
    public String getRecordType() { 
    
        if(aId == null && rId == null)
            return '';
        RecordType recType;
        if(rId == null && aId != null) {
            Solution sol = [Select Id, RecordTypeId From Solution where Id = :aId];
            rid = sol.RecordTypeId;        
            
        }
            
        if(rId != null)
            recType = [Select Name, Id From RecordType where Id = :rId];//'012Q00000004YU5']
            
       
            
        if(null != recType) {
            recordName = recType.Name;
            return recType.Name;
        }
        return '';
    }
    
    public PageReference closeCase() {
        System.debug('<<<<<<< In closeCase Method >>>>>>>>');               
        Solution_Detail__c solDet = new Solution_Detail__c(Case__c=CaseId,Article__c=solution.id,Description__c='Problem Solved by KB Article via BTBB.',status__c='Successful Resolution');
        insert solDet;
        CaseSolution caseSol = new CaseSolution(CaseId=caseId,SolutionId=solution.id);
        insert caseSol;        
        Case caseObj = new Case(Id=caseId);
        caseObj.status = 'Closed';
        caseObj.Portal_Status__c = 'Closed';
        caseObj.IsSelfServiceClosed = true;
        caseObj.IsClosedByRelevantArticle__c = true;
        update caseObj;
           
        PageReference casePage = new PageReference('/apex/btbb_caseview');
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage;        
   }
   
    public PageReference selArticle() {
        System.debug('<<<<<<< In selArticle Method >>>>>>>>');               
        CaseSolution caseSol = new CaseSolution(CaseId=caseId,SolutionId=solution.id);
        insert caseSol;
        PageReference casePage = new PageReference('/btbb_caseRelevantArticles');
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage;        
   }
   
  // Public PageReference ChkIsDeleted(){
   
  // }
   public PageReference notHelpful() {
        System.debug('<<<<<<< In notHelpful Method >>>>>>>>');  
        PageReference casePage = new PageReference('/btbb_caseRelevantArticles');
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage;        
   }
    
     public String getSearchKI(){
         PageReference SearchKI = new PageReference('/apex/btbb_articlesearch');
         SearchKI.getparameters().put('recordName',recordName);
         SearchKI.getparameters().put('aType','Known');
              
         SearchKI.getparameters().put('isKISearch','true');
         productId = [select Id from BTBB_KBCategory__c where CategoryName__c = :(product =='Blackboard Learn'?'Learn':product) LIMIT 1].id;   
         SearchKI.getparameters().put('Id',productId);
    //     list<string> versionlist =  Solution.Major_Release__c.split(';')  ;      
    //     release = [select Version__c from BTBB_KBVersion__c where version__c in :versionlist and BTBB_KBCategory__c =:productId LIMIT 1].Version__c;
    //     SearchKI.getparameters().put('release', release);
         SearchKI.getparameters().put('sourceID', Solution.ID);
    //     SearchKI.getparameters().put('servicePack',solution.Version_s__c); 
         SearchKI.setRedirect(true); 
        
         
         return SearchKI.getUrl();
         }
         
      public PageReference SearchKI_targetRelease(){
         PageReference SearchKI = new PageReference('/apex/btbb_articlesearch');
         SearchKI.getparameters().put('recordName',recordName);
         SearchKI.getparameters().put('aType','Known');
              
         SearchKI.getparameters().put('isKISearch','true');
         productId = [select Id from BTBB_KBCategory__c where CategoryName__c = :(product =='Blackboard Learn'?'Learn':product) LIMIT 1].id;   
         SearchKI.getparameters().put('Id',productId);
     //    list<string> versionlist =  Solution.Major_Release__c.split(';')  ;      
     //    release = [select Version__c from BTBB_KBVersion__c where version__c in :versionlist and BTBB_KBCategory__c =:productId LIMIT 1].Version__c;
    //     SearchKI.getparameters().put('release', release);
         SearchKI.getparameters().put('sourceID', Solution.ID);
          SearchKI.getparameters().put('isTarget', 'true');
     //    SearchKI.getparameters().put('servicePack',solution.Version_s__c); 
         SearchKI.setRedirect(true); 
        
         
         
         return SearchKI ;
         }
         
    public String getSearchKI_targetReleaseURL()
    {
        PageReference SearchKI = new PageReference('/apex/btbb_articlesearch');
        SearchKI.getparameters().put('recordName',recordName);
        SearchKI.getparameters().put('aType','Known');
        SearchKI.getparameters().put('isKISearch','true');
        productId = [select Id from BTBB_KBCategory__c where CategoryName__c = :(product =='Blackboard Learn'?'Learn':product) LIMIT 1].id;   
        SearchKI.getparameters().put('Id',productId);
        SearchKI.getparameters().put('sourceID', Solution.ID);
        SearchKI.getparameters().put('isTarget', 'true');
        SearchKI.setRedirect(true); 
        return SearchKI.getUrl();
    }    

    private Id rId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('RecordType') != null) {
                rId = ApexPages.currentPage().getparameters().get('RecordType');
            }
            return rId;
        }
        set { 
            if(value != null) rId = value;
        }
    }
    public Id aId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('Id') != null) {
                aId = ApexPages.currentPage().getparameters().get('Id');
            }
            return aId;
        }
        set { 
            if(value != null) aId = value;
        }
    }
    
    public Id caseId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('cId') != null) {
                caseId = ApexPages.currentPage().getparameters().get('cId');
            }
            return caseId;
        }
        set { 
            if(value != null) caseId = value;
        }
    }
/* public Id productId {
   get {
            if(ApexPages.currentPage().getparameters().get('Id') != null) {
                productId = ApexPages.currentPage().getparameters().get('Id');
                }
                return productId;
                }
                set { 
            if(value != null) productId = value;
        }
  }*/
    
    //Added by Shirish 10-june-2011 for Solution feedback
     public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','Yes, I was able to resolve my issue')); 
        options.add(new SelectOption('2','Yes, but instructions were unclear')); 
        options.add(new SelectOption('3','Yes, but it did not solve my issue')); 
        options.add(new SelectOption('4','No, it was not helpful at all'));
        
        return options; 
    }
    
    //Added by Shirish On 11/june/2011 for Solution feedback exist for solution and for login user.
    public Boolean isFBExist {
        
        get {                   
                List<BTBB_ArticleFeedback__c> articleFeedbackList = [Select User_Id__c, Solution__c, Id From BTBB_ArticleFeedback__c  where User_Id__c = :UserInfo.getUserId() and Solution__c = : solution.Id];
                if(null != articleFeedbackList && articleFeedbackList.size() > 0)
                        isFBExist = true;
                else 
                        isFBExist = false;
                return isFBExist;
        }
        set { 
            if(value != null) isFBExist = value;
        }
    }
    public Id ParentarticleId { 
       
        get { 
            if(ApexPages.currentPage().getparameters().get('pId') != null) {
                ParentarticleId = ApexPages.currentPage().getparameters().get('pId');
            }
            return ParentarticleId;
        }
        set { 
        
            if(value != null) ParentarticleId = value;
        }
    }
     
    
     public Pagereference addFeedback(){
        System.debug('voteValue >>>>>>>>>>'+ voteValue);
        BTBB_ArticleFeedback__c articleFeedback = new BTBB_ArticleFeedback__c();
        articleFeedback.Vote_Value__c = voteValue;      
        articleFeedback.User_Id__c = UserInfo.getUserId();
        articleFeedback.Solution__c = solution.Id;
        insert articleFeedback;
        PageReference articleView = new PageReference('/apex/btbb_articleview');
        articleView.getParameters().put('Id', solution.Id);
        articleView.setRedirect(true);
        return articleView;          
     }
     //End of added by Shirish On 11/june/2011.
     
     //Added by Shirish 0n 29 June for attchement display
     
     public List<Case_Attachment__c> getArticleAttach(){
        
        List<Case_Attachment__c> artattlist = new List<Case_Attachment__c>([Select c.File_Name_URL__c, c.Related_To_Article__c, c.Notes__c, c.File_Name__c, c.CreatedDate, c.Bucket_Name__c, c.File_Name_w_ext__c, c.CreatedBy.Name, c.CreatedById From Case_Attachment__c c where Related_To_Article__c =: aId and Internal_Only_Attachment__c =: false  ORDER BY CreatedDate DESC]);
        
        if(null != artattlist && artattlist.size() == 0)
                size = 0;
        else 
                size = artattlist.size();
        System.debug('size >>>>>>>>>' + size);
        return artattlist; 
    }
    /* public List<Attachment> getAttachmentList() {
     
                List<Attachment> attachList = [Select Id, ParentId, Name, OwnerId From Attachment where ParentId = :solution.Id];
                if(attachList.size() > 0)
                        return attachList;    
                return null;
     }*/
     

     
   
   //Added by Shirish on 1st Nov 2011 for Known issue and Resolved Issue list popoulation for Service Pack Article
   
   
   class Article{
        public Id articleId { get; set; }
        public String SolutionNumber { get; set; }
        public String Major { get; set; }
        public String Versions { get; set; }
        public String categoriesName { get; set; }
        public String IssueDescription { get; set; }
        public String TargetFixRelease { get; set; }
        public String PatchAvailable { get; set; }
        public String SolutionName { get; set; }
        public Date ReleaseDate { get; set; }
        public Article(){}
    }
    public List<Article> articleList;
    
    public List<Article> getKIArticleList()
    {
          articleList = new List<Article>();
          Article article = new Article();
          String[] majorReleaseArray;
          String[] versionArray;
          list<String> notFixedReasons = new list<String>{'Will Not Fix','Duplicate','Functioning As Designed'};
          if(null != recordName && (recordName.equals('Maintenance Release') || recordName.equals('Release'))) {
              results = new List<Solution>();
              results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c 
                         from Solution 
                         where RecordType.Name = 'Known Issue' and status='Published' and Visible_in_Customer_Portal__c = true 
                         and Not_Fixed_Reason__c NOT IN : notFixedReasons
                         order by Number_of_Clients_Reporting__c desc];
              
              //  results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and  major_Release__c = :solution.Major_Release__c and Version_s__c = : solution.Version_s__c and status='Published' and Visible_in_Customer_Portal__c = true ORDER BY SolutionName ASC, LastModifiedDate DESC];
              
              //System.debug('results>>>>>>>>>>>>> '+ results.size());  
            /*  if((null != results && results.size() > 0) || runFromTest == true) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                if(solution.Version_s__c != null) 
                    versionArray = solution.Version_s__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
                System.debug('versionArray >>>>>>>>>>>>' +versionArray);
                //tempSolList = results;
                //results = new List<Solution>();
                if(recordName.equals('Release')){
                
                    for(Solution sol : results) {
                        
                        for(String major : majorReleaseArray) {
                            
                            if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                tempSolMap.put(sol.Id,sol);
                                break;
                                //results.add(sol);
                            }
                        }
                    }
                } else {
                    
                    for(Solution sol : results) {
                        
                        for(String major : majorReleaseArray) {
                            
                            if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                
                                for(String version : versionArray) {
                                    
                                    if(null != sol.Version_s__c && sol.Version_s__c.contains(version)) {
                                        tempSolMap.put(sol.Id,sol);
                                        break;      //if one version match then break the loop
                                    }
                                }
                                //if one major release match then break the loop
                                break;
                                //results.add(sol);
                            }
                        }                       
                    }
                }
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
          } */
              
              if((null != results && results.size() > 0) || runFromTest == true) {
                
                Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                    //will add value in to map
                    mapOfCatNodeWithId.put(catNode.Id, catNode);
                  
                }
                //IsResult = true;    //Result Found
                //Map variable store the list of CategoryData on the basis of solution Id
                Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
                //Set variable store the solution ids
                Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
                List<CategoryData> catDataList = new List<CategoryData>();
                CategoryNode catNode;
                String categoryName = '';
                Set<Id> cateTopNodeIdSet = new Set<Id>(); 
                Set<Id> cateNodeIdSet = new Set<Id>();
                Set<Id> tempCateNodeIdSet = new Set<Id>(); 
                //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
                 
                
                articleList = new List<Article>(); 
                Solution solObj;
                
                for(Solution sol : results) {
                        
                        //solIdSet.add(sol.id);
                        mapOfSolutionWithId.put(sol.id, sol);
                }
                //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
                for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                        //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                        if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                                //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                                catDataList = new List<CategoryData>();  
                                catDataList.add(catData);                       
                                mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                        } else {
                                //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                                mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                        }                       
                }
                //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
                for(Id id : mapOfDataCatWithSol.keySet()) {
                        //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                        article = new Article();
                        cateTopNodeIdSet = new set<id>();
                        cateNodeIdSet = new set<id>();            
                        catDataList = new List<CategoryData>();
                        //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                        //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                        for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                                catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                              
                                if(catNode.ParentId != null) {
                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                       
                                        cateNodeIdSet.add(catNode.Id); 
                                } else {
                                        cateTopNodeIdSet.add(catNode.Id);
                                }
                        }                   
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                        //Will check category till 4 level to find out the top level category
                        if(cateNodeIdSet.size() > 0) {
                                                                
                                for(Integer i = 0; i < 4; i++) {
                                        tempCateNodeIdSet = cateNodeIdSet;
                                        //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                        //catDataList = new List<CategoryData>();
                                        cateNodeIdSet = new Set<Id>();
                                        for(Id tId : tempCateNodeIdSet) {                                            
                                                catNode = mapOfCatNodeWithId.get(tId);                                           
                                                if(catNode.ParentId != null) {
                                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                        cateNodeIdSet.add(catNode.Id);                                                     
                                                } else {
                                                        cateTopNodeIdSet.add(catNode.Id);
                                                }
                                        }
                                        if(cateNodeIdSet.size() == 0)
                                                break;
                                }
                        }
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        if(cateTopNodeIdSet.size() > 0) {
                                //article.categoriesName = '';
                                for(Id catId : cateTopNodeIdSet) {
                                    catNode = mapOfCatNodeWithId.get(catId);
                                    if(article.categoriesName == null) {
                                            article.categoriesName = catNode.MasterLabel;
                                    } else {
                                            article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                    }
                                }
                        }
                        solObj = mapOfSolutionWithId.get(id);       
                         string product = (solution.Product__c == 'Blackboard Learn'?'Learn':solution.Product__c);
                    if(article.categoriesName.contains(product)  )
                    {                         
                        article.articleId = solObj.id;
                        article.SolutionNumber=solObj.SolutionNumber;
                        article.Major=solObj.Major_Release__c; 
                        article.Versions=solObj.Version_s__c;
                        article.IssueDescription=solObj.Issue_Description__c;
                        article.PatchAvailable=solObj.Patch_Available__c;
                        article.TargetFixRelease=solObj.Target_Release_New__c;         
                        articleList.add(article);
                        }
                        if(articleList.size() == 10)
                            break;
                } 
           } else {
                articleList = new List<Article>();
                //isResult = false;   //Result Not Found
           }
        }            
       //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
      
        if(null != articleList && articleList.size() == 0)
                KISize = 0;
        else 
                KISize = articleList.size();
        
        System.debug('KISize >>>>>>>>>>>>' + KISize);
        return articleList;
   }
   public List<Article> getKIResolvedArticleList() {
    
        System.debug('<<<<<<<<< getKIResolvedArticleList >>>>>>>>');
        Set<String> targetReleaseSet = new Set<String>();
        Map<String, String> ServicePackTarReleaseMap = new Map<String, String>();
        List<Solution> solList = new List<Solution>(); 
        articleList = new List<Article>();
        String[] versionArray;
        if(null != recordName && recordName.equals('Maintenance Release')) {
          
            String versionTemp;
            if(solution.Version_s__c != null)
                versionArray = solution.Version_s__c.split(';',-1);
            String targetRelease;
            
            list<String> notFixedReasons = new list<String>{'Will Not Fix','Duplicate','Functioning As Designed'};
            for(Solution solObj: [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c 
                                  from Solution 
                                  where RecordType.Name = 'Known Issue' and status='Published' and Target_Release_New__c != null
                                  and Not_Fixed_Reason__c NOT IN : notFixedReasons]) {
                solList.add(solObj);                
                targetReleaseSet.add(solObj.Target_Release_New__c);
            }
            for(TargetReleaseMap__c tarRel : [Select Service_Pack__c, Name From TargetReleaseMap__c where Name IN : targetReleaseSet]) { 
                ServicePackTarReleaseMap.put(tarRel.Name, tarRel.Service_Pack__c);
            }  
            System.debug('ServicePackTarReleaseMap >>>>>>>>' + ServicePackTarReleaseMap);
            for(Solution solObj: solList) {
                    if(null != versionArray) {
                        for(String version : versionArray) {
                                
                            versionTemp = ServicePackTarReleaseMap.get(solObj.Target_Release_New__c);
                            if(version.equals(versionTemp)) {              
                                resultsKI.add(solObj);
                                break;
                            }
                        }
                    }
                
            }                
            /*for(Solution solObj: [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c from Solution where RecordType.Name = 'Known Issue' and status='Published']) {
                if(versionArray != null) {
                    for(String version : versionArray) {
                        if(solObj.Target_Release_New__c != null) {
                            versionTemp = version.replaceAll(' ', '');
                            targetRelease = solObj.Target_Release_New__c.replaceAll(' ', '');
                            
                            if(targetRelease.contains(versionTemp) || targetRelease.equals(versionTemp)) {              
                                resultsKI.add(solObj);
                                break;
                            }
                        }
                    }
                }
            }*/
            
            if((null != resultsKI && resultsKI.size() > 0) || runFromTest == true) {
                
                Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                      //will add value in to map
                        mapOfCatNodeWithId.put(catNode.Id, catNode);
                  
                }
                //IsResult = true;    //Result Found
                //Map variable store the list of CategoryData on the basis of solution Id
                Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
                //Set variable store the solution ids
                Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
                List<CategoryData> catDataList;
                CategoryNode catNode;
                String categoryName = '';
                Set<Id> cateTopNodeIdSet = new Set<Id>(); 
                Set<Id> cateNodeIdSet = new Set<Id>();
                Set<Id> tempCateNodeIdSet = new Set<Id>(); 
                //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
                catDataList = new List<CategoryData>();
                Article article;
                articleList = new List<Article>(); 
                Solution solObj;
                
                for(Solution sol : resultsKI) {
                        
                        //solIdSet.add(sol.id);
                        mapOfSolutionWithId.put(sol.id, sol);
                }  
                for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                        
                        if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {                           
                                catDataList = new List<CategoryData>();  
                                catDataList.add(catData);                       
                                mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                        } else {
                                
                                mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                        }                       
                }
                //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
                for(Id id : mapOfDataCatWithSol.keySet()) {
                        //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                        article = new Article();                       
                        catDataList = new List<CategoryData>();                   
                        for(CategoryData catData : mapOfDataCatWithSol.get(id)) {
                                
                                catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);                           
                                if(catNode.ParentId != null) {
                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                        cateNodeIdSet.add(catNode.Id); 
                                } else {
                                        cateTopNodeIdSet.add(catNode.Id);
                                }
                        }
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                        //Will check category till 4 level to find out the top level category
                        if(cateNodeIdSet.size() > 0) {
                                                                
                                for(Integer i = 0; i < 4; i++) {
                                        tempCateNodeIdSet = cateNodeIdSet;
                                        cateNodeIdSet = new Set<Id>();
                                        catDataList = new List<CategoryData>();
                                        for(Id tId : tempCateNodeIdSet) {
                                                
                                                catNode = mapOfCatNodeWithId.get(tId);
                                                if(catNode.ParentId != null) {
                                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                                        cateNodeIdSet.add(catNode.Id); 
                                                } else {
                                                        cateTopNodeIdSet.add(catNode.Id);
                                                }
                                        }
                                        if(cateNodeIdSet.size() == 0)
                                                break;
                                }
                        }
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        if(cateTopNodeIdSet.size() > 0) {
                                //article.categoriesName = '';
                                for(Id catId : cateTopNodeIdSet) {
                                    catNode = mapOfCatNodeWithId.get(catId);
                                    if(article.categoriesName == null) {
                                            article.categoriesName = catNode.MasterLabel;
                                    } else {
                                            article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                    }
                                }
                        }
                        solObj = mapOfSolutionWithId.get(id);    
                    
                                    
                        article.articleId = solObj.id;
                        article.SolutionNumber=solObj.SolutionNumber;
                        article.Major=solObj.Major_Release__c; 
                        article.Versions=solObj.Version_s__c;
                        
                        article.IssueDescription=solObj.Issue_Description__c;
                        article.TargetFixRelease=solObj.Target_Release_New__c;         
                        articleList.add(article);
                       
                      //  if(articleList.size() == 5)
                        //    break;  
                    } 
               } else {
                    articleList = new List<Article>();
                    //isResult = false;   //Result Not Found
               }  
        }
        //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
        if(null != articleList && articleList.size() == 0)
            ResolvedKISize = 0;
        else 
            ResolvedKISize = articleList.size();
        
        System.debug('ResolvedKISize >>>>>>>>>>>>' + ResolvedKISize);
        return articleList;
    }  
    
    public List<Article> getReleasePageArticleList()
    {
      articleList = new List<Article>();
      Article article = new Article();
      String[] majorReleaseArray;

      if(recordName.equals('Release')) {

          results = new List<Solution>();          
          results = [select id,SolutionNumber, Product__c, Major_Release__c,SolutionName,Release_Date__c,Version_s__c, Last_Updated__c from Solution where RecordType.Name = 'Maintenance Release' and status='Published' and Major_Release__c != null LIMIT 1000];
         
          //results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and  major_Release__c = :solution.Major_Release__c and Version_s__c = : solution.Version_s__c and status='Published'];
          
          System.debug('results>>>>>>>>>>>>> '+ results.size());
          
          if((null != results && results.size() > 0) || runFromTest == true) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
              
                for(Solution sol : results) {
                    
                    for(String major : majorReleaseArray) {
                        
                        if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major) && solution.Product__c == sol.Product__c) {
                            tempSolMap.put(sol.Id,sol);
                            break;
                            //results.add(sol);
                        }
                    }
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
                }
            
            }
            
            if((null != results && results.size() > 0) || runFromTest == true) {              
            
                Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                    //will add value in to map
                    mapOfCatNodeWithId.put(catNode.Id, catNode);
                  
                }
                //IsResult = true;    //Result Found
                //Map variable store the list of CategoryData on the basis of solution Id
                Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
                //Set variable store the solution ids
                Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
                List<CategoryData> catDataList = new List<CategoryData>();
                CategoryNode catNode;
                String categoryName = '';
                Set<Id> cateTopNodeIdSet = new Set<Id>(); 
                Set<Id> cateNodeIdSet = new Set<Id>();
                Set<Id> tempCateNodeIdSet = new Set<Id>(); 
                //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
             
            
                articleList = new List<Article>(); 
                Solution solObj;
            
                for(Solution sol : results) {
                        
                        //solIdSet.add(sol.id);
                        mapOfSolutionWithId.put(sol.id, sol);
                }
                //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
                for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                    //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                    if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                            catDataList = new List<CategoryData>();  
                            catDataList.add(catData);                       
                            mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                    } else {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                            mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                    }                       
                }
                //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
                for(Id id : mapOfDataCatWithSol.keySet()) {
                    //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
                    catDataList = new List<CategoryData>();
                    //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                    //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                    for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                            catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                          
                            if(catNode.ParentId != null) {
                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                   
                                    cateNodeIdSet.add(catNode.Id); 
                            } else {
                                    cateTopNodeIdSet.add(catNode.Id);
                            }
                    }                   
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                        for(Integer i = 0; i < 4; i++) {
                                tempCateNodeIdSet = cateNodeIdSet;
                                //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                //catDataList = new List<CategoryData>();
                                cateNodeIdSet = new Set<Id>();
                                for(Id tId : tempCateNodeIdSet) {                                            
                                        catNode = mapOfCatNodeWithId.get(tId);                                           
                                        if(catNode.ParentId != null) {
                                                catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                cateNodeIdSet.add(catNode.Id);                                                     
                                        } else {
                                                cateTopNodeIdSet.add(catNode.Id);
                                        }
                                }
                                if(cateNodeIdSet.size() == 0)
                                        break;
                        }
                    }
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    if(cateTopNodeIdSet.size() > 0) {
                        //article.categoriesName = '';
                        for(Id catId : cateTopNodeIdSet) {
                            catNode = mapOfCatNodeWithId.get(catId);
                            if(article.categoriesName == null) {
                                    article.categoriesName = catNode.MasterLabel;
                            } else {
                                    article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                            }
                        }
                    }
                    solObj = mapOfSolutionWithId.get(id);                                
                    article.articleId = solObj.id;
                    article.SolutionNumber=solObj.SolutionNumber;
                    article.Major=solObj.Major_Release__c; 
                    article.Versions=solObj.Version_s__c;
                    article.SolutionName=solObj.SolutionName;
                    article.ReleaseDate=solObj.Release_Date__c;
                    //article.IssueDescription=solObj.Issue_Description__c;
                    //article.PatchAvailable=solObj.Patch_Available__c;
                    //article.TargetFixRelease=solObj.Target_Release_New__c;         
                    articleList.add(article); 
                 //   if(articleList.size() == 5)
                  //      break;    
                }       
            } else {
                
                articleList =  new List<Article>(); 
            }  
        }   
        if(null != articleList && articleList.size() == 0)
                RPSize = 0;
        else 
                RPSize = articleList.size();  
                articleList = ArticleSort(articleList); 
        return articleList;
    }
    
    public List<Article> getSupportTechArticleList()
    {
      articleList = new List<Article>();
      Article article = new Article();
      String[] majorReleaseArray;
      String[] versionArray;
      if(recordName.equals('Maintenance Release')) {
      //if(recordName.equals('Version Information') || recordName.equals('Product Release Information')) {
          results = new List<Solution>();          
          results = [select id,SolutionNumber,Major_Release__c,Version_s__c, Last_Updated__c from Solution where RecordType.Name = 'Supported Technologies Information' and status='Published'];
         
          //results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and  major_Release__c = :solution.Major_Release__c and Version_s__c = : solution.Version_s__c and status='Published'];
          
          System.debug('results>>>>>>>>>>>>> '+ results.size());
          
          if((null != results && results.size() > 0) || runFromTest == true) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                if(solution.Version_s__c != null) 
                    versionArray = solution.Version_s__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
                System.debug('versionArray >>>>>>>>>>>>' +versionArray);
                //tempSolList = results;
                //results = new List<Solution>();       
                    
                    for(Solution sol : results) {
                        if(null != majorReleaseArray) {
                            for(String major : majorReleaseArray) {
                                
                                if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                    if(null != versionArray) {
                                        for(String version : versionArray) {
                                            
                                            if(null != sol.Version_s__c && sol.Version_s__c.contains(version)) {
                                                tempSolMap.put(sol.Id,sol);
                                                break;      //if one version match then break the loop
                                            }
                                        }
                                    }
                                    //if one major release match then break the loop
                                    break;
                                    //results.add(sol);
                                }
                            } 
                        }                      
                    }
                
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
          }
          if((null != results && results.size() > 0) || runFromTest == true) {              
            
            Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         

            for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                            ORDER BY MasterLabel DESC]) {            
                //will add value in to map
                mapOfCatNodeWithId.put(catNode.Id, catNode);
              
            }
            //IsResult = true;    //Result Found
            //Map variable store the list of CategoryData on the basis of solution Id
            Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
            //Set variable store the solution ids
            Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
            List<CategoryData> catDataList = new List<CategoryData>();
            CategoryNode catNode;
            String categoryName = '';
            Set<Id> cateTopNodeIdSet = new Set<Id>(); 
            Set<Id> cateNodeIdSet = new Set<Id>();
            Set<Id> tempCateNodeIdSet = new Set<Id>(); 
            //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
             
            
            articleList = new List<Article>(); 
            Solution solObj;
            
            for(Solution sol : results) {
                    
                    //solIdSet.add(sol.id);
                    mapOfSolutionWithId.put(sol.id, sol);
            }
            //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
            for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                    //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                    if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                            catDataList = new List<CategoryData>();  
                            catDataList.add(catData);                       
                            mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                    } else {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                            mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                    }                       
            }
            //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
            for(Id id : mapOfDataCatWithSol.keySet()) {
                    //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
                    catDataList = new List<CategoryData>();
                    //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                    //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                    for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                            catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                          
                            if(catNode.ParentId != null) {
                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                   
                                    cateNodeIdSet.add(catNode.Id); 
                            } else {
                                    cateTopNodeIdSet.add(catNode.Id);
                            }
                    }                   
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                            for(Integer i = 0; i < 4; i++) {
                                    tempCateNodeIdSet = cateNodeIdSet;
                                    //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                    //catDataList = new List<CategoryData>();
                                    cateNodeIdSet = new Set<Id>();
                                    for(Id tId : tempCateNodeIdSet) {                                            
                                            catNode = mapOfCatNodeWithId.get(tId);                                           
                                            if(catNode.ParentId != null) {
                                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                    cateNodeIdSet.add(catNode.Id);                                                     
                                            } else {
                                                    cateTopNodeIdSet.add(catNode.Id);
                                            }
                                    }
                                    if(cateNodeIdSet.size() == 0)
                                            break;
                            }
                    }
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    if(cateTopNodeIdSet.size() > 0) {
                            //article.categoriesName = '';
                            for(Id catId : cateTopNodeIdSet) {
                                catNode = mapOfCatNodeWithId.get(catId);
                                if(article.categoriesName == null) {
                                        article.categoriesName = catNode.MasterLabel;
                                } else {
                                        article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                }
                            }
                    }
                    solObj = mapOfSolutionWithId.get(id);                                
                    article.articleId = solObj.id;
                    article.SolutionNumber=solObj.SolutionNumber;
                    article.Major=solObj.Major_Release__c; 
                    article.Versions=solObj.Version_s__c;
                    //article.IssueDescription=solObj.Issue_Description__c;
                    //article.PatchAvailable=solObj.Patch_Available__c;
                    //article.TargetFixRelease=solObj.Target_Release_New__c;         
                    articleList.add(article);  
                    if(articleList.size() == 5)
                        break;
            } 
       } else {
            articleList = new List<Article>();
            //isResult = false;   //Result Not Found
       }
    }            
      //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
      if(null != articleList && articleList.size() == 0)
                STSize = 0;
        else 
                STSize = articleList.size();
      return articleList;
    }
    
    
    public PageReference redirect() { 
    try{
   solution soldel = [Select id from Solution where id =: (ApexPages.currentPage().getparameters().get('id'))];
  
   }
   catch(QueryException e){
    PageReference ArticleDeletedPage = new PageReference('/apex/btbb_ArticleDeleted');
    ArticleDeletedPage.setRedirect(true);
    return ArticleDeletedPage;
   }  
    if(gc.userRedirect == true || runFromTest == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
        return null;
        }
        }
   /*Method will match with article record type then 
    ** redirect detail page on the basis of record type 
    */
    public PageReference redirectToPage() { 
    try{
   solution soldel = [Select id from Solution where id =: (ApexPages.currentPage().getparameters().get('id'))];
  
   }
   catch(QueryException e){
    PageReference ArticleDeletedPage = new PageReference('/apex/btbb_ArticleDeleted');
    ArticleDeletedPage.setRedirect(true);
    return ArticleDeletedPage;
   }     
    if(gc.userRedirect == true || runFromTest == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
    
    
        string recordName = getRecordType();
        PageReference detailPage = new PageReference('/apex/btbb_home');        
        if(solution.Id != null) {
            
            if(recordName.equals('Announcement')) {
        
                detailPage = new PageReference('/apex/btbb_AnnouncementArticleView');
                          
            } else if(recordName.equals('Known Issue')) {
                
                detailPage = new PageReference('/apex/btbb_KnownIssueArticleView');
                
            } else if(recordName.equals('Other Resource')) {
            
                detailPage = new PageReference('/apex/btbb_OtherResourcesArticleView');
                
            } else if(recordName.equals('Product Documentation')) {
                
                detailPage = new PageReference('/apex/btbb_ProductDocArticleView');
               
            } else if(recordName.equals('Question/Answer')) {
            
                detailPage = new PageReference('/apex/btbb_QAArticleView');
               
            } else if(recordName.equals('Release')) {
                
                detailPage = new PageReference('/apex/btbb_ReleaseArticleView');
               
            } else if(recordName.equals('Maintenance Release')) {
            
                detailPage = new PageReference('/apex/btbb_ServicePackArticleView');
                
            } else if(recordName.equals('General Article')) {
            
                detailPage = new PageReference('/apex/btbb_GeneralArticleView');
               
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
                detailPage = new PageReference('/apex/btbb_SBSAArticleView');
               
            } else if(recordName.equals('Supported Technologies Information')) {
            
                detailPage = new PageReference('/apex/btbb_SupportedTechArticleView');
                
            } else if(recordName.equals('Troubleshooting/Informational')) {
            
                detailPage = new PageReference('/apex/btbb_TSGArticleView');
                
            } else if(recordName.equals('Blackboard Client Program')) {
            
                detailPage = new PageReference('/apex/btbb_BCProgramArticleView');
                
            }
            detailPage.getParameters().put('Id', solution.Id);
            detailPage.getParameters().put('RecordType', rId);
            if(caseId != null)
                detailPage.getParameters().put('cid', caseId);
            detailPage.setRedirect(true);
            return detailPage;       
        }        
        return null;
      }         
    }
    public PageReference redirectToPublicPage() { 
    
        string recordName = getRecordType();
        PageReference detailPage = new PageReference('/apex/btbb_home');        
        if(solution.Id != null) {
            
            if(recordName.equals('Announcement')) {
        
                detailPage = new PageReference('/apex/btbb_AnnouncementPublicArticleView');
                          
            } else if(recordName.equals('Known Issue')) {
                
                detailPage = new PageReference('/apex/btbb_KnownIssuePublicArticleView');
                
            } else if(recordName.equals('Other Resource')) {
            
                detailPage = new PageReference('/apex/btbb_OtherResourcesPublicArticleView');
                
            } else if(recordName.equals('Product Documentation')) {
                
                detailPage = new PageReference('/apex/btbb_ProductDocPublicArticleView');
               
            } else if(recordName.equals('Question/Answer')) {
            
                detailPage = new PageReference('/apex/btbb_QAPublicArticleView');
               
            } else if(recordName.equals('Release')) {
                
                detailPage = new PageReference('/apex/btbb_ReleasePublicArticleView');
               
            } else if(recordName.equals('Maintenance Release')) {
            
                detailPage = new PageReference('/apex/btbb_ServicePackPublicArticleView');
                
            } else if(recordName.equals('General Article')) {
            
                detailPage = new PageReference('/apex/btbb_GeneralPublicArticleView');
               
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
                detailPage = new PageReference('/apex/btbb_SBSAPublicArticleView');
               
            } else if(recordName.equals('Supported Technologies Information')) {
            
                detailPage = new PageReference('/apex/btbb_SupportedTechPublicArticleView');
                
            } else if(recordName.equals('Troubleshooting/Informational')) {
            
                detailPage = new PageReference('/apex/btbb_TSGPublicArticleView');
                
            } else if(recordName.equals('Blackboard Client Program')) {
            
                detailPage = new PageReference('/apex/btbb_BCProgramPublicArticleView');
                
            }
            detailPage.getParameters().put('Id', solution.Id);
            detailPage.getParameters().put('RecordType', rId);
            if(caseId != null)
                detailPage.getParameters().put('cid', caseId);
            detailPage.setRedirect(true);
            return detailPage;       
        }        
        return null;
                
    }
       //Method Written on 29th Feb by Abhinav for sorting articles list by date
    public List<Article> ArticleSort(List<Article> alist){      
      
       Article temp = new Article();
            
        for(Integer i=0;i<alist.size();i++){
        
            for(Integer j=1;j<alist.size()-i;j++)
            {               
             
                if(alist[j-1].ReleaseDate < alist[j].ReleaseDate || alist[j-1].ReleaseDate == null){
                    temp = alist[j-1];
                    alist[j-1] = alist[j] ;
                    alist[j] = temp;
                }
             }
        }
        return alist;
    } 
}