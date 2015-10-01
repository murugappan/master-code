public without sharing class ChangeEmailController 
{
    GlobalComponent gc = new GlobalComponent();
    public string CEmail{get;set;}
    public boolean isTransactonly {get;set;}
    public boolean isContactRoleError {get;set;}
    
    public PageReference changeEmail()
    {
            User u=[Select Id, Username, Email from User where id=:userinfo.getUserId()];
            u.email=CEmail;
            try{
            update u;
            PageReference redirectPage = new PageReference('/btbb_myprofile?id='+userInfo.getUserId());
            redirectPage.setRedirect(true);
            return redirectPage;
            }
            catch (System.DmlException e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'');
            ApexPages.addMessage(myMsg);
            return null;
            }
           
    }
    
    public PageReference Cancel()
    {
            PageReference redirectPage = new PageReference('/btbb_myprofile?id='+userInfo.getUserId());
            redirectPage.setRedirect(true);
            return redirectPage;
    } 
    
    public ChangeEmailController() 
    {
    
    }
    
    
    public PageReference Redirect() 
    {
       if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
        else  
        return null;
        
    }

}