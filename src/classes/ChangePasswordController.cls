/**
 * An apex page controller that exposes the change password functionality
 */
public with sharing class ChangePasswordController 
{
	GlobalComponent gc = new GlobalComponent();
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;} 
    public String psw {get;set;}
    public String vpsw {get;set;}
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; }
   	public boolean isTransactonly {get;set;}
    public boolean isContactRoleError {get;set;} 
       
    public PageReference changePassword()
    {
    		
 			errorShow = false;
        	
        	if(!Pattern.matches('(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\\d]){1,})(?=(.*[\\W\\_]){1,})(?!.*\\s).{8,20}$',newPassword))
            {
            	errorShow = true;
                errorTitle = 'Error:';
                errorMessage = 'Password does not meet the criteria';
                errorSeverity = 'error';
                return null;
             
            }
        	else if (newPassword != verifyNewPassword)
	        {
	        		
	            	errorShow = true;
	                errorTitle = 'Error:';
	                errorMessage = 'Confirm Password does not match with New Password';
	                errorSeverity = 'error';
	                return null;
            } 
            else
           	{
                return Site.changePassword(newPassword.trim(), verifyNewPassword.trim(), oldpassword.trim());
            } 
            
	} 
	
	 public PageReference Cancel()
    {
            string returl=ApexPages.currentpage().getParameters().get('retURL');
            if(retURL != null && retURL !='')
            {
                retURL=RetURL;
            }
            else
            {
                retURL='/btbb_home';
            }
    		PageReference redirectPage = new PageReference(retURL);
        	redirectPage.setRedirect(true);
        	return redirectPage;
	} 
    
    public boolean getisCancelVisible()
    {
         string returl=ApexPages.currentpage().getParameters().get('retURL');
         if(retURL != null && retURL != '')
         {
            return true;
         }
         else
         {
            return false;
         }
    }

   	public ChangePasswordController() 
   	{
   	
   	}
   	
   	 public PageReference Redirect() {
       
       
       
       if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }
        
        else if(isTransactonly == true) {
            PageReference TransactRedirect = new PageReference('/canvaspage');
            TransactRedirect.setRedirect(true);
            return TransactRedirect;
            }
        
        else if(isContactRoleError==true)
        {
          Pagereference Collabredirect = Page.login_success;
          Collabredirect.setredirect(true);
          return Collabredirect;
        }
        
        else  
        return null;
        
    }
   
    
}