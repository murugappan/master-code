public class btbb_xythosselfservicecontroller {
    GlobalComponent gc = new GlobalComponent();   
    public String searchText{ set; get; }
    public Boolean isXythosOnly { get; set;}
    GlobalComponent globalObj;
    public PageReference SearchArticle() {
    
     PageReference pageRedirect = new PageReference('/apex/btbb_articlesearch');
     pageRedirect.getParameters().put('searchText', searchText);
     pageRedirect.getParameters().put('viewall', globalObj.defaultProduct());
         pageRedirect.setRedirect(true);
         return pageRedirect;       
  }  
  public btbb_xythosselfservicecontroller() {
   globalObj = new GlobalComponent();
   isXythosOnly = globalObj.isXythosOnly();
    searchText = 'Search Knowledge Base';
    //System.debug('isTransactUser >>>>>>>>> 1' +isTransactUser);
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
  
    public PageReference redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
        return null;
        }
    }
    
    static testMethod void selfServiceTest() { 
    
    profile p = [select id,Name from profile where name='BTBB PROFILE'];
    user u = [select id, Name,profileId from user where profileId = :p.id limit 1];
   
   
    system.Runas(u)
       {
        btbb_xythosselfservicecontroller selfService = new btbb_xythosselfservicecontroller();
        selfService.SearchText = 'Test';
        selfService.SearchArticle();
        selfService.isTransactUser = False;
        selfService.Redirect();
        Boolean test = selfService.isTransactUser;
      }  
    }

}