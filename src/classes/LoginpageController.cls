public with sharing class LoginpageController
{
    public String username{get;set;}
    public String cemail{get;set;}
    public String password{get;set;}
    public string errormessage{get;set;}
    public string userprofile{get;set;}
    public string targetURL{get;set;}
    public string returnURL{get;set;}
    GlobalComponent gc = new GlobalComponent();
    
    public LoginpageController() 
    {
        userprofile=UserInfo.getprofileId();
        
               
        targetURL=apexpages.currentpage().getParameters().get('TARGET');
        if(targetURL != null)
        {
            if((targetURL.containsignorecase('bbbb.net')||targetURL.containsignorecase('blackboard.com'))&& !targetURL.containsignorecase('/canvas'))
            {
                returnURl='/canvaspage?TARGET='+targetURL;
            }
            else
            {
                returnURL=targetURL;
            }
        }
        else
        {
            	returnURL='default';
        } 
            
    }
    
    public pageReference login() 
    {
        
        PageReference pageref;
        if (cemail!= null) 
        { 
        	list<user> userlist;
           userlist=[Select username,NOV_Preferred_Site__c from User where email=:cemail and email != null];

          if(userlist!=null&&userlist.size()>0) {
            user u=userlist[0];
            if(returnURL=='default')
            {
            	if(u.NOV_Preferred_Site__c == 'Transact')
            	{
            		returnURL='/canvaspage';
            	}
            	else
            	{
            		returnURL='/btbb_home';
            	}
            }
            pageref = Site.login(u.username, password,returnURL);
            }
            else
            {
               pageref=null; 
            }
            if(pageref!= null )
            {
               		pageRef.setRedirect(true);
                	return pageref;
            }
            
            else
            {   
                 ApexPages.Message myMsg=new ApexPages.Message(ApexPages.severity.Info,'Your login attempt has failed. Make sure the username and password are correct.');
                 ApexPages.addmessage(myMsg); 
            }
        }
        return null;
    }

    public pagereference redirect()
    {
        if(gc.userRedirect != true){
            list<user> userlist;
           userlist=[Select username,NOV_Preferred_Site__c from User where id=:UserInfo.getuserid()];

          if(userlist!=null&&userlist.size()>0) {
            user u=userlist[0];
            if(u.NOV_Preferred_Site__c == 'Transact')
                {
                    returnURL='/canvaspage';
                }
                else
                {
                    returnURL='/btbb_home';
                }
            pagereference pageref= new pagereference(returnURL);
            pageref.setredirect(true);
            return pageref;    
            
        } 
    }
    return null;
}
}