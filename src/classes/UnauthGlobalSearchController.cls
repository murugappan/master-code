/*  
    Author : Mac Anderson
    Date : July 18th 2011
    Purpose : Created for Searching the Public Knowledge Base
*/

public class UnauthGlobalSearchController {
    
    public String searchText{ set; get; }
    
    public PageReference SearchArticle() {
        
         PageReference pageRedirect = new PageReference('/apex/publickbsearch');
         pageRedirect.getParameters().put('searchText', searchText);
         btbbCookieClass.UnAuthCookie authcookie= new btbbCookieClass.UnAuthCookie();
         authcookie.loadcookie();
          if(authcookie.product != null && authcookie.product!='')
         {
             pageRedirect.getParameters().put('viewall',authcookie.product);
         }
         pageRedirect.setRedirect(true);
         return pageRedirect;       
    }
    
    public String getUserContactId() {
        User u = [SELECT contactid from User where id = :userInfo.getUserId()];
        return u.contactid;
    }
    
    public String getMyId() {
        User u = [SELECT id from User where id = :userInfo.getUserId()];
        return u.id;
    }
    
    public UnauthGlobalSearchController() {
        searchText = 'Search Knowledge Base';

    }
    
    static testMethod void UnAuthorizedGlobalSearchControllerTest() {
     
         
         UnauthGlobalSearchController unAuthglobalSearch = new UnauthGlobalSearchController();
         
         unAuthglobalSearch.searchText = 'Test';
         unAuthglobalSearch.SearchArticle();
         unAuthglobalSearch.getUserContactId();
         unAuthglobalSearch.getMyId();       
     
     }
   
}