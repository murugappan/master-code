public class ArticleListController {
    
    public String recordName { get; set; }
    public String solutionNo { get; set; }
    public  List<Solution> results;
    public Boolean flag {get; set;}
    Solution solution;    
    public ArticleListController() {
            
            solution = [SELECT SolutionNumber,SolutionName,RecordTypeId, Product__c, Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c FROM Solution WHERE Id = :aId];
            solutionNo = solution.SolutionNumber;            
            if(null != solution && solution.RecordTypeId != null) {
                recordName = [Select Name From RecordType where Id = :solution.RecordTypeId].Name;                  
            }
            System.debug('<<<<<<< In  ArticleListController >>>>>>>>');
            pageNumber = 0;
            totalPageNumber = 0;
            pageSize = 15;
            BindData(1);    
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
    
    public String recType { 
        get { 
            if(ApexPages.currentPage().getparameters().get('recType') != null) {
                recType = ApexPages.currentPage().getparameters().get('recType');
            }
            return recType;
        }
        set { 
            if(value != null) recType = value;
        }
    }
    
    public String articleListType{ 
        get { 
            if(null != recType && recType.equals('KI')) {
                flag = true;
                articleListType = 'Known Issue';
            } else if(null != recType && recType.equals('RKI')) {
                flag = true;
                articleListType = 'Resolved Known Issue';
            } else if(null != recType && recType.equals('RP')) {
                flag = false;
                articleListType = 'Maintenance Release(s)';
            } else if(null != recType && recType.equals('ST')) {
                flag = true;
                articleListType = 'Supported Technology';            
            }
            return articleListType;
        }
        set { 
            if(value != null) articleListType = value;
        }
    }
    //List<Article> articleList;
    public List<Article> ArticleList {
    get {
        articleList = new List<Article>();
        Article article = new Article();
        String[] majorReleaseArray;
        String[] versionArray;
      
        results = new List<Solution>();
        if(recType.equals('RKI'))                    
            results = [select id,SolutionNumber,Product__c, Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,SolutionName,Release_Date__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and status='Published' and Target_Release_New__c != null Order By SolutionNumber limit 100];
        else if(recType.equals('KI'))
            results = [select id,SolutionNumber,Product__c, Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,SolutionName,Release_Date__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and status='Published' Order By Number_of_Clients_Reporting__c DESC  ];
        else if(recType.equals('ST'))
            results = [select id,SolutionNumber,Major_Release__c, Product__c, Version_s__c, Issue_Description__c,SolutionName ,Target_Release_New__c,Release_Date__c,Patch_Available__c from Solution where RecordType.Name = 'Supported Technologies Information' and status='Published' Order By SolutionNumber limit 100];
        else if(recType.equals('RP'))
            results = [select id,SolutionNumber,Product__c, Major_Release__c,Version_s__c, Issue_Description__c,Target_Release_New__c,Patch_Available__c,SolutionName,Release_Date__c from Solution where RecordType.Name = 'Maintenance Release' and status='Published'and Major_Release__c != null Order By Release_Date__c limit 100];           
    if(recType != 'KI'){
        if(null != results && results.size() > 0) {
            Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
            
            if(solution.Major_Release__c != null) 
                majorReleaseArray = solution.Major_Release__c.split(';',-1);
            if(solution.Version_s__c != null) 
                versionArray = solution.Version_s__c.split(';',-1);

            if(recordName.equals('Release')) {
            
                for(Solution sol : results) {
                    
                    for(String major : majorReleaseArray) {
                        
                        if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major) && solution.Product__c == sol.Product__c) {
                            tempSolMap.put(sol.Id,sol);
                            break;                            
                        }
                    }
                }
            } else {
                if(RecType.equals('RKI')) {
                
                    if(solution.Version_s__c != null) 
                        versionArray = solution.Version_s__c.split(';',-1);
                    String versionTemp;
                    String targetRelease;
                    for(Solution sol : results) {                
                        for(String version : versionArray) {
                            versionTemp = version.replaceAll(' ', '');
                            targetRelease = sol.Target_Release_New__c.replaceAll(' ', '');
                            if(targetRelease.contains(versionTemp) || targetRelease.equals(versionTemp)) {              
                                tempSolMap.put(sol.Id,sol);
                                break;
                            }
                           
                        }
               
                    }
                } else {
                      
                    for(Solution sol : results) {
                        
                        for(String major : majorReleaseArray) {
                            
                            if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major) && null != versionArray) {
                                
                                for(String version : versionArray) {
                                    
                                    if(null != sol.Version_s__c && sol.Version_s__c.contains(version)) {
                                        tempSolMap.put(sol.Id,sol);
                                        break;      //if one version match then break the loop
                                    }
                                }
                                //if one major release match then break the loop
                                break;                                
                            }
                        }                       
                    }
                }
               
            }
            if(tempSolMap.size() > 0)
                results = tempSolMap.values();
            else
                results = new List<Solution>();
                }
        }
          if(null != results && results.size() > 0) {              
                
            Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
            for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                            ORDER BY MasterLabel DESC]) {            
                //will add value in to map
                mapOfCatNodeWithId.put(catNode.Id, catNode);
              
            }
            
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
            for(Id id : mapOfDataCatWithSol.keySet()) {
                    
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
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
                    
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                            for(Integer i = 0; i < 4; i++) {
                                    tempCateNodeIdSet = cateNodeIdSet;
                                    
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
                   
                    if(cateTopNodeIdSet.size() > 0) {
                            
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
                    article.IssueDescription=solObj.Issue_Description__c;
                    article.PatchAvailable=solObj.Patch_Available__c;
                    article.TargetFixRelease=solObj.Target_Release_New__c;         
                    articleList.add(article);  
                    if(articleList.size() == 100)
                        break;
            } 
       } else {
        ArticleList = new List<Article>();       
        }
        if(rectype !='KI')
        {
      ArticleList = ArticleSort(articleList);
        return ArticleList;
        }
        else{
        return Articlelist;
        }
        }
       set {                   
                if(value != null) ArticleList = value;               
        }
    }   
    class Article{
        public Id articleId { get; set; }
        public String SolutionNumber { get; set; }
        public String Major { get; set; }
        public String Versions { get; set; }
        public String categoriesName { get; set; }
        public String IssueDescription { get; set; }
        public Date ReleaseDate { get; set; }
        public String SolutionName { get; set; }
        public String TargetFixRelease { get; set; }
        public String PatchAvailable { get; set; }
        public Article(){}
    }
    // Code for Pagination
    private Integer size;
    private Integer pageNumber;
    private Integer pageSize;
    private Integer totalPageNumber;
    private List<Article> pageArticleList;
    
    public Integer getSize() {
        if(null != pageArticleList)
            return pageArticleList.size();
        return -1;
    }      
    public List<Article> getPageArticleList() {
        return pageArticleList;
    }
    public Integer getPageNumber()
    {
        return pageNumber; 
    }
    public Integer getPageSize()
    {
        return pageSize;
    }
    public Boolean getPreviousButtonEnabled()
    {
        return !(pageNumber > 1);
    }
    public Boolean getNextButtonDisabled()
    {
    if (ArticleList == null) return true;
    else
        return ((pageNumber * pageSize) >= ArticleList.size());
    }
    
    public Integer getTotalPageNumber()
    {
        if (totalPageNumber == 0 && ArticleList != null)
        {
            totalPageNumber = ArticleList.size() / pageSize;
            Integer mod = ArticleList.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;
        }
        return totalPageNumber;
    }
    
    public PageReference nextBtnClick() {
        BindData(pageNumber + 1);
        return null;
    }
    public PageReference previousBtnClick() {
        BindData(pageNumber - 1);
        return null;
    }
    
    public void BindData(Integer newPageIndex)
    {
        System.debug('<<<<<<<<<< In Bind Data >>>>>>>>>>');        
      
        try
        {
            
            pageArticleList = new List<Article>();
            Transient Integer counter = 0;
            Transient Integer min = 0;
            Transient Integer max = 0;
            if (newPageIndex > pageNumber)
            {
                min = pageNumber * pageSize;
                max = newPageIndex * pageSize;
            }
            else
            {
                max = newPageIndex * pageSize;
                min = max - pageSize;
                
            }
            
            for(Article a : ArticleList)
            {
                counter++;
                if (counter > min && counter <= max) 
                    pageArticleList.add(a);
            }            
            pageNumber = newPageIndex;
            if (pageArticleList == null || pageArticleList.size() <= 0)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
        }
        catch(Exception ex)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }
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