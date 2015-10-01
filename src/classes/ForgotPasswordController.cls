/**
 * An apex page controller that exposes the site forgot password functionality
 */
public without sharing class ForgotPasswordController 
{
    public String cemail {get; set;}   
       
    public ForgotPasswordController() {}
  
    public PageReference forgotPassword() 
    {
      BtbbUserEmailLog__c useremail = new BtbbUserEmailLog__c();
      String result;
      
      if(cemail!= null && !cemail.contains('@blackboard.com'))
      {
      try{

            User u=[Select id,username,contact.id,email from User where email=:cemail and email!=null and contactid != null and isactive=true limit 1];
            system.debug('User Fetched' + u);
              
              
            ResetPasswordResult rpr = System.resetPassword(u.id,false);
            result = rpr.getPassword();
            useremail.user__c=u.id;
            useremail.contact__c=u.contact.id;
            useremail.email__c=u.email;
            useremail.Type__c='Recredential';
            useremail.Password__c=result;
            
            insert useremail;
              
            
            if(rpr!=null && rpr.getPassword()!=null)
            {
                PageReference pr = Page.ForgotPasswordConfirm;
            pr.setRedirect(true);
              return pr;
            }
          }
          catch(exception e)
          {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'User account does not exist for the given email');
            ApexPages.addMessage(myMsg);
          }
       }
       else if(cemail!= null && cemail.contains('@blackboard.com'))
       {
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'You have entered an email address indicating you are in internal employee.  Please recall that the Behind the Blackboard email address/login name for internal staff uses the following format:  firstname.lastname@bbbb.net. Please try again, using this format in the email address prompt.  If you continue to have difficulty logging in or resetting your password, please contact us by using this<a href="/loginissue" style="color:blue">webform</a>. ');
            ApexPages.addMessage(myMsg);
       }
       else
       {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Invalid Username');
          ApexPages.addMessage(myMsg);
       }
      return null;
    
    }
      
    
}