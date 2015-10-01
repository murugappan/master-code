public class CaseConfirmationController {
    
   public String searchText;
   //Id caseId;
   public Id articleId;
   public String caseNumber;
   public List<Solution> results;
   public Set<Id> solIdSet = new Set<Id>();
   
   public String getCaseNumber() {
        return caseNumber;
    }

    public void setCaseNumber(String caseNumber) {
        this.caseNumber = caseNumber;
    }
   
    public Id getArticleId() {
        return articleId;
    }

    public void setArticleId(Id aId) {
        articleId = aId;
    }
   

   public String getSearchText() {
      return searchText;
   }

   public void setSearchText(String s) {
      searchText = s;
   }

   public List<Solution> getResults() {
      return results;
   }
   
   List<RelevantArticle> RelevantArticles;
   /*public List<RelevantArticle> getRelevantArticles() {
      return RelevantArticles;
   }*/
   
   //Modified for Test Class
   
   public List<RelevantArticle> getRelevantArticles() {
      
      	RelevantArticles = new List<RelevantArticle>();
        //Set<Id> solIdSet = new Set<Id>();
        RelevantArticle relArticle;
        System.debug('<<<<<< In CaseConfirmationController>>>>>>>' + caseId);
        if(caseId != null) {
            
            Case caseObj = [SELECT Id, Subject, CaseNumber FROM Case WHERE Id = : caseId]; 
            searchText = caseObj.Subject;
            caseNumber = caseObj.CaseNumber;
        }
        System.debug('searchText >>>>>>>' + searchText);
        if(searchText != null)
        {
            results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate where status='Published' and Visible_in_Customer_Portal__c = true)][0];
            for(Solution sol : results) {
                
                solIdSet.add(sol.Id);
            }
        }
        Integer flag = 0;        
        for(Solution solution: [Select Id, Status, SolutionNumber,  (Select SolutionId, CaseId, Id From CaseSolutions where Id != null), SolutionName, Owner.FirstName, Owner.LastName, LastModifiedDate From Solution where Id IN : solIdSet]) {
        	flag = 0;
            relArticle = new RelevantArticle ();
            relArticle.articleId = solution.Id;
            relArticle.Status = solution.Status;
            relArticle.Author = solution.Owner.FirstName +' ' + solution.Owner.LastName;
            relArticle.LastModifiedDate = solution.LastModifiedDate;
            relArticle.ArticleName = solution.SolutionName;
            relArticle.ArticleNumber = solution.solutionNumber;
            List<CaseSolution> caseSolutionList = solution.CaseSolutions;           
            
            for(CaseSolution caseSol : caseSolutionList) {
            	
            	if(caseSol.CaseId == caseId && caseSol.SolutionId == solution.Id) {
            		flag = 1;
            		break;            
            	}
            }
            if(flag == 1)
            	continue;
            	
            if(null != caseSolutionList) {
                
                relArticle.caseCount = caseSolutionList.size();
            } else {
                relArticle.caseCount = 0;
            }
            RelevantArticles.add(relArticle);                       
        }
      	return RelevantArticles;
   }
   
   //End of modified for Test Class
  
   public PageReference selectArticle() {
        System.debug('<<<<<<< In selectArticle Method >>>>>>>>');               
        CaseSolution caseSol = new CaseSolution(CaseId=caseId,SolutionId=articleId);
        insert caseSol;
        PageReference casePage = new PageReference('/apex/btbb_caseview');
        casePage.getParameters().put('Id', caseId);        
        casePage.setRedirect(true);
        return casePage;        
   }
   public CaseConfirmationController() {
        /*RelevantArticles = new List<RelevantArticle>();
        //Set<Id> solIdSet = new Set<Id>();
        RelevantArticle relArticle;
        System.debug('<<<<<< In CaseConfirmationController>>>>>>>' + caseId);
        if(caseId != null) {
            
            Case caseObj = [SELECT Id, Subject, CaseNumber FROM Case WHERE Id = : caseId]; 
            searchText = caseObj.Subject;
            caseNumber = caseObj.CaseNumber;
        }
        System.debug('searchText >>>>>>>' + searchText);
        if(searchText != null)
        {
            results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate where status='Published' and Visible_in_Customer_Portal__c = true)][0];
            for(Solution sol : results) {
                
                solIdSet.add(sol.Id);
            }
        }
        Integer flag = 0;        
        for(Solution solution: [Select Id, Status, SolutionNumber,  (Select SolutionId, CaseId, Id From CaseSolutions where Id != null), SolutionName, Owner.FirstName, Owner.LastName, LastModifiedDate From Solution where Id IN : solIdSet]) {
        	flag = 0;
            relArticle = new RelevantArticle ();
            relArticle.articleId = solution.Id;
            relArticle.Status = solution.Status;
            relArticle.Author = solution.Owner.FirstName +' ' + solution.Owner.LastName;
            relArticle.LastModifiedDate = solution.LastModifiedDate;
            relArticle.ArticleName = solution.SolutionName;
            relArticle.ArticleNumber = solution.solutionNumber;
            List<CaseSolution> caseSolutionList = solution.CaseSolutions;           
            
            for(CaseSolution caseSol : caseSolutionList) {
            	
            	if(caseSol.CaseId == caseId && caseSol.SolutionId == solution.Id) {
            		flag = 1;
            		break;            
            	}
            }
            if(flag == 1)
            	continue;
            	
            if(null != caseSolutionList) {
                
                relArticle.caseCount = caseSolutionList.size();
            } else {
                relArticle.caseCount = 0;
            }
            RelevantArticles.add(relArticle);                       
        }*/
        
   }

   public Id caseId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('id') != null) {
                caseId = ApexPages.currentPage().getparameters().get('id');
            } 
            return caseId;
        }
        set { 
            if(value != null) caseId = value;
        }
    }
   
   class RelevantArticle {
        
        public Id articleId { get; set; }
        public String Status { get; set; }
        public String ArticleNumber { get; set; } 
        public String Author { get; set; }
        public String ArticleName { get; set; }
        public DateTime LastModifiedDate { get; set; }
        public Integer CaseCount { get; set; }        
        public RelevantArticle(){}
    }
}