/*  Author : Shirish Barsainya
    Created On : 8-June-2011
    Purpose : created for redirecing it into search article with search text value.
    
    Modified By : Mac Anderson
    Date : July 5th 2011
    Purpose : Transact Permissions for the Dropdown Link
*/

public class GlobalSearchController {
    
    public List<CategoryNode> catNodeList;
    
    public String searchText{ set; get; }
    User curUser;
    public Boolean isXythosOnly { get; set;}
    public Boolean isTransactUser { get; set;}    
    
    GlobalComponent globalObj;
   
    
    public PageReference SearchArticle() {
    //Update by Shirish On 08/June/2011 for Implementing default product in what new section
        //u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);
        
         PageReference pageRedirect = new PageReference('/apex/btbb_articlesearch');
         pageRedirect.getParameters().put('searchText', searchText);
         btbbCookieClass.AauthCookie authcookie= new btbbCookieClass.AauthCookie();
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
    
    public GlobalSearchController() {
        globalObj = new GlobalComponent();
        isXythosOnly = globalObj.isXythosOnly();
        isTransactUser = globalObj.isTransactUser();
        searchText = 'Search Knowledge Base';
        //Added on 7th Oct to implement default product functionality        
        
    }
    
   /* public boolean isTransactUser {
        
        get {
            User curUser=[SELECT Id, ContactId FROM User where Id = :userInfo.getUserId()];
            if(curUser != null) {
                Integer flag = 0;                
                for(Contact_Role__c contRole : [Select c.Role__c, c.Id, c.Contact__c, c.Contact_Role_Email__c From Contact_Role__c c  where contact__c = :curUser.ContactId]) {
                    System.debug('In Global Search contRole >>>>>>>>>' +contRole);
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('Transact') || contRole.Role__c.Contains('TRANSACT'))) {
                        isTransactUser = true;
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0)
                    isTransactUser = false;             
            }
            System.debug('isTransactUser >>>>>>>>>' +isTransactUser);
            return isTransactUser;
        }
        set { 
            if(value != null) isTransactUser = value;
        }       
            
    }*/

    public PageReference logout() {
        
        string transactURL=System.Label.TransactPortalURL;
        PageReference pageRedirect = new PageReference(transactURL+'/s/Logout.aspx');
        //PageReference pageRedirect = new PageReference('/secur/logout.jsp');
        pageRedirect.setRedirect(true);
        return pageRedirect;        
        
    }
    
     static testMethod void GlobalSearchControllerTest() {
     
         
         GlobalSearchController globalSearch = new GlobalSearchController();
         
         globalSearch.searchText = 'Test';
         globalSearch.SearchArticle();
         globalSearch.getUserContactId();
         globalSearch.getMyId();
         globalSearch.isTransactUser = true;
         globalSearch.isTransactUser = false;
         Boolean test = globalSearch.isTransactUser;
         globalSearch.logout();
     
     }
}