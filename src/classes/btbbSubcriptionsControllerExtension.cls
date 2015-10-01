public class btbbSubcriptionsControllerExtension {
    GlobalComponent gc = new GlobalComponent();
    public List<RecordType> recordTypeList;
    public String ArticleCategory {get;set;}
    private List<SelectOption> items;
    public String aType {get;set;}
    public List<CategoryNode> catNodeList; 
    public String category {get;set;}
    List<Solution> results;
    private List<Solution> KIArticles;
    private List<Solution> SBSAArticles;
    private List<Solution> PRIArticles;
    private List<Solution> allArticles;
    

    public String getUserContactId() {
        User u = [SELECT contactid from User where id = :userInfo.getUserId()];
        return u.contactid;
    }
    
    public String getUserId() {
        return userInfo.getUserId();
    }
    
    public pageReference SelectCategory(){
        return null;
    }
    
    public List<SelectOption> getCategories() {
        
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('','All Products'));
        for(CategoryNode catNode : catNodeList) {
            
            if(catNode.ParentId == null){
            if(catNode.MasterLabel != 'Mobile')
            {
                    options.add(new SelectOption(catNode.Id,catNode.MasterLabel));                       
                    }
                    }
        } 
        return options;
    }
            
    public List<CategoryNode> getArticleCategories() {    
    
        return [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
            FROM CategoryNode
            WHERE ParentId != Null
            ORDER BY MasterLabel DESC];
            
    }
    
    public btbbSubcriptionsControllerExtension(ApexPages.StandardController controller) {
                            catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                          FROM CategoryNode WHERE MasterLabel != 'Process/Procedure'
                                          ORDER BY MasterLabel ASC];
    }

   
    
     
    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
            return null;
        }
    }
    
   

}