public class btbb_selfservicecontroller {
    GlobalComponent gc = new GlobalComponent();
    public List<CategoryNode> catNodeList;
    List<User> u;
    public Integer testClass = 0;    
    public String category;
    public String searchText{ set; get; }
    public string corelicense{get;set;}
    
    public void setCategory(String category) {
        this.category = category;
    }
    public String getCategory() {
        return category;
    }
  
  public PageReference SearchArticle() {
    
     PageReference pageRedirect = new PageReference('/apex/btbb_articlesearch');
     pageRedirect.getParameters().put('searchText', searchText);
     pageRedirect.getParameters().put('viewall', category);
     pageRedirect.setRedirect(true);
     return pageRedirect;       
  }  
  public btbb_selfservicecontroller() {
    searchText = 'Search Knowledge Base';
    catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            FROM CategoryNode WHERE MasterLabel != 'Process/Procedure'
                                            ORDER BY MasterLabel ASC];
                                            
    u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);
   System.debug('u >>>>> 111' +u);
   //Update by Shirish On 08/June/2011 for Implementing default product in what new section
   if(null != u && u.size() > 0){
        System.debug('u >>>>>' +u);
        String defaultCategory = u[0].BTBB_KB_Default_Prod__c;
        System.debug('defaultCategory >>>>>' +defaultCategory);
        if(defaultCategory != null)
            for(CategoryNode catNode : catNodeList) {
                
                if(catNode.ParentId == null && defaultCategory == catNode.MasterLabel) {
                    category = catNode.Id;
                    break;
                }
            } 
        System.debug('category >>>>>' +defaultCategory);                                   
    } 
    
  }
   public boolean isTransactUser {
    
    get {
      User curUser=[SELECT Id, ContactId FROM User where Id = :userInfo.getUserId()];
      if(curUser != null) {
        
        List<Contact_Role__c> contRoleList = [Select c.Role__c, c.Id, c.Contact__c, c.Contact_Role_Email__c From Contact_Role__c c  where contact__c = :curUser.ContactId AND Contact__c!= NULL];
        if(contRoleList != null && contRoleList.size() > 0 && contRoleList[0].Role__c.Contains('Transact'))
          isTransactUser = true;
         else 
           isTransactUser = false;        
      }
      System.debug('isTransactUser >>>>>>>>>' +isTransactUser);
      return isTransactUser;
    }
    set { 
            if(value != null) isTransactUser = value;
        }       
      
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
     
    
     public  List<BtBb_Link__c>  getbtbbServicelinks()
     {
        
         
         List<BtBb_Link__c>  btbbServicelinks=new List<BtBb_Link__c>(); 
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
         authcookie.loadcookie();
         if(authcookie.product != null && authcookie.product!='')
         {
            corelicense=authcookie.product;
         }
    
     btbbServicelinks=[Select id,NAME,LINK_NAME__C,URL__C,WIDGET__C,CORE_LICENSE__C,ISAUTH__C,ISUNAUTH__C,ORDER__C, target__c, DESCRIPTION__C,ELEMENTID__C from BtBb_Link__c 
                        where WIDGET__C='Self Service' and CORE_LICENSE__C=:corelicense and ISAUTH__C = true order by ORDER__C asc];                   
        
        return btbbServicelinks;                
     } 
    
    static testMethod void selfServiceTest() { 
    
        btbb_selfservicecontroller selfService = new btbb_selfservicecontroller();
        selfService.SearchText = 'Test';
        selfService.category = 'ANGEL';
        selfService.setCategory('ANGEL');
        selfService.getCategory();
        selfService.u = new List<User>();
        selfService.SearchArticle();
        selfService.isTransactUser = False;
        selfService.testClass = 1;
        selfService.Redirect();
        Boolean test = selfService.isTransactUser;
        
    }
    
            
}