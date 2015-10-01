public class LoginsucessController{
 
 public PageReference logout() {
        
        PageReference pageRedirect = new PageReference('/secur/logout.jsp');
        pageRedirect.setRedirect(true);
        return pageRedirect;        
        
    }
}